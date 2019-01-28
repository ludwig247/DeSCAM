#
# @author:Luka
# jal.s
#
# Test for jump and link (jal)
.globl _start

_start:
addi x31,x0,0        # x31 = 0
addi x30,x0,0        # x30 = 0
addi x29,x0,0        # x29 = 0
addi x28,x0,0        # x29 = 0

jal  x1, TRY1     # x1 = PC + 4 = 20
addi x31,x0,15    # x31 = 0xF (not executed)

TRY1:
addi x30,x0,15    # x30 = 0xF (executed)
jal  x2, TRY2     # x2 = PC + 4 = 32
addi x0,x0,0      # halt

TRY2:
addi x29,x0,15    # x29 = 0xF  (executed)
jal  x0, TRY3     # JUMP
addi x0,x0,0      # halt

TRY3:
addi x28,x0,15    # x28 = 0xF (executed)
addi x0,x0,0      # halt

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall