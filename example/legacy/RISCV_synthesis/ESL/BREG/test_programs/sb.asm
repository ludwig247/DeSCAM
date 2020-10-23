
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/sb.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	08000093          	li	ra,128
   4:	09c00113          	li	sp,156
   8:	16000193          	li	gp,352
   c:	03700213          	li	tp,55
  10:	00100293          	li	t0,1
  14:	ff300313          	li	t1,-13
  18:	00308023          	sb	gp,0(ra)
  1c:	004080a3          	sb	tp,1(ra)
  20:	00508323          	sb	t0,6(ra)
  24:	00610023          	sb	t1,0(sp)
  28:	fe610fa3          	sb	t1,-1(sp)
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00100073          	ebreak
