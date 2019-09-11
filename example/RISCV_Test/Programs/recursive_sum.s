
# @author :	Don Dennis
# @name   : 	recursive_sum.s
# @purpose: 	Finds sum of the first N numbers recursively. Demonstrates how recursive functions can be added.
# @notes  :	x1: N, x29: return value, x30: stack Pointer, x31: return address

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,9		# x1  = 0x09  <-- N
	addi x30,x0,256 	# x30 = 0x100 <-- stack pointer
	jal  x31,FAB
HALT:
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
FAB:
	addi x3,x31,0
	jal  x31,PUSH
	addi x4,x0,2
	blt  x1,x4,RET_ONE
	add  x3,x0,x1
	jal  x31,PUSH
	addi x1,x1,-1
	jal  x31,FAB
	jal  x31,POP
	add  x29,x29,x3
	addi x3,x0,0
	beq  x3,x0,RET
RET_ONE: 
	addi x29,x0,1
RET:
	jal  x31,POP
	add  x31,x0,x3
	jalr x0,x31,0

PUSH:
	addi x30,x30,4
	sw   x3,0(x30)   
	jalr x0,x31,0
POP:
	lw   x3,0(x30)  
	addi x30,x30,-4
	jalr x0,x31,0
