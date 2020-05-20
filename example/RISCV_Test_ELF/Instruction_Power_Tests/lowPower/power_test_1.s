
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
	add x0,x0,x0
	beq x0,x0,NEXT3
NEXT3:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT4
NEXT4:
	add x0,x0,x0
	beq x0,x0,NEXT5
NEXT5:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT6
NEXT6:
	add x0,x0,x0
	beq x0,x0,NEXT7
NEXT7:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT8
NEXT8:
	add x0,x0,x0
	beq x0,x0,NEXT9
NEXT9:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT10
NEXT10:
	add x0,x0,x0
	beq x0,x0,NEXT11
NEXT11:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT12
NEXT12:
	add x0,x0,x0
	beq x0,x0,NEXT13
NEXT13:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT14
NEXT14:
	add x0,x0,x0
	beq x0,x0,NEXT15
NEXT15:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT16
NEXT16:
	add x0,x0,x0
	beq x0,x0,NEXT17
NEXT17:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT18
NEXT18:
	add x0,x0,x0
	beq x0,x0,NEXT19
NEXT19:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT20
NEXT20:
	add x0,x0,x0
	beq x0,x0,NEXT21
NEXT21:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT22
NEXT22:
	add x0,x0,x0
	beq x0,x0,NEXT23
NEXT23:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT24
NEXT24:
	add x0,x0,x0
	beq x0,x0,NEXT25
NEXT25:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT26
NEXT26:
	add x0,x0,x0
	beq x0,x0,NEXT27
NEXT27:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT28
NEXT28:
	add x0,x0,x0
	beq x0,x0,NEXT29
NEXT29:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT30
NEXT30:
	add x0,x0,x0
	beq x0,x0,NEXT31
NEXT31:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT32
NEXT32:
	add x0,x0,x0
	beq x0,x0,NEXT33
NEXT33:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT34
NEXT34:
	add x0,x0,x0
	beq x0,x0,NEXT35
NEXT35:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT36
NEXT36:
	add x0,x0,x0
	beq x0,x0,NEXT37
NEXT37:
	sw x0,0(x0)
	lui x0,0
	jal x0,NEXT38
NEXT38:
	add x0,x0,x0
	beq x0,x0,NEXT39
NEXT39:
	sw x0,0(x0)
	lui x0,0
	jal x0,END
END:
	ebreak
