#
# @author:Luka
# sltu.s
#
# Test for set less than unsigned (sltu)


addi  $1,$0,7       # $1 = 7
addi  $2,$0,-12     # $2 = -12
addi  $31,$0,32     # $31 = 32
addi  $30,$0,3      # $30 = 3
addi  $29,$0,-100   # $29 = -100
addi  $28,$0,-5     # $28 = -5
addi  $27,$0,100    # $27 = -100
addi  $26,$0,-13    # $26 = -13

sltu $3,$1,$31	    # $3 = 1
sltu $4,$1,$30	    # $4 = 0
sltu $5,$1,$29      # $5 = 1
sltu $6,$2,$28      # $6 = 1
sltu $7,$2,$0       # $7 = 0
sltu $8,$2,$27      # $8 = 0
sltu $9,$2,$26      # $9 = 0
sltu $10,$2,$29     # $10 = 0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
