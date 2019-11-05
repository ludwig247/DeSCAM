
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/bne.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00500093          	li	ra,5
   4:	ffa00113          	li	sp,-6
   8:	ffa00193          	li	gp,-6
   c:	00000f13          	li	t5,0
  10:	00000e93          	li	t4,0
  14:	00209263          	bne	ra,sp,18 <TRY1>

00000018 <TRY1>:
  18:	00f00f93          	li	t6,15
  1c:	00311663          	bne	sp,gp,28 <TRY2>
  20:	00009863          	bnez	ra,30 <TRY3>
  24:	00000013          	nop

00000028 <TRY2>:
  28:	00f00f13          	li	t5,15
  2c:	00000013          	nop

00000030 <TRY3>:
  30:	00f00e93          	li	t4,15
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00100073          	ebreak
