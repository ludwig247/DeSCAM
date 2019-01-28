
fibonacci.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00900293          	li	t0,9
   4:	00100093          	li	ra,1
   8:	00000113          	li	sp,0
   c:	00000193          	li	gp,0
  10:	00100213          	li	tp,1

00000014 <FOR>:
  14:	002081b3          	add	gp,ra,sp
  18:	00100133          	add	sp,zero,ra
  1c:	003000b3          	add	ra,zero,gp
  20:	00120213          	addi	tp,tp,1 # 1 <_start+0x1>
  24:	fe5248e3          	blt	tp,t0,14 <FOR>

00000028 <HALT>:
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00000013          	nop
  38:	05d00893          	li	a7,93
  3c:	00000513          	li	a0,0
  40:	00000073          	ecall
