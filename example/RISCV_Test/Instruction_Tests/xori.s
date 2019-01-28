#
# @author:Luka
# xori.s
#
# Test for xor immediate (xori)

addi  $1,$0,7		  # $1 = 0x7
xori  $2,$1,7         # $2 = 0x0
xori  $3,$1,4         # $3 = 0x3
xori  $4,$1,-1        # $4 = 0xFFFFFFF8
xori  $5,$4,0         # $5 = 0xFFFFFFF8

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
