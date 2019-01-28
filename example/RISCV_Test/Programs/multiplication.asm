
multiplication.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00b00093          	li	ra,11
   4:	00c00113          	li	sp,12
   8:	00000193          	li	gp,0
   c:	00000293          	li	t0,0
  10:	00104a63          	bgtz	ra,24 <LOOP>
  14:	00100193          	li	gp,1
  18:	fff00213          	li	tp,-1
  1c:	0040c0b3          	xor	ra,ra,tp
  20:	00108093          	addi	ra,ra,1

00000024 <LOOP>:
  24:	00100863          	beq	zero,ra,34 <DONE>
  28:	002282b3          	add	t0,t0,sp
  2c:	fff08093          	addi	ra,ra,-1
  30:	ff5ff06f          	j	24 <LOOP>

00000034 <DONE>:
  34:	00300863          	beq	zero,gp,44 <HALT>
  38:	fff00213          	li	tp,-1
  3c:	0042c2b3          	xor	t0,t0,tp
  40:	00128293          	addi	t0,t0,1

00000044 <HALT>:
  44:	00000013          	nop
  48:	00000013          	nop
  4c:	00000013          	nop
  50:	00000013          	nop
  54:	05d00893          	li	a7,93
  58:	00000513          	li	a0,0
  5c:	00000073          	ecall
