
# @author :	Dino Mehmedagić
# @name   : 	instruction_switch.s
# @purpose: 	Test for switching of all types of instructions with an attempt to eliminate as much of data switching as possible

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)
	add x0,x0,x0
	sw x0,0(x0)
	lui x0,0
	nop
	lw x0,0(x0)


END:
	ebreak
