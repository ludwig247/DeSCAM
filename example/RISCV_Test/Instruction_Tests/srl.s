#
# @author:Luka
# srl.s
#
# Test for shift right logical (srl)

addi $1,$0,64        # $1 = 0x40
addi $2,$0,1         # $2 = 0x1
addi $3,$0,4         # $3 = 0x4
addi $4,$0,7         # $4 = 0x7

srl  $5,$1,$2        # $5 = 0x20
srl  $6,$5,$3        # $6 = 0x02
srl  $7,$1,$4        # $7 = 0x0
srl  $8,$1,$0        # $8 = 0x40
srl  $9,$0,$3        # $9 = 0x0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
