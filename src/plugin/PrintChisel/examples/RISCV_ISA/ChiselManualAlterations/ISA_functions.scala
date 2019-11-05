package isa
import chisel3._
import chisel3.util._

object instructions {
  val instr_unknown = 0.U(32.W)
  val instr_add = 1.U(32.W)
  val instr_sub = 2.U(32.W)
  val instr_sll = 3.U(32.W)
  val instr_slt = 4.U(32.W)
  val instr_sltu = 5.U(32.W)
  val instr_xor = 6.U(32.W)
  val instr_srl = 7.U(32.W)
  val instr_sra = 8.U(32.W)
  val instr_or = 9.U(32.W)
  val instr_and = 10.U(32.W)
  val instr_addi = 11.U(32.W)
  val instr_slli = 12.U(32.W)
  val instr_slti = 13.U(32.W)
  val instr_sltui = 14.U(32.W)
  val instr_xori = 15.U(32.W)
  val instr_srli = 16.U(32.W)
  val instr_srai = 17.U(32.W)
  val instr_ori = 18.U(32.W)
  val instr_andi = 19.U(32.W)
  val instr_lb = 20.U(32.W)
  val instr_lh = 21.U(32.W)
  val instr_lw = 22.U(32.W)
  val instr_lbu = 23.U(32.W)
  val instr_lhu = 24.U(32.W)
  val instr_jalr = 25.U(32.W)
  val instr_sb = 26.U(32.W)
  val instr_sh = 27.U(32.W)
  val instr_sw = 28.U(32.W)
  val instr_beq = 29.U(32.W)
  val instr_bne = 30.U(32.W)
  val instr_blt = 31.U(32.W)
  val instr_bge = 32.U(32.W)
  val instr_bltu = 33.U(32.W)
  val instr_bgeu = 34.U(32.W)
  val instr_lui = 35.U(32.W)
  val instr_auipc = 36.U(32.W)
  val instr_jal = 37.U(32.W)

}

object ISA_functions {
  import instructions._
  //val instr_unknown :: instr_add :: instr_sub :: instr_sll :: instr_slt :: instr_sltu :: instr_xor :: instr_srl :: instr_sra :: instr_or :: instr_and :: instr_addi :: instr_slli :: instr_slti :: instr_sltui :: instr_xori :: instr_srli :: instr_srai :: instr_ori :: instr_andi :: instr_lb :: instr_lh :: instr_lw :: instr_lbu :: instr_lhu :: instr_jalr :: instr_sb :: instr_sh :: instr_sw :: instr_beq :: instr_bne :: instr_blt :: instr_bge :: instr_bltu :: instr_bgeu :: instr_lui :: instr_auipc :: instr_jal ::  Nil = Enum(38)
	val alu_x :: alu_add :: alu_sub :: alu_sll :: alu_srl :: alu_sra :: alu_and :: alu_or :: alu_xor :: alu_slt :: alu_sltu :: alu_copy1 ::  Nil = Enum(12)
	val enc_r :: enc_i_i :: enc_i_l :: enc_i_j :: enc_s :: enc_b :: enc_u :: enc_j :: enc_err ::  Nil = Enum(9)
	val mt_x :: mt_w :: mt_h :: mt_b :: mt_hu :: mt_bu ::  Nil = Enum(6)


	def branchPCcalculation(aluResult: UInt, encodedInstr: UInt, pcReg: UInt): UInt = {
    val tmp = Wire(UInt())
    tmp := 0.U(32.W)
		when (((getInstrType(encodedInstr) === instr_beq) && (aluResult === 0.U(32.W)))) {
			tmp := ((pcReg + getImmediate(encodedInstr)))
		}
		.elsewhen (!((getInstrType(encodedInstr) === instr_beq) && (aluResult === 0.U(32.W))) && ((getInstrType(encodedInstr) === instr_bne) && (aluResult != 0.U(32.W)))) { 
			tmp := ((pcReg + getImmediate(encodedInstr)))
		}
		.elsewhen (!((getInstrType(encodedInstr) === instr_beq) && (aluResult === 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_bne) && (aluResult != 0.U(32.W))) && ((getInstrType(encodedInstr) === instr_blt) && (aluResult === 1.U(32.W)))) { 
			tmp := ((pcReg + getImmediate(encodedInstr)))
		}
		.elsewhen (!((getInstrType(encodedInstr) === instr_beq) && (aluResult === 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_bne) && (aluResult != 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_blt) && (aluResult === 1.U(32.W))) && ((getInstrType(encodedInstr) === instr_bge) && (aluResult === 0.U(32.W)))) { 
			tmp := ((pcReg + getImmediate(encodedInstr)))
		}
		.elsewhen (!((getInstrType(encodedInstr) === instr_beq) && (aluResult === 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_bne) && (aluResult != 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_blt) && (aluResult === 1.U(32.W))) && !((getInstrType(encodedInstr) === instr_bge) && (aluResult === 0.U(32.W))) && ((getInstrType(encodedInstr) === instr_bltu) && (aluResult === 1.U(32.W)))) { 
			tmp := ((pcReg + getImmediate(encodedInstr)))
		}
		.elsewhen (!((getInstrType(encodedInstr) === instr_beq) && (aluResult === 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_bne) && (aluResult != 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_blt) && (aluResult === 1.U(32.W))) && !((getInstrType(encodedInstr) === instr_bge) && (aluResult === 0.U(32.W))) && !((getInstrType(encodedInstr) === instr_bltu) && (aluResult === 1.U(32.W))) && ((getInstrType(encodedInstr) === instr_bgeu) && (aluResult === 0.U(32.W)))) { 
			tmp := ((pcReg + getImmediate(encodedInstr)))
		}
		.otherwise {
			tmp := ((pcReg + 4.U(32.W)))
		}
		tmp
	}

	def getALUfunc(instr: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when ((((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc))) {
			tmp := (alu_add)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && (((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne))) { 
			tmp := (alu_sub)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && ((instr === instr_sll) || (instr === instr_slli))) { 
			tmp := (alu_sll)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && ((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge))) { 
			tmp := (alu_slt)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && ((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu))) { 
			tmp := (alu_sltu)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && !((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu)) && ((instr === instr_xor) || (instr === instr_xori))) { 
			tmp := (alu_xor)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && !((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu)) && !((instr === instr_xor) || (instr === instr_xori)) && ((instr === instr_srl) || (instr === instr_srli))) { 
			tmp := (alu_srl)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && !((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu)) && !((instr === instr_xor) || (instr === instr_xori)) && !((instr === instr_srl) || (instr === instr_srli)) && ((instr === instr_sra) || (instr === instr_srai))) { 
			tmp := (alu_sra)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && !((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu)) && !((instr === instr_xor) || (instr === instr_xori)) && !((instr === instr_srl) || (instr === instr_srli)) && !((instr === instr_sra) || (instr === instr_srai)) && ((instr === instr_or) || (instr === instr_ori))) { 
			tmp := (alu_or)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && !((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu)) && !((instr === instr_xor) || (instr === instr_xori)) && !((instr === instr_srl) || (instr === instr_srli)) && !((instr === instr_sra) || (instr === instr_srai)) && !((instr === instr_or) || (instr === instr_ori)) && ((instr === instr_and) || (instr === instr_andi))) { 
			tmp := (alu_and)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && !((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu)) && !((instr === instr_xor) || (instr === instr_xori)) && !((instr === instr_srl) || (instr === instr_srli)) && !((instr === instr_sra) || (instr === instr_srai)) && !((instr === instr_or) || (instr === instr_ori)) && !((instr === instr_and) || (instr === instr_andi)) && ((instr === instr_jalr) || (instr === instr_jal))) { 
			tmp := (alu_x)
		}
		.elsewhen (!(((((((((((instr === instr_add) || (instr === instr_addi)) || (instr === instr_lb)) || (instr === instr_lh)) || (instr === instr_lw)) || (instr === instr_lbu)) || (instr === instr_lhu)) || (instr === instr_sb)) || (instr === instr_sh)) || (instr === instr_sw)) || (instr === instr_auipc)) && !(((instr === instr_sub) || (instr === instr_beq)) || (instr === instr_bne)) && !((instr === instr_sll) || (instr === instr_slli)) && !((((instr === instr_slt) || (instr === instr_slti)) || (instr === instr_blt)) || (instr === instr_bge)) && !((((instr === instr_sltu) || (instr === instr_sltui)) || (instr === instr_bltu)) || (instr === instr_bgeu)) && !((instr === instr_xor) || (instr === instr_xori)) && !((instr === instr_srl) || (instr === instr_srli)) && !((instr === instr_sra) || (instr === instr_srai)) && !((instr === instr_or) || (instr === instr_ori)) && !((instr === instr_and) || (instr === instr_andi)) && !((instr === instr_jalr) || (instr === instr_jal)) && (instr === instr_lui)) { 
			tmp := (alu_copy1)
		}
		.otherwise {
			tmp := (alu_x)
		}
		tmp
	}

	/*def getALUresult(aluFunction: UInt, operand1: UInt, operand2: UInt): UInt = {
		val tmp = Wire(UInt())
		//tmp := 0.U(32.W)
		//tmp := ((operand1 << (operand2(18,0) & 31.U(19.W)))(31, 0))

		when ((aluFunction === alu_add)) {
			tmp := ((operand1 + operand2))
		}
			.elsewhen (!(aluFunction === alu_add) && (aluFunction === alu_sub)) {
				tmp := ((operand1 + (operand2 * 4294967295L.U(32.W))))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && (aluFunction === alu_and)) {
				tmp := ((operand1 & operand2))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && (aluFunction === alu_or)) {
				tmp := ((operand1 | operand2))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && (aluFunction === alu_xor)) {
				tmp := ((operand1 ^ operand2))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && (aluFunction === alu_slt) && ((operand1.asSInt) < (operand2.asSInt))) {
				tmp := (1.U(32.W))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && (aluFunction === alu_slt) && !((operand1.asSInt) < (operand2.asSInt))) {
				tmp := (0.U(32.W))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && (aluFunction === alu_sltu) && (operand1 < operand2)) {
				tmp := (1.U(32.W))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && (aluFunction === alu_sltu) && !(operand1 < operand2)) {
				tmp := (0.U(32.W))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && (aluFunction === alu_sll)) {
				tmp := ((operand1 << (operand2(18,0) & 31.U(19.W)))(31, 0))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && !(aluFunction === alu_sll) && (aluFunction === alu_sra)) {
				tmp := ((((operand1.asSInt) >> ((operand2 & 31.U(32.W))))(31, 0).asUInt))
				//tmp := (0.U(32.W))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && !(aluFunction === alu_sll) && !(aluFunction === alu_sra) && (aluFunction === alu_srl)) {
				tmp := ((operand1 >> (operand2 & 31.U(32.W)))(31, 0))
			}
			.elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && !(aluFunction === alu_sll) && !(aluFunction === alu_sra) && !(aluFunction === alu_srl) && (aluFunction === alu_copy1)) {
				tmp := (operand1)(31,0)
			}
			.otherwise {
				tmp := (0.U(32.W))
			}
		tmp
	}*/

  def getALUresult(aluFunction: UInt, operand1: UInt, operand2: UInt): UInt = {
    val tmp = Wire(UInt())
    when ((aluFunction === alu_add)) {
      tmp := ((operand1 + operand2))
    }
    .elsewhen (!(aluFunction === alu_add) && (aluFunction === alu_sub)) {
      tmp := ((operand1 + (operand2 * 4294967295L.U(32.W))))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && (aluFunction === alu_and)) {
      tmp := ((operand1 & operand2))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && (aluFunction === alu_or)) {
      tmp := ((operand1 | operand2))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && (aluFunction === alu_xor)) {
      tmp := ((operand1 ^ operand2))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && (aluFunction === alu_slt) && ((operand1.asSInt) < (operand2.asSInt))) {
      tmp := (1.U(32.W))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && (aluFunction === alu_slt) && !((operand1.asSInt) < (operand2.asSInt))) {
      tmp := (0.U(32.W))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && (aluFunction === alu_sltu) && (operand1 < operand2)) {
      tmp := (1.U(32.W))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && (aluFunction === alu_sltu) && !(operand1 < operand2)) {
      tmp := (0.U(32.W))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && (aluFunction === alu_sll)) {
      tmp := ((operand1 << (operand2(18,0) & 31.U(19.W)))(31, 0))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && !(aluFunction === alu_sll) && (aluFunction === alu_sra)) {
      tmp := ((((operand1.asSInt) >> ((operand2 & 31.U(32.W))))(31, 0).asUInt))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && !(aluFunction === alu_sll) && !(aluFunction === alu_sra) && (aluFunction === alu_srl)) {
      tmp := ((operand1 >> (operand2 & 31.U(32.W)))(31, 0))
    }
    .elsewhen (!(aluFunction === alu_add) && !(aluFunction === alu_sub) && !(aluFunction === alu_and) && !(aluFunction === alu_or) && !(aluFunction === alu_xor) && !(aluFunction === alu_slt) && !(aluFunction === alu_sltu) && !(aluFunction === alu_sll) && !(aluFunction === alu_sra) && !(aluFunction === alu_srl) && (aluFunction === alu_copy1)) {
      tmp := (operand1)
    }
    .otherwise {
      tmp := (0.U(32.W))
    }
    tmp
  }

	//tmp := (((operand1.asSInt) >> (((operand2 & 31.U(32.W)).asSInt).asUInt)))

	def getEncType(encodedInstr: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when (((encodedInstr & 127.U(32.W)) === 51.U(32.W))) {
			tmp := (enc_r)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W))) { 
			tmp := (enc_i_i)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) { 
			tmp := (enc_i_l)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) { 
			tmp := (enc_i_j)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 35.U(32.W))) { 
			tmp := (enc_s)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W))) { 
			tmp := (enc_b)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && (((encodedInstr & 127.U(32.W)) === 55.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 23.U(32.W)))) { 
			tmp := (enc_u)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr & 127.U(32.W)) === 55.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 23.U(32.W))) && ((encodedInstr & 127.U(32.W)) === 111.U(32.W))) { 
			tmp := (enc_j)
		}
		.otherwise {
			tmp := (enc_err)
		}
		tmp
	}

	def getEncUALUresult(encodedInstr: UInt, pcReg: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when ((getInstrType(encodedInstr) === instr_lui)) {
			tmp := (getALUresult(alu_copy1,getImmediate(encodedInstr),0.U(32.W)))
		}
		.otherwise {
			tmp := (getALUresult(alu_add,pcReg,getImmediate(encodedInstr)))
		}
		tmp
	}

	def getImmediate(encodedInstr: UInt): UInt = {
		val tmp = Wire(UInt())
		when (((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && (((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
			tmp := ((encodedInstr >> 20.U(32.W))(31, 0))
		}
			.elsewhen (((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && !(((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
				tmp := (((-4096.S(32.W).asUInt) | (encodedInstr >> 20.U(32.W))(31, 0)))
			}
			.elsewhen (!((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && ((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && (((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
				tmp := ((((encodedInstr >> 20.U(32.W))(31, 0) & 4064.U(32.W)) | ((encodedInstr >> 7.U(32.W))(31, 0) & 31.U(32.W))))
			}
			.elsewhen (!((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && ((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !(((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
				tmp := (((-4096.S(32.W).asUInt) | (((encodedInstr >> 20.U(32.W))(31, 0) & 4064.U(32.W)) | ((encodedInstr >> 7.U(32.W))(31, 0) & 31.U(32.W)))))
			}
			.elsewhen (!((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && (((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
				tmp := (((((encodedInstr << 4)(31, 0) & 2048.U(32.W)) | ((encodedInstr >> 20.U(32.W))(31, 0) & 2016.U(32.W))) | ((encodedInstr >> 7.U(32.W))(31, 0) & 30.U(32.W))))
			}
			.elsewhen (!((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
				tmp := (((-4096.S(32.W).asUInt) | ((((encodedInstr << 4)(31, 0) & 2048.U(32.W)) | ((encodedInstr >> 20.U(32.W))(31, 0) & 2016.U(32.W))) | ((encodedInstr >> 7.U(32.W))(31, 0) & 30.U(32.W)))))
			}
			.elsewhen (!((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && (((encodedInstr & 127.U(32.W)) === 55.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 23.U(32.W)))) {
				tmp := ((encodedInstr & (-4096.S(32.W).asUInt)))
			}
			.elsewhen (!((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr & 127.U(32.W)) === 55.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 23.U(32.W))) && ((encodedInstr & 127.U(32.W)) === 111.U(32.W)) && (((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
				tmp := ((((encodedInstr & 1044480.U(32.W)) | ((encodedInstr >> 9.U(32.W))(31, 0) & 2048.U(32.W))) | ((encodedInstr >> 20.U(32.W))(31, 0) & 2046.U(32.W))))
			}
			.elsewhen (!((((encodedInstr & 127.U(32.W)) === 19.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr & 127.U(32.W)) === 55.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 23.U(32.W))) && ((encodedInstr & 127.U(32.W)) === 111.U(32.W)) && !(((encodedInstr >> 31.U(32.W))(31, 0) & 1.U(32.W)) === 0.U(32.W))) {
				tmp := (((-1048576.S(32.W).asUInt) | (((encodedInstr & 1044480.U(32.W)) | ((encodedInstr >> 9.U(32.W))(31, 0) & 2048.U(32.W))) | ((encodedInstr >> 20.U(32.W))(31, 0) & 2046.U(32.W)))))
			}
			.otherwise {
				tmp := (0.U(32.W))
			}
		tmp
	}


	def getInstrType(encodedInstr: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W))) {
			tmp := (instr_add)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 32.U(32.W))) {
			tmp := (instr_sub)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 32.U(32.W))) {
			tmp := (instr_unknown)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W))) { 
			tmp := (instr_sll)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W))) { 
			tmp := (instr_slt)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W))) { 
			tmp := (instr_sltu)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W))) { 
			tmp := (instr_xor)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && (((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W))) {
			tmp := (instr_srl)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 32.U(32.W))) {
			tmp := (instr_sra)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 32.U(32.W))) {
			tmp := (instr_unknown)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W))) { 
			tmp := (instr_or)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 7.U(32.W))) { 
			tmp := (instr_and)
		}
		.elsewhen (((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 7.U(32.W))) { 
			tmp := (instr_unknown)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W))) { 
			tmp := (instr_addi)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W))) { 
			tmp := (instr_slli)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W))) { 
			tmp := (instr_slti)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W))) { 
			tmp := (instr_sltui)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W))) { 
			tmp := (instr_xori)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && (((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W))) {
			tmp := (instr_srli)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 32.U(32.W))) {
			tmp := (instr_srai)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 20.U(32.W))(31, 0) & 127.U(32.W)) === 32.U(32.W))) {
			tmp := (instr_unknown)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W))) { 
			tmp := (instr_ori)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 7.U(32.W))) { 
			tmp := (instr_andi)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 7.U(32.W))) { 
			tmp := (instr_unknown)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W))) { 
			tmp := (instr_lb)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W))) { 
			tmp := (instr_lh)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W))) { 
			tmp := (instr_lw)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W))) { 
			tmp := (instr_lbu)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W))) { 
			tmp := (instr_lhu)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W))) { 
			tmp := (instr_unknown)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) { 
			tmp := (instr_jalr)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W))) { 
			tmp := (instr_sb)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W))) { 
			tmp := (instr_sh)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W))) { 
			tmp := (instr_sw)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 2.U(32.W))) { 
			tmp := (instr_unknown)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W))) { 
			tmp := (instr_beq)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W))) { 
			tmp := (instr_bne)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W))) { 
			tmp := (instr_blt)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W))) { 
			tmp := (instr_bge)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W))) { 
			tmp := (instr_bltu)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W)) && (((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 7.U(32.W))) { 
			tmp := (instr_bgeu)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 0.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 1.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 4.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 5.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 6.U(32.W)) && !(((encodedInstr >> 12.U(32.W))(31, 0) & 7.U(32.W)) === 7.U(32.W))) { 
			tmp := (instr_unknown)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 55.U(32.W))) { 
			tmp := (instr_lui)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 55.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 23.U(32.W))) { 
			tmp := (instr_auipc)
		}
		.elsewhen (!((encodedInstr & 127.U(32.W)) === 51.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 19.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 3.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 103.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 35.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 99.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 55.U(32.W)) && !((encodedInstr & 127.U(32.W)) === 23.U(32.W)) && ((encodedInstr & 127.U(32.W)) === 111.U(32.W))) { 
			tmp := (instr_jal)
		}
		.otherwise {
			tmp := (instr_unknown)
		}
		tmp
	}

	def getMemoryMask(instr: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when (((instr === instr_lb) || (instr === instr_sb))) {
			tmp := (mt_b)
		}
		.elsewhen (!((instr === instr_lb) || (instr === instr_sb)) && ((instr === instr_lh) || (instr === instr_sh))) { 
			tmp := (mt_h)
		}
		.elsewhen (!((instr === instr_lb) || (instr === instr_sb)) && !((instr === instr_lh) || (instr === instr_sh)) && ((instr === instr_lw) || (instr === instr_sw))) { 
			tmp := (mt_w)
		}
		.elsewhen (!((instr === instr_lb) || (instr === instr_sb)) && !((instr === instr_lh) || (instr === instr_sh)) && !((instr === instr_lw) || (instr === instr_sw)) && (instr === instr_lbu)) { 
			tmp := (mt_bu)
		}
		.elsewhen (!((instr === instr_lb) || (instr === instr_sb)) && !((instr === instr_lh) || (instr === instr_sh)) && !((instr === instr_lw) || (instr === instr_sw)) && !(instr === instr_lbu) && (instr === instr_lhu)) { 
			tmp := (mt_hu)
		}
		.otherwise {
			tmp := (mt_x)
		}
		tmp
	}

	def getRdAddr(encodedInstr: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when (((((((((encodedInstr & 127.U(32.W)) === 51.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 19.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 55.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 23.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 111.U(32.W)))) {
			tmp := (((encodedInstr >> 7.U(32.W))(31, 0) & 31.U(32.W)))
		}
		.otherwise {
			tmp := (0.U(32.W))
		}
		tmp
	}

	def getRs1Addr(encodedInstr: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when ((((((((encodedInstr & 127.U(32.W)) === 51.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 19.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 3.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 103.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 35.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 99.U(32.W)))) {
			tmp := (((encodedInstr >> 15.U(32.W))(31, 0) & 31.U(32.W)))
		}
		.otherwise {
			tmp := (0.U(32.W))
		}
		tmp
	}

	def getRs2Addr(encodedInstr: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when (((((encodedInstr & 127.U(32.W)) === 51.U(32.W)) || ((encodedInstr & 127.U(32.W)) === 35.U(32.W))) || ((encodedInstr & 127.U(32.W)) === 99.U(32.W)))) {
			tmp := (((encodedInstr >> 20.U(32.W))(31, 0) & 31.U(32.W)))
		}
		.otherwise {
			tmp := (0.U(32.W))
		}
		tmp
	}

	def readRegfile(regfile_reg_file_01: UInt, regfile_reg_file_02: UInt, regfile_reg_file_03: UInt, regfile_reg_file_04: UInt, regfile_reg_file_05: UInt, regfile_reg_file_06: UInt, regfile_reg_file_07: UInt, regfile_reg_file_08: UInt, regfile_reg_file_09: UInt, regfile_reg_file_10: UInt, regfile_reg_file_11: UInt, regfile_reg_file_12: UInt, regfile_reg_file_13: UInt, regfile_reg_file_14: UInt, regfile_reg_file_15: UInt, regfile_reg_file_16: UInt, regfile_reg_file_17: UInt, regfile_reg_file_18: UInt, regfile_reg_file_19: UInt, regfile_reg_file_20: UInt, regfile_reg_file_21: UInt, regfile_reg_file_22: UInt, regfile_reg_file_23: UInt, regfile_reg_file_24: UInt, regfile_reg_file_25: UInt, regfile_reg_file_26: UInt, regfile_reg_file_27: UInt, regfile_reg_file_28: UInt, regfile_reg_file_29: UInt, regfile_reg_file_30: UInt, regfile_reg_file_31: UInt, src: UInt): UInt = {
    val tmp = Wire(UInt())
    //tmp := 0.U(32.W)
		when ((src === 0.U(32.W))) {
			tmp := (0.U(32.W))
		}
		.elsewhen (!(src === 0.U(32.W)) && (src === 1.U(32.W))) { 
			tmp := (regfile_reg_file_01)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && (src === 2.U(32.W))) { 
			tmp := (regfile_reg_file_02)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && (src === 3.U(32.W))) { 
			tmp := (regfile_reg_file_03)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && (src === 4.U(32.W))) { 
			tmp := (regfile_reg_file_04)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && (src === 5.U(32.W))) { 
			tmp := (regfile_reg_file_05)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && (src === 6.U(32.W))) { 
			tmp := (regfile_reg_file_06)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && (src === 7.U(32.W))) { 
			tmp := (regfile_reg_file_07)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && (src === 8.U(32.W))) { 
			tmp := (regfile_reg_file_08)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && (src === 9.U(32.W))) { 
			tmp := (regfile_reg_file_09)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && (src === 10.U(32.W))) { 
			tmp := (regfile_reg_file_10)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && (src === 11.U(32.W))) { 
			tmp := (regfile_reg_file_11)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && (src === 12.U(32.W))) { 
			tmp := (regfile_reg_file_12)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && (src === 13.U(32.W))) { 
			tmp := (regfile_reg_file_13)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && (src === 14.U(32.W))) { 
			tmp := (regfile_reg_file_14)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && (src === 15.U(32.W))) { 
			tmp := (regfile_reg_file_15)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && (src === 16.U(32.W))) { 
			tmp := (regfile_reg_file_16)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && (src === 17.U(32.W))) { 
			tmp := (regfile_reg_file_17)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && (src === 18.U(32.W))) { 
			tmp := (regfile_reg_file_18)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && (src === 19.U(32.W))) { 
			tmp := (regfile_reg_file_19)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && (src === 20.U(32.W))) { 
			tmp := (regfile_reg_file_20)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && (src === 21.U(32.W))) { 
			tmp := (regfile_reg_file_21)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && (src === 22.U(32.W))) { 
			tmp := (regfile_reg_file_22)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && (src === 23.U(32.W))) { 
			tmp := (regfile_reg_file_23)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && !(src === 23.U(32.W)) && (src === 24.U(32.W))) { 
			tmp := (regfile_reg_file_24)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && !(src === 23.U(32.W)) && !(src === 24.U(32.W)) && (src === 25.U(32.W))) { 
			tmp := (regfile_reg_file_25)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && !(src === 23.U(32.W)) && !(src === 24.U(32.W)) && !(src === 25.U(32.W)) && (src === 26.U(32.W))) { 
			tmp := (regfile_reg_file_26)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && !(src === 23.U(32.W)) && !(src === 24.U(32.W)) && !(src === 25.U(32.W)) && !(src === 26.U(32.W)) && (src === 27.U(32.W))) { 
			tmp := (regfile_reg_file_27)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && !(src === 23.U(32.W)) && !(src === 24.U(32.W)) && !(src === 25.U(32.W)) && !(src === 26.U(32.W)) && !(src === 27.U(32.W)) && (src === 28.U(32.W))) { 
			tmp := (regfile_reg_file_28)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && !(src === 23.U(32.W)) && !(src === 24.U(32.W)) && !(src === 25.U(32.W)) && !(src === 26.U(32.W)) && !(src === 27.U(32.W)) && !(src === 28.U(32.W)) && (src === 29.U(32.W))) { 
			tmp := (regfile_reg_file_29)
		}
		.elsewhen (!(src === 0.U(32.W)) && !(src === 1.U(32.W)) && !(src === 2.U(32.W)) && !(src === 3.U(32.W)) && !(src === 4.U(32.W)) && !(src === 5.U(32.W)) && !(src === 6.U(32.W)) && !(src === 7.U(32.W)) && !(src === 8.U(32.W)) && !(src === 9.U(32.W)) && !(src === 10.U(32.W)) && !(src === 11.U(32.W)) && !(src === 12.U(32.W)) && !(src === 13.U(32.W)) && !(src === 14.U(32.W)) && !(src === 15.U(32.W)) && !(src === 16.U(32.W)) && !(src === 17.U(32.W)) && !(src === 18.U(32.W)) && !(src === 19.U(32.W)) && !(src === 20.U(32.W)) && !(src === 21.U(32.W)) && !(src === 22.U(32.W)) && !(src === 23.U(32.W)) && !(src === 24.U(32.W)) && !(src === 25.U(32.W)) && !(src === 26.U(32.W)) && !(src === 27.U(32.W)) && !(src === 28.U(32.W)) && !(src === 29.U(32.W)) && (src === 30.U(32.W))) { 
			tmp := (regfile_reg_file_30)
		}
		.otherwise {
			tmp := (regfile_reg_file_31)
		}
		tmp
	}

}

