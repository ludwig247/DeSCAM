#
# @author:Luka
# sw.s
#
# Test for store word (sw)
.globl _start

_start:
addi x1,x0,128		 # address 0x80
addi x2,x0,156		 # address 0x9C

addi  x3,x0,352 	 # x3 = 0x160
addi  x4,x0,55 		 # x4 = 0x37
addi  x5,x0,1		 # x5 = 0x1
addi  x6,x0,-13		 # x6 = 0xFFFFFFF3

sw    x3, 0(x1) 		 # mem[0x80] = 0x60, mem[0x81] = 0x01, mem[0x82] = 0x0, mem[0x83] = 0x0
sw    x6, -4(x1)       # mem[0x7C] = 0xF3, mem[0x7D] = 0xFF, mem[0x7E] = 0xFF, mem[0x7F] = 0xFF
sw    x5, 4(x1)        # mem[0x84] = 0x1, mem[0x85] = 0x0, mem[0x86] = 0x0, mem[0x87] = 0x0

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
