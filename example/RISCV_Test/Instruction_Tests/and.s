#
# @author:Luka
# and.s
#
# Test for and (and)

addi $1,$0,7	     # $1 = 0x7
addi $2,$0,8         # $2 = 0x8
addi $3,$0,1         # $3 = 0x1
addi $4,$0,15        # $4 = 0x15

and  $1,$1,$1        # $1 = 0x7
and  $5,$1,$3        # $5 = 0x1
and  $6,$1,$4        # $6 = 0x7
and  $7,$1,$1        # $7 = 0x7
and  $8,$1,$2        # $8 = 0x0
and  $9,$2,$4        # $9 = 0x8
and  $10,$3,$0       # $10 = 0x0
and  $11,$0,$3       # $11 = 0x0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program

