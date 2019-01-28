#
# @author:Luka
# bgeu.s
#
# Test for branch greater equal unsigned (bgeu)

addi $1,$0,5		# 0x00	# $1 = 5
addi $2,$0,-6		# 0x04 	# $2 = -6

addi $30,$0,0        	# 0x08	# $30 = 0
addi $29,$0,0        	# 0x0C	# $29 = 0
addi $28,$0,0        	# 0x10	# $29 = 0

bgeu $1,$2,TRY1   	# 0x14	# not taken
addi $31,$0,15    	# 0x18	# $31 = 0xF (executed)
bgeu $2,$1,TRY2   	# 0x1C	# taken

TRY1:
addi $30,$0,15    	# 0x20	# $30 = 0xF (not executed)
addi $0, $0,0     	# 0x24	# halt

TRY2:
addi $29,$0,15    	# 0x28	# $29 = 0xF  (executed)
bgeu $1,$1,TRY3   	# 0x2C	# taken
addi $0,$0,0     	# 0x30	# halt

TRY3:
addi $28,$0,15    	# 0x34	# $28 = 0xF  (executed)
addi $0,$0,0      	# 0x38	# halt

addi $0,$0,0	     	# 0x3C	# end of ID stage of the last instruction
addi $0,$0,0	     	# 0x40	# end of EX stage of the last instruction
addi $0,$0,0	     	# 0x44	# end of MEM stage of the last instruction
addi $0,$0,0	     	# 0x48	# end of WB stage of the last instruction
addi $31,$0,0  	     	# 0x4C	# end of program
