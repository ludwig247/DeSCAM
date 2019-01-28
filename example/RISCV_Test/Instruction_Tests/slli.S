#
# @author:Luka
# slli.s
#
# Test for shift left logical immediate (slli)
.globl _start

_start:
addi x1,x0,8         # x1 = 0x8
slli x2,x1,1         # x2 = 0x10
slli x3,x2,2         # x3 = 0x40
slli x4,x3,0         # x4 = 0x40

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall