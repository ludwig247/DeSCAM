
# @author :	Dino Mehmedagić
# @name   : 	enc_u_low.s
# @purpose: 	Test for U-type instructions with an attempt to eliminate the power dependency on data

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
     
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	lui x1,1048575
	lui x1,0
	



_end:
	ebreak

