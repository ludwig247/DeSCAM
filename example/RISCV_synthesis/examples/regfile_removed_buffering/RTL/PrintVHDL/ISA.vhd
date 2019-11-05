library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ISA is
port(	
	MEtoCO_port_sig: in MEtoCP_IF;
	MEtoCO_port_sync: in boolean;
	MEtoCO_port_notify: out boolean;
	RFtoISA_port_sig: in RegfileType;
	COtoME_port_sig: out CUtoME_IF;
	COtoME_port_sync: in boolean;
	COtoME_port_notify: out boolean;
	ISAtoRF_port_sig: out RegfileWriteType;
	ISAtoRF_port_notify: out boolean;
	clk: in std_logic;
	rst: in std_logic
);
end ISA;

architecture ISA_arch of ISA is
	-- Define internal data types
	type ISA_assign_t is (assign_0, assign_1, assign_2, assign_3, assign_4, assign_5, assign_6, assign_7, assign_8, assign_9, assign_10, assign_11, assign_12, assign_13, assign_14);
	type ISA_state_t is (st_execute_10, st_execute_6, st_execute_7, st_fetch_15, st_fetch_16);
	type ALUfuncType is (ALU_ADD, ALU_COPY1, ALU_OR, ALU_SLL, ALU_SLT, ALU_SRL, ALU_SUB);
	type EncType is (ENC_B, ENC_I_I, ENC_I_J, ENC_I_L, ENC_J, ENC_R, ENC_S, ENC_U, ENC_X);
	type InstrType is (INSTR_ADD, INSTR_ADDI, INSTR_BGE, INSTR_LUI, INSTR_LW, INSTR_OR, INSTR_SLLI, INSTR_SRLI, INSTR_SUB, INSTR_SW);

	-- Declare signals
	signal active_state: ISA_state_t;
	signal active_assignment: ISA_assign_t;
	signal pcReg: unsigned(31 downto 0);
	signal toMemoryData: CUtoME_IF;
	signal toRegsData: RegfileWriteType;

	-- Declare state signals that are used by ITL properties for OneSpin
	signal execute_6: boolean;
	signal execute_7: boolean;
	signal execute_10: boolean;
	signal fetch_15: boolean;
	signal fetch_16: boolean;


	-- Functions
	function getALUfunc(instr: InstrType) return ALUfuncType;
	function getALUresult(aluFunction: ALUfuncType; operand1: unsigned; operand2: unsigned) return unsigned;
	function getBranchResult(aluResult: unsigned; encodedInstr: unsigned; pcReg: unsigned) return unsigned;
	function getEncType(encodedInstr: unsigned) return EncType;
	function getImmediate(encodedInstr: unsigned) return unsigned;
	function getInstrType(encodedInstr: unsigned) return InstrType;
	function getMemoryMask(instr: InstrType) return ME_MaskType;
	function readRegfile(fromRegsData_reg_file_01: unsigned; fromRegsData_reg_file_02: unsigned; fromRegsData_reg_file_06: unsigned; fromRegsData_reg_file_07: unsigned; fromRegsData_reg_file_08: unsigned; fromRegsData_reg_file_09: unsigned; fromRegsData_reg_file_10: unsigned; fromRegsData_reg_file_11: unsigned; fromRegsData_reg_file_12: unsigned; fromRegsData_reg_file_13: unsigned; fromRegsData_reg_file_14: unsigned; fromRegsData_reg_file_15: unsigned; fromRegsData_reg_file_16: unsigned; fromRegsData_reg_file_17: unsigned; fromRegsData_reg_file_18: unsigned; fromRegsData_reg_file_19: unsigned; fromRegsData_reg_file_20: unsigned; fromRegsData_reg_file_21: unsigned; fromRegsData_reg_file_22: unsigned; fromRegsData_reg_file_23: unsigned; fromRegsData_reg_file_24: unsigned; fromRegsData_reg_file_25: unsigned; fromRegsData_reg_file_26: unsigned; fromRegsData_reg_file_27: unsigned; src: unsigned) return unsigned;

	function getALUfunc(instr: InstrType) return ALUfuncType is
	begin
		if (instr = INSTR_LUI) then return ALU_COPY1;
		elsif (instr = INSTR_BGE) then return ALU_SLT;
		elsif ((((instr = INSTR_LW) or (instr = INSTR_SW)) or (instr = INSTR_ADDI)) or (instr = INSTR_ADD)) then return ALU_ADD;
		elsif (instr = INSTR_SLLI) then return ALU_SLL;
		elsif (instr = INSTR_SRLI) then return ALU_SRL;
		elsif (instr = INSTR_SUB) then return ALU_SUB;
		else return ALU_OR;
		end if;
	end getALUfunc;

	function getALUresult(aluFunction: ALUfuncType; operand1: unsigned; operand2: unsigned) return unsigned is
	begin
		if (aluFunction = ALU_COPY1) then return operand1;
		elsif (aluFunction = ALU_SLT) and (signed(operand1) < signed(operand2)) then return x"00000001";
		elsif (aluFunction = ALU_SLT) then return x"00000000";
		elsif (aluFunction = ALU_ADD) then return (operand1 + operand2);
		elsif (aluFunction = ALU_SLL) then return shift_left(operand1, to_integer(operand2 and to_unsigned(31, 32)));
		elsif (aluFunction = ALU_SRL) then return shift_right(operand1, to_integer(operand2 and to_unsigned(31, 32)));
		elsif (aluFunction = ALU_SUB) then return (operand1 - operand2);
		else return (operand1 or operand2);
		end if;
	end getALUresult;

	function getBranchResult(aluResult: unsigned; encodedInstr: unsigned; pcReg: unsigned) return unsigned is
	begin
		if ((getInstrType(encodedInstr) = INSTR_BGE) and (aluResult = x"00000000")) then return (pcReg + getImmediate(encodedInstr));
		else return (pcReg + x"00000004");
		end if;
	end getBranchResult;

	function getEncType(encodedInstr: unsigned) return EncType is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") then return ENC_R;
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return ENC_I_I;
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return ENC_I_L;
		elsif ((encodedInstr and x"0000007f") = x"00000067") then return ENC_I_J;
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return ENC_S;
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return ENC_B;
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return ENC_J;
		elsif (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) then return ENC_U;
		else return ENC_X;
		end if;
	end getEncType;

	function getImmediate(encodedInstr: unsigned) return unsigned is
	begin
		if (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) then return (encodedInstr and x"fffff000");
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f"));
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return (x"fffff000" or ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f")));
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e"));
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return (x"fffff000" or (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e")));
		elsif ((encodedInstr and x"0000007f") = x"0000006f") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe"));
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return (x"fff00000" or (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe")));
		elsif ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return shift_right(encodedInstr, 20);
		else return (x"fffff000" or shift_right(encodedInstr, 20));
		end if;
	end getImmediate;

	function getInstrType(encodedInstr: unsigned) return InstrType is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_OR;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and (((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000")) then return INSTR_ADD;
		elsif ((encodedInstr and x"0000007f") = x"00000033") then return INSTR_SUB;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_ADDI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SLLI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return INSTR_SRLI;
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return INSTR_LW;
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return INSTR_SW;
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return INSTR_BGE;
		else return INSTR_LUI;
		end if;
	end getInstrType;

	function getMemoryMask(instr: InstrType) return ME_MaskType is
	begin
		return MT_W;
	end getMemoryMask;

	function readRegfile(fromRegsData_reg_file_01: unsigned; fromRegsData_reg_file_02: unsigned; fromRegsData_reg_file_06: unsigned; fromRegsData_reg_file_07: unsigned; fromRegsData_reg_file_08: unsigned; fromRegsData_reg_file_09: unsigned; fromRegsData_reg_file_10: unsigned; fromRegsData_reg_file_11: unsigned; fromRegsData_reg_file_12: unsigned; fromRegsData_reg_file_13: unsigned; fromRegsData_reg_file_14: unsigned; fromRegsData_reg_file_15: unsigned; fromRegsData_reg_file_16: unsigned; fromRegsData_reg_file_17: unsigned; fromRegsData_reg_file_18: unsigned; fromRegsData_reg_file_19: unsigned; fromRegsData_reg_file_20: unsigned; fromRegsData_reg_file_21: unsigned; fromRegsData_reg_file_22: unsigned; fromRegsData_reg_file_23: unsigned; fromRegsData_reg_file_24: unsigned; fromRegsData_reg_file_25: unsigned; fromRegsData_reg_file_26: unsigned; fromRegsData_reg_file_27: unsigned; src: unsigned) return unsigned is
	begin
		if (src = x"00000000") then return x"00000000";
		elsif (src = x"00000001") then return fromRegsData_reg_file_01;
		elsif (src = x"00000002") then return fromRegsData_reg_file_02;
		elsif (src = x"00000006") then return fromRegsData_reg_file_06;
		elsif (src = x"00000007") then return fromRegsData_reg_file_07;
		elsif (src = x"00000008") then return fromRegsData_reg_file_08;
		elsif (src = x"00000009") then return fromRegsData_reg_file_09;
		elsif (src = x"0000000a") then return fromRegsData_reg_file_10;
		elsif (src = x"0000000b") then return fromRegsData_reg_file_11;
		elsif (src = x"0000000c") then return fromRegsData_reg_file_12;
		elsif (src = x"0000000d") then return fromRegsData_reg_file_13;
		elsif (src = x"0000000e") then return fromRegsData_reg_file_14;
		elsif (src = x"0000000f") then return fromRegsData_reg_file_15;
		elsif (src = x"00000010") then return fromRegsData_reg_file_16;
		elsif (src = x"00000011") then return fromRegsData_reg_file_17;
		elsif (src = x"00000012") then return fromRegsData_reg_file_18;
		elsif (src = x"00000013") then return fromRegsData_reg_file_19;
		elsif (src = x"00000014") then return fromRegsData_reg_file_20;
		elsif (src = x"00000015") then return fromRegsData_reg_file_21;
		elsif (src = x"00000016") then return fromRegsData_reg_file_22;
		elsif (src = x"00000017") then return fromRegsData_reg_file_23;
		elsif (src = x"00000018") then return fromRegsData_reg_file_24;
		elsif (src = x"00000019") then return fromRegsData_reg_file_25;
		elsif (src = x"0000001a") then return fromRegsData_reg_file_26;
		else return fromRegsData_reg_file_27;
		end if;
	end readRegfile;


begin
	-- Combinational logic that selects current operation
	process (active_state, COtoME_port_sync, MEtoCO_port_sync, MEtoCO_port_sig.loadedData)
	begin
		case active_state is
		when st_execute_6 =>
			if (not(COtoME_port_sync)) then 
				-- Operation: op_wait_execute_6;
				active_assignment <= assign_0;
			else--if(COtoME_port_sync) then 
				-- Operation: op_execute_6_write_0;
				active_assignment <= assign_1;
			end if;
		when st_execute_7 =>
			if (not(MEtoCO_port_sync)) then 
				-- Operation: op_wait_execute_7;
				active_assignment <= assign_1;
			else--if(MEtoCO_port_sync) then 
				-- Operation: op_execute_7_read_1;
				active_assignment <= assign_2;
			end if;
		when st_execute_10 =>
			if (not(COtoME_port_sync)) then 
				-- Operation: op_wait_execute_10;
				active_assignment <= assign_3;
			else--if(COtoME_port_sync) then 
				-- Operation: op_execute_10_write_2;
				active_assignment <= assign_4;
			end if;
		when st_fetch_15 =>
			if (not(COtoME_port_sync)) then 
				-- Operation: op_wait_fetch_15;
				active_assignment <= assign_5;
			else--if(COtoME_port_sync) then 
				-- Operation: op_fetch_15_write_3;
				active_assignment <= assign_6;
			end if;
		when st_fetch_16 =>
			if (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_4;
				active_assignment <= assign_4;
			elsif (not(MEtoCO_port_sync)) then 
				-- Operation: op_wait_fetch_16;
				active_assignment <= assign_6;
			elsif ((getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_5;
				active_assignment <= assign_7;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_6;
				active_assignment <= assign_8;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_7;
				active_assignment <= assign_9;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_8;
				active_assignment <= assign_10;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_9;
				active_assignment <= assign_11;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_10;
				active_assignment <= assign_12;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_11;
				active_assignment <= assign_13;
			else--if(not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and MEtoCO_port_sync) then 
				-- Operation: op_fetch_16_read_12;
				active_assignment <= assign_14;
			end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			ISAtoRF_port_notify <= false;
			toMemoryData.dataIn <= x"00000000";
			MEtoCO_port_notify <= false;
			toRegsData.dst <= x"00000000";
			COtoME_port_sig.req <= ME_RD;
			COtoME_port_notify <= true;
			COtoME_port_sig.addrIn <= x"00000000";
			pcReg <= x"00000000";
			toMemoryData.addrIn <= x"00000000";
			toMemoryData.req <= ME_RD;
			toMemoryData.mask <= MT_W;
			COtoME_port_sig.mask <= MT_W;
			active_state <= st_fetch_15;
			COtoME_port_sig.dataIn <= x"00000000";
		elsif (clk = '1' and clk'event) then
			case active_assignment is
			when assign_0 =>
				ISAtoRF_port_notify <= false;
				active_state <= st_execute_6;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.dataIn <= toMemoryData.dataIn;
				COtoME_port_sig.mask <= toMemoryData.mask;
				COtoME_port_sig.req <= toMemoryData.req;
				COtoME_port_notify <= true;
				COtoME_port_sig.addrIn <= toMemoryData.addrIn;
			when assign_1 =>
				ISAtoRF_port_notify <= false;
				active_state <= st_execute_7;
				COtoME_port_notify <= false;
				MEtoCO_port_notify <= true;
			when assign_2 =>
				ISAtoRF_port_notify <= true;
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				COtoME_port_sig.addrIn <= x"00000004" + pcReg;
				COtoME_port_sig.req <= ME_RD;
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				ISAtoRF_port_sig.dstData <= MEtoCO_port_sig.loadedData;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
				ISAtoRF_port_sig.dst <= toRegsData.dst;
			when assign_3 =>
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				active_state <= st_execute_10;
				COtoME_port_sig.dataIn <= toMemoryData.dataIn;
				COtoME_port_sig.mask <= toMemoryData.mask;
				COtoME_port_sig.req <= toMemoryData.req;
				COtoME_port_notify <= true;
				COtoME_port_sig.addrIn <= toMemoryData.addrIn;
			when assign_4 =>
				ISAtoRF_port_notify <= false;
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				COtoME_port_sig.addrIn <= x"00000004" + pcReg;
				COtoME_port_sig.req <= ME_RD;
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
			when assign_5 =>
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.dataIn <= toMemoryData.dataIn;
				COtoME_port_sig.mask <= toMemoryData.mask;
				COtoME_port_sig.req <= toMemoryData.req;
				COtoME_port_notify <= true;
				active_state <= st_fetch_15;
				COtoME_port_sig.addrIn <= toMemoryData.addrIn;
			when assign_6 =>
				ISAtoRF_port_notify <= false;
				active_state <= st_fetch_16;
				COtoME_port_notify <= false;
				MEtoCO_port_notify <= true;
			when assign_7 =>
				ISAtoRF_port_notify <= true;
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), getImmediate(MEtoCO_port_sig.loadedData), pcReg);
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.addrIn <= x"00000004" + pcReg;
				COtoME_port_sig.req <= ME_RD;
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
			when assign_8 =>
				ISAtoRF_port_notify <= true;
				ISAtoRF_port_sig.dstData <= x"00000004" + pcReg;
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				toMemoryData.addrIn <= pcReg + getImmediate(MEtoCO_port_sig.loadedData);
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.addrIn <= pcReg + getImmediate(MEtoCO_port_sig.loadedData);
				COtoME_port_sig.req <= ME_RD;
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				pcReg <= pcReg + getImmediate(MEtoCO_port_sig.loadedData);
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
			when assign_9 =>
				ISAtoRF_port_notify <= true;
				ISAtoRF_port_sig.dstData <= x"00000004" + pcReg;
				toMemoryData.dataIn <= x"00000000";
				toMemoryData.addrIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")) + getImmediate(MEtoCO_port_sig.loadedData);
				MEtoCO_port_notify <= false;
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.req <= ME_RD;
				pcReg <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")) + getImmediate(MEtoCO_port_sig.loadedData);
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				COtoME_port_sig.addrIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")) + getImmediate(MEtoCO_port_sig.loadedData);
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
			when assign_10 =>
				toMemoryData.addrIn <= getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"))), MEtoCO_port_sig.loadedData, pcReg);
				ISAtoRF_port_notify <= false;
				pcReg <= getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"))), MEtoCO_port_sig.loadedData, pcReg);
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				COtoME_port_sig.addrIn <= getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"))), MEtoCO_port_sig.loadedData, pcReg);
				COtoME_port_sig.req <= ME_RD;
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
			when assign_11 =>
				COtoME_port_sig.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				ISAtoRF_port_notify <= false;
				toMemoryData.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				active_state <= st_execute_6;
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.req <= ME_RD;
				COtoME_port_notify <= true;
				COtoME_port_sig.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
				toMemoryData.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
				toMemoryData.req <= ME_RD;
				COtoME_port_sig.dataIn <= x"00000000";
			when assign_12 =>
				COtoME_port_sig.req <= ME_WR;
				ISAtoRF_port_notify <= false;
				toMemoryData.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				COtoME_port_sig.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
				MEtoCO_port_notify <= false;
				active_state <= st_execute_10;
				toMemoryData.req <= ME_WR;
				toMemoryData.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
				COtoME_port_notify <= true;
				toMemoryData.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"));
				COtoME_port_sig.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"));
				COtoME_port_sig.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
			when assign_13 =>
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				ISAtoRF_port_notify <= true;
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.addrIn <= x"00000004" + pcReg;
				COtoME_port_sig.req <= ME_RD;
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
			when assign_14 =>
				ISAtoRF_port_notify <= true;
				toMemoryData.dataIn <= x"00000000";
				MEtoCO_port_notify <= false;
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.addrIn <= x"00000004" + pcReg;
				COtoME_port_sig.req <= ME_RD;
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f")));
				COtoME_port_notify <= true;
				toMemoryData.req <= ME_RD;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_15;
				COtoME_port_sig.dataIn <= x"00000000";
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	execute_6 <= active_state = st_execute_6;
	execute_7 <= active_state = st_execute_7;
	execute_10 <= active_state = st_execute_10;
	fetch_15 <= active_state = st_fetch_15;
	fetch_16 <= active_state = st_fetch_16;

end ISA_arch;

