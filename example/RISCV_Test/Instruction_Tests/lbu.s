#
# @author:Luka
# lbu.s
#
# Test for load byte unsigned (lbu)

addi $1,$0,128		 # address 0x80

addi $2,$0,1         # $2 = 0x01
addi $3,$0,2         # $3 = 0x02
addi $4,$0,3         # $4 = 0x03
addi $5,$0,4         # $5 = 0x04
sb   $1,$2,0
sb   $1,$3,1
sb   $1,$4,2
sb   $1,$5,3

# mem [0x80..83] = 0x01020304

addi $6,$0,255  	 # $6 = 0xFF
addi $7,$0,254		 # $7 = 0xFE
addi $8,$0,253		 # $8 = 0xFD
addi $9,$0,252		 # $9 = 0xFC
sb   $1,$6,4
sb   $1,$7,5
sb   $1,$8,6
sb   $1,$9,7

# mem [0x84..87] = 0xFFFEFDFC

lbu   $31,$1,0     	 # $31 = 0x00000001
lbu   $30,$1,4       # $30 = 0x000000FF
lbu   $29,$1,3       # $29 = 0x00000004
lbu   $28,$1,7       # $28 = 0x000000FC

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
