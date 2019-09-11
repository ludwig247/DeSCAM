
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/slti.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00700093          	li	ra,7
   4:	ff400113          	li	sp,-12
   8:	0200a193          	slti	gp,ra,32
   c:	0030a213          	slti	tp,ra,3
  10:	f9c0a293          	slti	t0,ra,-100
  14:	ffb12313          	slti	t1,sp,-5
  18:	00012393          	slti	t2,sp,0
  1c:	06412413          	slti	s0,sp,100
  20:	ff312493          	slti	s1,sp,-13
  24:	f9c12513          	slti	a0,sp,-100
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00000013          	nop
  38:	00100073          	ebreak
