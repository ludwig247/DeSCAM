
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/sw.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	08000093          	li	ra,128
   4:	09c00113          	li	sp,156
   8:	16000193          	li	gp,352
   c:	03700213          	li	tp,55
  10:	00100293          	li	t0,1
  14:	ff300313          	li	t1,-13
  18:	0030a023          	sw	gp,0(ra)
  1c:	fe60ae23          	sw	t1,-4(ra)
  20:	0050a223          	sw	t0,4(ra)
  24:	00000013          	nop
  28:	00000013          	nop
  2c:	00000013          	nop
  30:	00000013          	nop
  34:	00100073          	ebreak
