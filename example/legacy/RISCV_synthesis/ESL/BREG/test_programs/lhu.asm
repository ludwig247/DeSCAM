
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/lhu.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	08000093          	li	ra,128
   4:	00100113          	li	sp,1
   8:	00200193          	li	gp,2
   c:	00300213          	li	tp,3
  10:	00400293          	li	t0,4
  14:	00208023          	sb	sp,0(ra)
  18:	003080a3          	sb	gp,1(ra)
  1c:	00408123          	sb	tp,2(ra)
  20:	005081a3          	sb	t0,3(ra)
  24:	0ff00313          	li	t1,255
  28:	0fe00393          	li	t2,254
  2c:	0fd00413          	li	s0,253
  30:	0fc00493          	li	s1,252
  34:	00608223          	sb	t1,4(ra)
  38:	007082a3          	sb	t2,5(ra)
  3c:	00808323          	sb	s0,6(ra)
  40:	009083a3          	sb	s1,7(ra)
  44:	0000df83          	lhu	t6,0(ra)
  48:	0040df03          	lhu	t5,4(ra)
  4c:	0030de83          	lhu	t4,3(ra)
  50:	00000013          	nop
  54:	00000013          	nop
  58:	00000013          	nop
  5c:	00000013          	nop
  60:	00100073          	ebreak
