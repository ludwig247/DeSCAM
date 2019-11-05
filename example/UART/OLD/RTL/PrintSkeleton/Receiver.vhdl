library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Receiver is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	RE_flag_rec:		in unsigned(0 downto 0);
	RX_pin:		in bool;
	baudrate_in:		in bool;
	receive_data:		out reg_files;
	receive_data_sync:	 in bool;
	receive_data_notify:	 out bool);
end Receiver;

architecture Receiver_arch of Receiver is
signal section: Receiver_SECTIONS;
			 signal RX_pin_trigger_signal:bool;
			 signal RX_shiftreg_signal:unsigned(7 downto 0);
			 signal bitcounter_signal:unsigned(3 downto 0);
			 signal regs_signal:reg_files;
			 signal shiftcounter_signal:unsigned(3 downto 0);
			 signal trigg_signal:bool;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=IDLE;
			RX_shiftreg_signal<= (others => '0');
			bitcounter_signal<=(others => '0');
			regs_signal.CR_reg<=(others => '0');
			regs_signal.RX_reg<=(others => '0');
			regs_signal.SR_reg<=(others => '0');
			regs_signal.TX_reg<=(others => '0');
			regs_signal.r_act<=NA;
			shiftcounter_signal<=(others => '0');
			uart_in_signal.addrIn<=(others => '0');
			uart_in_signal.dataIn<=(others => '0');
			uart_in_signal.mask <= MT_X;
			uart_in_signal.req <= ME_X;
			uart_out_signal.loadedData <= (others => '0'); 
			receive_data_notify <= false;
			interrupt_enabled_notify <= false;
	        request_notify <= true;
	        response_notify <= false;
	        rx_receive_notify <= false;
	        tx_send_notify <= false;
		 else
		 if section = IDLE then
		
                 if(RE_flag_rec /= to_unsigned(0,1)) then
                    section<=SCAN; 
                 else
                    RX_shiftreg_signal <= to_unsigned(0,8);
                    bitcounter_signal <= to_unsigned(0,4);
                    shiftcounter_signal <=  to_unsigned(0,4);
                    regs_signal.r_act <= NA;
                    regs_signal.SR_reg <= to_unsigned(0,32);
                 end if;

           
		 end if;
	
		 if section = PARITY then
		    if(baudrate_in AND RE_flag_rec /= to_unsigned(0,1)) then
		       
		       if((RX_pin = true) AND ((bitcounter_signal MOD to_unsigned(2,4)) /= to_unsigned(0,4))) then
		          regs_signal.SR_reg <= regs_signal.SR_reg OR to_unsigned(64,32);
		       end if;
		       if((RX_pin = false) AND ((bitcounter_signal MOD to_unsigned(2,4)) = to_unsigned(0,4))) then
		          regs_signal.SR_reg <= regs_signal.SR_reg OR to_unsigned(64,32);
		       end if;
		       
		       bitcounter_signal <= to_unsigned(0,4);
		        section<=STOP;
		    elsif(RE_flag_rec = to_unsigned(0,1)) then
		          RX_shiftreg_signal <= to_unsigned(0,8);
                  bitcounter_signal <= to_unsigned(0,4);
                  shiftcounter_signal <=to_unsigned(0,4);
                  regs_signal.r_act <= NA;
                  regs_signal.SR_reg <= to_unsigned(0,32);  
		        section<=IDLE;
		    end if;
		 
		
		 end if;
		 if section = RECEIVE then
		 
		 
		  if(baudrate_in = true AND RE_flag_rec /= to_unsigned(0,1)) then
		      
		      shiftcounter_signal<= shiftcounter_signal + to_unsigned(1,4);
		     
		      
		      if(RX_pin = true) then
		         bitcounter_signal<= bitcounter_signal + to_unsigned(1,4);
		         RX_shiftreg_signal <= RX_shiftreg_signal SRL 1 OR to_unsigned(128,8);
		      else 
		         RX_shiftreg_signal <= RX_shiftreg_signal SRL 1 OR to_unsigned(0,8);
		      end if;
		     
		    
		      
		      if(shiftcounter_signal >= to_unsigned(7,4)) then
		         section<=PARITY;
		         shiftcounter_signal <= to_unsigned(0,4);
		      end if;
		   elsif(RE_flag_rec = to_unsigned(0,1)) then 
		          RX_shiftreg_signal <= to_unsigned(0,8);
                  bitcounter_signal <= to_unsigned(0,4);
                  shiftcounter_signal <= to_unsigned(0,4);
                  regs_signal.r_act <= NA;
                  regs_signal.SR_reg <= to_unsigned(0,32);  
		      section<=IDLE;
		   end if;
		    
		    
		 end if;
		 if section = SCAN then
		 
		 if(baudrate_in = true AND RX_pin = false) then

		       section <= RECEIVE;
		    else
		       section <= IDLE;
		    end if;
		    
		 end if;
		 if section = STOP then
		    if(baudrate_in = true AND RE_flag_rec /= to_unsigned(0,1) ) then
		      
		     
		     if(RX_pin = false) then
		        regs_signal.SR_reg <= regs_signal.SR_reg OR to_unsigned(136,32);
		        receive_data.SR_reg <= regs_signal.SR_reg OR to_unsigned(136,32); 
		     else
		        regs_signal.SR_reg <= regs_signal.SR_reg OR to_unsigned(8,32);
		        receive_data.SR_reg <= regs_signal.SR_reg OR to_unsigned(8,32); 
		     end if;
		      
		     regs_signal.r_act <= RX_WR;
		     regs_signal.RX_reg <= RX_shiftreg_signal;
		     receive_data.RX_reg <= RX_shiftreg_signal;
		     receive_data.TX_reg <= regs_signal.TX_reg;
		     receive_data.CR_reg <= regs_signal.CR_reg;
		     receive_data.r_act <= RX_WR;
		     
              receive_data_notify <= true;
		     
		       section<=WRITE_DATA;
		     elsif(RE_flag_rec = to_unsigned(0,1)) then 
		         RX_shiftreg_signal <= to_unsigned(0,8);
                  bitcounter_signal <= to_unsigned(0,4);
                  shiftcounter_signal <= to_unsigned(0,4);
                  regs_signal.r_act <= NA;
                  regs_signal.SR_reg <= to_unsigned(0,32);  
		         section<=IDLE;
		     end if;    
		    
		 end if;
		 if section = WRITE_DATA then
		   if(receive_data_sync = true) then
                        receive_data_notify <= false;
                        regs_signal.SR_reg <= to_unsigned(0,32);
                        RX_shiftreg_signal <= to_unsigned(0,8);
                        regs_signal.r_act <= NA;
                        section <= IDLE;     
              else
                   section <= WRITE_DATA;                
              end if;
		 end if;
		 end if;
	 end if;
	 end process;
end Receiver_arch;
