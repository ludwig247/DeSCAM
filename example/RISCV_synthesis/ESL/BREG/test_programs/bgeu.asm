
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/bgeu.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00500093          	li	ra,5
   4:	ffa00113          	li	sp,-6
   8:	00000f13          	li	t5,0
   c:	00000e93          	li	t4,0
  10:	00000e13          	li	t3,0
  14:	0020f663          	bleu	sp,ra,20 <TRY1>
  18:	00f00f93          	li	t6,15
  1c:	00117663          	bleu	ra,sp,28 <TRY2>

00000020 <TRY1>:
  20:	00f00f13          	li	t5,15
  24:	00000013          	nop

00000028 <TRY2>:
  28:	00f00e93          	li	t4,15
  2c:	0010f463          	bleu	ra,ra,34 <TRY3>
  30:	00000013          	nop

00000034 <TRY3>:
  34:	00f00e13          	li	t3,15
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00000013          	nop
  4c:	00100073          	ebreak
