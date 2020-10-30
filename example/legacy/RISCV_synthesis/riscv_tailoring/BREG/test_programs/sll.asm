
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/sll.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00800093          	li	ra,8
   4:	00100113          	li	sp,1
   8:	00200193          	li	gp,2
   c:	00209233          	sll	tp,ra,sp
  10:	003212b3          	sll	t0,tp,gp
  14:	00029333          	sll	t1,t0,zero
  18:	002013b3          	sll	t2,zero,sp
  1c:	00000013          	nop
  20:	00000013          	nop
  24:	00000013          	nop
  28:	00000013          	nop
  2c:	00100073          	ebreak
