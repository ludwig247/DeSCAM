
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/blt.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00500093          	li	ra,5
   4:	ffa00113          	li	sp,-6
   8:	00000f13          	li	t5,0
   c:	00000e93          	li	t4,0
  10:	0020c463          	blt	ra,sp,18 <TRY1>
  14:	00114663          	blt	sp,ra,20 <TRY2>

00000018 <TRY1>:
  18:	00f00f93          	li	t6,15
  1c:	00000013          	nop

00000020 <TRY2>:
  20:	00f00f13          	li	t5,15
  24:	0010ce63          	blt	ra,ra,40 <TRY3>
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00100073          	ebreak

00000040 <TRY3>:
  40:	00f00e93          	li	t4,15
  44:	00000013          	nop
