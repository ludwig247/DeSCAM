import global_pack_sv::*;

module i2c_master_sv #(
        parameter en_master_p = 1,    // parameter that enables master behavior implementation TODO change to param
        parameter en_slvdly_p = 0,     // parameter that enables slave behavior on tbe
        parameter en_i2cenbit_p = 0,  // parameter that enables Bit I2CEn in modereg
        parameter en_i2c10bit_p = 0    // parameter that enables I2C 10bit addressing mode

    )
    (
        input  datavec_t  reg_wrdata_i,               // IP data bus 
        input  logic  wrstrobe_sfr_i,                                    // write strobe, line has to be high if we want to write to registers
        input  logic  rdstrobe_sfr_i,                                    // read strobe, line has to be high if we want to read registers
        input  logic  addr_cfg_reg_i,                             // write/read control register joined with BDR, line has to be high if we want to write/read control register
        input  logic  addr_datain_reg_i,                             // write/read datain register, line has to be high if we want to write/read dataio register
        input  logic  addr_dataout_reg_i,                             // write/read dataout register, line has to be high if we want to write/read dataio register
        input  logic  addr_status_reg_i,                             // read status register, this register is read only, and it's content is set by IP
//        input  logic  addr_mode_reg_i,                             // write/read mode register, line has to be high if we want to write/read mode register. register is used for 10 bit addressing
//        input  logic  addr_addr_reg_i,                             // write/read control register, line has to be high if we want to write/read control register, default address is 0x6C
//        input  logic  addr_bdr_reg_i,                              // write/read bdr register, line has to be high if we want to write/read to bdr register.        
        input  logic  en_i2c_i,                                        // i2c_en_i  port is used only if parameter en_i2cenbit_p is 0                         

// TODO comment ports
        output  datavec_byte_t   sfr_i2c_datain_o,                           // SFR datain register
        output  datavec_byte_t   sfr_i2c_dataout_o,                           // SFR datain register
        output  datavec_byte_t   sfr_i2c_status_o,                          // SFR status register
        output  datavec_t   sfr_i2c_cfg_o,                           // SFR mode register, used for 10bit addressing
//        output  datavec_byte_t  sfr_i2c_control_s,                          // SFR control register
//        output  datavec_t   sfr_i2c_address_o,                       // SFR address register also used for 10bit addressing, default address is 0x6C
//        output  datavec_byte_t   sfr_i2c_baudrate_s,                     // SFR baudrate register

        input logic   sda_level_i,                                                       // SDA current line level
        input logic   sda_rising_i,                                                     // SDA line is rising
        input logic   sda_falling_i,                                                    // SDA line is falling
        
        output logic sda_enable_o,                                                // enable tri state buffer and pull low SDA line

        input logic   scl_level_i,                                                       // SCL current line level
        input logic   scl_rising_i,                                                       // SCL line is rising
        input logic   scl_falling_i,                                                       // SCL line is falling

        output logic scl_enable_o,                                                // enable tri state buffer and pull low SCL line

        output logic int_o,                                                          // interrupt flag for CPU

        input logic clk_i,                                                            // system clock signal
        input logic reset_n_i,                                                         // system reset signal 
        
        //////////////////////////////////////////////////////////////////////////
        ////////////////// Test controller ports ////////////////////////
        ////////////////////////////////////////////////////////////////////////

        input datavec_byte_t sfr_tcr_i,
        input logic tc_status_i,
        input logic tc_lock_mode_i,
        input logic read_tcr_via_i2c_i,
        output logic i2c_rbf_tc_o,
        output logic i2c_rw_tc_o,
        output logic i2c_tbf_tc_o,
        output logic i2c_addr_tc_o,
        output logic tc_pwd_ok_o   

    );

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // FSM states
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    typedef enum logic [4: 0] {
        idle_e,                                                   // idle state (do nothing)
        slv_receive_address_e,                     // receive address
        slv_send_address_ack_e,                 // send acknowledge on received address
        slv_receive_10bit_address_e,          // receive address (10-bit mode)
        slv_send_10bit_address_ack_e,      // send acknowledge (10-bit mode)
        slv_receive_data_e,                            // receive data
        slv_send_data_ack_e,                          // send acknowledge
        slv_delay_scl_lowphase_e,               // delay scl-high phase (setup time)
        slv_transmit_data_e,                        // transmit data
        slv_receive_data_ack_e,                  // receive acknowledge
        mst_send_restartbit_e,                    // send restart bit (master mode)
        mst_send_startbit_p1_e,                 // send start bit (master mode)
        mst_send_startbit_p2_e,                 //   phase 2 (SCL high phase)
        mst_transmit_address_p1_e,          // send slave's address
        mst_transmit_address_p2_e,          //   phase 2 (SCL high phase)
        mst_receive_data_p1_e,                 // receive data (master mode)
        mst_receive_data_p2_e,                 //   phase 2 (SCL high phase)
        mst_waiton_ack_enable_e,             // wait for acknowledge enable bit
        mst_transmit_data_ack_p1_e,       // send acknowledge (master mode)
        mst_transmit_data_ack_p2_e,       //  phase 2 (SCL high phase)
        mst_transmit_data_p1_e,              // transmit data (master mode)
        mst_transmit_data_p2_e,              //   phase 2 (SCL high phase)
        mst_receive_data_ack_p1_e,        // receive acknowledge (master mode)
        mst_receive_data_ack_p2_e,        //   phase 2 (SCL high phase)
        mst_send_stopbit_p1_e,              // send stop bit (master mode)
        mst_send_stopbit_p2_e               // phase 2 (SCL high phase)

    }  i2c_transfer_t;
   
    parameter   address_reg_low =  0;
    parameter   address_reg_high = 7;
    parameter   mode_reg_low = 8;
    parameter   mode_reg_high = 15;
    parameter   baud_rate_reg_low = 8;
    parameter   baud_rate_reg_high = 15;
    parameter   control_reg_low = 0;
    parameter   control_reg_high = 7;

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // status bits                                                                                                                                                     (master & slave mode)
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    parameter   i2c_status_rbf_p = 0;                                         // receive buffer full
    parameter   i2c_status_tbf_p = 1;                                         // transmit buffer full
    parameter   i2c_status_rack_p = 2;                                      // received acknowledge level
    parameter   i2c_status_rw_p = 3;                                         // read (1) or write (0) transfer
    parameter   i2c_status_s_p = 4;                                           // I2C transfer active (master / slave)
    // I2C-stop-bit-detected (slave only)
    parameter   i2c_status_ov_p = 5;                                        // buffer overflow detected
    parameter   i2c_status_cd_p = 6;                                       // bus collision detected
    parameter   i2c_status_sla_p = 7;                                      // I2C slave addressed

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // mode bits                                                                                                                                                         (master & slave mode)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    parameter   i2c_mode_tba_p = 10;                                       // ten-bit-address mode (7-bit)
    parameter   i2c_mode_a8_p = 8;                                        // ten bit address mode - bit:8
    parameter   i2c_mode_a9_p = 9;                                        // ten bit address mode - bit:9
    parameter   i2c_mode_bit3_p = 11;                                     // n.u.
    parameter   i2c_mode_bit4_p = 12;                                     // n.u.
    parameter   i2c_mode_bit5_p = 13;                                     // n.u.
    parameter   i2c_mode_bit6_p = 14;                                     // n.u.
    parameter   i2c_mode_bit7_p = 15;                                     // n.u.
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // control bits                                                                                                                                                           (master mode only)
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    parameter  i2c_control_sen_p = 0;
    parameter  i2c_control_rsen_p = 1;
    parameter  i2c_control_pen_p = 2;
    parameter  i2c_control_acken_p = 3;
    parameter  i2c_control_ackdt_p = 4;
    parameter  i2c_control_inp_p = 5;
    parameter  i2c_control_gcen_p = 6;
    parameter  i2c_control_i2cen_p = 7;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Reset Active level
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    parameter  reset_active_p = 1'b0;
    parameter  reset_allff_p = 1'b1;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // I2C registers
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     datavec_byte_t reg_i2cdatain_s;                                                                      // input buffer
     datavec_byte_t reg_i2cdataout_s;                                                                    // out
     datavec_byte_t reg_i2cstatus_s;                                                                      // status register
     datavec_t reg_i2ccfg_s;                                                                                      // configuration register
//     datavec_t reg_i2c_address_s;                                                                                      // configuration register
     datavec_byte_t reg_i2cshift_s;                                                                       // shift register

    logic [15:0] reg_i2ccontrol_baudrate_s;                                                 // allows one command setup

    logic [15:0] reg_i2cfulladdress_s;                                                           // allows 10-bit address in one command

    logic prior_addrmatch_s;                                                                     //prior addr matched (10-bit mode)
    logic sda_bitbuffer_s;                                                                          // bit buffer for captured SDA during tx.addr


    // shift register bit counter and baudrate generator (+1 LSBit + MSOVBit)
    //TODO this will maybe be changed, to (+2MSB), because this change could improve I2C speed
    // TODO add _s
    logic [3:0] bit_counter_s;
    logic [9:0] bdr_counter_s;

    logic en_i2c_s;                                                                                      // i2c enable

    logic scl_pull_low_s;                                                                              // pull SCL to '0'
    logic sda_pull_low_s;                                                                            // pull SDA to '0'

    //logics

    logic clr_bitcounter_s;                                                                       // clear bit counter
    logic store_data_s;                                                                           // store received I2C data
    logic store_address_s;                                                                     // store received address
    logic store_slv_rnw_s;                                                                      // store received bit RnW (slave)
    logic store_mst_rnw_s;                                                                    // store transmitted bit RnW (master)
    logic slave_addressed_s;                                                                 // I2C addressed as slave
    logic slave_i2c_srq_s;                                                                      // slave I2C service request
    logic slave_i2c_irq_s;                                                                       // slave I2C service interrupt
    logic master_i2c_srq_s;                                                                  //  master I2C service request
    logic master_i2c_irq_s;                                                                   //  master I2C service interrupt
    logic shiftin_i2cdata_s;                                                                      // shift in arrived I2C data
    logic shiftin_i2cack_s;                                                                       // I2C acknowledge available on sda_level_i
    logic shiftin_i2cbb_s;                                                                         // shift in arrived I2C data into bit - buffer
    logic shiftout_i2cdata_s;                                                                  // shift out I2C data
    logic shiftreg_full_s;                                                                         // shift_register_full
    logic shiftreg_lsb_s;                                                                         // shift register filled with first bit
    logic shiftedout_data_s;                                                                  // data shifter out transfer
    logic address_match_s;                                                                  // received address matches with I2C address
    logic addr10lsb_match_s;                                                               // received LSBit (10-bit mode) matches
    logic addr10pre_match_s;                                                              // received Preamble (10-bit mode) matches
    logic addr10msb_match_s;                                                            // received MSBits (10-bit mode) matches
    logic addr_gc_match_s;                                                                 // received general call address
    logic set_addrmatch_s;                                                                 // prior address matches (10-bit mode)
    logic received_rnw_s;                                                                    // received read - not write
    logic load_shiftreg_s;                                                                    // load shift register from reg_datao
    logic clr_stopbit_s;                                                                        // clear stop-condition bit
    logic clr_startbit_s;                                                                       // clear start-condition bit
    logic clr_restartbit_s;                                                                    // clear restart-condition bit
    logic i2c10bit_mode_s;                                                                // 10-bit address mode activated
    logic buscoll_detected_s;                                                             // bus collision detected (arbitration)
    logic i2c_ack_s;                                                                            // received acknowledge state
    logic i2c_rnw_s;                                                                            // transmitted RnW bir
    logic i2c_inp_s;                                                                             // interrupt/not polling handling
    logic interrupt_flag_s;                                                                  // interrupt flag (I2C internal flag)

    logic start_detected_s;                                                                 // start condition detected
    logic stop_detected_s;                                                                 // stop condition detected
    logic start_transfer_s;                                                                  // start master transfer action
    logic restart_transfer_s;                                                               // restart master transfer action
    logic stop_transfer_s;                                                                   // stop transfer master action
    logic tx_buffer_full_s;                                                                     // transmit buffer full
    logic buffer_corrupted_s;                                                             // buffer corrupted: receive buffer overflow or transmit buffer write collision
    logic ackdata_level_s;                                                                  // data acknowledge level (master)
    logic shiftout_ack_s;                                                                    // enable acknowledge output on SDA (master)

    logic start_bdr_counter_s;                                                           //starts baudrate-generator
    logic stop_bdr_counter_s;                                                           //stops baudrate-generator

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // CPU - I2C interface access signals
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // control reg
    logic addr_cfg_reg_s;
    logic wr_cfg_reg_s;
    logic rd_cfg_reg_s;

    // datain reg
    logic addr_datain_reg_s;
    logic wr_datain_reg_s;
    logic rd_datain_reg_s;

    logic addr_dataout_reg_s;
    logic wr_dataout_reg_s;
    logic rd_dataout_reg_s;


    // status reg
    logic addr_status_reg_s;
    logic wr_status_reg_s;
    logic rd_status_reg_s;

//    // mode reg
//    logic addr_mode_reg_s;
//    logic wr_mode_reg_s;
//    logic rd_mode_reg_s;
//
//    // addr reg
    logic addr_addr_reg_s;
    logic wr_addr_reg_s;
    logic rd_addr_reg_s;
//
//    // bdr reg
//    logic addr_bdr_reg_s;
//    logic wr_bdr_reg_s;
//    logic rd_bdr_reg_s;

    i2c_transfer_t next_transfer_state_s;
    i2c_transfer_t transfer_state_s;

    // Delay logic
    logic scl_out_ff_s;
    logic sda_out_ff_s;
    logic scl_pull_low_dly_1_s;
    logic scl_pull_low_dly_2_s;
    logic scl_pull_low_dly_3_s;

    // Merge 8 bit outputs to 32bit  output signals
    
    datavec_byte_t   sfr_i2c_control_s;
    datavec_t   sfr_i2c_address_s;                      
    datavec_byte_t   sfr_i2c_baudrate_s; 
    datavec_byte_t   sfr_i2c_mode_s; 
    datavec_t   sfr_i2c_cfg_s;
    
    // test controller logic
    datavec_byte_t sfr_tcr_s;
    datavec_byte_t lsb_pwd_s = 8'hB2;
    datavec_byte_t msb_pwd_s = 8'hA3;
        
    logic lsb_pwd_ok_s;
    logic msb_pwd_ok_s;
    logic tc_status_s;
    logic read_tcr_via_i2c_s;
    logic i2c_rbf_tc_s;
    logic i2c_rbf_tc_ff_s;
    logic i2c_rw_tc_s;
    logic i2c_tbf_tc_s;
    logic i2c_tbf_tc_ff_s;
    logic stop_detected_ff_s;
    logic i2c_addr_tc_comb_s;
    logic tc_pwd_ok_s;     
    logic first_try_s;
    logic i2c_addr_tc_comb_s_fall_edge_s;
    logic i2c_addr_tc_ff_s;
    logic locked_s;
    logic pwd_check_s; 
    
always_ff @(posedge clk_i, negedge reset_n_i)
    begin
        if (reset_n_i == reset_active_p)
            i2c_addr_tc_ff_s <= 1'b0;
        else 
            i2c_addr_tc_ff_s <= i2c_addr_tc_comb_s;
      end


always_ff @(posedge clk_i, negedge reset_n_i)
    begin 
        if (reset_n_i == reset_active_p)
            first_try_s <= 1'b1;
        else 
            if (i2c_addr_tc_comb_s_fall_edge_s)
                first_try_s <= 1'b0;
    end
//
//always_comb 
//    begin
//       i2c_rbf_tc_s = reg_i2cstatus_s[i2c_status_rbf_p] & stop_detected_s;
//       i2c_rw_tc_s = reg_i2cstatus_s[i2c_status_rw_p];
//       i2c_tbf_tc_s = reg_i2cstatus_s[i2c_status_tbf_p];
//    end


always_ff @(posedge clk_i, negedge reset_n_i)
    begin
        if (reset_n_i == reset_active_p)
            i2c_rbf_tc_ff_s <= 1'b0;
        else
            i2c_rbf_tc_ff_s <= i2c_rbf_tc_s & stop_detected_s;
    end


//always_ff @(posedge clk_i, negedge reset_n_i)
//    begin
//        if (reset_n_i == reset_active_p)
//            i2c_tbf_tc_ff_s <= 1'b0;
//        else
//            i2c_tbf_tc_ff_s <= i2c_tbf_tc_s;
//    end

always_ff @(posedge clk_i, negedge reset_n_i)
    begin
        if (reset_n_i == reset_active_p)
            lsb_pwd_ok_s <= 1'b0;
        else
        begin
           if ((reg_i2cdatain_s == lsb_pwd_s) & first_try_s & i2c_addr_tc_comb_s & msb_pwd_ok_s)
                    lsb_pwd_ok_s <= 1'b1;
        end   
   
    end
 
 always_ff@(posedge clk_i, negedge reset_n_i)
    begin
        if (reset_n_i == reset_active_p)
            msb_pwd_ok_s <= 1'b0;
        else
        begin
           if ((reg_i2cdatain_s == msb_pwd_s) & first_try_s & i2c_addr_tc_comb_s)
                    msb_pwd_ok_s <= 1'b1;
        end      
    end

        
    

always_comb 
    begin
        sfr_tcr_s = sfr_tcr_i;
        tc_status_s = tc_status_i;
        locked_s = tc_lock_mode_i;
        read_tcr_via_i2c_s = read_tcr_via_i2c_i;
        i2c_tbf_tc_o = i2c_tbf_tc_s;
        i2c_addr_tc_comb_s_fall_edge_s = i2c_addr_tc_ff_s & (~i2c_addr_tc_comb_s);
        tc_pwd_ok_o = tc_pwd_ok_s;
        pwd_check_s = i2c_addr_tc_comb_s & first_try_s;
    end

always_ff @(posedge clk_i, negedge reset_n_i) begin
    if (reset_n_i == reset_active_p) begin
        i2c_rw_tc_o <= 1'b0;
    end
    else begin
        i2c_rw_tc_o <= i2c_rw_tc_s;
    end
end

    always_ff @(posedge clk_i, negedge reset_n_i) begin
        if (reset_n_i == reset_active_p)
            tc_pwd_ok_s = 1'b0;
        else
             if (first_try_s & stop_detected_s)
                    tc_pwd_ok_s = msb_pwd_ok_s & lsb_pwd_ok_s;
        end

    always_comb
    begin
        // generate register enable signals

      //  addr_control_reg_s = addr_control_reg_i;
        addr_datain_reg_s = addr_datain_reg_i && (~tc_status_s);
        addr_dataout_reg_s = addr_dataout_reg_i && (~tc_status_s);
        addr_status_reg_s = addr_status_reg_i && (~tc_status_s);
        addr_cfg_reg_s = addr_cfg_reg_i && (~tc_status_s);
//        addr_addr_reg_s = addr_addr_reg_i && (~tc_status_s);
//        addr_bdr_reg_s = addr_bdr_reg_i;

        // generate register write and register read signals

        wr_cfg_reg_s = addr_cfg_reg_s && wrstrobe_sfr_i && (~tc_status_s);
        wr_dataout_reg_s = (addr_dataout_reg_s &&  wrstrobe_sfr_i && (~tc_status_s)) || (tc_status_s && read_tcr_via_i2c_s);
        wr_status_reg_s = addr_status_reg_s && wrstrobe_sfr_i && (~tc_status_s);
//        wr_mode_reg_s = addr_mode_reg_s && wrstrobe_sfr_i && (~tc_status_s);
//        wr_addr_reg_s = addr_addr_reg_s && wrstrobe_sfr_i && (~tc_status_s);
//        wr_bdr_reg_s = addr_bdr_reg_s && wrstrobe_sfr_i && (~tc_status_s);
//        //TODO == when always_comb
        rd_cfg_reg_s = addr_cfg_reg_s && rdstrobe_sfr_i && (~tc_status_s);
        rd_datain_reg_s = addr_datain_reg_s &&  rdstrobe_sfr_i && (~tc_status_s);
        rd_status_reg_s = addr_status_reg_s && rdstrobe_sfr_i && (~tc_status_s);
//        rd_mode_reg_s = addr_mode_reg_s && rdstrobe_sfr_i && (~tc_status_s);
//        rd_addr_reg_s = addr_addr_reg_s && rdstrobe_sfr_i && (~tc_status_s);
//        rd_bdr_reg_s = addr_bdr_reg_s && rdstrobe_sfr_i && (~tc_status_s);
    end

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                 I2C Interface Access FSM (Finite State Machine)
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //state transition

    always_ff @(posedge clk_i, negedge reset_n_i)
    begin:i2c_state_transition
        if (reset_n_i == reset_active_p)
        begin
            transfer_state_s <= idle_e;
        end

        else
        begin
            transfer_state_s <= next_transfer_state_s;
        end
    end:i2c_state_transition

    always_comb
    begin:i2c_control
        next_transfer_state_s = transfer_state_s;
        clr_bitcounter_s = 1'b0;
        store_data_s = 1'b0;
        store_address_s = 1'b0;
        store_slv_rnw_s = 1'b0;                  // store received bit RnW (slave)
        store_mst_rnw_s = 1'b0;                  // store transmitted bit RnW (master)
        slave_addressed_s = 1'b0;                // I2C addressed as slave device
        slave_i2c_srq_s = 1'b0;                  // set slave I2C service request
        slave_i2c_irq_s = 1'b0;                  // set slave I2C interrupt request
        master_i2c_srq_s = 1'b0;                 // set master I2C service request
        master_i2c_irq_s = 1'b0;                 // set master I2C interrupt request
        shiftin_i2cdata_s = 1'b0;                // shift in received I2C databit
        shiftin_i2cbb_s = 1'b0;                  // shift in received I2C databit (while address tx)
        shiftin_i2cack_s  = 1'b0;                // shift in received I2C ack.-bit
        shiftout_i2cdata_s = 1'b0;               // shift out I2C databit (transmit)
        load_shiftreg_s = 1'b0;                  // load up shift register
        clr_stopbit_s = 1'b0;                    // clear stop-condition bit (ctrl)
        clr_startbit_s = 1'b0;                   // clear start-condition bit (ctrl)
        clr_restartbit_s = 1'b0;                 // clear restart-condition bit (ctrl)
        start_bdr_counter_s = 1'b0;              // start baudrate generator
        set_addrmatch_s = 1'b0;                  // prior address matched (11'b0bit mode)
        buscoll_detected_s = 1'b0;               // bus collision det. (arbitration)
        sda_pull_low_s = 1'b0;                   // pull I2C line SDA to low
        scl_pull_low_s = 1'b0;                   // pull I2C line SCL to low

        //TODO === instead ==
        case (transfer_state_s)
            idle_e: begin
                if (start_detected_s == 1'b1 & (~locked_s))
                begin
                    clr_bitcounter_s =1'b1;
                    next_transfer_state_s = slv_receive_address_e;
                end
                if (start_transfer_s == 1'b1 & (~locked_s))
                begin
                    clr_startbit_s = 1'b1;
                    if (scl_level_i == 1'b1)
                    begin
                        if (sda_level_i == 1'b1)
                        begin
                            start_bdr_counter_s = 1'b1;
                            next_transfer_state_s = mst_send_startbit_p1_e;
                        end
                        else
                        begin
                            master_i2c_irq_s = 1'b1;
                            buscoll_detected_s = 1'b1;
                            clr_bitcounter_s = 1'b1;
                            next_transfer_state_s = slv_receive_address_e;
                        end
                    end
                    else
                    begin
                        master_i2c_irq_s = 1'b1;
                        buscoll_detected_s = 1'b1;
                    end
                end
            end
            slv_receive_address_e: begin                                                                                                              //receive address from master
                shiftin_i2cdata_s = scl_rising_i;                                      // read SDA data at rising edge
                if (scl_falling_i == 1'b1 && shiftreg_full_s == 1'b1)                                                   // all bits received?
                begin
                    next_transfer_state_s = idle_e;
                    if (i2c10bit_mode_s == 1'b0)                                                                 // 7-bit address mode
                        begin
                           if (address_match_s == 1'b1)                             // address matches?
                              begin
                                 store_address_s = 1'b1;
                                 store_slv_rnw_s = 1'b1;
                                 slave_i2c_srq_s = 1'b1;                                              //  set service request -> start I2C transfer process
                                 next_transfer_state_s = slv_send_address_ack_e;             // go to send slave address acknowledge state
                                 if ((received_rnw_s == 1'b1) && (tx_buffer_full_s == 1'b0))            // transmit slave data-byte?
                                    slave_i2c_irq_s = 1'b1;                         // set interupt request -> get transmit data, data buffer is empty, and we need data
                                end
                        end
                        else                                                                                // 10-bit address mode
                        begin
                            if ((addr10pre_match_s == 1'b1 ) && (addr10msb_match_s == 1'b1))         // address match
                            begin
                                store_slv_rnw_s = 1'b1;
                                if (received_rnw_s == 1'b0)               // read == 0, write == 1
                                    next_transfer_state_s = slv_send_address_ack_e;  // if read go to send acknowledge state
                                else if (prior_addrmatch_s == 1'b1)           // transmit slave data-byte?
                                   begin
                                       if (tx_buffer_full_s == 1'b0)
                                          slave_i2c_irq_s = 1'b1;          // set interupt request -> get transmit data, data buffer is empty, and we need data
                                       next_transfer_state_s = slv_send_address_ack_e;
                                    end
                            end
                        end
                    if (addr_gc_match_s == 1'b1)                                                              //is this a general call?
                    begin
                        store_address_s = 1'b1;
                        store_slv_rnw_s = 1'b1;
                        slave_i2c_irq_s = 1'b1;
                        slave_i2c_srq_s = 1'b1;
                        next_transfer_state_s = slv_send_address_ack_e;              // if yes send acknowledge
                    end
                end
                if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                        // does anyone else uses I2C bus?
                begin
                    buscoll_detected_s = 1'b1;
                    slave_i2c_irq_s = 1'b1;
                    next_transfer_state_s = idle_e;                                  // if yes, go to idle
                end
            end

            slv_send_address_ack_e: begin
                sda_pull_low_s = 1'b1;                                           //send acknowledge
                if (scl_falling_i == 1'b1)                                      // wait for a falling edge
                 begin
                    if ((i2c10bit_mode_s == 1'b0) || (addr_gc_match_s == 1'b1))                     // is it a 7-bit address mode or general call received
                    begin
                        slave_addressed_s = 1'b1;
                        if (received_rnw_s == 1'b0)                                                      // if write is expected
                        begin
                            clr_bitcounter_s = 1'b1;
                            next_transfer_state_s = slv_receive_data_e;
                        end
                        else
                            begin
                               if (en_slvdly_p == 1)                           // else if read is expected, use slv_delay state while data is not ready, if parameter is
                                                                                            // is set, if not, send whatever you have in transmit buffer, usually 0xFF
                                begin
                                   next_transfer_state_s = slv_delay_scl_lowphase_e;
                                 end
                               else
                                   begin
                                      clr_bitcounter_s = 1'b1;
                                      load_shiftreg_s = 1'b1;
                                      next_transfer_state_s = slv_transmit_data_e;
                                   end
                              end
                       end
                   else 
                    begin
                       if (received_rnw_s == 1'b0)
                           begin
                               clr_bitcounter_s = 1'b1;
                               next_transfer_state_s = slv_receive_10bit_address_e;
                           end
                       else
                           begin
                               slave_addressed_s = 1'b1;
                               if (en_slvdly_p == 1)
                                   begin
                                       next_transfer_state_s = slv_delay_scl_lowphase_e;
                                   end
                               else
                                   begin
                                      clr_bitcounter_s = 1'b1;
                                      load_shiftreg_s = 1'b1;
                                      next_transfer_state_s = slv_transmit_data_e;
                                   end
                           end
                    end
                 end
            end

            slv_receive_10bit_address_e: begin                                              // receive 10-bit address
                shiftin_i2cdata_s = scl_rising_i;
                if ((scl_falling_i == 1'b1) && (shiftreg_full_s == 1'b1))                 // wait for a falling edge
                    if ((address_match_s == 1'b1) && (addr10lsb_match_s == 1'b1))
                    begin
                        store_address_s = 1'b1;
                        next_transfer_state_s = slv_send_10bit_address_ack_e;
                    end
                    else
                        next_transfer_state_s = idle_e;
                if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                       // does anyone else uses I2C bus?
                begin
                    buscoll_detected_s = 1'b1;
                    slave_i2c_irq_s = 1'b1;
                    next_transfer_state_s = idle_e;                                  // if yes, go to idle
                end
            end

            slv_send_10bit_address_ack_e: begin
                sda_pull_low_s = 1'b1;                                       // set Acknowledge
                if (scl_falling_i == 1'b1)                                  // wait for the falling edge
                begin
                    clr_bitcounter_s = 1'b1;
                    slave_addressed_s = 1'b1;
                    slave_i2c_srq_s = 1'b1;                              // set service request -> start I2C transfer process
                    set_addrmatch_s = 1'b1;                                                          // lower part of 10-bit address matches => address matches
                    next_transfer_state_s = slv_receive_data_e;
                end
            end

            slv_receive_data_e: begin                                                   // recieve a byte
                shiftin_i2cdata_s = scl_rising_i;                                    // read SDA data at rising edge
                slave_addressed_s = 1'b1;
                if ((scl_falling_i == 1'b1) && (shiftreg_full_s == 1'b1))                     // wait untill all bits are received
                begin
                    store_data_s = 1'b1;                                 // store recieved byte
                    slave_i2c_irq_s = 1'b1;                                  // set interrupt request / readout received byte
                    next_transfer_state_s = slv_send_data_ack_e;
                end
                if (shiftreg_lsb_s == 1'b1)
                begin
                    if (start_detected_s == 1'b1)                                 // reStartcondition occured
                    begin
                        clr_bitcounter_s = 1'b1;
                        next_transfer_state_s = slv_receive_address_e;                   // change to address reception
                    end
                    if (stop_detected_s == 1'b1)                                  // stop condition occured
                    begin
                        slave_i2c_irq_s = 1'b1;
                        next_transfer_state_s = idle_e;
                    end
                end
                else
                    if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                        // does anyone else uses I2C bus?
                    begin
                        buscoll_detected_s = 1'b1;
                        slave_i2c_irq_s = 1'b1;
                        next_transfer_state_s = idle_e;                                  // if yes, go to idle
                    end
            end

            slv_send_data_ack_e:                                                        //send an acknowledge
            begin
                sda_pull_low_s = ~ (buffer_corrupted_s);                           // set nack if buffer overflow or write collision detecetd
                slave_addressed_s = 1'b1;
                if (scl_falling_i == 1'b1)                                  // wait for falling edge
                begin
                    clr_bitcounter_s = 1'b1;
                    next_transfer_state_s = slv_receive_data_e;
                end
                if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                        // does anyone else uses I2C bus?
                begin
                    buscoll_detected_s = 1'b1;
                    slave_i2c_irq_s = 1'b1;
                    next_transfer_state_s = idle_e;                                  // if yes, go to idle
                end
            end

            slv_delay_scl_lowphase_e:
            begin
                scl_pull_low_s = 1'b1;                                       // pull scl low
                slave_addressed_s = 1'b1;
                if (tx_buffer_full_s == 1'b1)                                     // wait for data
                begin
                    clr_bitcounter_s = 1'b1;
                    load_shiftreg_s = 1'b1;
                    start_bdr_counter_s = 1'b1;                          // start bdr generator
                    next_transfer_state_s = slv_transmit_data_e;
                end
            end

            slv_transmit_data_e:
            begin
                sda_pull_low_s = ~ (shiftedout_data_s);                                                         // pull to 0 if 1
                scl_pull_low_s = ~ (stop_bdr_counter_s);                                                        // delay scl-low phase (setup time)
                slave_addressed_s = 1'b1;
                if (scl_falling_i == 1'b1)                                  // wait for falling edge
                begin
                    shiftout_i2cdata_s = 1'b1;
                    if (shiftreg_full_s == 1'b1)
                        next_transfer_state_s = slv_receive_data_ack_e;
                end
                if (shiftreg_lsb_s == 1'b1)
                begin
                    if (start_detected_s == 1'b1)                                 // reStartcondition occured
                    begin
                        clr_bitcounter_s = 1'b1;
                        next_transfer_state_s = slv_receive_address_e;                   // change to address reception
                    end
                    if (stop_detected_s == 1'b1)                                  // stop condition occured
                    begin
                        slave_i2c_irq_s = 1'b1;
                        next_transfer_state_s = idle_e;
                    end
                end
                else
                    if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                        // does anyone else uses I2C bus?
                    begin
                        buscoll_detected_s = 1'b1;
                        slave_i2c_irq_s = 1'b1;
                        next_transfer_state_s = idle_e;                                  // if yes, go to idle
                    end
            end

            slv_receive_data_ack_e: begin                                                   // receive an acknowledge
                shiftin_i2cack_s = scl_rising_i;                                 // shift in an acknowledge bit
                slave_addressed_s = 1'b1;
                if (scl_falling_i == 1'b1)
                begin
                    if (i2c_ack_s == 1'b1)
                    begin
                        if (tx_buffer_full_s == 1'b0)
                            slave_i2c_irq_s = 1'b1;                      // if transmit buffer is empty request for data
                        if (en_slvdly_p == 1)                           //  use slv_delay state while data is not ready, if parameter is
                            // is set, if not, send whatever you have in transmit buffer, usually 0xFF
                            next_transfer_state_s = slv_delay_scl_lowphase_e;
                        else
                        begin
                            clr_bitcounter_s = 1'b1;
                            load_shiftreg_s = 1'b1;
                            next_transfer_state_s = slv_transmit_data_e;
                        end
                    end
                    else
                    begin                                       // if nack received go to idle state
                        slave_i2c_irq_s = 1'b1;
                        next_transfer_state_s = idle_e;
                    end
                end
                if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                        // does anyone else uses I2C bus?
                begin
                    buscoll_detected_s = 1'b1;
                    slave_i2c_irq_s = 1'b1;
                    next_transfer_state_s = idle_e;                                  // if yes, go to idle
                end
            end


            mst_send_restartbit_e:  begin
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (scl_rising_i == 1'b1)                                   // wait untill scl is high
                    begin
                        if (sda_level_i == 1'b0)                                // bus collision detected, arbitration
                        begin
                            master_i2c_irq_s = 1'b1;
                            buscoll_detected_s = 1'b1;
                            next_transfer_state_s = idle_e;
                        end
                        else
                        begin
                            start_bdr_counter_s = 1'b1;
                            next_transfer_state_s = mst_send_startbit_p1_e;
                        end
                    end
                end
                else
                    scl_pull_low_s = 1'b1;
            end
            mst_send_startbit_p1_e: begin
                if (scl_level_i == 1'b0)                                            // bus collision detected (scl level has to be high during this phase)
                begin
                    master_i2c_irq_s = 1'b1;
                    buscoll_detected_s = 1'b1;
                    next_transfer_state_s = idle_e;
                end
                if ((sda_level_i == 1'b0) || (stop_bdr_counter_s == 1'b1))
                begin
                    start_bdr_counter_s = 1'b1;
                    store_mst_rnw_s = 1'b1;
                    next_transfer_state_s = mst_send_startbit_p2_e;
                end
            end

            mst_send_startbit_p2_e: begin
                sda_pull_low_s = 1'b1;
                if ((scl_level_i == 1'b0) || (stop_bdr_counter_s == 1'b1))
                begin
                    start_bdr_counter_s = 1'b1;
                    clr_bitcounter_s = 1'b1;
                    load_shiftreg_s = 1'b1;
                    next_transfer_state_s = mst_transmit_address_p1_e;
                end

            end

            mst_transmit_address_p1_e:  begin
                sda_pull_low_s = ~(shiftedout_data_s);                             // pull to 0 if 1
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if(scl_rising_i == 1'b1)                            //wait until scl goes high
                    begin
                        if (sda_level_i == ~ (shiftedout_data_s))             // buss collision detected
                        begin
                            shiftin_i2cdata_s = 1'b1;
                            master_i2c_irq_s = 1'b1;
                            buscoll_detected_s = 1'b1;
                            next_transfer_state_s = slv_receive_address_e;       // maybe it's addressed as slave
                        end
                        else
                        begin
                            shiftin_i2cbb_s = 1'b1;
                            start_bdr_counter_s = 1'b1;
                            next_transfer_state_s = mst_transmit_address_p2_e;
                        end
                    end
                end
                else
                    scl_pull_low_s = 1'b1;
            end
            mst_transmit_address_p2_e:  begin
                sda_pull_low_s = ~(shiftedout_data_s);
                if (sda_level_i == ~(shiftedout_data_s))                                  // bus collision detected
                begin
                    master_i2c_irq_s = 1'b1;
                    buscoll_detected_s = 1'b1;
                    next_transfer_state_s = idle_e;
                end
                if (stop_bdr_counter_s == 1'b1)
                    scl_pull_low_s = 1'b1;
                if (scl_level_i == 1'b0)                                            // wait untill scl is pulled low
                begin
                    start_bdr_counter_s = 1'b1;
                    if (shiftreg_full_s == 1'b1)                              // receive acknowledge from slave
                        next_transfer_state_s = mst_receive_data_ack_p1_e;
                    else
                    begin
                        shiftout_i2cdata_s = 1'b1;                       //shift out next bit
                        next_transfer_state_s = mst_transmit_address_p1_e;
                    end
                end
            end
            mst_receive_data_p1_e:
            begin
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (scl_rising_i == 1'b1)                                     // wait untill scl goes high
                    begin
                        shiftin_i2cdata_s = 1'b1;                                // shift in next bit
                        start_bdr_counter_s = 1'b1;
                        next_transfer_state_s = mst_receive_data_p2_e;
                    end
                end
                else
                    scl_pull_low_s = 1'b1;
            end

            mst_receive_data_p2_e:  begin
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (shiftreg_full_s == 1'b1)
                    begin
                        store_data_s = 1'b1;                             // store received byte
                        master_i2c_irq_s = 1'b1;
                        next_transfer_state_s = mst_waiton_ack_enable_e;
                    end
                    else
                    begin
                        start_bdr_counter_s = 1'b1;                              // continue data reception
                        next_transfer_state_s = mst_receive_data_p1_e;
                    end
                end

                if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                        // does anyone else uses I2C bus?
                begin
                    buscoll_detected_s = 1'b1;
                    master_i2c_irq_s = 1'b1;
                    next_transfer_state_s = idle_e;                                  // if yes, go to idle
                end
            end

            mst_waiton_ack_enable_e:
            begin
                scl_pull_low_s = 1'b1;                                       // pull to low untile acknowledge info released
                if (shiftout_ack_s == 1'b1)
                begin
                    start_bdr_counter_s = 1'b1;
                    next_transfer_state_s = mst_transmit_data_ack_p1_e;
                end
            end

            mst_transmit_data_ack_p1_e:
            begin
                sda_pull_low_s = ackdata_level_s;
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (scl_rising_i == 1'b1)                           //wait until SCL changes to high
                    begin
                        if(sda_level_i == ackdata_level_s)                    //bus collision detected
                        begin
                            master_i2c_irq_s = 1'b1;
                            buscoll_detected_s = 1'b1;
                            next_transfer_state_s = idle_e;
                        end
                        else
                            begin
                               start_bdr_counter_s = 1'b1;
                               next_transfer_state_s = mst_transmit_data_ack_p2_e;
                            end
                    end
                end
                else
                    scl_pull_low_s = 1'b1;
            end

            mst_transmit_data_ack_p2_e:
            begin
                sda_pull_low_s = ackdata_level_s;
                if(sda_level_i == ackdata_level_s)                    //bus collision detected
                begin
                    master_i2c_irq_s = 1'b1;
                    buscoll_detected_s = 1'b1;
                    next_transfer_state_s = idle_e;
                end
                if (stop_bdr_counter_s == 1'b1)
                    scl_pull_low_s = 1'b1;
                if (scl_level_i == 1'b0)                        // wait for SCL line to go low
                begin
                    start_bdr_counter_s = 1'b1;
                    if (ackdata_level_s == 1'b1)
                    begin
                        clr_bitcounter_s = 1'b1;
                        next_transfer_state_s = mst_receive_data_p1_e;
                    end
                    else
                    begin
                        if (restart_transfer_s == 1'b1)
                        begin
                            clr_restartbit_s = 1'b1;
                            next_transfer_state_s = mst_send_restartbit_e;
                        end
                        else
                        begin
                            clr_stopbit_s = 1'b1;
                            next_transfer_state_s = mst_send_stopbit_p1_e;
                        end
                    end
                end
            end

            mst_transmit_data_p1_e:
            begin
                sda_pull_low_s = ~ (shiftedout_data_s);                                        //pull to 0 if 1
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (scl_rising_i == 1'b1)
                    begin
                        if (sda_level_i == (~shiftedout_data_s))                      // bus coillision detected
                        begin
                            master_i2c_irq_s = 1'b1;
                            buscoll_detected_s = 1'b1;
                            next_transfer_state_s = idle_e;
                        end
                        else
                        begin
                            start_bdr_counter_s = 1'b1;
                            next_transfer_state_s = mst_transmit_data_p2_e;
                        end
                    end
                end
                else
                    scl_pull_low_s = 1'b1;
            end

            mst_transmit_data_p2_e:
            begin
                sda_pull_low_s = ~ (shiftedout_data_s);
                if (sda_level_i == (~shiftedout_data_s))                      // bus coillision detected
                begin
                    master_i2c_irq_s = 1'b1;
                    buscoll_detected_s = 1'b1;
                    next_transfer_state_s = idle_e;
                end
                if (stop_bdr_counter_s == 1'b1)
                    scl_pull_low_s = 1'b1;
                if (scl_level_i == 1'b0)                            // wait until scl gets low
                begin
                    start_bdr_counter_s = 1'b1;
                    if (shiftreg_full_s == 1'b1)
                        next_transfer_state_s = mst_receive_data_ack_p1_e;
                    else
                    begin
                        shiftout_i2cdata_s = 1'b1;
                        next_transfer_state_s = mst_transmit_data_p1_e;
                    end
                end
            end

            mst_receive_data_ack_p1_e:
            begin
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (scl_rising_i == 1'b1)                         //wait until scl goes high
                    begin
                        shiftin_i2cack_s = 1'b1;                     // shift in acknowledge bit
                        master_i2c_srq_s = 1'b1;                     // set service request => ACK received
                        if (tx_buffer_full_s == 1'b0)
                        begin
                            master_i2c_irq_s = 1'b1;                    //set master interrupt request => ACK received; write new data
                        end
                        start_bdr_counter_s = 1'b1;
                        next_transfer_state_s = mst_receive_data_ack_p2_e;
                    end
                end
                else
                    scl_pull_low_s = 1'b1;
            end

            mst_receive_data_ack_p2_e:
            begin
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (i2c_ack_s == 1'b1)                                // data byte acknowledge
                    begin
                        if (i2c_rnw_s == 1'b0)                        // Read (0) or write 1
                        begin
                            if (stop_transfer_s == 1'b1)
                            begin
                                clr_stopbit_s = 1'b1;
                                start_bdr_counter_s = 1'b1;
                                next_transfer_state_s = mst_send_stopbit_p1_e;
                            end
                            else
                            begin
                                if (restart_transfer_s == 1'b1)                           // restart transfer ?
                                begin
                                    clr_restartbit_s = 1'b1;
                                    start_bdr_counter_s = 1'b1;
                                    next_transfer_state_s = mst_send_restartbit_e;
                                end
                                else
                                begin
                                    if (tx_buffer_full_s == 1'b1)                         // wait for new transmit data
                                    begin
                                        clr_bitcounter_s = 1'b1;                          // transmit next data byte
                                        load_shiftreg_s = 1'b1;                           // load shift register
                                        start_bdr_counter_s = 1'b1;
                                        next_transfer_state_s = mst_transmit_data_p1_e;
                                    end;
                                end
                            end
                        end
                        else
                        begin
                            clr_bitcounter_s = 1'b1;
                            start_bdr_counter_s = 1'b1;
                            next_transfer_state_s = mst_receive_data_p1_e;
                        end
                    end
                    else
                    begin
                        if (stop_transfer_s == 1'b1)
                        begin
                            clr_stopbit_s = 1'b1;
                            start_bdr_counter_s = 1'b1;
                            next_transfer_state_s = mst_send_stopbit_p1_e;
                        end
                        else
                        begin
                            if (restart_transfer_s == 1'b1)                           // restart transfer ?
                            begin
                                clr_restartbit_s = 1'b1;
                                start_bdr_counter_s = 1'b1;
                                next_transfer_state_s = mst_send_restartbit_e;
                            end
                        end
                    end
                end
                if ((start_detected_s == 1'b1) || (stop_detected_s == 1'b1))                        // does anyone else uses I2C bus?
                begin
                    buscoll_detected_s = 1'b1;
                    master_i2c_irq_s = 1'b1;
                    next_transfer_state_s = idle_e;                                  // if yes, go to idle
                end
            end

            mst_send_stopbit_p1_e:
            begin
                sda_pull_low_s = 1'b1;                                           // pull to low
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (scl_rising_i == 1'b1)                                 // wait until SCL goes high
                    begin
                        start_bdr_counter_s = 1'b1;
                        next_transfer_state_s = mst_send_stopbit_p2_e;
                    end
                end
                else
                    scl_pull_low_s = 1'b1;
            end

            mst_send_stopbit_p2_e:
            begin
                sda_pull_low_s = 1'b1;                                           // pull to low
                if (stop_bdr_counter_s == 1'b1)
                begin
                    if (scl_level_i == 1'b0)                                  //bus collision detected
                    begin
                        master_i2c_irq_s = 1'b1;
                        buscoll_detected_s = 1'b1;
                    end
                    next_transfer_state_s = idle_e;
                end
             
            end
            default :
            begin
                next_transfer_state_s = idle_e;
            end
        endcase

        if (en_i2c_s == 1'b0)
            next_transfer_state_s = idle_e;


    end:i2c_control
//
//    always_ff @ sensitivity_list begin :name
//        
//    end: name //TODO name processes
    always_ff @(posedge clk_i, negedge reset_n_i)
    begin:i2cinterface_dataflow
        if (reset_n_i == reset_active_p)
        begin
            reg_i2cdatain_s <= 0;
            reg_i2cdataout_s <= 0;
            reg_i2cstatus_s <= 0;
            reg_i2ccfg_s <= 32'h00000000;
//            reg_i2c_address_s <= 32'h0000006C;
            bit_counter_s <= 0;
            bdr_counter_s <= 0;
            reg_i2cshift_s <= 0;
            prior_addrmatch_s <= 0;
            buffer_corrupted_s <= 0;
            interrupt_flag_s <= 0;
            i2c_rbf_tc_s <= 0;
            i2c_tbf_tc_s <= 0;
            i2c_rw_tc_s <= 0;
            sda_bitbuffer_s <= 1;
        end
        else
        begin          
            if (clr_bitcounter_s == 1'b1)
                reg_i2ccfg_s[i2c_control_acken_p ] <= 1'b0;
            else if (wr_cfg_reg_s == 1'b1)
                reg_i2ccfg_s[i2c_control_acken_p] <= reg_wrdata_i[i2c_control_acken_p];
            
              if (clr_stopbit_s == 1'b1)
                reg_i2ccfg_s[i2c_control_pen_p] <= 1'b0;
              else if (wr_cfg_reg_s == 1'b1)
                reg_i2ccfg_s[i2c_control_pen_p] <= reg_wrdata_i[i2c_control_pen_p];
            
             if (clr_restartbit_s == 1'b1)
                reg_i2ccfg_s[i2c_control_rsen_p] <= 1'b0;
              else if (wr_cfg_reg_s == 1'b1)
                reg_i2ccfg_s[i2c_control_rsen_p] <= reg_wrdata_i[i2c_control_rsen_p];
              
              if (clr_startbit_s == 1'b1)
                reg_i2ccfg_s[i2c_control_sen_p] <= 1'b0;
              else if (wr_cfg_reg_s == 1'b1)
                reg_i2ccfg_s[i2c_control_sen_p] <= reg_wrdata_i[i2c_control_sen_p];
            
            
            
              if (wr_cfg_reg_s == 1'b1)
                  begin
                     reg_i2ccfg_s[i2c_control_ackdt_p] <= reg_wrdata_i[i2c_control_ackdt_p];
                     reg_i2ccfg_s[i2c_control_inp_p] <= reg_wrdata_i[i2c_control_inp_p];
                     reg_i2ccfg_s[i2c_control_gcen_p] <= reg_wrdata_i[i2c_control_gcen_p];
                     reg_i2ccfg_s[i2c_control_i2cen_p] <= reg_wrdata_i[i2c_control_i2cen_p];
                      reg_i2ccfg_s[$left(reg_i2ccfg_s) : baud_rate_reg_low] <= reg_wrdata_i[$left(reg_wrdata_i) : baud_rate_reg_low];
                      
                  end 
//            if (wr_addr_reg_s == 1'b1)
//                begin
//                    reg_i2c_address_s <= reg_wrdata_i;
//                end;  


            if (wr_dataout_reg_s == 1'b1 )
                if (read_tcr_via_i2c_s)
                        reg_i2cdataout_s <= sfr_tcr_s;
                else
                        reg_i2cdataout_s <= reg_wrdata_i[7:0];
            else  if ((en_slvdly_p == 0) && (load_shiftreg_s == 1'b1))
                         reg_i2cdataout_s <= 8'hFF;

//            if (wr_mode_reg_s == 1'b1)
//                reg_i2ccfg_s <= reg_wrdata_i;
//
//
//            if (wr_addr_reg_s == 1'b1)
//                reg_i2caddress_s <= reg_wrdata_i;
//
//            if (wr_bdr_reg_s == 1'b1)
//                reg_i2cbaudrate_s <= reg_wrdata_i;

            
 
                
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Collision detected status bit control /////////////////////////////////////////////////////////////////////////////////////////////////////////         
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////               

             if (buscoll_detected_s == 1'b1)
                reg_i2cstatus_s[i2c_status_cd_p] <= 1'b1;
             else if (wr_status_reg_s == 1'b1)
                        if (reg_wrdata_i[i2c_status_cd_p])
                           reg_i2cstatus_s[i2c_status_cd_p] <= 1'b0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Interrupt flag control //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////         
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////            
            
            if ((slave_i2c_irq_s == 1'b1) || (master_i2c_irq_s == 1'b1))
                interrupt_flag_s <= 1'b1;
            else if (rd_status_reg_s == 1'b1)
                interrupt_flag_s  <= 1'b0;
         
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// I2C transfer active (master/slave) status bit control /////////////////////////////////////////////////////////////////////////////////         
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            if (i2c_inp_s == 1'b0)
            begin
                if (stop_detected_s == 1'b1)
                    begin
                       reg_i2cstatus_s[i2c_status_s_p] <= 1'b1;
                    end
                else if (wr_status_reg_s == 1'b1)
                    begin
                        if (reg_wrdata_i[i2c_status_s_p] == 1'b1)
                            reg_i2cstatus_s[i2c_status_s_p] <= 1'b0;                                              // I2C slave: Stop-bit detected
                    end
            end
            else
            begin
                if (stop_detected_s == 1'b1)
                     begin
                        reg_i2cstatus_s[i2c_status_s_p] <= 1'b0;
                     end
                else if (start_detected_s == 1'b1)                                                   // I2C master/slave: I2C-transfer-active
                    begin
                       reg_i2cstatus_s[i2c_status_s_p] <= 1'b1;
                    end
            end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// I2C slave addressed status bit control /////////////////////////////////////////////////////////////////////////////////////////////////////         
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
           
            if (i2c_inp_s == 1'b1)
               begin
                  if (slave_addressed_s == 1'b1)
                     begin
                        reg_i2cstatus_s[i2c_status_sla_p] <= 1'b1;
                     end
                  else
                      begin
                         if (wr_status_reg_s == 1'b1)
                             if (reg_wrdata_i[i2c_status_sla_p])
                                 reg_i2cstatus_s[i2c_status_sla_p] <= 1'b0;
                      end
               end
            else 
                begin 
                 if ((slave_i2c_srq_s == 1'b1) || (master_i2c_srq_s == 1'b1))
                    reg_i2cstatus_s[i2c_status_sla_p]<= 1'b1;
                 else
                     begin
                            if (wr_status_reg_s == 1'b1)
                               if (reg_wrdata_i[i2c_status_sla_p])
                                 reg_i2cstatus_s[i2c_status_sla_p] <= 1'b0;
                     end
                end
            // detect I2C interrupt request
            
; //TODO This should be removed

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Buffer corrupted status bit control //////////////////////////////////////////////////////////////////////////////////////////////////////////          
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                if (start_detected_s || stop_detected_s)
                    buffer_corrupted_s <= 1'b0;
                else
                    begin
                        if (store_data_s && reg_i2cstatus_s[i2c_status_rbf_p] && ~(i2c_addr_tc_comb_s & first_try_s))
                            buffer_corrupted_s <= 1'b1;
                        else 
                            begin
                                if (store_address_s && reg_i2cstatus_s[i2c_status_rbf_p]  && ~(i2c_addr_tc_comb_s & first_try_s) )
                                    buffer_corrupted_s  <= 1'b1;
                            end
                     end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Transmit Buffer Full status bit control /////////////////////////////////////////////////////////////////////////////////////////////////////          
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                            
                if (wr_dataout_reg_s)
                    begin
                        if (tc_status_s)      
                           i2c_tbf_tc_s <= 1'b1;
                        else
                           reg_i2cstatus_s[i2c_status_tbf_p] <= 1'b1;
                     end
                else
                    begin
                        if (slave_addressed_s && stop_detected_s)
                            begin
                                if (tc_status_s)
                                    i2c_tbf_tc_s <= 1'b0;                                 
                                else
                                   reg_i2cstatus_s[i2c_status_tbf_p] <= 1'b0;
                             end
                        else
                            if (load_shiftreg_s)
                                begin
                                    if (!tc_status_s)
                                       reg_i2cstatus_s[i2c_status_tbf_p] <= 1'b0;
                                    else
                                       i2c_tbf_tc_s <= 1'b0;
                                end
                    end
                    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Overflow control /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////           
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                    
                if (reg_i2cstatus_s[i2c_status_rbf_p] && (store_address_s || store_data_s))
                    reg_i2cstatus_s[i2c_status_ov_p] <= 1'b1;
                else
                    begin
                            if (wr_status_reg_s)
                                if (reg_wrdata_i[i2c_status_ov_p])
                                    reg_i2cstatus_s[i2c_status_ov_p] <= 1'b0;
                    end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Receive Buffer Full status bit control ///////////////////////////////////////////////////////////////////////////////////////////////////////        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
                
                if (store_data_s)
                    begin
                        if (i2c_addr_tc_comb_s)
                            i2c_rbf_tc_s <= 1'b1;
                        else
                            reg_i2cstatus_s[i2c_status_rbf_p] <= 1'b1;
                    end
                else 
                    begin
                        if (rd_datain_reg_s)
                            begin
                                reg_i2cstatus_s[i2c_status_rbf_p] <= 1'b0;
                                i2c_rbf_tc_s <= 1'b0;
                            end
                        else if (stop_detected_s & i2c_addr_tc_comb_s)
                               i2c_rbf_tc_s <= 1'b0;
                    end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// Read/Write Transfer status bit control /////////////////////////////////////////////////////////////////////////////////////////////////////       
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            if (stop_detected_s == 1'b1)
                begin
                   reg_i2cstatus_s[i2c_status_rw_p] <= 1'b0;
                   i2c_rw_tc_s <=1'b0;
                end
            else 
                begin
                    if (store_mst_rnw_s == 1'b1)
                        begin
                            if (tc_status_s)      
                               i2c_rw_tc_s <= reg_i2cdataout_s[0];
                            else
                               reg_i2cstatus_s[i2c_status_rw_p] <= reg_i2cdataout_s[0];
                        end
                    else  if (store_slv_rnw_s == 1'b1)
                        begin
                            if (tc_status_s)
                               i2c_rw_tc_s <= reg_i2cshift_s[0];
                            else
                               reg_i2cstatus_s[i2c_status_rw_p] <= reg_i2cshift_s[0];
                        end
                end       

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// I2C shift register control   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////       
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            if (load_shiftreg_s == 1'b1)                      
                reg_i2cshift_s <= reg_i2cdataout_s;
            else 
                if (shiftout_i2cdata_s == 1'b1)
                   begin
                      reg_i2cshift_s[$high(datavec_byte_t):1] <= reg_i2cshift_s[$high(datavec_byte_t)-1 :0]; 
                      reg_i2cshift_s[0] <= sda_bitbuffer_s;
                    end
                else 
                  begin
                     if (shiftin_i2cdata_s == 1'b1)
                        begin
                           reg_i2cshift_s[$high(datavec_byte_t):1] <= reg_i2cshift_s[$high(datavec_byte_t)-1 :0];
                           reg_i2cshift_s[0] <= sda_level_i;
                        end
               end
           
            if (shiftin_i2cbb_s == 1'b1)
                sda_bitbuffer_s <= sda_level_i;
            //TODO change to datavec
           if ((store_data_s == 1'b1) || (store_address_s == 1'b1))            //store received address/data
                if (reg_i2cstatus_s[i2c_status_rbf_p] == 1'b0 || pwd_check_s)                    //if no overflow occurred
                   reg_i2cdatain_s <= reg_i2cshift_s;

            

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////// Store Received ACKnowledge level/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            if (shiftin_i2cack_s == 1'b1)
                reg_i2cstatus_s[i2c_status_rack_p] <= ~(sda_level_i);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// Internal flag Prior Address Matched control //////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


            if (stop_detected_s == 1'b1)
                prior_addrmatch_s <= 1'b0;
            else  if (set_addrmatch_s == 1'b1)
                prior_addrmatch_s <= 1'b1;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// Bit counter control ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            if (clr_bitcounter_s == 1'b1)
                begin
                   if (load_shiftreg_s == 1'b1)
                      bit_counter_s <= 8'h01;
                   else
                      bit_counter_s <= 8'h00;
                end
            else 
                begin
                     if (shiftout_i2cdata_s == 1'b1)
                         bit_counter_s <= bit_counter_s + 1;
                     else 
                         if (shiftin_i2cdata_s == 1'b1)
                            bit_counter_s <= bit_counter_s + 1;
                end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// BDR counter control /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            if (start_bdr_counter_s == 1'b1)
                bdr_counter_s <= { 1'b0, 1'b0 ,reg_i2ccfg_s[baud_rate_reg_high : baud_rate_reg_low]}; // TODO original code, here we'll try with { 1'b0 ,1'b0, reg_i2cbaudrate_s}
            else 
                if (stop_bdr_counter_s == 1'b0)
                   bdr_counter_s <= bdr_counter_s - 1 ;
        end
    end:i2cinterface_dataflow

    always_comb
    begin
        if ((en_slvdly_p == 1) || (en_master_p == 1))
            stop_bdr_counter_s = bdr_counter_s[$high(bdr_counter_s)];
        else
            stop_bdr_counter_s = 1'b1;

        if (en_i2cenbit_p == 1)
            en_i2c_s = reg_i2ccfg_s[i2c_control_i2cen_p];
        else
            en_i2c_s = en_i2c_i;

//        if (en_i2c10bit_p == 1)
//            i2c10bit_mode_s = reg_i2c_address_s[i2c_mode_tba_p];
//        else
        i2c10bit_mode_s = 1'b0;

        if ((en_i2c_s == 1'b1) && (scl_level_i == 1'b1) && (sda_falling_i == 1'b1))
            start_detected_s = 1'b1;
        else
            start_detected_s = 1'b0;

        if ((en_i2c_s == 1'b1) && (scl_level_i == 1'b1) && (sda_rising_i == 1'b1))
            stop_detected_s = 1'b1;
        else
            stop_detected_s = 1'b0;

        if ((en_master_p == 0) || (transfer_state_s != idle_e))
            start_transfer_s = 1'b0;
        else
            start_transfer_s = en_i2c_s && reg_i2ccfg_s[i2c_control_sen_p] && reg_i2cstatus_s[i2c_status_tbf_p];

        if ((en_master_p == 0) || (transfer_state_s == idle_e))
            restart_transfer_s = 1'b0;
        else
            restart_transfer_s = en_i2c_s && reg_i2ccfg_s[i2c_control_rsen_p] && reg_i2cstatus_s[i2c_status_tbf_p];

        if (en_master_p == 0)
            stop_transfer_s = 1'b0;
        else
            stop_transfer_s = en_i2c_s && reg_i2ccfg_s[i2c_control_pen_p];


        tx_buffer_full_s = reg_i2cstatus_s[i2c_status_tbf_p] || i2c_tbf_tc_s;
        i2c_ack_s = reg_i2cstatus_s[i2c_status_rack_p];
        i2c_rnw_s = reg_i2cstatus_s[i2c_status_rw_p];
        i2c_inp_s = reg_i2ccfg_s[i2c_control_inp_p];
        ackdata_level_s = reg_i2ccfg_s[i2c_control_ackdt_p];
        shiftout_ack_s = reg_i2ccfg_s[i2c_control_acken_p];

        shiftreg_full_s = bit_counter_s[3];                                            // shift register full

        if (bit_counter_s == 1'b1)
            shiftreg_lsb_s = 1'b1;
        else
            shiftreg_lsb_s = 1'b0;

        shiftedout_data_s = reg_i2cshift_s[$high(datavec_byte_t)];                                             //data shifted out (tx)         // here it should be $high(datavec)


        if (reg_i2cshift_s[$high(datavec_byte_t):1] == 7'b0110110 && ~tc_status_s)
            begin
               address_match_s = 1'b1;
            end
        else 
            begin
                if (reg_i2cshift_s[$high(datavec_byte_t):1] == 7'b0101110)
                   begin
                      address_match_s = 1'b1;
                   end
                else
                    begin
                       address_match_s = 1'b0;
                    end
            end
//        if (reg_i2c_address_s[i2c_mode_tba_p] == reg_i2c_address_s[i2c_mode_tba_p])
//            addr10lsb_match_s = 1'b1;
//        else
//            addr10lsb_match_s = 1'b0;

//        if (reg_i2cshift_s[7:3] == 5'b11110)
//            addr10pre_match_s = 1'b1;
//        else
//            addr10pre_match_s = 1'b0;


//        if (reg_i2cshift_s[2:1] == {reg_i2ccfg_s[i2c_mode_a9_p],reg_i2ccfg_s[i2c_mode_a8_p]})
//            addr10msb_match_s = 1'b1;
//        else
//            addr10msb_match_s = 1'b0;

        if ((reg_i2cshift_s[$high(datavec_byte_t):0] == 'b0) && (reg_i2ccfg_s[i2c_control_gcen_p] ==1))
            addr_gc_match_s = 1'b1;
        else
            addr_gc_match_s = 1'b0;

        received_rnw_s = reg_i2cshift_s[0];

    end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////                 I2C output control                  ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin int_o = interrupt_flag_s; end

    always_ff @(posedge clk_i, negedge reset_n_i)
    begin:slc_register
        if (reset_n_i == reset_active_p)
        begin
            if (reset_allff_p)
                scl_out_ff_s <= 1'b0;
                scl_pull_low_dly_1_s <= 1'b0;
                scl_pull_low_dly_2_s <= 1'b0;
                scl_pull_low_dly_3_s <= 1'b0;
        end
        else
            begin
                if (transfer_state_s != mst_receive_data_p1_e)
                   scl_out_ff_s <= en_i2c_s && scl_pull_low_s;
                else 
                    begin
                        scl_pull_low_dly_1_s <= scl_pull_low_s;
                        scl_pull_low_dly_2_s <= scl_pull_low_dly_1_s;
                        scl_pull_low_dly_3_s <= scl_pull_low_dly_2_s;
                        scl_out_ff_s <= en_i2c_s && ((scl_pull_low_s || scl_pull_low_dly_1_s || scl_pull_low_dly_2_s || scl_pull_low_dly_3_s));
                    end
            end
    end:slc_register

    always_comb begin scl_enable_o = scl_out_ff_s; end

   // assign scl_enable_o = scl_out_ff_s;

    always_ff @(posedge clk_i,negedge reset_n_i)
    begin:sda_register
        if (reset_n_i == reset_active_p)
        begin
            if (reset_allff_p)
                begin
                   sda_out_ff_s <= 1'b0;
                end
        end
        else
            begin
               sda_out_ff_s <= en_i2c_s && sda_pull_low_s;
            end
    end:sda_register

    always_comb begin sda_enable_o = sda_out_ff_s; end

    // output internal registers

    always_comb
    begin
        sfr_i2c_datain_o = reg_i2cdatain_s;
        sfr_i2c_dataout_o = reg_i2cdataout_s;
        sfr_i2c_status_o = reg_i2cstatus_s;

//        if (en_i2c10bit_p == 0)
//            sfr_i2c_address_s = {reg_i2c_address_s[7:1],1'b0};
//        else
//            sfr_i2c_address_s = reg_i2c_address_s[7:0];

        if ((en_slvdly_p == 1) || (en_master_p == 1) )
            sfr_i2c_cfg_s[baud_rate_reg_high : baud_rate_reg_low] = reg_i2ccfg_s[baud_rate_reg_high : baud_rate_reg_low];
        else
            sfr_i2c_cfg_s[baud_rate_reg_high : baud_rate_reg_low] = 8'b00000000;


        //if (en_i2cenbit_p == 1)
            sfr_i2c_cfg_s[i2c_control_i2cen_p] = reg_i2ccfg_s[i2c_control_i2cen_p];
//        else
//            sfr_i2c_cfg_s[i2c_control_i2cen_p] = 1'b0;

        sfr_i2c_cfg_s[i2c_control_gcen_p] = reg_i2ccfg_s[i2c_control_gcen_p];
        sfr_i2c_cfg_s[i2c_control_inp_p] = reg_i2ccfg_s[i2c_control_inp_p];

        if (en_master_p == 1)
        begin
            sfr_i2c_cfg_s[i2c_control_ackdt_p] = reg_i2ccfg_s[i2c_control_ackdt_p];
            sfr_i2c_cfg_s[i2c_control_acken_p] = reg_i2ccfg_s[i2c_control_acken_p];
            sfr_i2c_cfg_s[i2c_control_pen_p] = reg_i2ccfg_s[i2c_control_pen_p];
            sfr_i2c_cfg_s[i2c_control_rsen_p] = reg_i2ccfg_s[i2c_control_rsen_p];
            sfr_i2c_cfg_s[i2c_control_sen_p] = reg_i2ccfg_s[i2c_control_sen_p];
        end
        else
        begin
            sfr_i2c_control_s[i2c_control_ackdt_p : i2c_control_sen_p] = '0;
//            sfr_i2c_control_s[3] = 1'b0;
//            sfr_i2c_control_s[2] = 1'b0;
//            sfr_i2c_control_s[1] = 1'b0;
//            sfr_i2c_control_s[0] = 1'b0;
        end
//        sfr_i2c_address_s[i2c_mode_tba_p +5] = 1'b0;
//        sfr_i2c_address_s[i2c_mode_tba_p +4] = 1'b0;
//        sfr_i2c_address_s[i2c_mode_tba_p +3] = 1'b0;
//        sfr_i2c_address_s[i2c_mode_tba_p +2] = 1'b0;
//        sfr_i2c_address_s[i2c_mode_tba_p +1] = 1'b0;
//        if (en_i2c10bit_p == 1)
//            sfr_i2c_address_s[i2c_mode_a9_p] = reg_i2c_address_s [i2c_mode_a9_p];
//        else
//            sfr_i2c_address_s[i2c_mode_a9_p] = 1'b0;
//
//
//        if (en_i2c10bit_p == 1)
//            sfr_i2c_address_s[i2c_mode_a8_p] = reg_i2c_address_s [i2c_mode_a8_p];
//        else
//            sfr_i2c_address_s[i2c_mode_a8_p] = 1'b0;
//
//
//        if (en_i2c10bit_p == 1)
//            sfr_i2c_address_s[i2c_mode_tba_p] = reg_i2c_address_s [i2c_mode_tba_p];
//        else
//            sfr_i2c_address_s[i2c_mode_tba_p] = 1'b0;

    end
//    
//    always_ff @(posedge clk_i or negedge reset_n_i) begin
//        if (reset_n_i == reset_active_p) begin
//                   i2c_rbf_tc_o = 1'b0;
//        end
//        else begin
//                    i2c_rbf_tc_o = i2c_rbf_tc_s & (~i2c_rbf_tc_ff_s);
//        end
//    end

always_comb i2c_rbf_tc_o = i2c_rbf_tc_ff_s;
always_comb i2c_addr_tc_o = i2c_addr_tc_comb_s;

always_ff @(posedge clk_i, negedge reset_n_i) begin
    if (reset_n_i == reset_active_p) begin
         i2c_addr_tc_comb_s <= 1'b0;
    end
    else begin
         if (reg_i2cdatain_s[7:1] == 7'b0101110 & (address_match_s) & transfer_state_s == slv_receive_address_e)
            i2c_addr_tc_comb_s <= 1'b1;
        else if (stop_detected_ff_s)
            i2c_addr_tc_comb_s <= 1'b0;
    end
end
           

always_ff @(posedge clk_i, negedge reset_n_i) begin
    if (reset_n_i == reset_active_p) begin
        stop_detected_ff_s <= 1'b0;
    end
    else begin
        stop_detected_ff_s <= stop_detected_s;
    end
end

assign   sfr_i2c_cfg_o [baud_rate_reg_high:0]= sfr_i2c_cfg_s[baud_rate_reg_high:0];
//assign   sfr_i2c_address_o [mode_reg_high:0]= sfr_i2c_address_s[mode_reg_high:0];
assign   sfr_i2c_cfg_o [31:baud_rate_reg_high+1] = 'b0;
//assign   sfr_i2c_address_o [31:mode_reg_high+1] = 'b0;

endmodule: i2c_master_sv
// TODO use SFR package

