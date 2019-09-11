
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/jalr.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00000f93          	li	t6,0
   4:	00000f13          	li	t5,0
   8:	00000e93          	li	t4,0
   c:	024000ef          	jal	ra,30 <TRY1>
  10:	00f00f93          	li	t6,15
  14:	00f00f13          	li	t5,15
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00000013          	nop
  24:	00000013          	nop
  28:	00000013          	nop
  2c:	00100073          	ebreak

00000030 <TRY1>:
  30:	00f00e93          	li	t4,15
  34:	00408167          	jalr	sp,4(ra)
  38:	00000013          	nop
