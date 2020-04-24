
# @author :	Dino Mehmedagić
# @name   : 	switch.s
# @purpose: 	Perform a lot of switches.
# @notes  :	

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,2000	# for 100000 times
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000

	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000

	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000

	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
	addi x1,x1,2000
LOOP:
	beq x1,x0,END
	
	addi x2,x0,-1
	add x3,x0,x2
	addi x4,x0,-1
	add x5,x0,x2
	addi x6,x0,-1
	add x7,x0,x2
	addi x8,x0,-1
	add x9,x0,x2
	addi x10,x0,-1
	add x11,x0,x2
	addi x12,x0,-1
	add x13,x0,x2
	addi x14,x0,-1
	add x15,x0,x2
	addi x16,x0,-1
	add x17,x0,x2
	addi x18,x0,-1
	add x19,x0,x2
	addi x20,x0,-1
	add x21,x0,x2
	addi x22,x0,-1
	add x23,x0,x2
	addi x24,x0,-1
	add x25,x0,x2
	addi x26,x0,-1
	add x27,x0,x2
	addi x28,x0,-1
	add x29,x0,x2
	addi x30,x0,-1
	add x31,x0,x2


	
	addi x2,x2,1
	addi x3,x2,1
	addi x4,x2,1
	addi x5,x2,1
	addi x6,x2,1
	addi x7,x2,1
	addi x8,x2,1
	addi x9,x2,1
	addi x10,x2,1
	addi x11,x2,1
	addi x12,x2,1
	addi x13,x2,1
	addi x14,x2,1
	addi x15,x2,1
	addi x16,x2,1
	addi x17,x2,1
	addi x18,x2,1
	addi x19,x2,1
	addi x20,x2,1
	addi x21,x2,1
	addi x22,x2,1
	addi x23,x2,1
	addi x24,x2,1
	addi x25,x2,1
	addi x26,x2,1
	addi x27,x2,1
	addi x28,x2,1
	addi x29,x2,1
	addi x30,x2,1
	addi x31,x2,1




	addi x1,x1,-1	
	jal x0,LOOP
END:
	nop
	nop
	nop
	nop
	nop
_end:
	ebreak
