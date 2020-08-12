
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/or.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00700093          	li	ra,7
   4:	00800113          	li	sp,8
   8:	00100193          	li	gp,1
   c:	00f00213          	li	tp,15
  10:	0010e0b3          	or	ra,ra,ra
  14:	0030e2b3          	or	t0,ra,gp
  18:	0040e333          	or	t1,ra,tp
  1c:	0010e3b3          	or	t2,ra,ra
  20:	0020e433          	or	s0,ra,sp
  24:	004164b3          	or	s1,sp,tp
  28:	0001e533          	or	a0,gp,zero
  2c:	003065b3          	or	a1,zero,gp
  30:	00000013          	nop
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00100073          	ebreak
