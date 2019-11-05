library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.Control_functions.all;

entity Control is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	Baudrate_control:		out unsigned(1 downto 0);
	Parity_control_RX:		out unsigned(1 downto 0);
	Parity_control_TX:		out unsigned(1 downto 0);
	RE_flag_out:		out unsigned(0 downto 0);
	TE_flag_out:		out unsigned(0 downto 0);
	TX_flags_in:		in tx_flag_values;
	TX_flags_in_sync:	 in bool;
	TX_flags_in_notify:	 out bool;
	TX_reg_to_shiftreg:		out tx_data;
	TX_reg_to_shiftreg_sync:	 in bool;
	TX_reg_to_shiftreg_notify:	 out bool;
	interrupt:		out bool;
	interrupt_sync:	 in bool;
	interrupt_notify:	 out bool;
	req_from_mem:		in CUtoME_IF;
	req_from_mem_sync:	 in bool;
	req_from_mem_notify:	 out bool;
	resp_to_mem:		out reg_files;
	resp_to_mem_sync:	 in bool;
	resp_to_mem_notify:	 out bool;
	shiftreg_to_RX_reg:		in reg_files;
	shiftreg_to_RX_reg_sync:	 in bool;
	shiftreg_to_RX_reg_notify:	 out bool);
end Control;

architecture Control_arch of Control is
signal section: Control_SECTIONS;
			 signal regs_signal:reg_files;
			 signal regs2_signal:reg_files;
			 signal req_signal:CUtoME_IF;
			 signal tx_flag_signal:tx_flag_values;
			 signal tx_temp_signal:tx_data;
                         signal interrupt_notify_tmp:bool;
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
			 section <= RUN;
			regs_signal.CR_reg<= (others => '0');
			regs_signal.DR_reg<= (others => '0');
			regs_signal.SR_reg <= to_unsigned(32,32);
			regs_signal.r_act<=NA;
			regs2_signal.CR_reg<= (others => '0');
			regs2_signal.DR_reg<=(others => '0');
			regs2_signal.SR_reg<=(others => '0');
			regs2_signal.r_act<=NA;
			req_signal.addrIn<=(others => '0');
			req_signal.dataIn<=(others => '0');
			req_signal.mask<=MT_B;
			req_signal.req<=ME_X;
			tx_flag_signal.tc_flag<=NF;
			tx_flag_signal.txe_flag<=NF;
			tx_temp_signal.TX_temp_register<=(others => '0');
			tx_temp_signal.r_act<=CR_RD;
			TX_flags_in_notify <= false;
			TX_reg_to_shiftreg_notify <= false;
			interrupt_notify <= false;
			req_from_mem_notify <= true;
			resp_to_mem_notify <= false;
			shiftreg_to_RX_reg_notify <= false;
                        RE_flag_out <= to_unsigned(0,1);
                        TE_flag_out <= to_unsigned(0,1);
                        Baudrate_control <= to_unsigned(0,2);
                        Parity_control_RX <= to_unsigned(0,2);
                        Parity_control_TX <= to_unsigned(0,2);
		 else
		 if section = RUN then

                   if(req_from_mem_sync) then
                     req_temp := req_from_mem;
                     req_signal.addrIn <= req_from_mem.addrIn;
                     req_signal.dataIn <= req_from_mem.dataIn;
                     req_signal.mask <= req_from_mem.mask;
                   else
                     req_temp := req_signal;
                   end if;
              
                   if(shiftreg_to_RX_reg_sync = true) then
                    regs2_temp := shiftreg_to_RX_reg;
                    regs2_signal.CR_reg <= shiftreg_to_RX_reg.CR_reg;
                    regs2_signal.SR_reg <= shiftreg_to_RX_reg.SR_reg;
                    regs2_signal.DR_reg <= shiftreg_to_RX_reg.DR_reg;
                   else 
                    regs2_temp := regs2_signal;
                   end if;

                   if(TX_flags_in_sync = true) then
                      tx_flags_temp := TX_flags_in;
                   --   tx_flag_signal <= TX_flags_in;
                   else
                      tx_flags_temp := tx_flag_signal;
                   end if;
                  
               --    regs_temp.CR_reg := register_CR_command(regs_signal, req_temp);
               --    regs_temp.SR_reg := register_SR_command(regs_signal, req_temp);
                --   regs_temp.DR_reg := register_TX_command(regs_signal, req_temp);
                   tx_temp.TX_temp_register := register_TX_command(regs_signal, req_temp);
                   tx_temp.r_act := tx_action(tx_temp_signal, req_temp);

                   Baudrate_control <= align_control(regs_signal.CR_reg, to_unsigned(1024, 32));
                   Parity_control_RX <= align_control(regs_signal.CR_reg, to_unsigned(256, 32));
                   Parity_control_TX <= align_control(regs_signal.CR_reg, to_unsigned(256, 32));
                   TE_flag_out <= align_flag(regs_signal.CR_reg, to_unsigned(1, 32));
                   RE_flag_out <= align_flag(regs_signal.CR_reg,to_unsigned(2, 32));
                    
                   regs_temp.DR_reg := register_RX_event(regs_signal, regs2_temp);
               --     regs_temp.SR_reg := manage_RX_flags(regs_signal, regs2_temp);
                    regs_temp.SR_reg := manage_TX_flags(tx_flags_temp, regs_signal);


                   TX_reg_to_shiftreg <= tx_temp;
                   TX_reg_to_shiftreg_notify <= true;
		
                   
                   tx_temp.r_act := tx_no_action(tx_temp, tx_flags_temp);

                   tx_temp_signal <= tx_temp;

              --     if(check_interrupt((regs_signal.CR_reg, regs_signal.DR_reg, regs_temp.SR_reg, regs_signal.r_act)) /= 0) then
              --      regs_temp.SR_reg(1 downto 1) := to_unsigned(1,1);
              --      interrupt <= true;
              --      interrupt_notify <= true;
              --     else
              --      interrupt_notify <= false;
              --      interrupt <= false;
              --     end if;

                  
        
                   resp_to_mem.CR_reg <= regs_signal.CR_reg; -- regs_temp.CR_reg;
                   resp_to_mem.SR_reg <= regs_temp.SR_reg;
                   resp_to_mem.DR_reg <= regs_temp.DR_reg;
                   resp_to_mem.r_act <= regs_signal.r_act;
              --     regs_signal.CR_reg <= regs_temp.CR_reg;
                   regs_signal.SR_reg <= regs_temp.SR_reg;
                   regs_signal.DR_reg <= regs_temp.DR_reg;
                   resp_to_mem_notify <= true;
             



		 end if;
		
		 end if;
	 end if;
	 end process;
end Control_arch;
