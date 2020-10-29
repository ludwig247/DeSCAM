
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/analysis_programs/prime.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	008000ef          	jal	ra,c <main>

00000008 <_end>:
   8:	00100073          	ebreak

0000000c <main>:
   c:	fc010113          	addi	sp,sp,-64 # ffc0 <__global_pointer$+0xe534>
  10:	02112e23          	sw	ra,60(sp)
  14:	02812c23          	sw	s0,56(sp)
  18:	02912a23          	sw	s1,52(sp)
  1c:	04010413          	addi	s0,sp,64
  20:	fca42623          	sw	a0,-52(s0)
  24:	fcb42423          	sw	a1,-56(s0)
  28:	00010613          	mv	a2,sp
  2c:	00060493          	mv	s1,a2
  30:	00002637          	lui	a2,0x2
  34:	71060613          	addi	a2,a2,1808 # 2710 <__global_pointer$+0xc84>
  38:	fec42023          	sw	a2,-32(s0)
  3c:	fe042423          	sw	zero,-24(s0)
  40:	00a00613          	li	a2,10
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
  c8:	fe042623          	sw	zero,-20(s0)
  cc:	fe842703          	lw	a4,-24(s0)
  d0:	fdc42783          	lw	a5,-36(s0)
  d4:	08f75e63          	ble	a5,a4,170 <main+0x164>
  d8:	fe042623          	sw	zero,-20(s0)
  dc:	00200793          	li	a5,2
  e0:	fef42223          	sw	a5,-28(s0)
  e4:	fe042783          	lw	a5,-32(s0)
  e8:	01f7d713          	srli	a4,a5,0x1f
  ec:	00f707b3          	add	a5,a4,a5
  f0:	4017d793          	srai	a5,a5,0x1
  f4:	00078713          	mv	a4,a5
  f8:	fe442783          	lw	a5,-28(s0)
  fc:	02f74c63          	blt	a4,a5,134 <main+0x128>
 100:	fe042783          	lw	a5,-32(s0)
 104:	fe442583          	lw	a1,-28(s0)
 108:	00078513          	mv	a0,a5
 10c:	10c000ef          	jal	ra,218 <__modsi3>
 110:	00050793          	mv	a5,a0
 114:	00079863          	bnez	a5,124 <main+0x118>
 118:	00100793          	li	a5,1
 11c:	fef42623          	sw	a5,-20(s0)
 120:	0140006f          	j	134 <main+0x128>
 124:	fe442783          	lw	a5,-28(s0)
 128:	00178793          	addi	a5,a5,1
 12c:	fef42223          	sw	a5,-28(s0)
 130:	fb5ff06f          	j	e4 <main+0xd8>
 134:	fec42783          	lw	a5,-20(s0)
 138:	02079463          	bnez	a5,160 <main+0x154>
 13c:	fd442703          	lw	a4,-44(s0)
 140:	fe842783          	lw	a5,-24(s0)
 144:	00279793          	slli	a5,a5,0x2
 148:	00f707b3          	add	a5,a4,a5
 14c:	fe042703          	lw	a4,-32(s0)
 150:	00e7a023          	sw	a4,0(a5)
 154:	fe842783          	lw	a5,-24(s0)
 158:	00178793          	addi	a5,a5,1
 15c:	fef42423          	sw	a5,-24(s0)
 160:	fe042783          	lw	a5,-32(s0)
 164:	00178793          	addi	a5,a5,1
 168:	fef42023          	sw	a5,-32(s0)
 16c:	f61ff06f          	j	cc <main+0xc0>
 170:	00000793          	li	a5,0
 174:	00048113          	mv	sp,s1
 178:	00078513          	mv	a0,a5
 17c:	fc040113          	addi	sp,s0,-64
 180:	03c12083          	lw	ra,60(sp)
 184:	03812403          	lw	s0,56(sp)
 188:	03412483          	lw	s1,52(sp)
 18c:	04010113          	addi	sp,sp,64
 190:	00008067          	ret

00000194 <__divsi3>:
 194:	06054063          	bltz	a0,1f4 <__umodsi3+0x10>
 198:	0605c663          	bltz	a1,204 <__umodsi3+0x20>

0000019c <__udivsi3>:
 19c:	00058613          	mv	a2,a1
 1a0:	00050593          	mv	a1,a0
 1a4:	fff00513          	li	a0,-1
 1a8:	02060c63          	beqz	a2,1e0 <__udivsi3+0x44>
 1ac:	00100693          	li	a3,1
 1b0:	00b67a63          	bleu	a1,a2,1c4 <__udivsi3+0x28>
 1b4:	00c05863          	blez	a2,1c4 <__udivsi3+0x28>
 1b8:	00161613          	slli	a2,a2,0x1
 1bc:	00169693          	slli	a3,a3,0x1
 1c0:	feb66ae3          	bltu	a2,a1,1b4 <__udivsi3+0x18>
 1c4:	00000513          	li	a0,0
 1c8:	00c5e663          	bltu	a1,a2,1d4 <__udivsi3+0x38>
 1cc:	40c585b3          	sub	a1,a1,a2
 1d0:	00d56533          	or	a0,a0,a3
 1d4:	0016d693          	srli	a3,a3,0x1
 1d8:	00165613          	srli	a2,a2,0x1
 1dc:	fe0696e3          	bnez	a3,1c8 <__udivsi3+0x2c>
 1e0:	00008067          	ret

000001e4 <__umodsi3>:
 1e4:	00008293          	mv	t0,ra
 1e8:	fb5ff0ef          	jal	ra,19c <__udivsi3>
 1ec:	00058513          	mv	a0,a1
 1f0:	00028067          	jr	t0
 1f4:	40a00533          	neg	a0,a0
 1f8:	0005d863          	bgez	a1,208 <__umodsi3+0x24>
 1fc:	40b005b3          	neg	a1,a1
 200:	f9dff06f          	j	19c <__udivsi3>
 204:	40b005b3          	neg	a1,a1
 208:	00008293          	mv	t0,ra
 20c:	f91ff0ef          	jal	ra,19c <__udivsi3>
 210:	40a00533          	neg	a0,a0
 214:	00028067          	jr	t0

00000218 <__modsi3>:
 218:	00008293          	mv	t0,ra
 21c:	0005ca63          	bltz	a1,230 <__modsi3+0x18>
 220:	00054c63          	bltz	a0,238 <__modsi3+0x20>
 224:	f79ff0ef          	jal	ra,19c <__udivsi3>
 228:	00058513          	mv	a0,a1
 22c:	00028067          	jr	t0
 230:	40b005b3          	neg	a1,a1
 234:	fe0558e3          	bgez	a0,224 <__modsi3+0xc>
 238:	40a00533          	neg	a0,a0
 23c:	f61ff0ef          	jal	ra,19c <__udivsi3>
 240:	40b00533          	neg	a0,a1
 244:	00028067          	jr	t0
