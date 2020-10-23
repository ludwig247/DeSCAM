
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/push_pop.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	54100193          	li	gp,1345
   4:	04000f13          	li	t5,64
   8:	01000fef          	jal	t6,18 <PUSH>
   c:	01800fef          	jal	t6,24 <POP>

00000010 <HALT>:
  10:	00000013          	nop

00000014 <_end>:
  14:	00100073          	ebreak

00000018 <PUSH>:
  18:	004f0f13          	addi	t5,t5,4
  1c:	003f2023          	sw	gp,0(t5)
  20:	000f8067          	jr	t6

00000024 <POP>:
  24:	000f2203          	lw	tp,0(t5)
  28:	ffcf0f13          	addi	t5,t5,-4
  2c:	000f8067          	jr	t6
