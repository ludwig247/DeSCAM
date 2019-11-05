.globl _start
.globl main
.equ _memEnd, 0x10000

_start:
li sp, _memEnd
jal main

_end:
	ebreak
