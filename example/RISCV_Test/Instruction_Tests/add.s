#
# @author:Luka
# add.s
#
# Test for addition (add)

addi $1,$0,128		 # $1 = 128
addi $2,$0,10        # $2 = 10
addi $3,$0,-10       # $3 = -10
addi $4,$0,-128      # $4 = -128

add  $5,$1,$2        # $5 = $1 + $2 = 138
add  $6,$1,$3        # $6 = $1 + $3 = 118
add  $7,$1,$0        # $7 = $1 + $0 = 128
add  $8,$0,$1        # $8 = $0 + $1 = 128
add  $9,$1,$1        # $9 = $1 + $1 = 256

add  $10,$4,$2       # $10= $4 + $2 = -118
add  $11,$4,$3       # $11 = $4 + $3 = -138
add  $12,$4,$0       # $12 = $4 + $0 = -128
add  $13,$0,$4       # $13 = $0 + $4 = -128
add  $14,$4,$4       # $14 = $4 + $4 = -256

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program	
