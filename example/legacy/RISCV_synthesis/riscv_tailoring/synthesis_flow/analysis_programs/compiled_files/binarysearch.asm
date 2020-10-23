
/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/synthesis_flow/analysis_programs/compiled_files/binarysearch.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010137          	lui	sp,0x10
   4:	fff10113          	addi	sp,sp,-1 # ffff <_memEnd>
   8:	110000ef          	jal	ra,118 <main>

0000000c <_end>:
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00100073          	ebreak

00000024 <_Z12binarySearchPiiii>:
  24:	fd010113          	addi	sp,sp,-48
  28:	02112623          	sw	ra,44(sp)
  2c:	02812423          	sw	s0,40(sp)
  30:	03010413          	addi	s0,sp,48
  34:	fca42e23          	sw	a0,-36(s0)
  38:	fcb42c23          	sw	a1,-40(s0)
  3c:	fcc42a23          	sw	a2,-44(s0)
  40:	fcd42823          	sw	a3,-48(s0)
  44:	fd442703          	lw	a4,-44(s0)
  48:	fd842783          	lw	a5,-40(s0)
  4c:	0af74a63          	blt	a4,a5,100 <_Z12binarySearchPiiii+0xdc>
  50:	fd442703          	lw	a4,-44(s0)
  54:	fd842783          	lw	a5,-40(s0)
  58:	40f707b3          	sub	a5,a4,a5
  5c:	01f7d713          	srli	a4,a5,0x1f
  60:	00f707b3          	add	a5,a4,a5
  64:	4017d793          	srai	a5,a5,0x1
  68:	00078713          	mv	a4,a5
  6c:	fd842783          	lw	a5,-40(s0)
  70:	00e787b3          	add	a5,a5,a4
  74:	fef42623          	sw	a5,-20(s0)
  78:	fec42783          	lw	a5,-20(s0)
  7c:	00279793          	slli	a5,a5,0x2
  80:	fdc42703          	lw	a4,-36(s0)
  84:	00f707b3          	add	a5,a4,a5
  88:	0007a783          	lw	a5,0(a5)
  8c:	fd042703          	lw	a4,-48(s0)
  90:	00f71663          	bne	a4,a5,9c <_Z12binarySearchPiiii+0x78>
  94:	fec42783          	lw	a5,-20(s0)
  98:	06c0006f          	j	104 <_Z12binarySearchPiiii+0xe0>
  9c:	fec42783          	lw	a5,-20(s0)
  a0:	00279793          	slli	a5,a5,0x2
  a4:	fdc42703          	lw	a4,-36(s0)
  a8:	00f707b3          	add	a5,a4,a5
  ac:	0007a783          	lw	a5,0(a5)
  b0:	fd042703          	lw	a4,-48(s0)
  b4:	02f75463          	ble	a5,a4,dc <_Z12binarySearchPiiii+0xb8>
  b8:	fec42783          	lw	a5,-20(s0)
  bc:	fff78793          	addi	a5,a5,-1
  c0:	fd042683          	lw	a3,-48(s0)
  c4:	00078613          	mv	a2,a5
  c8:	fd842583          	lw	a1,-40(s0)
  cc:	fdc42503          	lw	a0,-36(s0)
  d0:	f55ff0ef          	jal	ra,24 <_Z12binarySearchPiiii>
  d4:	00050793          	mv	a5,a0
  d8:	02c0006f          	j	104 <_Z12binarySearchPiiii+0xe0>
  dc:	fec42783          	lw	a5,-20(s0)
  e0:	00178793          	addi	a5,a5,1
  e4:	fd042683          	lw	a3,-48(s0)
  e8:	fd442603          	lw	a2,-44(s0)
  ec:	00078593          	mv	a1,a5
  f0:	fdc42503          	lw	a0,-36(s0)
  f4:	f31ff0ef          	jal	ra,24 <_Z12binarySearchPiiii>
  f8:	00050793          	mv	a5,a0
  fc:	0080006f          	j	104 <_Z12binarySearchPiiii+0xe0>
 100:	fff00793          	li	a5,-1
 104:	00078513          	mv	a0,a5
 108:	02c12083          	lw	ra,44(sp)
 10c:	02812403          	lw	s0,40(sp)
 110:	03010113          	addi	sp,sp,48
 114:	00008067          	ret

00000118 <main>:
 118:	fd010113          	addi	sp,sp,-48
 11c:	02112623          	sw	ra,44(sp)
 120:	02812423          	sw	s0,40(sp)
 124:	02912223          	sw	s1,36(sp)
 128:	03010413          	addi	s0,sp,48
 12c:	00010513          	mv	a0,sp
 130:	00050493          	mv	s1,a0
 134:	03200513          	li	a0,50
 138:	fea42423          	sw	a0,-24(s0)
 13c:	fe842503          	lw	a0,-24(s0)
 140:	fff50513          	addi	a0,a0,-1
 144:	fea42223          	sw	a0,-28(s0)
 148:	00050893          	mv	a7,a0
 14c:	00188893          	addi	a7,a7,1
 150:	00088313          	mv	t1,a7
 154:	00000393          	li	t2,0
 158:	01b35893          	srli	a7,t1,0x1b
 15c:	00539713          	slli	a4,t2,0x5
 160:	00e8e733          	or	a4,a7,a4
 164:	00531693          	slli	a3,t1,0x5
 168:	00050713          	mv	a4,a0
 16c:	00170713          	addi	a4,a4,1
 170:	00070593          	mv	a1,a4
 174:	00000613          	li	a2,0
 178:	01b5d713          	srli	a4,a1,0x1b
 17c:	00561813          	slli	a6,a2,0x5
 180:	01076833          	or	a6,a4,a6
 184:	00559793          	slli	a5,a1,0x5
 188:	00050793          	mv	a5,a0
 18c:	00178793          	addi	a5,a5,1
 190:	00279793          	slli	a5,a5,0x2
 194:	00378793          	addi	a5,a5,3
 198:	00f78793          	addi	a5,a5,15
 19c:	0047d793          	srli	a5,a5,0x4
 1a0:	00479793          	slli	a5,a5,0x4
 1a4:	40f10133          	sub	sp,sp,a5
 1a8:	00010793          	mv	a5,sp
 1ac:	00378793          	addi	a5,a5,3
 1b0:	0027d793          	srli	a5,a5,0x2
 1b4:	00279793          	slli	a5,a5,0x2
 1b8:	fef42023          	sw	a5,-32(s0)
 1bc:	fe042623          	sw	zero,-20(s0)
 1c0:	fec42703          	lw	a4,-20(s0)
 1c4:	fe842783          	lw	a5,-24(s0)
 1c8:	02f75663          	ble	a5,a4,1f4 <main+0xdc>
 1cc:	fe042703          	lw	a4,-32(s0)
 1d0:	fec42783          	lw	a5,-20(s0)
 1d4:	00279793          	slli	a5,a5,0x2
 1d8:	00f707b3          	add	a5,a4,a5
 1dc:	fe842703          	lw	a4,-24(s0)
 1e0:	00e7a023          	sw	a4,0(a5)
 1e4:	fec42783          	lw	a5,-20(s0)
 1e8:	00178793          	addi	a5,a5,1
 1ec:	fef42623          	sw	a5,-20(s0)
 1f0:	fd1ff06f          	j	1c0 <main+0xa8>
 1f4:	00a00793          	li	a5,10
 1f8:	fcf42e23          	sw	a5,-36(s0)
 1fc:	fe042703          	lw	a4,-32(s0)
 200:	fe842783          	lw	a5,-24(s0)
 204:	fff78793          	addi	a5,a5,-1
 208:	fdc42683          	lw	a3,-36(s0)
 20c:	00078613          	mv	a2,a5
 210:	00000593          	li	a1,0
 214:	00070513          	mv	a0,a4
 218:	e0dff0ef          	jal	ra,24 <_Z12binarySearchPiiii>
 21c:	00050793          	mv	a5,a0
 220:	fcf42c23          	sw	a5,-40(s0)
 224:	00000793          	li	a5,0
 228:	00048113          	mv	sp,s1
 22c:	00078513          	mv	a0,a5
 230:	fd040113          	addi	sp,s0,-48
 234:	02c12083          	lw	ra,44(sp)
 238:	02812403          	lw	s0,40(sp)
 23c:	02412483          	lw	s1,36(sp)
 240:	03010113          	addi	sp,sp,48
 244:	00008067          	ret
