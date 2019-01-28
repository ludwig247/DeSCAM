#
# @author:Luka
# srai.s
#
# Test for shift right arithmetic immediate (srai)

addi $1,$0,64        # $1 = 0x40
addi $2,$0,-65       # $2 = 0xFFFFFFBF
srai $3,$1,1         # $3 = 0x20
srai $4,$3,5         # $4 = 0x1
srai $5,$2,2         # $5 = 0xFFFFFFEF
srai $6,$5,13        # $6 = 0xFFFFFFFF

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
