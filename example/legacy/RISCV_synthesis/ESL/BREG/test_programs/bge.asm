
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/bge.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00500093          	li	ra,5
   4:	ffa00113          	li	sp,-6
   8:	00000f93          	li	t6,0
   c:	00000f13          	li	t5,0
  10:	00000e93          	li	t4,0
  14:	00000e13          	li	t3,0
  18:	0020d463          	ble	sp,ra,20 <TRY1>
  1c:	00f00f93          	li	t6,15

00000020 <TRY1>:
  20:	00f00f13          	li	t5,15
  24:	00115463          	ble	ra,sp,2c <TRY2>
  28:	0010d663          	ble	ra,ra,34 <TRY3>

0000002c <TRY2>:
  2c:	00f00e93          	li	t4,15
  30:	00000013          	nop

00000034 <TRY3>:
  34:	00f00e13          	li	t3,15
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00000013          	nop
  4c:	00100073          	ebreak
