#
# @author:Luka
# ori.s
#
# Test for or immediate (ori)

ori  $1,$0,7		 # $1 = 0x7
ori  $2,$1,8         # $2 = 0xF
ori  $3,$2,0         # $3 = 0xF
ori  $4,$3,-1        # $4 = 0xFFFFFFFF

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
