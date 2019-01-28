#
# @author:Luka
# sra.s
#
# Test for shift right arithmetic (sra)

addi $1,$0,64        # $1 = 0x40
addi $2,$0,-65       # $2 = 0xFFFFFFBF
addi $3,$0,1         # $3 = 1
addi $4,$0,5         # $4 = 5
addi $5,$0,2         # $5 = 2
addi $6,$0,13        # $6 = 13

sra $7,$1,$3         # $7 = 0x20
sra $8,$7,$4         # $8 = 0x1
sra $9,$8,$0         # $9 = 0x1
sra $10,$9,$6        # $10 = 0x0

sra $11,$2,$5        # $11 = 0xFFFFFFEF
sra $12,$11,$6       # $12 = 0xFFFFFFFF
sra $13,$12,$0       # $13 = 0xFFFFFFFF
sra $14,$0,$4        # $14 = 0x0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
