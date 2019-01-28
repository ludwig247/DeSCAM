#
# @author:Luka
# srli.s
#
# Test for shift right logical immediate (srli)

addi $1,$0,64        # $1 = 0x40
srli $2,$1,1         # $2 = 0x20
srli $3,$2,4         # $3 = 0x02
srli $4,$1,7         # $4 = 0x0
srli $5,$1,0         # $5 = 0x40

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
