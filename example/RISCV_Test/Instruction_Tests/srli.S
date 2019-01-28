#
# @author:Luka
# srli.s
#
# Test for shift right logical immediate (srli)
.globl _start

_start:
addi x1,x0,64        # x1 = 0x40
srli x2,x1,1         # x2 = 0x20
srli x3,x2,4         # x3 = 0x02
srli x4,x1,7         # x4 = 0x0
srli x5,x1,0         # x5 = 0x40

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
