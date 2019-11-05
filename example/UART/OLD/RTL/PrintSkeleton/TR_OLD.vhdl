library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Transmitter is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	TE_flag_trans:		in unsigned(0 downto 0);
	TX_pin:		out bool;
	baudrate_in:		in bool;
	baudrate_in_sync:	 in bool;
	baudrate_in_notify:	 out bool;
	trans_flags_out:		out update_inf;
	trans_flags_out_sync:	 in bool;
	trans_flags_out_notify:	 out bool;
	transfer_data:		in reg_files;
	transfer_data_sync:	 in bool;
	transfer_data_notify:	 out bool);
end Transmitter;

architecture Transmitter_arch of Transmitter is
signal section: Transmitter_SECTIONS;
			 signal TE_flag_signal:unsigned(0 downto 0);
			 signal TX_pin_trigger_signal:bool;
			 signal TX_shiftreg_signal:unsigned(7 downto 0);
			 signal bitcounter_signal:unsigned(3 downto 0);
			 signal enabled_signal:bool;
			 signal init_signal:bool;
			 signal next_state_signal:unsigned(3 downto 0);
			 signal regs_signal:reg_files;
			 signal shiftcounter_signal:unsigned(3 downto 0);
			 signal trigg_signal:bool;
			 signal update_inf1_signal:update_inf;
                    --     signal trans_flags_out_sync_tmp:bool;
                         signal trans_flags_out_notify_tmp:bool;
                  --       signal transfer_data_notify_tmp:bool;
begin
--transfer_data_notify <= transfer_data_notify_tmp;
trans_flags_out_notify <= trans_flags_out_notify_tmp;

	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=RECEIVE_DATA;
			TE_flag_signal<= (others => '0');
			TX_pin_trigger_signal<=true;
			TX_shiftreg_signal<= (others => '0');
			bitcounter_signal<= (others => '0');
			enabled_signal<=false;
			init_signal<=false;
			next_state_signal<= (others => '0');
			regs_signal.CR_reg<=(others => '0');
			regs_signal.RX_reg<=(others => '0');
			regs_signal.SR_reg<=(others => '0');
			regs_signal.TX_reg<=(others => '0');
			regs_signal.r_act<=CR_RD;
			shiftcounter_signal<= (others => '0');
			trigg_signal<=false;
			update_inf1_signal.upd_inf1<=NU;
			trans_flags_out_notify_tmp <= false;
                   --     trans_flags_out_sync_tmp <= false;
			transfer_data_notify <= true;
                        TX_pin <= true;
		 else
		 if section = FINISH then

                    if(TE_flag_signal = to_unsigned(0,1) and enabled_signal = true) then 
                       next_state_signal <= to_unsigned(1,4);
                       TX_pin_trigger_signal <= true;
                       enabled_signal<=false;
                       bitcounter_signal<=to_unsigned(0,4);
                       shiftcounter_signal<=to_unsigned(0,4);
                       TX_shiftreg_signal<=to_unsigned(0,8);
                     end if;
                       

                    TX_pin <= TX_pin_trigger_signal;
                                                         
                    case next_state_signal is
                    when to_unsigned(1,4) => 
                         transfer_data_notify<= true;
                         section<=RECEIVE_DATA;
                    when to_unsigned(2,4) => section<=START;
                    when to_unsigned(3,4) => section<=SEND;
                    when to_unsigned(4,4) => section<=PARITY;
                    when to_unsigned(5,4) => 
                    --     trans_flags_out_notify<=true;
                         section<=STOP;
                    when others => 
                         transfer_data_notify<= true;
                         section<=RECEIVE_DATA;
                    end case; 
 

		 end if;
		 if section = PARITY then
                    if(baudrate_in = true) then
                       if(bitcounter_signal mod to_unsigned(2,4) /= 0) then
                          TX_pin_trigger_signal <= false;
                       else
                          TX_pin_trigger_signal <= true;
                       end if;
                       bitcounter_signal <= to_unsigned(0,4);
                       next_state_signal <= to_unsigned(5,4);
                       section<=FINISH;
                  
                    else
                       section<=PARITY;
                    end if;

		 -- FILL OUT HERE;
		 end if;
		 if section = RECEIVE_DATA then
             --       if(init_signal = true) then
              --         TX_pin <= TX_pin_trigger_signal;
                    --   init_signal<=false;
                  --  end if;
                    
                  

                    if(transfer_data_sync = true) then
                       transfer_data_notify <= false;
                       regs_signal<=transfer_data;
                       TE_flag_signal<=TE_flag_trans;
                       if(transfer_data.r_act = TX_WR and TE_flag_trans = to_unsigned(1,1)) then
                          next_state_signal<= to_unsigned(2,4);
                          TX_shiftreg_signal <= transfer_data.TX_reg;
                          update_inf1_signal.upd_inf1 <= r_ack;
                          enabled_signal<= true;
                       else 
                          next_state_signal<=to_unsigned(1,4);
                    end if;
                       section<=FINISH;
                    else
                     --  transfer_data_notify<=true;
                       section<=RECEIVE_DATA;
                    end if;

                    

		
		 end if;
		 if section = SEND then
                    if(baudrate_in = true) then
                      if(TX_shiftreg_signal(0 downto 0) = to_unsigned(1,1)) then 
                         TX_pin_trigger_signal <= true;                
                         bitcounter_signal <= bitcounter_signal + to_unsigned(1,4);
                      else
                         TX_pin_trigger_signal<=false;
                      end if;

                         TX_shiftreg_signal <= TX_shiftreg_signal SRL 1; 
                         shiftcounter_signal <= shiftcounter_signal + to_unsigned(1,4);
                         if(shiftcounter_signal >= 7) then
                            shiftcounter_signal <= to_unsigned(0,4);
                            next_state_signal <= to_unsigned(4,4);
                         else
                            next_state_signal <= to_unsigned(3,4);
                         end if;
                         section<=FINISH;

                    else
                       section<=SEND;
                    end if;

 
		 -- FILL OUT HERE;
		 end if;
		 if section = START then
                    if(baudrate_in = true) then
                       TX_pin_trigger_signal <= false;
                       next_state_signal <= to_unsigned(3,4);
                       section<=FINISH;
                    else
                       section<=START;
                    end if;
	
		 end if;
		 if section = STOP then
                    if(baudrate_in = true) then  
                       trans_flags_out_notify_tmp <= true;  
                       trans_flags_out.upd_inf1 <= t_comp;
                       update_inf1_signal.upd_inf1 <= t_comp;  
                       TX_pin_trigger_signal<=true; 
                      -- if(trans_flags_out_sync = true) then
                      --    trans_flags_out_sync_tmp <= true;
                      -- end if;         
                       if(trans_flags_out_sync = true and trans_flags_out_notify_tmp = true) then  
                        trans_flags_out_notify_tmp <= false;
                    --    trans_flags_out_sync_tmp <= false;
                        next_state_signal<=to_unsigned(1,4);
                      --  regs_signal.SR_reg <= to_unsigned(0,32);
                       
                        section<=FINISH;
                        
                        else
                        section<=STOP;
                       end if;
                
                    else
                        section<=STOP;
                    end if;
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;
end Transmitter_arch;
