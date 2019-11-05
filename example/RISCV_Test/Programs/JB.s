
# @author :	salaheddin hetalani

# @name   : 	JB.s

################################################################################################################################################

											    #STALL	     	     #FORWARDING
	#~~~~~~~~INST~~~~~~~~	#~InstAddress~	# ~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~      ~~NUM~~	~~~TYPE~~~    ~~NUM~~	~~~~~~TYPE~~~~~~ 
	addi  $1,$0,24		# 0x00	 	# $1 = address 0x18	
	addi  $2,$0,32	 	# 0x04		# $2 = 0x20	
	addi  $3,$0,24	 	# 0x08		# $3 = 0x18		

	jalr  $0,$3,0		# 0x0C	 	 			
	add   $4,$2,$3		# 0x10	 	# $4 = 0x00
	addi  $5,$2,4		# 0x14	 	# $5 = 0x00
	addi  $6,$0,384		# 0x18		# $6 = 0x180
	beq   $1,$1,FINALLY	# 0x1C
	add   $7,$2,$3		# 0x20		# $7 = 0x00
	addi  $8,$2,8		# 0x24		# $8 = 0x00
FINALLY: 
	addi  $9,$2,12		# 0x28		# $9 = 0x2C
	add   $10,$9,$3		# 0x2C		# $10 = 0x44
	beq   $10,$2,HALT	# 0x30
	jalr  $0,$10,0		# 0x34	 	
	beq   $10,$2,HALT	# 0x38		
	beq   $10,$2,HALT	# 0x3C		
	addi  $0,$0,0		# 0x40
	add   $11,$10,$10	# 0x44		# $11 = 0x88	
	beq   $10,$10,STOP	# 0x48		
	beq   $2,$2,BREAK	# 0x4C
	beq   $3,$3,HALT	# 0x50
	beq   $2,$2,BREAK	# 0x54
STOP:
	sw    $6,$3,0		# 0x58		# mem[0x180] = 0x18
	jalr  $0,$11,0		# 0x5C	
	addi  $7,$7,4		# 0x60	
	addi  $7,$7,1		# 0x64	
	addi  $8,$8,1		# 0x68
BREAK:
	beq   $3,$2,HALT	# 0x6C	
	jalr  $0,$11,0		# 0x70	
	addi  $7,$7,1		# 0x74	
	addi  $7,$7,0		# 0x78
	addi  $12,$12,12	# 0x7C	
	addi  $13,$13,13	# 0x80	
	addi  $14,$14,14	# 0x84	
	sw    $6,$2,4		# 0x88		# mem[0x184] = 0x20
	addi  $12,$11,36	# 0x8C		# $12 = 0xAC
	beq   $3,$3,HEY		# 0x90
HEY:
	sw    $6,$11,8		# 0x94		# mem[0x188] = 0x88
	addi  $17,$17,17	# 0x98		# $17 = 0x11
	jalr  $0,$12,0		# 0x9C
	add   $18,$17,$17	# 0xA0
	add   $19,$18,$18	# 0xA4
	add   $20,$19,$19	# 0xA8
	
	sw    $6,$10,12		# 0xAC		# mem[0x18C] = 0x44 
	beq   $3,$3,HALLO	# 0xB0	
	add   $18,$17,$17	# 0xB4
	add   $19,$18,$18	# 0xB8
HALLO:
	addi  $13,$12,40	# 0xBC		# $13 = 0xD4
	sw    $6,$10,16		# 0xC0		# mem[0x190] = 0x44 
	beq   $3,$2,HALT	# 0xC4
	jalr  $0,$13,0		# 0xC8		
	add   $18,$17,$17	# 0xCC
	add   $19,$18,$18	# 0xD0

	add   $20,$3,$2		# 0xD4		# $20 = 0x38
	add   $21,$20,$20	# 0xD8		# $21 = 0x70
	beq   $21,$20,HALT	# 0xDC
	jal   $22,BYE		# 0xE0
	add   $23,$21,$20	# 0xE4
	add   $24,$20,$20	# 0xE8
BYE:
	add   $25,$21,$20	# 0xEC		# $25 = 0xA8
	sw    $6,$10,20		# 0xF0		# mem[0x194] = 0x44 
	beq   $3,$2,HALT	# 0xF4
	jal   $26,HELLOAGAIN	# 0xF8
	add   $23,$21,$20	# 0xFC
	add   $24,$20,$20	# 0x100
HELLOAGAIN:
	add   $27,$25,$25	# 0x104		# $27 = 0x150	
	sw    $6,$10,24		# 0x108		# mem[0x198] = 0x44 
	addi  $28,$27,4		# 0x10C		# $28 = 0x154
	beq   $3,$2,HALT	# 0x110
	jal   $29,FINALBYE	# 0x114		# $29 = 0x118
	add   $23,$21,$20	# 0x118
	add   $24,$20,$20	# 0x11C
FINALBYE:
	add   $30,$29,$29	# 0x120		# $30 = 0x230
HALT:
	addi  $0,$0,0		# 0x124	 	# end of ID stage of the last instruction
	addi  $0,$0,0		# 0x128	 	# end of EX stage of the last instruction
	addi  $0,$0,0		# 0x12C	 	# end of MEM stage of the last instruction
	addi  $0,$0,0		# 0x130	 	# end of WB stage of the last instruction
	addi  $31,$0,0	 	# 0x134	 	# end of program
################################################################################################################################################
