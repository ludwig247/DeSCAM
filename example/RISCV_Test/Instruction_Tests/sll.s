#
# @author:Luka
# sll.s
#
# Test for shift left logical (sll)

addi $1,$0,8         # $1 = 0x8
addi $2,$0,1         # $2 = 0x1
addi $3,$0,2         # $3 = 0x2

sll  $4,$1,$2        # $4 = 0x10
sll  $5,$4,$3        # $5 = 0x40
sll  $6,$5,$0        # $6 = 0x40
sll  $7,$0,$2        # $6 = 0x0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program

