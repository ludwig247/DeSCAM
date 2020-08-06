
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/srl.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	04000093          	li	ra,64
   4:	00100113          	li	sp,1
   8:	00400193          	li	gp,4
   c:	00700213          	li	tp,7
  10:	0020d2b3          	srl	t0,ra,sp
  14:	0032d333          	srl	t1,t0,gp
  18:	0040d3b3          	srl	t2,ra,tp
  1c:	0000d433          	srl	s0,ra,zero
  20:	003054b3          	srl	s1,zero,gp
  24:	00000013          	nop
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00100073          	ebreak
