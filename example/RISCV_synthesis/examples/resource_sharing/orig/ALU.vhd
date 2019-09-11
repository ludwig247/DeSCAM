
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ALU_types is
	type ALU_state_t is (st_run_0);
	type ALU_assign_t is (assign_0, assign_1, assign_2, assign_3, assign_4, assign_5, assign_6, assign_7, assign_8, assign_9, assign_10, assign_11, assign_12, assign_13, assign_14, assign_15, assign_16, assign_17, assign_18, assign_19, assign_20, assign_21, assign_22, assign_23, assign_24, assign_25, assign_26, assign_27, assign_28, assign_29, assign_30, assign_31, assign_32, assign_33, assign_34, assign_35, assign_36, assign_37, assign_38, assign_39, assign_40, assign_41, assign_42, assign_43, assign_44, assign_45, assign_46, assign_47, assign_48, assign_49, assign_50, assign_51, assign_52, assign_53, assign_54, assign_55, assign_56, assign_57, assign_58, assign_59, assign_60, assign_61, assign_62, assign_63, assign_64);
	--type ALU_SECTIONS is (run);
	type ALU_function is (ALU_ADD, ALU_AND, ALU_COPY1, ALU_OR, ALU_SLL, ALU_SLT, ALU_SLTU, ALU_SRA, ALU_SRL, ALU_SUB, ALU_X, ALU_XOR);
	type ALUopType is (OP_IMM, OP_PC, OP_REG, OP_X);
	type ALUtoCtl_IF is record
		ALU_result: unsigned(31 downto 0);
	end record;
	type CtlToALU_IF is record
		alu_fun: ALU_function;
		imm: unsigned(31 downto 0);
		op1_sel: ALUopType;
		op2_sel: ALUopType;
		pc_reg: unsigned(31 downto 0);
		reg1_contents: unsigned(31 downto 0);
		reg2_contents: unsigned(31 downto 0);
	end record;
end package ALU_types;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_types.all;

entity ALU is
port(	
	clk: in std_logic;
	rst: in std_logic;
	ALUtoCtl_port_sig: out ALUtoCtl_IF;
	CtlToALU_port_sig: in CtlToALU_IF;
	CtlToALU_port_sync: in boolean);
end ALU;

architecture ALU_arch of ALU is
	signal active_state: ALU_state_t;
	signal active_assignment: ALU_assign_t;
	signal ALUtoCtl_data: ALUtoCtl_IF;

	-- Declaring state signals that are used by ITL properties for OneSpin
	signal run_0: boolean;

begin
	-- Combinational logic that selects current operation
	process (active_state, CtlToALU_port_sync, CtlToALU_port_sig.alu_fun, CtlToALU_port_sig.reg2_contents, CtlToALU_port_sig.imm, CtlToALU_port_sig.op1_sel, CtlToALU_port_sig.op2_sel, CtlToALU_port_sig.pc_reg, CtlToALU_port_sig.reg1_contents)
	begin
		case active_state is
		when st_run_0 =>
			if (not(CtlToALU_port_sync)) then 
				-- Operation: op_run_0_read_0;
				active_assignment <= assign_0;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_1;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_2;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_3;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_4;
				active_assignment <= assign_2;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_5;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_6;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_7;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_8;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_9;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_10;
				active_assignment <= assign_3;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_11;
				active_assignment <= assign_4;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_12;
				active_assignment <= assign_5;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_13;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_14;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_15;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_16;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_17;
				active_assignment <= assign_6;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_18;
				active_assignment <= assign_7;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_19;
				active_assignment <= assign_8;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_20;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_21;
				active_assignment <= assign_10;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_22;
				active_assignment <= assign_11;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_23;
				active_assignment <= assign_12;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_24;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_25;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_26;
				active_assignment <= assign_13;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_27;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_X) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_28;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_29;
				active_assignment <= assign_14;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_30;
				active_assignment <= assign_15;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_31;
				active_assignment <= assign_16;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_32;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_33;
				active_assignment <= assign_17;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_34;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_35;
				active_assignment <= assign_18;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_36;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_37;
				active_assignment <= assign_20;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_38;
				active_assignment <= assign_21;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_39;
				active_assignment <= assign_22;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_40;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_41;
				active_assignment <= assign_23;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_42;
				active_assignment <= assign_24;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_43;
				active_assignment <= assign_25;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_44;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_45;
				active_assignment <= assign_26;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_46;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_47;
				active_assignment <= assign_27;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_48;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_49;
				active_assignment <= assign_28;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_50;
				active_assignment <= assign_29;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_51;
				active_assignment <= assign_30;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_52;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_53;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_54;
				active_assignment <= assign_32;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_55;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_ADD) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_56;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_57;
				active_assignment <= assign_33;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_58;
				active_assignment <= assign_34;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_59;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_60;
				active_assignment <= assign_35;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_61;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_62;
				active_assignment <= assign_36;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_63;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_64;
				active_assignment <= assign_37;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_65;
				active_assignment <= assign_38;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_66;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_67;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_68;
				active_assignment <= assign_13;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_69;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_70;
				active_assignment <= assign_39;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SUB) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_71;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_72;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_73;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_74;
				active_assignment <= assign_41;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_75;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_76;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_77;
				active_assignment <= assign_42;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_78;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_79;
				active_assignment <= assign_43;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_80;
				active_assignment <= assign_44;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_81;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_82;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_83;
				active_assignment <= assign_13;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_84;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_85;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_AND) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_86;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_87;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_88;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_89;
				active_assignment <= assign_45;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.imm <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_90;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.imm <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_91;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_92;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_93;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_94;
				active_assignment <= assign_46;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_95;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_96;
				active_assignment <= assign_47;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_97;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_98;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_99;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_100;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_OR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_101;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_102;
				active_assignment <= assign_48;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.imm <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_103;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.imm <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_104;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_105;
				active_assignment <= assign_49;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_106;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_107;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_108;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_109;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_110;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_111;
				active_assignment <= assign_50;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_112;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_113;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_114;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_115;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_116;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.reg2_contents = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_117;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.reg2_contents = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_118;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_119;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_XOR) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_120;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_121;
				active_assignment <= assign_48;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_122;
				active_assignment <= assign_51;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_123;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.reg1_contents) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_124;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_125;
				active_assignment <= assign_52;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_126;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_127;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_128;
				active_assignment <= assign_53;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_129;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_130;
				active_assignment <= assign_54;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_131;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_132;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_133;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_134;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.reg2_contents <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_135;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_136;
				active_assignment <= assign_55;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.imm <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_137;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.imm <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_138;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.reg2_contents = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_139;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.reg2_contents = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_140;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_141;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.imm = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_142;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.imm = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_143;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_144;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_145;
				active_assignment <= assign_51;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_146;
				active_assignment <= assign_56;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_147;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_148;
				active_assignment <= assign_53;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_149;
				active_assignment <= assign_57;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_150;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.pc_reg <= CtlToALU_port_sig.imm) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_151;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_152;
				active_assignment <= assign_58;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_153;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_154;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_155;
				active_assignment <= assign_59;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.imm <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_156;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.imm <= CtlToALU_port_sig.pc_reg) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_157;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_158;
				active_assignment <= assign_60;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_159;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_160;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_161;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.imm = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_162;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.imm = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_163;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_164;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and not(CtlToALU_port_sig.pc_reg = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_165;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and (CtlToALU_port_sig.pc_reg = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_166;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLT) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_167;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_168;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_169;
				active_assignment <= assign_56;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_170;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_171;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_172;
				active_assignment <= assign_57;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_173;
				active_assignment <= assign_61;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_174;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_175;
				active_assignment <= assign_59;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_176;
				active_assignment <= assign_62;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_177;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_178;
				active_assignment <= assign_63;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_179;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_180;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_181;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_182;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and not(CtlToALU_port_sig.pc_reg = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_183;
				active_assignment <= assign_40;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and (CtlToALU_port_sig.pc_reg = 0) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_184;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_185;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLTU) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_186;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SLL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_187;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_188;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_189;
				active_assignment <= assign_9;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_190;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_191;
				active_assignment <= assign_61;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_192;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_193;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_194;
				active_assignment <= assign_62;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_195;
				active_assignment <= assign_64;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_196;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_REG) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_197;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_198;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_199;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRA) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_200;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_201;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_202;
				active_assignment <= assign_19;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_203;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_204;
				active_assignment <= assign_64;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_205;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_IMM) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_206;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_207;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_SRL) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_208;
				active_assignment <= assign_1;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_209;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and (CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_210;
				active_assignment <= assign_31;
			elsif (CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and (CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_211;
				active_assignment <= assign_1;
			else--if(CtlToALU_port_sync and not(CtlToALU_port_sig.op1_sel = OP_REG) and not(CtlToALU_port_sig.op1_sel = OP_IMM) and not(CtlToALU_port_sig.op1_sel = OP_PC) and not(CtlToALU_port_sig.op2_sel = OP_REG) and not(CtlToALU_port_sig.op2_sel = OP_IMM) and not(CtlToALU_port_sig.op2_sel = OP_PC) and (CtlToALU_port_sig.alu_fun = ALU_COPY1) and CtlToALU_port_sync) then 
				-- Operation: op_run_0_read_212;
				active_assignment <= assign_1;
			end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			active_state <= st_run_0;
			ALUtoCtl_data.ALU_result <= to_unsigned(0, ALUtoCtl_data.ALU_result'length);
		elsif (clk = '1' and clk'event) then
			case active_assignment is
			when assign_0 =>
				active_state <= st_run_0;
				ALUtoCtl_port_sig.ALU_result <= ALUtoCtl_data.ALU_result;
			when assign_1 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= to_unsigned(0, ALUtoCtl_data.ALU_result'length);
				ALUtoCtl_port_sig.ALU_result <= to_unsigned(0, ALUtoCtl_port_sig.ALU_result'length);
			when assign_2 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents + CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents + CtlToALU_port_sig.reg2_contents;
			when assign_3 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents - CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents - CtlToALU_port_sig.reg2_contents;
			when assign_4 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents + CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents + CtlToALU_port_sig.imm;
			when assign_5 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm + CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm + CtlToALU_port_sig.reg2_contents;
			when assign_6 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents and CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents and CtlToALU_port_sig.reg2_contents;
			when assign_7 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents - CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents - CtlToALU_port_sig.imm;
			when assign_8 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents + CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents + CtlToALU_port_sig.pc_reg;
			when assign_9 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents;
			when assign_10 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm - CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm - CtlToALU_port_sig.reg2_contents;
			when assign_11 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm + CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm + CtlToALU_port_sig.imm;
			when assign_12 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg + CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg + CtlToALU_port_sig.reg2_contents;
			when assign_13 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg2_contents;
			when assign_14 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents or CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents or CtlToALU_port_sig.reg2_contents;
			when assign_15 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents and CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents and CtlToALU_port_sig.imm;
			when assign_16 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents - CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents - CtlToALU_port_sig.pc_reg;
			when assign_17 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm and CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm and CtlToALU_port_sig.reg2_contents;
			when assign_18 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm + CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm + CtlToALU_port_sig.pc_reg;
			when assign_19 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm;
			when assign_20 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg - CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg - CtlToALU_port_sig.reg2_contents;
			when assign_21 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg + CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg + CtlToALU_port_sig.imm;
			when assign_22 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= not(CtlToALU_port_sig.reg2_contents) + 1;
				ALUtoCtl_port_sig.ALU_result <= not(CtlToALU_port_sig.reg2_contents) + 1;
			when assign_23 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents xor CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents xor CtlToALU_port_sig.reg2_contents;
			when assign_24 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents or CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents or CtlToALU_port_sig.imm;
			when assign_25 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents and CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents and CtlToALU_port_sig.pc_reg;
			when assign_26 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm or CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm or CtlToALU_port_sig.reg2_contents;
			when assign_27 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm - CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm - CtlToALU_port_sig.pc_reg;
			when assign_28 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg and CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg and CtlToALU_port_sig.reg2_contents;
			when assign_29 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg - CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg - CtlToALU_port_sig.imm;
			when assign_30 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg + CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg + CtlToALU_port_sig.pc_reg;
			when assign_31 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg;
			when assign_32 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= not(CtlToALU_port_sig.imm) + 1;
				ALUtoCtl_port_sig.ALU_result <= not(CtlToALU_port_sig.imm) + 1;
			when assign_33 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents xor CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents xor CtlToALU_port_sig.imm;
			when assign_34 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents or CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents or CtlToALU_port_sig.pc_reg;
			when assign_35 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm xor CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm xor CtlToALU_port_sig.reg2_contents;
			when assign_36 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm and CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm and CtlToALU_port_sig.pc_reg;
			when assign_37 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg or CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg or CtlToALU_port_sig.reg2_contents;
			when assign_38 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg and CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg and CtlToALU_port_sig.imm;
			when assign_39 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= not(CtlToALU_port_sig.pc_reg) + 1;
				ALUtoCtl_port_sig.ALU_result <= not(CtlToALU_port_sig.pc_reg) + 1;
			when assign_40 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= to_unsigned(1, ALUtoCtl_data.ALU_result'length);
				ALUtoCtl_port_sig.ALU_result <= to_unsigned(1, ALUtoCtl_port_sig.ALU_result'length);
			when assign_41 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.reg1_contents xor CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.reg1_contents xor CtlToALU_port_sig.pc_reg;
			when assign_42 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm or CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm or CtlToALU_port_sig.pc_reg;
			when assign_43 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg xor CtlToALU_port_sig.reg2_contents;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg xor CtlToALU_port_sig.reg2_contents;
			when assign_44 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg or CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg or CtlToALU_port_sig.imm;
			when assign_45 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
			when assign_46 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.imm xor CtlToALU_port_sig.pc_reg;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.imm xor CtlToALU_port_sig.pc_reg;
			when assign_47 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= CtlToALU_port_sig.pc_reg xor CtlToALU_port_sig.imm;
				ALUtoCtl_port_sig.ALU_result <= CtlToALU_port_sig.pc_reg xor CtlToALU_port_sig.imm;
			when assign_48 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
			when assign_49 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
			when assign_50 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
			when assign_51 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
			when assign_52 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
			when assign_53 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
			when assign_54 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
			when assign_55 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
			when assign_56 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.reg1_contents, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
			when assign_57 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
			when assign_58 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
			when assign_59 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.reg2_contents and to_unsigned(31, CtlToALU_port_sig.reg2_contents'length)));
			when assign_60 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
			when assign_61 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.imm, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
			when assign_62 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.imm and to_unsigned(31, CtlToALU_port_sig.imm'length)));
			when assign_63 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_left(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_left(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
			when assign_64 =>
				active_state <= st_run_0;
				ALUtoCtl_data.ALU_result <= shift_right(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
				ALUtoCtl_port_sig.ALU_result <= shift_right(CtlToALU_port_sig.pc_reg, to_integer(CtlToALU_port_sig.pc_reg and to_unsigned(31, CtlToALU_port_sig.pc_reg'length)));
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	run_0 <= active_state = st_run_0;

end ALU_arch;

