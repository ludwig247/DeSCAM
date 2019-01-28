#
# @author:Luka
# auipc.s
#
# Test for add upper immediate to PC (auipc)
.globl _start

_start:
auipc x1,0          # x1 = PC = 0
auipc x2,8		    # x2 = PC + (0x8 << 12) = 0x8004
auipc x3,0          # x3 = PC = 0x8
auipc x4,1          # x4 = PC + (0x1 << 12) = 0x100C

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall