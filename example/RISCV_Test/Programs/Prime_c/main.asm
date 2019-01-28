
main.out:     file format elf32-littleriscv


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

Disassembly of section .eh_frame:

000002c0 <__bss_start-0x1044>:
 2c0:	0010                	0x10
 2c2:	0000                	unimp
 2c4:	0000                	unimp
 2c6:	0000                	unimp
 2c8:	7a01                	lui	s4,0xfffe0
 2ca:	0052                	0x52
 2cc:	7c01                	lui	s8,0xfffe0
 2ce:	0101                	addi	sp,sp,0
 2d0:	00020d1b          	0x20d1b
 2d4:	002c                	addi	a1,sp,8
 2d6:	0000                	unimp
 2d8:	0018                	0x18
 2da:	0000                	unimp
 2dc:	fd30                	fsw	fa2,120(a0)
 2de:	ffff                	0xffff
 2e0:	0200                	addi	s0,sp,256
 2e2:	0000                	unimp
 2e4:	4400                	lw	s0,8(s0)
 2e6:	400e                	0x400e
 2e8:	814c                	0x814c
 2ea:	8801                	andi	s0,s0,0
 2ec:	8902                	jr	s2
 2ee:	080c4403          	lbu	s0,128(s8) # fffe0080 <_memEnd+0xfffd0080>
 2f2:	0300                	addi	s0,sp,384
 2f4:	01d8                	addi	a4,sp,196
 2f6:	020c                	addi	a1,sp,256
 2f8:	4440                	lw	s0,12(s0)
 2fa:	44c1                	li	s1,16
 2fc:	44c8                	lw	a0,12(s1)
 2fe:	44c9                	li	s1,18
 300:	000e                	0xe
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	fld	fs0,80(s0)
   6:	29554e47          	fmsub.s	ft8,fa0,fs5,ft5,rmm
   a:	3720                	fld	fs0,104(a4)
   c:	322e                	fld	ft4,232(sp)
   e:	302e                	fld	ft0,232(sp)
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	001c                	0x1c
   2:	0000                	unimp
   4:	0002                	0x2
   6:	0000                	unimp
   8:	0000                	unimp
   a:	0004                	0x4
   c:	0000                	unimp
   e:	0000                	unimp
  10:	020c                	addi	a1,sp,256
  12:	0000                	unimp
  14:	00b4                	addi	a3,sp,72
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	0022                	0x22
   2:	0000                	unimp
   4:	0002                	0x2
   6:	0000                	unimp
   8:	0000                	unimp
   a:	0104                	addi	s1,sp,128
   c:	0000                	unimp
   e:	0000                	unimp
  10:	020c                	addi	a1,sp,256
  12:	0000                	unimp
  14:	02c0                	addi	s0,sp,324
  16:	0000                	unimp
  18:	0000                	unimp
  1a:	0000                	unimp
  1c:	0030                	addi	a2,sp,8
  1e:	0000                	unimp
  20:	000000a7          	0xa7
  24:	8001                	srli	s0,s0,0x0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	1101                	addi	sp,sp,-32
   2:	1000                	addi	s0,sp,32
   4:	1106                	slli	sp,sp,0x21
   6:	1201                	addi	tp,tp,-32
   8:	0301                	addi	t1,t1,0
   a:	1b0e                	slli	s6,s6,0x23
   c:	250e                	fld	fa0,192(sp)
   e:	130e                	slli	t1,t1,0x23
  10:	0005                	c.addi	zero,1
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	0165                	addi	sp,sp,25
   2:	0000                	unimp
   4:	0002                	0x2
   6:	0046                	0x46
   8:	0000                	unimp
   a:	0101                	addi	sp,sp,0
   c:	000d0efb          	0xd0efb
  10:	0101                	addi	sp,sp,0
  12:	0101                	addi	sp,sp,0
  14:	0000                	unimp
  16:	0100                	addi	s0,sp,128
  18:	0000                	unimp
  1a:	2e01                	jal	32a <__modsi3+0x9a>
  1c:	2f2e                	fld	ft10,200(sp)
  1e:	2e2e                	fld	ft8,200(sp)
  20:	2f2e2e2f          	0x2f2e2e2f
  24:	2e2e                	fld	ft8,200(sp)
  26:	7369722f          	0x7369722f
  2a:	672d7663          	bleu	s2,s10,696 <__modsi3+0x406>
  2e:	6c2f6363          	bltu	t5,sp,6f4 <__modsi3+0x464>
  32:	6269                	lui	tp,0x1a
  34:	2f636367          	0x2f636367
  38:	666e6f63          	bltu	t3,t1,6b6 <__modsi3+0x426>
  3c:	6769                	lui	a4,0x1a
  3e:	7369722f          	0x7369722f
  42:	00007663          	bleu	zero,zero,4e <main+0x42>
  46:	6964                	flw	fs1,84(a0)
  48:	2e76                	fld	ft8,344(sp)
  4a:	00010053          	fadd.s	ft0,ft2,ft0,rne
  4e:	0000                	unimp
  50:	0500                	addi	s0,sp,640
  52:	0c02                	slli	s8,s8,0x0
  54:	0002                	0x2
  56:	0300                	addi	s0,sp,384
  58:	00c5                	addi	ra,ra,17
  5a:	0301                	addi	t1,t1,0
  5c:	0901                	addi	s2,s2,0
  5e:	0004                	0x4
  60:	0301                	addi	t1,t1,0
  62:	0905                	addi	s2,s2,1
  64:	0004                	0x4
  66:	0301                	addi	t1,t1,0
  68:	0901                	addi	s2,s2,0
  6a:	0004                	0x4
  6c:	0301                	addi	t1,t1,0
  6e:	0901                	addi	s2,s2,0
  70:	0004                	0x4
  72:	0301                	addi	t1,t1,0
  74:	0901                	addi	s2,s2,0
  76:	0004                	0x4
  78:	0301                	addi	t1,t1,0
  7a:	0901                	addi	s2,s2,0
  7c:	0004                	0x4
  7e:	0301                	addi	t1,t1,0
  80:	0901                	addi	s2,s2,0
  82:	0004                	0x4
  84:	0301                	addi	t1,t1,0
  86:	0902                	slli	s2,s2,0x0
  88:	0004                	0x4
  8a:	0301                	addi	t1,t1,0
  8c:	0901                	addi	s2,s2,0
  8e:	0004                	0x4
  90:	0301                	addi	t1,t1,0
  92:	0901                	addi	s2,s2,0
  94:	0004                	0x4
  96:	0301                	addi	t1,t1,0
  98:	0901                	addi	s2,s2,0
  9a:	0004                	0x4
  9c:	0301                	addi	t1,t1,0
  9e:	0902                	slli	s2,s2,0x0
  a0:	0004                	0x4
  a2:	0301                	addi	t1,t1,0
  a4:	0902                	slli	s2,s2,0x0
  a6:	0004                	0x4
  a8:	0301                	addi	t1,t1,0
  aa:	0901                	addi	s2,s2,0
  ac:	0004                	0x4
  ae:	0301                	addi	t1,t1,0
  b0:	0901                	addi	s2,s2,0
  b2:	0004                	0x4
  b4:	0301                	addi	t1,t1,0
  b6:	0902                	slli	s2,s2,0x0
  b8:	0004                	0x4
  ba:	0301                	addi	t1,t1,0
  bc:	0901                	addi	s2,s2,0
  be:	0004                	0x4
  c0:	0301                	addi	t1,t1,0
  c2:	0901                	addi	s2,s2,0
  c4:	0004                	0x4
  c6:	0301                	addi	t1,t1,0
  c8:	0902                	slli	s2,s2,0x0
  ca:	0004                	0x4
  cc:	0301                	addi	t1,t1,0
  ce:	0905                	addi	s2,s2,1
  d0:	0004                	0x4
  d2:	0301                	addi	t1,t1,0
  d4:	0901                	addi	s2,s2,0
  d6:	0004                	0x4
  d8:	0301                	addi	t1,t1,0
  da:	0901                	addi	s2,s2,0
  dc:	0004                	0x4
  de:	0301                	addi	t1,t1,0
  e0:	0901                	addi	s2,s2,0
  e2:	0004                	0x4
  e4:	0301                	addi	t1,t1,0
  e6:	0904                	addi	s1,sp,144
  e8:	0004                	0x4
  ea:	0301                	addi	t1,t1,0
  ec:	0901                	addi	s2,s2,0
  ee:	0004                	0x4
  f0:	0301                	addi	t1,t1,0
  f2:	0901                	addi	s2,s2,0
  f4:	0004                	0x4
  f6:	0301                	addi	t1,t1,0
  f8:	0901                	addi	s2,s2,0
  fa:	0004                	0x4
  fc:	0301                	addi	t1,t1,0
  fe:	0902                	slli	s2,s2,0x0
 100:	0004                	0x4
 102:	0301                	addi	t1,t1,0
 104:	0902                	slli	s2,s2,0x0
 106:	0004                	0x4
 108:	0301                	addi	t1,t1,0
 10a:	0901                	addi	s2,s2,0
 10c:	0004                	0x4
 10e:	0301                	addi	t1,t1,0
 110:	0901                	addi	s2,s2,0
 112:	0004                	0x4
 114:	0301                	addi	t1,t1,0
 116:	0901                	addi	s2,s2,0
 118:	0004                	0x4
 11a:	0301                	addi	t1,t1,0
 11c:	0904                	addi	s1,sp,144
 11e:	0004                	0x4
 120:	0301                	addi	t1,t1,0
 122:	0901                	addi	s2,s2,0
 124:	0004                	0x4
 126:	0301                	addi	t1,t1,0
 128:	0901                	addi	s2,s2,0
 12a:	0004                	0x4
 12c:	0301                	addi	t1,t1,0
 12e:	0902                	slli	s2,s2,0x0
 130:	0004                	0x4
 132:	0301                	addi	t1,t1,0
 134:	0901                	addi	s2,s2,0
 136:	0004                	0x4
 138:	0301                	addi	t1,t1,0
 13a:	0901                	addi	s2,s2,0
 13c:	0004                	0x4
 13e:	0301                	addi	t1,t1,0
 140:	0902                	slli	s2,s2,0x0
 142:	0004                	0x4
 144:	0301                	addi	t1,t1,0
 146:	0901                	addi	s2,s2,0
 148:	0004                	0x4
 14a:	0301                	addi	t1,t1,0
 14c:	0902                	slli	s2,s2,0x0
 14e:	0004                	0x4
 150:	0301                	addi	t1,t1,0
 152:	0901                	addi	s2,s2,0
 154:	0004                	0x4
 156:	0301                	addi	t1,t1,0
 158:	0901                	addi	s2,s2,0
 15a:	0004                	0x4
 15c:	0301                	addi	t1,t1,0
 15e:	0901                	addi	s2,s2,0
 160:	0004                	0x4
 162:	0901                	addi	s2,s2,0
 164:	0004                	0x4
 166:	0100                	addi	s0,sp,128
 168:	01              	Address 0x0000000000000168 is out of bounds.


Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	2e2e                	fld	ft8,200(sp)
   2:	2f2e2e2f          	0x2f2e2e2f
   6:	2e2e                	fld	ft8,200(sp)
   8:	2f2e2e2f          	0x2f2e2e2f
   c:	6972                	flw	fs2,28(sp)
   e:	2d766373          	csrrsi	t1,0x2d7,12
  12:	2f636367          	0x2f636367
  16:	696c                	flw	fa1,84(a0)
  18:	6762                	flw	fa4,24(sp)
  1a:	632f6363          	bltu	t5,s2,640 <__modsi3+0x3b0>
  1e:	69666e6f          	jal	t3,666b4 <_memEnd+0x566b4>
  22:	69722f67          	0x69722f67
  26:	2f766373          	csrrsi	t1,0x2f7,12
  2a:	6964                	flw	fs1,84(a0)
  2c:	2e76                	fld	ft8,344(sp)
  2e:	682f0053          	0x682f0053
  32:	2f656d6f          	jal	s10,56328 <_memEnd+0x46328>
  36:	6f72                	flw	ft10,28(sp)
  38:	74656b63          	bltu	a0,t1,78e <__modsi3+0x4fe>
  3c:	632d                	lui	t1,0xb
  3e:	6968                	flw	fa0,84(a0)
  40:	2f70                	fld	fa2,216(a4)
  42:	6f72                	flw	ft10,28(sp)
  44:	74656b63          	bltu	a0,t1,79a <__modsi3+0x50a>
  48:	632d                	lui	t1,0xb
  4a:	6968                	flw	fa0,84(a0)
  4c:	2f70                	fld	fa2,216(a4)
  4e:	6972                	flw	fs2,28(sp)
  50:	2d766373          	csrrsi	t1,0x2d7,12
  54:	6f74                	flw	fa3,92(a4)
  56:	2f736c6f          	jal	s8,36b4c <_memEnd+0x26b4c>
  5a:	6972                	flw	fs2,28(sp)
  5c:	2d766373          	csrrsi	t1,0x2d7,12
  60:	2d756e67          	0x2d756e67
  64:	6f74                	flw	fa3,92(a4)
  66:	68636c6f          	jal	s8,366ec <_memEnd+0x266ec>
  6a:	6961                	lui	s2,0x18
  6c:	2f6e                	fld	ft10,216(sp)
  6e:	7562                	flw	fa0,56(sp)
  70:	6c69                	lui	s8,0x1a
  72:	2f64                	fld	fs1,216(a4)
  74:	7562                	flw	fa0,56(sp)
  76:	6c69                	lui	s8,0x1a
  78:	2d64                	fld	fs1,216(a0)
  7a:	2d636367          	0x2d636367
  7e:	656e                	flw	fa0,216(sp)
  80:	62696c77          	0x62696c77
  84:	732d                	lui	t1,0xfffeb
  86:	6174                	flw	fa3,68(a0)
  88:	2f326567          	0x2f326567
  8c:	6972                	flw	fs2,28(sp)
  8e:	33766373          	csrrsi	t1,mhpmevent23,12
  92:	2d32                	fld	fs10,264(sp)
  94:	6e75                	lui	t3,0x1d
  96:	776f6e6b          	0x776f6e6b
  9a:	2d6e                	fld	fs10,216(sp)
  9c:	6c65                	lui	s8,0x19
  9e:	2f66                	fld	ft10,88(sp)
  a0:	696c                	flw	fa1,84(a0)
  a2:	6762                	flw	fa4,24(sp)
  a4:	47006363          	bltu	zero,a6,50a <__modsi3+0x27a>
  a8:	554e                	lw	a0,240(sp)
  aa:	4120                	lw	s0,64(a0)
  ac:	2e322053          	0x2e322053
  b0:	3932                	fld	fs2,296(sp)
	...
