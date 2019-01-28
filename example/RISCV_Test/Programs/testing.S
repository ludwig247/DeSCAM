
# @author :	salaheddin hetalani

# @name   : 	testing.s

# @purpose: 	Testing the pipline regarding all kinds of dependencies that are possible among instructions. Please refer to the comment #		section in data_path and control_path files for more information.

# @notes  :   * There are 36 different cases of forwarding and 12 different cases of stalling, among which only 18 cases of forwaring and 08
#		cases of stalling are tested in this file. 
#	      *	The tested forwarding cases are (01 -> 06, 13 -> 18, 31 -> 36) and for stalling (01,02,05 -> 10)
#	      *	As for forwarding cases (07 -> 12, 25 -> 30) that are not covered, they are equivalent to the cases (01 -> 06), same applied to #		stalling cases (03,04,11,12) with respect to (01,02). That's why, there is no need to test them individually.
#	      *	Using the same logic, the forwarding cases (19 -> 24) are equivalent to the cases (31 -> 36)

################################################################################################################################################
.globl _start

_start:
											    #STALL	     	     #FORWARDING
	#~~~~~~~~INST~~~~~~~~	#~InstAddress~	# ~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~      ~~NUM~~	~~~TYPE~~~    ~~NUM~~	~~~~~~TYPE~~~~~~ 
	addi  x5,x0,256		# 0x00	 	# x5 = address 0x100	
	addi  x6,x0,44	 	# 0x04		# x6 = 0x2C	
	sw    x6,0(x5)  		# 0x08	 	# mem[0x100] = 0x2C

	addi  x1,x0,1		# 0x0C	 	# x1 = 0x01							
	add   x2,x1,x1	 	# 0x10	 	# x2 = 0x02					
	add   x3,x2,x2   	# 0x14 	 	# x3 = 0x04							# 01  	# EX1_1  # EX2_2
	addi  x4,x3,0		# 0x18		# x4 = 0x04							# 02  	# EX1_1
	sub   x7,x5,x4		# 0x1C		# x7 = 0xFC
	lw    x8,4(x7)		# 0x20		# x8 = 0x2C							# 03	# EX1_1
	add   x9,x8,x4     	# 0x24 		# x9 = 0x30
	jalr  x0,x9,0		# 0x28	 	 					# 01	# STALL_3	# 04	# ID1_1
	addi  x7,x4,0		# 0x2C	 	# will be disgarded

	addi  x10,x5,8		# 0x30	 	# x10 = 0x108
	sub   x11,x10,x4	# 0x34		# x11 = 0x104
	sw    x11,0(x11)		# 0x38		# mem[0x104] = 0x104       					# 05	# EX1_1  # MEM_1
	add   x12,x11,x4	# 0x3C		# x12 = 0x108						
	beq   x12,x12,LOAD	# 0x40							# 02    # STALL_1	# 06    # ID1_1  # ID2_1
LOAD:
	lw    x13,0(x5)		# 0x44		# x13 = 0x2C
	add   x14,x13,x13	# 0x48		# x14 = 0x58 (0x2C + 0x2C)		# 05 	# STALL_1	# 13	# EX1_2  # EX2_2
	lw    x15,0(x5)		# 0x4C		# x15 = 0x2C
	addi  x16,x15,60	# 0x50		# x16 = 0x68				# 06 	# STALL_3	# 14	# EX1_2 
	sw    x16,4(x11)		# 0x54		# mem[0x108] = 0x68
	lw    x17,0(x11)		# 0x58		# x17 = mem[0x104] = 0x104
	lw    x17,4(x17)		# 0x5C		# x17 = mem[0x108] = 0x68		# 07 	# STALL_3	# 15	# EX1_2
	jalr  x0,x17,0		# 0x60							# 08 	# STALL_4	# 16	# ID1_5
	addi  x7,x4,0		# 0x64		# will be disgarded

	lw    x18,0(x11)		# 0x68		# x18 = mem[0x104] = 0x104
	sw    x18,8(x18)		# 0x6C		# mem[0x10C] = 0x104			# 09 	# STALL_4	# 17	# ID1_5  # ID2_5
	lw    x18,4(x11)		# 0x70		# x18 = mem[0x108] = 0x68
	sw    x18,12(x11)	# 0x74		# mem[0x110] = 0x68			  	 		#*17	         #*MEM_2
	lw    x18,0(x11)		# 0x78		# x18 = mem[0x104] = 0x104
	beq   x18,x18,JUMP	# 0x7C							# 10 	# STALL_2	# 18	# ID1_5  # ID2_5
JUMP:
	jal   x19,R		# 0x80		# x19 = 0x84
R: 	
	add   x20,x19,x19	# 0x84		# x20 = 0x108 (0x84 + 0x84)					# 31	# ID1_3  # ID2_3
	jal   x21,I_I		# 0x88		# x21 = 0x8C
I_I: 	
	addi  x22,x21,0		# 0x8C		# x22 = 0x8C							# 32	# ID1_3  
	jal   x23,S		# 0x90		# x23 = 0x94
S:	
	sw    x23,128(x23)	# 0x94		# mem[114] = 0x94						# 35	# ID1_3  # ID2_3
	jal   x24,I_L		# 0x98		# x24 = 0x9C
I_L:
	lw    x25,120(x24)	# 0x9C		# x25 = 0x94							# 34	# ID1_3
	jal   x26,B		# 0xA0		# x26 = 0xA4
B:
	beq   x26,x26,J		# 0xA4										# 36	# ID1_3  # ID2_3
J:
	jal   x27,I_J		# 0xA8		# x27 = 0xAC
	jal   x0,SPECIAL	# 0xAC
I_J:
	jalr  x0,x27,0		# 0xB0										# 33	# ID1_3  

SPECIAL:
	addi  x28,x27,16	# 0xB4		# x28 = 0xBC
	jalr  x0,x28,0		# 0xB8	 	 
	addi  x29,x28,8		# 0xBC    	# x29 = 0xC4
	jalr  x30,x29,0		# 0xC0	 	# x30 = 0xC4
	add   x30,x30,x30	# 0xC4	 	# x30 = 0x188 (0xC4 + 0xC4)
	
	auipc x31,0		# 0xC8    	# x31 = 0xC8
	bne   x31,x29,HALT	# 0xCC 	 	 
HALT:
	addi  x0,x0,0		# 0xD0	 	# end of ID stage of the last instruction
	addi  x0,x0,0		# 0xD4	 	# end of EX stage of the last instruction
	addi  x0,x0,0		# 0xD8	 	# end of MEM stage of the last instruction
	addi  x0,x0,0		# 0xDC	 	# end of WB stage of the last instruction
# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
################################################################################################################################################
