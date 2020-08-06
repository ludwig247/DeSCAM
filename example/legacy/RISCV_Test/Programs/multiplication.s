
# @author :	Don Dennis
# @name   : 	multiplication.s
# @purpose: 	Multiplication using repeated addition.
# @notes  :	x1: a, x2: b, x3: is_neg, x5: ans

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,11		# x1 = 0x0B <-- a
	addi x2,x0,12		# x2 = 0x0C <-- b
	addi x3,x0,0
	addi x5,x0,0
	blt  x0,x1,LOOP
	addi x3,x0,1
	addi x4,x0,-1
	xor  x1,x1,x4
	addi x1,x1,1
LOOP:
	beq  x0,x1,DONE
	add  x5,x5,x2
	addi x1,x1,-1
	jal  x0,LOOP
DONE: 
	beq  x0,x3,HALT
	addi x4,x0,-1
	xor  x5,x5,x4
	addi x5,x5,1
HALT:
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
