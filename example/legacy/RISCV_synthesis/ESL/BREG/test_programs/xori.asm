
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/xori.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00700093          	li	ra,7
   4:	0070c113          	xori	sp,ra,7
   8:	0040c193          	xori	gp,ra,4
   c:	fff0c213          	not	tp,ra
  10:	00024293          	xori	t0,tp,0
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00000013          	nop
  24:	00100073          	ebreak
