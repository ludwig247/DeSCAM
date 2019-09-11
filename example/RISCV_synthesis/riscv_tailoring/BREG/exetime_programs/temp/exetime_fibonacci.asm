
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/exetime_programs/exetime_fibonacci.elf:     file format elf32-littleriscv


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
  40:	00004637          	lui	a2,0x4
  44:	a9860613          	addi	a2,a2,-1384 # 3a98 <__global_pointer$+0x20f8>
  48:	fcc42e23          	sw	a2,-36(s0)
  4c:	fdc42603          	lw	a2,-36(s0)
  50:	fff60613          	addi	a2,a2,-1
  54:	fcc42c23          	sw	a2,-40(s0)
  58:	00060593          	mv	a1,a2
  5c:	00158593          	addi	a1,a1,1
  60:	00058e13          	mv	t3,a1
  64:	00000e93          	li	t4,0
  68:	01be5593          	srli	a1,t3,0x1b
  6c:	005e9713          	slli	a4,t4,0x5
  70:	00e5e733          	or	a4,a1,a4
  74:	005e1693          	slli	a3,t3,0x5
  78:	00060713          	mv	a4,a2
  7c:	00170713          	addi	a4,a4,1
  80:	00070313          	mv	t1,a4
  84:	00000393          	li	t2,0
  88:	01b35713          	srli	a4,t1,0x1b
  8c:	00539813          	slli	a6,t2,0x5
  90:	01076833          	or	a6,a4,a6
  94:	00531793          	slli	a5,t1,0x5
  98:	00060793          	mv	a5,a2
  9c:	00178793          	addi	a5,a5,1
  a0:	00279793          	slli	a5,a5,0x2
  a4:	00378793          	addi	a5,a5,3
  a8:	00f78793          	addi	a5,a5,15
  ac:	0047d793          	srli	a5,a5,0x4
  b0:	00479793          	slli	a5,a5,0x4
  b4:	40f10133          	sub	sp,sp,a5
  b8:	00010793          	mv	a5,sp
  bc:	00378793          	addi	a5,a5,3
  c0:	0027d793          	srli	a5,a5,0x2
  c4:	00279793          	slli	a5,a5,0x2
  c8:	fcf42a23          	sw	a5,-44(s0)
  cc:	fe042423          	sw	zero,-24(s0)
  d0:	00100793          	li	a5,1
  d4:	fef42623          	sw	a5,-20(s0)
  d8:	fe042223          	sw	zero,-28(s0)
  dc:	fe442703          	lw	a4,-28(s0)
  e0:	fdc42783          	lw	a5,-36(s0)
  e4:	06f75263          	ble	a5,a4,148 <main+0x124>
  e8:	fe442703          	lw	a4,-28(s0)
  ec:	00100793          	li	a5,1
  f0:	00e7c863          	blt	a5,a4,100 <main+0xdc>
  f4:	fe442783          	lw	a5,-28(s0)
  f8:	fef42023          	sw	a5,-32(s0)
  fc:	0240006f          	j	120 <main+0xfc>
 100:	fe842703          	lw	a4,-24(s0)
 104:	fec42783          	lw	a5,-20(s0)
 108:	00f707b3          	add	a5,a4,a5
 10c:	fef42023          	sw	a5,-32(s0)
 110:	fec42783          	lw	a5,-20(s0)
 114:	fef42423          	sw	a5,-24(s0)
 118:	fe042783          	lw	a5,-32(s0)
 11c:	fef42623          	sw	a5,-20(s0)
 120:	fd442703          	lw	a4,-44(s0)
 124:	fe442783          	lw	a5,-28(s0)
 128:	00279793          	slli	a5,a5,0x2
 12c:	00f707b3          	add	a5,a4,a5
 130:	fe042703          	lw	a4,-32(s0)
 134:	00e7a023          	sw	a4,0(a5)
 138:	fe442783          	lw	a5,-28(s0)
 13c:	00178793          	addi	a5,a5,1
 140:	fef42223          	sw	a5,-28(s0)
 144:	f99ff06f          	j	dc <main+0xb8>
 148:	00000793          	li	a5,0
 14c:	00050113          	mv	sp,a0
 150:	00078513          	mv	a0,a5
 154:	fc040113          	addi	sp,s0,-64
 158:	03c12403          	lw	s0,60(sp)
 15c:	04010113          	addi	sp,sp,64
 160:	00008067          	ret
