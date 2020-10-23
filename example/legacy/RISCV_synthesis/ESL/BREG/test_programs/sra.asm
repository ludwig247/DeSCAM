
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/sra.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	04000093          	li	ra,64
   4:	fbf00113          	li	sp,-65
   8:	00100193          	li	gp,1
   c:	00500213          	li	tp,5
  10:	00200293          	li	t0,2
  14:	00d00313          	li	t1,13
  18:	4030d3b3          	sra	t2,ra,gp
  1c:	4043d433          	sra	s0,t2,tp
  20:	400454b3          	sra	s1,s0,zero
  24:	4064d533          	sra	a0,s1,t1
  28:	405155b3          	sra	a1,sp,t0
  2c:	4065d633          	sra	a2,a1,t1
  30:	400656b3          	sra	a3,a2,zero
  34:	40405733          	sra	a4,zero,tp
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00100073          	ebreak
