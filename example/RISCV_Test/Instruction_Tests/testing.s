
# @author :	salaheddin hetalani

# @name   : 	testing.s

# @purpose: 	Testing the pipline regarding all kinds of dependencies that are possible among instructions. Please refer to the comment #		section in data_path and control_path files for more information.

# @notes  :   * There are 36 different cases of forwarding and 12 different cases of stalling, among which only 18 cases of forwaring and 08
#		cases of stalling are tested in this file. 
#	      *	The tested forwarding cases are (01 -> 06, 13 -> 18, 31 -> 36) and for stalling (01,02,05 -> 10)
#	      *	As for forwarding cases (07 -> 12, 25 -> 30) that are not covered, they are equivalent to the cases (01 -> 06), same applied to #		stalling cases (03,04,11,12) with respect to (01,02). That's why, there is no need to test them individually.
#	      *	Using the same logic, the forwarding cases (19 -> 24) are equivalent to the cases (31 -> 36)

################################################################################################################################################

											    #STALL	     	     #FORWARDING
	#~~~~~~~~INST~~~~~~~~	#~InstAddress~	# ~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~      ~~NUM~~	~~~TYPE~~~    ~~NUM~~	~~~~~~TYPE~~~~~~ 
	addi  $5,$0,256		# 0x00	 	# $5 = address 0x100	
	addi  $6,$0,44	 	# 0x04		# $6 = 0x2C	
	sw    $5,$6,0  		# 0x08	 	# mem[0x100] = 0x2C	

	addi  $1,$0,1		# 0x0C	 	# $1 = 0x01							
	add   $2,$1,$1	 	# 0x10	 	# $2 = 0x02					
	add   $3,$2,$2   	# 0x14 	 	# $3 = 0x04							# 01  	# EX1_1  # EX2_2
	addi  $4,$3,0		# 0x18		# $4 = 0x04							# 02  	# EX1_1
	sub   $7,$5,$4		# 0x1C		# $7 = 0xFC
	lw    $8,$7,4		# 0x20		# $8 = 0x2C							# 03	# EX1_1
	add   $9,$8,$4     	# 0x24 		# $9 = 0x30
	jalr  $0,$9,0		# 0x28	 	 					# 01	# STALL_3	# 04	# ID1_1
	addi  $7,$4,0		# 0x2C	 	# will be disgarded

	addi  $10,$5,8		# 0x30	 	# $10 = 0x108
	sub   $11,$10,$4	# 0x34		# $11 = 0x104
	sw    $11,$11,0		# 0x38		# mem[0x104] = 0x104       					# 05	# EX1_1  # MEM_1
	add   $12,$11,$4	# 0x3C		# $12 = 0x108						
	beq   $12,$12,LOAD	# 0x40							# 02    # STALL_1	# 06    # ID1_1  # ID2_1
LOAD:
	lw    $13,$5,0		# 0x44		# $13 = 0x2C
	add   $14,$13,$13	# 0x48		# $14 = 0x58 (0x2C + 0x2C)		# 05 	# STALL_1	# 13	# EX1_2  # EX2_2
	lw    $15,$5,0		# 0x4C		# $15 = 0x2C
	addi  $16,$15,60	# 0x50		# $16 = 0x68				# 06 	# STALL_3	# 14	# EX1_2 
	sw    $11,$16,4		# 0x54		# mem[0x108] = 0x68
	lw    $17,$11,0		# 0x58		# $17 = mem[0x104] = 0x104
	lw    $17,$17,4		# 0x5C		# $17 = mem[0x108] = 0x68		# 07 	# STALL_3	# 15	# EX1_2
	jalr  $0,$17,0		# 0x60							# 08 	# STALL_4	# 16	# ID1_5
	addi  $7,$4,0		# 0x64		# will be disgarded

	lw    $18,$11,0		# 0x68		# $18 = mem[0x104] = 0x104
	sw    $18,$18,8		# 0x6C		# mem[0x10C] = 0x104			# 09 	# STALL_4	# 17	# ID1_5  # ID2_5
	lw    $18,$11,4		# 0x70		# $18 = mem[0x108] = 0x68
	sw    $11,$18,12	# 0x74		# mem[0x110] = 0x68			  	 		#*17	         #*MEM_2
	lw    $18,$11,0		# 0x78		# $18 = mem[0x104] = 0x104	
	beq   $18,$18,JUMP	# 0x7C							# 10 	# STALL_2	# 18	# ID1_5  # ID2_5
JUMP:
	jal   $19,R		# 0x80		# $19 = 0x84
R: 	
	add   $20,$19,$19	# 0x84		# $20 = 0x108 (0x84 + 0x84)					# 31	# ID1_3  # ID2_3
	jal   $21,I_I		# 0x88		# $21 = 0x8C
I_I: 	
	addi  $22,$21,0		# 0x8C		# $22 = 0x8C							# 32	# ID1_3  
	jal   $23,S		# 0x90		# $23 = 0x94
S:	
	sw    $23,$23,128	# 0x94		# mem[114] = 0x94						# 35	# ID1_3  # ID2_3
	jal   $24,I_L		# 0x98		# $24 = 0x9C
I_L:
	lw    $25,$24,120	# 0x9C		# $25 = 0x94							# 34	# ID1_3  
	jal   $26,B		# 0xA0		# $26 = 0xA4
B:
	beq   $26,$26,J		# 0xA4										# 36	# ID1_3  # ID2_3
J:
	jal   $27,I_J		# 0xA8		# $27 = 0xAC
	jal   $0,SPECIAL	# 0xAC
I_J:
	jalr  $0,$27,0		# 0xB0										# 33	# ID1_3  

SPECIAL:
	addi  $28,$27,16	# 0xB4		# $28 = 0xBC
	jalr  $0,$28,0		# 0xB8	 	 
	addi  $29,$28,8		# 0xBC    	# $29 = 0xC4
	jalr  $30,$29,0		# 0xC0	 	# $30 = 0xC4
	add   $30,$30,$30	# 0xC4	 	# $30 = 0x188 (0xC4 + 0xC4)
	
	auipc $31,0		# 0xC8    	# $31 = 0xC8
	bne   $31,$29,HALT	# 0xCC 	 	 
HALT:
	addi  $0,$0,0		# 0xD0	 	# end of ID stage of the last instruction
	addi  $0,$0,0		# 0xD4	 	# end of EX stage of the last instruction
	addi  $0,$0,0		# 0xD8	 	# end of MEM stage of the last instruction
	addi  $0,$0,0		# 0xDC	 	# end of WB stage of the last instruction
	addi  $31,$0,0	 	# 0xE0	 	# end of program

################################################################################################################################################
