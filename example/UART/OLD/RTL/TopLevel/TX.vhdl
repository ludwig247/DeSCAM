library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.TX_functions.all;

entity TX is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	Parity_control_in:		in unsigned(31 downto 0);
	TE_flag_in:		in unsigned(31 downto 0);
	TX_flags_out:		out tx_flag_values;
	TX_flags_out_notify:	 out bool;
	TX_pin:		out bool;
	TX_reg_to_shiftreg:		in tx_data;
	baudrate_in:		in bool);
end TX;

architecture TX_arch of TX is
signal section: TX_SECTIONS;
			 signal TE_flag_signal:unsigned(31 downto 0);
			 signal TX_shiftreg_signal:unsigned(31 downto 0);
			 signal bitcounter_signal:unsigned(31 downto 0);
			 signal par_ctrl_signal:unsigned(31 downto 0);
			 signal regs_signal:tx_data;
			 signal shiftcounter_signal:unsigned(31 downto 0);
			 signal trigg_signal:bool;
			 signal tx_flag_signal:tx_flag_values;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=IDLE1;
			TE_flag_signal<= (others => '0');
			TX_shiftreg_signal<= (others => '0');
			bitcounter_signal<= (others => '0');
			par_ctrl_signal<= (others => '0');
			regs_signal.TX_temp_register<= (others => '0');
			regs_signal.r_act<=CR_RD;
			shiftcounter_signal<= (others => '0');
			trigg_signal<=false;
			tx_flag_signal.tc_flag<=NF;
			tx_flag_signal.txe_flag<=NF;
			TX_flags_out_notify <= false;
			TX_pin <= true;
		 else
		 if section = IDLE1 then
		   regs_signal <= TX_reg_to_shiftreg;
		   
		   if(TE_flag_in = to_unsigned(0,32)) then
		     TX_pin <= true;
		     TX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE1;
		   elsif((TE_flag_in /= to_unsigned(0,32)) and (TX_reg_to_shiftreg.r_act = TX_WR)) then
		     TX_flags_out.tc_flag <= RESET;
		     TX_flags_out.txe_flag <= SET;
		     TX_flags_out_notify <= true;
		     section <= IDLE2;
		   end if;
		   
		 end if;
		 if section = IDLE2 then
		   TX_shiftreg_signal <= regs_signal.TX_temp_register;
		   TX_flags_out_notify <= false;
		   section <= START;
		 end if;
		 if section = PARITY then
		   if(TE_flag_in = to_unsigned(0,32)) then
		     TX_pin <= true;
		     TX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE1;
		    elsif((TE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true)) then
		      if(parity_bit(Parity_control_in, bitcounter_signal) /= to_unsigned(0,32)) then
		       TX_pin <= true;
		      else
		       TX_pin <= false;
		      end if;
		      bitcounter_signal <= to_unsigned(0,32);
		      section <= STOP1;
		   end if;
		 end if;
		 if section = SEND then
		   if(TE_flag_in = to_unsigned(0,32)) then
		     TX_pin <= true;
		     TX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE1;
		    elsif((TE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true) and (shiftcounter_signal = to_unsigned(7,32))) then
		      if((TX_shiftreg_signal and to_unsigned(1,32)) /= to_unsigned(0,32)) then
		        TX_pin <= true;
		        bitcounter_signal <= bitcounter_signal + to_unsigned(1,32);
		      else
		        TX_pin <= false;
		      end if;
		      shiftcounter_signal <= to_unsigned(0,32);
		      TX_shiftreg_signal <= TX_shiftreg_signal SRL 1;
		      if(Parity_control_in /= to_unsigned(0,32)) then
		       section <= PARITY;
		      else
		       section <= STOP1;
		      end if;
		    elsif((TE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true) and (shiftcounter_signal < to_unsigned(7,32))) then  
		       if((TX_shiftreg_signal and to_unsigned(1,32)) /= to_unsigned(0,32)) then
		        TX_pin <= true;
		        bitcounter_signal <= bitcounter_signal + to_unsigned(1,32);
		      else
		        TX_pin <= false;
		      end if;
		        shiftcounter_signal <= shiftcounter_signal + to_unsigned(1,32);
		        TX_shiftreg_signal <= TX_shiftreg_signal SRL 1;
		   end if;
		 end if;
		 if section = START then
           if(TE_flag_in = to_unsigned(0,32)) then
		     TX_pin <= true;
		     TX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE1;
		   elsif((TE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true)) then
		     TX_pin <= false;
		     section <= SEND;
		   end if;
		 end if;
		 if section = STOP1 then
		   if(TE_flag_in = to_unsigned(0,32)) then
		     TX_pin <= true;
		     TX_shiftreg_signal <= to_unsigned(0,32);
		     bitcounter_signal <= to_unsigned(0,32);
		     shiftcounter_signal <= to_unsigned(0,32);
		     section <= IDLE1;
		    elsif((TE_flag_in /= to_unsigned(0,32)) and (baudrate_in = true)) then
		      TX_pin <= true;
		      TX_flags_out.tc_flag <= SET;
		      TX_flags_out.txe_flag <= NF;
		      TX_flags_out_notify <= true;
		      section <= STOP2;
		   end if;
		 end if;
		 if section = STOP2 then
		    TX_flags_out_notify <= false;
		    section <= IDLE1;
		 end if;
		 end if;
	 end if;
	 end process;
end TX_arch;
