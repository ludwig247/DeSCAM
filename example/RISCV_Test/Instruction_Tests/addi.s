#
# @author:Luka
# addi.s
#
# Test for add immediate (addi)

addi $1,$0,128		 # $1 = 128
addi $2,$1,0         # $2 = $1 = 128
addi $3,$2,10        # $3 = $2 + 10 = 138
addi $4,$2,-10       # $4 = $2 - 10 = 118

addi $5,$0,-128      # $5 = -128
addi $6,$5,0         # $6 = -128
addi $7,$5,10        # $7 = -118
addi $8,$5,-10       # $8 = -138

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
