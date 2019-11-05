library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.Control_functions.all;

entity Control is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	TX_flags_in:		in unsigned(1 downto 0);
	TX_flags_in_sync:	 in bool;
        baud_clk_div:           out unsigned(15 downto 0);
        TE_flag:                out unsigned(0 downto 0);
        RE_flag:                out unsigned(0 downto 0);
	ctrl_from_rx:		in rx_data;
	ctrl_from_rx_sync:	 in bool;
	ctrl_to_tx:		out tx_data;
	interrupt:		out bool;
	interrupt_notify:	 out bool;
	req_from_mem:		in CUtoME_IF;
	req_from_mem_sync:	 in bool;
	resp_to_mem:		out reg_files
);
end Control;

architecture Control_arch of Control is
signal section: Control_SECTIONS;
			 signal from_mem_signal:bool;
			 signal from_rx_signal:bool;
			 signal from_tx_signal:bool;
			 signal regs_signal:reg_files;
			 signal req_signal:CUtoME_IF;
			 signal rx_temp_signal:rx_data;
			 signal tx_flag_signal:unsigned(1 downto 0);
			 signal tx_temp_signal:tx_data;
begin
	 process(clk)
	 
       
         variable req_temp: CUtoME_IF;
         variable rx_data_temp: rx_data;
         variable regs_temp: reg_files;
         variable tx_temp: tx_data;


	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=RUN;
			from_mem_signal<=false;
			from_rx_signal<=false;
			from_tx_signal<=false;
			regs_signal.CR_reg<= (others => '0');
			regs_signal.DR_reg<= (others => '0');
			regs_signal.SR_reg<= TXE_flag;
			req_signal.addrIn<= (others => '0');
			req_signal.dataIn<= (others => '0');
			req_signal.mask<=MT_B;
			req_signal.req<=ME_RD;
			rx_temp_signal.DR_reg<= (others => '0');
			rx_temp_signal.SR_reg<= (others => '0');
			tx_flag_signal<= (others => '0');
			tx_temp_signal.r_act<=NA;
			tx_temp_signal.tx_reg<= (others => '0');
			interrupt_notify <= false;
                        TE_flag <= to_unsigned(0,1);
                        RE_flag <= to_unsigned(0,1);
		 else

		 if section = RUN then
		
                     regs_temp := regs_signal; 
                     tx_temp := tx_temp_signal;

                    if(TX_flags_in_sync = false and req_from_mem_sync = false and ctrl_from_rx_sync = false) then
                      ctrl_to_tx <= tx_temp;
                    elsif(TX_flags_in_sync = false and req_from_mem_sync = false and ctrl_from_rx_sync = true) then
                      ctrl_to_tx <= tx_temp;                      
                      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, ctrl_from_rx.DR_reg, ctrl_from_rx.SR_reg);
                      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, ctrl_from_rx.SR_reg);
                    elsif(TX_flags_in_sync = false and req_from_mem_sync = true and ctrl_from_rx_sync = false) then
                      regs_temp.CR_reg := register_CR_command(regs_temp.CR_reg, req_from_mem);
                      regs_temp.DR_reg := register_TX_command(regs_temp.DR_reg, req_from_mem);
                      regs_temp.SR_reg := register_SR_command(regs_temp.SR_reg, req_from_mem);
                      tx_temp.tx_reg   := set_tx(req_from_mem.dataIn);
                      tx_temp.r_act    := tx_action(tx_temp_signal, req_from_mem);
                      ctrl_to_tx <= tx_temp;
                    elsif(TX_flags_in_sync = false and req_from_mem_sync = true and ctrl_from_rx_sync = true) then
                      regs_temp.CR_reg := register_CR_command(regs_temp.CR_reg, req_from_mem);
                      regs_temp.DR_reg := register_TX_command(regs_temp.DR_reg, req_from_mem);
                      regs_temp.SR_reg := register_SR_command(regs_temp.SR_reg, req_from_mem);
                      tx_temp.tx_reg   := set_tx(req_from_mem.dataIn);
                      tx_temp.r_act    := tx_action(tx_temp_signal, req_from_mem);
                      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, ctrl_from_rx.DR_reg, ctrl_from_rx.SR_reg);
                      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, ctrl_from_rx.SR_reg);
                      ctrl_to_tx <= tx_temp;
                    elsif(TX_flags_in_sync = true and req_from_mem_sync = false and ctrl_from_rx_sync = false) then
                      ctrl_to_tx <= tx_temp;
                      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg); 
                      tx_temp.r_act := tx_no_action(tx_temp, TX_flags_in);
                    elsif(TX_flags_in_sync = true and req_from_mem_sync = false and ctrl_from_rx_sync = true) then
                      ctrl_to_tx <= tx_temp;
                      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, ctrl_from_rx.DR_reg, ctrl_from_rx.SR_reg);
                      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, ctrl_from_rx.SR_reg);
                      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg);     
                      tx_temp.r_act := tx_no_action(tx_temp, TX_flags_in);
                    elsif(TX_flags_in_sync = true and req_from_mem_sync = true and ctrl_from_rx_sync = false) then

                      regs_temp.CR_reg := register_CR_command(regs_temp.CR_reg, req_from_mem);
                      regs_temp.DR_reg := register_TX_command(regs_temp.DR_reg, req_from_mem);
                      regs_temp.SR_reg := register_SR_command(regs_temp.SR_reg, req_from_mem);
                      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg); 
                      tx_temp.tx_reg   := set_tx(req_from_mem.dataIn);
                      tx_temp.r_act    := tx_action(tx_temp_signal, req_from_mem);

                      ctrl_to_tx <= tx_temp;
                      tx_temp.r_act    := tx_no_action(tx_temp, TX_flags_in);
                    elsif(TX_flags_in_sync = true and req_from_mem_sync = true and ctrl_from_rx_sync = true) then

                      regs_temp.CR_reg := register_CR_command(regs_temp.CR_reg, req_from_mem);
                      regs_temp.DR_reg := register_TX_command(regs_temp.DR_reg, req_from_mem);
                      regs_temp.SR_reg := register_SR_command(regs_temp.SR_reg, req_from_mem);

                      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, ctrl_from_rx.DR_reg, ctrl_from_rx.SR_reg);
                      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, ctrl_from_rx.SR_reg);
                      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg); 
                      tx_temp.tx_reg   := set_tx(req_from_mem.dataIn);
                      tx_temp.r_act    := tx_action(tx_temp_signal, req_from_mem);


                      ctrl_to_tx <= tx_temp;
                      tx_temp.r_act    := tx_no_action(tx_temp, TX_flags_in);

                    end if;

                    baud_clk_div <= regs_signal.CR_reg(31 downto 16);
                    TE_flag <= regs_signal.CR_reg(0 downto 0);
                    RE_flag <= regs_signal.CR_reg(1 downto 1);                    
                   

                    tx_temp_signal.tx_reg <= tx_temp.tx_reg;
                    tx_temp_signal.r_act <= tx_temp.r_act;
               

                    if(check_interrupt(regs_temp.SR_reg, regs_temp.CR_reg) /= ZERO) then
                      interrupt <= true;
                      interrupt_notify <= true;
                      regs_temp.SR_reg := regs_temp.SR_reg or IP_bit;
                    else
                      interrupt <= false;
                      interrupt_notify <= false;
                    end if;

                    resp_to_mem <= regs_temp;
                    
                    
                    regs_signal <= regs_temp;

		 end if;
		 end if;
	 end if;
	 end process;
end Control_arch;
