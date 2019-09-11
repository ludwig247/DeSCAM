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

	ISAtoRF_port_sig					: in RegfileWriteType;
	ISAtoRF_port_sync				: in boolean;
	RFtoISA_port_sig				: out RegfileType;

	syscall_reg_port_sig			: in RegfileWriteType;
	syscall_reg_port_sync		: in boolean;
	reg_syscall_port_sig			: out RegfileSyscallType
);
end Regs;

architecture Regs_arch of Regs is

begin

	process(clk)

	variable reg_file_10	: unsigned (31 downto 0);

	begin
		if(clk='1' and clk'event) then

			-- Reset Sequence
			if rst = '1' then

				RFtoISA_port_sig.reg_file_01 <= (others => '0');
				RFtoISA_port_sig.reg_file_02 <= (others => '0');
				RFtoISA_port_sig.reg_file_03 <= (others => '0');
				RFtoISA_port_sig.reg_file_04 <= (others => '0');
				RFtoISA_port_sig.reg_file_05 <= (others => '0');
				RFtoISA_port_sig.reg_file_06 <= (others => '0');
				RFtoISA_port_sig.reg_file_07 <= (others => '0');
				RFtoISA_port_sig.reg_file_08 <= (others => '0');
				RFtoISA_port_sig.reg_file_09 <= (others => '0');
				RFtoISA_port_sig.reg_file_10 <= (others => '0');
				RFtoISA_port_sig.reg_file_11 <= (others => '0');
				RFtoISA_port_sig.reg_file_12 <= (others => '0');
				RFtoISA_port_sig.reg_file_13 <= (others => '0');
				RFtoISA_port_sig.reg_file_14 <= (others => '0');
				RFtoISA_port_sig.reg_file_15 <= (others => '0');
				RFtoISA_port_sig.reg_file_16 <= (others => '0');
				RFtoISA_port_sig.reg_file_17 <= (others => '0');
				RFtoISA_port_sig.reg_file_18 <= (others => '0');
				RFtoISA_port_sig.reg_file_19 <= (others => '0');
				RFtoISA_port_sig.reg_file_20 <= (others => '0');
				RFtoISA_port_sig.reg_file_21 <= (others => '0');
				RFtoISA_port_sig.reg_file_22 <= (others => '0');
				RFtoISA_port_sig.reg_file_23 <= (others => '0');
				RFtoISA_port_sig.reg_file_24 <= (others => '0');
				RFtoISA_port_sig.reg_file_25 <= (others => '0');
				RFtoISA_port_sig.reg_file_26 <= (others => '0');
				RFtoISA_port_sig.reg_file_27 <= (others => '0');
				RFtoISA_port_sig.reg_file_28 <= (others => '0');
				RFtoISA_port_sig.reg_file_29 <= (others => '0');
				RFtoISA_port_sig.reg_file_30 <= (others => '0');
				RFtoISA_port_sig.reg_file_31 <= (others => '0');

				reg_syscall_port_sig.reg_file_10 <= (others => '0');
				reg_syscall_port_sig.reg_file_11 <= (others => '0');
				reg_syscall_port_sig.reg_file_12 <= (others => '0');
				reg_syscall_port_sig.reg_file_17 <= (others => '0');
			else

				-- WRITE
				if ISAtoRF_port_sync = true then

					if    (ISAtoRF_port_sig.dst =  1) then
						RFtoISA_port_sig.reg_file_01 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  2) then
						RFtoISA_port_sig.reg_file_02 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  3) then
						RFtoISA_port_sig.reg_file_03 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  4) then
						RFtoISA_port_sig.reg_file_04 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  5) then
						RFtoISA_port_sig.reg_file_05 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  6) then
						RFtoISA_port_sig.reg_file_06 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  7) then
						RFtoISA_port_sig.reg_file_07 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  8) then
						RFtoISA_port_sig.reg_file_08 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst =  9) then
						RFtoISA_port_sig.reg_file_09 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 10) then
						reg_file_10 := ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 11) then
						RFtoISA_port_sig.reg_file_11 <= ISAtoRF_port_sig.dstData;
						reg_syscall_port_sig.reg_file_11 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 12) then
						RFtoISA_port_sig.reg_file_12 <= ISAtoRF_port_sig.dstData;
						reg_syscall_port_sig.reg_file_12 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 13) then
						RFtoISA_port_sig.reg_file_13 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 14) then
						RFtoISA_port_sig.reg_file_14 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 15) then
						RFtoISA_port_sig.reg_file_15 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 16) then
						RFtoISA_port_sig.reg_file_16 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 17) then
						RFtoISA_port_sig.reg_file_17 <= ISAtoRF_port_sig.dstData;
						reg_syscall_port_sig.reg_file_17 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 18) then
						RFtoISA_port_sig.reg_file_18 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 19) then
						RFtoISA_port_sig.reg_file_19 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 20) then
						RFtoISA_port_sig.reg_file_20 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 21) then
						RFtoISA_port_sig.reg_file_21 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 22) then
						RFtoISA_port_sig.reg_file_22 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 23) then
						RFtoISA_port_sig.reg_file_23 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 24) then
						RFtoISA_port_sig.reg_file_24 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 25) then
						RFtoISA_port_sig.reg_file_25 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 26) then
						RFtoISA_port_sig.reg_file_26 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 27) then
						RFtoISA_port_sig.reg_file_27 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 28) then
						RFtoISA_port_sig.reg_file_28 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 29) then
						RFtoISA_port_sig.reg_file_29 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 30) then
						RFtoISA_port_sig.reg_file_30 <= ISAtoRF_port_sig.dstData;
					elsif (ISAtoRF_port_sig.dst = 31) then
						RFtoISA_port_sig.reg_file_31 <= ISAtoRF_port_sig.dstData;
					end if;
				end if; 

				if syscall_reg_port_sync = true then
					reg_file_10 := syscall_reg_port_sig.dstData;
				end if;

				if (( (ISAtoRF_port_sync = true) and (ISAtoRF_port_sig.dst = 10) ) or (syscall_reg_port_sync = true)) then
					RFtoISA_port_sig.reg_file_10 <= reg_file_10;
					reg_syscall_port_sig.reg_file_10 <= reg_file_10;
				end if;
				
			end if; -- RST
		end if; -- CLK
	end process;
end Regs_arch;
