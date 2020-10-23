
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/sltu.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00700093          	li	ra,7
   4:	ff400113          	li	sp,-12
   8:	02000f93          	li	t6,32
   c:	00300f13          	li	t5,3
  10:	f9c00e93          	li	t4,-100
  14:	ffb00e13          	li	t3,-5
  18:	06400d93          	li	s11,100
  1c:	ff300d13          	li	s10,-13
  20:	01f0b1b3          	sltu	gp,ra,t6
  24:	01e0b233          	sltu	tp,ra,t5
  28:	01d0b2b3          	sltu	t0,ra,t4
  2c:	01c13333          	sltu	t1,sp,t3
  30:	000133b3          	sltu	t2,sp,zero
  34:	01b13433          	sltu	s0,sp,s11
  38:	01a134b3          	sltu	s1,sp,s10
  3c:	01d13533          	sltu	a0,sp,t4
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00000013          	nop
  4c:	00000013          	nop
  50:	00100073          	ebreak
