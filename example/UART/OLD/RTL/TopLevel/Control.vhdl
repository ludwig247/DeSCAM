library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.Control_functions.all;

entity Control is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	Baudrate_control:		out unsigned(31 downto 0);
	Parity_control_RX:		out unsigned(31 downto 0);
	Parity_control_TX:		out unsigned(31 downto 0);
	RE_flag_out:		out unsigned(31 downto 0);
	TE_flag_out:		out unsigned(31 downto 0);
	TX_flags_in:		in tx_flag_values;
	TX_flags_in_sync:	 in bool;
	TX_reg_to_shiftreg:		out tx_data;
	interrupt:		out bool;
	interrupt_notify:	 out bool;
	req_from_mem:		in CUtoME_IF;
	req_from_mem_sync:	 in bool;
	resp_to_mem:		out reg_files;
	shiftreg_to_RX_reg:		in reg_files;
	shiftreg_to_RX_reg_sync:	 in bool);
end Control;

architecture Control_arch of Control is
signal section: Control_SECTIONS;
			 signal regs_signal:reg_files;
			 signal regs2_signal:reg_files;
			 signal req_signal:CUtoME_IF;
			 signal tx_flag_signal:tx_flag_values;
			 signal tx_temp_signal:tx_data;
begin
	 process(clk)
	 
	     variable tx_flags_temp: tx_flag_values;
         variable req_temp: CUtoME_IF;
         variable regs2_temp: reg_files;
         variable regs_temp: reg_files;
         variable tx_temp: tx_data;
         
         
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=RUN;
			regs_signal.CR_reg<= (others => '0');
			regs_signal.DR_reg<= (others => '0');
			regs_signal.SR_reg<= to_unsigned(32,32);
			regs_signal.r_act<=NA;
			regs2_signal.CR_reg<= (others => '0');
			regs2_signal.DR_reg<= (others => '0');
			regs2_signal.SR_reg<= (others => '0');
			regs2_signal.r_act<=NA;
			req_signal.addrIn<= (others => '0');
			req_signal.dataIn<= (others => '0');
			req_signal.mask<=MT_B;
			req_signal.req<=ME_X;
			tx_flag_signal.tc_flag<=NF;
			tx_flag_signal.txe_flag<=NF;
			tx_temp_signal.TX_temp_register<= (others => '0');
			tx_temp_signal.r_act<=CR_RD;
			interrupt_notify <= false;
			Parity_control_RX <= (others => '0');
			Parity_control_TX <= (others => '0');
			Baudrate_control <= (others => '0');
			TE_flag_out <= (others => '0');
			RE_flag_out <= (others => '0');
		 else
		 if section = RUN then
		    
		    regs_temp := regs_signal; 
	
		    
		    if((req_from_mem_sync = false) and (shiftreg_to_RX_reg_sync = false) and (TX_flags_in_sync = false)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_signal);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_signal); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_signal);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_signal);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_signal);
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_TX_flags(tx_flag_signal, regs_temp.SR_reg);
		      tx_temp.r_act := tx_no_action(tx_temp, tx_flag_signal);
		      
		      elsif((req_from_mem_sync = false) and (shiftreg_to_RX_reg_sync = false) and (TX_flags_in_sync = true)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_signal);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_signal); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_signal);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_signal);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_signal);
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg);
		      tx_flag_signal <= TX_flags_in;
		      tx_temp.r_act := tx_no_action(tx_temp, TX_flags_in);
		      
		    elsif((req_from_mem_sync = false) and (shiftreg_to_RX_reg_sync = true) and (TX_flags_in_sync = false)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_signal);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_signal); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_signal);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_signal);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_signal);
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs2_signal <= shiftreg_to_RX_reg;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_TX_flags(tx_flag_signal, regs_temp.SR_reg);
		      tx_temp.r_act := tx_no_action(tx_temp, tx_flag_signal);
		    
		    elsif((req_from_mem_sync = false) and (shiftreg_to_RX_reg_sync = true) and (TX_flags_in_sync = true)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_signal);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_signal); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_signal);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_signal);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_signal);
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs2_signal <= shiftreg_to_RX_reg;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg);
		      tx_flag_signal <= TX_flags_in;
		      tx_temp.r_act := tx_no_action(tx_temp, TX_flags_in);
		      
		    elsif((req_from_mem_sync = true) and (shiftreg_to_RX_reg_sync = false) and (TX_flags_in_sync = false)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_from_mem);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_from_mem); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_from_mem);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_from_mem);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_from_mem);
		      req_signal <= req_from_mem;
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_TX_flags(tx_flag_signal, regs_temp.SR_reg);
		      tx_temp.r_act := tx_no_action(tx_temp, tx_flag_signal);
		      
		    elsif((req_from_mem_sync = true) and (shiftreg_to_RX_reg_sync = false) and (TX_flags_in_sync = true)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_from_mem);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_from_mem); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_from_mem);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_from_mem);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_from_mem);
		      req_signal <= req_from_mem;
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, regs2_signal);
		      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg);
		      tx_flag_signal <= TX_flags_in;
		      tx_temp.r_act := tx_no_action(tx_temp, TX_flags_in);  
		    
		    elsif((req_from_mem_sync = true) and (shiftreg_to_RX_reg_sync = true) and (TX_flags_in_sync = false)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_from_mem);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_from_mem); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_from_mem);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_from_mem);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_from_mem);
		      req_signal <= req_from_mem;
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs2_signal <= shiftreg_to_RX_reg;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_TX_flags(tx_flag_signal, regs_temp.SR_reg);
		      tx_temp.r_act := tx_no_action(tx_temp, tx_flag_signal);  
		      
		    elsif((req_from_mem_sync = true) and (shiftreg_to_RX_reg_sync = true) and (TX_flags_in_sync = true)) then
		      regs_temp.CR_reg := register_CR_command(regs_signal.CR_reg, req_from_mem);
		      regs_temp.SR_reg := register_SR_command(regs_signal.SR_reg, req_from_mem); 
		      regs_temp.DR_reg := register_TX_command(regs_signal.DR_reg, req_from_mem);
		      tx_temp.TX_temp_register := register_TX_command(regs_temp.DR_reg, req_from_mem);
		      tx_temp.r_act := tx_action(tx_temp_signal, req_from_mem);
		      req_signal <= req_from_mem;
		      TX_reg_to_shiftreg.r_act <= tx_temp.r_act;
		      regs2_signal <= shiftreg_to_RX_reg;
		      regs_temp.DR_reg := register_RX_event(regs_temp.DR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_RX_flags(regs_temp.SR_reg, shiftreg_to_RX_reg);
		      regs_temp.SR_reg := manage_TX_flags(TX_flags_in, regs_temp.SR_reg);
		      tx_flag_signal <= TX_flags_in;
		      tx_temp.r_act := tx_no_action(tx_temp, TX_flags_in);	    
		    end if;
		    
		      TE_flag_out <= align_flag(regs_signal.CR_reg, to_unsigned(1, 32));
		      RE_flag_out <= align_flag(regs_signal.CR_reg, to_unsigned(2, 32));
		      Baudrate_control <= align_control(regs_signal.CR_reg, to_unsigned(65536, 32));
		      Parity_control_RX <= align_control(regs_signal.CR_reg, to_unsigned(256, 32));
		      Parity_control_TX <= align_control(regs_signal.CR_reg, to_unsigned(256, 32));
		  
		      TX_reg_to_shiftreg.TX_temp_register <= tx_temp.TX_temp_register;
		      tx_temp_signal.r_act <= tx_temp.r_act;
		      
		      if(check_interrupt(regs_temp.SR_reg, regs_temp.CR_reg) /= to_unsigned(0,32)) then
		       regs_temp.SR_reg := regs_temp.SR_reg OR to_unsigned(2,32);
		       interrupt_notify <= true;
		       interrupt <= true;
		      else
		       interrupt_notify <= false;
		       interrupt <= false;
		      end if;
		      
		      regs_signal <= regs_temp;
		      
		      resp_to_mem <= regs_temp;
		      
		      req_signal.req <= ME_X;
		      regs2_signal.r_act <= NA;
		      tx_flag_signal.txe_flag <= NF;
		      tx_flag_signal.tc_flag <= NF;
		      
		      
		      
		 end if;
		 end if;
	 end if;
	 end process;
end Control_arch;
