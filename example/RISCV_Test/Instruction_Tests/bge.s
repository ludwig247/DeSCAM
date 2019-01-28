#
# @author:Luka
# bge.s
#
# Test for branch greater equal (bge)

addi $1,$0,5		 # $1 = 5
addi $2,$0,-6		 # $2 = -6
addi $31,$0,0        # $31 = 0
addi $30,$0,0        # $30 = 0
addi $29,$0,0        # $29 = 0
addi $28,$0,0        # $29 = 0

bge  $1,$2,TRY1   # taken
addi $31,$0,15    # $31 = 0xF (not executed)

TRY1:
addi $30,$0,15    # $30 = 0xF (executed)
bge  $2,$1,TRY2   # not taken
bge  $1,$1,TRY3   # taken

TRY2:
addi $29,$0,15    # $29 = 0xF  (not executed)
addi $0,$0,0     # halt

TRY3:
addi $28,$0,15    # $28 = 0xF  (executed)
addi $0,$0,0     # halt

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
