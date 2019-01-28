
main.out:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	008000ef          	jal	ra,c <main>

00000008 <_end>:
   8:	00100073          	ebreak

0000000c <main>:
   c:	fc010113          	addi	sp,sp,-64 # ffc0 <__global_pointer$+0xe520>
  10:	02812e23          	sw	s0,60(sp)
  14:	04010413          	addi	s0,sp,64
  18:	fca42623          	sw	a0,-52(s0)
  1c:	fcb42423          	sw	a1,-56(s0)
  20:	00010613          	mv	a2,sp
  24:	00060513          	mv	a0,a2
  28:	00004637          	lui	a2,0x4
  2c:	a9860613          	addi	a2,a2,-1384 # 3a98 <__global_pointer$+0x1ff8>
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
 130:	fdc42783          	lw	a5,-36(s0)
 134:	ff678793          	addi	a5,a5,-10
 138:	fd442703          	lw	a4,-44(s0)
 13c:	00279793          	slli	a5,a5,0x2
 140:	00f707b3          	add	a5,a4,a5
 144:	0007a783          	lw	a5,0(a5)
 148:	00078913          	mv	s2,a5
 14c:	fdc42783          	lw	a5,-36(s0)
 150:	ff778793          	addi	a5,a5,-9
 154:	fd442703          	lw	a4,-44(s0)
 158:	00279793          	slli	a5,a5,0x2
 15c:	00f707b3          	add	a5,a4,a5
 160:	0007a783          	lw	a5,0(a5)
 164:	00078993          	mv	s3,a5
 168:	fdc42783          	lw	a5,-36(s0)
 16c:	ff878793          	addi	a5,a5,-8
 170:	fd442703          	lw	a4,-44(s0)
 174:	00279793          	slli	a5,a5,0x2
 178:	00f707b3          	add	a5,a4,a5
 17c:	0007a783          	lw	a5,0(a5)
 180:	00078a13          	mv	s4,a5
 184:	fdc42783          	lw	a5,-36(s0)
 188:	ff978793          	addi	a5,a5,-7
 18c:	fd442703          	lw	a4,-44(s0)
 190:	00279793          	slli	a5,a5,0x2
 194:	00f707b3          	add	a5,a4,a5
 198:	0007a783          	lw	a5,0(a5)
 19c:	00078a93          	mv	s5,a5
 1a0:	fdc42783          	lw	a5,-36(s0)
 1a4:	ffa78793          	addi	a5,a5,-6
 1a8:	fd442703          	lw	a4,-44(s0)
 1ac:	00279793          	slli	a5,a5,0x2
 1b0:	00f707b3          	add	a5,a4,a5
 1b4:	0007a783          	lw	a5,0(a5)
 1b8:	00078b13          	mv	s6,a5
 1bc:	fdc42783          	lw	a5,-36(s0)
 1c0:	ffb78793          	addi	a5,a5,-5
 1c4:	fd442703          	lw	a4,-44(s0)
 1c8:	00279793          	slli	a5,a5,0x2
 1cc:	00f707b3          	add	a5,a4,a5
 1d0:	0007a783          	lw	a5,0(a5)
 1d4:	00078b93          	mv	s7,a5
 1d8:	fdc42783          	lw	a5,-36(s0)
 1dc:	ffc78793          	addi	a5,a5,-4
 1e0:	fd442703          	lw	a4,-44(s0)
 1e4:	00279793          	slli	a5,a5,0x2
 1e8:	00f707b3          	add	a5,a4,a5
 1ec:	0007a783          	lw	a5,0(a5)
 1f0:	00078c13          	mv	s8,a5
 1f4:	fdc42783          	lw	a5,-36(s0)
 1f8:	ffd78793          	addi	a5,a5,-3
 1fc:	fd442703          	lw	a4,-44(s0)
 200:	00279793          	slli	a5,a5,0x2
 204:	00f707b3          	add	a5,a4,a5
 208:	0007a783          	lw	a5,0(a5)
 20c:	00078c93          	mv	s9,a5
 210:	fdc42783          	lw	a5,-36(s0)
 214:	ffe78793          	addi	a5,a5,-2
 218:	fd442703          	lw	a4,-44(s0)
 21c:	00279793          	slli	a5,a5,0x2
 220:	00f707b3          	add	a5,a4,a5
 224:	0007a783          	lw	a5,0(a5)
 228:	00078d13          	mv	s10,a5
 22c:	fdc42783          	lw	a5,-36(s0)
 230:	fff78793          	addi	a5,a5,-1
 234:	fd442703          	lw	a4,-44(s0)
 238:	00279793          	slli	a5,a5,0x2
 23c:	00f707b3          	add	a5,a4,a5
 240:	0007a783          	lw	a5,0(a5)
 244:	00078d93          	mv	s11,a5
 248:	00000793          	li	a5,0
 24c:	00050113          	mv	sp,a0
 250:	00078513          	mv	a0,a5
 254:	fc040113          	addi	sp,s0,-64
 258:	03c12403          	lw	s0,60(sp)
 25c:	04010113          	addi	sp,sp,64
 260:	00008067          	ret

Disassembly of section .eh_frame:

00000264 <__bss_start-0x103c>:
 264:	0010                	0x10
 266:	0000                	unimp
 268:	0000                	unimp
 26a:	0000                	unimp
 26c:	7a01                	lui	s4,0xfffe0
 26e:	0052                	0x52
 270:	7c01                	lui	s8,0xfffe0
 272:	0101                	addi	sp,sp,0
 274:	00020d1b          	0x20d1b
 278:	0024                	addi	s1,sp,8
 27a:	0000                	unimp
 27c:	0018                	0x18
 27e:	0000                	unimp
 280:	fd8c                	fsw	fa1,56(a1)
 282:	ffff                	0xffff
 284:	0258                	addi	a4,sp,260
 286:	0000                	unimp
 288:	4400                	lw	s0,8(s0)
 28a:	400e                	0x400e
 28c:	8844                	0x8844
 28e:	4401                	li	s0,0
 290:	080c                	addi	a1,sp,16
 292:	0300                	addi	s0,sp,384
 294:	0240                	addi	s0,sp,260
 296:	020c                	addi	a1,sp,256
 298:	4440                	lw	s0,12(s0)
 29a:	44c8                	lw	a0,12(s1)
 29c:	000e                	0xe
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
