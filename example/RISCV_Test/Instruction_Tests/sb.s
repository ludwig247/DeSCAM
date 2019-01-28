#
# @author:Luka
# sb.s
#
# Test for store byte (sb)

addi $1,$0,128		 # address 0x80
addi $2,$0,156		 # address 0x9C


addi  $3,$0,352 	 # $3 = 0x160
addi  $4,$0,55 		 # $4 = 0x37
addi  $5,$0,1		 # $5 = 0x1
addi  $6,$0,-13		 # $6 = 0xFFFFFFF3

sb    $1,$3,0 		 # mem[0x80] = 0x60
sb    $1,$4,1 		 # mem[0x81] = 0x37
sb    $1,$5,6		 # mem[0x86] = 0x1
sb    $2,$6,0        # mem[0x9C] = 0xF3
sb    $2,$6,-1       # mem[0x9B] = 0xF3

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
