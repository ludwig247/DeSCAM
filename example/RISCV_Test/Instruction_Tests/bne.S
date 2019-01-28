#
# @author:Luka
# bne.s
#
# Test for branch not equal (bne)
.globl _start

_start:
addi x1,x0,5		 # x1 = 5
addi x2,x0,-6		 # x2 = -6
addi x3,x0,-6        # x3 = -6
#addi x31,x0,0        # x31 = 0
addi x30,x0,0        # x30 = 0
addi x29,x0,0        # x29 = 0

bne  x1,x2,TRY1   # taken

TRY1:
addi x31,x0,15    # x31 = 0xF (executed)
bne  x2,x3,TRY2   # not taken
bne  x1,x0,TRY3   # taken
addi x0,x0,0      # halt

TRY2:
addi x30,x0,15    # x30 = 0xF  (not executed)
addi x0,x0,0      # halt

TRY3:
addi x29,x0,15    # x29 = 0xF (executed)
addi x0,x0,0      # halt

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall