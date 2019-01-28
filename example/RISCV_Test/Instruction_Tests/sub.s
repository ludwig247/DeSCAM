#
# @author:Luka
# sub.s
#
# Test for subtraction (sub)

addi $1,$0,128		 # $1 = 128
addi $2,$0,10        # $2 = 10
addi $3,$0,-10       # $3 = -10
addi $4,$0,-128      # $4 = -128

sub  $5,$1,$2        # $5 = $1 - $2 = 118
sub  $6,$1,$3        # $6 = $1 - $3 = 138
sub  $7,$1,$0        # $7 = $1 - $0 = 128
sub  $8,$0,$1        # $8 = $0 - $1 = -128
sub  $9,$1,$1        # $9 = $1 - $1 = 0

sub  $10,$4,$2        # $10 = $4 - $2 = -138
sub  $11,$4,$3        # $11 = $4 - $3 = -118
sub  $12,$4,$0        # $12 = $4 - $0 = -128
sub  $13,$0,$4        # $13 = $0 - $4 = 128
sub  $14,$4,$4        # $14 = $4 - $4 = 0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
