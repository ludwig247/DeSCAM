library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
--use IEEE.Fixed_Pkg.all;
use work.top_level_types.all;


entity Test_self is
port(	
	clk:			in std_logic;
	rst:			in std_logic;
	data1_in:		in std_logic_vector(15 downto 0);
	data2_in:		in std_logic_vector(15 downto 0);
	data_out:		out std_logic_vector(15 downto 0)
);
end Test_self;

architecture Test_arch of Test_self is

	function add_fixed(a : std_logic_vector ; b : std_logic_vector) 
	return std_logic_vector is

		variable a_upper 		: std_logic_vector(8 downto 0) := b"0" & a(15 downto 8);
		variable a_lower 		: std_logic_vector(8 downto 0) := b"0" & a(7 downto 0);
		variable b_upper 		: std_logic_vector(8 downto 0) := b"0" & b(15 downto 8);
		variable b_lower 		: std_logic_vector(8 downto 0) := b"0" & b(7 downto 0);
		variable intermediate_lower	: std_logic_vector(8 downto 0);
		variable intermediate_upper 	: std_logic_vector(8 downto 0);
		variable result 		: std_logic_vector(15 downto 0) := "0000000000000000";

	begin
		

		intermediate_lower(8 downto 0) := std_logic_vector(unsigned(a_lower) + unsigned(b_lower));
		intermediate_upper := std_logic_vector(unsigned(a_upper) + unsigned(b_upper));

		if(intermediate_lower(8) = '1') then
			intermediate_upper := std_logic_vector(unsigned(intermediate_upper) + 1);
		end if;

		result(15 downto 8) := intermediate_upper(7 downto 0);
		result(7 downto 0) := intermediate_lower(7 downto 0);

		return result;

	end add_fixed;


begin


	process(clk)


	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			data_out <= "0000000000000000";
		else
		
			data_out <= add_fixed(data1_in, data2_in);
		end if;
			 

	end if;

	end process;

end Test_arch;