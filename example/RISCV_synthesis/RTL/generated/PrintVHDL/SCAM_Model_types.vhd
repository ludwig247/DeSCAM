-- External data type definition package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SCAM_Model_types is
	type RegfileType is record
		reg_file_01: unsigned(31 downto 0);
		reg_file_02: unsigned(31 downto 0);
		reg_file_03: unsigned(31 downto 0);
		reg_file_04: unsigned(31 downto 0);
		reg_file_05: unsigned(31 downto 0);
		reg_file_06: unsigned(31 downto 0);
		reg_file_07: unsigned(31 downto 0);
		reg_file_08: unsigned(31 downto 0);
		reg_file_09: unsigned(31 downto 0);
		reg_file_10: unsigned(31 downto 0);
		reg_file_11: unsigned(31 downto 0);
		reg_file_12: unsigned(31 downto 0);
		reg_file_13: unsigned(31 downto 0);
		reg_file_14: unsigned(31 downto 0);
		reg_file_15: unsigned(31 downto 0);
		reg_file_16: unsigned(31 downto 0);
		reg_file_17: unsigned(31 downto 0);
		reg_file_18: unsigned(31 downto 0);
		reg_file_19: unsigned(31 downto 0);
		reg_file_20: unsigned(31 downto 0);
		reg_file_21: unsigned(31 downto 0);
		reg_file_22: unsigned(31 downto 0);
		reg_file_23: unsigned(31 downto 0);
		reg_file_24: unsigned(31 downto 0);
		reg_file_25: unsigned(31 downto 0);
		reg_file_26: unsigned(31 downto 0);
		reg_file_27: unsigned(31 downto 0);
		reg_file_28: unsigned(31 downto 0);
		reg_file_29: unsigned(31 downto 0);
		reg_file_30: unsigned(31 downto 0);
		reg_file_31: unsigned(31 downto 0);
	end record;
	type RegfileWriteType is record
		dst: unsigned(31 downto 0);
		dstData: unsigned(31 downto 0);
	end record;
end package SCAM_Model_types;

