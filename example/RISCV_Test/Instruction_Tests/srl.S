#
# @author:Luka
# srl.s
#
# Test for shift right logical (srl)
.globl _start

_start:
addi x1,x0,64        # x1 = 0x40
addi x2,x0,1         # x2 = 0x1
addi x3,x0,4         # x3 = 0x4
addi x4,x0,7         # x4 = 0x7

srl  x5,x1,x2        # x5 = 0x20
srl  x6,x5,x3        # x6 = 0x02
srl  x7,x1,x4        # x7 = 0x0
srl  x8,x1,x0        # x8 = 0x40
srl  x9,x0,x3        # x9 = 0x0

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
