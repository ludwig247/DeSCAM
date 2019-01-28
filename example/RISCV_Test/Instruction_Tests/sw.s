#
# @author:Luka
# sw.s
#
# Test for store word (sw)

addi $1,$0,128		# 0x00	# address 0x80
addi $2,$0,156		# 0x04 	# address 0x9C

addi $3,$0,352 		# 0x08 	# $3 = 0x160
addi $4,$0,55 		# 0x0C 	# $4 = 0x37
addi $5,$0,1		# 0x10 	# $5 = 0x1
addi $6,$0,-13		# 0x14 	# $6 = 0xFFFFFFF3

sw   $1,$3,0 		# 0x18 	# mem[0x80] = 0x60, mem[0x81] = 0x01, mem[0x82] = 0x0, mem[0x83] = 0x0
sw   $1,$6,-4       	# 0x1C	# mem[0x7C] = 0xF3, mem[0x7D] = 0xFF, mem[0x7E] = 0xFF, mem[0x7F] = 0xFF
sw   $1,$5,4        	# 0x20	# mem[0x84] = 0x1, mem[0x85] = 0x0, mem[0x86] = 0x0, mem[0x87] = 0x0

addi $0,$0,0	     	# 0x24	# end of ID stage of the last instruction
addi $0,$0,0	     	# 0x28	# end of EX stage of the last instruction
addi $0,$0,0	     	# 0x2C	# end of MEM stage of the last instruction
addi $0,$0,0	     	# 0x30	# end of WB stage of the last instruction
addi $31,$0,0  	     	# 0x34	# end of program
