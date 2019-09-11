
# @author :	Don Dennis
# @name   : 	fibonacci.s
# @purpose: 	Find the Nth fibonacci number.
# @notes  :	x5: N, x3: ans

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x5,x0,9		# x5 = 0x09 <-- N
	addi x1,x0,1 		# x1 <-- a1
	addi x2,x0,0 		# x2 <-- a0
	addi x3,x0,0 		# x3 <-- ans
	addi x4,x0,1 		# x4 <-- i
FOR:
	add  x3,x1,x2
	add  x2,x0,x1
	add  x1,x0,x3
	addi x4,x4,1
	blt  x4,x5,FOR
HALT:
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
    ebreak
