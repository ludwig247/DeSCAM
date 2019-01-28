#
# @author:Luka
# lui.s
#
# Test for load upper immediate (lui)


lui   $1,5          # $1 = 0x5 << 12 = 0x5000
lui   $2,31         # $2 = 0x1F << 12 = 0x1F000
lui   $3,-1         # $3 = 0xFFFFF000
lui   $4,0          # $4 = 0x0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
