#
# @author:Luka
# lui.s
#
# Test for load upper immediate (lui)
.globl _start

_start:
lui   x1,5          # x1 = 0x5 << 12 = 0x5000
lui   x2,31         # x2 = 0x1F << 12 = 0x1F000
#lui   x3,-1         # x3 = 0xFFFFF000
lui   x4,0          # x4 = 0x0

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
