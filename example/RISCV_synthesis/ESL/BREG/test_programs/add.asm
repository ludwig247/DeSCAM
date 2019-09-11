
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/add.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	08000093          	li	ra,128
   4:	00a00113          	li	sp,10
   8:	ff600193          	li	gp,-10
   c:	f8000213          	li	tp,-128
  10:	002082b3          	add	t0,ra,sp
  14:	00308333          	add	t1,ra,gp
  18:	000083b3          	add	t2,ra,zero
  1c:	00100433          	add	s0,zero,ra
  20:	001084b3          	add	s1,ra,ra
  24:	00220533          	add	a0,tp,sp
  28:	003205b3          	add	a1,tp,gp
  2c:	00020633          	add	a2,tp,zero
  30:	004006b3          	add	a3,zero,tp
  34:	00420733          	add	a4,tp,tp
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00100073          	ebreak
