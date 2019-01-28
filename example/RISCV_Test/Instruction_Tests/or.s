#
# @author:Luka
# or.s
#
# Test for or (or)

addi $1,$0,7		 # $1 = 0x7
addi $2,$0,8         # $2 = 0x8
addi $3,$0,1         # $3 = 0x1
addi $4,$0,15        # $4 = 0xF

or   $1,$1,$1        # $1 = 0x7
or   $5,$1,$3        # $5 = 0x7
or   $6,$1,$4        # $6 = 0xF
or   $7,$1,$1        # $7 = 0x7
or   $8,$1,$2        # $8 = 0xF
or   $9,$2,$4        # $9 = 0xF
or   $10,$3,$0       # $10 = 0x1
or   $11,$0,$3       # $11 = 0x1

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program

