#
# @author:Luka
# blt.s
#
# Test for branch less than (blt)

addi $1,$0,5		# 0x00	# $1 = 5
addi $2,$0,-6		# 0x04 	# $2 = -6

addi $30,$0,0        	# 0x08	# $30 = 0
addi $29,$0,0        	# 0x0C	# $29 = 0

blt $1,$2,TRY1    	# 0x10	# not taken
blt $2,$1,TRY2    	# 0x14	# taken

TRY1:
addi $31,$0,15    	# 0x18	# $31 = 0xF (not executed)
addi $0,$0,0     	# 0x1C	# halt

TRY2:
addi $30,$0,15    	# 0x20	# $30 = 0xF  (executed)
blt  $1,$1,TRY3   	# 0x24	# not taken
addi $0,$0,0     	# 0x28	# halt

addi $0,$0,0	     	# 0x2C	# end of ID stage of the last instruction
addi $0,$0,0	     	# 0x30	# end of EX stage of the last instruction
addi $0,$0,0	     	# 0x34	# end of MEM stage of the last instruction
addi $0,$0,0	     	# 0x38	# end of WB stage of the last instruction
addi $31,$0,0  	     	# 0x3C	# end of program

TRY3:
addi $29,$0,15    	# 0x40	# $29 = 0xF (not executed)
addi $0,$0,0     	# 0x44	# halt
