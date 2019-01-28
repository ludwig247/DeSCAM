#
# @author:Luka
# slli.s
#
# Test for shift left logical immediate (slli)

addi $1,$0,8         # $1 = 0x8
slli $2,$1,1         # $2 = 0x10
slli $3,$2,2         # $3 = 0x40
slli $4,$3,0         # $4 = 0x40

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
