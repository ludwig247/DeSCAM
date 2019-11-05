package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Regs_SECTIONS is (run);
type RegfileECallType is record
	reg_file_10: unsigned;
	reg_file_11: unsigned;
	reg_file_12: unsigned;
	reg_file_17: unsigned;
end record;
type RegfileType is record
	reg_file_01: unsigned;
	reg_file_02: unsigned;
	reg_file_03: unsigned;
	reg_file_04: unsigned;
	reg_file_05: unsigned;
	reg_file_06: unsigned;
	reg_file_07: unsigned;
	reg_file_08: unsigned;
	reg_file_09: unsigned;
	reg_file_10: unsigned;
	reg_file_11: unsigned;
	reg_file_12: unsigned;
	reg_file_13: unsigned;
	reg_file_14: unsigned;
	reg_file_15: unsigned;
	reg_file_16: unsigned;
	reg_file_17: unsigned;
	reg_file_18: unsigned;
	reg_file_19: unsigned;
	reg_file_20: unsigned;
	reg_file_21: unsigned;
	reg_file_22: unsigned;
	reg_file_23: unsigned;
	reg_file_24: unsigned;
	reg_file_25: unsigned;
	reg_file_26: unsigned;
	reg_file_27: unsigned;
	reg_file_28: unsigned;
	reg_file_29: unsigned;
	reg_file_30: unsigned;
	reg_file_31: unsigned;
end record;
type RegfileWriteType is record
	dst: unsigned;
	dstData: unsigned;
	exception: unsigned;
end record;
end package SCAM_Model_types;
