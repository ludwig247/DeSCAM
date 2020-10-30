
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/exetime_programs/exetime_fft.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	fff10113          	addi	sp,sp,-1 # ffff <_memEnd>
   8:	348000ef          	jal	ra,350 <main>

0000000c <_end>:
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00100073          	ebreak

00000024 <_Z9fft_16bitPiS_>:
  24:	fb010113          	addi	sp,sp,-80
  28:	04112623          	sw	ra,76(sp)
  2c:	04812423          	sw	s0,72(sp)
  30:	04912223          	sw	s1,68(sp)
  34:	05010413          	addi	s0,sp,80
  38:	faa42e23          	sw	a0,-68(s0)
  3c:	fab42c23          	sw	a1,-72(s0)
  40:	00100793          	li	a5,1
  44:	fef42623          	sw	a5,-20(s0)
  48:	00700793          	li	a5,7
  4c:	fef405a3          	sb	a5,-21(s0)
  50:	00100793          	li	a5,1
  54:	fef42223          	sw	a5,-28(s0)
  58:	fe442703          	lw	a4,-28(s0)
  5c:	0ef00793          	li	a5,239
  60:	0ae7c063          	blt	a5,a4,100 <_Z9fft_16bitPiS_+0xdc>
  64:	71800713          	li	a4,1816
  68:	fe442783          	lw	a5,-28(s0)
  6c:	00f707b3          	add	a5,a4,a5
  70:	0007c783          	lbu	a5,0(a5)
  74:	00078713          	mv	a4,a5
  78:	fe442783          	lw	a5,-28(s0)
  7c:	06e7da63          	ble	a4,a5,f0 <_Z9fft_16bitPiS_+0xcc>
  80:	fe442783          	lw	a5,-28(s0)
  84:	00279793          	slli	a5,a5,0x2
  88:	fbc42703          	lw	a4,-68(s0)
  8c:	00f707b3          	add	a5,a4,a5
  90:	0007a783          	lw	a5,0(a5)
  94:	fcf42e23          	sw	a5,-36(s0)
  98:	71800713          	li	a4,1816
  9c:	fe442783          	lw	a5,-28(s0)
  a0:	00f707b3          	add	a5,a4,a5
  a4:	0007c783          	lbu	a5,0(a5)
  a8:	00279793          	slli	a5,a5,0x2
  ac:	fbc42703          	lw	a4,-68(s0)
  b0:	00f70733          	add	a4,a4,a5
  b4:	fe442783          	lw	a5,-28(s0)
  b8:	00279793          	slli	a5,a5,0x2
  bc:	fbc42683          	lw	a3,-68(s0)
  c0:	00f687b3          	add	a5,a3,a5
  c4:	00072703          	lw	a4,0(a4)
  c8:	00e7a023          	sw	a4,0(a5)
  cc:	71800713          	li	a4,1816
  d0:	fe442783          	lw	a5,-28(s0)
  d4:	00f707b3          	add	a5,a4,a5
  d8:	0007c783          	lbu	a5,0(a5)
  dc:	00279793          	slli	a5,a5,0x2
  e0:	fbc42703          	lw	a4,-68(s0)
  e4:	00f707b3          	add	a5,a4,a5
  e8:	fdc42703          	lw	a4,-36(s0)
  ec:	00e7a023          	sw	a4,0(a5)
  f0:	fe442783          	lw	a5,-28(s0)
  f4:	00178793          	addi	a5,a5,1
  f8:	fef42223          	sw	a5,-28(s0)
  fc:	f5dff06f          	j	58 <_Z9fft_16bitPiS_+0x34>
 100:	fec42703          	lw	a4,-20(s0)
 104:	0ff00793          	li	a5,255
 108:	22e7c863          	blt	a5,a4,338 <_Z9fft_16bitPiS_+0x314>
 10c:	fec42783          	lw	a5,-20(s0)
 110:	00179793          	slli	a5,a5,0x1
 114:	fcf42c23          	sw	a5,-40(s0)
 118:	fe042023          	sw	zero,-32(s0)
 11c:	fe042703          	lw	a4,-32(s0)
 120:	fec42783          	lw	a5,-20(s0)
 124:	1ef75e63          	ble	a5,a4,320 <_Z9fft_16bitPiS_+0x2fc>
 128:	feb44783          	lbu	a5,-21(s0)
 12c:	fe042703          	lw	a4,-32(s0)
 130:	00f717b3          	sll	a5,a4,a5
 134:	fcf42a23          	sw	a5,-44(s0)
 138:	fd442783          	lw	a5,-44(s0)
 13c:	04078713          	addi	a4,a5,64
 140:	00271713          	slli	a4,a4,0x2
 144:	41800793          	li	a5,1048
 148:	00f707b3          	add	a5,a4,a5
 14c:	0007a783          	lw	a5,0(a5)
 150:	fcf42823          	sw	a5,-48(s0)
 154:	fd442703          	lw	a4,-44(s0)
 158:	00271713          	slli	a4,a4,0x2
 15c:	41800793          	li	a5,1048
 160:	00f707b3          	add	a5,a4,a5
 164:	0007a783          	lw	a5,0(a5)
 168:	40f007b3          	neg	a5,a5
 16c:	fcf42623          	sw	a5,-52(s0)
 170:	fe042783          	lw	a5,-32(s0)
 174:	fef42223          	sw	a5,-28(s0)
 178:	fe442703          	lw	a4,-28(s0)
 17c:	0ff00793          	li	a5,255
 180:	18e7c863          	blt	a5,a4,310 <_Z9fft_16bitPiS_+0x2ec>
 184:	fe442703          	lw	a4,-28(s0)
 188:	fec42783          	lw	a5,-20(s0)
 18c:	00f707b3          	add	a5,a4,a5
 190:	fcf42a23          	sw	a5,-44(s0)
 194:	fd442783          	lw	a5,-44(s0)
 198:	00279793          	slli	a5,a5,0x2
 19c:	fbc42703          	lw	a4,-68(s0)
 1a0:	00f707b3          	add	a5,a4,a5
 1a4:	0007a783          	lw	a5,0(a5)
 1a8:	fd042583          	lw	a1,-48(s0)
 1ac:	00078513          	mv	a0,a5
 1b0:	244000ef          	jal	ra,3f4 <__mulsi3>
 1b4:	00050793          	mv	a5,a0
 1b8:	4107d493          	srai	s1,a5,0x10
 1bc:	fd442783          	lw	a5,-44(s0)
 1c0:	00279793          	slli	a5,a5,0x2
 1c4:	fb842703          	lw	a4,-72(s0)
 1c8:	00f707b3          	add	a5,a4,a5
 1cc:	0007a783          	lw	a5,0(a5)
 1d0:	fcc42583          	lw	a1,-52(s0)
 1d4:	00078513          	mv	a0,a5
 1d8:	21c000ef          	jal	ra,3f4 <__mulsi3>
 1dc:	00050793          	mv	a5,a0
 1e0:	4107d793          	srai	a5,a5,0x10
 1e4:	40f487b3          	sub	a5,s1,a5
 1e8:	fcf42e23          	sw	a5,-36(s0)
 1ec:	fd442783          	lw	a5,-44(s0)
 1f0:	00279793          	slli	a5,a5,0x2
 1f4:	fb842703          	lw	a4,-72(s0)
 1f8:	00f707b3          	add	a5,a4,a5
 1fc:	0007a783          	lw	a5,0(a5)
 200:	fd042583          	lw	a1,-48(s0)
 204:	00078513          	mv	a0,a5
 208:	1ec000ef          	jal	ra,3f4 <__mulsi3>
 20c:	00050793          	mv	a5,a0
 210:	4107d493          	srai	s1,a5,0x10
 214:	fd442783          	lw	a5,-44(s0)
 218:	00279793          	slli	a5,a5,0x2
 21c:	fbc42703          	lw	a4,-68(s0)
 220:	00f707b3          	add	a5,a4,a5
 224:	0007a783          	lw	a5,0(a5)
 228:	fcc42583          	lw	a1,-52(s0)
 22c:	00078513          	mv	a0,a5
 230:	1c4000ef          	jal	ra,3f4 <__mulsi3>
 234:	00050793          	mv	a5,a0
 238:	4107d793          	srai	a5,a5,0x10
 23c:	00f487b3          	add	a5,s1,a5
 240:	fcf42423          	sw	a5,-56(s0)
 244:	fe442783          	lw	a5,-28(s0)
 248:	00279793          	slli	a5,a5,0x2
 24c:	fbc42703          	lw	a4,-68(s0)
 250:	00f707b3          	add	a5,a4,a5
 254:	0007a783          	lw	a5,0(a5)
 258:	4017d793          	srai	a5,a5,0x1
 25c:	fcf42223          	sw	a5,-60(s0)
 260:	fe442783          	lw	a5,-28(s0)
 264:	00279793          	slli	a5,a5,0x2
 268:	fb842703          	lw	a4,-72(s0)
 26c:	00f707b3          	add	a5,a4,a5
 270:	0007a783          	lw	a5,0(a5)
 274:	4017d793          	srai	a5,a5,0x1
 278:	fcf42023          	sw	a5,-64(s0)
 27c:	fd442783          	lw	a5,-44(s0)
 280:	00279793          	slli	a5,a5,0x2
 284:	fbc42703          	lw	a4,-68(s0)
 288:	00f707b3          	add	a5,a4,a5
 28c:	fc442683          	lw	a3,-60(s0)
 290:	fdc42703          	lw	a4,-36(s0)
 294:	40e68733          	sub	a4,a3,a4
 298:	00e7a023          	sw	a4,0(a5)
 29c:	fd442783          	lw	a5,-44(s0)
 2a0:	00279793          	slli	a5,a5,0x2
 2a4:	fb842703          	lw	a4,-72(s0)
 2a8:	00f707b3          	add	a5,a4,a5
 2ac:	fc042683          	lw	a3,-64(s0)
 2b0:	fc842703          	lw	a4,-56(s0)
 2b4:	40e68733          	sub	a4,a3,a4
 2b8:	00e7a023          	sw	a4,0(a5)
 2bc:	fe442783          	lw	a5,-28(s0)
 2c0:	00279793          	slli	a5,a5,0x2
 2c4:	fbc42703          	lw	a4,-68(s0)
 2c8:	00f707b3          	add	a5,a4,a5
 2cc:	fc442683          	lw	a3,-60(s0)
 2d0:	fdc42703          	lw	a4,-36(s0)
 2d4:	00e68733          	add	a4,a3,a4
 2d8:	00e7a023          	sw	a4,0(a5)
 2dc:	fe442783          	lw	a5,-28(s0)
 2e0:	00279793          	slli	a5,a5,0x2
 2e4:	fb842703          	lw	a4,-72(s0)
 2e8:	00f707b3          	add	a5,a4,a5
 2ec:	fc042683          	lw	a3,-64(s0)
 2f0:	fc842703          	lw	a4,-56(s0)
 2f4:	00e68733          	add	a4,a3,a4
 2f8:	00e7a023          	sw	a4,0(a5)
 2fc:	fe442703          	lw	a4,-28(s0)
 300:	fd842783          	lw	a5,-40(s0)
 304:	00f707b3          	add	a5,a4,a5
 308:	fef42223          	sw	a5,-28(s0)
 30c:	e6dff06f          	j	178 <_Z9fft_16bitPiS_+0x154>
 310:	fe042783          	lw	a5,-32(s0)
 314:	00178793          	addi	a5,a5,1
 318:	fef42023          	sw	a5,-32(s0)
 31c:	e01ff06f          	j	11c <_Z9fft_16bitPiS_+0xf8>
 320:	feb44783          	lbu	a5,-21(s0)
 324:	fff78793          	addi	a5,a5,-1
 328:	fef405a3          	sb	a5,-21(s0)
 32c:	fd842783          	lw	a5,-40(s0)
 330:	fef42623          	sw	a5,-20(s0)
 334:	dcdff06f          	j	100 <_Z9fft_16bitPiS_+0xdc>
 338:	00000013          	nop
 33c:	04c12083          	lw	ra,76(sp)
 340:	04812403          	lw	s0,72(sp)
 344:	04412483          	lw	s1,68(sp)
 348:	05010113          	addi	sp,sp,80
 34c:	00008067          	ret

00000350 <main>:
 350:	fd010113          	addi	sp,sp,-48
 354:	02112623          	sw	ra,44(sp)
 358:	02812423          	sw	s0,40(sp)
 35c:	03010413          	addi	s0,sp,48
 360:	fca42e23          	sw	a0,-36(s0)
 364:	fcb42c23          	sw	a1,-40(s0)
 368:	fe042623          	sw	zero,-20(s0)
 36c:	fec42703          	lw	a4,-20(s0)
 370:	2ed00793          	li	a5,749
 374:	04e7ca63          	blt	a5,a4,3c8 <main+0x78>
 378:	000017b7          	lui	a5,0x1
 37c:	fec42703          	lw	a4,-20(s0)
 380:	00271713          	slli	a4,a4,0x2
 384:	00078793          	mv	a5,a5
 388:	00f707b3          	add	a5,a4,a5
 38c:	fec42703          	lw	a4,-20(s0)
 390:	00e7a023          	sw	a4,0(a5) # 1000 <inputRE>
 394:	5db00713          	li	a4,1499
 398:	fec42783          	lw	a5,-20(s0)
 39c:	40f70733          	sub	a4,a4,a5
 3a0:	000017b7          	lui	a5,0x1
 3a4:	00271713          	slli	a4,a4,0x2
 3a8:	00078793          	mv	a5,a5
 3ac:	00f707b3          	add	a5,a4,a5
 3b0:	fec42703          	lw	a4,-20(s0)
 3b4:	00e7a023          	sw	a4,0(a5) # 1000 <inputRE>
 3b8:	fec42783          	lw	a5,-20(s0)
 3bc:	00178793          	addi	a5,a5,1
 3c0:	fef42623          	sw	a5,-20(s0)
 3c4:	fa9ff06f          	j	36c <main+0x1c>
 3c8:	000027b7          	lui	a5,0x2
 3cc:	77078593          	addi	a1,a5,1904 # 2770 <inputIM>
 3d0:	000017b7          	lui	a5,0x1
 3d4:	00078513          	mv	a0,a5
 3d8:	c4dff0ef          	jal	ra,24 <_Z9fft_16bitPiS_>
 3dc:	00000793          	li	a5,0
 3e0:	00078513          	mv	a0,a5
 3e4:	02c12083          	lw	ra,44(sp)
 3e8:	02812403          	lw	s0,40(sp)
 3ec:	03010113          	addi	sp,sp,48
 3f0:	00008067          	ret

000003f4 <__mulsi3>:
 3f4:	00050613          	mv	a2,a0
 3f8:	00000513          	li	a0,0
 3fc:	0015f693          	andi	a3,a1,1
 400:	00068463          	beqz	a3,408 <__mulsi3+0x14>
 404:	00c50533          	add	a0,a0,a2
 408:	0015d593          	srli	a1,a1,0x1
 40c:	00161613          	slli	a2,a2,0x1
 410:	fe0596e3          	bnez	a1,3fc <__mulsi3+0x8>
 414:	00008067          	ret
