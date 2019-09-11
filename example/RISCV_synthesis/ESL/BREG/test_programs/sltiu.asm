
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/sltiu.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00700093          	li	ra,7
   4:	ff400113          	li	sp,-12
   8:	0200b193          	sltiu	gp,ra,32
   c:	0030b213          	sltiu	tp,ra,3
  10:	f9c0b293          	sltiu	t0,ra,-100
  14:	ffb13313          	sltiu	t1,sp,-5
  18:	00013393          	sltiu	t2,sp,0
  1c:	06413413          	sltiu	s0,sp,100
  20:	ff313493          	sltiu	s1,sp,-13
  24:	f9c13513          	sltiu	a0,sp,-100
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00000013          	nop
  38:	00100073          	ebreak
