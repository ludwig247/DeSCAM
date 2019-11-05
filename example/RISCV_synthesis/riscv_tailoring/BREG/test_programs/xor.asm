
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/xor.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00700093          	li	ra,7
   4:	00400113          	li	sp,4
   8:	fff00193          	li	gp,-1
   c:	0010c233          	xor	tp,ra,ra
  10:	0020c2b3          	xor	t0,ra,sp
  14:	0030c333          	xor	t1,ra,gp
  18:	000343b3          	xor	t2,t1,zero
  1c:	00604433          	xor	s0,zero,t1
  20:	0073c4b3          	xor	s1,t2,t2
  24:	00000013          	nop
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00100073          	ebreak
