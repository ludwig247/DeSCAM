# @author:Luka
# jalr.s
#
# Test for jump and link register (jalr)

addi $27,$0,0        # $31 = 0
addi $30,$0,0        # $30 = 0
addi $29,$0,0        # $29 = 0

jal  $1, TRY1     # $1 = PC + 4 = 16
addi $31,$0,15    # $31 = 0xF  (not executed)
addi $30,$0,15    # $30 = 0xF  (executed)
addi $0,$0,0      # halt

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program

TRY1:
addi $29,$0,15    # $29 = 0xF  (executed)
jalr $2,$1,4      # $2 = PC + 4 = 56
addi $0,$0,0      # halt
