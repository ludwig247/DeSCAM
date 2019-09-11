-- External data type definition package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SCAM_Model_types is
	type ME_MaskType is (MT_B, MT_BU, MT_H, MT_HU, MT_W, MT_X);
	type ME_AccessType is (ME_RD, ME_WR, ME_X);
	type CUtoME_IF is record
		addrIn: unsigned(31 downto 0);
		dataIn: unsigned(31 downto 0);
		mask: ME_MaskType;
		req: ME_AccessType;
	end record;
	type AccessType_Reg is (REG_RD, REG_WR);
	type CtlToRegs_IF is record
		dst: unsigned(31 downto 0);
		dst_data: unsigned(31 downto 0);
		req: AccessType_Reg;
		src1: unsigned(31 downto 0);
		src2: unsigned(31 downto 0);
	end record;
	type EncType is (B, Error_Type, I, J, R, S, U);
	type InstrType is (And_Instr, Or_Instr, Unknown, Xor_Instr, add, addI, andI, auipc, beq, bge, bgeu, blt, bltu, bne, jal, jalr, lb, lbu, lh, lhu, lui, lw, orI, sb, sh, sllI, sll_Instr, slt, sltI, sltIu, sltu, sraI, sra_Instr, srlI, srl_Instr, sub, sw, xorI);
	type DecodedInstr is record
		encType: EncType;
		imm: unsigned(31 downto 0);
		instrType: InstrType;
		rd_addr: unsigned(31 downto 0);
		rs1_addr: unsigned(31 downto 0);
		rs2_addr: unsigned(31 downto 0);
	end record;
	type MEtoCU_IF is record
		loadedData: unsigned(31 downto 0);
	end record;
	type RegsToCtl_IF is record
		contents1: unsigned(31 downto 0);
		contents2: unsigned(31 downto 0);
	end record;
end package SCAM_Model_types;

