
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/addi.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	08000093          	li	ra,128
   4:	00008113          	mv	sp,ra
   8:	00a10193          	addi	gp,sp,10
   c:	ff610213          	addi	tp,sp,-10
  10:	f8000293          	li	t0,-128
  14:	00028313          	mv	t1,t0
  18:	00a28393          	addi	t2,t0,10
  1c:	ff628413          	addi	s0,t0,-10
  20:	00000013          	nop
  24:	00000013          	nop
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00100073          	ebreak
