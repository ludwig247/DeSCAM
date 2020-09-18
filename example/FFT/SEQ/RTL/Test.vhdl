library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use IEEE.Fixed_Pkg.all;
use work.top_level_types.all;


entity Test is
port(	
	clk:			in std_logic;
	rst:			in std_logic;
	data1_in:		in ufixed(7 downto -8);
	data2_in:		in ufixed(7 downto -8);
	data_out:		out ufixed(7 downto -8)
);
end Test;

architecture Test_arch of Test is

begin


	process(clk)


	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			data_out <= "0000000000000000";
		else
		
			data_out <= resize(data1_in + data2_in, data_out'high, data_out'low);
		end if;
			 

	end if;

	end process;

end Test_arch;