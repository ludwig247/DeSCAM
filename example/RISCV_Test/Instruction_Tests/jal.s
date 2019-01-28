#
# @author:Luka
# jal.s
#
# Test for jump and link (jal)

#addi $31,$0,0        # $31 = 0
addi $30,$0,0        # $30 = 0
addi $29,$0,0        # $29 = 0
addi $28,$0,0        # $29 = 0

jal  $1, TRY1     # $1 = PC + 4 = 20
addi $31,$0,15    # $31 = 0xF (not executed)

TRY1:
addi $30,$0,15    # $30 = 0xF (executed)
jal  $2, TRY2     # $2 = PC + 4 = 32
addi $0,$0,0      # halt

TRY2:
addi $29,$0,15    # $29 = 0xF  (executed)
jal  $0, TRY3     # JUMP
addi $0,$0,0      # halt

TRY3:
addi $28,$0,15    # $28 = 0xF (executed)
addi $0,$0,0      # halt

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
