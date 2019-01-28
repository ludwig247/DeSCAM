library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity Interconnect is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	master_in:		in master_signals;
	master_out:		out slave_signals;
	slave_in0:		in slave_signals;
	slave_in1:		in slave_signals;
	slave_in2:		in slave_signals;
	slave_in3:		in slave_signals;
	slave_out0:		out master_signals;
	slave_out1:		out master_signals;
	slave_out2:		out master_signals;
	slave_out3:		out master_signals);
end Interconnect;


architecture Interconnect_arch of Interconnect is
signal section: Interconnect_SECTIONS;
			 signal from_master_signal:master_signals;
			 signal to_master_signal:slave_signals;
			 signal slave_number_signal:int;
			 signal helper:int;
begin	

	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=IDLE;
			from_master_signal.addr<=0;
			from_master_signal.cyc<=false;
			from_master_signal.data<=0;
			from_master_signal.stb<=false;
			from_master_signal.we<=false;
			to_master_signal.ack<=false;
			to_master_signal.data<=0;
			to_master_signal.err<=false;
			slave_number_signal <= 0;
			master_out <= slave_signals_default;
			slave_out0 <= master_signals_default;
			slave_out1 <= master_signals_default;
			slave_out2 <= master_signals_default;
			slave_out3 <= master_signals_default;
			helper <= 0;
		 else
		 if section = DONE then
			if(helper = 0) then
				from_master_signal <= master_in;
				helper <= 1;
			elsif(helper = 1) then
				master_out <= to_master_signal;
				if(not(from_master_signal.cyc) and not(from_master_signal.stb)) then
					to_master_signal.ack <= false;
					to_master_signal.data <= 0;
					to_master_signal.err <= false;
					master_out.ack <= false;
					master_out.data <= 0;
					master_out.err <= false;
					helper <= 2;
				else 
					helper <= 0;
				end if;
			else 	
				helper <= 0;
				section <= IDLE;
			end if;
		 end if;
		 if section = IDLE then
			from_master_signal <= master_in;
			if(master_in.cyc and master_in.stb) then
				if( master_in.addr >= 0 and master_in.addr <= 7) then
					section <= START;
					from_master_signal <= master_in;
					slave_out0 <= master_in;
					slave_number_signal <= 0;
				elsif(master_in.addr >= 8 and master_in.addr <= 15) then
					section <= START;
					from_master_signal <= master_in;
					from_master_signal.addr <= master_in.addr - 8;
					slave_out1 <= master_in;
					slave_out1.addr <= master_in.addr - 8;
					slave_number_signal <= 1;
				elsif(master_in.addr >= 16 and master_in.addr <= 23) then
					section <= START;
					from_master_signal <= master_in;
					from_master_signal.addr <= master_in.addr - 16;
					slave_out2 <= master_in;
					slave_out2.addr <= master_in.addr - 16; 
					slave_number_signal <= 2;
				elsif(master_in.addr >= 24 and master_in.addr <= 31) then
					section <= START;
					from_master_signal <= master_in;
					from_master_signal.addr <= master_in.addr - 24;
					slave_out3 <= master_in;
					slave_out3.addr <= master_in.addr - 24; 
					slave_number_signal <= 3;
				else 
					section <= DONE;
					to_master_signal <= slave_signals_default;
					to_master_signal.ack <= true;
					master_out <= slave_signals_default;
					master_out.ack <= true;
				end if;		
			end if; 
			
		 end if;
		 if section = START then
			from_master_signal <= master_signals_default;
			section <= TRANSMITTING;
			
		 -- FILL OUT HERE;
		 end if;
		 if section = TRANSMITTING then
			if(slave_number_signal = 0) then 
				if(helper = 0) then
				    to_master_signal <= slave_in0;
				end if;
				if(slave_in0.ack and helper = 0) then
					slave_out0 <= from_master_signal;
					helper <= 1;
				elsif(helper = 1) then
					master_out <= to_master_signal;
					helper <= 0;
					section <= DONE;
				end if;
			elsif(slave_number_signal = 1) then 
				if(helper = 0) then
				    to_master_signal <= slave_in1;
				end if;

				if(slave_in1.ack and helper = 0) then
					slave_out1 <= from_master_signal;
					helper <= 1;
				elsif(helper = 1) then
					master_out <= to_master_signal;
					helper <= 0;
					section <= DONE;
				end if;
			elsif(slave_number_signal = 2) then 
				if(helper = 0) then
				    to_master_signal <= slave_in2;
				end if;
				if(slave_in2.ack and helper = 0) then
					slave_out2 <= from_master_signal;
					helper <= 1;
				elsif(helper = 1) then
					master_out <= to_master_signal;
					helper <= 0;
					section <= DONE;
				end if;
			elsif(slave_number_signal = 3) then 
				if(helper = 0) then
				    to_master_signal <= slave_in3;
				end if;				
				if(slave_in3.ack and helper = 0) then
					slave_out3 <= from_master_signal;
					helper <= 1;
				elsif(helper = 1) then
					master_out <= to_master_signal;
					helper <= 0;
					section <= DONE;
				end if;
			end if;
		 end if;
		 end if;
	 end if;
	 end process;
end Interconnect_arch;