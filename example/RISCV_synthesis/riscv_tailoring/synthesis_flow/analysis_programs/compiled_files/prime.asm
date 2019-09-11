
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/synthesis_flow/analysis_programs/compiled_files/prime.elf:     file format elf32-littleriscv


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
  28:	02112e23          	sw	ra,60(sp)
  2c:	02812c23          	sw	s0,56(sp)
  30:	02912a23          	sw	s1,52(sp)
  34:	04010413          	addi	s0,sp,64
  38:	fca42623          	sw	a0,-52(s0)
  3c:	fcb42423          	sw	a1,-56(s0)
  40:	00010613          	mv	a2,sp
  44:	00060493          	mv	s1,a2
  48:	00f00613          	li	a2,15
  4c:	fec42023          	sw	a2,-32(s0)
  50:	fe042423          	sw	zero,-24(s0)
  54:	00400613          	li	a2,4
  58:	fcc42e23          	sw	a2,-36(s0)
  5c:	fdc42603          	lw	a2,-36(s0)
  60:	fff60613          	addi	a2,a2,-1
  64:	fcc42c23          	sw	a2,-40(s0)
  68:	00060593          	mv	a1,a2
  6c:	00158593          	addi	a1,a1,1
  70:	00058e13          	mv	t3,a1
  74:	00000e93          	li	t4,0
  78:	01be5593          	srli	a1,t3,0x1b
  7c:	005e9713          	slli	a4,t4,0x5
  80:	00e5e733          	or	a4,a1,a4
  84:	005e1693          	slli	a3,t3,0x5
  88:	00060713          	mv	a4,a2
  8c:	00170713          	addi	a4,a4,1
  90:	00070313          	mv	t1,a4
  94:	00000393          	li	t2,0
  98:	01b35713          	srli	a4,t1,0x1b
  9c:	00539813          	slli	a6,t2,0x5
  a0:	01076833          	or	a6,a4,a6
  a4:	00531793          	slli	a5,t1,0x5
  a8:	00060793          	mv	a5,a2
  ac:	00178793          	addi	a5,a5,1
  b0:	00279793          	slli	a5,a5,0x2
  b4:	00378793          	addi	a5,a5,3
  b8:	00f78793          	addi	a5,a5,15
  bc:	0047d793          	srli	a5,a5,0x4
  c0:	00479793          	slli	a5,a5,0x4
  c4:	40f10133          	sub	sp,sp,a5
  c8:	00010793          	mv	a5,sp
  cc:	00378793          	addi	a5,a5,3
  d0:	0027d793          	srli	a5,a5,0x2
  d4:	00279793          	slli	a5,a5,0x2
  d8:	fcf42a23          	sw	a5,-44(s0)
  dc:	fe042623          	sw	zero,-20(s0)
  e0:	fe842703          	lw	a4,-24(s0)
  e4:	fdc42783          	lw	a5,-36(s0)
  e8:	08f75e63          	ble	a5,a4,184 <main+0x160>
  ec:	fe042623          	sw	zero,-20(s0)
  f0:	00200793          	li	a5,2
  f4:	fef42223          	sw	a5,-28(s0)
  f8:	fe042783          	lw	a5,-32(s0)
  fc:	01f7d713          	srli	a4,a5,0x1f
 100:	00f707b3          	add	a5,a4,a5
 104:	4017d793          	srai	a5,a5,0x1
 108:	00078713          	mv	a4,a5
 10c:	fe442783          	lw	a5,-28(s0)
 110:	02f74c63          	blt	a4,a5,148 <main+0x124>
 114:	fe042783          	lw	a5,-32(s0)
 118:	fe442583          	lw	a1,-28(s0)
 11c:	00078513          	mv	a0,a5
 120:	10c000ef          	jal	ra,22c <__modsi3>
 124:	00050793          	mv	a5,a0
 128:	00079863          	bnez	a5,138 <main+0x114>
 12c:	00100793          	li	a5,1
 130:	fef42623          	sw	a5,-20(s0)
 134:	0140006f          	j	148 <main+0x124>
 138:	fe442783          	lw	a5,-28(s0)
 13c:	00178793          	addi	a5,a5,1
 140:	fef42223          	sw	a5,-28(s0)
 144:	fb5ff06f          	j	f8 <main+0xd4>
 148:	fec42783          	lw	a5,-20(s0)
 14c:	02079463          	bnez	a5,174 <main+0x150>
 150:	fd442703          	lw	a4,-44(s0)
 154:	fe842783          	lw	a5,-24(s0)
 158:	00279793          	slli	a5,a5,0x2
 15c:	00f707b3          	add	a5,a4,a5
 160:	fe042703          	lw	a4,-32(s0)
 164:	00e7a023          	sw	a4,0(a5)
 168:	fe842783          	lw	a5,-24(s0)
 16c:	00178793          	addi	a5,a5,1
 170:	fef42423          	sw	a5,-24(s0)
 174:	fe042783          	lw	a5,-32(s0)
 178:	00178793          	addi	a5,a5,1
 17c:	fef42023          	sw	a5,-32(s0)
 180:	f61ff06f          	j	e0 <main+0xbc>
 184:	00000793          	li	a5,0
 188:	00048113          	mv	sp,s1
 18c:	00078513          	mv	a0,a5
 190:	fc040113          	addi	sp,s0,-64
 194:	03c12083          	lw	ra,60(sp)
 198:	03812403          	lw	s0,56(sp)
 19c:	03412483          	lw	s1,52(sp)
 1a0:	04010113          	addi	sp,sp,64
 1a4:	00008067          	ret

000001a8 <__divsi3>:
 1a8:	06054063          	bltz	a0,208 <__umodsi3+0x10>
 1ac:	0605c663          	bltz	a1,218 <__umodsi3+0x20>

000001b0 <__udivsi3>:
 1b0:	00058613          	mv	a2,a1
 1b4:	00050593          	mv	a1,a0
 1b8:	fff00513          	li	a0,-1
 1bc:	02060c63          	beqz	a2,1f4 <__udivsi3+0x44>
 1c0:	00100693          	li	a3,1
 1c4:	00b67a63          	bleu	a1,a2,1d8 <__udivsi3+0x28>
 1c8:	00c05863          	blez	a2,1d8 <__udivsi3+0x28>
 1cc:	00161613          	slli	a2,a2,0x1
 1d0:	00169693          	slli	a3,a3,0x1
 1d4:	feb66ae3          	bltu	a2,a1,1c8 <__udivsi3+0x18>
 1d8:	00000513          	li	a0,0
 1dc:	00c5e663          	bltu	a1,a2,1e8 <__udivsi3+0x38>
 1e0:	40c585b3          	sub	a1,a1,a2
 1e4:	00d56533          	or	a0,a0,a3
 1e8:	0016d693          	srli	a3,a3,0x1
 1ec:	00165613          	srli	a2,a2,0x1
 1f0:	fe0696e3          	bnez	a3,1dc <__udivsi3+0x2c>
 1f4:	00008067          	ret

000001f8 <__umodsi3>:
 1f8:	00008293          	mv	t0,ra
 1fc:	fb5ff0ef          	jal	ra,1b0 <__udivsi3>
 200:	00058513          	mv	a0,a1
 204:	00028067          	jr	t0
 208:	40a00533          	neg	a0,a0
 20c:	0005d863          	bgez	a1,21c <__umodsi3+0x24>
 210:	40b005b3          	neg	a1,a1
 214:	f9dff06f          	j	1b0 <__udivsi3>
 218:	40b005b3          	neg	a1,a1
 21c:	00008293          	mv	t0,ra
 220:	f91ff0ef          	jal	ra,1b0 <__udivsi3>
 224:	40a00533          	neg	a0,a0
 228:	00028067          	jr	t0

0000022c <__modsi3>:
 22c:	00008293          	mv	t0,ra
 230:	0005ca63          	bltz	a1,244 <__modsi3+0x18>
 234:	00054c63          	bltz	a0,24c <__modsi3+0x20>
 238:	f79ff0ef          	jal	ra,1b0 <__udivsi3>
 23c:	00058513          	mv	a0,a1
 240:	00028067          	jr	t0
 244:	40b005b3          	neg	a1,a1
 248:	fe0558e3          	bgez	a0,238 <__modsi3+0xc>
 24c:	40a00533          	neg	a0,a0
 250:	f61ff0ef          	jal	ra,1b0 <__udivsi3>
 254:	40b00533          	neg	a0,a1
 258:	00028067          	jr	t0
