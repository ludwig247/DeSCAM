
# @author :	Dino Mehmedagić
# @name   : 	instruction_switch.s
# @purpose: 	Test for switching of all types of instructions with an attempt to eliminate as much of data switching as possible

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

	add x0,x0,x0
	beq x0,x0,NEXT1
NEXT1:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT2
NEXT2:
	nop
	lw x0,0(x0)
	jalr x0,x0,32
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT3
NEXT3:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT4
NEXT4:
	nop
	lw x0,0(x0)
	jalr x0,x0,72
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT5
NEXT5:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT6
NEXT6:
	nop
	lw x0,0(x0)
	jalr x0,x0,112
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT7
NEXT7:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT8
NEXT8:
	nop
	lw x0,0(x0)
	jalr x0,x0,152
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT9
NEXT9:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT10
NEXT10:
	nop
	lw x0,0(x0)
	jalr x0,x0,192
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT11
NEXT11:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT12
NEXT12:
	nop
	lw x0,0(x0)
	jalr x0,x0,232
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT13
NEXT13:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT14
NEXT14:
	nop
	lw x0,0(x0)
	jalr x0,x0,272
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT15
NEXT15:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT16
NEXT16:
	nop
	lw x0,0(x0)
	jalr x0,x0,312
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT17
NEXT17:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT18
NEXT18:
	nop
	lw x0,0(x0)
	jalr x0,x0,352
	nop
	nop
	add x0,x0,x0
	beq x0,x0,NEXT19
NEXT19:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT20
NEXT20:
	nop
	lw x0,0(x0)
	jalr x0,x0,392
	nop
	nop	
	ebreak
