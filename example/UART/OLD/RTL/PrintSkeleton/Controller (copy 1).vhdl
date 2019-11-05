library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.C_functions.all;

entity Controller is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	RE_flag_out:		out unsigned(1 downto 0);
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
signal next_section: Controller_SECTIONS;
			 signal init_signal:bool;
			 signal int_en_signal:unsigned(0 downto 0);
			 signal regs2_signal:reg_files;
			 signal regs3_signal:reg_files;
			 signal t_comp_signal:bool;
			 signal uart_in_signal:CUtoME_IF;
			 signal uart_out_signal:MEtoCU_IF;
			 signal tx_send_notify_tmp:bool;
begin
tx_send_notify <= tx_send_notify_tmp;
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if (rst = '1') then
			section <=READ_INPUT;
			next_section <= READ_INPUT;
			init_signal<=false;
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
			uart_in_signal.addrIn<=to_unsigned(99,32);
			uart_in_signal.dataIn<=(others => '0');
			uart_in_signal.mask<=MT_X;
			uart_in_signal.req<=ME_X;
			uart_out_signal.loadedData<=(others => '0');
			interrupt_enabled_notify <= false;
			request_notify <= true;
			response_notify <= false;
			rx_receive_notify <= false;
			tx_send_notify_tmp <= false;
			TE_flag_out <= (others => '0');
			RE_flag_out <= (others => '0');
		 else
		 if (section = OUTPUT) then
		    if(response_sync = true) then
		      uart_in_signal.addrIn <= to_unsigned(99,32);
		      uart_in_signal.dataIn <= to_unsigned(0,32);
		      uart_in_signal.mask   <= MT_X;
		      uart_in_signal.req    <= ME_X;
		      request_notify <= true;
		      section <= READ_INPUT; 
		      response_notify <= false;
		    else
		      section <= OUTPUT; 
		    end if;
		 end if;
		 if section = PROCESS_INPUT then
		 
		   if(tx_send_sync = true AND tx_send_notify_tmp = true) then
		      regs2_signal.r_act <= NA;
		      tx_send_notify_tmp <= false;
		      rx_receive_notify <= true;
		      section <= SERVICE_COMMS;
		   elsif(tx_send_sync = false AND tx_send_notify_tmp = true) then
		      section <= PROCESS_INPUT;
		   else
		      rx_receive_notify <= true;
		      section <= SERVICE_COMMS;
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
	              tx_send_notify_tmp <= true;	      
	          elsif(register_action(request) = CR_WR) then
	              TE_flag_out <= register_CR_command(regs2_signal, request)(0 downto 0);
	              RE_flag_out <= register_CR_command(regs2_signal, request)(1 downto 0) AND to_unsigned(2,2); 
		      end if;
		   else 
		         regs2_signal.CR_reg <= register_CR_command(regs2_signal, uart_in_signal);
		         regs2_signal.SR_reg <= register_SR_command(regs2_signal, uart_in_signal);
		         regs2_signal.TX_reg <= register_TX_command(regs2_signal, uart_in_signal);
		         regs2_signal.r_act  <= register_action(uart_in_signal);   
		   end if;
		       
		   
		    request_notify <= false;
		    
		    section <= PROCESS_INPUT;
		    
		 end if;
		 if (section = SERVICE_COMMS) then
		 
		   if(rx_receive_sync = true) then
		    regs3_signal <= rx_receive;
		   end if;
		   
		   if(rx_receive.r_act = RX_WR AND rx_receive_sync = true) then
		     regs2_signal.RX_reg <= rx_receive.RX_reg;
		     regs3_signal.r_act <= NA;
		   
		   end if;
		   
		   rx_receive_notify <= false;
		 
		   if(uart_in_signal.req = ME_RD) then
		     section <= OUTPUT;
		     response_notify <= true;
		     if(regs2_signal.r_act = CR_RD) then
		       response.loadedData <= regs2_signal.CR_reg;
		       uart_out_signal.loadedData <= regs2_signal.CR_reg;
		     elsif(regs2_signal.r_act = SR_RD) then
		       response.loadedData <= regs2_signal.SR_reg;
		       uart_out_signal.loadedData <= regs2_signal.SR_reg; 
		     elsif(regs2_signal.r_act = RX_RD) then
		        if(rx_receive.r_act = RX_WR AND rx_receive_sync = true) then
		             response.loadedData(31 downto 8) <= to_unsigned(0, 24);
		             uart_out_signal.loadedData(31 downto 8) <= to_unsigned(0, 24);
		             response.loadedData(7 downto 0) <=  rx_receive.RX_reg;
		             uart_out_signal.loadedData(7 downto 0) <= rx_receive.RX_reg;
		        else
		             response.loadedData(31 downto 8) <= to_unsigned(0, 24);
		             uart_out_signal.loadedData(31 downto 8) <= to_unsigned(0, 24);
		             response.loadedData(7 downto 0) <=  regs2_signal.RX_reg;
		             uart_out_signal.loadedData(7 downto 0) <= regs2_signal.RX_reg;
		        end if;
		     else
		       response.loadedData <= to_unsigned(0,32);
		       uart_out_signal.loadedData <= to_unsigned(0,32); 
		     end if;
		     
		   else
		     uart_in_signal.addrIn <= to_unsigned(99,32);
		     uart_in_signal.dataIn <= to_unsigned(0,32);
		     uart_in_signal.mask   <= MT_X;
		     uart_in_signal.req    <= ME_X;
		     request_notify <= true;
		     section <= READ_INPUT;
		   end if;
		 end if;
		 end if;
		
	 end if;
	 end process;
end Controller_arch;


