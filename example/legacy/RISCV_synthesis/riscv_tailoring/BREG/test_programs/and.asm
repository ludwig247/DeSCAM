
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/and.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00700093          	li	ra,7
   4:	00800113          	li	sp,8
   8:	00100193          	li	gp,1
   c:	00f00213          	li	tp,15
  10:	0010f0b3          	and	ra,ra,ra
  14:	0030f2b3          	and	t0,ra,gp
  18:	0040f333          	and	t1,ra,tp
  1c:	0010f3b3          	and	t2,ra,ra
  20:	0020f433          	and	s0,ra,sp
  24:	004174b3          	and	s1,sp,tp
  28:	0001f533          	and	a0,gp,zero
  2c:	003075b3          	and	a1,zero,gp
  30:	00000013          	nop
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00100073          	ebreak
