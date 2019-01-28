#
# @author:Luka
# auipc.s
#
# Test for add upper immediate to PC (auipc)


auipc $1,0          # $1 = PC = 0
auipc $2,8		    # $2 = PC + (0x8 << 12) = 0x8004
auipc $3,0          # $3 = PC = 0x8
auipc $4,1          # $4 = PC + (0x1 << 12) = 0x100C

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
