
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/slli.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00800093          	li	ra,8
   4:	00109113          	slli	sp,ra,0x1
   8:	00211193          	slli	gp,sp,0x2
   c:	00019213          	slli	tp,gp,0x0
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00100073          	ebreak
