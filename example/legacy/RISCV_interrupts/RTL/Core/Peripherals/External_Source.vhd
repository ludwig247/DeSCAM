--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 01.12.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity External_Source is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		--  master_out<unsigned int> IntSig
		IntSig			: out bool;
		IntSig_notify	: out bool
	);
end External_Source;

architecture External_Source_arch of External_Source is

begin

	process(clk)

		begin
			if(clk='1' and clk'event) then
				if rst = '1' then

					IntSig <= false;
					IntSig_notify <= true;

				else

					IntSig <= false;
					IntSig_notify <= true;

				end if; -- RST
			end if; -- CLK
	end process;
end External_Source_arch;
