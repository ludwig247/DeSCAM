library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity baudgen is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	baudrate_control:		in unsigned(31 downto 0);
	rec_trigger:		out bool;
	trans_trigger:		out bool);
end baudgen;

architecture baudgen_arch of baudgen is
signal section: baudgen_SECTIONS;
			 signal baudcounter_signal:unsigned(31 downto 0);
			 signal trigg_signal:bool;
begin
	 
	
		 
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <= INIT;
			baudcounter_signal<= (others => '0');		
			trigg_signal <= false;
			rec_trigger <= false;
			trans_trigger <= false;
		 else
		 
		 if section = INIT then
		    
		    if((baudrate_control AND to_unsigned(65535,32)) = to_unsigned(0,32)) then
		     trigg_signal <= true;
		     baudcounter_signal <= to_unsigned(0,32);
		     else
		     baudcounter_signal <= to_unsigned(1,32);
		    end if;
		   section <= RUN;
		 end if;
		 
		 if section = RUN then

		    rec_trigger <= trigg_signal;
		    trans_trigger <= trigg_signal;
		    
		   if(baudcounter_signal = (baudrate_control AND to_unsigned(65535, 32))) then
		    trigg_signal <= true;
		    baudcounter_signal <= to_unsigned(0,32);
		   else
		    baudcounter_signal <= baudcounter_signal + to_unsigned(1, 32);
		    trigg_signal <= false;
		    end if;
		 
		 
		 end if;
		 end if;
	 end if;
	 end process;
end baudgen_arch;
