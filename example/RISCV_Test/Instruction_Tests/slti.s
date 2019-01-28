#
# @author:Luka
# slti.s
#
# Test for set less than immediate (slti)


addi  $1,$0,7       # $1 = 7
addi  $2,$0,-12     # $2 = -12

slti  $3,$1,32	    # $3 = 1
slti  $4,$1,3	    # $4 = 0
slti  $5,$1,-100    # $5 = 0
slti  $6,$2,-5      # $6 = 1
slti  $7,$2,0       # $7 = 1
slti  $8,$2,100     # $8 = 1
slti  $9,$2,-13     # $9 = 0
slti  $10,$2,-100   # $10 = 0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
