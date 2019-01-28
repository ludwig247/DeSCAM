
JB.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	01800093          	li	ra,24
   4:	02000113          	li	sp,32
   8:	01800193          	li	gp,24
   c:	00018067          	jr	gp
  10:	00310233          	add	tp,sp,gp
  14:	00410293          	addi	t0,sp,4
  18:	18000313          	li	t1,384
  1c:	00108663          	beq	ra,ra,28 <FINALLY>
  20:	003103b3          	add	t2,sp,gp
  24:	00810413          	addi	s0,sp,8

00000028 <FINALLY>:
  28:	00c10493          	addi	s1,sp,12
  2c:	00348533          	add	a0,s1,gp
  30:	0e250a63          	beq	a0,sp,124 <HALT>
  34:	00050067          	jr	a0
  38:	0e250663          	beq	a0,sp,124 <HALT>
  3c:	0e250463          	beq	a0,sp,124 <HALT>
  40:	00000013          	nop
  44:	00a505b3          	add	a1,a0,a0
  48:	00a50863          	beq	a0,a0,58 <STOP>
  4c:	02210063          	beq	sp,sp,6c <BREAK>
  50:	0c318a63          	beq	gp,gp,124 <HALT>
  54:	00210c63          	beq	sp,sp,6c <BREAK>

00000058 <STOP>:
  58:	00332023          	sw	gp,0(t1)
  5c:	00058067          	jr	a1
  60:	00438393          	addi	t2,t2,4
  64:	00138393          	addi	t2,t2,1
  68:	00140413          	addi	s0,s0,1

0000006c <BREAK>:
  6c:	0a218c63          	beq	gp,sp,124 <HALT>
  70:	00058067          	jr	a1
  74:	00138393          	addi	t2,t2,1
  78:	00038393          	mv	t2,t2
  7c:	00c60613          	addi	a2,a2,12
  80:	00d68693          	addi	a3,a3,13
  84:	00e70713          	addi	a4,a4,14
  88:	00232223          	sw	sp,4(t1)
  8c:	02458613          	addi	a2,a1,36
  90:	00318263          	beq	gp,gp,94 <HEY>

00000094 <HEY>:
  94:	00b32423          	sw	a1,8(t1)
  98:	01188893          	addi	a7,a7,17
  9c:	00060067          	jr	a2
  a0:	01188933          	add	s2,a7,a7
  a4:	012909b3          	add	s3,s2,s2
  a8:	01398a33          	add	s4,s3,s3
  ac:	00a32623          	sw	a0,12(t1)
  b0:	00318663          	beq	gp,gp,bc <HALLO>
  b4:	01188933          	add	s2,a7,a7
  b8:	012909b3          	add	s3,s2,s2

000000bc <HALLO>:
  bc:	02860693          	addi	a3,a2,40
  c0:	00a32823          	sw	a0,16(t1)
  c4:	06218063          	beq	gp,sp,124 <HALT>
  c8:	00068067          	jr	a3
  cc:	01188933          	add	s2,a7,a7
  d0:	012909b3          	add	s3,s2,s2
  d4:	00218a33          	add	s4,gp,sp
  d8:	014a0ab3          	add	s5,s4,s4
  dc:	054a8463          	beq	s5,s4,124 <HALT>
  e0:	00c00b6f          	jal	s6,ec <BYE>
  e4:	014a8bb3          	add	s7,s5,s4
  e8:	014a0c33          	add	s8,s4,s4

000000ec <BYE>:
  ec:	014a8cb3          	add	s9,s5,s4
  f0:	00a32a23          	sw	a0,20(t1)
  f4:	02218863          	beq	gp,sp,124 <HALT>
  f8:	00c00d6f          	jal	s10,104 <HELLOAGAIN>
  fc:	014a8bb3          	add	s7,s5,s4
 100:	014a0c33          	add	s8,s4,s4

00000104 <HELLOAGAIN>:
 104:	019c8db3          	add	s11,s9,s9
 108:	00a32c23          	sw	a0,24(t1)
 10c:	004d8e13          	addi	t3,s11,4
 110:	00218a63          	beq	gp,sp,124 <HALT>
 114:	00c00eef          	jal	t4,120 <FINALBYE>
 118:	014a8bb3          	add	s7,s5,s4
 11c:	014a0c33          	add	s8,s4,s4

00000120 <FINALBYE>:
 120:	01de8f33          	add	t5,t4,t4

00000124 <HALT>:
 124:	00000013          	nop
 128:	00000013          	nop
 12c:	00000013          	nop
 130:	00000013          	nop
 134:	05d00893          	li	a7,93
 138:	00000513          	li	a0,0
 13c:	00000073          	ecall
