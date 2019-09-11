
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/jal.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00000f93          	li	t6,0
   4:	00000f13          	li	t5,0
   8:	00000e93          	li	t4,0
   c:	00000e13          	li	t3,0
  10:	008000ef          	jal	ra,18 <TRY1>
  14:	00f00f93          	li	t6,15

00000018 <TRY1>:
  18:	00f00f13          	li	t5,15
  1c:	0080016f          	jal	sp,24 <TRY2>
  20:	00000013          	nop

00000024 <TRY2>:
  24:	00f00e93          	li	t4,15
  28:	0080006f          	j	30 <TRY3>
  2c:	00000013          	nop

00000030 <TRY3>:
  30:	00f00e13          	li	t3,15
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00100073          	ebreak
