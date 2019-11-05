library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity baudgen is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	baudrate_control:       in unsigned(15 downto 0);
        TE_flag:                in unsigned(0 downto 0);
        RE_flag:                in unsigned(0 downto 0);
	rec_trigger:		out std_logic;
	trans_trigger:		out std_logic
	);
end baudgen;

architecture baudgen_arch of baudgen is

			signal re_cnt:unsigned(15 downto 0);
			signal te_cnt:unsigned(15 downto 0);
begin
	 
	
		 
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
            re_cnt <= to_unsigned(0, 16);
            te_cnt <= to_unsigned(0, 16);			
			rec_trigger <= '0';
			trans_trigger <= '0';
		 else
		 
	     if(TE_flag = to_unsigned(1,1)) then
		    if(te_cnt = baudrate_control) then
			   te_cnt <= to_unsigned(0,16);
			   trans_trigger <= '1'; 
			else
			    te_cnt <= te_cnt + to_unsigned(1,16);
			    trans_trigger <= '0';
			end if;
		 else
		    te_cnt <= to_unsigned(0,16);
		    trans_trigger <= '0';
		 end if;
	
	     if(RE_flag = to_unsigned(1,1)) then
		    if(re_cnt = baudrate_control) then
			   re_cnt <= to_unsigned(0,16);
			   rec_trigger <= '1'; 
			else
			    re_cnt <= re_cnt + to_unsigned(1,16);
			    rec_trigger <= '0';
			end if;
		 else
		    re_cnt <= to_unsigned(0,16);
		    rec_trigger <= '0';
		 end if;	
		

		
		 end if;
	 end if;
	 end process;
end baudgen_arch;
