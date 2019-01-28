
recursive_sum.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00900093          	li	ra,9
   4:	10000f13          	li	t5,256
   8:	02000fef          	jal	t6,28 <FAB>

0000000c <HALT>:
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	05d00893          	li	a7,93
  20:	00000513          	li	a0,0
  24:	00000073          	ecall

00000028 <FAB>:
  28:	000f8193          	mv	gp,t6
  2c:	03c00fef          	jal	t6,68 <PUSH>
  30:	00200213          	li	tp,2
  34:	0240c263          	blt	ra,tp,58 <RET_ONE>
  38:	001001b3          	add	gp,zero,ra
  3c:	02c00fef          	jal	t6,68 <PUSH>
  40:	fff08093          	addi	ra,ra,-1
  44:	fe5fffef          	jal	t6,28 <FAB>
  48:	02c00fef          	jal	t6,74 <POP>
  4c:	003e8eb3          	add	t4,t4,gp
  50:	00000193          	li	gp,0
  54:	00018463          	beqz	gp,5c <RET>

00000058 <RET_ONE>:
  58:	00100e93          	li	t4,1

0000005c <RET>:
  5c:	01800fef          	jal	t6,74 <POP>
  60:	00300fb3          	add	t6,zero,gp
  64:	000f8067          	jr	t6

00000068 <PUSH>:
  68:	004f0f13          	addi	t5,t5,4
  6c:	003f2023          	sw	gp,0(t5)
  70:	000f8067          	jr	t6

00000074 <POP>:
  74:	000f2183          	lw	gp,0(t5)
  78:	ffcf0f13          	addi	t5,t5,-4
  7c:	000f8067          	jr	t6
