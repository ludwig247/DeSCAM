
# @author :	Dino Mehmedagić
# @name   : 	highPower.s
# @purpose: 	Perform a lot of switches.
# @notes  :	

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x5,x0,-1	# x5 = 2^32 - 1
	addi x5,x5,1 	# x5 = 0
	addi x5,x5,-1	# repeat many times
	addi x5,x5,1
	addi x5,x5,-1	
	addi x5,x5,1 	
	addi x5,x5,-1	
	addi x5,x5,1 
	addi x5,x5,-1	
	addi x5,x5,1 
	addi x5,x5,-1	
	addi x5,x5,1 
	addi x5,x5,-1	# leave at all 1's

	addi x1,x0,-1	# x1 = 2^32 - 1
	addi x1,x1,1 	# x1 = 0
	addi x1,x1,-1	# repeat many times
	addi x1,x1,1
	addi x1,x1,-1
	addi x1,x1,1
	addi x1,x1,-1
	addi x1,x1,1
	addi x1,x1,-1
	addi x1,x1,1
	addi x1,x1,-1
	addi x1,x1,1
	addi x1,x1,-1
	addi x1,x1,1	# leave x1 at all 0's

	addi x2,x0,256	# x2 = 0x100 <-- address
	addi x3,x0,300	# x3 = 0x12C <-- address

    sw x5,0(x2)	# store all 1's to address 0x100 in memory
	sw x1,0(x3)	# store all 0's to address 0x12C in memory
	sw x5,4(x2)	# repeat storing to adjacent places in memory
	sw x1,4(x3)
	sw x5,8(x2) 
	sw x1,8(x3)
	sw x5,12(x2) 
	sw x1,12(x3)
	sw x5,16(x2) 
	sw x1,16(x3)
	sw x5,20(x2) 
	sw x1,20(x3)

    lw x6,0(x2)	# load all 1's from address 0x100 in memory
	lw x6,0(x3)	# load all 0's from address 0x12C in memory
	lw x6,4(x2)	# repeat loading from adjacent places in memory
	lw x6,4(x3)
	lw x6,8(x2) 
	lw x6,8(x3)
	lw x6,12(x2) 
	lw x6,12(x3)
	lw x6,16(x2) 
	lw x6,16(x3)
	lw x6,20(x2) 
	lw x6,20(x3)

	nop
	nop
	nop
	nop
	nop
_end:
	ebreak
