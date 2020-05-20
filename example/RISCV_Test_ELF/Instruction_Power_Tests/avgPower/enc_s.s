
# @author :	Dino Mehmedagić
# @name   : 	enc_s.s
# @purpose: 	Test for store with an attempt to average out the power dependency on data and the initial addi instructions

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	addi x1,x0,-1		# x1 = 0xFFFFFFFF
	addi x2,x0,256		# x2 = 0x100 -> address

	sw x1,0(x2)		# mem[0x100..103] = 0xFFFFFFFF
	sw x0,4(x2)		# mem[0x104..107] = 0x00000000

	sw x1,8(x2)		# mem[0x108..111] = 0xFFFFFFFF	
	sw x0,12(x2)		# mem[0x112..116] = 0x00000000

	sw x0,4(x2)		# mem[0x100..103] = 0x00000000
	sw x0,12(x2)		# mem[0x112..116] = 0x00000000

	sw x1,0(x2)		# mem[0x108..111] = 0xFFFFFFFF	
	sw x0,8(x2)		# mem[0x112..116] = 0xFFFFFFFF

	sw x1,0(x0)		# mem[0x0..3] = 0xFFFFFFFF
	sw x0,4(x0)		# mem[0x4..7] = 0x00000000

	sw x1,8(x0)		# mem[0x8..11] = 0xFFFFFFFF	
	sw x0,12(x0)		# mem[0x12..16] = 0x00000000

	sw x0,4(x0)		# mem[0x0..3] = 0x00000000
	sw x0,12(x0)		# mem[0x12..16] = 0x00000000

	sw x1,0(x0)		# mem[0x8..11] = 0xFFFFFFFF	
	sw x0,8(x0)		# mem[0x12..16] = 0xFFFFFFFF

	sw x1,0(x2)		# mem[0x100..103] = 0xFFFFFFFF
	sw x0,4(x2)		# mem[0x104..107] = 0x00000000

	sw x1,8(x2)		# mem[0x108..111] = 0xFFFFFFFF	
	sw x0,12(x2)		# mem[0x112..116] = 0x00000000

	sw x0,4(x2)		# mem[0x104..107] = 0x00000000
	sw x0,12(x2)		# mem[0x112..116] = 0x00000000

	sw x1,0(x2)		# mem[0x108..111] = 0xFFFFFFFF	
	sw x0,8(x2)		# mem[0x112..116] = 0xFFFFFFFF

	sw x1,0(x0)		# mem[0x0..3] = 0xFFFFFFFF
	sw x0,4(x0)		# mem[0x4..7] = 0x00000000

	sw x1,8(x0)		# mem[0x8..11] = 0xFFFFFFFF	
	sw x0,12(x0)		# mem[0x12..16] = 0x00000000

	sw x0,4(x0)		# mem[0x0..3] = 0x00000000
	sw x0,12(x0)		# mem[0x12..16] = 0x00000000

	sw x1,0(x0)		# mem[0x8..11] = 0xFFFFFFFF	
	sw x0,8(x0)		# mem[0x12..16] = 0xFFFFFFFF

	sh x1,0(x2)		# mem[0x100-101] = 0xFFFF
	sh x0,2(x2)		# mem[0x102-103] = 0x0000

	sh x1,8(x2)		# mem[0x108-109] = 0xFFFF	
	sh x0,10(x2)		# mem[0x110-111] = 0x0000

	sh x0,4(x2)		# mem[0x104-105] = 0x0000
	sh x0,12(x2)		# mem[0x112-113] = 0x0000

	sh x1,0(x2)		# mem[0x100-101] = 0xFFFF	
	sh x0,8(x2)		# mem[0x108-109] = 0xFFFF

	sb x1,0(x0)		# mem[0x0] = 0xFF
	sb x0,1(x0)		# mem[0x1] = 0x00

	sb x1,8(x0)		# mem[0x8] = 0xFF	
	sb x0,9(x0)		# mem[0x9] = 0x00

	sb x0,4(x0)		# mem[0x4] = 0x00
	sb x0,12(x0)		# mem[0x12] = 0x00

	sb x1,0(x0)		# mem[0x0] = 0xFF	
	sb x0,8(x0)		# mem[0x8] = 0xFF


_end:
	ebreak
