
# @author :	Dino Mehmedagić
# @name   : 	enc_i_i_low.s
# @purpose: 	Test for i-immediate type of instruction with an attempt to eliminate as much of data switching as possible

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	addi x1,x0,-1
	addi x1,x1,1
	
_end:
	ebreak
