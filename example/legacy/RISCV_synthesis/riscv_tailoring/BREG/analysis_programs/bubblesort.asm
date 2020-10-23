
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/BREG/analysis_programs/bubblesort.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	108000ef          	jal	ra,10c <main>

00000008 <_end>:
   8:	00100073          	ebreak

0000000c <_Z10bubbleSortPii>:
   c:	fd010113          	addi	sp,sp,-48 # ffd0 <__global_pointer$+0xe544>
  10:	02812623          	sw	s0,44(sp)
  14:	03010413          	addi	s0,sp,48
  18:	fca42e23          	sw	a0,-36(s0)
  1c:	fcb42c23          	sw	a1,-40(s0)
  20:	00100793          	li	a5,1
  24:	fef42623          	sw	a5,-20(s0)
  28:	fec42703          	lw	a4,-20(s0)
  2c:	fd842783          	lw	a5,-40(s0)
  30:	0cf75663          	ble	a5,a4,fc <_Z10bubbleSortPii+0xf0>
  34:	fe042423          	sw	zero,-24(s0)
  38:	fd842703          	lw	a4,-40(s0)
  3c:	fec42783          	lw	a5,-20(s0)
  40:	40f707b3          	sub	a5,a4,a5
  44:	fe842703          	lw	a4,-24(s0)
  48:	0af75263          	ble	a5,a4,ec <_Z10bubbleSortPii+0xe0>
  4c:	fe842783          	lw	a5,-24(s0)
  50:	00279793          	slli	a5,a5,0x2
  54:	fdc42703          	lw	a4,-36(s0)
  58:	00f707b3          	add	a5,a4,a5
  5c:	0007a703          	lw	a4,0(a5)
  60:	fe842783          	lw	a5,-24(s0)
  64:	00178793          	addi	a5,a5,1
  68:	00279793          	slli	a5,a5,0x2
  6c:	fdc42683          	lw	a3,-36(s0)
  70:	00f687b3          	add	a5,a3,a5
  74:	0007a783          	lw	a5,0(a5)
  78:	06e7d263          	ble	a4,a5,dc <_Z10bubbleSortPii+0xd0>
  7c:	fe842783          	lw	a5,-24(s0)
  80:	00279793          	slli	a5,a5,0x2
  84:	fdc42703          	lw	a4,-36(s0)
  88:	00f707b3          	add	a5,a4,a5
  8c:	0007a783          	lw	a5,0(a5)
  90:	fef42223          	sw	a5,-28(s0)
  94:	fe842783          	lw	a5,-24(s0)
  98:	00178793          	addi	a5,a5,1
  9c:	00279793          	slli	a5,a5,0x2
  a0:	fdc42703          	lw	a4,-36(s0)
  a4:	00f70733          	add	a4,a4,a5
  a8:	fe842783          	lw	a5,-24(s0)
  ac:	00279793          	slli	a5,a5,0x2
  b0:	fdc42683          	lw	a3,-36(s0)
  b4:	00f687b3          	add	a5,a3,a5
  b8:	00072703          	lw	a4,0(a4)
  bc:	00e7a023          	sw	a4,0(a5)
  c0:	fe842783          	lw	a5,-24(s0)
  c4:	00178793          	addi	a5,a5,1
  c8:	00279793          	slli	a5,a5,0x2
  cc:	fdc42703          	lw	a4,-36(s0)
  d0:	00f707b3          	add	a5,a4,a5
  d4:	fe442703          	lw	a4,-28(s0)
  d8:	00e7a023          	sw	a4,0(a5)
  dc:	fe842783          	lw	a5,-24(s0)
  e0:	00178793          	addi	a5,a5,1
  e4:	fef42423          	sw	a5,-24(s0)
  e8:	f51ff06f          	j	38 <_Z10bubbleSortPii+0x2c>
  ec:	fec42783          	lw	a5,-20(s0)
  f0:	00178793          	addi	a5,a5,1
  f4:	fef42623          	sw	a5,-20(s0)
  f8:	f31ff06f          	j	28 <_Z10bubbleSortPii+0x1c>
  fc:	00000013          	nop
 100:	02c12403          	lw	s0,44(sp)
 104:	03010113          	addi	sp,sp,48
 108:	00008067          	ret

0000010c <main>:
 10c:	fe010113          	addi	sp,sp,-32
 110:	00112e23          	sw	ra,28(sp)
 114:	00812c23          	sw	s0,24(sp)
 118:	00912a23          	sw	s1,20(sp)
 11c:	02010413          	addi	s0,sp,32
 120:	00010513          	mv	a0,sp
 124:	00050493          	mv	s1,a0
 128:	03200513          	li	a0,50
 12c:	fea42423          	sw	a0,-24(s0)
 130:	fe842503          	lw	a0,-24(s0)
 134:	fff50513          	addi	a0,a0,-1
 138:	fea42223          	sw	a0,-28(s0)
 13c:	00050893          	mv	a7,a0
 140:	00188893          	addi	a7,a7,1
 144:	00088313          	mv	t1,a7
 148:	00000393          	li	t2,0
 14c:	01b35893          	srli	a7,t1,0x1b
 150:	00539713          	slli	a4,t2,0x5
 154:	00e8e733          	or	a4,a7,a4
 158:	00531693          	slli	a3,t1,0x5
 15c:	00050713          	mv	a4,a0
 160:	00170713          	addi	a4,a4,1
 164:	00070593          	mv	a1,a4
 168:	00000613          	li	a2,0
 16c:	01b5d713          	srli	a4,a1,0x1b
 170:	00561813          	slli	a6,a2,0x5
 174:	01076833          	or	a6,a4,a6
 178:	00559793          	slli	a5,a1,0x5
 17c:	00050793          	mv	a5,a0
 180:	00178793          	addi	a5,a5,1
 184:	00279793          	slli	a5,a5,0x2
 188:	00378793          	addi	a5,a5,3
 18c:	00f78793          	addi	a5,a5,15
 190:	0047d793          	srli	a5,a5,0x4
 194:	00479793          	slli	a5,a5,0x4
 198:	40f10133          	sub	sp,sp,a5
 19c:	00010793          	mv	a5,sp
 1a0:	00378793          	addi	a5,a5,3
 1a4:	0027d793          	srli	a5,a5,0x2
 1a8:	00279793          	slli	a5,a5,0x2
 1ac:	fef42023          	sw	a5,-32(s0)
 1b0:	fe042623          	sw	zero,-20(s0)
 1b4:	fec42703          	lw	a4,-20(s0)
 1b8:	fe842783          	lw	a5,-24(s0)
 1bc:	02f75a63          	ble	a5,a4,1f0 <main+0xe4>
 1c0:	fe842703          	lw	a4,-24(s0)
 1c4:	fec42783          	lw	a5,-20(s0)
 1c8:	40f70733          	sub	a4,a4,a5
 1cc:	fe042683          	lw	a3,-32(s0)
 1d0:	fec42783          	lw	a5,-20(s0)
 1d4:	00279793          	slli	a5,a5,0x2
 1d8:	00f687b3          	add	a5,a3,a5
 1dc:	00e7a023          	sw	a4,0(a5)
 1e0:	fec42783          	lw	a5,-20(s0)
 1e4:	00178793          	addi	a5,a5,1
 1e8:	fef42623          	sw	a5,-20(s0)
 1ec:	fc9ff06f          	j	1b4 <main+0xa8>
 1f0:	fe042783          	lw	a5,-32(s0)
 1f4:	fe842583          	lw	a1,-24(s0)
 1f8:	00078513          	mv	a0,a5
 1fc:	e11ff0ef          	jal	ra,c <_Z10bubbleSortPii>
 200:	00000793          	li	a5,0
 204:	00048113          	mv	sp,s1
 208:	00078513          	mv	a0,a5
 20c:	fe040113          	addi	sp,s0,-32
 210:	01c12083          	lw	ra,28(sp)
 214:	01812403          	lw	s0,24(sp)
 218:	01412483          	lw	s1,20(sp)
 21c:	02010113          	addi	sp,sp,32
 220:	00008067          	ret
