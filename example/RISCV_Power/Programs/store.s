#
# @author:Luka
# store.s
#
# Tests stores and loads in various situations

addi $1,$0,128		 # address 0x80
addi $2,$0,156		 # address 0x9C

lui   $20,5          # $20 = 5 << 12
auipc $21,0          # $21 = PC
auipc $22,100		 # $22 = PC + (100 << 12)

addi  $5,$0,352 	 # 0x160 imm
addi  $6,$0,55 		 # 0x37 imm
addi  $7,$0,1		 # 0x1 imm
addi  $8,$0,3		 # 0x3 imm

addi  $9,$0,-1		 # 0xFFFFFFFF imm
addi  $10,$0,129	 # 0x81 imm
addi  $11,$0,-100	 # 0xFFFFFF9C imm
	
sw    $1,$5,0  		 # mem[0x80] = 0x160
sh    $1,$6,4		 # mem[0x84] = 0x37
sb    $1,$7,6 		 # mem[0x86] = 0x1
sb    $1,$8,0 		 # mem[0x80] = 0x3

sw    $2,$9,0		 # mem[0x9C] = 0xFFFFFFFF
sw    $2,$10,4		 # mem[0xA0] = 0x81
sh    $2,$11,8 		 # mem[0xA4] = 0xFF9C

lw    $31,$2,0     	 # R31 = mem[0x9C] = 0xFFFFFFFF
lh    $30,$2,0     	 # R30 = mem[0x9C] = 0xFFFFFFFF
lhu   $29,$2,0     	 # R29 = mem[0x9C] = 0x0000FFFF
lb    $28,$2,0     	 # R28 = mem[0x9C] = 0xFFFFFFFF
lbu   $27,$2,0     	 # R27 = mem[0x9C] = 0x000000FF

lb    $26,$2,4     	 # R26 = mem[0xA0] = 0xFFFFFF81
lbu   $25,$2,4     	 # R25 = mem[0xA0] = 0x00000081

addi  $0,$0,0 	   	 # end of program
