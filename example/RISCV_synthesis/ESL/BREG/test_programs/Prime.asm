
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/ESL/BREG/test_programs/Prime.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	008000ef          	jal	ra,c <main>

00000008 <_end>:
   8:	00100073          	ebreak

0000000c <main>:
   c:	fc010113          	addi	sp,sp,-64 # ffc0 <__global_pointer$+0xe4bc>
  10:	02112e23          	sw	ra,60(sp)
  14:	02812c23          	sw	s0,56(sp)
  18:	02912a23          	sw	s1,52(sp)
  1c:	04010413          	addi	s0,sp,64
  20:	fca42623          	sw	a0,-52(s0)
  24:	fcb42423          	sw	a1,-56(s0)
  28:	00010613          	mv	a2,sp
  2c:	00060493          	mv	s1,a2
  30:	00002637          	lui	a2,0x2
  34:	71060613          	addi	a2,a2,1808 # 2710 <__global_pointer$+0xc0c>
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
 10c:	184000ef          	jal	ra,290 <__modsi3>
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
 170:	fd442783          	lw	a5,-44(s0)
 174:	0007a783          	lw	a5,0(a5)
 178:	00078913          	mv	s2,a5
 17c:	fd442783          	lw	a5,-44(s0)
 180:	0047a783          	lw	a5,4(a5)
 184:	00078993          	mv	s3,a5
 188:	fd442783          	lw	a5,-44(s0)
 18c:	0087a783          	lw	a5,8(a5)
 190:	00078a13          	mv	s4,a5
 194:	fd442783          	lw	a5,-44(s0)
 198:	00c7a783          	lw	a5,12(a5)
 19c:	00078a93          	mv	s5,a5
 1a0:	fd442783          	lw	a5,-44(s0)
 1a4:	0107a783          	lw	a5,16(a5)
 1a8:	00078b13          	mv	s6,a5
 1ac:	fd442783          	lw	a5,-44(s0)
 1b0:	0147a783          	lw	a5,20(a5)
 1b4:	00078b93          	mv	s7,a5
 1b8:	fd442783          	lw	a5,-44(s0)
 1bc:	0187a783          	lw	a5,24(a5)
 1c0:	00078c13          	mv	s8,a5
 1c4:	fd442783          	lw	a5,-44(s0)
 1c8:	01c7a783          	lw	a5,28(a5)
 1cc:	00078c93          	mv	s9,a5
 1d0:	fd442783          	lw	a5,-44(s0)
 1d4:	0207a783          	lw	a5,32(a5)
 1d8:	00078d13          	mv	s10,a5
 1dc:	fd442783          	lw	a5,-44(s0)
 1e0:	0247a783          	lw	a5,36(a5)
 1e4:	00078d93          	mv	s11,a5
 1e8:	00000793          	li	a5,0
 1ec:	00048113          	mv	sp,s1
 1f0:	00078513          	mv	a0,a5
 1f4:	fc040113          	addi	sp,s0,-64
 1f8:	03c12083          	lw	ra,60(sp)
 1fc:	03812403          	lw	s0,56(sp)
 200:	03412483          	lw	s1,52(sp)
 204:	04010113          	addi	sp,sp,64
 208:	00008067          	ret

0000020c <__divsi3>:
 20c:	06054063          	bltz	a0,26c <__umodsi3+0x10>
 210:	0605c663          	bltz	a1,27c <__umodsi3+0x20>

00000214 <__udivsi3>:
 214:	00058613          	mv	a2,a1
 218:	00050593          	mv	a1,a0
 21c:	fff00513          	li	a0,-1
 220:	02060c63          	beqz	a2,258 <__udivsi3+0x44>
 224:	00100693          	li	a3,1
 228:	00b67a63          	bleu	a1,a2,23c <__udivsi3+0x28>
 22c:	00c05863          	blez	a2,23c <__udivsi3+0x28>
 230:	00161613          	slli	a2,a2,0x1
 234:	00169693          	slli	a3,a3,0x1
 238:	feb66ae3          	bltu	a2,a1,22c <__udivsi3+0x18>
 23c:	00000513          	li	a0,0
 240:	00c5e663          	bltu	a1,a2,24c <__udivsi3+0x38>
 244:	40c585b3          	sub	a1,a1,a2
 248:	00d56533          	or	a0,a0,a3
 24c:	0016d693          	srli	a3,a3,0x1
 250:	00165613          	srli	a2,a2,0x1
 254:	fe0696e3          	bnez	a3,240 <__udivsi3+0x2c>
 258:	00008067          	ret

0000025c <__umodsi3>:
 25c:	00008293          	mv	t0,ra
 260:	fb5ff0ef          	jal	ra,214 <__udivsi3>
 264:	00058513          	mv	a0,a1
 268:	00028067          	jr	t0
 26c:	40a00533          	neg	a0,a0
 270:	0005d863          	bgez	a1,280 <__umodsi3+0x24>
 274:	40b005b3          	neg	a1,a1
 278:	f9dff06f          	j	214 <__udivsi3>
 27c:	40b005b3          	neg	a1,a1
 280:	00008293          	mv	t0,ra
 284:	f91ff0ef          	jal	ra,214 <__udivsi3>
 288:	40a00533          	neg	a0,a0
 28c:	00028067          	jr	t0

00000290 <__modsi3>:
 290:	00008293          	mv	t0,ra
 294:	0005ca63          	bltz	a1,2a8 <__modsi3+0x18>
 298:	00054c63          	bltz	a0,2b0 <__modsi3+0x20>
 29c:	f79ff0ef          	jal	ra,214 <__udivsi3>
 2a0:	00058513          	mv	a0,a1
 2a4:	00028067          	jr	t0
 2a8:	40b005b3          	neg	a1,a1
 2ac:	fe0558e3          	bgez	a0,29c <__modsi3+0xc>
 2b0:	40a00533          	neg	a0,a0
 2b4:	f61ff0ef          	jal	ra,214 <__udivsi3>
 2b8:	40b00533          	neg	a0,a1
 2bc:	00028067          	jr	t0
