--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Regs is
port(
	clk							: in std_logic;
	rst							: in std_logic;

	toRegsPort					: in RegfileWriteType;
	toRegsPort_sync			: in bool;
	fromRegsPort				: out RegfileType
);
end Regs;

architecture Regs_arch of Regs is

begin

	process(clk)

	begin
		if(clk='1' and clk'event) then

			-- Reset Sequence
			if rst = '1' then

				fromRegsPort.reg_file_01 <= (others => '0');
				fromRegsPort.reg_file_02 <= (others => '0');
				fromRegsPort.reg_file_03 <= (others => '0');
				fromRegsPort.reg_file_04 <= (others => '0');
				fromRegsPort.reg_file_05 <= (others => '0');
				fromRegsPort.reg_file_06 <= (others => '0');
				fromRegsPort.reg_file_07 <= (others => '0');
				fromRegsPort.reg_file_08 <= (others => '0');
				fromRegsPort.reg_file_09 <= (others => '0');
				fromRegsPort.reg_file_10 <= (others => '0');
				fromRegsPort.reg_file_11 <= (others => '0');
				fromRegsPort.reg_file_12 <= (others => '0');
				fromRegsPort.reg_file_13 <= (others => '0');
				fromRegsPort.reg_file_14 <= (others => '0');
				fromRegsPort.reg_file_15 <= (others => '0');
				fromRegsPort.reg_file_16 <= (others => '0');
				fromRegsPort.reg_file_17 <= (others => '0');
				fromRegsPort.reg_file_18 <= (others => '0');
				fromRegsPort.reg_file_19 <= (others => '0');
				fromRegsPort.reg_file_20 <= (others => '0');
				fromRegsPort.reg_file_21 <= (others => '0');
				fromRegsPort.reg_file_22 <= (others => '0');
				fromRegsPort.reg_file_23 <= (others => '0');
				fromRegsPort.reg_file_24 <= (others => '0');
				fromRegsPort.reg_file_25 <= (others => '0');
				fromRegsPort.reg_file_26 <= (others => '0');
				fromRegsPort.reg_file_27 <= (others => '0');
				fromRegsPort.reg_file_28 <= (others => '0');
				fromRegsPort.reg_file_29 <= (others => '0');
				fromRegsPort.reg_file_30 <= (others => '0');
				fromRegsPort.reg_file_31 <= (others => '0');

			else

				-- WRITE
				if toRegsPort_sync = true then

					if    (toRegsPort.dst =  1) then
						fromRegsPort.reg_file_01 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  2) then
						fromRegsPort.reg_file_02 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  3) then
						fromRegsPort.reg_file_03 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  4) then
						fromRegsPort.reg_file_04 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  5) then
						fromRegsPort.reg_file_05 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  6) then
						fromRegsPort.reg_file_06 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  7) then
						fromRegsPort.reg_file_07 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  8) then
						fromRegsPort.reg_file_08 <= toRegsPort.dstData;
					elsif (toRegsPort.dst =  9) then
						fromRegsPort.reg_file_09 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 10) then
						fromRegsPort.reg_file_10 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 11) then
						fromRegsPort.reg_file_11 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 12) then
						fromRegsPort.reg_file_12 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 13) then
						fromRegsPort.reg_file_13 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 14) then
						fromRegsPort.reg_file_14 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 15) then
						fromRegsPort.reg_file_15 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 16) then
						fromRegsPort.reg_file_16 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 17) then
						fromRegsPort.reg_file_17 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 18) then
						fromRegsPort.reg_file_18 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 19) then
						fromRegsPort.reg_file_19 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 20) then
						fromRegsPort.reg_file_20 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 21) then
						fromRegsPort.reg_file_21 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 22) then
						fromRegsPort.reg_file_22 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 23) then
						fromRegsPort.reg_file_23 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 24) then
						fromRegsPort.reg_file_24 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 25) then
						fromRegsPort.reg_file_25 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 26) then
						fromRegsPort.reg_file_26 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 27) then
						fromRegsPort.reg_file_27 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 28) then
						fromRegsPort.reg_file_28 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 29) then
						fromRegsPort.reg_file_29 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 30) then
						fromRegsPort.reg_file_30 <= toRegsPort.dstData;
					elsif (toRegsPort.dst = 31) then
						fromRegsPort.reg_file_31 <= toRegsPort.dstData;
					end if;
				end if; 

			end if; -- RST
		end if; -- CLK
	end process;
end Regs_arch;