#
# @author:Luka
# xor.s
#
# Test for xor (xor)

addi $1,$0,7		 # $1 = 0x7
addi $2,$0,4         # $2 = 0x4
addi $3,$0,-1        # $3 = 0x1

xor  $4,$1,$1        # $4 = 0x0
xor  $5,$1,$2        # $5 = 0x3
xor  $6,$1,$3        # $6 = 0xFFFFFFF8
xor  $7,$6,$0        # $7 = 0xFFFFFFF8
xor  $8,$0,$6        # $8 = 0xFFFFFFF8
xor  $9,$7,$7        # $9 = 0x0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
