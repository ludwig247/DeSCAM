
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/srli.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	04000093          	li	ra,64
   4:	0010d113          	srli	sp,ra,0x1
   8:	00415193          	srli	gp,sp,0x4
   c:	0070d213          	srli	tp,ra,0x7
  10:	0000d293          	srli	t0,ra,0x0
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00000013          	nop
  24:	00100073          	ebreak
