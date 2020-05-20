
# @author :	Dino Mehmedagić
# @name   : 	enc_i_l_low.s
# @purpose: 	Test for load with an attempt to eliminate power dependency on data

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	lw x0,0(x0)
	

_end:
	ebreak
