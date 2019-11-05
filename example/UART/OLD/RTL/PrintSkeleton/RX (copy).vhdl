library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.RX_functions.all;

entity RX is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	Parity_control_in:		in unsigned(31 downto 0);
	RE_flag_in:		in unsigned(31 downto 0);
	RX_pin:		in bool;
	baudrate_in:		in bool;
	baudrate_in_sync:	 in bool;
	baudrate_in_notify:	 out bool;
	shiftreg_to_RX_reg:		out reg_files;
	shiftreg_to_RX_reg_sync:	 in bool;
	shiftreg_to_RX_reg_notify:	 out bool);
end RX;

architecture RX_arch of RX is
signal section: RX_SECTIONS;
			 signal RE_flag_signal:unsigned(31 downto 0);
			 signal RX_pin_value_signal:bool;
			 signal RX_shiftreg_signal:unsigned(31 downto 0);
			 signal bitcounter_signal:unsigned(31 downto 0);
			 signal par_ctrl_signal:unsigned(31 downto 0);
			 signal regs_signal:reg_files;
			 signal shiftcounter_signal:unsigned(31 downto 0);
			 signal trigg_signal:bool;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=IDLE;
			RE_flag_signal<= (others => '0');
			RX_pin_value_signal<=true;
			RX_shiftreg_signal<= (others => '0');
			bitcounter_signal<= (others => '0');
			par_ctrl_signal<= (others => '0');
			regs_signal.CR_reg<= (others => '0');
			regs_signal.DR_reg<= (others => '0');
			regs_signal.SR_reg<= (others => '0');
			regs_signal.r_act<=NA;
			shiftcounter_signal<= (others => '0');
			trigg_signal<=false;
			shiftreg_to_RX_reg_notify <= false;
		 else
		 if section = IDLE then
		   
		   if(RE_flag_in = to_unsigned(0,32)) then 
		     RX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     regs_signal.SR_reg <= to_unsigned(0,32);
		     regs_signal.r_act <= NA;
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE;
		   else
		     section <= SCAN;
		   end if;
		   
		 end if;
		 if section = PARITY then
		 
		    if(RE_flag_in = to_unsigned(0,32)) then
		     RX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     regs_signal.SR_reg <= to_unsigned(0,32);
		     regs_signal.r_act <= NA;
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE;
		    elsif((RE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true)) then
		      regs_signal.SR_reg <= regs_signal.SR_reg OR parity_check(Parity_control_in, bitcounter_signal, RX_pin);
		      bitcounter_signal <= to_unsigned(0,32);
		      section <= STOP1;
		    end if;
		   
		 end if;
		 if section = RECEIVE then
		 
		   if(RE_flag_in = to_unsigned(0,32)) then 
		     RX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     regs_signal.SR_reg <= to_unsigned(0,32);
		     regs_signal.r_act <= NA;
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE;
		   elsif((RE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true) and (shiftcounter_signal = to_unsigned(7,32))) then
		     if(RX_pin = true) then
		      RX_shiftreg_signal <= RX_shiftreg_signal SRL 1 OR to_unsigned(128,32);
		      bitcounter_signal <= bitcounter_signal + to_unsigned(1,32);
		     else
		      RX_shiftreg_signal <= RX_shiftreg_signal SRL 1 OR to_unsigned(0,32);
		     end if;
		      shiftcounter_signal <= to_unsigned(0,32);
		     if(Parity_control_in /= to_unsigned(0,32)) then
		      section <= PARITY;
		     else
		      section <= STOP1;
		     end if;
		    elsif((RE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true) and (shiftcounter_signal < to_unsigned(7,32))) then
		     if(RX_pin = true) then
		      RX_shiftreg_signal <= RX_shiftreg_signal SRL 1 OR to_unsigned(128,32);
		      bitcounter_signal <= bitcounter_signal + to_unsigned(1,32);
		     else
		      RX_shiftreg_signal <= RX_shiftreg_signal SRL 1 OR to_unsigned(0,32);
		     end if;
		     shiftcounter_signal <= shiftcounter_signal + to_unsigned(1,32);
		    end if;
		    
		  
		   
		 end if;
		 if section = SCAN then
		 if(RE_flag_in = to_unsigned(0,32)) then 
		     RX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     regs_signal.SR_reg <= to_unsigned(0,32);
		     regs_signal.r_act <= NA;
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE;
		   elsif((baudrate_in = true) and (RX_pin = false)) then
		     section <= RECEIVE;
		  end if;
		 end if;
		 if section = STOP1 then
		 
		   if(RE_flag_in = to_unsigned(0,32)) then 
		     RX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     regs_signal.SR_reg <= to_unsigned(0,32);
		     regs_signal.r_act <= NA;
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE;
		   elsif((RE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true)) then
		     regs_signal.DR_reg <= (RX_shiftreg_signal SLL 8) AND to_unsigned(65280,32);
		     regs_signal.SR_reg <= regs_signal.SR_reg OR frame_check(RX_pin) OR to_unsigned(8,32);
		     regs_signal.r_act  <= RX_WR;
		     shiftreg_to_RX_reg.CR_reg <= regs_signal.CR_reg;
		     shiftreg_to_RX_reg.DR_reg <= (RX_shiftreg_signal SLL 8) AND to_unsigned(65280,32);
		     shiftreg_to_RX_reg.SR_reg <= regs_signal.SR_reg OR frame_check(RX_pin) OR to_unsigned(8,32);
		     shiftreg_to_RX_reg.r_act  <= RX_WR;
		     shiftreg_to_RX_reg_notify <= true;
		     section <= STOP2;
		   end if;
		 
		 end if;
		   
		   if section = STOP2 then
		     RX_shiftreg_signal <= to_unsigned(0,32);
		     regs_signal.SR_reg <= to_unsigned(0,32);
		     regs_signal.r_act <= NA;
		     section <= SCAN;
		     shiftreg_to_RX_reg_notify <= false;
		   end if;
		  
		 end if;
	 end if;
	 end process;
end RX_arch;
