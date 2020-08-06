
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/bltu.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00500093          	li	ra,5
   4:	ffa00113          	li	sp,-6
   8:	00000f13          	li	t5,0
   c:	00000e93          	li	t4,0
  10:	00000e13          	li	t3,0
  14:	00116463          	bltu	sp,ra,1c <TRY1>
  18:	0020e663          	bltu	ra,sp,24 <TRY2>

0000001c <TRY1>:
  1c:	00f00f93          	li	t6,15
  20:	00000013          	nop

00000024 <TRY2>:
  24:	00f00f13          	li	t5,15
  28:	0210e063          	bltu	ra,ra,48 <TRY3>
  2c:	00f00e93          	li	t4,15
  30:	00000013          	nop
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00100073          	ebreak

00000048 <TRY3>:
  48:	00f00e13          	li	t3,15
  4c:	00000013          	nop
