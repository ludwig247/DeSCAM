
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/exetime_programs/exetime_bubblesort.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	fff10113          	addi	sp,sp,-1 # ffff <_memEnd>
   8:	11c000ef          	jal	ra,124 <main>

0000000c <_end>:
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00100073          	ebreak

00000024 <_Z10bubbleSortPii>:
  24:	fd010113          	addi	sp,sp,-48
  28:	02812623          	sw	s0,44(sp)
  2c:	03010413          	addi	s0,sp,48
  30:	fca42e23          	sw	a0,-36(s0)
  34:	fcb42c23          	sw	a1,-40(s0)
  38:	00100793          	li	a5,1
  3c:	fef42623          	sw	a5,-20(s0)
  40:	fec42703          	lw	a4,-20(s0)
  44:	fd842783          	lw	a5,-40(s0)
  48:	0cf75663          	ble	a5,a4,114 <_Z10bubbleSortPii+0xf0>
  4c:	fe042423          	sw	zero,-24(s0)
  50:	fd842703          	lw	a4,-40(s0)
  54:	fec42783          	lw	a5,-20(s0)
  58:	40f707b3          	sub	a5,a4,a5
  5c:	fe842703          	lw	a4,-24(s0)
  60:	0af75263          	ble	a5,a4,104 <_Z10bubbleSortPii+0xe0>
  64:	fe842783          	lw	a5,-24(s0)
  68:	00279793          	slli	a5,a5,0x2
  6c:	fdc42703          	lw	a4,-36(s0)
  70:	00f707b3          	add	a5,a4,a5
  74:	0007a703          	lw	a4,0(a5)
  78:	fe842783          	lw	a5,-24(s0)
  7c:	00178793          	addi	a5,a5,1
  80:	00279793          	slli	a5,a5,0x2
  84:	fdc42683          	lw	a3,-36(s0)
  88:	00f687b3          	add	a5,a3,a5
  8c:	0007a783          	lw	a5,0(a5)
  90:	06e7d263          	ble	a4,a5,f4 <_Z10bubbleSortPii+0xd0>
  94:	fe842783          	lw	a5,-24(s0)
  98:	00279793          	slli	a5,a5,0x2
  9c:	fdc42703          	lw	a4,-36(s0)
  a0:	00f707b3          	add	a5,a4,a5
  a4:	0007a783          	lw	a5,0(a5)
  a8:	fef42223          	sw	a5,-28(s0)
  ac:	fe842783          	lw	a5,-24(s0)
  b0:	00178793          	addi	a5,a5,1
  b4:	00279793          	slli	a5,a5,0x2
  b8:	fdc42703          	lw	a4,-36(s0)
  bc:	00f70733          	add	a4,a4,a5
  c0:	fe842783          	lw	a5,-24(s0)
  c4:	00279793          	slli	a5,a5,0x2
  c8:	fdc42683          	lw	a3,-36(s0)
  cc:	00f687b3          	add	a5,a3,a5
  d0:	00072703          	lw	a4,0(a4)
  d4:	00e7a023          	sw	a4,0(a5)
  d8:	fe842783          	lw	a5,-24(s0)
  dc:	00178793          	addi	a5,a5,1
  e0:	00279793          	slli	a5,a5,0x2
  e4:	fdc42703          	lw	a4,-36(s0)
  e8:	00f707b3          	add	a5,a4,a5
  ec:	fe442703          	lw	a4,-28(s0)
  f0:	00e7a023          	sw	a4,0(a5)
  f4:	fe842783          	lw	a5,-24(s0)
  f8:	00178793          	addi	a5,a5,1
  fc:	fef42423          	sw	a5,-24(s0)
 100:	f51ff06f          	j	50 <_Z10bubbleSortPii+0x2c>
 104:	fec42783          	lw	a5,-20(s0)
 108:	00178793          	addi	a5,a5,1
 10c:	fef42623          	sw	a5,-20(s0)
 110:	f31ff06f          	j	40 <_Z10bubbleSortPii+0x1c>
 114:	00000013          	nop
 118:	02c12403          	lw	s0,44(sp)
 11c:	03010113          	addi	sp,sp,48
 120:	00008067          	ret

00000124 <main>:
 124:	fe010113          	addi	sp,sp,-32
 128:	00112e23          	sw	ra,28(sp)
 12c:	00812c23          	sw	s0,24(sp)
 130:	00912a23          	sw	s1,20(sp)
 134:	02010413          	addi	s0,sp,32
 138:	00010513          	mv	a0,sp
 13c:	00050493          	mv	s1,a0
 140:	1f400513          	li	a0,500
 144:	fea42423          	sw	a0,-24(s0)
 148:	fe842503          	lw	a0,-24(s0)
 14c:	fff50513          	addi	a0,a0,-1
 150:	fea42223          	sw	a0,-28(s0)
 154:	00050893          	mv	a7,a0
 158:	00188893          	addi	a7,a7,1
 15c:	00088313          	mv	t1,a7
 160:	00000393          	li	t2,0
 164:	01b35893          	srli	a7,t1,0x1b
 168:	00539713          	slli	a4,t2,0x5
 16c:	00e8e733          	or	a4,a7,a4
 170:	00531693          	slli	a3,t1,0x5
 174:	00050713          	mv	a4,a0
 178:	00170713          	addi	a4,a4,1
 17c:	00070593          	mv	a1,a4
 180:	00000613          	li	a2,0
 184:	01b5d713          	srli	a4,a1,0x1b
 188:	00561813          	slli	a6,a2,0x5
 18c:	01076833          	or	a6,a4,a6
 190:	00559793          	slli	a5,a1,0x5
 194:	00050793          	mv	a5,a0
 198:	00178793          	addi	a5,a5,1
 19c:	00279793          	slli	a5,a5,0x2
 1a0:	00378793          	addi	a5,a5,3
 1a4:	00f78793          	addi	a5,a5,15
 1a8:	0047d793          	srli	a5,a5,0x4
 1ac:	00479793          	slli	a5,a5,0x4
 1b0:	40f10133          	sub	sp,sp,a5
 1b4:	00010793          	mv	a5,sp
 1b8:	00378793          	addi	a5,a5,3
 1bc:	0027d793          	srli	a5,a5,0x2
 1c0:	00279793          	slli	a5,a5,0x2
 1c4:	fef42023          	sw	a5,-32(s0)
 1c8:	fe042623          	sw	zero,-20(s0)
 1cc:	fec42703          	lw	a4,-20(s0)
 1d0:	fe842783          	lw	a5,-24(s0)
 1d4:	02f75a63          	ble	a5,a4,208 <main+0xe4>
 1d8:	fe842703          	lw	a4,-24(s0)
 1dc:	fec42783          	lw	a5,-20(s0)
 1e0:	40f70733          	sub	a4,a4,a5
 1e4:	fe042683          	lw	a3,-32(s0)
 1e8:	fec42783          	lw	a5,-20(s0)
 1ec:	00279793          	slli	a5,a5,0x2
 1f0:	00f687b3          	add	a5,a3,a5
 1f4:	00e7a023          	sw	a4,0(a5)
 1f8:	fec42783          	lw	a5,-20(s0)
 1fc:	00178793          	addi	a5,a5,1
 200:	fef42623          	sw	a5,-20(s0)
 204:	fc9ff06f          	j	1cc <main+0xa8>
 208:	fe042783          	lw	a5,-32(s0)
 20c:	fe842583          	lw	a1,-24(s0)
 210:	00078513          	mv	a0,a5
 214:	e11ff0ef          	jal	ra,24 <_Z10bubbleSortPii>
 218:	00000793          	li	a5,0
 21c:	00048113          	mv	sp,s1
 220:	00078513          	mv	a0,a5
 224:	fe040113          	addi	sp,s0,-32
 228:	01c12083          	lw	ra,28(sp)
 22c:	01812403          	lw	s0,24(sp)
 230:	01412483          	lw	s1,20(sp)
 234:	02010113          	addi	sp,sp,32
 238:	00008067          	ret
