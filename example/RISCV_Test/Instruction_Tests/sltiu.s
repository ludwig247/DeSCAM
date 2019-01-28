#
# @author:Luka
# slti.s
#
# Test for set less than immediate (slti)


addi  $1,$0,7          # $1 = 7
addi  $2,$0,-12        # $2 = -12

sltiu $3,$1,32	       # $3 = 1
sltiu $4,$1,3	       # $4 = 0
sltiu $5,$1,-100       # $5 = 1
sltiu $6,$2,-5         # $6 = 1
sltiu $7,$2,0          # $7 = 0
sltiu $8,$2,100        # $8 = 0
sltiu $9,$2,-13        # $9 = 0
sltiu $10,$2,-100      # $10 = 0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
