
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/srai.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	04000093          	li	ra,64
   4:	fbf00113          	li	sp,-65
   8:	4010d193          	srai	gp,ra,0x1
   c:	4051d213          	srai	tp,gp,0x5
  10:	40215293          	srai	t0,sp,0x2
  14:	40d2d313          	srai	t1,t0,0xd
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00000013          	nop
  24:	00000013          	nop
  28:	00100073          	ebreak
