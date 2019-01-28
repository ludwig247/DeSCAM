#
# @author:Don Dennis
# fibonacci.s
#
# Find the Nth fibonacci number.
# x5 holds N and ans returned in #3

.global _start
_start:
    	addi x5,x0,9		#0x00	# Replace with N
    	addi x1,x0,1 		#0x04	#a1
    	addi x2,x0,0 		#0x08	#a0
    	addi x3,x0,0 		#0x0c	#ans
    	addi x4,x0,1 		#0x10	#i
FOR:
    	add  x3, x1, x2		#0x14
	    add  x2, x0, x1		#0x18
    	add  x1, x0, x3		#0x1c
    	addi x4, x4, 1		#0x20
    	blt  x4, x5, FOR	#0x24
HALT:    
    	addi x0,x0,0		#0x28	#end of ID stage of the last instruction
    	addi x0,x0,0		#0x2c	#end of EX stage of the last instruction
    	addi x0,x0,0		#0x30	#end of MEM stage of the last instruction
    	addi x0,x0,0		#0x34	#end of WB stage of the last instruction
    	
# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall