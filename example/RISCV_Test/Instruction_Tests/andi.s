#
# @author:Luka
# andi.s
#
# Test for and immediate (andi)

addi $1,$0,7		 # $1 = 0x7
addi $2,$0,8         # $2 = 0x8
andi $3,$1,1         # $3 = 0x1
andi $4,$1,15        # $4 = 0x7
andi $5,$2,7         # $5 = 0x0
andi $6,$2,9         # $6 = 0x8

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
