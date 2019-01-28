#
# @author:Luka
# sb.s
#
# Test for store byte (sb)
.globl _start

_start:
addi x1,x0,128		 # address 0x80
addi x2,x0,156		 # address 0x9C


addi  x3,x0,352 	 # x3 = 0x160
addi  x4,x0,55 		 # x4 = 0x37
addi  x5,x0,1		 # x5 = 0x1
addi  x6,x0,-13		 # x6 = 0xFFFFFFF3

sb    x3,0(x1) 		 # mem[0x80] = 0x60
sb    x4,1(x1) 		 # mem[0x81] = 0x37
sb    x5,6(x1)		 # mem[0x86] = 0x1
sb    x6,0(x2)        # mem[0x9C] = 0xF3
sb    x6,-1(x2)       # mem[0x9B] = 0xF3

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
