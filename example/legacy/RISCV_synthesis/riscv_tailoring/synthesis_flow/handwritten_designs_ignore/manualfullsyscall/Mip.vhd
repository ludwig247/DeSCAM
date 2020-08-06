--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Mip is
port(    
	clk: in std_logic;
	rst: in std_logic;

	--  master_in<bool> MSIP_port_sig;
	MSIP_port_sig				: in bool;

	--  master_in<bool> MTIP_port_sig;
	MTIP_port_sig				: in bool;

	--  slave_out<unsigned int> mip_isa_port_sig;
	mip_isa_port_sig				: out unsigned (31 downto 0)
);
end Mip;

architecture Mip_arch of Mip is

signal mip : unsigned (31 downto 0) := (others => '0');

begin
	process(clk)

	variable temp : unsigned (31 downto 0);

	begin
		if(clk='1' and clk'event) then

			-- Reset Sequence
			if rst = '1' then
				mip <= (others => '0');
				mip_isa_port_sig <= (others => '0');
			else
				temp := mip;

				if (MSIP_port_sig = true) then
					temp := temp or (X"00000008");
				else
					temp := temp and (X"FFFFFFF7");
				end if;

				if (MTIP_port_sig = true) then
					temp := temp or (X"00000080");
				else
					temp := temp and (X"FFFFFF7F");
				end if;

				mip <= temp;
				mip_isa_port_sig <= temp;
			end if; -- RST
		end if; -- CLK
	end process;
end Mip_arch;