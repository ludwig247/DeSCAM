
# @author :	Dino Mehmedagić
# @name   : 	enc_b.s
# @purpose: 	Test for branching with an attempt to average out the power dependency on data and the initial addi instructions

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,-1		# x1 = 0xFFFFFFFF
	addi x2,x0,2047        	# x2 = 0x000007FF
	addi x3,x0,2047		# x3 = x2 = 0x000007FF
EQ1:
	beq x3,x2,NUGRT2
NUGRT1:
	bgeu x0,x1,DEBUG
NOTEQ1:
	bne x2,x1,NNOTEQ2
NNOTEQ1:
	bne x2,x3,DEBUG
LESST1:
	blt x1,x2,NULESS2
NULESS1:
	bltu x1,x0,DEBUG
GRTT1:
	bge x2,x1,NGRTT2
NGRTT1:
	bge x1,x2,DEBUG
ULESS1:
	bltu x0,x1,NLESST2
NLESST1:
	blt x2,x21,DEBUG
UGRT1:
	bgeu x1,x0,NEQ2
NEQ1:
	beq x3,x0,DEBUG

EQ2:
	beq x3,x2,NUGRT3
NUGRT2:
	bgeu x0,x1,DEBUG
NOTEQ2:
	bne x2,x1,NNOTEQ3
NNOTEQ2:
	bne x2,x3,DEBUG
LESST2:
	blt x1,x2,NULESS3
NULESS2:
	bltu x1,x0,DEBUG
GRTT2:
	bge x2,x1,NGRTT3
NGRTT2:
	bge x1,x2,DEBUG
ULESS2:
	bltu x0,x1,NLESST3
NLESST2:
	blt x2,x1,DEBUG
UGRT2:
	bgeu x1,x0,NEQ3
NEQ2:
	beq x3,x0,DEBUG

EQ3:
	beq x3,x2,NUGRT4
NUGRT3:
	bgeu x0,x1,DEBUG
NOTEQ3:
	bne x2,x1,NNOTEQ4
NNOTEQ3:
	bne x2,x3,DEBUG
LESST3:
	blt x1,x2,NULESS4
NULESS3:
	bltu x1,x0,DEBUG
GRTT3:
	bge x2,x1,NGRTT4
NGRTT3:
	bge x1,x2,DEBUG
ULESS3:
	bltu x0,x1,NLESST4
NLESST3:
	blt x2,x1,DEBUG
UGRT3:
	bgeu x1,x0,NEQ4
NEQ3:
	beq x3,x0,DEBUG

EQ4:
	beq x3,x2,NUGRT5
NUGRT4:
	bgeu x0,x1,DEBUG
NOTEQ4:
	bne x2,x1,NNOTEQ5
NNOTEQ4:
	bne x2,x3,DEBUG
LESST4:
	blt x1,x2,NULESS5
NULESS4:
	bltu x1,x0,DEBUG
GRTT4:
	bge x2,x1,NGRTT5
NGRTT4:
	bge x1,x2,DEBUG
ULESS4:
	bltu x0,x1,NLESST5
NLESST4:
	blt x2,x1,DEBUG
UGRT4:
	bgeu x1,x0,NEQ5
NEQ4:
	beq x3,x0,DEBUG

EQ5:
	beq x3,x2,NUGRT1
NUGRT5:
	bgeu x0,x1,DEBUG
NOTEQ5:
	bne x2,x1,NNOTEQ1
NNOTEQ5:
	bne x2,x3,DEBUG
LESST5:
	blt x1,x2,NULESS1
NULESS5:
	bltu x1,x0,DEBUG
GRTT5:
	bge x2,x1,NGRTT1
NGRTT5:
	bge x1,x2,DEBUG
ULESS5:
	bltu x0,x1,NLESST1
NLESST5:
	blt x2,x1,DEBUG
UGRT5:
	bgeu x1,x0,NEQ1
NEQ5:
	beq x3,x0,DEBUG

END:
	ebreak

DEBUG:
	addi x12,x0,-1
	jal x0,END
