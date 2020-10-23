
PrintMessage.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
       0:	00002fb7          	lui	t6,0x2
       4:	800f8f93          	addi	t6,t6,-2048 # 1800 <__umoddi3+0x25c>
       8:	300f9073          	csrw	mstatus,t6
       c:	0340006f          	j	40 <_mstart>
      10:	00000013          	nop
      14:	00000013          	nop
      18:	00000013          	nop
      1c:	00000013          	nop
      20:	00000013          	nop
      24:	00000013          	nop
      28:	00000013          	nop
      2c:	00000013          	nop
      30:	00000013          	nop
      34:	00000013          	nop
      38:	00000013          	nop
      3c:	00000013          	nop

00000040 <_mstart>:
      40:	00000297          	auipc	t0,0x0
      44:	11c28293          	addi	t0,t0,284 # 15c <trap_entry>
      48:	30529073          	csrw	mtvec,t0
      4c:	00000093          	li	ra,0
      50:	00000113          	li	sp,0
      54:	00000193          	li	gp,0
      58:	00000213          	li	tp,0
      5c:	00000293          	li	t0,0
      60:	00000313          	li	t1,0
      64:	00000393          	li	t2,0
      68:	00000413          	li	s0,0
      6c:	00000493          	li	s1,0
      70:	00000513          	li	a0,0
      74:	00000593          	li	a1,0
      78:	00000613          	li	a2,0
      7c:	00000693          	li	a3,0
      80:	00000713          	li	a4,0
      84:	00000793          	li	a5,0
      88:	00000813          	li	a6,0
      8c:	00000893          	li	a7,0
      90:	00000913          	li	s2,0
      94:	00000993          	li	s3,0
      98:	00000a13          	li	s4,0
      9c:	00000a93          	li	s5,0
      a0:	00000b13          	li	s6,0
      a4:	00000b93          	li	s7,0
      a8:	00000c13          	li	s8,0
      ac:	00000c93          	li	s9,0
      b0:	00000d13          	li	s10,0
      b4:	00000d93          	li	s11,0
      b8:	00000e13          	li	t3,0
      bc:	00000e93          	li	t4,0
      c0:	00000f13          	li	t5,0
      c4:	00000f93          	li	t6,0
      c8:	00021197          	auipc	gp,0x21
      cc:	ab418193          	addi	gp,gp,-1356 # 20b7c <_gp>

000000d0 <init_bss>:
      d0:	00020517          	auipc	a0,0x20
      d4:	2b050513          	addi	a0,a0,688 # 20380 <__bss_start>
      d8:	00020597          	auipc	a1,0x20
      dc:	36c58593          	addi	a1,a1,876 # 20444 <tohost+0x4>
      e0:	00000613          	li	a2,0
      e4:	1a8000ef          	jal	ra,28c <fill_block>

000000e8 <init_sbss>:
      e8:	00020517          	auipc	a0,0x20
      ec:	29450513          	addi	a0,a0,660 # 2037c <__data_end>
      f0:	00020597          	auipc	a1,0x20
      f4:	28858593          	addi	a1,a1,648 # 20378 <__rodata_end+0xb4>
      f8:	00000613          	li	a2,0
      fc:	190000ef          	jal	ra,28c <fill_block>

00000100 <write_stack_pattern>:
     100:	00021517          	auipc	a0,0x21
     104:	34850513          	addi	a0,a0,840 # 21448 <_heap_end>
     108:	00022597          	auipc	a1,0x22
     10c:	33c58593          	addi	a1,a1,828 # 22444 <_heap_end+0xffc>
     110:	ababb637          	lui	a2,0xababb
     114:	bab60613          	addi	a2,a2,-1109 # abababab <__stack+0xaba98763>
     118:	174000ef          	jal	ra,28c <fill_block>

0000011c <init_stack>:
     11c:	00022117          	auipc	sp,0x22
     120:	32c10113          	addi	sp,sp,812 # 22448 <__stack>
     124:	00000313          	li	t1,0
     128:	30431073          	csrw	mie,t1
     12c:	30005073          	csrwi	mstatus,0
     130:	3ac0006f          	j	4dc <vSyscallInit>

00000134 <interrupt>:
     134:	00129293          	slli	t0,t0,0x1
     138:	0012d293          	srli	t0,t0,0x1
     13c:	ffd28293          	addi	t0,t0,-3
     140:	00028863          	beqz	t0,150 <softwareInterrupt>
     144:	00012283          	lw	t0,0(sp)
     148:	00410113          	addi	sp,sp,4
     14c:	30200073          	mret

00000150 <softwareInterrupt>:
     150:	00012283          	lw	t0,0(sp)
     154:	00410113          	addi	sp,sp,4
     158:	30200073          	mret

0000015c <trap_entry>:
     15c:	ffc10113          	addi	sp,sp,-4
     160:	00512023          	sw	t0,0(sp)
     164:	342022f3          	csrr	t0,mcause
     168:	fc02c6e3          	bltz	t0,134 <interrupt>
     16c:	00012283          	lw	t0,0(sp)
     170:	00410113          	addi	sp,sp,4
     174:	f8010113          	addi	sp,sp,-128
     178:	00112223          	sw	ra,4(sp)
     17c:	00212423          	sw	sp,8(sp)
     180:	00312623          	sw	gp,12(sp)
     184:	00412823          	sw	tp,16(sp)
     188:	00512a23          	sw	t0,20(sp)
     18c:	00612c23          	sw	t1,24(sp)
     190:	00712e23          	sw	t2,28(sp)
     194:	02812023          	sw	s0,32(sp)
     198:	02912223          	sw	s1,36(sp)
     19c:	02a12423          	sw	a0,40(sp)
     1a0:	02b12623          	sw	a1,44(sp)
     1a4:	02c12823          	sw	a2,48(sp)
     1a8:	02d12a23          	sw	a3,52(sp)
     1ac:	02e12c23          	sw	a4,56(sp)
     1b0:	02f12e23          	sw	a5,60(sp)
     1b4:	05012023          	sw	a6,64(sp)
     1b8:	05112223          	sw	a7,68(sp)
     1bc:	05212423          	sw	s2,72(sp)
     1c0:	05312623          	sw	s3,76(sp)
     1c4:	05412823          	sw	s4,80(sp)
     1c8:	05512a23          	sw	s5,84(sp)
     1cc:	05612c23          	sw	s6,88(sp)
     1d0:	05712e23          	sw	s7,92(sp)
     1d4:	07812023          	sw	s8,96(sp)
     1d8:	07912223          	sw	s9,100(sp)
     1dc:	07a12423          	sw	s10,104(sp)
     1e0:	07b12623          	sw	s11,108(sp)
     1e4:	07c12823          	sw	t3,112(sp)
     1e8:	07d12a23          	sw	t4,116(sp)
     1ec:	07e12c23          	sw	t5,120(sp)
     1f0:	07f12e23          	sw	t6,124(sp)
     1f4:	34202573          	csrr	a0,mcause
     1f8:	341025f3          	csrr	a1,mepc
     1fc:	00010613          	mv	a2,sp
     200:	30c000ef          	jal	ra,50c <ulSyscallTrap>
     204:	34151073          	csrw	mepc,a0
     208:	00412083          	lw	ra,4(sp)
     20c:	00812103          	lw	sp,8(sp)
     210:	00c12183          	lw	gp,12(sp)
     214:	01012203          	lw	tp,16(sp)
     218:	01412283          	lw	t0,20(sp)
     21c:	01812303          	lw	t1,24(sp)
     220:	01c12383          	lw	t2,28(sp)
     224:	02012403          	lw	s0,32(sp)
     228:	02412483          	lw	s1,36(sp)
     22c:	02812503          	lw	a0,40(sp)
     230:	02c12583          	lw	a1,44(sp)
     234:	03012603          	lw	a2,48(sp)
     238:	03412683          	lw	a3,52(sp)
     23c:	03812703          	lw	a4,56(sp)
     240:	03c12783          	lw	a5,60(sp)
     244:	04012803          	lw	a6,64(sp)
     248:	04412883          	lw	a7,68(sp)
     24c:	04812903          	lw	s2,72(sp)
     250:	04c12983          	lw	s3,76(sp)
     254:	05012a03          	lw	s4,80(sp)
     258:	05412a83          	lw	s5,84(sp)
     25c:	05812b03          	lw	s6,88(sp)
     260:	05c12b83          	lw	s7,92(sp)
     264:	06012c03          	lw	s8,96(sp)
     268:	06412c83          	lw	s9,100(sp)
     26c:	06812d03          	lw	s10,104(sp)
     270:	06c12d83          	lw	s11,108(sp)
     274:	07012e03          	lw	t3,112(sp)
     278:	07412e83          	lw	t4,116(sp)
     27c:	07812f03          	lw	t5,120(sp)
     280:	07c12f83          	lw	t6,124(sp)
     284:	08010113          	addi	sp,sp,128
     288:	30200073          	mret

0000028c <fill_block>:
     28c:	00c52023          	sw	a2,0(a0)
     290:	00b57663          	bleu	a1,a0,29c <fb_end>
     294:	00450513          	addi	a0,a0,4
     298:	ff5ff06f          	j	28c <fill_block>

0000029c <fb_end>:
     29c:	00008067          	ret
	...

000002b4 <zeroExtend>:
     2b4:	fe010113          	addi	sp,sp,-32
     2b8:	00a12623          	sw	a0,12(sp)
     2bc:	00c12783          	lw	a5,12(sp)
     2c0:	00f12c23          	sw	a5,24(sp)
     2c4:	41f7d793          	srai	a5,a5,0x1f
     2c8:	00f12e23          	sw	a5,28(sp)
     2cc:	00c12783          	lw	a5,12(sp)
     2d0:	00f12c23          	sw	a5,24(sp)
     2d4:	00012e23          	sw	zero,28(sp)
     2d8:	01812783          	lw	a5,24(sp)
     2dc:	01c12803          	lw	a6,28(sp)
     2e0:	00078513          	mv	a0,a5
     2e4:	00080593          	mv	a1,a6
     2e8:	02010113          	addi	sp,sp,32
     2ec:	00008067          	ret

000002f0 <prvSyscallToHost>:
     2f0:	f6010113          	addi	sp,sp,-160
     2f4:	08112e23          	sw	ra,156(sp)
     2f8:	08812c23          	sw	s0,152(sp)
     2fc:	00a12623          	sw	a0,12(sp)
     300:	00b12423          	sw	a1,8(sp)
     304:	00c12223          	sw	a2,4(sp)
     308:	00d12023          	sw	a3,0(sp)
     30c:	09010793          	addi	a5,sp,144
     310:	f8078793          	addi	a5,a5,-128
     314:	03f78793          	addi	a5,a5,63
     318:	0067d793          	srli	a5,a5,0x6
     31c:	00679413          	slli	s0,a5,0x6
     320:	00c12503          	lw	a0,12(sp)
     324:	f91ff0ef          	jal	ra,2b4 <zeroExtend>
     328:	00050793          	mv	a5,a0
     32c:	00058813          	mv	a6,a1
     330:	00f42023          	sw	a5,0(s0)
     334:	01042223          	sw	a6,4(s0)
     338:	00812503          	lw	a0,8(sp)
     33c:	f79ff0ef          	jal	ra,2b4 <zeroExtend>
     340:	00050793          	mv	a5,a0
     344:	00058813          	mv	a6,a1
     348:	00f42423          	sw	a5,8(s0)
     34c:	01042623          	sw	a6,12(s0)
     350:	00412503          	lw	a0,4(sp)
     354:	f61ff0ef          	jal	ra,2b4 <zeroExtend>
     358:	00050793          	mv	a5,a0
     35c:	00058813          	mv	a6,a1
     360:	00f42823          	sw	a5,16(s0)
     364:	01042a23          	sw	a6,20(s0)
     368:	00012503          	lw	a0,0(sp)
     36c:	f49ff0ef          	jal	ra,2b4 <zeroExtend>
     370:	00050793          	mv	a5,a0
     374:	00058813          	mv	a6,a1
     378:	00f42c23          	sw	a5,24(s0)
     37c:	01042e23          	sw	a6,28(s0)
     380:	0ff0000f          	fence
     384:	00040793          	mv	a5,s0
     388:	00078513          	mv	a0,a5
     38c:	f29ff0ef          	jal	ra,2b4 <zeroExtend>
     390:	00050793          	mv	a5,a0
     394:	00058813          	mv	a6,a1
     398:	00020717          	auipc	a4,0x20
     39c:	0a870713          	addi	a4,a4,168 # 20440 <tohost>
     3a0:	00f72023          	sw	a5,0(a4)
     3a4:	01072223          	sw	a6,4(a4)
     3a8:	00042783          	lw	a5,0(s0)
     3ac:	00442803          	lw	a6,4(s0)
     3b0:	00078513          	mv	a0,a5
     3b4:	00080593          	mv	a1,a6
     3b8:	09c12083          	lw	ra,156(sp)
     3bc:	09812403          	lw	s0,152(sp)
     3c0:	0a010113          	addi	sp,sp,160
     3c4:	00008067          	ret

000003c8 <prvSyscallExit>:
     3c8:	fc010113          	addi	sp,sp,-64
     3cc:	02112e23          	sw	ra,60(sp)
     3d0:	02812c23          	sw	s0,56(sp)
     3d4:	02912a23          	sw	s1,52(sp)
     3d8:	03212823          	sw	s2,48(sp)
     3dc:	03312623          	sw	s3,44(sp)
     3e0:	00a12623          	sw	a0,12(sp)
     3e4:	00c12503          	lw	a0,12(sp)
     3e8:	ecdff0ef          	jal	ra,2b4 <zeroExtend>
     3ec:	00a12c23          	sw	a0,24(sp)
     3f0:	00b12e23          	sw	a1,28(sp)
     3f4:	01812783          	lw	a5,24(sp)
     3f8:	01f7d793          	srli	a5,a5,0x1f
     3fc:	01c12703          	lw	a4,28(sp)
     400:	00171493          	slli	s1,a4,0x1
     404:	0097e4b3          	or	s1,a5,s1
     408:	01812783          	lw	a5,24(sp)
     40c:	00179413          	slli	s0,a5,0x1
     410:	00146913          	ori	s2,s0,1
     414:	0004e993          	ori	s3,s1,0
     418:	00020797          	auipc	a5,0x20
     41c:	02878793          	addi	a5,a5,40 # 20440 <tohost>
     420:	0127a023          	sw	s2,0(a5)
     424:	0137a223          	sw	s3,4(a5)
     428:	0000006f          	j	428 <prvSyscallExit+0x60>

0000042c <printstr>:
     42c:	fe010113          	addi	sp,sp,-32
     430:	00112e23          	sw	ra,28(sp)
     434:	00812c23          	sw	s0,24(sp)
     438:	00a12623          	sw	a0,12(sp)
     43c:	00c12403          	lw	s0,12(sp)
     440:	00c12503          	lw	a0,12(sp)
     444:	345000ef          	jal	ra,f88 <strlen>
     448:	00050793          	mv	a5,a0
     44c:	00078693          	mv	a3,a5
     450:	00040613          	mv	a2,s0
     454:	00100593          	li	a1,1
     458:	04000513          	li	a0,64
     45c:	018000ef          	jal	ra,474 <syscall>
     460:	00000013          	nop
     464:	01c12083          	lw	ra,28(sp)
     468:	01812403          	lw	s0,24(sp)
     46c:	02010113          	addi	sp,sp,32
     470:	00008067          	ret

00000474 <syscall>:
     474:	ff010113          	addi	sp,sp,-16
     478:	00a12623          	sw	a0,12(sp)
     47c:	00b12423          	sw	a1,8(sp)
     480:	00c12223          	sw	a2,4(sp)
     484:	00d12023          	sw	a3,0(sp)
     488:	00c12883          	lw	a7,12(sp)
     48c:	00812503          	lw	a0,8(sp)
     490:	00412583          	lw	a1,4(sp)
     494:	00012603          	lw	a2,0(sp)
     498:	00000073          	ecall
     49c:	00050793          	mv	a5,a0
     4a0:	00078513          	mv	a0,a5
     4a4:	01010113          	addi	sp,sp,16
     4a8:	00008067          	ret
     4ac:	fe010113          	addi	sp,sp,-32
     4b0:	00112e23          	sw	ra,28(sp)
     4b4:	00a12623          	sw	a0,12(sp)
     4b8:	00b12423          	sw	a1,8(sp)
     4bc:	00020517          	auipc	a0,0x20
     4c0:	b4450513          	addi	a0,a0,-1212 # 20000 <__rodata_start>
     4c4:	f69ff0ef          	jal	ra,42c <printstr>
     4c8:	fff00793          	li	a5,-1
     4cc:	00078513          	mv	a0,a5
     4d0:	01c12083          	lw	ra,28(sp)
     4d4:	02010113          	addi	sp,sp,32
     4d8:	00008067          	ret

000004dc <vSyscallInit>:
     4dc:	fe010113          	addi	sp,sp,-32
     4e0:	00112e23          	sw	ra,28(sp)
     4e4:	00000593          	li	a1,0
     4e8:	00000513          	li	a0,0
     4ec:	259000ef          	jal	ra,f44 <main>
     4f0:	00a12623          	sw	a0,12(sp)
     4f4:	00c12503          	lw	a0,12(sp)
     4f8:	079000ef          	jal	ra,d70 <exit>
     4fc:	00000013          	nop
     500:	01c12083          	lw	ra,28(sp)
     504:	02010113          	addi	sp,sp,32
     508:	00008067          	ret

0000050c <ulSyscallTrap>:
     50c:	fd010113          	addi	sp,sp,-48
     510:	02112623          	sw	ra,44(sp)
     514:	00a12623          	sw	a0,12(sp)
     518:	00b12423          	sw	a1,8(sp)
     51c:	00c12223          	sw	a2,4(sp)
     520:	00012e23          	sw	zero,28(sp)
     524:	00c12703          	lw	a4,12(sp)
     528:	00b00793          	li	a5,11
     52c:	00f70863          	beq	a4,a5,53c <ulSyscallTrap+0x30>
     530:	00c12503          	lw	a0,12(sp)
     534:	e95ff0ef          	jal	ra,3c8 <prvSyscallExit>
     538:	0780006f          	j	5b0 <ulSyscallTrap+0xa4>
     53c:	00412783          	lw	a5,4(sp)
     540:	04478793          	addi	a5,a5,68
     544:	0007a703          	lw	a4,0(a5)
     548:	05d00793          	li	a5,93
     54c:	00f71e63          	bne	a4,a5,568 <ulSyscallTrap+0x5c>
     550:	00412783          	lw	a5,4(sp)
     554:	02878793          	addi	a5,a5,40
     558:	0007a783          	lw	a5,0(a5)
     55c:	00078513          	mv	a0,a5
     560:	e69ff0ef          	jal	ra,3c8 <prvSyscallExit>
     564:	04c0006f          	j	5b0 <ulSyscallTrap+0xa4>
     568:	00412783          	lw	a5,4(sp)
     56c:	04478793          	addi	a5,a5,68
     570:	0007a703          	lw	a4,0(a5)
     574:	00412783          	lw	a5,4(sp)
     578:	02878793          	addi	a5,a5,40
     57c:	0007a583          	lw	a1,0(a5)
     580:	00412783          	lw	a5,4(sp)
     584:	02c78793          	addi	a5,a5,44
     588:	0007a603          	lw	a2,0(a5)
     58c:	00412783          	lw	a5,4(sp)
     590:	03078793          	addi	a5,a5,48
     594:	0007a783          	lw	a5,0(a5)
     598:	00078693          	mv	a3,a5
     59c:	00070513          	mv	a0,a4
     5a0:	d51ff0ef          	jal	ra,2f0 <prvSyscallToHost>
     5a4:	00050793          	mv	a5,a0
     5a8:	00058813          	mv	a6,a1
     5ac:	00f12e23          	sw	a5,28(sp)
     5b0:	00412783          	lw	a5,4(sp)
     5b4:	02878793          	addi	a5,a5,40
     5b8:	01c12703          	lw	a4,28(sp)
     5bc:	00e7a023          	sw	a4,0(a5)
     5c0:	00812783          	lw	a5,8(sp)
     5c4:	00478793          	addi	a5,a5,4
     5c8:	00078513          	mv	a0,a5
     5cc:	02c12083          	lw	ra,44(sp)
     5d0:	03010113          	addi	sp,sp,48
     5d4:	00008067          	ret

000005d8 <putchar>:
     5d8:	fe010113          	addi	sp,sp,-32
     5dc:	00112e23          	sw	ra,28(sp)
     5e0:	00a12623          	sw	a0,12(sp)
     5e4:	00020797          	auipc	a5,0x20
     5e8:	d9c78793          	addi	a5,a5,-612 # 20380 <__bss_start>
     5ec:	0007a783          	lw	a5,0(a5)
     5f0:	00178693          	addi	a3,a5,1
     5f4:	00020717          	auipc	a4,0x20
     5f8:	d8c70713          	addi	a4,a4,-628 # 20380 <__bss_start>
     5fc:	00d72023          	sw	a3,0(a4)
     600:	00c12703          	lw	a4,12(sp)
     604:	0ff77713          	andi	a4,a4,255
     608:	00020697          	auipc	a3,0x20
     60c:	db868693          	addi	a3,a3,-584 # 203c0 <buf.2126>
     610:	00f687b3          	add	a5,a3,a5
     614:	00e78023          	sb	a4,0(a5)
     618:	00c12703          	lw	a4,12(sp)
     61c:	00a00793          	li	a5,10
     620:	00f70c63          	beq	a4,a5,638 <putchar+0x60>
     624:	00020797          	auipc	a5,0x20
     628:	d5c78793          	addi	a5,a5,-676 # 20380 <__bss_start>
     62c:	0007a703          	lw	a4,0(a5)
     630:	04000793          	li	a5,64
     634:	02f71c63          	bne	a4,a5,66c <putchar+0x94>
     638:	00020717          	auipc	a4,0x20
     63c:	d8870713          	addi	a4,a4,-632 # 203c0 <buf.2126>
     640:	00020797          	auipc	a5,0x20
     644:	d4078793          	addi	a5,a5,-704 # 20380 <__bss_start>
     648:	0007a783          	lw	a5,0(a5)
     64c:	00078693          	mv	a3,a5
     650:	00070613          	mv	a2,a4
     654:	00100593          	li	a1,1
     658:	04000513          	li	a0,64
     65c:	e19ff0ef          	jal	ra,474 <syscall>
     660:	00020797          	auipc	a5,0x20
     664:	d2078793          	addi	a5,a5,-736 # 20380 <__bss_start>
     668:	0007a023          	sw	zero,0(a5)
     66c:	00000793          	li	a5,0
     670:	00078513          	mv	a0,a5
     674:	01c12083          	lw	ra,28(sp)
     678:	02010113          	addi	sp,sp,32
     67c:	00008067          	ret

00000680 <printnum>:
     680:	eb010113          	addi	sp,sp,-336
     684:	14112623          	sw	ra,332(sp)
     688:	14812423          	sw	s0,328(sp)
     68c:	14912223          	sw	s1,324(sp)
     690:	15212023          	sw	s2,320(sp)
     694:	13312e23          	sw	s3,316(sp)
     698:	13412c23          	sw	s4,312(sp)
     69c:	13512a23          	sw	s5,308(sp)
     6a0:	00a12e23          	sw	a0,28(sp)
     6a4:	00b12c23          	sw	a1,24(sp)
     6a8:	00c12823          	sw	a2,16(sp)
     6ac:	00d12a23          	sw	a3,20(sp)
     6b0:	00e12623          	sw	a4,12(sp)
     6b4:	00f12423          	sw	a5,8(sp)
     6b8:	01012223          	sw	a6,4(sp)
     6bc:	12012623          	sw	zero,300(sp)
     6c0:	00c12783          	lw	a5,12(sp)
     6c4:	00078a13          	mv	s4,a5
     6c8:	00000a93          	li	s5,0
     6cc:	01012783          	lw	a5,16(sp)
     6d0:	01412803          	lw	a6,20(sp)
     6d4:	000a0613          	mv	a2,s4
     6d8:	000a8693          	mv	a3,s5
     6dc:	00078513          	mv	a0,a5
     6e0:	00080593          	mv	a1,a6
     6e4:	6c1000ef          	jal	ra,15a4 <__umoddi3>
     6e8:	00050793          	mv	a5,a0
     6ec:	00058813          	mv	a6,a1
     6f0:	00078613          	mv	a2,a5
     6f4:	00080693          	mv	a3,a6
     6f8:	12c12783          	lw	a5,300(sp)
     6fc:	00178713          	addi	a4,a5,1
     700:	12e12623          	sw	a4,300(sp)
     704:	00060713          	mv	a4,a2
     708:	00279793          	slli	a5,a5,0x2
     70c:	13010693          	addi	a3,sp,304
     710:	00f687b3          	add	a5,a3,a5
     714:	eee7ae23          	sw	a4,-260(a5)
     718:	00c12783          	lw	a5,12(sp)
     71c:	00078413          	mv	s0,a5
     720:	00000493          	li	s1,0
     724:	01412783          	lw	a5,20(sp)
     728:	00048713          	mv	a4,s1
     72c:	04e7e863          	bltu	a5,a4,77c <printnum+0xfc>
     730:	01412783          	lw	a5,20(sp)
     734:	00048713          	mv	a4,s1
     738:	00e79863          	bne	a5,a4,748 <printnum+0xc8>
     73c:	01012783          	lw	a5,16(sp)
     740:	00040713          	mv	a4,s0
     744:	02e7ec63          	bltu	a5,a4,77c <printnum+0xfc>
     748:	00c12783          	lw	a5,12(sp)
     74c:	00078913          	mv	s2,a5
     750:	00000993          	li	s3,0
     754:	00090613          	mv	a2,s2
     758:	00098693          	mv	a3,s3
     75c:	01012503          	lw	a0,16(sp)
     760:	01412583          	lw	a1,20(sp)
     764:	065000ef          	jal	ra,fc8 <__udivdi3>
     768:	00050793          	mv	a5,a0
     76c:	00058813          	mv	a6,a1
     770:	00f12823          	sw	a5,16(sp)
     774:	01012a23          	sw	a6,20(sp)
     778:	f49ff06f          	j	6c0 <printnum+0x40>
     77c:	00000013          	nop
     780:	0140006f          	j	794 <printnum+0x114>
     784:	01c12783          	lw	a5,28(sp)
     788:	01812583          	lw	a1,24(sp)
     78c:	00412503          	lw	a0,4(sp)
     790:	000780e7          	jalr	a5
     794:	00812783          	lw	a5,8(sp)
     798:	fff78713          	addi	a4,a5,-1
     79c:	00e12423          	sw	a4,8(sp)
     7a0:	12c12703          	lw	a4,300(sp)
     7a4:	fef740e3          	blt	a4,a5,784 <printnum+0x104>
     7a8:	0540006f          	j	7fc <printnum+0x17c>
     7ac:	12c12783          	lw	a5,300(sp)
     7b0:	00279793          	slli	a5,a5,0x2
     7b4:	13010713          	addi	a4,sp,304
     7b8:	00f707b3          	add	a5,a4,a5
     7bc:	efc7a703          	lw	a4,-260(a5)
     7c0:	12c12783          	lw	a5,300(sp)
     7c4:	00279793          	slli	a5,a5,0x2
     7c8:	13010693          	addi	a3,sp,304
     7cc:	00f687b3          	add	a5,a3,a5
     7d0:	efc7a683          	lw	a3,-260(a5)
     7d4:	00900793          	li	a5,9
     7d8:	00d7f663          	bleu	a3,a5,7e4 <printnum+0x164>
     7dc:	05700793          	li	a5,87
     7e0:	0080006f          	j	7e8 <printnum+0x168>
     7e4:	03000793          	li	a5,48
     7e8:	00e787b3          	add	a5,a5,a4
     7ec:	01c12703          	lw	a4,28(sp)
     7f0:	01812583          	lw	a1,24(sp)
     7f4:	00078513          	mv	a0,a5
     7f8:	000700e7          	jalr	a4
     7fc:	12c12783          	lw	a5,300(sp)
     800:	fff78713          	addi	a4,a5,-1
     804:	12e12623          	sw	a4,300(sp)
     808:	faf042e3          	bgtz	a5,7ac <printnum+0x12c>
     80c:	00000013          	nop
     810:	14c12083          	lw	ra,332(sp)
     814:	14812403          	lw	s0,328(sp)
     818:	14412483          	lw	s1,324(sp)
     81c:	14012903          	lw	s2,320(sp)
     820:	13c12983          	lw	s3,316(sp)
     824:	13812a03          	lw	s4,312(sp)
     828:	13412a83          	lw	s5,308(sp)
     82c:	15010113          	addi	sp,sp,336
     830:	00008067          	ret

00000834 <getuint>:
     834:	ff010113          	addi	sp,sp,-16
     838:	00a12623          	sw	a0,12(sp)
     83c:	00b12423          	sw	a1,8(sp)
     840:	00812683          	lw	a3,8(sp)
     844:	00100713          	li	a4,1
     848:	02d75663          	ble	a3,a4,874 <getuint+0x40>
     84c:	00c12783          	lw	a5,12(sp)
     850:	0007a783          	lw	a5,0(a5)
     854:	00778793          	addi	a5,a5,7
     858:	ff87f793          	andi	a5,a5,-8
     85c:	00878693          	addi	a3,a5,8
     860:	00c12703          	lw	a4,12(sp)
     864:	00d72023          	sw	a3,0(a4)
     868:	0047a803          	lw	a6,4(a5)
     86c:	0007a783          	lw	a5,0(a5)
     870:	0500006f          	j	8c0 <getuint+0x8c>
     874:	00812703          	lw	a4,8(sp)
     878:	02070463          	beqz	a4,8a0 <getuint+0x6c>
     87c:	00c12703          	lw	a4,12(sp)
     880:	00072703          	lw	a4,0(a4)
     884:	00470613          	addi	a2,a4,4
     888:	00c12683          	lw	a3,12(sp)
     88c:	00c6a023          	sw	a2,0(a3)
     890:	00072703          	lw	a4,0(a4)
     894:	00070793          	mv	a5,a4
     898:	00000813          	li	a6,0
     89c:	0240006f          	j	8c0 <getuint+0x8c>
     8a0:	00c12703          	lw	a4,12(sp)
     8a4:	00072703          	lw	a4,0(a4)
     8a8:	00470613          	addi	a2,a4,4
     8ac:	00c12683          	lw	a3,12(sp)
     8b0:	00c6a023          	sw	a2,0(a3)
     8b4:	00072703          	lw	a4,0(a4)
     8b8:	00070793          	mv	a5,a4
     8bc:	00000813          	li	a6,0
     8c0:	00078513          	mv	a0,a5
     8c4:	00080593          	mv	a1,a6
     8c8:	01010113          	addi	sp,sp,16
     8cc:	00008067          	ret

000008d0 <getint>:
     8d0:	ff010113          	addi	sp,sp,-16
     8d4:	00a12623          	sw	a0,12(sp)
     8d8:	00b12423          	sw	a1,8(sp)
     8dc:	00812683          	lw	a3,8(sp)
     8e0:	00100713          	li	a4,1
     8e4:	02d75663          	ble	a3,a4,910 <getint+0x40>
     8e8:	00c12783          	lw	a5,12(sp)
     8ec:	0007a783          	lw	a5,0(a5)
     8f0:	00778793          	addi	a5,a5,7
     8f4:	ff87f793          	andi	a5,a5,-8
     8f8:	00878693          	addi	a3,a5,8
     8fc:	00c12703          	lw	a4,12(sp)
     900:	00d72023          	sw	a3,0(a4)
     904:	0047a803          	lw	a6,4(a5)
     908:	0007a783          	lw	a5,0(a5)
     90c:	0580006f          	j	964 <getint+0x94>
     910:	00812703          	lw	a4,8(sp)
     914:	02070663          	beqz	a4,940 <getint+0x70>
     918:	00c12703          	lw	a4,12(sp)
     91c:	00072703          	lw	a4,0(a4)
     920:	00470613          	addi	a2,a4,4
     924:	00c12683          	lw	a3,12(sp)
     928:	00c6a023          	sw	a2,0(a3)
     92c:	00072703          	lw	a4,0(a4)
     930:	00070793          	mv	a5,a4
     934:	41f75713          	srai	a4,a4,0x1f
     938:	00070813          	mv	a6,a4
     93c:	0280006f          	j	964 <getint+0x94>
     940:	00c12703          	lw	a4,12(sp)
     944:	00072703          	lw	a4,0(a4)
     948:	00470613          	addi	a2,a4,4
     94c:	00c12683          	lw	a3,12(sp)
     950:	00c6a023          	sw	a2,0(a3)
     954:	00072703          	lw	a4,0(a4)
     958:	00070793          	mv	a5,a4
     95c:	41f75713          	srai	a4,a4,0x1f
     960:	00070813          	mv	a6,a4
     964:	00078513          	mv	a0,a5
     968:	00080593          	mv	a1,a6
     96c:	01010113          	addi	sp,sp,16
     970:	00008067          	ret

00000974 <vFormatPrintString>:
     974:	fc010113          	addi	sp,sp,-64
     978:	02112e23          	sw	ra,60(sp)
     97c:	02812c23          	sw	s0,56(sp)
     980:	02912a23          	sw	s1,52(sp)
     984:	00a12623          	sw	a0,12(sp)
     988:	00b12423          	sw	a1,8(sp)
     98c:	00c12223          	sw	a2,4(sp)
     990:	00d12023          	sw	a3,0(sp)
     994:	0240006f          	j	9b8 <vFormatPrintString+0x44>
     998:	3c040063          	beqz	s0,d58 <vFormatPrintString+0x3e4>
     99c:	00412783          	lw	a5,4(sp)
     9a0:	00178793          	addi	a5,a5,1
     9a4:	00f12223          	sw	a5,4(sp)
     9a8:	00c12783          	lw	a5,12(sp)
     9ac:	00812583          	lw	a1,8(sp)
     9b0:	00040513          	mv	a0,s0
     9b4:	000780e7          	jalr	a5
     9b8:	00412783          	lw	a5,4(sp)
     9bc:	0007c783          	lbu	a5,0(a5)
     9c0:	00078413          	mv	s0,a5
     9c4:	02500793          	li	a5,37
     9c8:	fcf418e3          	bne	s0,a5,998 <vFormatPrintString+0x24>
     9cc:	00412783          	lw	a5,4(sp)
     9d0:	00178793          	addi	a5,a5,1
     9d4:	00f12223          	sw	a5,4(sp)
     9d8:	00412783          	lw	a5,4(sp)
     9dc:	00f12823          	sw	a5,16(sp)
     9e0:	02000793          	li	a5,32
     9e4:	00f10ba3          	sb	a5,23(sp)
     9e8:	fff00793          	li	a5,-1
     9ec:	00f12e23          	sw	a5,28(sp)
     9f0:	fff00793          	li	a5,-1
     9f4:	00f12c23          	sw	a5,24(sp)
     9f8:	02012023          	sw	zero,32(sp)
     9fc:	00412783          	lw	a5,4(sp)
     a00:	00178713          	addi	a4,a5,1
     a04:	00e12223          	sw	a4,4(sp)
     a08:	0007c783          	lbu	a5,0(a5)
     a0c:	00078413          	mv	s0,a5
     a10:	fdd40793          	addi	a5,s0,-35
     a14:	05500713          	li	a4,85
     a18:	32f76063          	bltu	a4,a5,d38 <vFormatPrintString+0x3c4>
     a1c:	00279713          	slli	a4,a5,0x2
     a20:	0001f797          	auipc	a5,0x1f
     a24:	60478793          	addi	a5,a5,1540 # 20024 <__rodata_start+0x24>
     a28:	00f707b3          	add	a5,a4,a5
     a2c:	0007a703          	lw	a4,0(a5)
     a30:	0001f797          	auipc	a5,0x1f
     a34:	5f478793          	addi	a5,a5,1524 # 20024 <__rodata_start+0x24>
     a38:	00f707b3          	add	a5,a4,a5
     a3c:	00078067          	jr	a5
     a40:	02d00793          	li	a5,45
     a44:	00f10ba3          	sb	a5,23(sp)
     a48:	fb5ff06f          	j	9fc <vFormatPrintString+0x88>
     a4c:	03000793          	li	a5,48
     a50:	00f10ba3          	sb	a5,23(sp)
     a54:	fa9ff06f          	j	9fc <vFormatPrintString+0x88>
     a58:	00012c23          	sw	zero,24(sp)
     a5c:	01812703          	lw	a4,24(sp)
     a60:	00070793          	mv	a5,a4
     a64:	00279793          	slli	a5,a5,0x2
     a68:	00e787b3          	add	a5,a5,a4
     a6c:	00179793          	slli	a5,a5,0x1
     a70:	00f407b3          	add	a5,s0,a5
     a74:	fd078793          	addi	a5,a5,-48
     a78:	00f12c23          	sw	a5,24(sp)
     a7c:	00412783          	lw	a5,4(sp)
     a80:	0007c783          	lbu	a5,0(a5)
     a84:	00078413          	mv	s0,a5
     a88:	02f00793          	li	a5,47
     a8c:	0487d263          	ble	s0,a5,ad0 <vFormatPrintString+0x15c>
     a90:	03900793          	li	a5,57
     a94:	0287ce63          	blt	a5,s0,ad0 <vFormatPrintString+0x15c>
     a98:	00412783          	lw	a5,4(sp)
     a9c:	00178793          	addi	a5,a5,1
     aa0:	00f12223          	sw	a5,4(sp)
     aa4:	fb9ff06f          	j	a5c <vFormatPrintString+0xe8>
     aa8:	00012783          	lw	a5,0(sp)
     aac:	00478713          	addi	a4,a5,4
     ab0:	00e12023          	sw	a4,0(sp)
     ab4:	0007a783          	lw	a5,0(a5)
     ab8:	00f12c23          	sw	a5,24(sp)
     abc:	0180006f          	j	ad4 <vFormatPrintString+0x160>
     ac0:	01c12783          	lw	a5,28(sp)
     ac4:	f207dce3          	bgez	a5,9fc <vFormatPrintString+0x88>
     ac8:	00012e23          	sw	zero,28(sp)
     acc:	f31ff06f          	j	9fc <vFormatPrintString+0x88>
     ad0:	00000013          	nop
     ad4:	01c12783          	lw	a5,28(sp)
     ad8:	f207d2e3          	bgez	a5,9fc <vFormatPrintString+0x88>
     adc:	01812783          	lw	a5,24(sp)
     ae0:	00f12e23          	sw	a5,28(sp)
     ae4:	fff00793          	li	a5,-1
     ae8:	00f12c23          	sw	a5,24(sp)
     aec:	f11ff06f          	j	9fc <vFormatPrintString+0x88>
     af0:	02012783          	lw	a5,32(sp)
     af4:	00178793          	addi	a5,a5,1
     af8:	02f12023          	sw	a5,32(sp)
     afc:	f01ff06f          	j	9fc <vFormatPrintString+0x88>
     b00:	00012783          	lw	a5,0(sp)
     b04:	00478713          	addi	a4,a5,4
     b08:	00e12023          	sw	a4,0(sp)
     b0c:	0007a783          	lw	a5,0(a5)
     b10:	00c12703          	lw	a4,12(sp)
     b14:	00812583          	lw	a1,8(sp)
     b18:	00078513          	mv	a0,a5
     b1c:	000700e7          	jalr	a4
     b20:	2340006f          	j	d54 <vFormatPrintString+0x3e0>
     b24:	00012783          	lw	a5,0(sp)
     b28:	00478713          	addi	a4,a5,4
     b2c:	00e12023          	sw	a4,0(sp)
     b30:	0007a483          	lw	s1,0(a5)
     b34:	00049663          	bnez	s1,b40 <vFormatPrintString+0x1cc>
     b38:	0001f497          	auipc	s1,0x1f
     b3c:	4e448493          	addi	s1,s1,1252 # 2001c <__rodata_start+0x1c>
     b40:	01c12783          	lw	a5,28(sp)
     b44:	08f05063          	blez	a5,bc4 <vFormatPrintString+0x250>
     b48:	01714703          	lbu	a4,23(sp)
     b4c:	02d00793          	li	a5,45
     b50:	06f70a63          	beq	a4,a5,bc4 <vFormatPrintString+0x250>
     b54:	01812783          	lw	a5,24(sp)
     b58:	00078593          	mv	a1,a5
     b5c:	00048513          	mv	a0,s1
     b60:	444000ef          	jal	ra,fa4 <strnlen>
     b64:	00050713          	mv	a4,a0
     b68:	01c12783          	lw	a5,28(sp)
     b6c:	40e787b3          	sub	a5,a5,a4
     b70:	00f12e23          	sw	a5,28(sp)
     b74:	0240006f          	j	b98 <vFormatPrintString+0x224>
     b78:	01714783          	lbu	a5,23(sp)
     b7c:	00c12703          	lw	a4,12(sp)
     b80:	00812583          	lw	a1,8(sp)
     b84:	00078513          	mv	a0,a5
     b88:	000700e7          	jalr	a4
     b8c:	01c12783          	lw	a5,28(sp)
     b90:	fff78793          	addi	a5,a5,-1
     b94:	00f12e23          	sw	a5,28(sp)
     b98:	01c12783          	lw	a5,28(sp)
     b9c:	fcf04ee3          	bgtz	a5,b78 <vFormatPrintString+0x204>
     ba0:	0240006f          	j	bc4 <vFormatPrintString+0x250>
     ba4:	00c12783          	lw	a5,12(sp)
     ba8:	00812583          	lw	a1,8(sp)
     bac:	00040513          	mv	a0,s0
     bb0:	000780e7          	jalr	a5
     bb4:	00148493          	addi	s1,s1,1
     bb8:	01c12783          	lw	a5,28(sp)
     bbc:	fff78793          	addi	a5,a5,-1
     bc0:	00f12e23          	sw	a5,28(sp)
     bc4:	0004c783          	lbu	a5,0(s1)
     bc8:	00078413          	mv	s0,a5
     bcc:	04040063          	beqz	s0,c0c <vFormatPrintString+0x298>
     bd0:	01812783          	lw	a5,24(sp)
     bd4:	fc07c8e3          	bltz	a5,ba4 <vFormatPrintString+0x230>
     bd8:	01812783          	lw	a5,24(sp)
     bdc:	fff78793          	addi	a5,a5,-1
     be0:	00f12c23          	sw	a5,24(sp)
     be4:	01812783          	lw	a5,24(sp)
     be8:	fa07dee3          	bgez	a5,ba4 <vFormatPrintString+0x230>
     bec:	0200006f          	j	c0c <vFormatPrintString+0x298>
     bf0:	00c12783          	lw	a5,12(sp)
     bf4:	00812583          	lw	a1,8(sp)
     bf8:	02000513          	li	a0,32
     bfc:	000780e7          	jalr	a5
     c00:	01c12783          	lw	a5,28(sp)
     c04:	fff78793          	addi	a5,a5,-1
     c08:	00f12e23          	sw	a5,28(sp)
     c0c:	01c12783          	lw	a5,28(sp)
     c10:	fef040e3          	bgtz	a5,bf0 <vFormatPrintString+0x27c>
     c14:	1400006f          	j	d54 <vFormatPrintString+0x3e0>
     c18:	00010793          	mv	a5,sp
     c1c:	02012583          	lw	a1,32(sp)
     c20:	00078513          	mv	a0,a5
     c24:	cadff0ef          	jal	ra,8d0 <getint>
     c28:	00050793          	mv	a5,a0
     c2c:	00058813          	mv	a6,a1
     c30:	02f12423          	sw	a5,40(sp)
     c34:	03012623          	sw	a6,44(sp)
     c38:	02812783          	lw	a5,40(sp)
     c3c:	02c12803          	lw	a6,44(sp)
     c40:	00080793          	mv	a5,a6
     c44:	0407d663          	bgez	a5,c90 <vFormatPrintString+0x31c>
     c48:	00c12783          	lw	a5,12(sp)
     c4c:	00812583          	lw	a1,8(sp)
     c50:	02d00513          	li	a0,45
     c54:	000780e7          	jalr	a5
     c58:	02812583          	lw	a1,40(sp)
     c5c:	02c12603          	lw	a2,44(sp)
     c60:	00000793          	li	a5,0
     c64:	00000813          	li	a6,0
     c68:	40b786b3          	sub	a3,a5,a1
     c6c:	00068513          	mv	a0,a3
     c70:	00a7b533          	sltu	a0,a5,a0
     c74:	40c80733          	sub	a4,a6,a2
     c78:	40a707b3          	sub	a5,a4,a0
     c7c:	00078713          	mv	a4,a5
     c80:	00068793          	mv	a5,a3
     c84:	00070813          	mv	a6,a4
     c88:	02f12423          	sw	a5,40(sp)
     c8c:	03012623          	sw	a6,44(sp)
     c90:	00a00793          	li	a5,10
     c94:	02f12223          	sw	a5,36(sp)
     c98:	0640006f          	j	cfc <vFormatPrintString+0x388>
     c9c:	00a00793          	li	a5,10
     ca0:	02f12223          	sw	a5,36(sp)
     ca4:	0400006f          	j	ce4 <vFormatPrintString+0x370>
     ca8:	00800793          	li	a5,8
     cac:	02f12223          	sw	a5,36(sp)
     cb0:	0340006f          	j	ce4 <vFormatPrintString+0x370>
     cb4:	00100793          	li	a5,1
     cb8:	02f12023          	sw	a5,32(sp)
     cbc:	00c12783          	lw	a5,12(sp)
     cc0:	00812583          	lw	a1,8(sp)
     cc4:	03000513          	li	a0,48
     cc8:	000780e7          	jalr	a5
     ccc:	00c12783          	lw	a5,12(sp)
     cd0:	00812583          	lw	a1,8(sp)
     cd4:	07800513          	li	a0,120
     cd8:	000780e7          	jalr	a5
     cdc:	01000793          	li	a5,16
     ce0:	02f12223          	sw	a5,36(sp)
     ce4:	00010793          	mv	a5,sp
     ce8:	02012583          	lw	a1,32(sp)
     cec:	00078513          	mv	a0,a5
     cf0:	b45ff0ef          	jal	ra,834 <getuint>
     cf4:	02a12423          	sw	a0,40(sp)
     cf8:	02b12623          	sw	a1,44(sp)
     cfc:	02412703          	lw	a4,36(sp)
     d00:	01714783          	lbu	a5,23(sp)
     d04:	00078813          	mv	a6,a5
     d08:	01c12783          	lw	a5,28(sp)
     d0c:	02812603          	lw	a2,40(sp)
     d10:	02c12683          	lw	a3,44(sp)
     d14:	00812583          	lw	a1,8(sp)
     d18:	00c12503          	lw	a0,12(sp)
     d1c:	965ff0ef          	jal	ra,680 <printnum>
     d20:	0340006f          	j	d54 <vFormatPrintString+0x3e0>
     d24:	00c12783          	lw	a5,12(sp)
     d28:	00812583          	lw	a1,8(sp)
     d2c:	00040513          	mv	a0,s0
     d30:	000780e7          	jalr	a5
     d34:	0200006f          	j	d54 <vFormatPrintString+0x3e0>
     d38:	00c12783          	lw	a5,12(sp)
     d3c:	00812583          	lw	a1,8(sp)
     d40:	02500513          	li	a0,37
     d44:	000780e7          	jalr	a5
     d48:	01012783          	lw	a5,16(sp)
     d4c:	00f12223          	sw	a5,4(sp)
     d50:	00000013          	nop
     d54:	c65ff06f          	j	9b8 <vFormatPrintString+0x44>
     d58:	00000013          	nop
     d5c:	03c12083          	lw	ra,60(sp)
     d60:	03812403          	lw	s0,56(sp)
     d64:	03412483          	lw	s1,52(sp)
     d68:	04010113          	addi	sp,sp,64
     d6c:	00008067          	ret

00000d70 <exit>:
     d70:	fe010113          	addi	sp,sp,-32
     d74:	00112e23          	sw	ra,28(sp)
     d78:	00a12623          	sw	a0,12(sp)
     d7c:	00000693          	li	a3,0
     d80:	00000613          	li	a2,0
     d84:	00c12583          	lw	a1,12(sp)
     d88:	05d00513          	li	a0,93
     d8c:	ee8ff0ef          	jal	ra,474 <syscall>
     d90:	0000006f          	j	d90 <exit+0x20>

00000d94 <printf>:
     d94:	fb010113          	addi	sp,sp,-80
     d98:	02112623          	sw	ra,44(sp)
     d9c:	00a12623          	sw	a0,12(sp)
     da0:	02b12a23          	sw	a1,52(sp)
     da4:	02c12c23          	sw	a2,56(sp)
     da8:	02d12e23          	sw	a3,60(sp)
     dac:	04e12023          	sw	a4,64(sp)
     db0:	04f12223          	sw	a5,68(sp)
     db4:	05012423          	sw	a6,72(sp)
     db8:	05112623          	sw	a7,76(sp)
     dbc:	05010793          	addi	a5,sp,80
     dc0:	fe478793          	addi	a5,a5,-28
     dc4:	00f12e23          	sw	a5,28(sp)
     dc8:	01c12783          	lw	a5,28(sp)
     dcc:	00078693          	mv	a3,a5
     dd0:	00c12603          	lw	a2,12(sp)
     dd4:	00000593          	li	a1,0
     dd8:	00000517          	auipc	a0,0x0
     ddc:	80050513          	addi	a0,a0,-2048 # 5d8 <putchar>
     de0:	b95ff0ef          	jal	ra,974 <vFormatPrintString>
     de4:	00000793          	li	a5,0
     de8:	00078513          	mv	a0,a5
     dec:	02c12083          	lw	ra,44(sp)
     df0:	05010113          	addi	sp,sp,80
     df4:	00008067          	ret

00000df8 <sprintf_putch.2235>:
     df8:	fe010113          	addi	sp,sp,-32
     dfc:	00a12623          	sw	a0,12(sp)
     e00:	00b12423          	sw	a1,8(sp)
     e04:	00712223          	sw	t2,4(sp)
     e08:	00812783          	lw	a5,8(sp)
     e0c:	00f12e23          	sw	a5,28(sp)
     e10:	01c12783          	lw	a5,28(sp)
     e14:	0007a783          	lw	a5,0(a5)
     e18:	00c12703          	lw	a4,12(sp)
     e1c:	0ff77713          	andi	a4,a4,255
     e20:	00e78023          	sb	a4,0(a5)
     e24:	01c12783          	lw	a5,28(sp)
     e28:	0007a783          	lw	a5,0(a5)
     e2c:	00178713          	addi	a4,a5,1
     e30:	01c12783          	lw	a5,28(sp)
     e34:	00e7a023          	sw	a4,0(a5)
     e38:	00000013          	nop
     e3c:	02010113          	addi	sp,sp,32
     e40:	00008067          	ret

00000e44 <sprintf>:
     e44:	fa010113          	addi	sp,sp,-96
     e48:	02112e23          	sw	ra,60(sp)
     e4c:	00a12623          	sw	a0,12(sp)
     e50:	00b12423          	sw	a1,8(sp)
     e54:	04c12423          	sw	a2,72(sp)
     e58:	04d12623          	sw	a3,76(sp)
     e5c:	04e12823          	sw	a4,80(sp)
     e60:	04f12a23          	sw	a5,84(sp)
     e64:	05012c23          	sw	a6,88(sp)
     e68:	05112e23          	sw	a7,92(sp)
     e6c:	06010793          	addi	a5,sp,96
     e70:	02f12223          	sw	a5,36(sp)
     e74:	01410793          	addi	a5,sp,20
     e78:	01410593          	addi	a1,sp,20
     e7c:	00000617          	auipc	a2,0x0
     e80:	f7c60613          	addi	a2,a2,-132 # df8 <sprintf_putch.2235>
     e84:	fffff737          	lui	a4,0xfffff
     e88:	fff74693          	not	a3,a4
     e8c:	00001537          	lui	a0,0x1
     e90:	80050513          	addi	a0,a0,-2048 # 800 <printnum+0x180>
     e94:	00a58833          	add	a6,a1,a0
     e98:	00e87833          	and	a6,a6,a4
     e9c:	3b786813          	ori	a6,a6,951
     ea0:	0107a023          	sw	a6,0(a5)
     ea4:	00a60533          	add	a0,a2,a0
     ea8:	00e57733          	and	a4,a0,a4
     eac:	33776713          	ori	a4,a4,823
     eb0:	00e7a223          	sw	a4,4(a5)
     eb4:	00d5f733          	and	a4,a1,a3
     eb8:	01471593          	slli	a1,a4,0x14
     ebc:	00038737          	lui	a4,0x38
     ec0:	39370713          	addi	a4,a4,915 # 38393 <__stack+0x15f4b>
     ec4:	00e5e733          	or	a4,a1,a4
     ec8:	00e7a423          	sw	a4,8(a5)
     ecc:	00d67733          	and	a4,a2,a3
     ed0:	01471693          	slli	a3,a4,0x14
     ed4:	00030737          	lui	a4,0x30
     ed8:	06770713          	addi	a4,a4,103 # 30067 <__stack+0xdc1f>
     edc:	00e6e733          	or	a4,a3,a4
     ee0:	00e7a623          	sw	a4,12(a5)
     ee4:	0000100f          	fence.i
     ee8:	00c12783          	lw	a5,12(sp)
     eec:	02f12623          	sw	a5,44(sp)
     ef0:	06010793          	addi	a5,sp,96
     ef4:	fe878793          	addi	a5,a5,-24
     ef8:	02f12423          	sw	a5,40(sp)
     efc:	02812703          	lw	a4,40(sp)
     f00:	01410793          	addi	a5,sp,20
     f04:	00078513          	mv	a0,a5
     f08:	00c10793          	addi	a5,sp,12
     f0c:	00070693          	mv	a3,a4
     f10:	00812603          	lw	a2,8(sp)
     f14:	00078593          	mv	a1,a5
     f18:	a5dff0ef          	jal	ra,974 <vFormatPrintString>
     f1c:	00c12783          	lw	a5,12(sp)
     f20:	00078023          	sb	zero,0(a5)
     f24:	00c12783          	lw	a5,12(sp)
     f28:	00078713          	mv	a4,a5
     f2c:	02c12783          	lw	a5,44(sp)
     f30:	40f707b3          	sub	a5,a4,a5
     f34:	00078513          	mv	a0,a5
     f38:	03c12083          	lw	ra,60(sp)
     f3c:	06010113          	addi	sp,sp,96
     f40:	00008067          	ret

00000f44 <main>:
     f44:	ff010113          	addi	sp,sp,-16
     f48:	00112623          	sw	ra,12(sp)
     f4c:	0001f517          	auipc	a0,0x1f
     f50:	23050513          	addi	a0,a0,560 # 2017c <__rodata_start+0x17c>
     f54:	e41ff0ef          	jal	ra,d94 <printf>
     f58:	0001f517          	auipc	a0,0x1f
     f5c:	24c50513          	addi	a0,a0,588 # 201a4 <__rodata_start+0x1a4>
     f60:	e35ff0ef          	jal	ra,d94 <printf>
     f64:	00500793          	li	a5,5
     f68:	00078f13          	mv	t5,a5
     f6c:	00600793          	li	a5,6
     f70:	00078f93          	mv	t6,a5
     f74:	00000793          	li	a5,0
     f78:	00078513          	mv	a0,a5
     f7c:	00c12083          	lw	ra,12(sp)
     f80:	01010113          	addi	sp,sp,16
     f84:	00008067          	ret

00000f88 <strlen>:
     f88:	00050793          	mv	a5,a0
     f8c:	00178793          	addi	a5,a5,1
     f90:	fff7c703          	lbu	a4,-1(a5)
     f94:	fe071ce3          	bnez	a4,f8c <strlen+0x4>
     f98:	40a78533          	sub	a0,a5,a0
     f9c:	fff50513          	addi	a0,a0,-1
     fa0:	00008067          	ret

00000fa4 <strnlen>:
     fa4:	00b505b3          	add	a1,a0,a1
     fa8:	00050793          	mv	a5,a0
     fac:	00b78663          	beq	a5,a1,fb8 <strnlen+0x14>
     fb0:	0007c703          	lbu	a4,0(a5)
     fb4:	00071663          	bnez	a4,fc0 <strnlen+0x1c>
     fb8:	40a78533          	sub	a0,a5,a0
     fbc:	00008067          	ret
     fc0:	00178793          	addi	a5,a5,1
     fc4:	fe9ff06f          	j	fac <strnlen+0x8>

00000fc8 <__udivdi3>:
#endif

#ifdef L_udivdi3
UDWtype
__udivdi3 (UDWtype n, UDWtype d)
{
     fc8:	fd010113          	addi	sp,sp,-48
     fcc:	01612823          	sw	s6,16(sp)
     fd0:	01712623          	sw	s7,12(sp)
     fd4:	02112623          	sw	ra,44(sp)
     fd8:	02812423          	sw	s0,40(sp)
     fdc:	02912223          	sw	s1,36(sp)
     fe0:	03212023          	sw	s2,32(sp)
     fe4:	01312e23          	sw	s3,28(sp)
     fe8:	01412c23          	sw	s4,24(sp)
     fec:	01512a23          	sw	s5,20(sp)
     ff0:	01812423          	sw	s8,8(sp)
     ff4:	01912223          	sw	s9,4(sp)
     ff8:	01a12023          	sw	s10,0(sp)
     ffc:	00050b13          	mv	s6,a0
    1000:	00058b93          	mv	s7,a1
  if (d1 == 0)
    1004:	38069e63          	bnez	a3,13a0 <_HEAP_SIZE+0x3a0>
    1008:	00020937          	lui	s2,0x20
    100c:	00060493          	mv	s1,a2
    1010:	00050a13          	mv	s4,a0
    1014:	1c490913          	addi	s2,s2,452 # 201c4 <__clz_tab>
      if (d0 > n1)
    1018:	12c5f863          	bleu	a2,a1,1148 <_HEAP_SIZE+0x148>
	  count_leading_zeros (bm, d0);
    101c:	000107b7          	lui	a5,0x10
    1020:	00058413          	mv	s0,a1
    1024:	10f67863          	bleu	a5,a2,1134 <_HEAP_SIZE+0x134>
    1028:	0ff00713          	li	a4,255
    102c:	00c73733          	sltu	a4,a4,a2
    1030:	00371713          	slli	a4,a4,0x3
    1034:	00e657b3          	srl	a5,a2,a4
    1038:	00f90933          	add	s2,s2,a5
    103c:	00094683          	lbu	a3,0(s2)
    1040:	00e68733          	add	a4,a3,a4
    1044:	02000693          	li	a3,32
    1048:	40e686b3          	sub	a3,a3,a4
	  if (bm != 0)
    104c:	00068c63          	beqz	a3,1064 <_HEAP_SIZE+0x64>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    1050:	00db9433          	sll	s0,s7,a3
    1054:	00eb5733          	srl	a4,s6,a4
	      d0 = d0 << bm;
    1058:	00d614b3          	sll	s1,a2,a3
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    105c:	00876433          	or	s0,a4,s0
	      n0 = n0 << bm;
    1060:	00db1a33          	sll	s4,s6,a3
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    1064:	0104da93          	srli	s5,s1,0x10
    1068:	000a8593          	mv	a1,s5
    106c:	00040513          	mv	a0,s0
    1070:	2a9000ef          	jal	ra,1b18 <__umodsi3>
    1074:	00050993          	mv	s3,a0
    1078:	000a8593          	mv	a1,s5
    107c:	00040513          	mv	a0,s0
    1080:	01049b13          	slli	s6,s1,0x10
    1084:	24d000ef          	jal	ra,1ad0 <__udivsi3>
    1088:	010b5b13          	srli	s6,s6,0x10
    108c:	00050913          	mv	s2,a0
    1090:	00050593          	mv	a1,a0
    1094:	000b0513          	mv	a0,s6
    1098:	20d000ef          	jal	ra,1aa4 <__mulsi3>
    109c:	01099993          	slli	s3,s3,0x10
    10a0:	010a5793          	srli	a5,s4,0x10
    10a4:	00f9e7b3          	or	a5,s3,a5
    10a8:	00090413          	mv	s0,s2
    10ac:	00a7fe63          	bleu	a0,a5,10c8 <_HEAP_SIZE+0xc8>
    10b0:	009787b3          	add	a5,a5,s1
    10b4:	fff90413          	addi	s0,s2,-1
    10b8:	0097e863          	bltu	a5,s1,10c8 <_HEAP_SIZE+0xc8>
    10bc:	00a7f663          	bleu	a0,a5,10c8 <_HEAP_SIZE+0xc8>
    10c0:	ffe90413          	addi	s0,s2,-2
    10c4:	009787b3          	add	a5,a5,s1
    10c8:	40a78933          	sub	s2,a5,a0
    10cc:	000a8593          	mv	a1,s5
    10d0:	00090513          	mv	a0,s2
    10d4:	245000ef          	jal	ra,1b18 <__umodsi3>
    10d8:	00050993          	mv	s3,a0
    10dc:	000a8593          	mv	a1,s5
    10e0:	00090513          	mv	a0,s2
    10e4:	1ed000ef          	jal	ra,1ad0 <__udivsi3>
    10e8:	010a1a13          	slli	s4,s4,0x10
    10ec:	00050913          	mv	s2,a0
    10f0:	00050593          	mv	a1,a0
    10f4:	01099993          	slli	s3,s3,0x10
    10f8:	000b0513          	mv	a0,s6
    10fc:	010a5a13          	srli	s4,s4,0x10
    1100:	1a5000ef          	jal	ra,1aa4 <__mulsi3>
    1104:	0149ea33          	or	s4,s3,s4
    1108:	00090613          	mv	a2,s2
    110c:	00aa7c63          	bleu	a0,s4,1124 <_HEAP_SIZE+0x124>
    1110:	01448a33          	add	s4,s1,s4
    1114:	fff90613          	addi	a2,s2,-1
    1118:	009a6663          	bltu	s4,s1,1124 <_HEAP_SIZE+0x124>
    111c:	00aa7463          	bleu	a0,s4,1124 <_HEAP_SIZE+0x124>
    1120:	ffe90613          	addi	a2,s2,-2
    1124:	01041413          	slli	s0,s0,0x10
    1128:	00c46433          	or	s0,s0,a2
	      q1 = 0;
    112c:	00000a93          	li	s5,0
    1130:	1300006f          	j	1260 <_HEAP_SIZE+0x260>
	  count_leading_zeros (bm, d0);
    1134:	010007b7          	lui	a5,0x1000
    1138:	01000713          	li	a4,16
    113c:	eef66ce3          	bltu	a2,a5,1034 <_HEAP_SIZE+0x34>
    1140:	01800713          	li	a4,24
    1144:	ef1ff06f          	j	1034 <_HEAP_SIZE+0x34>
    1148:	00068993          	mv	s3,a3
	  if (d0 == 0)
    114c:	00061a63          	bnez	a2,1160 <_HEAP_SIZE+0x160>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    1150:	00000593          	li	a1,0
    1154:	00100513          	li	a0,1
    1158:	179000ef          	jal	ra,1ad0 <__udivsi3>
    115c:	00050493          	mv	s1,a0
	  count_leading_zeros (bm, d0);
    1160:	000107b7          	lui	a5,0x10
    1164:	12f4fe63          	bleu	a5,s1,12a0 <_HEAP_SIZE+0x2a0>
    1168:	0ff00793          	li	a5,255
    116c:	0097f463          	bleu	s1,a5,1174 <_HEAP_SIZE+0x174>
    1170:	00800993          	li	s3,8
    1174:	0134d7b3          	srl	a5,s1,s3
    1178:	00f90933          	add	s2,s2,a5
    117c:	00094703          	lbu	a4,0(s2)
    1180:	02000693          	li	a3,32
    1184:	01370733          	add	a4,a4,s3
    1188:	40e686b3          	sub	a3,a3,a4
	  if (bm == 0)
    118c:	12069463          	bnez	a3,12b4 <_HEAP_SIZE+0x2b4>
	      n1 -= d0;
    1190:	409b8433          	sub	s0,s7,s1
	      q1 = 1;
    1194:	00100a93          	li	s5,1
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    1198:	0104db13          	srli	s6,s1,0x10
    119c:	000b0593          	mv	a1,s6
    11a0:	00040513          	mv	a0,s0
    11a4:	175000ef          	jal	ra,1b18 <__umodsi3>
    11a8:	00050993          	mv	s3,a0
    11ac:	000b0593          	mv	a1,s6
    11b0:	00040513          	mv	a0,s0
    11b4:	01049b93          	slli	s7,s1,0x10
    11b8:	119000ef          	jal	ra,1ad0 <__udivsi3>
    11bc:	010bdb93          	srli	s7,s7,0x10
    11c0:	00050913          	mv	s2,a0
    11c4:	00050593          	mv	a1,a0
    11c8:	000b8513          	mv	a0,s7
    11cc:	0d9000ef          	jal	ra,1aa4 <__mulsi3>
    11d0:	01099993          	slli	s3,s3,0x10
    11d4:	010a5793          	srli	a5,s4,0x10
    11d8:	00f9e7b3          	or	a5,s3,a5
    11dc:	00090413          	mv	s0,s2
    11e0:	00a7fe63          	bleu	a0,a5,11fc <_HEAP_SIZE+0x1fc>
    11e4:	009787b3          	add	a5,a5,s1
    11e8:	fff90413          	addi	s0,s2,-1
    11ec:	0097e863          	bltu	a5,s1,11fc <_HEAP_SIZE+0x1fc>
    11f0:	00a7f663          	bleu	a0,a5,11fc <_HEAP_SIZE+0x1fc>
    11f4:	ffe90413          	addi	s0,s2,-2
    11f8:	009787b3          	add	a5,a5,s1
    11fc:	40a78933          	sub	s2,a5,a0
    1200:	000b0593          	mv	a1,s6
    1204:	00090513          	mv	a0,s2
    1208:	111000ef          	jal	ra,1b18 <__umodsi3>
    120c:	00050993          	mv	s3,a0
    1210:	000b0593          	mv	a1,s6
    1214:	00090513          	mv	a0,s2
    1218:	0b9000ef          	jal	ra,1ad0 <__udivsi3>
    121c:	010a1a13          	slli	s4,s4,0x10
    1220:	00050913          	mv	s2,a0
    1224:	00050593          	mv	a1,a0
    1228:	01099993          	slli	s3,s3,0x10
    122c:	000b8513          	mv	a0,s7
    1230:	010a5a13          	srli	s4,s4,0x10
    1234:	071000ef          	jal	ra,1aa4 <__mulsi3>
    1238:	0149ea33          	or	s4,s3,s4
    123c:	00090613          	mv	a2,s2
    1240:	00aa7c63          	bleu	a0,s4,1258 <_HEAP_SIZE+0x258>
    1244:	01448a33          	add	s4,s1,s4
    1248:	fff90613          	addi	a2,s2,-1
    124c:	009a6663          	bltu	s4,s1,1258 <_HEAP_SIZE+0x258>
    1250:	00aa7463          	bleu	a0,s4,1258 <_HEAP_SIZE+0x258>
    1254:	ffe90613          	addi	a2,s2,-2
    1258:	01041413          	slli	s0,s0,0x10
    125c:	00c46433          	or	s0,s0,a2
  return __udivmoddi4 (n, d, (UDWtype *) 0);
}
    1260:	00040513          	mv	a0,s0
    1264:	000a8593          	mv	a1,s5
    1268:	02c12083          	lw	ra,44(sp)
    126c:	02812403          	lw	s0,40(sp)
    1270:	02412483          	lw	s1,36(sp)
    1274:	02012903          	lw	s2,32(sp)
    1278:	01c12983          	lw	s3,28(sp)
    127c:	01812a03          	lw	s4,24(sp)
    1280:	01412a83          	lw	s5,20(sp)
    1284:	01012b03          	lw	s6,16(sp)
    1288:	00c12b83          	lw	s7,12(sp)
    128c:	00812c03          	lw	s8,8(sp)
    1290:	00412c83          	lw	s9,4(sp)
    1294:	00012d03          	lw	s10,0(sp)
    1298:	03010113          	addi	sp,sp,48
    129c:	00008067          	ret
	  count_leading_zeros (bm, d0);
    12a0:	010007b7          	lui	a5,0x1000
    12a4:	01000993          	li	s3,16
    12a8:	ecf4e6e3          	bltu	s1,a5,1174 <_HEAP_SIZE+0x174>
    12ac:	01800993          	li	s3,24
    12b0:	ec5ff06f          	j	1174 <_HEAP_SIZE+0x174>
	      d0 = d0 << bm;
    12b4:	00d494b3          	sll	s1,s1,a3
	      n2 = n1 >> b;
    12b8:	00ebd9b3          	srl	s3,s7,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    12bc:	0104d413          	srli	s0,s1,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    12c0:	00eb5733          	srl	a4,s6,a4
    12c4:	00db9bb3          	sll	s7,s7,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    12c8:	00040593          	mv	a1,s0
    12cc:	00098513          	mv	a0,s3
	      n1 = (n1 << bm) | (n0 >> b);
    12d0:	01776bb3          	or	s7,a4,s7
	      n0 = n0 << bm;
    12d4:	00db1a33          	sll	s4,s6,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    12d8:	041000ef          	jal	ra,1b18 <__umodsi3>
    12dc:	00050913          	mv	s2,a0
    12e0:	00040593          	mv	a1,s0
    12e4:	00098513          	mv	a0,s3
    12e8:	01049b13          	slli	s6,s1,0x10
    12ec:	7e4000ef          	jal	ra,1ad0 <__udivsi3>
    12f0:	010b5b13          	srli	s6,s6,0x10
    12f4:	00050993          	mv	s3,a0
    12f8:	00050593          	mv	a1,a0
    12fc:	000b0513          	mv	a0,s6
    1300:	7a4000ef          	jal	ra,1aa4 <__mulsi3>
    1304:	01091913          	slli	s2,s2,0x10
    1308:	010bd713          	srli	a4,s7,0x10
    130c:	00e96733          	or	a4,s2,a4
    1310:	00098a93          	mv	s5,s3
    1314:	00a77e63          	bleu	a0,a4,1330 <_HEAP_SIZE+0x330>
    1318:	00970733          	add	a4,a4,s1
    131c:	fff98a93          	addi	s5,s3,-1
    1320:	00976863          	bltu	a4,s1,1330 <_HEAP_SIZE+0x330>
    1324:	00a77663          	bleu	a0,a4,1330 <_HEAP_SIZE+0x330>
    1328:	ffe98a93          	addi	s5,s3,-2
    132c:	00970733          	add	a4,a4,s1
    1330:	40a709b3          	sub	s3,a4,a0
    1334:	00040593          	mv	a1,s0
    1338:	00098513          	mv	a0,s3
    133c:	7dc000ef          	jal	ra,1b18 <__umodsi3>
    1340:	00040593          	mv	a1,s0
    1344:	00050913          	mv	s2,a0
    1348:	00098513          	mv	a0,s3
    134c:	784000ef          	jal	ra,1ad0 <__udivsi3>
    1350:	00050413          	mv	s0,a0
    1354:	00050593          	mv	a1,a0
    1358:	000b0513          	mv	a0,s6
    135c:	748000ef          	jal	ra,1aa4 <__mulsi3>
    1360:	010b9713          	slli	a4,s7,0x10
    1364:	01075713          	srli	a4,a4,0x10
    1368:	01091913          	slli	s2,s2,0x10
    136c:	00e967b3          	or	a5,s2,a4
    1370:	00040713          	mv	a4,s0
    1374:	00a7fe63          	bleu	a0,a5,1390 <_HEAP_SIZE+0x390>
    1378:	009787b3          	add	a5,a5,s1
    137c:	fff40713          	addi	a4,s0,-1
    1380:	0097e863          	bltu	a5,s1,1390 <_HEAP_SIZE+0x390>
    1384:	00a7f663          	bleu	a0,a5,1390 <_HEAP_SIZE+0x390>
    1388:	ffe40713          	addi	a4,s0,-2
    138c:	009787b3          	add	a5,a5,s1
    1390:	010a9a93          	slli	s5,s5,0x10
    1394:	40a78433          	sub	s0,a5,a0
    1398:	00eaeab3          	or	s5,s5,a4
    139c:	dfdff06f          	j	1198 <_HEAP_SIZE+0x198>
      if (d1 > n1)
    13a0:	1ed5ec63          	bltu	a1,a3,1598 <_HEAP_SIZE+0x598>
	  count_leading_zeros (bm, d1);
    13a4:	000107b7          	lui	a5,0x10
    13a8:	04f6f463          	bleu	a5,a3,13f0 <_HEAP_SIZE+0x3f0>
    13ac:	0ff00713          	li	a4,255
    13b0:	00d735b3          	sltu	a1,a4,a3
    13b4:	00359593          	slli	a1,a1,0x3
    13b8:	00020737          	lui	a4,0x20
    13bc:	1c470713          	addi	a4,a4,452 # 201c4 <__clz_tab>
    13c0:	00b6d7b3          	srl	a5,a3,a1
    13c4:	00e787b3          	add	a5,a5,a4
    13c8:	0007c703          	lbu	a4,0(a5) # 10000 <__modsi3+0xe4b4>
    13cc:	02000a93          	li	s5,32
    13d0:	00b70733          	add	a4,a4,a1
    13d4:	40ea8ab3          	sub	s5,s5,a4
	  if (bm == 0)
    13d8:	020a9663          	bnez	s5,1404 <_HEAP_SIZE+0x404>
		  q0 = 1;
    13dc:	00100413          	li	s0,1
	      if (n1 > d1 || n0 >= d0)
    13e0:	e976e0e3          	bltu	a3,s7,1260 <_HEAP_SIZE+0x260>
    13e4:	00cb3633          	sltu	a2,s6,a2
    13e8:	00164413          	xori	s0,a2,1
    13ec:	e75ff06f          	j	1260 <_HEAP_SIZE+0x260>
	  count_leading_zeros (bm, d1);
    13f0:	010007b7          	lui	a5,0x1000
    13f4:	01000593          	li	a1,16
    13f8:	fcf6e0e3          	bltu	a3,a5,13b8 <_HEAP_SIZE+0x3b8>
    13fc:	01800593          	li	a1,24
    1400:	fb9ff06f          	j	13b8 <_HEAP_SIZE+0x3b8>
	      d1 = (d1 << bm) | (d0 >> b);
    1404:	00e65cb3          	srl	s9,a2,a4
    1408:	015696b3          	sll	a3,a3,s5
    140c:	00dcecb3          	or	s9,s9,a3
	      n2 = n1 >> b;
    1410:	00ebd4b3          	srl	s1,s7,a4
	      n1 = (n1 << bm) | (n0 >> b);
    1414:	015b97b3          	sll	a5,s7,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1418:	010cdb93          	srli	s7,s9,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    141c:	00eb5733          	srl	a4,s6,a4
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1420:	000b8593          	mv	a1,s7
    1424:	00048513          	mv	a0,s1
	      n1 = (n1 << bm) | (n0 >> b);
    1428:	00f76433          	or	s0,a4,a5
	      d0 = d0 << bm;
    142c:	015619b3          	sll	s3,a2,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1430:	6e8000ef          	jal	ra,1b18 <__umodsi3>
    1434:	00050913          	mv	s2,a0
    1438:	000b8593          	mv	a1,s7
    143c:	00048513          	mv	a0,s1
    1440:	010c9c13          	slli	s8,s9,0x10
    1444:	68c000ef          	jal	ra,1ad0 <__udivsi3>
    1448:	010c5c13          	srli	s8,s8,0x10
    144c:	00050493          	mv	s1,a0
    1450:	00050593          	mv	a1,a0
    1454:	000c0513          	mv	a0,s8
    1458:	64c000ef          	jal	ra,1aa4 <__mulsi3>
    145c:	01091913          	slli	s2,s2,0x10
    1460:	01045713          	srli	a4,s0,0x10
    1464:	00e96733          	or	a4,s2,a4
    1468:	00048a13          	mv	s4,s1
    146c:	00a77e63          	bleu	a0,a4,1488 <_HEAP_SIZE+0x488>
    1470:	01970733          	add	a4,a4,s9
    1474:	fff48a13          	addi	s4,s1,-1
    1478:	01976863          	bltu	a4,s9,1488 <_HEAP_SIZE+0x488>
    147c:	00a77663          	bleu	a0,a4,1488 <_HEAP_SIZE+0x488>
    1480:	ffe48a13          	addi	s4,s1,-2
    1484:	01970733          	add	a4,a4,s9
    1488:	40a704b3          	sub	s1,a4,a0
    148c:	000b8593          	mv	a1,s7
    1490:	00048513          	mv	a0,s1
    1494:	684000ef          	jal	ra,1b18 <__umodsi3>
    1498:	00050913          	mv	s2,a0
    149c:	000b8593          	mv	a1,s7
    14a0:	00048513          	mv	a0,s1
    14a4:	62c000ef          	jal	ra,1ad0 <__udivsi3>
    14a8:	00050493          	mv	s1,a0
    14ac:	00050593          	mv	a1,a0
    14b0:	000c0513          	mv	a0,s8
    14b4:	5f0000ef          	jal	ra,1aa4 <__mulsi3>
    14b8:	01041793          	slli	a5,s0,0x10
    14bc:	01091913          	slli	s2,s2,0x10
    14c0:	0107d793          	srli	a5,a5,0x10
    14c4:	00f967b3          	or	a5,s2,a5
    14c8:	00048613          	mv	a2,s1
    14cc:	00a7fe63          	bleu	a0,a5,14e8 <_HEAP_SIZE+0x4e8>
    14d0:	019787b3          	add	a5,a5,s9
    14d4:	fff48613          	addi	a2,s1,-1
    14d8:	0197e863          	bltu	a5,s9,14e8 <_HEAP_SIZE+0x4e8>
    14dc:	00a7f663          	bleu	a0,a5,14e8 <_HEAP_SIZE+0x4e8>
    14e0:	ffe48613          	addi	a2,s1,-2
    14e4:	019787b3          	add	a5,a5,s9
    14e8:	010a1413          	slli	s0,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    14ec:	00010bb7          	lui	s7,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    14f0:	00c46433          	or	s0,s0,a2
	      umul_ppmm (m1, m0, q0, d0);
    14f4:	fffb8913          	addi	s2,s7,-1 # ffff <__modsi3+0xe4b3>
    14f8:	01247d33          	and	s10,s0,s2
    14fc:	0129f933          	and	s2,s3,s2
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1500:	40a784b3          	sub	s1,a5,a0
	      umul_ppmm (m1, m0, q0, d0);
    1504:	00090593          	mv	a1,s2
    1508:	000d0513          	mv	a0,s10
    150c:	598000ef          	jal	ra,1aa4 <__mulsi3>
    1510:	01045c93          	srli	s9,s0,0x10
    1514:	00090593          	mv	a1,s2
    1518:	00050a13          	mv	s4,a0
    151c:	000c8513          	mv	a0,s9
    1520:	584000ef          	jal	ra,1aa4 <__mulsi3>
    1524:	0109d993          	srli	s3,s3,0x10
    1528:	00050c13          	mv	s8,a0
    152c:	00098593          	mv	a1,s3
    1530:	000c8513          	mv	a0,s9
    1534:	570000ef          	jal	ra,1aa4 <__mulsi3>
    1538:	00050913          	mv	s2,a0
    153c:	00098593          	mv	a1,s3
    1540:	000d0513          	mv	a0,s10
    1544:	560000ef          	jal	ra,1aa4 <__mulsi3>
    1548:	01850533          	add	a0,a0,s8
    154c:	010a5793          	srli	a5,s4,0x10
    1550:	00a78533          	add	a0,a5,a0
    1554:	01857463          	bleu	s8,a0,155c <_HEAP_SIZE+0x55c>
    1558:	01790933          	add	s2,s2,s7
    155c:	01055793          	srli	a5,a0,0x10
    1560:	012787b3          	add	a5,a5,s2
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1564:	02f4e663          	bltu	s1,a5,1590 <_HEAP_SIZE+0x590>
    1568:	bcf492e3          	bne	s1,a5,112c <_HEAP_SIZE+0x12c>
	      umul_ppmm (m1, m0, q0, d0);
    156c:	000107b7          	lui	a5,0x10
    1570:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe4b3>
    1574:	00f57533          	and	a0,a0,a5
    1578:	01051513          	slli	a0,a0,0x10
    157c:	00fa7a33          	and	s4,s4,a5
	      n0 = n0 << bm;
    1580:	015b1633          	sll	a2,s6,s5
	      umul_ppmm (m1, m0, q0, d0);
    1584:	01450533          	add	a0,a0,s4
	      q1 = 0;
    1588:	00000a93          	li	s5,0
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    158c:	cca67ae3          	bleu	a0,a2,1260 <_HEAP_SIZE+0x260>
		  q0--;
    1590:	fff40413          	addi	s0,s0,-1
    1594:	b99ff06f          	j	112c <_HEAP_SIZE+0x12c>
	  q1 = 0;
    1598:	00000a93          	li	s5,0
	  q0 = 0;
    159c:	00000413          	li	s0,0
    15a0:	cc1ff06f          	j	1260 <_HEAP_SIZE+0x260>

000015a4 <__umoddi3>:
{
    15a4:	fb010113          	addi	sp,sp,-80
    15a8:	04812423          	sw	s0,72(sp)
    15ac:	04912223          	sw	s1,68(sp)
    15b0:	03312e23          	sw	s3,60(sp)
    15b4:	03912223          	sw	s9,36(sp)
    15b8:	04112623          	sw	ra,76(sp)
    15bc:	05212023          	sw	s2,64(sp)
    15c0:	03412c23          	sw	s4,56(sp)
    15c4:	03512a23          	sw	s5,52(sp)
    15c8:	03612823          	sw	s6,48(sp)
    15cc:	03712623          	sw	s7,44(sp)
    15d0:	03812423          	sw	s8,40(sp)
    15d4:	03a12023          	sw	s10,32(sp)
    15d8:	01b12e23          	sw	s11,28(sp)
    15dc:	00050c93          	mv	s9,a0
    15e0:	00058993          	mv	s3,a1
  n0 = nn.s.low;
    15e4:	00050413          	mv	s0,a0
  n1 = nn.s.high;
    15e8:	00058493          	mv	s1,a1
  if (d1 == 0)
    15ec:	26069e63          	bnez	a3,1868 <__umoddi3+0x2c4>
    15f0:	00020ab7          	lui	s5,0x20
    15f4:	00060913          	mv	s2,a2
    15f8:	00068a13          	mv	s4,a3
    15fc:	1c4a8a93          	addi	s5,s5,452 # 201c4 <__clz_tab>
      if (d0 > n1)
    1600:	14c5f463          	bleu	a2,a1,1748 <__umoddi3+0x1a4>
	  count_leading_zeros (bm, d0);
    1604:	000107b7          	lui	a5,0x10
    1608:	12f67663          	bleu	a5,a2,1734 <__umoddi3+0x190>
    160c:	0ff00793          	li	a5,255
    1610:	00c7f463          	bleu	a2,a5,1618 <__umoddi3+0x74>
    1614:	00800a13          	li	s4,8
    1618:	014657b3          	srl	a5,a2,s4
    161c:	00fa8ab3          	add	s5,s5,a5
    1620:	000ac703          	lbu	a4,0(s5)
    1624:	02000513          	li	a0,32
    1628:	01470733          	add	a4,a4,s4
    162c:	40e50a33          	sub	s4,a0,a4
	  if (bm != 0)
    1630:	000a0c63          	beqz	s4,1648 <__umoddi3+0xa4>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    1634:	014995b3          	sll	a1,s3,s4
    1638:	00ecd733          	srl	a4,s9,a4
	      d0 = d0 << bm;
    163c:	01461933          	sll	s2,a2,s4
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    1640:	00b764b3          	or	s1,a4,a1
	      n0 = n0 << bm;
    1644:	014c9433          	sll	s0,s9,s4
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    1648:	01095a93          	srli	s5,s2,0x10
    164c:	000a8593          	mv	a1,s5
    1650:	00048513          	mv	a0,s1
    1654:	4c4000ef          	jal	ra,1b18 <__umodsi3>
    1658:	00050993          	mv	s3,a0
    165c:	000a8593          	mv	a1,s5
    1660:	01091b13          	slli	s6,s2,0x10
    1664:	00048513          	mv	a0,s1
    1668:	468000ef          	jal	ra,1ad0 <__udivsi3>
    166c:	010b5b13          	srli	s6,s6,0x10
    1670:	00050593          	mv	a1,a0
    1674:	000b0513          	mv	a0,s6
    1678:	42c000ef          	jal	ra,1aa4 <__mulsi3>
    167c:	01099993          	slli	s3,s3,0x10
    1680:	01045793          	srli	a5,s0,0x10
    1684:	00f9e7b3          	or	a5,s3,a5
    1688:	00a7fa63          	bleu	a0,a5,169c <__umoddi3+0xf8>
    168c:	012787b3          	add	a5,a5,s2
    1690:	0127e663          	bltu	a5,s2,169c <__umoddi3+0xf8>
    1694:	00a7f463          	bleu	a0,a5,169c <__umoddi3+0xf8>
    1698:	012787b3          	add	a5,a5,s2
    169c:	40a784b3          	sub	s1,a5,a0
    16a0:	000a8593          	mv	a1,s5
    16a4:	00048513          	mv	a0,s1
    16a8:	470000ef          	jal	ra,1b18 <__umodsi3>
    16ac:	00050993          	mv	s3,a0
    16b0:	000a8593          	mv	a1,s5
    16b4:	00048513          	mv	a0,s1
    16b8:	418000ef          	jal	ra,1ad0 <__udivsi3>
    16bc:	01041413          	slli	s0,s0,0x10
    16c0:	00050593          	mv	a1,a0
    16c4:	01099993          	slli	s3,s3,0x10
    16c8:	000b0513          	mv	a0,s6
    16cc:	01045413          	srli	s0,s0,0x10
    16d0:	3d4000ef          	jal	ra,1aa4 <__mulsi3>
    16d4:	0089e433          	or	s0,s3,s0
    16d8:	00a47a63          	bleu	a0,s0,16ec <__umoddi3+0x148>
    16dc:	01240433          	add	s0,s0,s2
    16e0:	01246663          	bltu	s0,s2,16ec <__umoddi3+0x148>
    16e4:	00a47463          	bleu	a0,s0,16ec <__umoddi3+0x148>
    16e8:	01240433          	add	s0,s0,s2
    16ec:	40a40433          	sub	s0,s0,a0
	  rr.s.low = n0 >> bm;
    16f0:	01445533          	srl	a0,s0,s4
	  *rp = rr.ll;
    16f4:	00000593          	li	a1,0
}
    16f8:	04c12083          	lw	ra,76(sp)
    16fc:	04812403          	lw	s0,72(sp)
    1700:	04412483          	lw	s1,68(sp)
    1704:	04012903          	lw	s2,64(sp)
    1708:	03c12983          	lw	s3,60(sp)
    170c:	03812a03          	lw	s4,56(sp)
    1710:	03412a83          	lw	s5,52(sp)
    1714:	03012b03          	lw	s6,48(sp)
    1718:	02c12b83          	lw	s7,44(sp)
    171c:	02812c03          	lw	s8,40(sp)
    1720:	02412c83          	lw	s9,36(sp)
    1724:	02012d03          	lw	s10,32(sp)
    1728:	01c12d83          	lw	s11,28(sp)
    172c:	05010113          	addi	sp,sp,80
    1730:	00008067          	ret
	  count_leading_zeros (bm, d0);
    1734:	010007b7          	lui	a5,0x1000
    1738:	01000a13          	li	s4,16
    173c:	ecf66ee3          	bltu	a2,a5,1618 <__umoddi3+0x74>
    1740:	01800a13          	li	s4,24
    1744:	ed5ff06f          	j	1618 <__umoddi3+0x74>
	  if (d0 == 0)
    1748:	00061a63          	bnez	a2,175c <__umoddi3+0x1b8>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    174c:	00000593          	li	a1,0
    1750:	00100513          	li	a0,1
    1754:	37c000ef          	jal	ra,1ad0 <__udivsi3>
    1758:	00050913          	mv	s2,a0
	  count_leading_zeros (bm, d0);
    175c:	000107b7          	lui	a5,0x10
    1760:	0ef97a63          	bleu	a5,s2,1854 <__umoddi3+0x2b0>
    1764:	0ff00793          	li	a5,255
    1768:	0127f463          	bleu	s2,a5,1770 <__umoddi3+0x1cc>
    176c:	00800a13          	li	s4,8
    1770:	014957b3          	srl	a5,s2,s4
    1774:	00fa8ab3          	add	s5,s5,a5
    1778:	000ac703          	lbu	a4,0(s5)
    177c:	02000513          	li	a0,32
	      n1 -= d0;
    1780:	412984b3          	sub	s1,s3,s2
	  count_leading_zeros (bm, d0);
    1784:	01470733          	add	a4,a4,s4
    1788:	40e50a33          	sub	s4,a0,a4
	  if (bm == 0)
    178c:	ea0a0ee3          	beqz	s4,1648 <__umoddi3+0xa4>
	      d0 = d0 << bm;
    1790:	01491933          	sll	s2,s2,s4
	      n2 = n1 >> b;
    1794:	00e9dab3          	srl	s5,s3,a4
	      n1 = (n1 << bm) | (n0 >> b);
    1798:	014995b3          	sll	a1,s3,s4
    179c:	00ecd733          	srl	a4,s9,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    17a0:	01095493          	srli	s1,s2,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    17a4:	00b76b33          	or	s6,a4,a1
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    17a8:	000a8513          	mv	a0,s5
    17ac:	00048593          	mv	a1,s1
    17b0:	368000ef          	jal	ra,1b18 <__umodsi3>
    17b4:	00050993          	mv	s3,a0
    17b8:	00048593          	mv	a1,s1
    17bc:	01091b93          	slli	s7,s2,0x10
    17c0:	000a8513          	mv	a0,s5
    17c4:	30c000ef          	jal	ra,1ad0 <__udivsi3>
    17c8:	010bdb93          	srli	s7,s7,0x10
    17cc:	00050593          	mv	a1,a0
    17d0:	000b8513          	mv	a0,s7
    17d4:	2d0000ef          	jal	ra,1aa4 <__mulsi3>
    17d8:	01099993          	slli	s3,s3,0x10
    17dc:	010b5793          	srli	a5,s6,0x10
    17e0:	00f9e7b3          	or	a5,s3,a5
	      n0 = n0 << bm;
    17e4:	014c9433          	sll	s0,s9,s4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    17e8:	00a7fa63          	bleu	a0,a5,17fc <__umoddi3+0x258>
    17ec:	012787b3          	add	a5,a5,s2
    17f0:	0127e663          	bltu	a5,s2,17fc <__umoddi3+0x258>
    17f4:	00a7f463          	bleu	a0,a5,17fc <__umoddi3+0x258>
    17f8:	012787b3          	add	a5,a5,s2
    17fc:	40a78ab3          	sub	s5,a5,a0
    1800:	00048593          	mv	a1,s1
    1804:	000a8513          	mv	a0,s5
    1808:	310000ef          	jal	ra,1b18 <__umodsi3>
    180c:	00050993          	mv	s3,a0
    1810:	00048593          	mv	a1,s1
    1814:	000a8513          	mv	a0,s5
    1818:	2b8000ef          	jal	ra,1ad0 <__udivsi3>
    181c:	00050593          	mv	a1,a0
    1820:	000b8513          	mv	a0,s7
    1824:	280000ef          	jal	ra,1aa4 <__mulsi3>
    1828:	010b1593          	slli	a1,s6,0x10
    182c:	01099993          	slli	s3,s3,0x10
    1830:	0105d593          	srli	a1,a1,0x10
    1834:	00b9e5b3          	or	a1,s3,a1
    1838:	00a5fa63          	bleu	a0,a1,184c <__umoddi3+0x2a8>
    183c:	012585b3          	add	a1,a1,s2
    1840:	0125e663          	bltu	a1,s2,184c <__umoddi3+0x2a8>
    1844:	00a5f463          	bleu	a0,a1,184c <__umoddi3+0x2a8>
    1848:	012585b3          	add	a1,a1,s2
    184c:	40a584b3          	sub	s1,a1,a0
    1850:	df9ff06f          	j	1648 <__umoddi3+0xa4>
	  count_leading_zeros (bm, d0);
    1854:	010007b7          	lui	a5,0x1000
    1858:	01000a13          	li	s4,16
    185c:	f0f96ae3          	bltu	s2,a5,1770 <__umoddi3+0x1cc>
    1860:	01800a13          	li	s4,24
    1864:	f0dff06f          	j	1770 <__umoddi3+0x1cc>
      if (d1 > n1)
    1868:	e8d5e8e3          	bltu	a1,a3,16f8 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    186c:	000107b7          	lui	a5,0x10
    1870:	04f6fc63          	bleu	a5,a3,18c8 <__umoddi3+0x324>
    1874:	0ff00b93          	li	s7,255
    1878:	00dbb533          	sltu	a0,s7,a3
    187c:	00351513          	slli	a0,a0,0x3
    1880:	00020737          	lui	a4,0x20
    1884:	00a6d7b3          	srl	a5,a3,a0
    1888:	1c470713          	addi	a4,a4,452 # 201c4 <__clz_tab>
    188c:	00e787b3          	add	a5,a5,a4
    1890:	0007cb83          	lbu	s7,0(a5) # 10000 <__modsi3+0xe4b4>
    1894:	02000593          	li	a1,32
    1898:	00ab8bb3          	add	s7,s7,a0
    189c:	41758b33          	sub	s6,a1,s7
	  if (bm == 0)
    18a0:	020b1e63          	bnez	s6,18dc <__umoddi3+0x338>
	      if (n1 > d1 || n0 >= d0)
    18a4:	0136e463          	bltu	a3,s3,18ac <__umoddi3+0x308>
    18a8:	00ccea63          	bltu	s9,a2,18bc <__umoddi3+0x318>
		  sub_ddmmss (n1, n0, n1, n0, d1, d0);
    18ac:	40cc8433          	sub	s0,s9,a2
    18b0:	40d986b3          	sub	a3,s3,a3
    18b4:	008cb533          	sltu	a0,s9,s0
    18b8:	40a684b3          	sub	s1,a3,a0
		  *rp = rr.ll;
    18bc:	00040513          	mv	a0,s0
    18c0:	00048593          	mv	a1,s1
    18c4:	e35ff06f          	j	16f8 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    18c8:	010007b7          	lui	a5,0x1000
    18cc:	01000513          	li	a0,16
    18d0:	faf6e8e3          	bltu	a3,a5,1880 <__umoddi3+0x2dc>
    18d4:	01800513          	li	a0,24
    18d8:	fa9ff06f          	j	1880 <__umoddi3+0x2dc>
	      d1 = (d1 << bm) | (d0 >> b);
    18dc:	016696b3          	sll	a3,a3,s6
    18e0:	01765d33          	srl	s10,a2,s7
    18e4:	00dd6d33          	or	s10,s10,a3
	      n2 = n1 >> b;
    18e8:	0179d433          	srl	s0,s3,s7
	      n1 = (n1 << bm) | (n0 >> b);
    18ec:	016995b3          	sll	a1,s3,s6
    18f0:	017cdc33          	srl	s8,s9,s7
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    18f4:	010d5493          	srli	s1,s10,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    18f8:	00bc6c33          	or	s8,s8,a1
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    18fc:	00040513          	mv	a0,s0
    1900:	00048593          	mv	a1,s1
	      d0 = d0 << bm;
    1904:	01661ab3          	sll	s5,a2,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1908:	210000ef          	jal	ra,1b18 <__umodsi3>
    190c:	00050a13          	mv	s4,a0
    1910:	00048593          	mv	a1,s1
    1914:	00040513          	mv	a0,s0
	      n0 = n0 << bm;
    1918:	016c9933          	sll	s2,s9,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    191c:	010d1c93          	slli	s9,s10,0x10
    1920:	1b0000ef          	jal	ra,1ad0 <__udivsi3>
    1924:	010cdc93          	srli	s9,s9,0x10
    1928:	00050413          	mv	s0,a0
    192c:	00050593          	mv	a1,a0
    1930:	000c8513          	mv	a0,s9
    1934:	170000ef          	jal	ra,1aa4 <__mulsi3>
    1938:	010a1a13          	slli	s4,s4,0x10
    193c:	010c5713          	srli	a4,s8,0x10
    1940:	00ea6733          	or	a4,s4,a4
    1944:	00040a13          	mv	s4,s0
    1948:	00a77e63          	bleu	a0,a4,1964 <__umoddi3+0x3c0>
    194c:	01a70733          	add	a4,a4,s10
    1950:	fff40a13          	addi	s4,s0,-1
    1954:	01a76863          	bltu	a4,s10,1964 <__umoddi3+0x3c0>
    1958:	00a77663          	bleu	a0,a4,1964 <__umoddi3+0x3c0>
    195c:	ffe40a13          	addi	s4,s0,-2
    1960:	01a70733          	add	a4,a4,s10
    1964:	40a709b3          	sub	s3,a4,a0
    1968:	00048593          	mv	a1,s1
    196c:	00098513          	mv	a0,s3
    1970:	1a8000ef          	jal	ra,1b18 <__umodsi3>
    1974:	00048593          	mv	a1,s1
    1978:	00050413          	mv	s0,a0
    197c:	00098513          	mv	a0,s3
    1980:	150000ef          	jal	ra,1ad0 <__udivsi3>
    1984:	00050593          	mv	a1,a0
    1988:	00050493          	mv	s1,a0
    198c:	000c8513          	mv	a0,s9
    1990:	114000ef          	jal	ra,1aa4 <__mulsi3>
    1994:	010c1593          	slli	a1,s8,0x10
    1998:	01041413          	slli	s0,s0,0x10
    199c:	0105d593          	srli	a1,a1,0x10
    19a0:	00b465b3          	or	a1,s0,a1
    19a4:	00048713          	mv	a4,s1
    19a8:	00a5fe63          	bleu	a0,a1,19c4 <__umoddi3+0x420>
    19ac:	01a585b3          	add	a1,a1,s10
    19b0:	fff48713          	addi	a4,s1,-1
    19b4:	01a5e863          	bltu	a1,s10,19c4 <__umoddi3+0x420>
    19b8:	00a5f663          	bleu	a0,a1,19c4 <__umoddi3+0x420>
    19bc:	ffe48713          	addi	a4,s1,-2
    19c0:	01a585b3          	add	a1,a1,s10
    19c4:	010a1a13          	slli	s4,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    19c8:	00010cb7          	lui	s9,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    19cc:	00ea6a33          	or	s4,s4,a4
	      umul_ppmm (m1, m0, q0, d0);
    19d0:	fffc8413          	addi	s0,s9,-1 # ffff <__modsi3+0xe4b3>
    19d4:	008a77b3          	and	a5,s4,s0
    19d8:	008af433          	and	s0,s5,s0
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    19dc:	40a584b3          	sub	s1,a1,a0
	      umul_ppmm (m1, m0, q0, d0);
    19e0:	00078513          	mv	a0,a5
    19e4:	00040593          	mv	a1,s0
    19e8:	00f12623          	sw	a5,12(sp)
    19ec:	010a5a13          	srli	s4,s4,0x10
    19f0:	0b4000ef          	jal	ra,1aa4 <__mulsi3>
    19f4:	00050993          	mv	s3,a0
    19f8:	00040593          	mv	a1,s0
    19fc:	000a0513          	mv	a0,s4
    1a00:	0a4000ef          	jal	ra,1aa4 <__mulsi3>
    1a04:	010adc13          	srli	s8,s5,0x10
    1a08:	00050d93          	mv	s11,a0
    1a0c:	000c0593          	mv	a1,s8
    1a10:	000a0513          	mv	a0,s4
    1a14:	090000ef          	jal	ra,1aa4 <__mulsi3>
    1a18:	00c12783          	lw	a5,12(sp)
    1a1c:	00050a13          	mv	s4,a0
    1a20:	000c0593          	mv	a1,s8
    1a24:	00078513          	mv	a0,a5
    1a28:	07c000ef          	jal	ra,1aa4 <__mulsi3>
    1a2c:	01b50533          	add	a0,a0,s11
    1a30:	0109d713          	srli	a4,s3,0x10
    1a34:	00a70733          	add	a4,a4,a0
    1a38:	01b77463          	bleu	s11,a4,1a40 <__umoddi3+0x49c>
    1a3c:	019a0a33          	add	s4,s4,s9
    1a40:	000107b7          	lui	a5,0x10
    1a44:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe4b3>
    1a48:	01075593          	srli	a1,a4,0x10
    1a4c:	00f77733          	and	a4,a4,a5
    1a50:	01071713          	slli	a4,a4,0x10
    1a54:	00f9f7b3          	and	a5,s3,a5
    1a58:	014585b3          	add	a1,a1,s4
    1a5c:	00f707b3          	add	a5,a4,a5
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1a60:	00b4e663          	bltu	s1,a1,1a6c <__umoddi3+0x4c8>
    1a64:	00b49e63          	bne	s1,a1,1a80 <__umoddi3+0x4dc>
    1a68:	00f97c63          	bleu	a5,s2,1a80 <__umoddi3+0x4dc>
		  sub_ddmmss (m1, m0, m1, m0, d1, d0);
    1a6c:	41578633          	sub	a2,a5,s5
    1a70:	00c7b7b3          	sltu	a5,a5,a2
    1a74:	41a585b3          	sub	a1,a1,s10
    1a78:	40f585b3          	sub	a1,a1,a5
    1a7c:	00060793          	mv	a5,a2
		  sub_ddmmss (n1, n0, n1, n0, m1, m0);
    1a80:	40f907b3          	sub	a5,s2,a5
    1a84:	00f93933          	sltu	s2,s2,a5
    1a88:	40b485b3          	sub	a1,s1,a1
    1a8c:	412585b3          	sub	a1,a1,s2
		  rr.s.low = (n1 << b) | (n0 >> bm);
    1a90:	01759433          	sll	s0,a1,s7
    1a94:	0167d7b3          	srl	a5,a5,s6
		  *rp = rr.ll;
    1a98:	00f46533          	or	a0,s0,a5
    1a9c:	0165d5b3          	srl	a1,a1,s6
  return w;
    1aa0:	c59ff06f          	j	16f8 <__umoddi3+0x154>

00001aa4 <__mulsi3>:
# define __muldi3 __mulsi3
#endif

  .globl __muldi3
__muldi3:
  mv     a2, a0
    1aa4:	00050613          	mv	a2,a0
  li     a0, 0
    1aa8:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
    1aac:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
    1ab0:	00068463          	beqz	a3,1ab8 <__mulsi3+0x14>
  add    a0, a0, a2
    1ab4:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
    1ab8:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
    1abc:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
    1ac0:	fe0596e3          	bnez	a1,1aac <__mulsi3+0x8>
  ret
    1ac4:	00008067          	ret

00001ac8 <__divsi3>:
  beq   a1, t0, .L20
#endif

  .globl __divdi3
__divdi3:
  bltz  a0, .L10
    1ac8:	06054063          	bltz	a0,1b28 <__umodsi3+0x10>
  bltz  a1, .L11
    1acc:	0605c663          	bltz	a1,1b38 <__umodsi3+0x20>

00001ad0 <__udivsi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

  .globl __udivdi3
__udivdi3:
  mv    a2, a1
    1ad0:	00058613          	mv	a2,a1
  mv    a1, a0
    1ad4:	00050593          	mv	a1,a0
  li    a0, -1
    1ad8:	fff00513          	li	a0,-1
  beqz  a2, .L5
    1adc:	02060c63          	beqz	a2,1b14 <__udivsi3+0x44>
  li    a3, 1
    1ae0:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
    1ae4:	00b67a63          	bleu	a1,a2,1af8 <__udivsi3+0x28>
.L1:
  blez  a2, .L2
    1ae8:	00c05863          	blez	a2,1af8 <__udivsi3+0x28>
  slli  a2, a2, 1
    1aec:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
    1af0:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
    1af4:	feb66ae3          	bltu	a2,a1,1ae8 <__udivsi3+0x18>
.L2:
  li    a0, 0
    1af8:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
    1afc:	00c5e663          	bltu	a1,a2,1b08 <__udivsi3+0x38>
  sub   a1, a1, a2
    1b00:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
    1b04:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
    1b08:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
    1b0c:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
    1b10:	fe0696e3          	bnez	a3,1afc <__udivsi3+0x2c>
.L5:
  ret
    1b14:	00008067          	ret

00001b18 <__umodsi3>:

  .globl __umoddi3
__umoddi3:
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
    1b18:	00008293          	mv	t0,ra
  jal   __udivdi3
    1b1c:	fb5ff0ef          	jal	ra,1ad0 <__udivsi3>
  move  a0, a1
    1b20:	00058513          	mv	a0,a1
  jr    t0
    1b24:	00028067          	jr	t0

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
    1b28:	40a00533          	neg	a0,a0
  bgez  a1, .L12      /* Compute __udivdi3(-a0, a1), then negate the result.  */
    1b2c:	0005d863          	bgez	a1,1b3c <__umodsi3+0x24>
  neg   a1, a1
    1b30:	40b005b3          	neg	a1,a1
  j     __udivdi3     /* Compute __udivdi3(-a0, -a1).  */
    1b34:	f9dff06f          	j	1ad0 <__udivsi3>
.L11:                 /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
    1b38:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
    1b3c:	00008293          	mv	t0,ra
  jal   __udivdi3
    1b40:	f91ff0ef          	jal	ra,1ad0 <__udivsi3>
  neg   a0, a0
    1b44:	40a00533          	neg	a0,a0
  jr    t0
    1b48:	00028067          	jr	t0

00001b4c <__modsi3>:

  .globl __moddi3
__moddi3:
  move   t0, ra
    1b4c:	00008293          	mv	t0,ra
  bltz   a1, .L31
    1b50:	0005ca63          	bltz	a1,1b64 <__modsi3+0x18>
  bltz   a0, .L32
    1b54:	00054c63          	bltz	a0,1b6c <__modsi3+0x20>
.L30:
  jal    __udivdi3    /* The dividend is not negative.  */
    1b58:	f79ff0ef          	jal	ra,1ad0 <__udivsi3>
  move   a0, a1
    1b5c:	00058513          	mv	a0,a1
  jr     t0
    1b60:	00028067          	jr	t0
.L31:
  neg    a1, a1
    1b64:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
    1b68:	fe0558e3          	bgez	a0,1b58 <__modsi3+0xc>
.L32:
  neg    a0, a0
    1b6c:	40a00533          	neg	a0,a0
  jal    __udivdi3    /* The dividend is hella negative.  */
    1b70:	f61ff0ef          	jal	ra,1ad0 <__udivsi3>
  neg    a0, a1
    1b74:	40b00533          	neg	a0,a1
  jr     t0
    1b78:	00028067          	jr	t0
