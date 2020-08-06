
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/test_programs/recursive_sum.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00900093          	li	ra,9
   4:	10000f13          	li	t5,256
   8:	00c00fef          	jal	t6,14 <FAB>

0000000c <HALT>:
   c:	00000013          	nop

00000010 <_end>:
  10:	00100073          	ebreak

00000014 <FAB>:
  14:	000f8193          	mv	gp,t6
  18:	03c00fef          	jal	t6,54 <PUSH>
  1c:	00200213          	li	tp,2
  20:	0240c263          	blt	ra,tp,44 <RET_ONE>
  24:	001001b3          	add	gp,zero,ra
  28:	02c00fef          	jal	t6,54 <PUSH>
  2c:	fff08093          	addi	ra,ra,-1
  30:	fe5fffef          	jal	t6,14 <FAB>
  34:	02c00fef          	jal	t6,60 <POP>
  38:	003e8eb3          	add	t4,t4,gp
  3c:	00000193          	li	gp,0
  40:	00018463          	beqz	gp,48 <RET>

00000044 <RET_ONE>:
  44:	00100e93          	li	t4,1

00000048 <RET>:
  48:	01800fef          	jal	t6,60 <POP>
  4c:	00300fb3          	add	t6,zero,gp
  50:	000f8067          	jr	t6

00000054 <PUSH>:
  54:	004f0f13          	addi	t5,t5,4
  58:	003f2023          	sw	gp,0(t5)
  5c:	000f8067          	jr	t6

00000060 <POP>:
  60:	000f2183          	lw	gp,0(t5)
  64:	ffcf0f13          	addi	t5,t5,-4
  68:	000f8067          	jr	t6
