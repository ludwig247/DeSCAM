
# @author :	Dino Mehmedagić
# @name   : 	instruction_switch.s
# @purpose: 	Test for switching of all types of instructions with an attempt to eliminate as much of data switching as possible

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

	add x0,x0,x0
	beq x0,x0,NEXT2
NEXT1:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT2
NEXT2:
	nop
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT4
NEXT3:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT4
NEXT4:
	nop
	nop
	nop
	ebreak
