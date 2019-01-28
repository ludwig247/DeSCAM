
testing.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	10000293          	li	t0,256
   4:	02c00313          	li	t1,44
   8:	0062a023          	sw	t1,0(t0)
   c:	00100093          	li	ra,1
  10:	00108133          	add	sp,ra,ra
  14:	002101b3          	add	gp,sp,sp
  18:	00018213          	mv	tp,gp
  1c:	404283b3          	sub	t2,t0,tp
  20:	0043a403          	lw	s0,4(t2)
  24:	004404b3          	add	s1,s0,tp
  28:	00048067          	jr	s1
  2c:	00020393          	mv	t2,tp
  30:	00828513          	addi	a0,t0,8
  34:	404505b3          	sub	a1,a0,tp
  38:	00b5a023          	sw	a1,0(a1)
  3c:	00458633          	add	a2,a1,tp
  40:	00c60263          	beq	a2,a2,44 <LOAD>

00000044 <LOAD>:
  44:	0002a683          	lw	a3,0(t0)
  48:	00d68733          	add	a4,a3,a3
  4c:	0002a783          	lw	a5,0(t0)
  50:	03c78813          	addi	a6,a5,60
  54:	0105a223          	sw	a6,4(a1)
  58:	0005a883          	lw	a7,0(a1)
  5c:	0048a883          	lw	a7,4(a7)
  60:	00088067          	jr	a7
  64:	00020393          	mv	t2,tp
  68:	0005a903          	lw	s2,0(a1)
  6c:	01292423          	sw	s2,8(s2)
  70:	0045a903          	lw	s2,4(a1)
  74:	0125a623          	sw	s2,12(a1)
  78:	0005a903          	lw	s2,0(a1)
  7c:	01290263          	beq	s2,s2,80 <JUMP>

00000080 <JUMP>:
  80:	004009ef          	jal	s3,84 <R>

00000084 <R>:
  84:	01398a33          	add	s4,s3,s3
  88:	00400aef          	jal	s5,8c <I_I>

0000008c <I_I>:
  8c:	000a8b13          	mv	s6,s5
  90:	00400bef          	jal	s7,94 <S>

00000094 <S>:
  94:	097ba023          	sw	s7,128(s7)
  98:	00400c6f          	jal	s8,9c <I_L>

0000009c <I_L>:
  9c:	078c2c83          	lw	s9,120(s8)
  a0:	00400d6f          	jal	s10,a4 <B>

000000a4 <B>:
  a4:	01ad0263          	beq	s10,s10,a8 <J>

000000a8 <J>:
  a8:	00800def          	jal	s11,b0 <I_J>
  ac:	0080006f          	j	b4 <SPECIAL>

000000b0 <I_J>:
  b0:	000d8067          	jr	s11

000000b4 <SPECIAL>:
  b4:	010d8e13          	addi	t3,s11,16
  b8:	000e0067          	jr	t3
  bc:	008e0e93          	addi	t4,t3,8
  c0:	000e8f67          	jalr	t5,t4
  c4:	01ef0f33          	add	t5,t5,t5
  c8:	00000f97          	auipc	t6,0x0
  cc:	01df9263          	bne	t6,t4,d0 <HALT>

000000d0 <HALT>:
  d0:	00000013          	nop
  d4:	00000013          	nop
  d8:	00000013          	nop
  dc:	00000013          	nop
  e0:	05d00893          	li	a7,93
  e4:	00000513          	li	a0,0
  e8:	00000073          	ecall
