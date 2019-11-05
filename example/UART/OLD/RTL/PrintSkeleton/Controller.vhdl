library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.C_functions.all;

entity Controller is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	RE_flag_out:		out unsigned(0 downto 0);
	TE_flag_out:		out unsigned(0 downto 0);
	interrupt_enabled:		out bool;
	interrupt_enabled_sync:	 in bool;
	interrupt_enabled_notify:	 out bool;
	request:		in CUtoME_IF;
	request_sync:	 in bool;
	request_notify:	 out bool;
	response:		out MEtoCU_IF;
	response_sync:	 in bool;
	response_notify:	 out bool;
	rx_receive:		in reg_files;
	rx_receive_sync:	 in bool;
	rx_receive_notify:	 out bool;
	trans_flags_in:		in bool;
	tx_send:		out reg_files;
	tx_send_sync:	 in bool;
	tx_send_notify:	 out bool);
end Controller;

architecture Controller_arch of Controller is
signal section: Controller_SECTIONS;
			 signal int_en_signal:unsigned(0 downto 0);
			 signal regs2_signal:reg_files;
			 signal regs3_signal:reg_files;
			 signal t_comp_signal:bool;
			 signal uart_in_signal:CUtoME_IF;
			 signal uart_out_signal:MEtoCU_IF;
			 signal response_notify_tmp:bool;
begin
response_notify <= response_notify_tmp;

	 process(clk)
	 
	 variable regs_temp: reg_files;
	 variable RX_temp: unsigned(7 downto 0);
	 variable SR_temp: unsigned(31 downto 0);
	 
	 begin
	 if(clk='1' and clk'event) then
		 if (rst = '1') then
			section <=READ_INPUT;
			int_en_signal<= (others => '0');
			regs2_signal.CR_reg<=(others => '0');
			regs2_signal.RX_reg<=(others => '0');
			regs2_signal.SR_reg<= to_unsigned(32,32);
			regs2_signal.TX_reg<=(others => '0');
			regs2_signal.r_act<=CR_RD;
			regs3_signal.CR_reg<=(others => '0');
			regs3_signal.RX_reg<=(others => '0');
			regs3_signal.SR_reg<=(others => '0');
			regs3_signal.TX_reg<=(others => '0');
			regs3_signal.r_act<=CR_RD;
			t_comp_signal<=false;
			uart_in_signal.addrIn<=(others => '0');
			uart_in_signal.dataIn<=(others => '0');
			uart_in_signal.mask<=MT_X;
			uart_in_signal.req<=ME_X;
			uart_out_signal.loadedData<=(others => '0');
			interrupt_enabled_notify <= false;
			request_notify <= true;
			response_notify_tmp <= false;
			rx_receive_notify <= false;
			tx_send_notify <= false;
			TE_flag_out <= (others => '0');
			RE_flag_out <= (others => '0');
		 else
		 if (section = OUTPUT) then
		   
		   if(response_sync = false AND response_notify_tmp = true) then
		      section <= OUTPUT;
		    else
		      uart_in_signal.mask   <= MT_X;
		      uart_in_signal.req    <= ME_X;
		      request_notify <= true;
		      section <= READ_INPUT;  
		    end if;
		 end if;
		 if (section = SEND) then
		 
		   if(tx_send_sync = true) then
		     section <= SERVICE_COMMS;
		     regs2_signal.r_act <= NA;
		     rx_receive_notify <= true;
		     tx_send_notify <= false;
		     response_notify_tmp <= false;
		   else
		     section <= SEND;
		   end if;
		
		  
		 end if;
		 if (section = READ_INPUT) then
		    
		   if(request_sync = true) then
		         uart_in_signal <= request;
		         regs2_signal.CR_reg <= register_CR_command(regs2_signal, request);
		         regs2_signal.SR_reg <= register_SR_command(regs2_signal, request);
		         regs2_signal.TX_reg <= register_TX_command(regs2_signal, request);
		         regs2_signal.r_act  <= register_action(request);
		    
		
		      if(register_action(request) = TX_WR) then
		          tx_send.CR_reg <= register_CR_command(regs2_signal, request);
		          tx_send.SR_reg <= register_SR_command(regs2_signal, request);
		          tx_send.RX_reg <= regs2_signal.RX_reg;
		          tx_send.TX_reg <= register_TX_command(regs2_signal, request);
		          tx_send.r_act  <= TX_WR;
	              tx_send_notify <= true;	      
	              section <= SEND;
	          else
	              rx_receive_notify <= true;
	              section <= SERVICE_COMMS;
		      end if;
		   else 
		         regs2_signal.CR_reg <= register_CR_command(regs2_signal, uart_in_signal);
		         regs2_signal.SR_reg <= register_SR_command(regs2_signal, uart_in_signal);
		         regs2_signal.TX_reg <= register_TX_command(regs2_signal, uart_in_signal);
		         regs2_signal.r_act  <= register_action(uart_in_signal); 
		         section <= SERVICE_COMMS;  
		         rx_receive_notify <= true;
		   end if;
		       
		    TE_flag_out <= get_flag(regs2_signal.CR_reg, to_unsigned(1,32));
	        RE_flag_out <= get_flag(regs2_signal.CR_reg, to_unsigned(2,32));
		   
		    request_notify <= false;
		    
		    
		    
		 end if;
		 if (section = SERVICE_COMMS) then
		 
		 
		     regs_temp := regs2_signal;
		     if(rx_receive_sync = true) then
		       regs3_signal <= rx_receive;
		     regs_temp.RX_reg := register_RX_event(regs2_signal, rx_receive);
		     regs_temp.SR_reg := register_SR_event(trans_flags_in, regs_temp, rx_receive);
		     else
		     regs_temp.RX_reg := register_RX_event(regs2_signal, regs3_signal);
		     regs_temp.SR_reg := register_SR_event(trans_flags_in, regs_temp, regs3_signal);
		     end if;
		     
		     
	
		   

uart_out_signal.loadedData <= response_data(regs_temp);
		     if(uart_in_signal.req = ME_RD) then
		     
		     response.loadedData <= response_data(regs_temp);
		     response_notify_tmp <= true;
		     end if;
		      		
		     regs2_signal.RX_reg <= regs_temp.RX_reg; --register_RX_event(regs2_signal, rx_receive);
		     regs2_signal.SR_reg <= clear_SR_flags(regs_temp);
		     --regs2_signal.SR_reg <= clear_SR_flags(
		                --                           (regs2_signal.CR_reg, 		                                           		                                          
		                  --                          register_RX_event(regs2_signal, rx_receive), 		                                           		                                       
		                    --                        register_SR_event( trans_flags_in,		                                                             
		                      --                                        (regs2_signal.CR_reg, 		                                                              
		                        --                                       register_RX_event(regs2_signal, rx_receive), 		                                                              
		                          --                                     regs2_signal.SR_reg,		                                                              
		                            --                                   regs2_signal.TX_reg,		                                                              
		                              --                                 regs2_signal.r_act) , rx_receive), 		                                           
		                                --           regs2_signal.TX_reg,		                                           
		                                  --         regs2_signal.r_act)
		                                    --       );
		     

		     
		  
		  
		     regs3_signal.r_act <= NA;
		     rx_receive_notify <= false;
		    
		     section <= OUTPUT;
		   
		 end if;
		 end if;
		
	 end if;
	 end process;
end Controller_arch;

