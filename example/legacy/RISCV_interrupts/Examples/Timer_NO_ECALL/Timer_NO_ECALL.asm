
Timer_NO_ECALL.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
       0:	00002fb7          	lui	t6,0x2
       4:	800f8f93          	addi	t6,t6,-2048 # 1800 <__umoddi3+0x1d0>
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
      44:	0f428293          	addi	t0,t0,244 # 134 <level_0_interrupt_handler>
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
      cc:	a8818193          	addi	gp,gp,-1400 # 20b50 <_gp>

000000d0 <init_bss>:
      d0:	00020517          	auipc	a0,0x20
      d4:	2b050513          	addi	a0,a0,688 # 20380 <__bss_start>
      d8:	00020597          	auipc	a1,0x20
      dc:	3ac58593          	addi	a1,a1,940 # 20484 <tohost+0x4>
      e0:	00000613          	li	a2,0
      e4:	0ec000ef          	jal	ra,1d0 <fill_block>

000000e8 <init_sbss>:
      e8:	00020517          	auipc	a0,0x20
      ec:	26050513          	addi	a0,a0,608 # 20348 <num_ticks>
      f0:	00020597          	auipc	a1,0x20
      f4:	25c58593          	addi	a1,a1,604 # 2034c <timer_ticked>
      f8:	00000613          	li	a2,0
      fc:	0d4000ef          	jal	ra,1d0 <fill_block>

00000100 <write_stack_pattern>:
     100:	00021517          	auipc	a0,0x21
     104:	38850513          	addi	a0,a0,904 # 21488 <_heap_end>
     108:	00022597          	auipc	a1,0x22
     10c:	37c58593          	addi	a1,a1,892 # 22484 <_heap_end+0xffc>
     110:	ababb637          	lui	a2,0xababb
     114:	bab60613          	addi	a2,a2,-1109 # abababab <__stack+0xaba98723>
     118:	0b8000ef          	jal	ra,1d0 <fill_block>

0000011c <init_stack>:
     11c:	00022117          	auipc	sp,0x22
     120:	36c10113          	addi	sp,sp,876 # 22488 <__stack>
     124:	08000313          	li	t1,128
     128:	30431073          	csrw	mie,t1
     12c:	30045073          	csrwi	mstatus,8
     130:	2e80006f          	j	418 <vSyscallInit>

00000134 <level_0_interrupt_handler>:
     134:	f8010113          	addi	sp,sp,-128
     138:	00112023          	sw	ra,0(sp)
     13c:	00412623          	sw	tp,12(sp)
     140:	00512823          	sw	t0,16(sp)
     144:	00612a23          	sw	t1,20(sp)
     148:	00712c23          	sw	t2,24(sp)
     14c:	02a12223          	sw	a0,36(sp)
     150:	02b12423          	sw	a1,40(sp)
     154:	02c12623          	sw	a2,44(sp)
     158:	02d12823          	sw	a3,48(sp)
     15c:	02e12a23          	sw	a4,52(sp)
     160:	02f12c23          	sw	a5,56(sp)
     164:	03012e23          	sw	a6,60(sp)
     168:	05112023          	sw	a7,64(sp)
     16c:	07c12623          	sw	t3,108(sp)
     170:	07d12823          	sw	t4,112(sp)
     174:	07e12a23          	sw	t5,116(sp)
     178:	07f12c23          	sw	t6,120(sp)
     17c:	34202573          	csrr	a0,mcause
     180:	501000ef          	jal	ra,e80 <level_1_interrupt_handler>
     184:	00012083          	lw	ra,0(sp)
     188:	00c12203          	lw	tp,12(sp)
     18c:	01012283          	lw	t0,16(sp)
     190:	01412303          	lw	t1,20(sp)
     194:	01812383          	lw	t2,24(sp)
     198:	02412503          	lw	a0,36(sp)
     19c:	02812583          	lw	a1,40(sp)
     1a0:	02c12603          	lw	a2,44(sp)
     1a4:	03012683          	lw	a3,48(sp)
     1a8:	03412703          	lw	a4,52(sp)
     1ac:	03812783          	lw	a5,56(sp)
     1b0:	03c12803          	lw	a6,60(sp)
     1b4:	04012883          	lw	a7,64(sp)
     1b8:	06c12e03          	lw	t3,108(sp)
     1bc:	07012e83          	lw	t4,112(sp)
     1c0:	07412f03          	lw	t5,116(sp)
     1c4:	07812f83          	lw	t6,120(sp)
     1c8:	08010113          	addi	sp,sp,128
     1cc:	30200073          	mret

000001d0 <fill_block>:
     1d0:	00c52023          	sw	a2,0(a0)
     1d4:	00b57663          	bleu	a1,a0,1e0 <fb_end>
     1d8:	00450513          	addi	a0,a0,4
     1dc:	ff5ff06f          	j	1d0 <fill_block>

000001e0 <fb_end>:
     1e0:	00008067          	ret
	...

000001f4 <zeroExtend>:
     1f4:	fe010113          	addi	sp,sp,-32
     1f8:	00a12623          	sw	a0,12(sp)
     1fc:	00c12783          	lw	a5,12(sp)
     200:	00f12c23          	sw	a5,24(sp)
     204:	41f7d793          	srai	a5,a5,0x1f
     208:	00f12e23          	sw	a5,28(sp)
     20c:	00c12783          	lw	a5,12(sp)
     210:	00f12c23          	sw	a5,24(sp)
     214:	00012e23          	sw	zero,28(sp)
     218:	01812783          	lw	a5,24(sp)
     21c:	01c12803          	lw	a6,28(sp)
     220:	00078513          	mv	a0,a5
     224:	00080593          	mv	a1,a6
     228:	02010113          	addi	sp,sp,32
     22c:	00008067          	ret

00000230 <prvSyscallToHost>:
     230:	f6010113          	addi	sp,sp,-160
     234:	08112e23          	sw	ra,156(sp)
     238:	08812c23          	sw	s0,152(sp)
     23c:	00a12623          	sw	a0,12(sp)
     240:	00b12423          	sw	a1,8(sp)
     244:	00c12223          	sw	a2,4(sp)
     248:	00d12023          	sw	a3,0(sp)
     24c:	09010793          	addi	a5,sp,144
     250:	f8078793          	addi	a5,a5,-128
     254:	03f78793          	addi	a5,a5,63
     258:	0067d793          	srli	a5,a5,0x6
     25c:	00679413          	slli	s0,a5,0x6
     260:	00c12503          	lw	a0,12(sp)
     264:	f91ff0ef          	jal	ra,1f4 <zeroExtend>
     268:	00050793          	mv	a5,a0
     26c:	00058813          	mv	a6,a1
     270:	00f42023          	sw	a5,0(s0)
     274:	01042223          	sw	a6,4(s0)
     278:	00812503          	lw	a0,8(sp)
     27c:	f79ff0ef          	jal	ra,1f4 <zeroExtend>
     280:	00050793          	mv	a5,a0
     284:	00058813          	mv	a6,a1
     288:	00f42423          	sw	a5,8(s0)
     28c:	01042623          	sw	a6,12(s0)
     290:	00412503          	lw	a0,4(sp)
     294:	f61ff0ef          	jal	ra,1f4 <zeroExtend>
     298:	00050793          	mv	a5,a0
     29c:	00058813          	mv	a6,a1
     2a0:	00f42823          	sw	a5,16(s0)
     2a4:	01042a23          	sw	a6,20(s0)
     2a8:	00012503          	lw	a0,0(sp)
     2ac:	f49ff0ef          	jal	ra,1f4 <zeroExtend>
     2b0:	00050793          	mv	a5,a0
     2b4:	00058813          	mv	a6,a1
     2b8:	00f42c23          	sw	a5,24(s0)
     2bc:	01042e23          	sw	a6,28(s0)
     2c0:	0ff0000f          	fence
     2c4:	00040793          	mv	a5,s0
     2c8:	00078513          	mv	a0,a5
     2cc:	f29ff0ef          	jal	ra,1f4 <zeroExtend>
     2d0:	00050793          	mv	a5,a0
     2d4:	00058813          	mv	a6,a1
     2d8:	00020717          	auipc	a4,0x20
     2dc:	1a870713          	addi	a4,a4,424 # 20480 <tohost>
     2e0:	00f72023          	sw	a5,0(a4)
     2e4:	01072223          	sw	a6,4(a4)
     2e8:	00042783          	lw	a5,0(s0)
     2ec:	00442803          	lw	a6,4(s0)
     2f0:	00078513          	mv	a0,a5
     2f4:	00080593          	mv	a1,a6
     2f8:	09c12083          	lw	ra,156(sp)
     2fc:	09812403          	lw	s0,152(sp)
     300:	0a010113          	addi	sp,sp,160
     304:	00008067          	ret

00000308 <prvSyscallExit>:
     308:	fc010113          	addi	sp,sp,-64
     30c:	02112e23          	sw	ra,60(sp)
     310:	02812c23          	sw	s0,56(sp)
     314:	02912a23          	sw	s1,52(sp)
     318:	03212823          	sw	s2,48(sp)
     31c:	03312623          	sw	s3,44(sp)
     320:	00a12623          	sw	a0,12(sp)
     324:	00c12503          	lw	a0,12(sp)
     328:	ecdff0ef          	jal	ra,1f4 <zeroExtend>
     32c:	00a12c23          	sw	a0,24(sp)
     330:	00b12e23          	sw	a1,28(sp)
     334:	01812783          	lw	a5,24(sp)
     338:	01f7d793          	srli	a5,a5,0x1f
     33c:	01c12703          	lw	a4,28(sp)
     340:	00171493          	slli	s1,a4,0x1
     344:	0097e4b3          	or	s1,a5,s1
     348:	01812783          	lw	a5,24(sp)
     34c:	00179413          	slli	s0,a5,0x1
     350:	00146913          	ori	s2,s0,1
     354:	0004e993          	ori	s3,s1,0
     358:	00020797          	auipc	a5,0x20
     35c:	12878793          	addi	a5,a5,296 # 20480 <tohost>
     360:	0127a023          	sw	s2,0(a5)
     364:	0137a223          	sw	s3,4(a5)
     368:	0000006f          	j	368 <prvSyscallExit+0x60>

0000036c <printstr>:
     36c:	fe010113          	addi	sp,sp,-32
     370:	00112e23          	sw	ra,28(sp)
     374:	00812c23          	sw	s0,24(sp)
     378:	00a12623          	sw	a0,12(sp)
     37c:	00c12403          	lw	s0,12(sp)
     380:	00c12503          	lw	a0,12(sp)
     384:	491000ef          	jal	ra,1014 <strlen>
     388:	00050793          	mv	a5,a0
     38c:	00078693          	mv	a3,a5
     390:	00040613          	mv	a2,s0
     394:	00100593          	li	a1,1
     398:	04000513          	li	a0,64
     39c:	018000ef          	jal	ra,3b4 <syscall>
     3a0:	00000013          	nop
     3a4:	01c12083          	lw	ra,28(sp)
     3a8:	01812403          	lw	s0,24(sp)
     3ac:	02010113          	addi	sp,sp,32
     3b0:	00008067          	ret

000003b4 <syscall>:
     3b4:	ff010113          	addi	sp,sp,-16
     3b8:	00a12623          	sw	a0,12(sp)
     3bc:	00b12423          	sw	a1,8(sp)
     3c0:	00c12223          	sw	a2,4(sp)
     3c4:	00d12023          	sw	a3,0(sp)
     3c8:	00c12703          	lw	a4,12(sp)
     3cc:	05d00793          	li	a5,93
     3d0:	00f71463          	bne	a4,a5,3d8 <syscall+0x24>
     3d4:	00100073          	ebreak
     3d8:	00812783          	lw	a5,8(sp)
     3dc:	00078513          	mv	a0,a5
     3e0:	01010113          	addi	sp,sp,16
     3e4:	00008067          	ret
     3e8:	fe010113          	addi	sp,sp,-32
     3ec:	00112e23          	sw	ra,28(sp)
     3f0:	00a12623          	sw	a0,12(sp)
     3f4:	00b12423          	sw	a1,8(sp)
     3f8:	00020517          	auipc	a0,0x20
     3fc:	c0850513          	addi	a0,a0,-1016 # 20000 <__rodata_start>
     400:	f6dff0ef          	jal	ra,36c <printstr>
     404:	fff00793          	li	a5,-1
     408:	00078513          	mv	a0,a5
     40c:	01c12083          	lw	ra,28(sp)
     410:	02010113          	addi	sp,sp,32
     414:	00008067          	ret

00000418 <vSyscallInit>:
     418:	fe010113          	addi	sp,sp,-32
     41c:	00112e23          	sw	ra,28(sp)
     420:	00000593          	li	a1,0
     424:	00000513          	li	a0,0
     428:	399000ef          	jal	ra,fc0 <main>
     42c:	00a12623          	sw	a0,12(sp)
     430:	00c12503          	lw	a0,12(sp)
     434:	079000ef          	jal	ra,cac <exit>
     438:	00000013          	nop
     43c:	01c12083          	lw	ra,28(sp)
     440:	02010113          	addi	sp,sp,32
     444:	00008067          	ret

00000448 <ulSyscallTrap>:
     448:	fd010113          	addi	sp,sp,-48
     44c:	02112623          	sw	ra,44(sp)
     450:	00a12623          	sw	a0,12(sp)
     454:	00b12423          	sw	a1,8(sp)
     458:	00c12223          	sw	a2,4(sp)
     45c:	00012e23          	sw	zero,28(sp)
     460:	00c12703          	lw	a4,12(sp)
     464:	00b00793          	li	a5,11
     468:	00f70863          	beq	a4,a5,478 <ulSyscallTrap+0x30>
     46c:	00c12503          	lw	a0,12(sp)
     470:	e99ff0ef          	jal	ra,308 <prvSyscallExit>
     474:	0780006f          	j	4ec <ulSyscallTrap+0xa4>
     478:	00412783          	lw	a5,4(sp)
     47c:	04478793          	addi	a5,a5,68
     480:	0007a703          	lw	a4,0(a5)
     484:	05d00793          	li	a5,93
     488:	00f71e63          	bne	a4,a5,4a4 <ulSyscallTrap+0x5c>
     48c:	00412783          	lw	a5,4(sp)
     490:	02878793          	addi	a5,a5,40
     494:	0007a783          	lw	a5,0(a5)
     498:	00078513          	mv	a0,a5
     49c:	e6dff0ef          	jal	ra,308 <prvSyscallExit>
     4a0:	04c0006f          	j	4ec <ulSyscallTrap+0xa4>
     4a4:	00412783          	lw	a5,4(sp)
     4a8:	04478793          	addi	a5,a5,68
     4ac:	0007a703          	lw	a4,0(a5)
     4b0:	00412783          	lw	a5,4(sp)
     4b4:	02878793          	addi	a5,a5,40
     4b8:	0007a583          	lw	a1,0(a5)
     4bc:	00412783          	lw	a5,4(sp)
     4c0:	02c78793          	addi	a5,a5,44
     4c4:	0007a603          	lw	a2,0(a5)
     4c8:	00412783          	lw	a5,4(sp)
     4cc:	03078793          	addi	a5,a5,48
     4d0:	0007a783          	lw	a5,0(a5)
     4d4:	00078693          	mv	a3,a5
     4d8:	00070513          	mv	a0,a4
     4dc:	d55ff0ef          	jal	ra,230 <prvSyscallToHost>
     4e0:	00050793          	mv	a5,a0
     4e4:	00058813          	mv	a6,a1
     4e8:	00f12e23          	sw	a5,28(sp)
     4ec:	00412783          	lw	a5,4(sp)
     4f0:	02878793          	addi	a5,a5,40
     4f4:	01c12703          	lw	a4,28(sp)
     4f8:	00e7a023          	sw	a4,0(a5)
     4fc:	00812783          	lw	a5,8(sp)
     500:	00478793          	addi	a5,a5,4
     504:	00078513          	mv	a0,a5
     508:	02c12083          	lw	ra,44(sp)
     50c:	03010113          	addi	sp,sp,48
     510:	00008067          	ret

00000514 <putchar>:
     514:	fe010113          	addi	sp,sp,-32
     518:	00112e23          	sw	ra,28(sp)
     51c:	00a12623          	sw	a0,12(sp)
     520:	00020797          	auipc	a5,0x20
     524:	e6078793          	addi	a5,a5,-416 # 20380 <__bss_start>
     528:	0007a783          	lw	a5,0(a5)
     52c:	00178693          	addi	a3,a5,1
     530:	00020717          	auipc	a4,0x20
     534:	e5070713          	addi	a4,a4,-432 # 20380 <__bss_start>
     538:	00d72023          	sw	a3,0(a4)
     53c:	00c12703          	lw	a4,12(sp)
     540:	0ff77713          	andi	a4,a4,255
     544:	00020697          	auipc	a3,0x20
     548:	e7c68693          	addi	a3,a3,-388 # 203c0 <buf.2126>
     54c:	00f687b3          	add	a5,a3,a5
     550:	00e78023          	sb	a4,0(a5)
     554:	00c12703          	lw	a4,12(sp)
     558:	00a00793          	li	a5,10
     55c:	00f70c63          	beq	a4,a5,574 <putchar+0x60>
     560:	00020797          	auipc	a5,0x20
     564:	e2078793          	addi	a5,a5,-480 # 20380 <__bss_start>
     568:	0007a703          	lw	a4,0(a5)
     56c:	04000793          	li	a5,64
     570:	02f71c63          	bne	a4,a5,5a8 <putchar+0x94>
     574:	00020717          	auipc	a4,0x20
     578:	e4c70713          	addi	a4,a4,-436 # 203c0 <buf.2126>
     57c:	00020797          	auipc	a5,0x20
     580:	e0478793          	addi	a5,a5,-508 # 20380 <__bss_start>
     584:	0007a783          	lw	a5,0(a5)
     588:	00078693          	mv	a3,a5
     58c:	00070613          	mv	a2,a4
     590:	00100593          	li	a1,1
     594:	04000513          	li	a0,64
     598:	e1dff0ef          	jal	ra,3b4 <syscall>
     59c:	00020797          	auipc	a5,0x20
     5a0:	de478793          	addi	a5,a5,-540 # 20380 <__bss_start>
     5a4:	0007a023          	sw	zero,0(a5)
     5a8:	00000793          	li	a5,0
     5ac:	00078513          	mv	a0,a5
     5b0:	01c12083          	lw	ra,28(sp)
     5b4:	02010113          	addi	sp,sp,32
     5b8:	00008067          	ret

000005bc <printnum>:
     5bc:	eb010113          	addi	sp,sp,-336
     5c0:	14112623          	sw	ra,332(sp)
     5c4:	14812423          	sw	s0,328(sp)
     5c8:	14912223          	sw	s1,324(sp)
     5cc:	15212023          	sw	s2,320(sp)
     5d0:	13312e23          	sw	s3,316(sp)
     5d4:	13412c23          	sw	s4,312(sp)
     5d8:	13512a23          	sw	s5,308(sp)
     5dc:	00a12e23          	sw	a0,28(sp)
     5e0:	00b12c23          	sw	a1,24(sp)
     5e4:	00c12823          	sw	a2,16(sp)
     5e8:	00d12a23          	sw	a3,20(sp)
     5ec:	00e12623          	sw	a4,12(sp)
     5f0:	00f12423          	sw	a5,8(sp)
     5f4:	01012223          	sw	a6,4(sp)
     5f8:	12012623          	sw	zero,300(sp)
     5fc:	00c12783          	lw	a5,12(sp)
     600:	00078a13          	mv	s4,a5
     604:	00000a93          	li	s5,0
     608:	01012783          	lw	a5,16(sp)
     60c:	01412803          	lw	a6,20(sp)
     610:	000a0613          	mv	a2,s4
     614:	000a8693          	mv	a3,s5
     618:	00078513          	mv	a0,a5
     61c:	00080593          	mv	a1,a6
     620:	010010ef          	jal	ra,1630 <__umoddi3>
     624:	00050793          	mv	a5,a0
     628:	00058813          	mv	a6,a1
     62c:	00078613          	mv	a2,a5
     630:	00080693          	mv	a3,a6
     634:	12c12783          	lw	a5,300(sp)
     638:	00178713          	addi	a4,a5,1
     63c:	12e12623          	sw	a4,300(sp)
     640:	00060713          	mv	a4,a2
     644:	00279793          	slli	a5,a5,0x2
     648:	13010693          	addi	a3,sp,304
     64c:	00f687b3          	add	a5,a3,a5
     650:	eee7ae23          	sw	a4,-260(a5)
     654:	00c12783          	lw	a5,12(sp)
     658:	00078413          	mv	s0,a5
     65c:	00000493          	li	s1,0
     660:	01412783          	lw	a5,20(sp)
     664:	00048713          	mv	a4,s1
     668:	04e7e863          	bltu	a5,a4,6b8 <printnum+0xfc>
     66c:	01412783          	lw	a5,20(sp)
     670:	00048713          	mv	a4,s1
     674:	00e79863          	bne	a5,a4,684 <printnum+0xc8>
     678:	01012783          	lw	a5,16(sp)
     67c:	00040713          	mv	a4,s0
     680:	02e7ec63          	bltu	a5,a4,6b8 <printnum+0xfc>
     684:	00c12783          	lw	a5,12(sp)
     688:	00078913          	mv	s2,a5
     68c:	00000993          	li	s3,0
     690:	00090613          	mv	a2,s2
     694:	00098693          	mv	a3,s3
     698:	01012503          	lw	a0,16(sp)
     69c:	01412583          	lw	a1,20(sp)
     6a0:	1b5000ef          	jal	ra,1054 <__udivdi3>
     6a4:	00050793          	mv	a5,a0
     6a8:	00058813          	mv	a6,a1
     6ac:	00f12823          	sw	a5,16(sp)
     6b0:	01012a23          	sw	a6,20(sp)
     6b4:	f49ff06f          	j	5fc <printnum+0x40>
     6b8:	00000013          	nop
     6bc:	0140006f          	j	6d0 <printnum+0x114>
     6c0:	01c12783          	lw	a5,28(sp)
     6c4:	01812583          	lw	a1,24(sp)
     6c8:	00412503          	lw	a0,4(sp)
     6cc:	000780e7          	jalr	a5
     6d0:	00812783          	lw	a5,8(sp)
     6d4:	fff78713          	addi	a4,a5,-1
     6d8:	00e12423          	sw	a4,8(sp)
     6dc:	12c12703          	lw	a4,300(sp)
     6e0:	fef740e3          	blt	a4,a5,6c0 <printnum+0x104>
     6e4:	0540006f          	j	738 <printnum+0x17c>
     6e8:	12c12783          	lw	a5,300(sp)
     6ec:	00279793          	slli	a5,a5,0x2
     6f0:	13010713          	addi	a4,sp,304
     6f4:	00f707b3          	add	a5,a4,a5
     6f8:	efc7a703          	lw	a4,-260(a5)
     6fc:	12c12783          	lw	a5,300(sp)
     700:	00279793          	slli	a5,a5,0x2
     704:	13010693          	addi	a3,sp,304
     708:	00f687b3          	add	a5,a3,a5
     70c:	efc7a683          	lw	a3,-260(a5)
     710:	00900793          	li	a5,9
     714:	00d7f663          	bleu	a3,a5,720 <printnum+0x164>
     718:	05700793          	li	a5,87
     71c:	0080006f          	j	724 <printnum+0x168>
     720:	03000793          	li	a5,48
     724:	00e787b3          	add	a5,a5,a4
     728:	01c12703          	lw	a4,28(sp)
     72c:	01812583          	lw	a1,24(sp)
     730:	00078513          	mv	a0,a5
     734:	000700e7          	jalr	a4
     738:	12c12783          	lw	a5,300(sp)
     73c:	fff78713          	addi	a4,a5,-1
     740:	12e12623          	sw	a4,300(sp)
     744:	faf042e3          	bgtz	a5,6e8 <printnum+0x12c>
     748:	00000013          	nop
     74c:	14c12083          	lw	ra,332(sp)
     750:	14812403          	lw	s0,328(sp)
     754:	14412483          	lw	s1,324(sp)
     758:	14012903          	lw	s2,320(sp)
     75c:	13c12983          	lw	s3,316(sp)
     760:	13812a03          	lw	s4,312(sp)
     764:	13412a83          	lw	s5,308(sp)
     768:	15010113          	addi	sp,sp,336
     76c:	00008067          	ret

00000770 <getuint>:
     770:	ff010113          	addi	sp,sp,-16
     774:	00a12623          	sw	a0,12(sp)
     778:	00b12423          	sw	a1,8(sp)
     77c:	00812683          	lw	a3,8(sp)
     780:	00100713          	li	a4,1
     784:	02d75663          	ble	a3,a4,7b0 <getuint+0x40>
     788:	00c12783          	lw	a5,12(sp)
     78c:	0007a783          	lw	a5,0(a5)
     790:	00778793          	addi	a5,a5,7
     794:	ff87f793          	andi	a5,a5,-8
     798:	00878693          	addi	a3,a5,8
     79c:	00c12703          	lw	a4,12(sp)
     7a0:	00d72023          	sw	a3,0(a4)
     7a4:	0047a803          	lw	a6,4(a5)
     7a8:	0007a783          	lw	a5,0(a5)
     7ac:	0500006f          	j	7fc <getuint+0x8c>
     7b0:	00812703          	lw	a4,8(sp)
     7b4:	02070463          	beqz	a4,7dc <getuint+0x6c>
     7b8:	00c12703          	lw	a4,12(sp)
     7bc:	00072703          	lw	a4,0(a4)
     7c0:	00470613          	addi	a2,a4,4
     7c4:	00c12683          	lw	a3,12(sp)
     7c8:	00c6a023          	sw	a2,0(a3)
     7cc:	00072703          	lw	a4,0(a4)
     7d0:	00070793          	mv	a5,a4
     7d4:	00000813          	li	a6,0
     7d8:	0240006f          	j	7fc <getuint+0x8c>
     7dc:	00c12703          	lw	a4,12(sp)
     7e0:	00072703          	lw	a4,0(a4)
     7e4:	00470613          	addi	a2,a4,4
     7e8:	00c12683          	lw	a3,12(sp)
     7ec:	00c6a023          	sw	a2,0(a3)
     7f0:	00072703          	lw	a4,0(a4)
     7f4:	00070793          	mv	a5,a4
     7f8:	00000813          	li	a6,0
     7fc:	00078513          	mv	a0,a5
     800:	00080593          	mv	a1,a6
     804:	01010113          	addi	sp,sp,16
     808:	00008067          	ret

0000080c <getint>:
     80c:	ff010113          	addi	sp,sp,-16
     810:	00a12623          	sw	a0,12(sp)
     814:	00b12423          	sw	a1,8(sp)
     818:	00812683          	lw	a3,8(sp)
     81c:	00100713          	li	a4,1
     820:	02d75663          	ble	a3,a4,84c <getint+0x40>
     824:	00c12783          	lw	a5,12(sp)
     828:	0007a783          	lw	a5,0(a5)
     82c:	00778793          	addi	a5,a5,7
     830:	ff87f793          	andi	a5,a5,-8
     834:	00878693          	addi	a3,a5,8
     838:	00c12703          	lw	a4,12(sp)
     83c:	00d72023          	sw	a3,0(a4)
     840:	0047a803          	lw	a6,4(a5)
     844:	0007a783          	lw	a5,0(a5)
     848:	0580006f          	j	8a0 <getint+0x94>
     84c:	00812703          	lw	a4,8(sp)
     850:	02070663          	beqz	a4,87c <getint+0x70>
     854:	00c12703          	lw	a4,12(sp)
     858:	00072703          	lw	a4,0(a4)
     85c:	00470613          	addi	a2,a4,4
     860:	00c12683          	lw	a3,12(sp)
     864:	00c6a023          	sw	a2,0(a3)
     868:	00072703          	lw	a4,0(a4)
     86c:	00070793          	mv	a5,a4
     870:	41f75713          	srai	a4,a4,0x1f
     874:	00070813          	mv	a6,a4
     878:	0280006f          	j	8a0 <getint+0x94>
     87c:	00c12703          	lw	a4,12(sp)
     880:	00072703          	lw	a4,0(a4)
     884:	00470613          	addi	a2,a4,4
     888:	00c12683          	lw	a3,12(sp)
     88c:	00c6a023          	sw	a2,0(a3)
     890:	00072703          	lw	a4,0(a4)
     894:	00070793          	mv	a5,a4
     898:	41f75713          	srai	a4,a4,0x1f
     89c:	00070813          	mv	a6,a4
     8a0:	00078513          	mv	a0,a5
     8a4:	00080593          	mv	a1,a6
     8a8:	01010113          	addi	sp,sp,16
     8ac:	00008067          	ret

000008b0 <vFormatPrintString>:
     8b0:	fc010113          	addi	sp,sp,-64
     8b4:	02112e23          	sw	ra,60(sp)
     8b8:	02812c23          	sw	s0,56(sp)
     8bc:	02912a23          	sw	s1,52(sp)
     8c0:	00a12623          	sw	a0,12(sp)
     8c4:	00b12423          	sw	a1,8(sp)
     8c8:	00c12223          	sw	a2,4(sp)
     8cc:	00d12023          	sw	a3,0(sp)
     8d0:	0240006f          	j	8f4 <vFormatPrintString+0x44>
     8d4:	3c040063          	beqz	s0,c94 <vFormatPrintString+0x3e4>
     8d8:	00412783          	lw	a5,4(sp)
     8dc:	00178793          	addi	a5,a5,1
     8e0:	00f12223          	sw	a5,4(sp)
     8e4:	00c12783          	lw	a5,12(sp)
     8e8:	00812583          	lw	a1,8(sp)
     8ec:	00040513          	mv	a0,s0
     8f0:	000780e7          	jalr	a5
     8f4:	00412783          	lw	a5,4(sp)
     8f8:	0007c783          	lbu	a5,0(a5)
     8fc:	00078413          	mv	s0,a5
     900:	02500793          	li	a5,37
     904:	fcf418e3          	bne	s0,a5,8d4 <vFormatPrintString+0x24>
     908:	00412783          	lw	a5,4(sp)
     90c:	00178793          	addi	a5,a5,1
     910:	00f12223          	sw	a5,4(sp)
     914:	00412783          	lw	a5,4(sp)
     918:	00f12823          	sw	a5,16(sp)
     91c:	02000793          	li	a5,32
     920:	00f10ba3          	sb	a5,23(sp)
     924:	fff00793          	li	a5,-1
     928:	00f12e23          	sw	a5,28(sp)
     92c:	fff00793          	li	a5,-1
     930:	00f12c23          	sw	a5,24(sp)
     934:	02012023          	sw	zero,32(sp)
     938:	00412783          	lw	a5,4(sp)
     93c:	00178713          	addi	a4,a5,1
     940:	00e12223          	sw	a4,4(sp)
     944:	0007c783          	lbu	a5,0(a5)
     948:	00078413          	mv	s0,a5
     94c:	fdd40793          	addi	a5,s0,-35
     950:	05500713          	li	a4,85
     954:	32f76063          	bltu	a4,a5,c74 <vFormatPrintString+0x3c4>
     958:	00279713          	slli	a4,a5,0x2
     95c:	0001f797          	auipc	a5,0x1f
     960:	6c878793          	addi	a5,a5,1736 # 20024 <__rodata_start+0x24>
     964:	00f707b3          	add	a5,a4,a5
     968:	0007a703          	lw	a4,0(a5)
     96c:	0001f797          	auipc	a5,0x1f
     970:	6b878793          	addi	a5,a5,1720 # 20024 <__rodata_start+0x24>
     974:	00f707b3          	add	a5,a4,a5
     978:	00078067          	jr	a5
     97c:	02d00793          	li	a5,45
     980:	00f10ba3          	sb	a5,23(sp)
     984:	fb5ff06f          	j	938 <vFormatPrintString+0x88>
     988:	03000793          	li	a5,48
     98c:	00f10ba3          	sb	a5,23(sp)
     990:	fa9ff06f          	j	938 <vFormatPrintString+0x88>
     994:	00012c23          	sw	zero,24(sp)
     998:	01812703          	lw	a4,24(sp)
     99c:	00070793          	mv	a5,a4
     9a0:	00279793          	slli	a5,a5,0x2
     9a4:	00e787b3          	add	a5,a5,a4
     9a8:	00179793          	slli	a5,a5,0x1
     9ac:	00f407b3          	add	a5,s0,a5
     9b0:	fd078793          	addi	a5,a5,-48
     9b4:	00f12c23          	sw	a5,24(sp)
     9b8:	00412783          	lw	a5,4(sp)
     9bc:	0007c783          	lbu	a5,0(a5)
     9c0:	00078413          	mv	s0,a5
     9c4:	02f00793          	li	a5,47
     9c8:	0487d263          	ble	s0,a5,a0c <vFormatPrintString+0x15c>
     9cc:	03900793          	li	a5,57
     9d0:	0287ce63          	blt	a5,s0,a0c <vFormatPrintString+0x15c>
     9d4:	00412783          	lw	a5,4(sp)
     9d8:	00178793          	addi	a5,a5,1
     9dc:	00f12223          	sw	a5,4(sp)
     9e0:	fb9ff06f          	j	998 <vFormatPrintString+0xe8>
     9e4:	00012783          	lw	a5,0(sp)
     9e8:	00478713          	addi	a4,a5,4
     9ec:	00e12023          	sw	a4,0(sp)
     9f0:	0007a783          	lw	a5,0(a5)
     9f4:	00f12c23          	sw	a5,24(sp)
     9f8:	0180006f          	j	a10 <vFormatPrintString+0x160>
     9fc:	01c12783          	lw	a5,28(sp)
     a00:	f207dce3          	bgez	a5,938 <vFormatPrintString+0x88>
     a04:	00012e23          	sw	zero,28(sp)
     a08:	f31ff06f          	j	938 <vFormatPrintString+0x88>
     a0c:	00000013          	nop
     a10:	01c12783          	lw	a5,28(sp)
     a14:	f207d2e3          	bgez	a5,938 <vFormatPrintString+0x88>
     a18:	01812783          	lw	a5,24(sp)
     a1c:	00f12e23          	sw	a5,28(sp)
     a20:	fff00793          	li	a5,-1
     a24:	00f12c23          	sw	a5,24(sp)
     a28:	f11ff06f          	j	938 <vFormatPrintString+0x88>
     a2c:	02012783          	lw	a5,32(sp)
     a30:	00178793          	addi	a5,a5,1
     a34:	02f12023          	sw	a5,32(sp)
     a38:	f01ff06f          	j	938 <vFormatPrintString+0x88>
     a3c:	00012783          	lw	a5,0(sp)
     a40:	00478713          	addi	a4,a5,4
     a44:	00e12023          	sw	a4,0(sp)
     a48:	0007a783          	lw	a5,0(a5)
     a4c:	00c12703          	lw	a4,12(sp)
     a50:	00812583          	lw	a1,8(sp)
     a54:	00078513          	mv	a0,a5
     a58:	000700e7          	jalr	a4
     a5c:	2340006f          	j	c90 <vFormatPrintString+0x3e0>
     a60:	00012783          	lw	a5,0(sp)
     a64:	00478713          	addi	a4,a5,4
     a68:	00e12023          	sw	a4,0(sp)
     a6c:	0007a483          	lw	s1,0(a5)
     a70:	00049663          	bnez	s1,a7c <vFormatPrintString+0x1cc>
     a74:	0001f497          	auipc	s1,0x1f
     a78:	5a848493          	addi	s1,s1,1448 # 2001c <__rodata_start+0x1c>
     a7c:	01c12783          	lw	a5,28(sp)
     a80:	08f05063          	blez	a5,b00 <vFormatPrintString+0x250>
     a84:	01714703          	lbu	a4,23(sp)
     a88:	02d00793          	li	a5,45
     a8c:	06f70a63          	beq	a4,a5,b00 <vFormatPrintString+0x250>
     a90:	01812783          	lw	a5,24(sp)
     a94:	00078593          	mv	a1,a5
     a98:	00048513          	mv	a0,s1
     a9c:	594000ef          	jal	ra,1030 <strnlen>
     aa0:	00050713          	mv	a4,a0
     aa4:	01c12783          	lw	a5,28(sp)
     aa8:	40e787b3          	sub	a5,a5,a4
     aac:	00f12e23          	sw	a5,28(sp)
     ab0:	0240006f          	j	ad4 <vFormatPrintString+0x224>
     ab4:	01714783          	lbu	a5,23(sp)
     ab8:	00c12703          	lw	a4,12(sp)
     abc:	00812583          	lw	a1,8(sp)
     ac0:	00078513          	mv	a0,a5
     ac4:	000700e7          	jalr	a4
     ac8:	01c12783          	lw	a5,28(sp)
     acc:	fff78793          	addi	a5,a5,-1
     ad0:	00f12e23          	sw	a5,28(sp)
     ad4:	01c12783          	lw	a5,28(sp)
     ad8:	fcf04ee3          	bgtz	a5,ab4 <vFormatPrintString+0x204>
     adc:	0240006f          	j	b00 <vFormatPrintString+0x250>
     ae0:	00c12783          	lw	a5,12(sp)
     ae4:	00812583          	lw	a1,8(sp)
     ae8:	00040513          	mv	a0,s0
     aec:	000780e7          	jalr	a5
     af0:	00148493          	addi	s1,s1,1
     af4:	01c12783          	lw	a5,28(sp)
     af8:	fff78793          	addi	a5,a5,-1
     afc:	00f12e23          	sw	a5,28(sp)
     b00:	0004c783          	lbu	a5,0(s1)
     b04:	00078413          	mv	s0,a5
     b08:	04040063          	beqz	s0,b48 <vFormatPrintString+0x298>
     b0c:	01812783          	lw	a5,24(sp)
     b10:	fc07c8e3          	bltz	a5,ae0 <vFormatPrintString+0x230>
     b14:	01812783          	lw	a5,24(sp)
     b18:	fff78793          	addi	a5,a5,-1
     b1c:	00f12c23          	sw	a5,24(sp)
     b20:	01812783          	lw	a5,24(sp)
     b24:	fa07dee3          	bgez	a5,ae0 <vFormatPrintString+0x230>
     b28:	0200006f          	j	b48 <vFormatPrintString+0x298>
     b2c:	00c12783          	lw	a5,12(sp)
     b30:	00812583          	lw	a1,8(sp)
     b34:	02000513          	li	a0,32
     b38:	000780e7          	jalr	a5
     b3c:	01c12783          	lw	a5,28(sp)
     b40:	fff78793          	addi	a5,a5,-1
     b44:	00f12e23          	sw	a5,28(sp)
     b48:	01c12783          	lw	a5,28(sp)
     b4c:	fef040e3          	bgtz	a5,b2c <vFormatPrintString+0x27c>
     b50:	1400006f          	j	c90 <vFormatPrintString+0x3e0>
     b54:	00010793          	mv	a5,sp
     b58:	02012583          	lw	a1,32(sp)
     b5c:	00078513          	mv	a0,a5
     b60:	cadff0ef          	jal	ra,80c <getint>
     b64:	00050793          	mv	a5,a0
     b68:	00058813          	mv	a6,a1
     b6c:	02f12423          	sw	a5,40(sp)
     b70:	03012623          	sw	a6,44(sp)
     b74:	02812783          	lw	a5,40(sp)
     b78:	02c12803          	lw	a6,44(sp)
     b7c:	00080793          	mv	a5,a6
     b80:	0407d663          	bgez	a5,bcc <vFormatPrintString+0x31c>
     b84:	00c12783          	lw	a5,12(sp)
     b88:	00812583          	lw	a1,8(sp)
     b8c:	02d00513          	li	a0,45
     b90:	000780e7          	jalr	a5
     b94:	02812583          	lw	a1,40(sp)
     b98:	02c12603          	lw	a2,44(sp)
     b9c:	00000793          	li	a5,0
     ba0:	00000813          	li	a6,0
     ba4:	40b786b3          	sub	a3,a5,a1
     ba8:	00068513          	mv	a0,a3
     bac:	00a7b533          	sltu	a0,a5,a0
     bb0:	40c80733          	sub	a4,a6,a2
     bb4:	40a707b3          	sub	a5,a4,a0
     bb8:	00078713          	mv	a4,a5
     bbc:	00068793          	mv	a5,a3
     bc0:	00070813          	mv	a6,a4
     bc4:	02f12423          	sw	a5,40(sp)
     bc8:	03012623          	sw	a6,44(sp)
     bcc:	00a00793          	li	a5,10
     bd0:	02f12223          	sw	a5,36(sp)
     bd4:	0640006f          	j	c38 <vFormatPrintString+0x388>
     bd8:	00a00793          	li	a5,10
     bdc:	02f12223          	sw	a5,36(sp)
     be0:	0400006f          	j	c20 <vFormatPrintString+0x370>
     be4:	00800793          	li	a5,8
     be8:	02f12223          	sw	a5,36(sp)
     bec:	0340006f          	j	c20 <vFormatPrintString+0x370>
     bf0:	00100793          	li	a5,1
     bf4:	02f12023          	sw	a5,32(sp)
     bf8:	00c12783          	lw	a5,12(sp)
     bfc:	00812583          	lw	a1,8(sp)
     c00:	03000513          	li	a0,48
     c04:	000780e7          	jalr	a5
     c08:	00c12783          	lw	a5,12(sp)
     c0c:	00812583          	lw	a1,8(sp)
     c10:	07800513          	li	a0,120
     c14:	000780e7          	jalr	a5
     c18:	01000793          	li	a5,16
     c1c:	02f12223          	sw	a5,36(sp)
     c20:	00010793          	mv	a5,sp
     c24:	02012583          	lw	a1,32(sp)
     c28:	00078513          	mv	a0,a5
     c2c:	b45ff0ef          	jal	ra,770 <getuint>
     c30:	02a12423          	sw	a0,40(sp)
     c34:	02b12623          	sw	a1,44(sp)
     c38:	02412703          	lw	a4,36(sp)
     c3c:	01714783          	lbu	a5,23(sp)
     c40:	00078813          	mv	a6,a5
     c44:	01c12783          	lw	a5,28(sp)
     c48:	02812603          	lw	a2,40(sp)
     c4c:	02c12683          	lw	a3,44(sp)
     c50:	00812583          	lw	a1,8(sp)
     c54:	00c12503          	lw	a0,12(sp)
     c58:	965ff0ef          	jal	ra,5bc <printnum>
     c5c:	0340006f          	j	c90 <vFormatPrintString+0x3e0>
     c60:	00c12783          	lw	a5,12(sp)
     c64:	00812583          	lw	a1,8(sp)
     c68:	00040513          	mv	a0,s0
     c6c:	000780e7          	jalr	a5
     c70:	0200006f          	j	c90 <vFormatPrintString+0x3e0>
     c74:	00c12783          	lw	a5,12(sp)
     c78:	00812583          	lw	a1,8(sp)
     c7c:	02500513          	li	a0,37
     c80:	000780e7          	jalr	a5
     c84:	01012783          	lw	a5,16(sp)
     c88:	00f12223          	sw	a5,4(sp)
     c8c:	00000013          	nop
     c90:	c65ff06f          	j	8f4 <vFormatPrintString+0x44>
     c94:	00000013          	nop
     c98:	03c12083          	lw	ra,60(sp)
     c9c:	03812403          	lw	s0,56(sp)
     ca0:	03412483          	lw	s1,52(sp)
     ca4:	04010113          	addi	sp,sp,64
     ca8:	00008067          	ret

00000cac <exit>:
     cac:	fe010113          	addi	sp,sp,-32
     cb0:	00112e23          	sw	ra,28(sp)
     cb4:	00a12623          	sw	a0,12(sp)
     cb8:	00000693          	li	a3,0
     cbc:	00000613          	li	a2,0
     cc0:	00c12583          	lw	a1,12(sp)
     cc4:	05d00513          	li	a0,93
     cc8:	eecff0ef          	jal	ra,3b4 <syscall>
     ccc:	0000006f          	j	ccc <exit+0x20>

00000cd0 <printf>:
     cd0:	fb010113          	addi	sp,sp,-80
     cd4:	02112623          	sw	ra,44(sp)
     cd8:	00a12623          	sw	a0,12(sp)
     cdc:	02b12a23          	sw	a1,52(sp)
     ce0:	02c12c23          	sw	a2,56(sp)
     ce4:	02d12e23          	sw	a3,60(sp)
     ce8:	04e12023          	sw	a4,64(sp)
     cec:	04f12223          	sw	a5,68(sp)
     cf0:	05012423          	sw	a6,72(sp)
     cf4:	05112623          	sw	a7,76(sp)
     cf8:	05010793          	addi	a5,sp,80
     cfc:	fe478793          	addi	a5,a5,-28
     d00:	00f12e23          	sw	a5,28(sp)
     d04:	01c12783          	lw	a5,28(sp)
     d08:	00078693          	mv	a3,a5
     d0c:	00c12603          	lw	a2,12(sp)
     d10:	00000593          	li	a1,0
     d14:	00000517          	auipc	a0,0x0
     d18:	80050513          	addi	a0,a0,-2048 # 514 <putchar>
     d1c:	b95ff0ef          	jal	ra,8b0 <vFormatPrintString>
     d20:	00000793          	li	a5,0
     d24:	00078513          	mv	a0,a5
     d28:	02c12083          	lw	ra,44(sp)
     d2c:	05010113          	addi	sp,sp,80
     d30:	00008067          	ret

00000d34 <sprintf_putch.2235>:
     d34:	fe010113          	addi	sp,sp,-32
     d38:	00a12623          	sw	a0,12(sp)
     d3c:	00b12423          	sw	a1,8(sp)
     d40:	00712223          	sw	t2,4(sp)
     d44:	00812783          	lw	a5,8(sp)
     d48:	00f12e23          	sw	a5,28(sp)
     d4c:	01c12783          	lw	a5,28(sp)
     d50:	0007a783          	lw	a5,0(a5)
     d54:	00c12703          	lw	a4,12(sp)
     d58:	0ff77713          	andi	a4,a4,255
     d5c:	00e78023          	sb	a4,0(a5)
     d60:	01c12783          	lw	a5,28(sp)
     d64:	0007a783          	lw	a5,0(a5)
     d68:	00178713          	addi	a4,a5,1
     d6c:	01c12783          	lw	a5,28(sp)
     d70:	00e7a023          	sw	a4,0(a5)
     d74:	00000013          	nop
     d78:	02010113          	addi	sp,sp,32
     d7c:	00008067          	ret

00000d80 <sprintf>:
     d80:	fa010113          	addi	sp,sp,-96
     d84:	02112e23          	sw	ra,60(sp)
     d88:	00a12623          	sw	a0,12(sp)
     d8c:	00b12423          	sw	a1,8(sp)
     d90:	04c12423          	sw	a2,72(sp)
     d94:	04d12623          	sw	a3,76(sp)
     d98:	04e12823          	sw	a4,80(sp)
     d9c:	04f12a23          	sw	a5,84(sp)
     da0:	05012c23          	sw	a6,88(sp)
     da4:	05112e23          	sw	a7,92(sp)
     da8:	06010793          	addi	a5,sp,96
     dac:	02f12223          	sw	a5,36(sp)
     db0:	01410793          	addi	a5,sp,20
     db4:	01410593          	addi	a1,sp,20
     db8:	00000617          	auipc	a2,0x0
     dbc:	f7c60613          	addi	a2,a2,-132 # d34 <sprintf_putch.2235>
     dc0:	fffff737          	lui	a4,0xfffff
     dc4:	fff74693          	not	a3,a4
     dc8:	00001537          	lui	a0,0x1
     dcc:	80050513          	addi	a0,a0,-2048 # 800 <getuint+0x90>
     dd0:	00a58833          	add	a6,a1,a0
     dd4:	00e87833          	and	a6,a6,a4
     dd8:	3b786813          	ori	a6,a6,951
     ddc:	0107a023          	sw	a6,0(a5)
     de0:	00a60533          	add	a0,a2,a0
     de4:	00e57733          	and	a4,a0,a4
     de8:	33776713          	ori	a4,a4,823
     dec:	00e7a223          	sw	a4,4(a5)
     df0:	00d5f733          	and	a4,a1,a3
     df4:	01471593          	slli	a1,a4,0x14
     df8:	00038737          	lui	a4,0x38
     dfc:	39370713          	addi	a4,a4,915 # 38393 <__stack+0x15f0b>
     e00:	00e5e733          	or	a4,a1,a4
     e04:	00e7a423          	sw	a4,8(a5)
     e08:	00d67733          	and	a4,a2,a3
     e0c:	01471693          	slli	a3,a4,0x14
     e10:	00030737          	lui	a4,0x30
     e14:	06770713          	addi	a4,a4,103 # 30067 <__stack+0xdbdf>
     e18:	00e6e733          	or	a4,a3,a4
     e1c:	00e7a623          	sw	a4,12(a5)
     e20:	0000100f          	fence.i
     e24:	00c12783          	lw	a5,12(sp)
     e28:	02f12623          	sw	a5,44(sp)
     e2c:	06010793          	addi	a5,sp,96
     e30:	fe878793          	addi	a5,a5,-24
     e34:	02f12423          	sw	a5,40(sp)
     e38:	02812703          	lw	a4,40(sp)
     e3c:	01410793          	addi	a5,sp,20
     e40:	00078513          	mv	a0,a5
     e44:	00c10793          	addi	a5,sp,12
     e48:	00070693          	mv	a3,a4
     e4c:	00812603          	lw	a2,8(sp)
     e50:	00078593          	mv	a1,a5
     e54:	a5dff0ef          	jal	ra,8b0 <vFormatPrintString>
     e58:	00c12783          	lw	a5,12(sp)
     e5c:	00078023          	sb	zero,0(a5)
     e60:	00c12783          	lw	a5,12(sp)
     e64:	00078713          	mv	a4,a5
     e68:	02c12783          	lw	a5,44(sp)
     e6c:	40f707b3          	sub	a5,a4,a5
     e70:	00078513          	mv	a0,a5
     e74:	03c12083          	lw	ra,60(sp)
     e78:	06010113          	addi	sp,sp,96
     e7c:	00008067          	ret

00000e80 <level_1_interrupt_handler>:
     e80:	fe010113          	addi	sp,sp,-32
     e84:	00112e23          	sw	ra,28(sp)
     e88:	00a12623          	sw	a0,12(sp)
     e8c:	00c12783          	lw	a5,12(sp)
     e90:	00f7f713          	andi	a4,a5,15
     e94:	00700793          	li	a5,7
     e98:	04f71463          	bne	a4,a5,ee0 <level_1_interrupt_handler+0x60>
     e9c:	0001f797          	auipc	a5,0x1f
     ea0:	56478793          	addi	a5,a5,1380 # 20400 <timer_irq_handler>
     ea4:	0007a783          	lw	a5,0(a5)
     ea8:	00078c63          	beqz	a5,ec0 <level_1_interrupt_handler+0x40>
     eac:	0001f797          	auipc	a5,0x1f
     eb0:	55478793          	addi	a5,a5,1364 # 20400 <timer_irq_handler>
     eb4:	0007a783          	lw	a5,0(a5)
     eb8:	000780e7          	jalr	a5
     ebc:	0240006f          	j	ee0 <level_1_interrupt_handler+0x60>
     ec0:	0001f797          	auipc	a5,0x1f
     ec4:	49478793          	addi	a5,a5,1172 # 20354 <mtimecmp>
     ec8:	0007a783          	lw	a5,0(a5)
     ecc:	00000693          	li	a3,0
     ed0:	00000713          	li	a4,0
     ed4:	00d7a023          	sw	a3,0(a5)
     ed8:	00e7a223          	sw	a4,4(a5)
     edc:	00000013          	nop
     ee0:	01c12083          	lw	ra,28(sp)
     ee4:	02010113          	addi	sp,sp,32
     ee8:	00008067          	ret

00000eec <register_timer_interrupt_handler>:
     eec:	ff010113          	addi	sp,sp,-16
     ef0:	00a12623          	sw	a0,12(sp)
     ef4:	0001f797          	auipc	a5,0x1f
     ef8:	50c78793          	addi	a5,a5,1292 # 20400 <timer_irq_handler>
     efc:	00c12703          	lw	a4,12(sp)
     f00:	00e7a023          	sw	a4,0(a5)
     f04:	00000013          	nop
     f08:	01010113          	addi	sp,sp,16
     f0c:	00008067          	ret

00000f10 <set_next_timer_interrupt>:
     f10:	0001f797          	auipc	a5,0x1f
     f14:	44078793          	addi	a5,a5,1088 # 20350 <__sbss_end>
     f18:	0007a783          	lw	a5,0(a5)
     f1c:	0047a803          	lw	a6,4(a5)
     f20:	0007a783          	lw	a5,0(a5)
     f24:	0001f717          	auipc	a4,0x1f
     f28:	43070713          	addi	a4,a4,1072 # 20354 <mtimecmp>
     f2c:	00072503          	lw	a0,0(a4)
     f30:	000f45b7          	lui	a1,0xf4
     f34:	24058593          	addi	a1,a1,576 # f4240 <__stack+0xd1db8>
     f38:	00000613          	li	a2,0
     f3c:	00b786b3          	add	a3,a5,a1
     f40:	00068893          	mv	a7,a3
     f44:	00f8b8b3          	sltu	a7,a7,a5
     f48:	00c80733          	add	a4,a6,a2
     f4c:	00e887b3          	add	a5,a7,a4
     f50:	00078713          	mv	a4,a5
     f54:	00068793          	mv	a5,a3
     f58:	00070813          	mv	a6,a4
     f5c:	00f52023          	sw	a5,0(a0)
     f60:	01052223          	sw	a6,4(a0)
     f64:	00000013          	nop
     f68:	00008067          	ret

00000f6c <timer_irq_handler>:
     f6c:	ff010113          	addi	sp,sp,-16
     f70:	00112623          	sw	ra,12(sp)
     f74:	0001f797          	auipc	a5,0x1f
     f78:	3d478793          	addi	a5,a5,980 # 20348 <num_ticks>
     f7c:	0007a783          	lw	a5,0(a5)
     f80:	00178713          	addi	a4,a5,1
     f84:	0001f797          	auipc	a5,0x1f
     f88:	3c478793          	addi	a5,a5,964 # 20348 <num_ticks>
     f8c:	00e7a023          	sw	a4,0(a5)
     f90:	f81ff0ef          	jal	ra,f10 <set_next_timer_interrupt>
     f94:	0001f797          	auipc	a5,0x1f
     f98:	3b478793          	addi	a5,a5,948 # 20348 <num_ticks>
     f9c:	0007a783          	lw	a5,0(a5)
     fa0:	00078593          	mv	a1,a5
     fa4:	0001f517          	auipc	a0,0x1f
     fa8:	1d850513          	addi	a0,a0,472 # 2017c <__rodata_start+0x17c>
     fac:	d25ff0ef          	jal	ra,cd0 <printf>
     fb0:	00000013          	nop
     fb4:	00c12083          	lw	ra,12(sp)
     fb8:	01010113          	addi	sp,sp,16
     fbc:	00008067          	ret

00000fc0 <main>:
     fc0:	ff010113          	addi	sp,sp,-16
     fc4:	00112623          	sw	ra,12(sp)
     fc8:	00000517          	auipc	a0,0x0
     fcc:	fa450513          	addi	a0,a0,-92 # f6c <timer_irq_handler>
     fd0:	f1dff0ef          	jal	ra,eec <register_timer_interrupt_handler>
     fd4:	f3dff0ef          	jal	ra,f10 <set_next_timer_interrupt>
     fd8:	00000013          	nop
     fdc:	0001f797          	auipc	a5,0x1f
     fe0:	36c78793          	addi	a5,a5,876 # 20348 <num_ticks>
     fe4:	0007a703          	lw	a4,0(a5)
     fe8:	00400793          	li	a5,4
     fec:	fee7f8e3          	bleu	a4,a5,fdc <main+0x1c>
     ff0:	0001f797          	auipc	a5,0x1f
     ff4:	35878793          	addi	a5,a5,856 # 20348 <num_ticks>
     ff8:	0007a783          	lw	a5,0(a5)
     ffc:	00078f93          	mv	t6,a5
    1000:	00000793          	li	a5,0
    1004:	00078513          	mv	a0,a5
    1008:	00c12083          	lw	ra,12(sp)
    100c:	01010113          	addi	sp,sp,16
    1010:	00008067          	ret

00001014 <strlen>:
    1014:	00050793          	mv	a5,a0
    1018:	00178793          	addi	a5,a5,1
    101c:	fff7c703          	lbu	a4,-1(a5)
    1020:	fe071ce3          	bnez	a4,1018 <strlen+0x4>
    1024:	40a78533          	sub	a0,a5,a0
    1028:	fff50513          	addi	a0,a0,-1
    102c:	00008067          	ret

00001030 <strnlen>:
    1030:	00b505b3          	add	a1,a0,a1
    1034:	00050793          	mv	a5,a0
    1038:	00b78663          	beq	a5,a1,1044 <strnlen+0x14>
    103c:	0007c703          	lbu	a4,0(a5)
    1040:	00071663          	bnez	a4,104c <strnlen+0x1c>
    1044:	40a78533          	sub	a0,a5,a0
    1048:	00008067          	ret
    104c:	00178793          	addi	a5,a5,1
    1050:	fe9ff06f          	j	1038 <strnlen+0x8>

00001054 <__udivdi3>:
#endif

#ifdef L_udivdi3
UDWtype
__udivdi3 (UDWtype n, UDWtype d)
{
    1054:	fd010113          	addi	sp,sp,-48
    1058:	01612823          	sw	s6,16(sp)
    105c:	01712623          	sw	s7,12(sp)
    1060:	02112623          	sw	ra,44(sp)
    1064:	02812423          	sw	s0,40(sp)
    1068:	02912223          	sw	s1,36(sp)
    106c:	03212023          	sw	s2,32(sp)
    1070:	01312e23          	sw	s3,28(sp)
    1074:	01412c23          	sw	s4,24(sp)
    1078:	01512a23          	sw	s5,20(sp)
    107c:	01812423          	sw	s8,8(sp)
    1080:	01912223          	sw	s9,4(sp)
    1084:	01a12023          	sw	s10,0(sp)
    1088:	00050b13          	mv	s6,a0
    108c:	00058b93          	mv	s7,a1
  if (d1 == 0)
    1090:	38069e63          	bnez	a3,142c <__udivdi3+0x3d8>
    1094:	00020937          	lui	s2,0x20
    1098:	00060493          	mv	s1,a2
    109c:	00050a13          	mv	s4,a0
    10a0:	19090913          	addi	s2,s2,400 # 20190 <__clz_tab>
      if (d0 > n1)
    10a4:	12c5f863          	bleu	a2,a1,11d4 <__udivdi3+0x180>
	  count_leading_zeros (bm, d0);
    10a8:	000107b7          	lui	a5,0x10
    10ac:	00058413          	mv	s0,a1
    10b0:	10f67863          	bleu	a5,a2,11c0 <__udivdi3+0x16c>
    10b4:	0ff00713          	li	a4,255
    10b8:	00c73733          	sltu	a4,a4,a2
    10bc:	00371713          	slli	a4,a4,0x3
    10c0:	00e657b3          	srl	a5,a2,a4
    10c4:	00f90933          	add	s2,s2,a5
    10c8:	00094683          	lbu	a3,0(s2)
    10cc:	00e68733          	add	a4,a3,a4
    10d0:	02000693          	li	a3,32
    10d4:	40e686b3          	sub	a3,a3,a4
	  if (bm != 0)
    10d8:	00068c63          	beqz	a3,10f0 <__udivdi3+0x9c>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    10dc:	00db9433          	sll	s0,s7,a3
    10e0:	00eb5733          	srl	a4,s6,a4
	      d0 = d0 << bm;
    10e4:	00d614b3          	sll	s1,a2,a3
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    10e8:	00876433          	or	s0,a4,s0
	      n0 = n0 << bm;
    10ec:	00db1a33          	sll	s4,s6,a3
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    10f0:	0104da93          	srli	s5,s1,0x10
    10f4:	000a8593          	mv	a1,s5
    10f8:	00040513          	mv	a0,s0
    10fc:	2a9000ef          	jal	ra,1ba4 <__umodsi3>
    1100:	00050993          	mv	s3,a0
    1104:	000a8593          	mv	a1,s5
    1108:	00040513          	mv	a0,s0
    110c:	01049b13          	slli	s6,s1,0x10
    1110:	24d000ef          	jal	ra,1b5c <__udivsi3>
    1114:	010b5b13          	srli	s6,s6,0x10
    1118:	00050913          	mv	s2,a0
    111c:	00050593          	mv	a1,a0
    1120:	000b0513          	mv	a0,s6
    1124:	20d000ef          	jal	ra,1b30 <__mulsi3>
    1128:	01099993          	slli	s3,s3,0x10
    112c:	010a5793          	srli	a5,s4,0x10
    1130:	00f9e7b3          	or	a5,s3,a5
    1134:	00090413          	mv	s0,s2
    1138:	00a7fe63          	bleu	a0,a5,1154 <__udivdi3+0x100>
    113c:	009787b3          	add	a5,a5,s1
    1140:	fff90413          	addi	s0,s2,-1
    1144:	0097e863          	bltu	a5,s1,1154 <__udivdi3+0x100>
    1148:	00a7f663          	bleu	a0,a5,1154 <__udivdi3+0x100>
    114c:	ffe90413          	addi	s0,s2,-2
    1150:	009787b3          	add	a5,a5,s1
    1154:	40a78933          	sub	s2,a5,a0
    1158:	000a8593          	mv	a1,s5
    115c:	00090513          	mv	a0,s2
    1160:	245000ef          	jal	ra,1ba4 <__umodsi3>
    1164:	00050993          	mv	s3,a0
    1168:	000a8593          	mv	a1,s5
    116c:	00090513          	mv	a0,s2
    1170:	1ed000ef          	jal	ra,1b5c <__udivsi3>
    1174:	010a1a13          	slli	s4,s4,0x10
    1178:	00050913          	mv	s2,a0
    117c:	00050593          	mv	a1,a0
    1180:	01099993          	slli	s3,s3,0x10
    1184:	000b0513          	mv	a0,s6
    1188:	010a5a13          	srli	s4,s4,0x10
    118c:	1a5000ef          	jal	ra,1b30 <__mulsi3>
    1190:	0149ea33          	or	s4,s3,s4
    1194:	00090613          	mv	a2,s2
    1198:	00aa7c63          	bleu	a0,s4,11b0 <__udivdi3+0x15c>
    119c:	01448a33          	add	s4,s1,s4
    11a0:	fff90613          	addi	a2,s2,-1
    11a4:	009a6663          	bltu	s4,s1,11b0 <__udivdi3+0x15c>
    11a8:	00aa7463          	bleu	a0,s4,11b0 <__udivdi3+0x15c>
    11ac:	ffe90613          	addi	a2,s2,-2
    11b0:	01041413          	slli	s0,s0,0x10
    11b4:	00c46433          	or	s0,s0,a2
	      q1 = 0;
    11b8:	00000a93          	li	s5,0
    11bc:	1300006f          	j	12ec <__udivdi3+0x298>
	  count_leading_zeros (bm, d0);
    11c0:	010007b7          	lui	a5,0x1000
    11c4:	01000713          	li	a4,16
    11c8:	eef66ce3          	bltu	a2,a5,10c0 <__udivdi3+0x6c>
    11cc:	01800713          	li	a4,24
    11d0:	ef1ff06f          	j	10c0 <__udivdi3+0x6c>
    11d4:	00068993          	mv	s3,a3
	  if (d0 == 0)
    11d8:	00061a63          	bnez	a2,11ec <__udivdi3+0x198>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    11dc:	00000593          	li	a1,0
    11e0:	00100513          	li	a0,1
    11e4:	179000ef          	jal	ra,1b5c <__udivsi3>
    11e8:	00050493          	mv	s1,a0
	  count_leading_zeros (bm, d0);
    11ec:	000107b7          	lui	a5,0x10
    11f0:	12f4fe63          	bleu	a5,s1,132c <__udivdi3+0x2d8>
    11f4:	0ff00793          	li	a5,255
    11f8:	0097f463          	bleu	s1,a5,1200 <__udivdi3+0x1ac>
    11fc:	00800993          	li	s3,8
    1200:	0134d7b3          	srl	a5,s1,s3
    1204:	00f90933          	add	s2,s2,a5
    1208:	00094703          	lbu	a4,0(s2)
    120c:	02000693          	li	a3,32
    1210:	01370733          	add	a4,a4,s3
    1214:	40e686b3          	sub	a3,a3,a4
	  if (bm == 0)
    1218:	12069463          	bnez	a3,1340 <__udivdi3+0x2ec>
	      n1 -= d0;
    121c:	409b8433          	sub	s0,s7,s1
	      q1 = 1;
    1220:	00100a93          	li	s5,1
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    1224:	0104db13          	srli	s6,s1,0x10
    1228:	000b0593          	mv	a1,s6
    122c:	00040513          	mv	a0,s0
    1230:	175000ef          	jal	ra,1ba4 <__umodsi3>
    1234:	00050993          	mv	s3,a0
    1238:	000b0593          	mv	a1,s6
    123c:	00040513          	mv	a0,s0
    1240:	01049b93          	slli	s7,s1,0x10
    1244:	119000ef          	jal	ra,1b5c <__udivsi3>
    1248:	010bdb93          	srli	s7,s7,0x10
    124c:	00050913          	mv	s2,a0
    1250:	00050593          	mv	a1,a0
    1254:	000b8513          	mv	a0,s7
    1258:	0d9000ef          	jal	ra,1b30 <__mulsi3>
    125c:	01099993          	slli	s3,s3,0x10
    1260:	010a5793          	srli	a5,s4,0x10
    1264:	00f9e7b3          	or	a5,s3,a5
    1268:	00090413          	mv	s0,s2
    126c:	00a7fe63          	bleu	a0,a5,1288 <__udivdi3+0x234>
    1270:	009787b3          	add	a5,a5,s1
    1274:	fff90413          	addi	s0,s2,-1
    1278:	0097e863          	bltu	a5,s1,1288 <__udivdi3+0x234>
    127c:	00a7f663          	bleu	a0,a5,1288 <__udivdi3+0x234>
    1280:	ffe90413          	addi	s0,s2,-2
    1284:	009787b3          	add	a5,a5,s1
    1288:	40a78933          	sub	s2,a5,a0
    128c:	000b0593          	mv	a1,s6
    1290:	00090513          	mv	a0,s2
    1294:	111000ef          	jal	ra,1ba4 <__umodsi3>
    1298:	00050993          	mv	s3,a0
    129c:	000b0593          	mv	a1,s6
    12a0:	00090513          	mv	a0,s2
    12a4:	0b9000ef          	jal	ra,1b5c <__udivsi3>
    12a8:	010a1a13          	slli	s4,s4,0x10
    12ac:	00050913          	mv	s2,a0
    12b0:	00050593          	mv	a1,a0
    12b4:	01099993          	slli	s3,s3,0x10
    12b8:	000b8513          	mv	a0,s7
    12bc:	010a5a13          	srli	s4,s4,0x10
    12c0:	071000ef          	jal	ra,1b30 <__mulsi3>
    12c4:	0149ea33          	or	s4,s3,s4
    12c8:	00090613          	mv	a2,s2
    12cc:	00aa7c63          	bleu	a0,s4,12e4 <__udivdi3+0x290>
    12d0:	01448a33          	add	s4,s1,s4
    12d4:	fff90613          	addi	a2,s2,-1
    12d8:	009a6663          	bltu	s4,s1,12e4 <__udivdi3+0x290>
    12dc:	00aa7463          	bleu	a0,s4,12e4 <__udivdi3+0x290>
    12e0:	ffe90613          	addi	a2,s2,-2
    12e4:	01041413          	slli	s0,s0,0x10
    12e8:	00c46433          	or	s0,s0,a2
  return __udivmoddi4 (n, d, (UDWtype *) 0);
}
    12ec:	00040513          	mv	a0,s0
    12f0:	000a8593          	mv	a1,s5
    12f4:	02c12083          	lw	ra,44(sp)
    12f8:	02812403          	lw	s0,40(sp)
    12fc:	02412483          	lw	s1,36(sp)
    1300:	02012903          	lw	s2,32(sp)
    1304:	01c12983          	lw	s3,28(sp)
    1308:	01812a03          	lw	s4,24(sp)
    130c:	01412a83          	lw	s5,20(sp)
    1310:	01012b03          	lw	s6,16(sp)
    1314:	00c12b83          	lw	s7,12(sp)
    1318:	00812c03          	lw	s8,8(sp)
    131c:	00412c83          	lw	s9,4(sp)
    1320:	00012d03          	lw	s10,0(sp)
    1324:	03010113          	addi	sp,sp,48
    1328:	00008067          	ret
	  count_leading_zeros (bm, d0);
    132c:	010007b7          	lui	a5,0x1000
    1330:	01000993          	li	s3,16
    1334:	ecf4e6e3          	bltu	s1,a5,1200 <__udivdi3+0x1ac>
    1338:	01800993          	li	s3,24
    133c:	ec5ff06f          	j	1200 <__udivdi3+0x1ac>
	      d0 = d0 << bm;
    1340:	00d494b3          	sll	s1,s1,a3
	      n2 = n1 >> b;
    1344:	00ebd9b3          	srl	s3,s7,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1348:	0104d413          	srli	s0,s1,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    134c:	00eb5733          	srl	a4,s6,a4
    1350:	00db9bb3          	sll	s7,s7,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1354:	00040593          	mv	a1,s0
    1358:	00098513          	mv	a0,s3
	      n1 = (n1 << bm) | (n0 >> b);
    135c:	01776bb3          	or	s7,a4,s7
	      n0 = n0 << bm;
    1360:	00db1a33          	sll	s4,s6,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1364:	041000ef          	jal	ra,1ba4 <__umodsi3>
    1368:	00050913          	mv	s2,a0
    136c:	00040593          	mv	a1,s0
    1370:	00098513          	mv	a0,s3
    1374:	01049b13          	slli	s6,s1,0x10
    1378:	7e4000ef          	jal	ra,1b5c <__udivsi3>
    137c:	010b5b13          	srli	s6,s6,0x10
    1380:	00050993          	mv	s3,a0
    1384:	00050593          	mv	a1,a0
    1388:	000b0513          	mv	a0,s6
    138c:	7a4000ef          	jal	ra,1b30 <__mulsi3>
    1390:	01091913          	slli	s2,s2,0x10
    1394:	010bd713          	srli	a4,s7,0x10
    1398:	00e96733          	or	a4,s2,a4
    139c:	00098a93          	mv	s5,s3
    13a0:	00a77e63          	bleu	a0,a4,13bc <__udivdi3+0x368>
    13a4:	00970733          	add	a4,a4,s1
    13a8:	fff98a93          	addi	s5,s3,-1
    13ac:	00976863          	bltu	a4,s1,13bc <__udivdi3+0x368>
    13b0:	00a77663          	bleu	a0,a4,13bc <__udivdi3+0x368>
    13b4:	ffe98a93          	addi	s5,s3,-2
    13b8:	00970733          	add	a4,a4,s1
    13bc:	40a709b3          	sub	s3,a4,a0
    13c0:	00040593          	mv	a1,s0
    13c4:	00098513          	mv	a0,s3
    13c8:	7dc000ef          	jal	ra,1ba4 <__umodsi3>
    13cc:	00040593          	mv	a1,s0
    13d0:	00050913          	mv	s2,a0
    13d4:	00098513          	mv	a0,s3
    13d8:	784000ef          	jal	ra,1b5c <__udivsi3>
    13dc:	00050413          	mv	s0,a0
    13e0:	00050593          	mv	a1,a0
    13e4:	000b0513          	mv	a0,s6
    13e8:	748000ef          	jal	ra,1b30 <__mulsi3>
    13ec:	010b9713          	slli	a4,s7,0x10
    13f0:	01075713          	srli	a4,a4,0x10
    13f4:	01091913          	slli	s2,s2,0x10
    13f8:	00e967b3          	or	a5,s2,a4
    13fc:	00040713          	mv	a4,s0
    1400:	00a7fe63          	bleu	a0,a5,141c <__udivdi3+0x3c8>
    1404:	009787b3          	add	a5,a5,s1
    1408:	fff40713          	addi	a4,s0,-1
    140c:	0097e863          	bltu	a5,s1,141c <__udivdi3+0x3c8>
    1410:	00a7f663          	bleu	a0,a5,141c <__udivdi3+0x3c8>
    1414:	ffe40713          	addi	a4,s0,-2
    1418:	009787b3          	add	a5,a5,s1
    141c:	010a9a93          	slli	s5,s5,0x10
    1420:	40a78433          	sub	s0,a5,a0
    1424:	00eaeab3          	or	s5,s5,a4
    1428:	dfdff06f          	j	1224 <__udivdi3+0x1d0>
      if (d1 > n1)
    142c:	1ed5ec63          	bltu	a1,a3,1624 <__udivdi3+0x5d0>
	  count_leading_zeros (bm, d1);
    1430:	000107b7          	lui	a5,0x10
    1434:	04f6f463          	bleu	a5,a3,147c <__udivdi3+0x428>
    1438:	0ff00713          	li	a4,255
    143c:	00d735b3          	sltu	a1,a4,a3
    1440:	00359593          	slli	a1,a1,0x3
    1444:	00020737          	lui	a4,0x20
    1448:	19070713          	addi	a4,a4,400 # 20190 <__clz_tab>
    144c:	00b6d7b3          	srl	a5,a3,a1
    1450:	00e787b3          	add	a5,a5,a4
    1454:	0007c703          	lbu	a4,0(a5) # 10000 <__modsi3+0xe428>
    1458:	02000a93          	li	s5,32
    145c:	00b70733          	add	a4,a4,a1
    1460:	40ea8ab3          	sub	s5,s5,a4
	  if (bm == 0)
    1464:	020a9663          	bnez	s5,1490 <__udivdi3+0x43c>
		  q0 = 1;
    1468:	00100413          	li	s0,1
	      if (n1 > d1 || n0 >= d0)
    146c:	e976e0e3          	bltu	a3,s7,12ec <__udivdi3+0x298>
    1470:	00cb3633          	sltu	a2,s6,a2
    1474:	00164413          	xori	s0,a2,1
    1478:	e75ff06f          	j	12ec <__udivdi3+0x298>
	  count_leading_zeros (bm, d1);
    147c:	010007b7          	lui	a5,0x1000
    1480:	01000593          	li	a1,16
    1484:	fcf6e0e3          	bltu	a3,a5,1444 <__udivdi3+0x3f0>
    1488:	01800593          	li	a1,24
    148c:	fb9ff06f          	j	1444 <__udivdi3+0x3f0>
	      d1 = (d1 << bm) | (d0 >> b);
    1490:	00e65cb3          	srl	s9,a2,a4
    1494:	015696b3          	sll	a3,a3,s5
    1498:	00dcecb3          	or	s9,s9,a3
	      n2 = n1 >> b;
    149c:	00ebd4b3          	srl	s1,s7,a4
	      n1 = (n1 << bm) | (n0 >> b);
    14a0:	015b97b3          	sll	a5,s7,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    14a4:	010cdb93          	srli	s7,s9,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    14a8:	00eb5733          	srl	a4,s6,a4
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    14ac:	000b8593          	mv	a1,s7
    14b0:	00048513          	mv	a0,s1
	      n1 = (n1 << bm) | (n0 >> b);
    14b4:	00f76433          	or	s0,a4,a5
	      d0 = d0 << bm;
    14b8:	015619b3          	sll	s3,a2,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    14bc:	6e8000ef          	jal	ra,1ba4 <__umodsi3>
    14c0:	00050913          	mv	s2,a0
    14c4:	000b8593          	mv	a1,s7
    14c8:	00048513          	mv	a0,s1
    14cc:	010c9c13          	slli	s8,s9,0x10
    14d0:	68c000ef          	jal	ra,1b5c <__udivsi3>
    14d4:	010c5c13          	srli	s8,s8,0x10
    14d8:	00050493          	mv	s1,a0
    14dc:	00050593          	mv	a1,a0
    14e0:	000c0513          	mv	a0,s8
    14e4:	64c000ef          	jal	ra,1b30 <__mulsi3>
    14e8:	01091913          	slli	s2,s2,0x10
    14ec:	01045713          	srli	a4,s0,0x10
    14f0:	00e96733          	or	a4,s2,a4
    14f4:	00048a13          	mv	s4,s1
    14f8:	00a77e63          	bleu	a0,a4,1514 <__udivdi3+0x4c0>
    14fc:	01970733          	add	a4,a4,s9
    1500:	fff48a13          	addi	s4,s1,-1
    1504:	01976863          	bltu	a4,s9,1514 <__udivdi3+0x4c0>
    1508:	00a77663          	bleu	a0,a4,1514 <__udivdi3+0x4c0>
    150c:	ffe48a13          	addi	s4,s1,-2
    1510:	01970733          	add	a4,a4,s9
    1514:	40a704b3          	sub	s1,a4,a0
    1518:	000b8593          	mv	a1,s7
    151c:	00048513          	mv	a0,s1
    1520:	684000ef          	jal	ra,1ba4 <__umodsi3>
    1524:	00050913          	mv	s2,a0
    1528:	000b8593          	mv	a1,s7
    152c:	00048513          	mv	a0,s1
    1530:	62c000ef          	jal	ra,1b5c <__udivsi3>
    1534:	00050493          	mv	s1,a0
    1538:	00050593          	mv	a1,a0
    153c:	000c0513          	mv	a0,s8
    1540:	5f0000ef          	jal	ra,1b30 <__mulsi3>
    1544:	01041793          	slli	a5,s0,0x10
    1548:	01091913          	slli	s2,s2,0x10
    154c:	0107d793          	srli	a5,a5,0x10
    1550:	00f967b3          	or	a5,s2,a5
    1554:	00048613          	mv	a2,s1
    1558:	00a7fe63          	bleu	a0,a5,1574 <__udivdi3+0x520>
    155c:	019787b3          	add	a5,a5,s9
    1560:	fff48613          	addi	a2,s1,-1
    1564:	0197e863          	bltu	a5,s9,1574 <__udivdi3+0x520>
    1568:	00a7f663          	bleu	a0,a5,1574 <__udivdi3+0x520>
    156c:	ffe48613          	addi	a2,s1,-2
    1570:	019787b3          	add	a5,a5,s9
    1574:	010a1413          	slli	s0,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    1578:	00010bb7          	lui	s7,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    157c:	00c46433          	or	s0,s0,a2
	      umul_ppmm (m1, m0, q0, d0);
    1580:	fffb8913          	addi	s2,s7,-1 # ffff <__modsi3+0xe427>
    1584:	01247d33          	and	s10,s0,s2
    1588:	0129f933          	and	s2,s3,s2
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    158c:	40a784b3          	sub	s1,a5,a0
	      umul_ppmm (m1, m0, q0, d0);
    1590:	00090593          	mv	a1,s2
    1594:	000d0513          	mv	a0,s10
    1598:	598000ef          	jal	ra,1b30 <__mulsi3>
    159c:	01045c93          	srli	s9,s0,0x10
    15a0:	00090593          	mv	a1,s2
    15a4:	00050a13          	mv	s4,a0
    15a8:	000c8513          	mv	a0,s9
    15ac:	584000ef          	jal	ra,1b30 <__mulsi3>
    15b0:	0109d993          	srli	s3,s3,0x10
    15b4:	00050c13          	mv	s8,a0
    15b8:	00098593          	mv	a1,s3
    15bc:	000c8513          	mv	a0,s9
    15c0:	570000ef          	jal	ra,1b30 <__mulsi3>
    15c4:	00050913          	mv	s2,a0
    15c8:	00098593          	mv	a1,s3
    15cc:	000d0513          	mv	a0,s10
    15d0:	560000ef          	jal	ra,1b30 <__mulsi3>
    15d4:	01850533          	add	a0,a0,s8
    15d8:	010a5793          	srli	a5,s4,0x10
    15dc:	00a78533          	add	a0,a5,a0
    15e0:	01857463          	bleu	s8,a0,15e8 <__udivdi3+0x594>
    15e4:	01790933          	add	s2,s2,s7
    15e8:	01055793          	srli	a5,a0,0x10
    15ec:	012787b3          	add	a5,a5,s2
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    15f0:	02f4e663          	bltu	s1,a5,161c <__udivdi3+0x5c8>
    15f4:	bcf492e3          	bne	s1,a5,11b8 <__udivdi3+0x164>
	      umul_ppmm (m1, m0, q0, d0);
    15f8:	000107b7          	lui	a5,0x10
    15fc:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe427>
    1600:	00f57533          	and	a0,a0,a5
    1604:	01051513          	slli	a0,a0,0x10
    1608:	00fa7a33          	and	s4,s4,a5
	      n0 = n0 << bm;
    160c:	015b1633          	sll	a2,s6,s5
	      umul_ppmm (m1, m0, q0, d0);
    1610:	01450533          	add	a0,a0,s4
	      q1 = 0;
    1614:	00000a93          	li	s5,0
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1618:	cca67ae3          	bleu	a0,a2,12ec <__udivdi3+0x298>
		  q0--;
    161c:	fff40413          	addi	s0,s0,-1
    1620:	b99ff06f          	j	11b8 <__udivdi3+0x164>
	  q1 = 0;
    1624:	00000a93          	li	s5,0
	  q0 = 0;
    1628:	00000413          	li	s0,0
    162c:	cc1ff06f          	j	12ec <__udivdi3+0x298>

00001630 <__umoddi3>:
{
    1630:	fb010113          	addi	sp,sp,-80
    1634:	04812423          	sw	s0,72(sp)
    1638:	04912223          	sw	s1,68(sp)
    163c:	03312e23          	sw	s3,60(sp)
    1640:	03912223          	sw	s9,36(sp)
    1644:	04112623          	sw	ra,76(sp)
    1648:	05212023          	sw	s2,64(sp)
    164c:	03412c23          	sw	s4,56(sp)
    1650:	03512a23          	sw	s5,52(sp)
    1654:	03612823          	sw	s6,48(sp)
    1658:	03712623          	sw	s7,44(sp)
    165c:	03812423          	sw	s8,40(sp)
    1660:	03a12023          	sw	s10,32(sp)
    1664:	01b12e23          	sw	s11,28(sp)
    1668:	00050c93          	mv	s9,a0
    166c:	00058993          	mv	s3,a1
  n0 = nn.s.low;
    1670:	00050413          	mv	s0,a0
  n1 = nn.s.high;
    1674:	00058493          	mv	s1,a1
  if (d1 == 0)
    1678:	26069e63          	bnez	a3,18f4 <__umoddi3+0x2c4>
    167c:	00020ab7          	lui	s5,0x20
    1680:	00060913          	mv	s2,a2
    1684:	00068a13          	mv	s4,a3
    1688:	190a8a93          	addi	s5,s5,400 # 20190 <__clz_tab>
      if (d0 > n1)
    168c:	14c5f463          	bleu	a2,a1,17d4 <__umoddi3+0x1a4>
	  count_leading_zeros (bm, d0);
    1690:	000107b7          	lui	a5,0x10
    1694:	12f67663          	bleu	a5,a2,17c0 <__umoddi3+0x190>
    1698:	0ff00793          	li	a5,255
    169c:	00c7f463          	bleu	a2,a5,16a4 <__umoddi3+0x74>
    16a0:	00800a13          	li	s4,8
    16a4:	014657b3          	srl	a5,a2,s4
    16a8:	00fa8ab3          	add	s5,s5,a5
    16ac:	000ac703          	lbu	a4,0(s5)
    16b0:	02000513          	li	a0,32
    16b4:	01470733          	add	a4,a4,s4
    16b8:	40e50a33          	sub	s4,a0,a4
	  if (bm != 0)
    16bc:	000a0c63          	beqz	s4,16d4 <__umoddi3+0xa4>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    16c0:	014995b3          	sll	a1,s3,s4
    16c4:	00ecd733          	srl	a4,s9,a4
	      d0 = d0 << bm;
    16c8:	01461933          	sll	s2,a2,s4
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    16cc:	00b764b3          	or	s1,a4,a1
	      n0 = n0 << bm;
    16d0:	014c9433          	sll	s0,s9,s4
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    16d4:	01095a93          	srli	s5,s2,0x10
    16d8:	000a8593          	mv	a1,s5
    16dc:	00048513          	mv	a0,s1
    16e0:	4c4000ef          	jal	ra,1ba4 <__umodsi3>
    16e4:	00050993          	mv	s3,a0
    16e8:	000a8593          	mv	a1,s5
    16ec:	01091b13          	slli	s6,s2,0x10
    16f0:	00048513          	mv	a0,s1
    16f4:	468000ef          	jal	ra,1b5c <__udivsi3>
    16f8:	010b5b13          	srli	s6,s6,0x10
    16fc:	00050593          	mv	a1,a0
    1700:	000b0513          	mv	a0,s6
    1704:	42c000ef          	jal	ra,1b30 <__mulsi3>
    1708:	01099993          	slli	s3,s3,0x10
    170c:	01045793          	srli	a5,s0,0x10
    1710:	00f9e7b3          	or	a5,s3,a5
    1714:	00a7fa63          	bleu	a0,a5,1728 <__umoddi3+0xf8>
    1718:	012787b3          	add	a5,a5,s2
    171c:	0127e663          	bltu	a5,s2,1728 <__umoddi3+0xf8>
    1720:	00a7f463          	bleu	a0,a5,1728 <__umoddi3+0xf8>
    1724:	012787b3          	add	a5,a5,s2
    1728:	40a784b3          	sub	s1,a5,a0
    172c:	000a8593          	mv	a1,s5
    1730:	00048513          	mv	a0,s1
    1734:	470000ef          	jal	ra,1ba4 <__umodsi3>
    1738:	00050993          	mv	s3,a0
    173c:	000a8593          	mv	a1,s5
    1740:	00048513          	mv	a0,s1
    1744:	418000ef          	jal	ra,1b5c <__udivsi3>
    1748:	01041413          	slli	s0,s0,0x10
    174c:	00050593          	mv	a1,a0
    1750:	01099993          	slli	s3,s3,0x10
    1754:	000b0513          	mv	a0,s6
    1758:	01045413          	srli	s0,s0,0x10
    175c:	3d4000ef          	jal	ra,1b30 <__mulsi3>
    1760:	0089e433          	or	s0,s3,s0
    1764:	00a47a63          	bleu	a0,s0,1778 <__umoddi3+0x148>
    1768:	01240433          	add	s0,s0,s2
    176c:	01246663          	bltu	s0,s2,1778 <__umoddi3+0x148>
    1770:	00a47463          	bleu	a0,s0,1778 <__umoddi3+0x148>
    1774:	01240433          	add	s0,s0,s2
    1778:	40a40433          	sub	s0,s0,a0
	  rr.s.low = n0 >> bm;
    177c:	01445533          	srl	a0,s0,s4
	  *rp = rr.ll;
    1780:	00000593          	li	a1,0
}
    1784:	04c12083          	lw	ra,76(sp)
    1788:	04812403          	lw	s0,72(sp)
    178c:	04412483          	lw	s1,68(sp)
    1790:	04012903          	lw	s2,64(sp)
    1794:	03c12983          	lw	s3,60(sp)
    1798:	03812a03          	lw	s4,56(sp)
    179c:	03412a83          	lw	s5,52(sp)
    17a0:	03012b03          	lw	s6,48(sp)
    17a4:	02c12b83          	lw	s7,44(sp)
    17a8:	02812c03          	lw	s8,40(sp)
    17ac:	02412c83          	lw	s9,36(sp)
    17b0:	02012d03          	lw	s10,32(sp)
    17b4:	01c12d83          	lw	s11,28(sp)
    17b8:	05010113          	addi	sp,sp,80
    17bc:	00008067          	ret
	  count_leading_zeros (bm, d0);
    17c0:	010007b7          	lui	a5,0x1000
    17c4:	01000a13          	li	s4,16
    17c8:	ecf66ee3          	bltu	a2,a5,16a4 <__umoddi3+0x74>
    17cc:	01800a13          	li	s4,24
    17d0:	ed5ff06f          	j	16a4 <__umoddi3+0x74>
	  if (d0 == 0)
    17d4:	00061a63          	bnez	a2,17e8 <__umoddi3+0x1b8>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    17d8:	00000593          	li	a1,0
    17dc:	00100513          	li	a0,1
    17e0:	37c000ef          	jal	ra,1b5c <__udivsi3>
    17e4:	00050913          	mv	s2,a0
	  count_leading_zeros (bm, d0);
    17e8:	000107b7          	lui	a5,0x10
    17ec:	0ef97a63          	bleu	a5,s2,18e0 <__umoddi3+0x2b0>
    17f0:	0ff00793          	li	a5,255
    17f4:	0127f463          	bleu	s2,a5,17fc <__umoddi3+0x1cc>
    17f8:	00800a13          	li	s4,8
    17fc:	014957b3          	srl	a5,s2,s4
    1800:	00fa8ab3          	add	s5,s5,a5
    1804:	000ac703          	lbu	a4,0(s5)
    1808:	02000513          	li	a0,32
	      n1 -= d0;
    180c:	412984b3          	sub	s1,s3,s2
	  count_leading_zeros (bm, d0);
    1810:	01470733          	add	a4,a4,s4
    1814:	40e50a33          	sub	s4,a0,a4
	  if (bm == 0)
    1818:	ea0a0ee3          	beqz	s4,16d4 <__umoddi3+0xa4>
	      d0 = d0 << bm;
    181c:	01491933          	sll	s2,s2,s4
	      n2 = n1 >> b;
    1820:	00e9dab3          	srl	s5,s3,a4
	      n1 = (n1 << bm) | (n0 >> b);
    1824:	014995b3          	sll	a1,s3,s4
    1828:	00ecd733          	srl	a4,s9,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    182c:	01095493          	srli	s1,s2,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1830:	00b76b33          	or	s6,a4,a1
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1834:	000a8513          	mv	a0,s5
    1838:	00048593          	mv	a1,s1
    183c:	368000ef          	jal	ra,1ba4 <__umodsi3>
    1840:	00050993          	mv	s3,a0
    1844:	00048593          	mv	a1,s1
    1848:	01091b93          	slli	s7,s2,0x10
    184c:	000a8513          	mv	a0,s5
    1850:	30c000ef          	jal	ra,1b5c <__udivsi3>
    1854:	010bdb93          	srli	s7,s7,0x10
    1858:	00050593          	mv	a1,a0
    185c:	000b8513          	mv	a0,s7
    1860:	2d0000ef          	jal	ra,1b30 <__mulsi3>
    1864:	01099993          	slli	s3,s3,0x10
    1868:	010b5793          	srli	a5,s6,0x10
    186c:	00f9e7b3          	or	a5,s3,a5
	      n0 = n0 << bm;
    1870:	014c9433          	sll	s0,s9,s4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1874:	00a7fa63          	bleu	a0,a5,1888 <__umoddi3+0x258>
    1878:	012787b3          	add	a5,a5,s2
    187c:	0127e663          	bltu	a5,s2,1888 <__umoddi3+0x258>
    1880:	00a7f463          	bleu	a0,a5,1888 <__umoddi3+0x258>
    1884:	012787b3          	add	a5,a5,s2
    1888:	40a78ab3          	sub	s5,a5,a0
    188c:	00048593          	mv	a1,s1
    1890:	000a8513          	mv	a0,s5
    1894:	310000ef          	jal	ra,1ba4 <__umodsi3>
    1898:	00050993          	mv	s3,a0
    189c:	00048593          	mv	a1,s1
    18a0:	000a8513          	mv	a0,s5
    18a4:	2b8000ef          	jal	ra,1b5c <__udivsi3>
    18a8:	00050593          	mv	a1,a0
    18ac:	000b8513          	mv	a0,s7
    18b0:	280000ef          	jal	ra,1b30 <__mulsi3>
    18b4:	010b1593          	slli	a1,s6,0x10
    18b8:	01099993          	slli	s3,s3,0x10
    18bc:	0105d593          	srli	a1,a1,0x10
    18c0:	00b9e5b3          	or	a1,s3,a1
    18c4:	00a5fa63          	bleu	a0,a1,18d8 <__umoddi3+0x2a8>
    18c8:	012585b3          	add	a1,a1,s2
    18cc:	0125e663          	bltu	a1,s2,18d8 <__umoddi3+0x2a8>
    18d0:	00a5f463          	bleu	a0,a1,18d8 <__umoddi3+0x2a8>
    18d4:	012585b3          	add	a1,a1,s2
    18d8:	40a584b3          	sub	s1,a1,a0
    18dc:	df9ff06f          	j	16d4 <__umoddi3+0xa4>
	  count_leading_zeros (bm, d0);
    18e0:	010007b7          	lui	a5,0x1000
    18e4:	01000a13          	li	s4,16
    18e8:	f0f96ae3          	bltu	s2,a5,17fc <__umoddi3+0x1cc>
    18ec:	01800a13          	li	s4,24
    18f0:	f0dff06f          	j	17fc <__umoddi3+0x1cc>
      if (d1 > n1)
    18f4:	e8d5e8e3          	bltu	a1,a3,1784 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    18f8:	000107b7          	lui	a5,0x10
    18fc:	04f6fc63          	bleu	a5,a3,1954 <__umoddi3+0x324>
    1900:	0ff00b93          	li	s7,255
    1904:	00dbb533          	sltu	a0,s7,a3
    1908:	00351513          	slli	a0,a0,0x3
    190c:	00020737          	lui	a4,0x20
    1910:	00a6d7b3          	srl	a5,a3,a0
    1914:	19070713          	addi	a4,a4,400 # 20190 <__clz_tab>
    1918:	00e787b3          	add	a5,a5,a4
    191c:	0007cb83          	lbu	s7,0(a5) # 10000 <__modsi3+0xe428>
    1920:	02000593          	li	a1,32
    1924:	00ab8bb3          	add	s7,s7,a0
    1928:	41758b33          	sub	s6,a1,s7
	  if (bm == 0)
    192c:	020b1e63          	bnez	s6,1968 <__umoddi3+0x338>
	      if (n1 > d1 || n0 >= d0)
    1930:	0136e463          	bltu	a3,s3,1938 <__umoddi3+0x308>
    1934:	00ccea63          	bltu	s9,a2,1948 <__umoddi3+0x318>
		  sub_ddmmss (n1, n0, n1, n0, d1, d0);
    1938:	40cc8433          	sub	s0,s9,a2
    193c:	40d986b3          	sub	a3,s3,a3
    1940:	008cb533          	sltu	a0,s9,s0
    1944:	40a684b3          	sub	s1,a3,a0
		  *rp = rr.ll;
    1948:	00040513          	mv	a0,s0
    194c:	00048593          	mv	a1,s1
    1950:	e35ff06f          	j	1784 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    1954:	010007b7          	lui	a5,0x1000
    1958:	01000513          	li	a0,16
    195c:	faf6e8e3          	bltu	a3,a5,190c <__umoddi3+0x2dc>
    1960:	01800513          	li	a0,24
    1964:	fa9ff06f          	j	190c <__umoddi3+0x2dc>
	      d1 = (d1 << bm) | (d0 >> b);
    1968:	016696b3          	sll	a3,a3,s6
    196c:	01765d33          	srl	s10,a2,s7
    1970:	00dd6d33          	or	s10,s10,a3
	      n2 = n1 >> b;
    1974:	0179d433          	srl	s0,s3,s7
	      n1 = (n1 << bm) | (n0 >> b);
    1978:	016995b3          	sll	a1,s3,s6
    197c:	017cdc33          	srl	s8,s9,s7
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1980:	010d5493          	srli	s1,s10,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1984:	00bc6c33          	or	s8,s8,a1
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1988:	00040513          	mv	a0,s0
    198c:	00048593          	mv	a1,s1
	      d0 = d0 << bm;
    1990:	01661ab3          	sll	s5,a2,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1994:	210000ef          	jal	ra,1ba4 <__umodsi3>
    1998:	00050a13          	mv	s4,a0
    199c:	00048593          	mv	a1,s1
    19a0:	00040513          	mv	a0,s0
	      n0 = n0 << bm;
    19a4:	016c9933          	sll	s2,s9,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    19a8:	010d1c93          	slli	s9,s10,0x10
    19ac:	1b0000ef          	jal	ra,1b5c <__udivsi3>
    19b0:	010cdc93          	srli	s9,s9,0x10
    19b4:	00050413          	mv	s0,a0
    19b8:	00050593          	mv	a1,a0
    19bc:	000c8513          	mv	a0,s9
    19c0:	170000ef          	jal	ra,1b30 <__mulsi3>
    19c4:	010a1a13          	slli	s4,s4,0x10
    19c8:	010c5713          	srli	a4,s8,0x10
    19cc:	00ea6733          	or	a4,s4,a4
    19d0:	00040a13          	mv	s4,s0
    19d4:	00a77e63          	bleu	a0,a4,19f0 <__umoddi3+0x3c0>
    19d8:	01a70733          	add	a4,a4,s10
    19dc:	fff40a13          	addi	s4,s0,-1
    19e0:	01a76863          	bltu	a4,s10,19f0 <__umoddi3+0x3c0>
    19e4:	00a77663          	bleu	a0,a4,19f0 <__umoddi3+0x3c0>
    19e8:	ffe40a13          	addi	s4,s0,-2
    19ec:	01a70733          	add	a4,a4,s10
    19f0:	40a709b3          	sub	s3,a4,a0
    19f4:	00048593          	mv	a1,s1
    19f8:	00098513          	mv	a0,s3
    19fc:	1a8000ef          	jal	ra,1ba4 <__umodsi3>
    1a00:	00048593          	mv	a1,s1
    1a04:	00050413          	mv	s0,a0
    1a08:	00098513          	mv	a0,s3
    1a0c:	150000ef          	jal	ra,1b5c <__udivsi3>
    1a10:	00050593          	mv	a1,a0
    1a14:	00050493          	mv	s1,a0
    1a18:	000c8513          	mv	a0,s9
    1a1c:	114000ef          	jal	ra,1b30 <__mulsi3>
    1a20:	010c1593          	slli	a1,s8,0x10
    1a24:	01041413          	slli	s0,s0,0x10
    1a28:	0105d593          	srli	a1,a1,0x10
    1a2c:	00b465b3          	or	a1,s0,a1
    1a30:	00048713          	mv	a4,s1
    1a34:	00a5fe63          	bleu	a0,a1,1a50 <__umoddi3+0x420>
    1a38:	01a585b3          	add	a1,a1,s10
    1a3c:	fff48713          	addi	a4,s1,-1
    1a40:	01a5e863          	bltu	a1,s10,1a50 <__umoddi3+0x420>
    1a44:	00a5f663          	bleu	a0,a1,1a50 <__umoddi3+0x420>
    1a48:	ffe48713          	addi	a4,s1,-2
    1a4c:	01a585b3          	add	a1,a1,s10
    1a50:	010a1a13          	slli	s4,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    1a54:	00010cb7          	lui	s9,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1a58:	00ea6a33          	or	s4,s4,a4
	      umul_ppmm (m1, m0, q0, d0);
    1a5c:	fffc8413          	addi	s0,s9,-1 # ffff <__modsi3+0xe427>
    1a60:	008a77b3          	and	a5,s4,s0
    1a64:	008af433          	and	s0,s5,s0
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1a68:	40a584b3          	sub	s1,a1,a0
	      umul_ppmm (m1, m0, q0, d0);
    1a6c:	00078513          	mv	a0,a5
    1a70:	00040593          	mv	a1,s0
    1a74:	00f12623          	sw	a5,12(sp)
    1a78:	010a5a13          	srli	s4,s4,0x10
    1a7c:	0b4000ef          	jal	ra,1b30 <__mulsi3>
    1a80:	00050993          	mv	s3,a0
    1a84:	00040593          	mv	a1,s0
    1a88:	000a0513          	mv	a0,s4
    1a8c:	0a4000ef          	jal	ra,1b30 <__mulsi3>
    1a90:	010adc13          	srli	s8,s5,0x10
    1a94:	00050d93          	mv	s11,a0
    1a98:	000c0593          	mv	a1,s8
    1a9c:	000a0513          	mv	a0,s4
    1aa0:	090000ef          	jal	ra,1b30 <__mulsi3>
    1aa4:	00c12783          	lw	a5,12(sp)
    1aa8:	00050a13          	mv	s4,a0
    1aac:	000c0593          	mv	a1,s8
    1ab0:	00078513          	mv	a0,a5
    1ab4:	07c000ef          	jal	ra,1b30 <__mulsi3>
    1ab8:	01b50533          	add	a0,a0,s11
    1abc:	0109d713          	srli	a4,s3,0x10
    1ac0:	00a70733          	add	a4,a4,a0
    1ac4:	01b77463          	bleu	s11,a4,1acc <__umoddi3+0x49c>
    1ac8:	019a0a33          	add	s4,s4,s9
    1acc:	000107b7          	lui	a5,0x10
    1ad0:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe427>
    1ad4:	01075593          	srli	a1,a4,0x10
    1ad8:	00f77733          	and	a4,a4,a5
    1adc:	01071713          	slli	a4,a4,0x10
    1ae0:	00f9f7b3          	and	a5,s3,a5
    1ae4:	014585b3          	add	a1,a1,s4
    1ae8:	00f707b3          	add	a5,a4,a5
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1aec:	00b4e663          	bltu	s1,a1,1af8 <__umoddi3+0x4c8>
    1af0:	00b49e63          	bne	s1,a1,1b0c <__umoddi3+0x4dc>
    1af4:	00f97c63          	bleu	a5,s2,1b0c <__umoddi3+0x4dc>
		  sub_ddmmss (m1, m0, m1, m0, d1, d0);
    1af8:	41578633          	sub	a2,a5,s5
    1afc:	00c7b7b3          	sltu	a5,a5,a2
    1b00:	41a585b3          	sub	a1,a1,s10
    1b04:	40f585b3          	sub	a1,a1,a5
    1b08:	00060793          	mv	a5,a2
		  sub_ddmmss (n1, n0, n1, n0, m1, m0);
    1b0c:	40f907b3          	sub	a5,s2,a5
    1b10:	00f93933          	sltu	s2,s2,a5
    1b14:	40b485b3          	sub	a1,s1,a1
    1b18:	412585b3          	sub	a1,a1,s2
		  rr.s.low = (n1 << b) | (n0 >> bm);
    1b1c:	01759433          	sll	s0,a1,s7
    1b20:	0167d7b3          	srl	a5,a5,s6
		  *rp = rr.ll;
    1b24:	00f46533          	or	a0,s0,a5
    1b28:	0165d5b3          	srl	a1,a1,s6
  return w;
    1b2c:	c59ff06f          	j	1784 <__umoddi3+0x154>

00001b30 <__mulsi3>:
# define __muldi3 __mulsi3
#endif

  .globl __muldi3
__muldi3:
  mv     a2, a0
    1b30:	00050613          	mv	a2,a0
  li     a0, 0
    1b34:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
    1b38:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
    1b3c:	00068463          	beqz	a3,1b44 <__mulsi3+0x14>
  add    a0, a0, a2
    1b40:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
    1b44:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
    1b48:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
    1b4c:	fe0596e3          	bnez	a1,1b38 <__mulsi3+0x8>
  ret
    1b50:	00008067          	ret

00001b54 <__divsi3>:
  beq   a1, t0, .L20
#endif

  .globl __divdi3
__divdi3:
  bltz  a0, .L10
    1b54:	06054063          	bltz	a0,1bb4 <__umodsi3+0x10>
  bltz  a1, .L11
    1b58:	0605c663          	bltz	a1,1bc4 <__umodsi3+0x20>

00001b5c <__udivsi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

  .globl __udivdi3
__udivdi3:
  mv    a2, a1
    1b5c:	00058613          	mv	a2,a1
  mv    a1, a0
    1b60:	00050593          	mv	a1,a0
  li    a0, -1
    1b64:	fff00513          	li	a0,-1
  beqz  a2, .L5
    1b68:	02060c63          	beqz	a2,1ba0 <__udivsi3+0x44>
  li    a3, 1
    1b6c:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
    1b70:	00b67a63          	bleu	a1,a2,1b84 <__udivsi3+0x28>
.L1:
  blez  a2, .L2
    1b74:	00c05863          	blez	a2,1b84 <__udivsi3+0x28>
  slli  a2, a2, 1
    1b78:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
    1b7c:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
    1b80:	feb66ae3          	bltu	a2,a1,1b74 <__udivsi3+0x18>
.L2:
  li    a0, 0
    1b84:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
    1b88:	00c5e663          	bltu	a1,a2,1b94 <__udivsi3+0x38>
  sub   a1, a1, a2
    1b8c:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
    1b90:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
    1b94:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
    1b98:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
    1b9c:	fe0696e3          	bnez	a3,1b88 <__udivsi3+0x2c>
.L5:
  ret
    1ba0:	00008067          	ret

00001ba4 <__umodsi3>:

  .globl __umoddi3
__umoddi3:
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
    1ba4:	00008293          	mv	t0,ra
  jal   __udivdi3
    1ba8:	fb5ff0ef          	jal	ra,1b5c <__udivsi3>
  move  a0, a1
    1bac:	00058513          	mv	a0,a1
  jr    t0
    1bb0:	00028067          	jr	t0

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
    1bb4:	40a00533          	neg	a0,a0
  bgez  a1, .L12      /* Compute __udivdi3(-a0, a1), then negate the result.  */
    1bb8:	0005d863          	bgez	a1,1bc8 <__umodsi3+0x24>
  neg   a1, a1
    1bbc:	40b005b3          	neg	a1,a1
  j     __udivdi3     /* Compute __udivdi3(-a0, -a1).  */
    1bc0:	f9dff06f          	j	1b5c <__udivsi3>
.L11:                 /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
    1bc4:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
    1bc8:	00008293          	mv	t0,ra
  jal   __udivdi3
    1bcc:	f91ff0ef          	jal	ra,1b5c <__udivsi3>
  neg   a0, a0
    1bd0:	40a00533          	neg	a0,a0
  jr    t0
    1bd4:	00028067          	jr	t0

00001bd8 <__modsi3>:

  .globl __moddi3
__moddi3:
  move   t0, ra
    1bd8:	00008293          	mv	t0,ra
  bltz   a1, .L31
    1bdc:	0005ca63          	bltz	a1,1bf0 <__modsi3+0x18>
  bltz   a0, .L32
    1be0:	00054c63          	bltz	a0,1bf8 <__modsi3+0x20>
.L30:
  jal    __udivdi3    /* The dividend is not negative.  */
    1be4:	f79ff0ef          	jal	ra,1b5c <__udivsi3>
  move   a0, a1
    1be8:	00058513          	mv	a0,a1
  jr     t0
    1bec:	00028067          	jr	t0
.L31:
  neg    a1, a1
    1bf0:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
    1bf4:	fe0558e3          	bgez	a0,1be4 <__modsi3+0xc>
.L32:
  neg    a0, a0
    1bf8:	40a00533          	neg	a0,a0
  jal    __udivdi3    /* The dividend is hella negative.  */
    1bfc:	f61ff0ef          	jal	ra,1b5c <__udivsi3>
  neg    a0, a1
    1c00:	40b00533          	neg	a0,a1
  jr     t0
    1c04:	00028067          	jr	t0
