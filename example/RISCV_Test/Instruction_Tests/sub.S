#
# @author:Luka
# sub.s
#
# Test for subtraction (sub)
.globl _start

_start:
addi x1,x0,128		 # x1 = 128
addi x2,x0,10        # x2 = 10
addi x3,x0,-10       # x3 = -10
addi x4,x0,-128      # x4 = -128

sub  x5,x1,x2        # x5 = x1 - x2 = 118
sub  x6,x1,x3        # x6 = x1 - x3 = 138
sub  x7,x1,x0        # x7 = x1 - x0 = 128
sub  x8,x0,x1        # x8 = x0 - x1 = -128
sub  x9,x1,x1        # x9 = x1 - x1 = 0

sub  x10,x4,x2        # x10 = x4 - x2 = -138
sub  x11,x4,x3        # x11 = x4 - x3 = -118
sub  x12,x4,x0        # x12 = x4 - x0 = -128
sub  x13,x0,x4        # x13 = x0 - x4 = 128
sub  x14,x4,x4        # x14 = x4 - x4 = 0

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
