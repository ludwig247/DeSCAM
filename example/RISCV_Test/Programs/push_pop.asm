
push_pop.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	54100193          	li	gp,1345
   4:	04000f13          	li	t5,64
   8:	02400fef          	jal	t6,2c <PUSH>
   c:	02c00fef          	jal	t6,38 <POP>

00000010 <HALT>:
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	05d00893          	li	a7,93
  24:	00000513          	li	a0,0
  28:	00000073          	ecall

0000002c <PUSH>:
  2c:	004f0f13          	addi	t5,t5,4
  30:	003f2023          	sw	gp,0(t5)
  34:	000f8067          	jr	t6

00000038 <POP>:
  38:	000f2203          	lw	tp,0(t5)
  3c:	ffcf0f13          	addi	t5,t5,-4
  40:	000f8067          	jr	t6
