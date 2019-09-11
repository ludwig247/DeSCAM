
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/sub.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	08000093          	li	ra,128
   4:	00a00113          	li	sp,10
   8:	ff600193          	li	gp,-10
   c:	f8000213          	li	tp,-128
  10:	402082b3          	sub	t0,ra,sp
  14:	40308333          	sub	t1,ra,gp
  18:	400083b3          	sub	t2,ra,zero
  1c:	40100433          	neg	s0,ra
  20:	401084b3          	sub	s1,ra,ra
  24:	40220533          	sub	a0,tp,sp
  28:	403205b3          	sub	a1,tp,gp
  2c:	40020633          	sub	a2,tp,zero
  30:	404006b3          	neg	a3,tp
  34:	40420733          	sub	a4,tp,tp
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00100073          	ebreak
