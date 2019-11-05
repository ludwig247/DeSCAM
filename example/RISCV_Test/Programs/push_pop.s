
# @author :	Don Dennis
# @name   : 	push_pop.s
# @purpose: 	Testing functions PUSH, POP and HALT. They are used as pseudo instructions in other programs.
# @notes  :     x3: push register, x4: pop register, x30: stack pointer, x31: return address

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x3,x0,1345		# x3 = 0x541 <-- value
	addi x30,x0,64		# x30 = 0x40 <-- stack pointer
	jal  x31,PUSH
	jal  x31,POP
HALT:
	nop			# end of ID stage of the last instruction
	nop			# end of EX stage of the last instruction
	nop			# end of MEM stage of the last instruction
	nop			# end of WB stage of the last instruction
_end:
	ebreak
PUSH:				# Increments stack pointer and pushes the value in x3 to stack
	addi x30,x30,4
	sw   x3,0(x30)  
	jalr x0,x31,0
POP:				# Pops the value from stack to x4 and decrements stack pointer
	lw   x4,0(x30)   
	addi x30,x30,-4
	jalr x0,x31,0
