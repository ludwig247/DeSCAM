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
	trans_flags_out:		out bool;
	transfer_data:		in reg_files;
	transfer_data_sync:	 in bool;
	transfer_data_notify:	 out bool);
end Transmitter;

architecture Transmitter_arch of Transmitter is
signal section: Transmitter_SECTIONS;
			 signal TE_flag_signal:unsigned(0 downto 0);
			 signal TX_shiftreg_signal:unsigned(7 downto 0);
			 signal bitcounter_signal:unsigned(3 downto 0);
			 signal regs_signal:reg_files;
			 signal shiftcounter_signal:unsigned(3 downto 0);
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=READ_DATA;
			TE_flag_signal<= (others => '0');
			TX_shiftreg_signal<= (others => '0');
			bitcounter_signal<= (others => '0');
			regs_signal.CR_reg<= (others => '0');
			regs_signal.RX_reg<= (others => '0');
			regs_signal.SR_reg<= (others => '0');
			regs_signal.TX_reg<= (others => '0');
			regs_signal.r_act<=NA;
			shiftcounter_signal<= (others => '0');
			transfer_data_notify <= true;
			TX_pin <= true;
			trans_flags_out<= false;
		 else
		 if section = PARITY then
		  if(baudrate_in = true and TE_flag_trans /= to_unsigned(0,1)) then
                       if(bitcounter_signal mod to_unsigned(2,4) /= 0) then
                          TX_pin <= false;
                       else
                          TX_pin <= true;
                       end if;
                       bitcounter_signal <= to_unsigned(0,4);
                       
                       section<=STOP;
                  
                      elsif(TE_flag_trans = to_unsigned(0,1)) then 
                       TX_shiftreg_signal <= to_unsigned(0,8); 
                          bitcounter_signal <= to_unsigned(0,4); 
                          shiftcounter_signal <= to_unsigned(0,4); 
                          TX_pin <= true;
                          trans_flags_out <= false;  
                          transfer_data_notify <= true;
                       section<=READ_DATA;
                    end if;

		 end if;
		 if section = READ_DATA then
		     if(transfer_data_sync = true) then
                       
         
                       if(transfer_data.r_act = TX_WR and TE_flag_trans /= to_unsigned(0,1)) then
                          section<=START;
                          trans_flags_out <= false;
                          TX_shiftreg_signal <= transfer_data.TX_reg; 
                          transfer_data_notify <= false;             
                       elsif(TE_flag_trans = to_unsigned(0,1)) then 
                          TX_shiftreg_signal <= to_unsigned(0,8); 
                          bitcounter_signal <= to_unsigned(0,4); 
                          shiftcounter_signal <= to_unsigned(0,4); 
                          TX_pin <= true;
                          trans_flags_out <= false;  
                          transfer_data_notify <= true;
                       else
                          transfer_data_notify <= true;
                       end if;
                       
              else
                     section<=READ_DATA;
              end if;

		 end if;
		 if section = SEND then
		   if(baudrate_in = true and TE_flag_trans /= to_unsigned(0,1)) then
                      if(TX_shiftreg_signal(0 downto 0) = to_unsigned(1,1)) then 
                         TX_pin <= true;                
                         bitcounter_signal <= bitcounter_signal + to_unsigned(1,4);
                      else
                         TX_pin<=false;
                      end if;

                         TX_shiftreg_signal <= TX_shiftreg_signal SRL 1; 
                         shiftcounter_signal <= shiftcounter_signal + to_unsigned(1,4);
                         if(shiftcounter_signal >= 7) then
                            shiftcounter_signal <= to_unsigned(0,4);
                            section<=PARITY;
                      
                         end if;
                         

                    elsif(TE_flag_trans = to_unsigned(0,1)) then
                       TX_shiftreg_signal <= to_unsigned(0,8); 
                          bitcounter_signal <= to_unsigned(0,4); 
                          shiftcounter_signal <= to_unsigned(0,4); 
                          TX_pin <= true;
                          trans_flags_out <= false;  
                          transfer_data_notify <= true;
                       section<=READ_DATA;
                    end if;

		 end if;
		 if section = START then
		
		 if(baudrate_in = true and TE_flag_trans /= to_unsigned(0,1)) then
                       TX_pin <= false;
                    
                       section<=SEND;
                    elsif(TE_flag_trans = to_unsigned(0,1)) then
                           TX_shiftreg_signal <= to_unsigned(0,8); 
                          bitcounter_signal <= to_unsigned(0,4); 
                          shiftcounter_signal <= to_unsigned(0,4); 
                          TX_pin <= true;
                          trans_flags_out <= false;  
                          transfer_data_notify <= true;
                       section<=READ_DATA;
                    end if;
		 end if;
		 if section = STOP then
		   if(baudrate_in = true and TE_flag_trans /= to_unsigned(0,1) ) then  
                       
                       TX_pin<=true; 
                       trans_flags_out <= true;
                       transfer_data_notify <= true;
                       section <= READ_DATA;

                    elsif(TE_flag_trans = to_unsigned(0,1)) then
                      TX_shiftreg_signal <= to_unsigned(0,8); 
                          bitcounter_signal <= to_unsigned(0,4); 
                          shiftcounter_signal <= to_unsigned(0,4); 
                          TX_pin <= true;
                          trans_flags_out <= false;  
                          transfer_data_notify <= true;
                        section<=READ_DATA;
                    end if;
		 end if;
		 end if;
	 end if;
	 end process;
end Transmitter_arch;
