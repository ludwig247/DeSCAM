
store.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	08000093          	li	ra,128
   4:	09c00113          	li	sp,156
   8:	00005a37          	lui	s4,0x5
   c:	00000a97          	auipc	s5,0x0
  10:	00064b17          	auipc	s6,0x64
  14:	16000293          	li	t0,352
  18:	03700313          	li	t1,55
  1c:	00100393          	li	t2,1
  20:	00300413          	li	s0,3
  24:	fff00493          	li	s1,-1
  28:	08100513          	li	a0,129
  2c:	f9c00593          	li	a1,-100
  30:	0050a023          	sw	t0,0(ra)
  34:	00609223          	sh	t1,4(ra)
  38:	00708323          	sb	t2,6(ra)
  3c:	00808023          	sb	s0,0(ra)
  40:	00912023          	sw	s1,0(sp)
  44:	00a12223          	sw	a0,4(sp)
  48:	00b11423          	sh	a1,8(sp)
  4c:	00012f83          	lw	t6,0(sp)
  50:	00011f03          	lh	t5,0(sp)
  54:	00015e83          	lhu	t4,0(sp)
  58:	00010e03          	lb	t3,0(sp)
  5c:	00014d83          	lbu	s11,0(sp)
  60:	00410d03          	lb	s10,4(sp)
  64:	00414c83          	lbu	s9,4(sp)
  68:	00000013          	nop
  6c:	00000013          	nop
  70:	00000013          	nop
  74:	00000013          	nop
  78:	05d00893          	li	a7,93
  7c:	00000513          	li	a0,0
  80:	00000073          	ecall
