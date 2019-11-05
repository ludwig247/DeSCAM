
main.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	490000ef          	jal	ra,490 <main>

00000004 <_end>:
   4:	0000006f          	j	4 <_end>

00000008 <initialize>:
   8:	ff010113          	addi	sp,sp,-16
   c:	00812623          	sw	s0,12(sp)
  10:	01010413          	addi	s0,sp,16
  14:	00002797          	auipc	a5,0x2
  18:	b987a783          	lw	a5,-1128(a5) # 1bac <_GLOBAL_OFFSET_TABLE_+0xc>
  1c:	19000713          	li	a4,400
  20:	00e7a023          	sw	a4,0(a5)
  24:	00002797          	auipc	a5,0x2
  28:	b887a783          	lw	a5,-1144(a5) # 1bac <_GLOBAL_OFFSET_TABLE_+0xc>
  2c:	1f400713          	li	a4,500
  30:	00e7a223          	sw	a4,4(a5)
  34:	00002797          	auipc	a5,0x2
  38:	b787a783          	lw	a5,-1160(a5) # 1bac <_GLOBAL_OFFSET_TABLE_+0xc>
  3c:	28000713          	li	a4,640
  40:	00e7a423          	sw	a4,8(a5)
  44:	00002797          	auipc	a5,0x2
  48:	b687a783          	lw	a5,-1176(a5) # 1bac <_GLOBAL_OFFSET_TABLE_+0xc>
  4c:	2e400713          	li	a4,740
  50:	00e7a623          	sw	a4,12(a5)
  54:	00000013          	nop
  58:	00c12403          	lw	s0,12(sp)
  5c:	01010113          	addi	sp,sp,16
  60:	00008067          	ret

00000064 <ALIM>:
  64:	ff010113          	addi	sp,sp,-16
  68:	00812623          	sw	s0,12(sp)
  6c:	01010413          	addi	s0,sp,16
  70:	00002797          	auipc	a5,0x2
  74:	b487a783          	lw	a5,-1208(a5) # 1bb8 <_GLOBAL_OFFSET_TABLE_+0x18>
  78:	0007a783          	lw	a5,0(a5)
  7c:	00002717          	auipc	a4,0x2
  80:	b3072703          	lw	a4,-1232(a4) # 1bac <_GLOBAL_OFFSET_TABLE_+0xc>
  84:	00279793          	slli	a5,a5,0x2
  88:	00f707b3          	add	a5,a4,a5
  8c:	0007a783          	lw	a5,0(a5)
  90:	00078513          	mv	a0,a5
  94:	00c12403          	lw	s0,12(sp)
  98:	01010113          	addi	sp,sp,16
  9c:	00008067          	ret

000000a0 <Inhibit_Biased_Climb>:
  a0:	ff010113          	addi	sp,sp,-16
  a4:	00812623          	sw	s0,12(sp)
  a8:	01010413          	addi	s0,sp,16
  ac:	00002797          	auipc	a5,0x2
  b0:	b247a783          	lw	a5,-1244(a5) # 1bd0 <_GLOBAL_OFFSET_TABLE_+0x30>
  b4:	0007a783          	lw	a5,0(a5)
  b8:	00078c63          	beqz	a5,d0 <Inhibit_Biased_Climb+0x30>
  bc:	00002797          	auipc	a5,0x2
  c0:	b0c7a783          	lw	a5,-1268(a5) # 1bc8 <_GLOBAL_OFFSET_TABLE_+0x28>
  c4:	0007a783          	lw	a5,0(a5)
  c8:	06478793          	addi	a5,a5,100
  cc:	0100006f          	j	dc <Inhibit_Biased_Climb+0x3c>
  d0:	00002797          	auipc	a5,0x2
  d4:	af87a783          	lw	a5,-1288(a5) # 1bc8 <_GLOBAL_OFFSET_TABLE_+0x28>
  d8:	0007a783          	lw	a5,0(a5)
  dc:	00078513          	mv	a0,a5
  e0:	00c12403          	lw	s0,12(sp)
  e4:	01010113          	addi	sp,sp,16
  e8:	00008067          	ret

000000ec <Non_Crossing_Biased_Climb>:
  ec:	fe010113          	addi	sp,sp,-32
  f0:	00112e23          	sw	ra,28(sp)
  f4:	00812c23          	sw	s0,24(sp)
  f8:	02010413          	addi	s0,sp,32
  fc:	fa5ff0ef          	jal	ra,a0 <Inhibit_Biased_Climb>
 100:	00050713          	mv	a4,a0
 104:	00002797          	auipc	a5,0x2
 108:	aac7a783          	lw	a5,-1364(a5) # 1bb0 <_GLOBAL_OFFSET_TABLE_+0x10>
 10c:	0007a783          	lw	a5,0(a5)
 110:	00e7a7b3          	slt	a5,a5,a4
 114:	0ff7f793          	andi	a5,a5,255
 118:	fef42423          	sw	a5,-24(s0)
 11c:	fe842783          	lw	a5,-24(s0)
 120:	04078463          	beqz	a5,168 <Non_Crossing_Biased_Climb+0x7c>
 124:	180000ef          	jal	ra,2a4 <Own_Below_Threat>
 128:	00050793          	mv	a5,a0
 12c:	02078463          	beqz	a5,154 <Non_Crossing_Biased_Climb+0x68>
 130:	174000ef          	jal	ra,2a4 <Own_Below_Threat>
 134:	00050793          	mv	a5,a0
 138:	02078263          	beqz	a5,15c <Non_Crossing_Biased_Climb+0x70>
 13c:	f29ff0ef          	jal	ra,64 <ALIM>
 140:	00050713          	mv	a4,a0
 144:	00002797          	auipc	a5,0x2
 148:	a6c7a783          	lw	a5,-1428(a5) # 1bb0 <_GLOBAL_OFFSET_TABLE_+0x10>
 14c:	0007a783          	lw	a5,0(a5)
 150:	00e7d663          	ble	a4,a5,15c <Non_Crossing_Biased_Climb+0x70>
 154:	00100793          	li	a5,1
 158:	0080006f          	j	160 <Non_Crossing_Biased_Climb+0x74>
 15c:	00000793          	li	a5,0
 160:	fef42623          	sw	a5,-20(s0)
 164:	04c0006f          	j	1b0 <Non_Crossing_Biased_Climb+0xc4>
 168:	178000ef          	jal	ra,2e0 <Own_Above_Threat>
 16c:	00050793          	mv	a5,a0
 170:	02078c63          	beqz	a5,1a8 <Non_Crossing_Biased_Climb+0xbc>
 174:	00002797          	auipc	a5,0x2
 178:	a487a783          	lw	a5,-1464(a5) # 1bbc <_GLOBAL_OFFSET_TABLE_+0x1c>
 17c:	0007a703          	lw	a4,0(a5)
 180:	12b00793          	li	a5,299
 184:	02e7d263          	ble	a4,a5,1a8 <Non_Crossing_Biased_Climb+0xbc>
 188:	eddff0ef          	jal	ra,64 <ALIM>
 18c:	00050713          	mv	a4,a0
 190:	00002797          	auipc	a5,0x2
 194:	a387a783          	lw	a5,-1480(a5) # 1bc8 <_GLOBAL_OFFSET_TABLE_+0x28>
 198:	0007a783          	lw	a5,0(a5)
 19c:	00e7c663          	blt	a5,a4,1a8 <Non_Crossing_Biased_Climb+0xbc>
 1a0:	00100793          	li	a5,1
 1a4:	0080006f          	j	1ac <Non_Crossing_Biased_Climb+0xc0>
 1a8:	00000793          	li	a5,0
 1ac:	fef42623          	sw	a5,-20(s0)
 1b0:	fec42783          	lw	a5,-20(s0)
 1b4:	00078513          	mv	a0,a5
 1b8:	01c12083          	lw	ra,28(sp)
 1bc:	01812403          	lw	s0,24(sp)
 1c0:	02010113          	addi	sp,sp,32
 1c4:	00008067          	ret

000001c8 <Non_Crossing_Biased_Descend>:
 1c8:	fe010113          	addi	sp,sp,-32
 1cc:	00112e23          	sw	ra,28(sp)
 1d0:	00812c23          	sw	s0,24(sp)
 1d4:	02010413          	addi	s0,sp,32
 1d8:	ec9ff0ef          	jal	ra,a0 <Inhibit_Biased_Climb>
 1dc:	00050713          	mv	a4,a0
 1e0:	00002797          	auipc	a5,0x2
 1e4:	9d07a783          	lw	a5,-1584(a5) # 1bb0 <_GLOBAL_OFFSET_TABLE_+0x10>
 1e8:	0007a783          	lw	a5,0(a5)
 1ec:	00e7a7b3          	slt	a5,a5,a4
 1f0:	0ff7f793          	andi	a5,a5,255
 1f4:	fef42423          	sw	a5,-24(s0)
 1f8:	fe842783          	lw	a5,-24(s0)
 1fc:	04078863          	beqz	a5,24c <Non_Crossing_Biased_Descend+0x84>
 200:	0a4000ef          	jal	ra,2a4 <Own_Below_Threat>
 204:	00050793          	mv	a5,a0
 208:	02078c63          	beqz	a5,240 <Non_Crossing_Biased_Descend+0x78>
 20c:	00002797          	auipc	a5,0x2
 210:	9b07a783          	lw	a5,-1616(a5) # 1bbc <_GLOBAL_OFFSET_TABLE_+0x1c>
 214:	0007a703          	lw	a4,0(a5)
 218:	12b00793          	li	a5,299
 21c:	02e7d263          	ble	a4,a5,240 <Non_Crossing_Biased_Descend+0x78>
 220:	e45ff0ef          	jal	ra,64 <ALIM>
 224:	00050713          	mv	a4,a0
 228:	00002797          	auipc	a5,0x2
 22c:	9887a783          	lw	a5,-1656(a5) # 1bb0 <_GLOBAL_OFFSET_TABLE_+0x10>
 230:	0007a783          	lw	a5,0(a5)
 234:	00e7c663          	blt	a5,a4,240 <Non_Crossing_Biased_Descend+0x78>
 238:	00100793          	li	a5,1
 23c:	0080006f          	j	244 <Non_Crossing_Biased_Descend+0x7c>
 240:	00000793          	li	a5,0
 244:	fef42623          	sw	a5,-20(s0)
 248:	0440006f          	j	28c <Non_Crossing_Biased_Descend+0xc4>
 24c:	094000ef          	jal	ra,2e0 <Own_Above_Threat>
 250:	00050793          	mv	a5,a0
 254:	02078463          	beqz	a5,27c <Non_Crossing_Biased_Descend+0xb4>
 258:	088000ef          	jal	ra,2e0 <Own_Above_Threat>
 25c:	00050793          	mv	a5,a0
 260:	02078263          	beqz	a5,284 <Non_Crossing_Biased_Descend+0xbc>
 264:	e01ff0ef          	jal	ra,64 <ALIM>
 268:	00050713          	mv	a4,a0
 26c:	00002797          	auipc	a5,0x2
 270:	95c7a783          	lw	a5,-1700(a5) # 1bc8 <_GLOBAL_OFFSET_TABLE_+0x28>
 274:	0007a783          	lw	a5,0(a5)
 278:	00e7c663          	blt	a5,a4,284 <Non_Crossing_Biased_Descend+0xbc>
 27c:	00100793          	li	a5,1
 280:	0080006f          	j	288 <Non_Crossing_Biased_Descend+0xc0>
 284:	00000793          	li	a5,0
 288:	fef42623          	sw	a5,-20(s0)
 28c:	fec42783          	lw	a5,-20(s0)
 290:	00078513          	mv	a0,a5
 294:	01c12083          	lw	ra,28(sp)
 298:	01812403          	lw	s0,24(sp)
 29c:	02010113          	addi	sp,sp,32
 2a0:	00008067          	ret

000002a4 <Own_Below_Threat>:
 2a4:	ff010113          	addi	sp,sp,-16
 2a8:	00812623          	sw	s0,12(sp)
 2ac:	01010413          	addi	s0,sp,16
 2b0:	00002797          	auipc	a5,0x2
 2b4:	91c7a783          	lw	a5,-1764(a5) # 1bcc <_GLOBAL_OFFSET_TABLE_+0x2c>
 2b8:	0007a703          	lw	a4,0(a5)
 2bc:	00002797          	auipc	a5,0x2
 2c0:	9087a783          	lw	a5,-1784(a5) # 1bc4 <_GLOBAL_OFFSET_TABLE_+0x24>
 2c4:	0007a783          	lw	a5,0(a5)
 2c8:	00f727b3          	slt	a5,a4,a5
 2cc:	0ff7f793          	andi	a5,a5,255
 2d0:	00078513          	mv	a0,a5
 2d4:	00c12403          	lw	s0,12(sp)
 2d8:	01010113          	addi	sp,sp,16
 2dc:	00008067          	ret

000002e0 <Own_Above_Threat>:
 2e0:	ff010113          	addi	sp,sp,-16
 2e4:	00812623          	sw	s0,12(sp)
 2e8:	01010413          	addi	s0,sp,16
 2ec:	00002797          	auipc	a5,0x2
 2f0:	8d87a783          	lw	a5,-1832(a5) # 1bc4 <_GLOBAL_OFFSET_TABLE_+0x24>
 2f4:	0007a703          	lw	a4,0(a5)
 2f8:	00002797          	auipc	a5,0x2
 2fc:	8d47a783          	lw	a5,-1836(a5) # 1bcc <_GLOBAL_OFFSET_TABLE_+0x2c>
 300:	0007a783          	lw	a5,0(a5)
 304:	00f727b3          	slt	a5,a4,a5
 308:	0ff7f793          	andi	a5,a5,255
 30c:	00078513          	mv	a0,a5
 310:	00c12403          	lw	s0,12(sp)
 314:	01010113          	addi	sp,sp,16
 318:	00008067          	ret

0000031c <alt_sep_test>:
 31c:	fd010113          	addi	sp,sp,-48
 320:	02112623          	sw	ra,44(sp)
 324:	02812423          	sw	s0,40(sp)
 328:	03010413          	addi	s0,sp,48
 32c:	00002797          	auipc	a5,0x2
 330:	87c7a783          	lw	a5,-1924(a5) # 1ba8 <_GLOBAL_OFFSET_TABLE_+0x8>
 334:	0007a783          	lw	a5,0(a5)
 338:	02078a63          	beqz	a5,36c <alt_sep_test+0x50>
 33c:	00002797          	auipc	a5,0x2
 340:	8847a783          	lw	a5,-1916(a5) # 1bc0 <_GLOBAL_OFFSET_TABLE_+0x20>
 344:	0007a703          	lw	a4,0(a5)
 348:	25800793          	li	a5,600
 34c:	02e7c063          	blt	a5,a4,36c <alt_sep_test+0x50>
 350:	00002797          	auipc	a5,0x2
 354:	86c7a783          	lw	a5,-1940(a5) # 1bbc <_GLOBAL_OFFSET_TABLE_+0x1c>
 358:	0007a703          	lw	a4,0(a5)
 35c:	25800793          	li	a5,600
 360:	00e7d663          	ble	a4,a5,36c <alt_sep_test+0x50>
 364:	00100793          	li	a5,1
 368:	0080006f          	j	370 <alt_sep_test+0x54>
 36c:	00000793          	li	a5,0
 370:	fef42423          	sw	a5,-24(s0)
 374:	00002797          	auipc	a5,0x2
 378:	8407a783          	lw	a5,-1984(a5) # 1bb4 <_GLOBAL_OFFSET_TABLE_+0x14>
 37c:	0007a783          	lw	a5,0(a5)
 380:	fff78793          	addi	a5,a5,-1
 384:	0017b793          	seqz	a5,a5
 388:	0ff7f793          	andi	a5,a5,255
 38c:	fef42223          	sw	a5,-28(s0)
 390:	00002797          	auipc	a5,0x2
 394:	8147a783          	lw	a5,-2028(a5) # 1ba4 <_GLOBAL_OFFSET_TABLE_+0x4>
 398:	0007a783          	lw	a5,0(a5)
 39c:	00078e63          	beqz	a5,3b8 <alt_sep_test+0x9c>
 3a0:	00002797          	auipc	a5,0x2
 3a4:	8347a783          	lw	a5,-1996(a5) # 1bd4 <_GLOBAL_OFFSET_TABLE_+0x34>
 3a8:	0007a783          	lw	a5,0(a5)
 3ac:	00079663          	bnez	a5,3b8 <alt_sep_test+0x9c>
 3b0:	00100793          	li	a5,1
 3b4:	0080006f          	j	3bc <alt_sep_test+0xa0>
 3b8:	00000793          	li	a5,0
 3bc:	fef42023          	sw	a5,-32(s0)
 3c0:	fe042623          	sw	zero,-20(s0)
 3c4:	fe842783          	lw	a5,-24(s0)
 3c8:	0a078863          	beqz	a5,478 <alt_sep_test+0x15c>
 3cc:	fe442783          	lw	a5,-28(s0)
 3d0:	00078663          	beqz	a5,3dc <alt_sep_test+0xc0>
 3d4:	fe042783          	lw	a5,-32(s0)
 3d8:	00079663          	bnez	a5,3e4 <alt_sep_test+0xc8>
 3dc:	fe442783          	lw	a5,-28(s0)
 3e0:	08079c63          	bnez	a5,478 <alt_sep_test+0x15c>
 3e4:	d09ff0ef          	jal	ra,ec <Non_Crossing_Biased_Climb>
 3e8:	00050793          	mv	a5,a0
 3ec:	00078c63          	beqz	a5,404 <alt_sep_test+0xe8>
 3f0:	eb5ff0ef          	jal	ra,2a4 <Own_Below_Threat>
 3f4:	00050793          	mv	a5,a0
 3f8:	00078663          	beqz	a5,404 <alt_sep_test+0xe8>
 3fc:	00100793          	li	a5,1
 400:	0080006f          	j	408 <alt_sep_test+0xec>
 404:	00000793          	li	a5,0
 408:	fcf42e23          	sw	a5,-36(s0)
 40c:	dbdff0ef          	jal	ra,1c8 <Non_Crossing_Biased_Descend>
 410:	00050793          	mv	a5,a0
 414:	00078c63          	beqz	a5,42c <alt_sep_test+0x110>
 418:	ec9ff0ef          	jal	ra,2e0 <Own_Above_Threat>
 41c:	00050793          	mv	a5,a0
 420:	00078663          	beqz	a5,42c <alt_sep_test+0x110>
 424:	00100793          	li	a5,1
 428:	0080006f          	j	430 <alt_sep_test+0x114>
 42c:	00000793          	li	a5,0
 430:	fcf42c23          	sw	a5,-40(s0)
 434:	fdc42783          	lw	a5,-36(s0)
 438:	00078a63          	beqz	a5,44c <alt_sep_test+0x130>
 43c:	fd842783          	lw	a5,-40(s0)
 440:	00078663          	beqz	a5,44c <alt_sep_test+0x130>
 444:	fe042623          	sw	zero,-20(s0)
 448:	0300006f          	j	478 <alt_sep_test+0x15c>
 44c:	fdc42783          	lw	a5,-36(s0)
 450:	00078863          	beqz	a5,460 <alt_sep_test+0x144>
 454:	00100793          	li	a5,1
 458:	fef42623          	sw	a5,-20(s0)
 45c:	01c0006f          	j	478 <alt_sep_test+0x15c>
 460:	fd842783          	lw	a5,-40(s0)
 464:	00078863          	beqz	a5,474 <alt_sep_test+0x158>
 468:	00200793          	li	a5,2
 46c:	fef42623          	sw	a5,-20(s0)
 470:	0080006f          	j	478 <alt_sep_test+0x15c>
 474:	fe042623          	sw	zero,-20(s0)
 478:	fec42783          	lw	a5,-20(s0)
 47c:	00078513          	mv	a0,a5
 480:	02c12083          	lw	ra,44(sp)
 484:	02812403          	lw	s0,40(sp)
 488:	03010113          	addi	sp,sp,48
 48c:	00008067          	ret

00000490 <main>:
 490:	fe010113          	addi	sp,sp,-32
 494:	00112e23          	sw	ra,28(sp)
 498:	00812c23          	sw	s0,24(sp)
 49c:	02010413          	addi	s0,sp,32
 4a0:	000067b7          	lui	a5,0x6
 4a4:	fef42623          	sw	a5,-20(s0)
 4a8:	b61ff0ef          	jal	ra,8 <initialize>
 4ac:	fec42783          	lw	a5,-20(s0)
 4b0:	0047a703          	lw	a4,4(a5) # 6004 <__global_pointer$+0x3c2c>
 4b4:	00001797          	auipc	a5,0x1
 4b8:	7087a783          	lw	a5,1800(a5) # 1bbc <_GLOBAL_OFFSET_TABLE_+0x1c>
 4bc:	00e7a023          	sw	a4,0(a5)
 4c0:	fec42783          	lw	a5,-20(s0)
 4c4:	0087a703          	lw	a4,8(a5)
 4c8:	00001797          	auipc	a5,0x1
 4cc:	6e07a783          	lw	a5,1760(a5) # 1ba8 <_GLOBAL_OFFSET_TABLE_+0x8>
 4d0:	00e7a023          	sw	a4,0(a5)
 4d4:	fec42783          	lw	a5,-20(s0)
 4d8:	00c7a703          	lw	a4,12(a5)
 4dc:	00001797          	auipc	a5,0x1
 4e0:	6c87a783          	lw	a5,1736(a5) # 1ba4 <_GLOBAL_OFFSET_TABLE_+0x4>
 4e4:	00e7a023          	sw	a4,0(a5)
 4e8:	fec42783          	lw	a5,-20(s0)
 4ec:	0107a703          	lw	a4,16(a5)
 4f0:	00001797          	auipc	a5,0x1
 4f4:	6dc7a783          	lw	a5,1756(a5) # 1bcc <_GLOBAL_OFFSET_TABLE_+0x2c>
 4f8:	00e7a023          	sw	a4,0(a5)
 4fc:	fec42783          	lw	a5,-20(s0)
 500:	0147a703          	lw	a4,20(a5)
 504:	00001797          	auipc	a5,0x1
 508:	6bc7a783          	lw	a5,1724(a5) # 1bc0 <_GLOBAL_OFFSET_TABLE_+0x20>
 50c:	00e7a023          	sw	a4,0(a5)
 510:	fec42783          	lw	a5,-20(s0)
 514:	0187a703          	lw	a4,24(a5)
 518:	00001797          	auipc	a5,0x1
 51c:	6ac7a783          	lw	a5,1708(a5) # 1bc4 <_GLOBAL_OFFSET_TABLE_+0x24>
 520:	00e7a023          	sw	a4,0(a5)
 524:	fec42783          	lw	a5,-20(s0)
 528:	01c7a703          	lw	a4,28(a5)
 52c:	00001797          	auipc	a5,0x1
 530:	68c7a783          	lw	a5,1676(a5) # 1bb8 <_GLOBAL_OFFSET_TABLE_+0x18>
 534:	00e7a023          	sw	a4,0(a5)
 538:	00001797          	auipc	a5,0x1
 53c:	6807a783          	lw	a5,1664(a5) # 1bb8 <_GLOBAL_OFFSET_TABLE_+0x18>
 540:	0007a783          	lw	a5,0(a5)
 544:	0037f713          	andi	a4,a5,3
 548:	00001797          	auipc	a5,0x1
 54c:	6707a783          	lw	a5,1648(a5) # 1bb8 <_GLOBAL_OFFSET_TABLE_+0x18>
 550:	00e7a023          	sw	a4,0(a5)
 554:	fec42783          	lw	a5,-20(s0)
 558:	0207a703          	lw	a4,32(a5)
 55c:	00001797          	auipc	a5,0x1
 560:	66c7a783          	lw	a5,1644(a5) # 1bc8 <_GLOBAL_OFFSET_TABLE_+0x28>
 564:	00e7a023          	sw	a4,0(a5)
 568:	fec42783          	lw	a5,-20(s0)
 56c:	0247a703          	lw	a4,36(a5)
 570:	00001797          	auipc	a5,0x1
 574:	6407a783          	lw	a5,1600(a5) # 1bb0 <_GLOBAL_OFFSET_TABLE_+0x10>
 578:	00e7a023          	sw	a4,0(a5)
 57c:	fec42783          	lw	a5,-20(s0)
 580:	0287a703          	lw	a4,40(a5)
 584:	00001797          	auipc	a5,0x1
 588:	6507a783          	lw	a5,1616(a5) # 1bd4 <_GLOBAL_OFFSET_TABLE_+0x34>
 58c:	00e7a023          	sw	a4,0(a5)
 590:	fec42783          	lw	a5,-20(s0)
 594:	02c7a703          	lw	a4,44(a5)
 598:	00001797          	auipc	a5,0x1
 59c:	61c7a783          	lw	a5,1564(a5) # 1bb4 <_GLOBAL_OFFSET_TABLE_+0x14>
 5a0:	00e7a023          	sw	a4,0(a5)
 5a4:	fec42783          	lw	a5,-20(s0)
 5a8:	0307a703          	lw	a4,48(a5)
 5ac:	00001797          	auipc	a5,0x1
 5b0:	6247a783          	lw	a5,1572(a5) # 1bd0 <_GLOBAL_OFFSET_TABLE_+0x30>
 5b4:	00e7a023          	sw	a4,0(a5)
 5b8:	000047b7          	lui	a5,0x4
 5bc:	fef42423          	sw	a5,-24(s0)
 5c0:	d5dff0ef          	jal	ra,31c <alt_sep_test>
 5c4:	00050713          	mv	a4,a0
 5c8:	fe842783          	lw	a5,-24(s0)
 5cc:	00e7a023          	sw	a4,0(a5) # 4000 <__global_pointer$+0x1c28>
 5d0:	00000513          	li	a0,0
 5d4:	004000ef          	jal	ra,5d8 <exit>

000005d8 <exit>:
 5d8:	ff010113          	addi	sp,sp,-16
 5dc:	00000593          	li	a1,0
 5e0:	00812423          	sw	s0,8(sp)
 5e4:	00112623          	sw	ra,12(sp)
 5e8:	00050413          	mv	s0,a0
 5ec:	020000ef          	jal	ra,60c <__call_exitprocs>
 5f0:	000027b7          	lui	a5,0x2
 5f4:	bd87a503          	lw	a0,-1064(a5) # 1bd8 <_global_impure_ptr>
 5f8:	03c52783          	lw	a5,60(a0)
 5fc:	00078463          	beqz	a5,604 <exit+0x2c>
 600:	000780e7          	jalr	a5
 604:	00040513          	mv	a0,s0
 608:	114000ef          	jal	ra,71c <_exit>

0000060c <__call_exitprocs>:
 60c:	fd010113          	addi	sp,sp,-48
 610:	000027b7          	lui	a5,0x2
 614:	01312e23          	sw	s3,28(sp)
 618:	bd87a983          	lw	s3,-1064(a5) # 1bd8 <_global_impure_ptr>
 61c:	01412c23          	sw	s4,24(sp)
 620:	01512a23          	sw	s5,20(sp)
 624:	01612823          	sw	s6,16(sp)
 628:	02112623          	sw	ra,44(sp)
 62c:	02812423          	sw	s0,40(sp)
 630:	02912223          	sw	s1,36(sp)
 634:	03212023          	sw	s2,32(sp)
 638:	01712623          	sw	s7,12(sp)
 63c:	00050a93          	mv	s5,a0
 640:	00058a13          	mv	s4,a1
 644:	00100b13          	li	s6,1
 648:	1489a483          	lw	s1,328(s3)
 64c:	00048c63          	beqz	s1,664 <__call_exitprocs+0x58>
 650:	0044a403          	lw	s0,4(s1)
 654:	fff40913          	addi	s2,s0,-1
 658:	00241413          	slli	s0,s0,0x2
 65c:	00848433          	add	s0,s1,s0
 660:	02095863          	bgez	s2,690 <__call_exitprocs+0x84>
 664:	02c12083          	lw	ra,44(sp)
 668:	02812403          	lw	s0,40(sp)
 66c:	02412483          	lw	s1,36(sp)
 670:	02012903          	lw	s2,32(sp)
 674:	01c12983          	lw	s3,28(sp)
 678:	01812a03          	lw	s4,24(sp)
 67c:	01412a83          	lw	s5,20(sp)
 680:	01012b03          	lw	s6,16(sp)
 684:	00c12b83          	lw	s7,12(sp)
 688:	03010113          	addi	sp,sp,48
 68c:	00008067          	ret
 690:	000a0c63          	beqz	s4,6a8 <__call_exitprocs+0x9c>
 694:	10442783          	lw	a5,260(s0)
 698:	01478863          	beq	a5,s4,6a8 <__call_exitprocs+0x9c>
 69c:	fff90913          	addi	s2,s2,-1
 6a0:	ffc40413          	addi	s0,s0,-4
 6a4:	fbdff06f          	j	660 <__call_exitprocs+0x54>
 6a8:	0044a703          	lw	a4,4(s1)
 6ac:	00442783          	lw	a5,4(s0)
 6b0:	fff70713          	addi	a4,a4,-1
 6b4:	03271c63          	bne	a4,s2,6ec <__call_exitprocs+0xe0>
 6b8:	0124a223          	sw	s2,4(s1)
 6bc:	fe0780e3          	beqz	a5,69c <__call_exitprocs+0x90>
 6c0:	1884a683          	lw	a3,392(s1)
 6c4:	012b1733          	sll	a4,s6,s2
 6c8:	0044ab83          	lw	s7,4(s1)
 6cc:	00d776b3          	and	a3,a4,a3
 6d0:	02069263          	bnez	a3,6f4 <__call_exitprocs+0xe8>
 6d4:	000780e7          	jalr	a5
 6d8:	0044a703          	lw	a4,4(s1)
 6dc:	1489a783          	lw	a5,328(s3)
 6e0:	f77714e3          	bne	a4,s7,648 <__call_exitprocs+0x3c>
 6e4:	faf48ce3          	beq	s1,a5,69c <__call_exitprocs+0x90>
 6e8:	f61ff06f          	j	648 <__call_exitprocs+0x3c>
 6ec:	00042223          	sw	zero,4(s0)
 6f0:	fcdff06f          	j	6bc <__call_exitprocs+0xb0>
 6f4:	18c4a683          	lw	a3,396(s1)
 6f8:	08442583          	lw	a1,132(s0)
 6fc:	00d77733          	and	a4,a4,a3
 700:	00071863          	bnez	a4,710 <__call_exitprocs+0x104>
 704:	000a8513          	mv	a0,s5
 708:	000780e7          	jalr	a5
 70c:	fcdff06f          	j	6d8 <__call_exitprocs+0xcc>
 710:	00058513          	mv	a0,a1
 714:	000780e7          	jalr	a5
 718:	fc1ff06f          	j	6d8 <__call_exitprocs+0xcc>

0000071c <_exit>:
 71c:	00000593          	li	a1,0
 720:	00000613          	li	a2,0
 724:	00000693          	li	a3,0
 728:	00000713          	li	a4,0
 72c:	00000793          	li	a5,0
 730:	05d00893          	li	a7,93
 734:	00000073          	ecall
 738:	02055263          	bgez	a0,75c <_exit+0x40>
 73c:	ff010113          	addi	sp,sp,-16
 740:	00812423          	sw	s0,8(sp)
 744:	00050413          	mv	s0,a0
 748:	00112623          	sw	ra,12(sp)
 74c:	40800433          	neg	s0,s0
 750:	010000ef          	jal	ra,760 <__errno>
 754:	00852023          	sw	s0,0(a0)
 758:	0000006f          	j	758 <_exit+0x3c>
 75c:	0000006f          	j	75c <_exit+0x40>

00000760 <__errno>:
 760:	000027b7          	lui	a5,0x2
 764:	bdc7a503          	lw	a0,-1060(a5) # 1bdc <_impure_ptr>
 768:	00008067          	ret
