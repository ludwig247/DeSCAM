library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.baudgen_functions.all;

entity baudgen is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	baudrate_control:		in unsigned(31 downto 0);
	rec_trigger:		out unsigned(31 downto 0);
	rec_trigger_sync:	 in bool;
	rec_trigger_notify:	 out bool;
	trans_trigger:		out unsigned(31 downto 0);
	trans_trigger_sync:	 in bool;
	trans_trigger_notify:	 out bool);
end baudgen;

architecture baudgen_arch of baudgen is
signal section: baudgen_SECTIONS;
			 signal baudcounter_signal:unsigned(31 downto 0);
			 signal baudctrl_signal:unsigned(31 downto 0);
			 signal prescaler_signal:unsigned(31 downto 0);
			 signal trigg_signal:unsigned(31 downto 0);
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=RUN;
			baudcounter_signal<= (others => '0');
			trigg_signal <= (others => '0');
			baudctrl_signal<= (others => '0');
			prescaler_signal<= (others => '0'); --calc_prescaler(baudrate_control, to_unsigned(10000000, 32));
			trans_trigger <= (others => '0'); --trigging(to_unsigned(0,32), calc_prescaler(baudrate_control, to_unsigned(10000000, 32)));
			rec_trigger_notify <= true;
			trans_trigger_notify <= true;
		 else
		 if section = RUN then
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;
end baudgen_arch;
