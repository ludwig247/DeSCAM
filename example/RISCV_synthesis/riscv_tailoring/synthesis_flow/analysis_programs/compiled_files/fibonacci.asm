
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/synthesis_flow/analysis_programs/compiled_files/fibonacci.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	fff10113          	addi	sp,sp,-1 # ffff <_memEnd>
   8:	01c000ef          	jal	ra,24 <main>

0000000c <_end>:
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00100073          	ebreak

00000024 <main>:
  24:	fc010113          	addi	sp,sp,-64
  28:	02812e23          	sw	s0,60(sp)
  2c:	04010413          	addi	s0,sp,64
  30:	fca42623          	sw	a0,-52(s0)
  34:	fcb42423          	sw	a1,-56(s0)
  38:	00010613          	mv	a2,sp
  3c:	00060513          	mv	a0,a2
  40:	01400613          	li	a2,20
  44:	fcc42e23          	sw	a2,-36(s0)
  48:	fdc42603          	lw	a2,-36(s0)
  4c:	fff60613          	addi	a2,a2,-1
  50:	fcc42c23          	sw	a2,-40(s0)
  54:	00060593          	mv	a1,a2
  58:	00158593          	addi	a1,a1,1
  5c:	00058e13          	mv	t3,a1
  60:	00000e93          	li	t4,0
  64:	01be5593          	srli	a1,t3,0x1b
  68:	005e9713          	slli	a4,t4,0x5
  6c:	00e5e733          	or	a4,a1,a4
  70:	005e1693          	slli	a3,t3,0x5
  74:	00060713          	mv	a4,a2
  78:	00170713          	addi	a4,a4,1
  7c:	00070313          	mv	t1,a4
  80:	00000393          	li	t2,0
  84:	01b35713          	srli	a4,t1,0x1b
  88:	00539813          	slli	a6,t2,0x5
  8c:	01076833          	or	a6,a4,a6
  90:	00531793          	slli	a5,t1,0x5
  94:	00060793          	mv	a5,a2
  98:	00178793          	addi	a5,a5,1
  9c:	00279793          	slli	a5,a5,0x2
  a0:	00378793          	addi	a5,a5,3
  a4:	00f78793          	addi	a5,a5,15
  a8:	0047d793          	srli	a5,a5,0x4
  ac:	00479793          	slli	a5,a5,0x4
  b0:	40f10133          	sub	sp,sp,a5
  b4:	00010793          	mv	a5,sp
  b8:	00378793          	addi	a5,a5,3
  bc:	0027d793          	srli	a5,a5,0x2
  c0:	00279793          	slli	a5,a5,0x2
  c4:	fcf42a23          	sw	a5,-44(s0)
  c8:	fe042423          	sw	zero,-24(s0)
  cc:	00100793          	li	a5,1
  d0:	fef42623          	sw	a5,-20(s0)
  d4:	fe042223          	sw	zero,-28(s0)
  d8:	fe442703          	lw	a4,-28(s0)
  dc:	fdc42783          	lw	a5,-36(s0)
  e0:	06f75263          	ble	a5,a4,144 <main+0x120>
  e4:	fe442703          	lw	a4,-28(s0)
  e8:	00100793          	li	a5,1
  ec:	00e7c863          	blt	a5,a4,fc <main+0xd8>
  f0:	fe442783          	lw	a5,-28(s0)
  f4:	fef42023          	sw	a5,-32(s0)
  f8:	0240006f          	j	11c <main+0xf8>
  fc:	fe842703          	lw	a4,-24(s0)
 100:	fec42783          	lw	a5,-20(s0)
 104:	00f707b3          	add	a5,a4,a5
 108:	fef42023          	sw	a5,-32(s0)
 10c:	fec42783          	lw	a5,-20(s0)
 110:	fef42423          	sw	a5,-24(s0)
 114:	fe042783          	lw	a5,-32(s0)
 118:	fef42623          	sw	a5,-20(s0)
 11c:	fd442703          	lw	a4,-44(s0)
 120:	fe442783          	lw	a5,-28(s0)
 124:	00279793          	slli	a5,a5,0x2
 128:	00f707b3          	add	a5,a4,a5
 12c:	fe042703          	lw	a4,-32(s0)
 130:	00e7a023          	sw	a4,0(a5)
 134:	fe442783          	lw	a5,-28(s0)
 138:	00178793          	addi	a5,a5,1
 13c:	fef42223          	sw	a5,-28(s0)
 140:	f99ff06f          	j	d8 <main+0xb4>
 144:	00000793          	li	a5,0
 148:	00050113          	mv	sp,a0
 14c:	00078513          	mv	a0,a5
 150:	fc040113          	addi	sp,s0,-64
 154:	03c12403          	lw	s0,60(sp)
 158:	04010113          	addi	sp,sp,64
 15c:	00008067          	ret
