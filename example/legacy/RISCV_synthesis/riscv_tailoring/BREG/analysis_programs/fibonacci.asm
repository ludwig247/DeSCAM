
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/analysis_programs/fibonacci.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	008000ef          	jal	ra,c <main>

00000008 <_end>:
   8:	00100073          	ebreak

0000000c <main>:
   c:	fc010113          	addi	sp,sp,-64 # ffc0 <__global_pointer$+0xe638>
  10:	02812e23          	sw	s0,60(sp)
  14:	04010413          	addi	s0,sp,64
  18:	fca42623          	sw	a0,-52(s0)
  1c:	fcb42423          	sw	a1,-56(s0)
  20:	00010613          	mv	a2,sp
  24:	00060513          	mv	a0,a2
  28:	00004637          	lui	a2,0x4
  2c:	a9860613          	addi	a2,a2,-1384 # 3a98 <__global_pointer$+0x2110>
  30:	fcc42e23          	sw	a2,-36(s0)
  34:	fdc42603          	lw	a2,-36(s0)
  38:	fff60613          	addi	a2,a2,-1
  3c:	fcc42c23          	sw	a2,-40(s0)
  40:	00060593          	mv	a1,a2
  44:	00158593          	addi	a1,a1,1
  48:	00058e13          	mv	t3,a1
  4c:	00000e93          	li	t4,0
  50:	01be5593          	srli	a1,t3,0x1b
  54:	005e9713          	slli	a4,t4,0x5
  58:	00e5e733          	or	a4,a1,a4
  5c:	005e1693          	slli	a3,t3,0x5
  60:	00060713          	mv	a4,a2
  64:	00170713          	addi	a4,a4,1
  68:	00070313          	mv	t1,a4
  6c:	00000393          	li	t2,0
  70:	01b35713          	srli	a4,t1,0x1b
  74:	00539813          	slli	a6,t2,0x5
  78:	01076833          	or	a6,a4,a6
  7c:	00531793          	slli	a5,t1,0x5
  80:	00060793          	mv	a5,a2
  84:	00178793          	addi	a5,a5,1
  88:	00279793          	slli	a5,a5,0x2
  8c:	00378793          	addi	a5,a5,3
  90:	00f78793          	addi	a5,a5,15
  94:	0047d793          	srli	a5,a5,0x4
  98:	00479793          	slli	a5,a5,0x4
  9c:	40f10133          	sub	sp,sp,a5
  a0:	00010793          	mv	a5,sp
  a4:	00378793          	addi	a5,a5,3
  a8:	0027d793          	srli	a5,a5,0x2
  ac:	00279793          	slli	a5,a5,0x2
  b0:	fcf42a23          	sw	a5,-44(s0)
  b4:	fe042423          	sw	zero,-24(s0)
  b8:	00100793          	li	a5,1
  bc:	fef42623          	sw	a5,-20(s0)
  c0:	fe042223          	sw	zero,-28(s0)
  c4:	fe442703          	lw	a4,-28(s0)
  c8:	fdc42783          	lw	a5,-36(s0)
  cc:	06f75263          	ble	a5,a4,130 <main+0x124>
  d0:	fe442703          	lw	a4,-28(s0)
  d4:	00100793          	li	a5,1
  d8:	00e7c863          	blt	a5,a4,e8 <main+0xdc>
  dc:	fe442783          	lw	a5,-28(s0)
  e0:	fef42023          	sw	a5,-32(s0)
  e4:	0240006f          	j	108 <main+0xfc>
  e8:	fe842703          	lw	a4,-24(s0)
  ec:	fec42783          	lw	a5,-20(s0)
  f0:	00f707b3          	add	a5,a4,a5
  f4:	fef42023          	sw	a5,-32(s0)
  f8:	fec42783          	lw	a5,-20(s0)
  fc:	fef42423          	sw	a5,-24(s0)
 100:	fe042783          	lw	a5,-32(s0)
 104:	fef42623          	sw	a5,-20(s0)
 108:	fd442703          	lw	a4,-44(s0)
 10c:	fe442783          	lw	a5,-28(s0)
 110:	00279793          	slli	a5,a5,0x2
 114:	00f707b3          	add	a5,a4,a5
 118:	fe042703          	lw	a4,-32(s0)
 11c:	00e7a023          	sw	a4,0(a5)
 120:	fe442783          	lw	a5,-28(s0)
 124:	00178793          	addi	a5,a5,1
 128:	fef42223          	sw	a5,-28(s0)
 12c:	f99ff06f          	j	c4 <main+0xb8>
 130:	00000793          	li	a5,0
 134:	00050113          	mv	sp,a0
 138:	00078513          	mv	a0,a5
 13c:	fc040113          	addi	sp,s0,-64
 140:	03c12403          	lw	s0,60(sp)
 144:	04010113          	addi	sp,sp,64
 148:	00008067          	ret
