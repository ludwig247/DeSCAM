#
# @author:Luka
# srai.s
#
# Test for shift right arithmetic immediate (srai)
.globl _start

_start:
addi x1,x0,64        # x1 = 0x40
addi x2,x0,-65       # x2 = 0xFFFFFFBF
srai x3,x1,1         # x3 = 0x20
srai x4,x3,5         # x4 = 0x1
srai x5,x2,2         # x5 = 0xFFFFFFEF
srai x6,x5,13        # x6 = 0xFFFFFFFF

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
