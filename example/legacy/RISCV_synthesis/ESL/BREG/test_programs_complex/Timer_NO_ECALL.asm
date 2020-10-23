
Timer_NO_ECALL.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
       0:	00002fb7          	lui	t6,0x2
       4:	800f8f93          	addi	t6,t6,-2048 # 1800 <__umoddi3+0x378>
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
      cc:	a0c18193          	addi	gp,gp,-1524 # 20ad4 <_gp>

000000d0 <init_bss>:
      d0:	00020517          	auipc	a0,0x20
      d4:	23050513          	addi	a0,a0,560 # 20300 <__bss_start>
      d8:	00020597          	auipc	a1,0x20
      dc:	32c58593          	addi	a1,a1,812 # 20404 <tohost+0x4>
      e0:	00000613          	li	a2,0
      e4:	0ec000ef          	jal	ra,1d0 <fill_block>

000000e8 <init_sbss>:
      e8:	00020517          	auipc	a0,0x20
      ec:	1e450513          	addi	a0,a0,484 # 202cc <num_ticks>
      f0:	00020597          	auipc	a1,0x20
      f4:	1e058593          	addi	a1,a1,480 # 202d0 <timer_ticked>
      f8:	00000613          	li	a2,0
      fc:	0d4000ef          	jal	ra,1d0 <fill_block>

00000100 <write_stack_pattern>:
     100:	00021517          	auipc	a0,0x21
     104:	30850513          	addi	a0,a0,776 # 21408 <_heap_end>
     108:	00022597          	auipc	a1,0x22
     10c:	2fc58593          	addi	a1,a1,764 # 22404 <_heap_end+0xffc>
     110:	ababb637          	lui	a2,0xababb
     114:	bab60613          	addi	a2,a2,-1109 # abababab <__stack+0xaba987a3>
     118:	0b8000ef          	jal	ra,1d0 <fill_block>

0000011c <init_stack>:
     11c:	00022117          	auipc	sp,0x22
     120:	2ec10113          	addi	sp,sp,748 # 22408 <__stack>
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
     2dc:	12870713          	addi	a4,a4,296 # 20400 <tohost>
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
     35c:	0a878793          	addi	a5,a5,168 # 20400 <tohost>
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
     524:	de078793          	addi	a5,a5,-544 # 20300 <__bss_start>
     528:	0007a783          	lw	a5,0(a5)
     52c:	00178693          	addi	a3,a5,1
     530:	00020717          	auipc	a4,0x20
     534:	dd070713          	addi	a4,a4,-560 # 20300 <__bss_start>
     538:	00d72023          	sw	a3,0(a4)
     53c:	00c12703          	lw	a4,12(sp)
     540:	0ff77713          	andi	a4,a4,255
     544:	00020697          	auipc	a3,0x20
     548:	dfc68693          	addi	a3,a3,-516 # 20340 <buf.2126>
     54c:	00f687b3          	add	a5,a3,a5
     550:	00e78023          	sb	a4,0(a5)
     554:	00c12703          	lw	a4,12(sp)
     558:	00a00793          	li	a5,10
     55c:	00f70c63          	beq	a4,a5,574 <putchar+0x60>
     560:	00020797          	auipc	a5,0x20
     564:	da078793          	addi	a5,a5,-608 # 20300 <__bss_start>
     568:	0007a703          	lw	a4,0(a5)
     56c:	04000793          	li	a5,64
     570:	02f71c63          	bne	a4,a5,5a8 <putchar+0x94>
     574:	00020717          	auipc	a4,0x20
     578:	dcc70713          	addi	a4,a4,-564 # 20340 <buf.2126>
     57c:	00020797          	auipc	a5,0x20
     580:	d8478793          	addi	a5,a5,-636 # 20300 <__bss_start>
     584:	0007a783          	lw	a5,0(a5)
     588:	00078693          	mv	a3,a5
     58c:	00070613          	mv	a2,a4
     590:	00100593          	li	a1,1
     594:	04000513          	li	a0,64
     598:	e1dff0ef          	jal	ra,3b4 <syscall>
     59c:	00020797          	auipc	a5,0x20
     5a0:	d6478793          	addi	a5,a5,-668 # 20300 <__bss_start>
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
     620:	669000ef          	jal	ra,1488 <__umoddi3>
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
     dfc:	39370713          	addi	a4,a4,915 # 38393 <__stack+0x15f8b>
     e00:	00e5e733          	or	a4,a1,a4
     e04:	00e7a423          	sw	a4,8(a5)
     e08:	00d67733          	and	a4,a2,a3
     e0c:	01471693          	slli	a3,a4,0x14
     e10:	00030737          	lui	a4,0x30
     e14:	06770713          	addi	a4,a4,103 # 30067 <__stack+0xdc5f>
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
     ea0:	4e478793          	addi	a5,a5,1252 # 20380 <timer_irq_handler>
     ea4:	0007a783          	lw	a5,0(a5)
     ea8:	00078c63          	beqz	a5,ec0 <level_1_interrupt_handler+0x40>
     eac:	0001f797          	auipc	a5,0x1f
     eb0:	4d478793          	addi	a5,a5,1236 # 20380 <timer_irq_handler>
     eb4:	0007a783          	lw	a5,0(a5)
     eb8:	000780e7          	jalr	a5
     ebc:	0240006f          	j	ee0 <level_1_interrupt_handler+0x60>
     ec0:	0001f797          	auipc	a5,0x1f
     ec4:	41878793          	addi	a5,a5,1048 # 202d8 <mtimecmp>
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
     ef8:	48c78793          	addi	a5,a5,1164 # 20380 <timer_irq_handler>
     efc:	00c12703          	lw	a4,12(sp)
     f00:	00e7a023          	sw	a4,0(a5)
     f04:	00000013          	nop
     f08:	01010113          	addi	sp,sp,16
     f0c:	00008067          	ret

00000f10 <set_next_timer_interrupt>:
     f10:	0001f797          	auipc	a5,0x1f
     f14:	3c478793          	addi	a5,a5,964 # 202d4 <__sbss_end>
     f18:	0007a783          	lw	a5,0(a5)
     f1c:	0047a803          	lw	a6,4(a5)
     f20:	0007a783          	lw	a5,0(a5)
     f24:	0001f717          	auipc	a4,0x1f
     f28:	3b470713          	addi	a4,a4,948 # 202d8 <mtimecmp>
     f2c:	00072503          	lw	a0,0(a4)
     f30:	000f45b7          	lui	a1,0xf4
     f34:	24058593          	addi	a1,a1,576 # f4240 <__stack+0xd1e38>
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
     f78:	35878793          	addi	a5,a5,856 # 202cc <num_ticks>
     f7c:	0007a783          	lw	a5,0(a5)
     f80:	00178713          	addi	a4,a5,1
     f84:	0001f797          	auipc	a5,0x1f
     f88:	34878793          	addi	a5,a5,840 # 202cc <num_ticks>
     f8c:	00e7a023          	sw	a4,0(a5)
     f90:	f81ff0ef          	jal	ra,f10 <set_next_timer_interrupt>
     f94:	0001f797          	auipc	a5,0x1f
     f98:	33878793          	addi	a5,a5,824 # 202cc <num_ticks>
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
     fe0:	2f078793          	addi	a5,a5,752 # 202cc <num_ticks>
     fe4:	0007a703          	lw	a4,0(a5)
     fe8:	00400793          	li	a5,4
     fec:	fee7f8e3          	bleu	a4,a5,fdc <main+0x1c>
     ff0:	0001f797          	auipc	a5,0x1f
     ff4:	2dc78793          	addi	a5,a5,732 # 202cc <num_ticks>
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
    1054:	00058793          	mv	a5,a1
    1058:	00060813          	mv	a6,a2
    105c:	00068893          	mv	a7,a3
    1060:	00050313          	mv	t1,a0
    1064:	28069663          	bnez	a3,12f0 <__udivdi3+0x29c>
    1068:	00020737          	lui	a4,0x20
    106c:	19070713          	addi	a4,a4,400 # 20190 <__clz_tab>
    1070:	0ec5f663          	bleu	a2,a1,115c <__udivdi3+0x108>
    1074:	000106b7          	lui	a3,0x10
    1078:	0cd67863          	bleu	a3,a2,1148 <__udivdi3+0xf4>
    107c:	0ff00693          	li	a3,255
    1080:	00c6b6b3          	sltu	a3,a3,a2
    1084:	00369693          	slli	a3,a3,0x3
    1088:	00d658b3          	srl	a7,a2,a3
    108c:	01170733          	add	a4,a4,a7
    1090:	00074703          	lbu	a4,0(a4)
    1094:	00d706b3          	add	a3,a4,a3
    1098:	02000713          	li	a4,32
    109c:	40d70733          	sub	a4,a4,a3
    10a0:	00070c63          	beqz	a4,10b8 <__udivdi3+0x64>
    10a4:	00e797b3          	sll	a5,a5,a4
    10a8:	00d556b3          	srl	a3,a0,a3
    10ac:	00e61833          	sll	a6,a2,a4
    10b0:	00f6e5b3          	or	a1,a3,a5
    10b4:	00e51333          	sll	t1,a0,a4
    10b8:	01085513          	srli	a0,a6,0x10
    10bc:	02a5d7b3          	divu	a5,a1,a0
    10c0:	01081613          	slli	a2,a6,0x10
    10c4:	01065613          	srli	a2,a2,0x10
    10c8:	01035693          	srli	a3,t1,0x10
    10cc:	02a5f733          	remu	a4,a1,a0
    10d0:	02f605b3          	mul	a1,a2,a5
    10d4:	01071713          	slli	a4,a4,0x10
    10d8:	00d766b3          	or	a3,a4,a3
    10dc:	00078713          	mv	a4,a5
    10e0:	00b6fe63          	bleu	a1,a3,10fc <__udivdi3+0xa8>
    10e4:	010686b3          	add	a3,a3,a6
    10e8:	fff78713          	addi	a4,a5,-1
    10ec:	0106e863          	bltu	a3,a6,10fc <__udivdi3+0xa8>
    10f0:	00b6f663          	bleu	a1,a3,10fc <__udivdi3+0xa8>
    10f4:	ffe78713          	addi	a4,a5,-2
    10f8:	010686b3          	add	a3,a3,a6
    10fc:	40b686b3          	sub	a3,a3,a1
    1100:	02a6f7b3          	remu	a5,a3,a0
    1104:	01031313          	slli	t1,t1,0x10
    1108:	01035313          	srli	t1,t1,0x10
    110c:	02a6d6b3          	divu	a3,a3,a0
    1110:	01079793          	slli	a5,a5,0x10
    1114:	0067e333          	or	t1,a5,t1
    1118:	02d605b3          	mul	a1,a2,a3
    111c:	00068513          	mv	a0,a3
    1120:	00b37c63          	bleu	a1,t1,1138 <__udivdi3+0xe4>
    1124:	00680333          	add	t1,a6,t1
    1128:	fff68513          	addi	a0,a3,-1 # ffff <__umoddi3+0xeb77>
    112c:	01036663          	bltu	t1,a6,1138 <__udivdi3+0xe4>
    1130:	00b37463          	bleu	a1,t1,1138 <__udivdi3+0xe4>
    1134:	ffe68513          	addi	a0,a3,-2
    1138:	01071713          	slli	a4,a4,0x10
    113c:	00a76733          	or	a4,a4,a0
    1140:	00000593          	li	a1,0
    1144:	0e40006f          	j	1228 <__udivdi3+0x1d4>
    1148:	010008b7          	lui	a7,0x1000
    114c:	01000693          	li	a3,16
    1150:	f3166ce3          	bltu	a2,a7,1088 <__udivdi3+0x34>
    1154:	01800693          	li	a3,24
    1158:	f31ff06f          	j	1088 <__udivdi3+0x34>
    115c:	00061663          	bnez	a2,1168 <__udivdi3+0x114>
    1160:	00100693          	li	a3,1
    1164:	02c6d833          	divu	a6,a3,a2
    1168:	000106b7          	lui	a3,0x10
    116c:	0cd87263          	bleu	a3,a6,1230 <__udivdi3+0x1dc>
    1170:	0ff00693          	li	a3,255
    1174:	0106f463          	bleu	a6,a3,117c <__udivdi3+0x128>
    1178:	00800893          	li	a7,8
    117c:	011856b3          	srl	a3,a6,a7
    1180:	00d70733          	add	a4,a4,a3
    1184:	00074683          	lbu	a3,0(a4)
    1188:	02000713          	li	a4,32
    118c:	011686b3          	add	a3,a3,a7
    1190:	40d70733          	sub	a4,a4,a3
    1194:	0a071863          	bnez	a4,1244 <__udivdi3+0x1f0>
    1198:	410787b3          	sub	a5,a5,a6
    119c:	00100593          	li	a1,1
    11a0:	01085613          	srli	a2,a6,0x10
    11a4:	01081893          	slli	a7,a6,0x10
    11a8:	0108d893          	srli	a7,a7,0x10
    11ac:	01035693          	srli	a3,t1,0x10
    11b0:	02c7f733          	remu	a4,a5,a2
    11b4:	02c7d7b3          	divu	a5,a5,a2
    11b8:	01071713          	slli	a4,a4,0x10
    11bc:	00d766b3          	or	a3,a4,a3
    11c0:	02f88533          	mul	a0,a7,a5
    11c4:	00078713          	mv	a4,a5
    11c8:	00a6fe63          	bleu	a0,a3,11e4 <__udivdi3+0x190>
    11cc:	010686b3          	add	a3,a3,a6
    11d0:	fff78713          	addi	a4,a5,-1
    11d4:	0106e863          	bltu	a3,a6,11e4 <__udivdi3+0x190>
    11d8:	00a6f663          	bleu	a0,a3,11e4 <__udivdi3+0x190>
    11dc:	ffe78713          	addi	a4,a5,-2
    11e0:	010686b3          	add	a3,a3,a6
    11e4:	40a686b3          	sub	a3,a3,a0
    11e8:	02c6f7b3          	remu	a5,a3,a2
    11ec:	01031313          	slli	t1,t1,0x10
    11f0:	01035313          	srli	t1,t1,0x10
    11f4:	02c6d6b3          	divu	a3,a3,a2
    11f8:	01079793          	slli	a5,a5,0x10
    11fc:	0067e333          	or	t1,a5,t1
    1200:	02d888b3          	mul	a7,a7,a3
    1204:	00068513          	mv	a0,a3
    1208:	01137c63          	bleu	a7,t1,1220 <__udivdi3+0x1cc>
    120c:	00680333          	add	t1,a6,t1
    1210:	fff68513          	addi	a0,a3,-1 # ffff <__umoddi3+0xeb77>
    1214:	01036663          	bltu	t1,a6,1220 <__udivdi3+0x1cc>
    1218:	01137463          	bleu	a7,t1,1220 <__udivdi3+0x1cc>
    121c:	ffe68513          	addi	a0,a3,-2
    1220:	01071713          	slli	a4,a4,0x10
    1224:	00a76733          	or	a4,a4,a0
    1228:	00070513          	mv	a0,a4
    122c:	00008067          	ret
    1230:	010006b7          	lui	a3,0x1000
    1234:	01000893          	li	a7,16
    1238:	f4d862e3          	bltu	a6,a3,117c <__udivdi3+0x128>
    123c:	01800893          	li	a7,24
    1240:	f3dff06f          	j	117c <__udivdi3+0x128>
    1244:	00e81833          	sll	a6,a6,a4
    1248:	00d7d5b3          	srl	a1,a5,a3
    124c:	00e51333          	sll	t1,a0,a4
    1250:	00d556b3          	srl	a3,a0,a3
    1254:	01085513          	srli	a0,a6,0x10
    1258:	00e797b3          	sll	a5,a5,a4
    125c:	02a5f733          	remu	a4,a1,a0
    1260:	00f6e8b3          	or	a7,a3,a5
    1264:	01081793          	slli	a5,a6,0x10
    1268:	0107d793          	srli	a5,a5,0x10
    126c:	0108d613          	srli	a2,a7,0x10
    1270:	02a5d5b3          	divu	a1,a1,a0
    1274:	01071713          	slli	a4,a4,0x10
    1278:	00c76733          	or	a4,a4,a2
    127c:	02b786b3          	mul	a3,a5,a1
    1280:	00058613          	mv	a2,a1
    1284:	00d77e63          	bleu	a3,a4,12a0 <__udivdi3+0x24c>
    1288:	01070733          	add	a4,a4,a6
    128c:	fff58613          	addi	a2,a1,-1
    1290:	01076863          	bltu	a4,a6,12a0 <__udivdi3+0x24c>
    1294:	00d77663          	bleu	a3,a4,12a0 <__udivdi3+0x24c>
    1298:	ffe58613          	addi	a2,a1,-2
    129c:	01070733          	add	a4,a4,a6
    12a0:	40d706b3          	sub	a3,a4,a3
    12a4:	02a6f733          	remu	a4,a3,a0
    12a8:	01089893          	slli	a7,a7,0x10
    12ac:	0108d893          	srli	a7,a7,0x10
    12b0:	02a6d6b3          	divu	a3,a3,a0
    12b4:	01071713          	slli	a4,a4,0x10
    12b8:	02d785b3          	mul	a1,a5,a3
    12bc:	011767b3          	or	a5,a4,a7
    12c0:	00068713          	mv	a4,a3
    12c4:	00b7fe63          	bleu	a1,a5,12e0 <__udivdi3+0x28c>
    12c8:	010787b3          	add	a5,a5,a6
    12cc:	fff68713          	addi	a4,a3,-1 # ffffff <__stack+0xfddbf7>
    12d0:	0107e863          	bltu	a5,a6,12e0 <__udivdi3+0x28c>
    12d4:	00b7f663          	bleu	a1,a5,12e0 <__udivdi3+0x28c>
    12d8:	ffe68713          	addi	a4,a3,-2
    12dc:	010787b3          	add	a5,a5,a6
    12e0:	40b787b3          	sub	a5,a5,a1
    12e4:	01061593          	slli	a1,a2,0x10
    12e8:	00e5e5b3          	or	a1,a1,a4
    12ec:	eb5ff06f          	j	11a0 <__udivdi3+0x14c>
    12f0:	18d5e663          	bltu	a1,a3,147c <__udivdi3+0x428>
    12f4:	00010737          	lui	a4,0x10
    12f8:	04e6f463          	bleu	a4,a3,1340 <__udivdi3+0x2ec>
    12fc:	0ff00813          	li	a6,255
    1300:	00d83733          	sltu	a4,a6,a3
    1304:	00371713          	slli	a4,a4,0x3
    1308:	00020837          	lui	a6,0x20
    130c:	19080813          	addi	a6,a6,400 # 20190 <__clz_tab>
    1310:	00e6d5b3          	srl	a1,a3,a4
    1314:	010585b3          	add	a1,a1,a6
    1318:	0005c803          	lbu	a6,0(a1)
    131c:	02000593          	li	a1,32
    1320:	00e80833          	add	a6,a6,a4
    1324:	410585b3          	sub	a1,a1,a6
    1328:	02059663          	bnez	a1,1354 <__udivdi3+0x300>
    132c:	00100713          	li	a4,1
    1330:	eef6ece3          	bltu	a3,a5,1228 <__udivdi3+0x1d4>
    1334:	00c53533          	sltu	a0,a0,a2
    1338:	00154713          	xori	a4,a0,1
    133c:	eedff06f          	j	1228 <__udivdi3+0x1d4>
    1340:	010005b7          	lui	a1,0x1000
    1344:	01000713          	li	a4,16
    1348:	fcb6e0e3          	bltu	a3,a1,1308 <__udivdi3+0x2b4>
    134c:	01800713          	li	a4,24
    1350:	fb9ff06f          	j	1308 <__udivdi3+0x2b4>
    1354:	01065733          	srl	a4,a2,a6
    1358:	00b696b3          	sll	a3,a3,a1
    135c:	00d766b3          	or	a3,a4,a3
    1360:	0106de93          	srli	t4,a3,0x10
    1364:	0107d733          	srl	a4,a5,a6
    1368:	03d778b3          	remu	a7,a4,t4
    136c:	00b797b3          	sll	a5,a5,a1
    1370:	01055833          	srl	a6,a0,a6
    1374:	00f86333          	or	t1,a6,a5
    1378:	01069793          	slli	a5,a3,0x10
    137c:	0107d793          	srli	a5,a5,0x10
    1380:	01035813          	srli	a6,t1,0x10
    1384:	00b61633          	sll	a2,a2,a1
    1388:	03d75733          	divu	a4,a4,t4
    138c:	01089893          	slli	a7,a7,0x10
    1390:	0108e833          	or	a6,a7,a6
    1394:	02e78f33          	mul	t5,a5,a4
    1398:	00070e13          	mv	t3,a4
    139c:	01e87e63          	bleu	t5,a6,13b8 <__udivdi3+0x364>
    13a0:	00d80833          	add	a6,a6,a3
    13a4:	fff70e13          	addi	t3,a4,-1 # ffff <__umoddi3+0xeb77>
    13a8:	00d86863          	bltu	a6,a3,13b8 <__udivdi3+0x364>
    13ac:	01e87663          	bleu	t5,a6,13b8 <__udivdi3+0x364>
    13b0:	ffe70e13          	addi	t3,a4,-2
    13b4:	00d80833          	add	a6,a6,a3
    13b8:	41e80833          	sub	a6,a6,t5
    13bc:	03d878b3          	remu	a7,a6,t4
    13c0:	03d85833          	divu	a6,a6,t4
    13c4:	01089893          	slli	a7,a7,0x10
    13c8:	03078eb3          	mul	t4,a5,a6
    13cc:	01031793          	slli	a5,t1,0x10
    13d0:	0107d793          	srli	a5,a5,0x10
    13d4:	00f8e7b3          	or	a5,a7,a5
    13d8:	00080713          	mv	a4,a6
    13dc:	01d7fe63          	bleu	t4,a5,13f8 <__udivdi3+0x3a4>
    13e0:	00d787b3          	add	a5,a5,a3
    13e4:	fff80713          	addi	a4,a6,-1
    13e8:	00d7e863          	bltu	a5,a3,13f8 <__udivdi3+0x3a4>
    13ec:	01d7f663          	bleu	t4,a5,13f8 <__udivdi3+0x3a4>
    13f0:	ffe80713          	addi	a4,a6,-2
    13f4:	00d787b3          	add	a5,a5,a3
    13f8:	010e1e13          	slli	t3,t3,0x10
    13fc:	41d787b3          	sub	a5,a5,t4
    1400:	00010eb7          	lui	t4,0x10
    1404:	00ee6733          	or	a4,t3,a4
    1408:	fffe8813          	addi	a6,t4,-1 # ffff <__umoddi3+0xeb77>
    140c:	01077333          	and	t1,a4,a6
    1410:	01075893          	srli	a7,a4,0x10
    1414:	01067833          	and	a6,a2,a6
    1418:	01065613          	srli	a2,a2,0x10
    141c:	03030e33          	mul	t3,t1,a6
    1420:	03088833          	mul	a6,a7,a6
    1424:	010e5693          	srli	a3,t3,0x10
    1428:	02c30333          	mul	t1,t1,a2
    142c:	01030333          	add	t1,t1,a6
    1430:	006686b3          	add	a3,a3,t1
    1434:	02c888b3          	mul	a7,a7,a2
    1438:	0106f463          	bleu	a6,a3,1440 <__udivdi3+0x3ec>
    143c:	01d888b3          	add	a7,a7,t4
    1440:	0106d613          	srli	a2,a3,0x10
    1444:	011608b3          	add	a7,a2,a7
    1448:	0317e663          	bltu	a5,a7,1474 <__udivdi3+0x420>
    144c:	cf179ae3          	bne	a5,a7,1140 <__udivdi3+0xec>
    1450:	000107b7          	lui	a5,0x10
    1454:	fff78793          	addi	a5,a5,-1 # ffff <__umoddi3+0xeb77>
    1458:	00f6f6b3          	and	a3,a3,a5
    145c:	01069693          	slli	a3,a3,0x10
    1460:	00fe7e33          	and	t3,t3,a5
    1464:	00b51533          	sll	a0,a0,a1
    1468:	01c686b3          	add	a3,a3,t3
    146c:	00000593          	li	a1,0
    1470:	dad57ce3          	bleu	a3,a0,1228 <__udivdi3+0x1d4>
    1474:	fff70713          	addi	a4,a4,-1
    1478:	cc9ff06f          	j	1140 <__udivdi3+0xec>
    147c:	00000593          	li	a1,0
    1480:	00000713          	li	a4,0
    1484:	da5ff06f          	j	1228 <__udivdi3+0x1d4>

00001488 <__umoddi3>:
    1488:	00060893          	mv	a7,a2
    148c:	00068713          	mv	a4,a3
    1490:	00050793          	mv	a5,a0
    1494:	00058813          	mv	a6,a1
    1498:	22069c63          	bnez	a3,16d0 <__umoddi3+0x248>
    149c:	000206b7          	lui	a3,0x20
    14a0:	19068693          	addi	a3,a3,400 # 20190 <__clz_tab>
    14a4:	0cc5fc63          	bleu	a2,a1,157c <__umoddi3+0xf4>
    14a8:	00010337          	lui	t1,0x10
    14ac:	0a667e63          	bleu	t1,a2,1568 <__umoddi3+0xe0>
    14b0:	0ff00313          	li	t1,255
    14b4:	00c37463          	bleu	a2,t1,14bc <__umoddi3+0x34>
    14b8:	00800713          	li	a4,8
    14bc:	00e65333          	srl	t1,a2,a4
    14c0:	006686b3          	add	a3,a3,t1
    14c4:	0006ce03          	lbu	t3,0(a3)
    14c8:	02000313          	li	t1,32
    14cc:	00ee0e33          	add	t3,t3,a4
    14d0:	41c30333          	sub	t1,t1,t3
    14d4:	00030c63          	beqz	t1,14ec <__umoddi3+0x64>
    14d8:	006595b3          	sll	a1,a1,t1
    14dc:	01c55e33          	srl	t3,a0,t3
    14e0:	006618b3          	sll	a7,a2,t1
    14e4:	00be6833          	or	a6,t3,a1
    14e8:	006517b3          	sll	a5,a0,t1
    14ec:	0108d613          	srli	a2,a7,0x10
    14f0:	02c87733          	remu	a4,a6,a2
    14f4:	01089513          	slli	a0,a7,0x10
    14f8:	01055513          	srli	a0,a0,0x10
    14fc:	0107d693          	srli	a3,a5,0x10
    1500:	02c85833          	divu	a6,a6,a2
    1504:	01071713          	slli	a4,a4,0x10
    1508:	00d766b3          	or	a3,a4,a3
    150c:	03050833          	mul	a6,a0,a6
    1510:	0106fa63          	bleu	a6,a3,1524 <__umoddi3+0x9c>
    1514:	011686b3          	add	a3,a3,a7
    1518:	0116e663          	bltu	a3,a7,1524 <__umoddi3+0x9c>
    151c:	0106f463          	bleu	a6,a3,1524 <__umoddi3+0x9c>
    1520:	011686b3          	add	a3,a3,a7
    1524:	410686b3          	sub	a3,a3,a6
    1528:	02c6f733          	remu	a4,a3,a2
    152c:	01079793          	slli	a5,a5,0x10
    1530:	0107d793          	srli	a5,a5,0x10
    1534:	02c6d6b3          	divu	a3,a3,a2
    1538:	02d506b3          	mul	a3,a0,a3
    153c:	01071513          	slli	a0,a4,0x10
    1540:	00f567b3          	or	a5,a0,a5
    1544:	00d7fa63          	bleu	a3,a5,1558 <__umoddi3+0xd0>
    1548:	011787b3          	add	a5,a5,a7
    154c:	0117e663          	bltu	a5,a7,1558 <__umoddi3+0xd0>
    1550:	00d7f463          	bleu	a3,a5,1558 <__umoddi3+0xd0>
    1554:	011787b3          	add	a5,a5,a7
    1558:	40d787b3          	sub	a5,a5,a3
    155c:	0067d533          	srl	a0,a5,t1
    1560:	00000593          	li	a1,0
    1564:	00008067          	ret
    1568:	01000337          	lui	t1,0x1000
    156c:	01000713          	li	a4,16
    1570:	f46666e3          	bltu	a2,t1,14bc <__umoddi3+0x34>
    1574:	01800713          	li	a4,24
    1578:	f45ff06f          	j	14bc <__umoddi3+0x34>
    157c:	00061663          	bnez	a2,1588 <__umoddi3+0x100>
    1580:	00100613          	li	a2,1
    1584:	031658b3          	divu	a7,a2,a7
    1588:	00010637          	lui	a2,0x10
    158c:	0ac8f263          	bleu	a2,a7,1630 <__umoddi3+0x1a8>
    1590:	0ff00613          	li	a2,255
    1594:	01167463          	bleu	a7,a2,159c <__umoddi3+0x114>
    1598:	00800713          	li	a4,8
    159c:	00e8d633          	srl	a2,a7,a4
    15a0:	00c686b3          	add	a3,a3,a2
    15a4:	0006ce03          	lbu	t3,0(a3)
    15a8:	02000313          	li	t1,32
    15ac:	00ee0e33          	add	t3,t3,a4
    15b0:	41c30333          	sub	t1,t1,t3
    15b4:	08031863          	bnez	t1,1644 <__umoddi3+0x1bc>
    15b8:	411585b3          	sub	a1,a1,a7
    15bc:	0108d713          	srli	a4,a7,0x10
    15c0:	01089513          	slli	a0,a7,0x10
    15c4:	01055513          	srli	a0,a0,0x10
    15c8:	0107d613          	srli	a2,a5,0x10
    15cc:	02e5f6b3          	remu	a3,a1,a4
    15d0:	02e5d5b3          	divu	a1,a1,a4
    15d4:	01069693          	slli	a3,a3,0x10
    15d8:	00c6e6b3          	or	a3,a3,a2
    15dc:	02b505b3          	mul	a1,a0,a1
    15e0:	00b6fa63          	bleu	a1,a3,15f4 <__umoddi3+0x16c>
    15e4:	011686b3          	add	a3,a3,a7
    15e8:	0116e663          	bltu	a3,a7,15f4 <__umoddi3+0x16c>
    15ec:	00b6f463          	bleu	a1,a3,15f4 <__umoddi3+0x16c>
    15f0:	011686b3          	add	a3,a3,a7
    15f4:	40b685b3          	sub	a1,a3,a1
    15f8:	02e5f6b3          	remu	a3,a1,a4
    15fc:	01079793          	slli	a5,a5,0x10
    1600:	0107d793          	srli	a5,a5,0x10
    1604:	02e5d5b3          	divu	a1,a1,a4
    1608:	02b505b3          	mul	a1,a0,a1
    160c:	01069513          	slli	a0,a3,0x10
    1610:	00f567b3          	or	a5,a0,a5
    1614:	00b7fa63          	bleu	a1,a5,1628 <__umoddi3+0x1a0>
    1618:	011787b3          	add	a5,a5,a7
    161c:	0117e663          	bltu	a5,a7,1628 <__umoddi3+0x1a0>
    1620:	00b7f463          	bleu	a1,a5,1628 <__umoddi3+0x1a0>
    1624:	011787b3          	add	a5,a5,a7
    1628:	40b787b3          	sub	a5,a5,a1
    162c:	f31ff06f          	j	155c <__umoddi3+0xd4>
    1630:	01000637          	lui	a2,0x1000
    1634:	01000713          	li	a4,16
    1638:	f6c8e2e3          	bltu	a7,a2,159c <__umoddi3+0x114>
    163c:	01800713          	li	a4,24
    1640:	f5dff06f          	j	159c <__umoddi3+0x114>
    1644:	006898b3          	sll	a7,a7,t1
    1648:	01c5d733          	srl	a4,a1,t3
    164c:	006517b3          	sll	a5,a0,t1
    1650:	01c55e33          	srl	t3,a0,t3
    1654:	0108d513          	srli	a0,a7,0x10
    1658:	02a776b3          	remu	a3,a4,a0
    165c:	006595b3          	sll	a1,a1,t1
    1660:	00be6e33          	or	t3,t3,a1
    1664:	01089593          	slli	a1,a7,0x10
    1668:	0105d593          	srli	a1,a1,0x10
    166c:	010e5613          	srli	a2,t3,0x10
    1670:	02a75733          	divu	a4,a4,a0
    1674:	01069693          	slli	a3,a3,0x10
    1678:	00c6e6b3          	or	a3,a3,a2
    167c:	02e58733          	mul	a4,a1,a4
    1680:	00e6fa63          	bleu	a4,a3,1694 <__umoddi3+0x20c>
    1684:	011686b3          	add	a3,a3,a7
    1688:	0116e663          	bltu	a3,a7,1694 <__umoddi3+0x20c>
    168c:	00e6f463          	bleu	a4,a3,1694 <__umoddi3+0x20c>
    1690:	011686b3          	add	a3,a3,a7
    1694:	40e68633          	sub	a2,a3,a4
    1698:	02a676b3          	remu	a3,a2,a0
    169c:	010e1e13          	slli	t3,t3,0x10
    16a0:	010e5e13          	srli	t3,t3,0x10
    16a4:	02a65633          	divu	a2,a2,a0
    16a8:	01069693          	slli	a3,a3,0x10
    16ac:	02c58633          	mul	a2,a1,a2
    16b0:	01c6e5b3          	or	a1,a3,t3
    16b4:	00c5fa63          	bleu	a2,a1,16c8 <__umoddi3+0x240>
    16b8:	011585b3          	add	a1,a1,a7
    16bc:	0115e663          	bltu	a1,a7,16c8 <__umoddi3+0x240>
    16c0:	00c5f463          	bleu	a2,a1,16c8 <__umoddi3+0x240>
    16c4:	011585b3          	add	a1,a1,a7
    16c8:	40c585b3          	sub	a1,a1,a2
    16cc:	ef1ff06f          	j	15bc <__umoddi3+0x134>
    16d0:	e8d5eae3          	bltu	a1,a3,1564 <__umoddi3+0xdc>
    16d4:	00010737          	lui	a4,0x10
    16d8:	04e6fc63          	bleu	a4,a3,1730 <__umoddi3+0x2a8>
    16dc:	0ff00e93          	li	t4,255
    16e0:	00deb733          	sltu	a4,t4,a3
    16e4:	00371713          	slli	a4,a4,0x3
    16e8:	00020337          	lui	t1,0x20
    16ec:	00e6d8b3          	srl	a7,a3,a4
    16f0:	19030313          	addi	t1,t1,400 # 20190 <__clz_tab>
    16f4:	006888b3          	add	a7,a7,t1
    16f8:	0008ce83          	lbu	t4,0(a7) # 1000000 <__stack+0xfddbf8>
    16fc:	02000e13          	li	t3,32
    1700:	00ee8eb3          	add	t4,t4,a4
    1704:	41de0e33          	sub	t3,t3,t4
    1708:	020e1e63          	bnez	t3,1744 <__umoddi3+0x2bc>
    170c:	00b6e463          	bltu	a3,a1,1714 <__umoddi3+0x28c>
    1710:	00c56a63          	bltu	a0,a2,1724 <__umoddi3+0x29c>
    1714:	40c507b3          	sub	a5,a0,a2
    1718:	40d585b3          	sub	a1,a1,a3
    171c:	00f53533          	sltu	a0,a0,a5
    1720:	40a58833          	sub	a6,a1,a0
    1724:	00078513          	mv	a0,a5
    1728:	00080593          	mv	a1,a6
    172c:	e39ff06f          	j	1564 <__umoddi3+0xdc>
    1730:	010008b7          	lui	a7,0x1000
    1734:	01000713          	li	a4,16
    1738:	fb16e8e3          	bltu	a3,a7,16e8 <__umoddi3+0x260>
    173c:	01800713          	li	a4,24
    1740:	fa9ff06f          	j	16e8 <__umoddi3+0x260>
    1744:	01d65733          	srl	a4,a2,t4
    1748:	01c696b3          	sll	a3,a3,t3
    174c:	00d766b3          	or	a3,a4,a3
    1750:	01d557b3          	srl	a5,a0,t4
    1754:	01d5d733          	srl	a4,a1,t4
    1758:	01c595b3          	sll	a1,a1,t3
    175c:	00b7e7b3          	or	a5,a5,a1
    1760:	0106d593          	srli	a1,a3,0x10
    1764:	02b77333          	remu	t1,a4,a1
    1768:	01069f13          	slli	t5,a3,0x10
    176c:	010f5f13          	srli	t5,t5,0x10
    1770:	0107d893          	srli	a7,a5,0x10
    1774:	01c61633          	sll	a2,a2,t3
    1778:	01c51533          	sll	a0,a0,t3
    177c:	02b75733          	divu	a4,a4,a1
    1780:	01031313          	slli	t1,t1,0x10
    1784:	011368b3          	or	a7,t1,a7
    1788:	02ef0833          	mul	a6,t5,a4
    178c:	00070313          	mv	t1,a4
    1790:	0108fe63          	bleu	a6,a7,17ac <__umoddi3+0x324>
    1794:	00d888b3          	add	a7,a7,a3
    1798:	fff70313          	addi	t1,a4,-1 # ffff <__umoddi3+0xeb77>
    179c:	00d8e863          	bltu	a7,a3,17ac <__umoddi3+0x324>
    17a0:	0108f663          	bleu	a6,a7,17ac <__umoddi3+0x324>
    17a4:	ffe70313          	addi	t1,a4,-2
    17a8:	00d888b3          	add	a7,a7,a3
    17ac:	410888b3          	sub	a7,a7,a6
    17b0:	02b8ffb3          	remu	t6,a7,a1
    17b4:	02b8d8b3          	divu	a7,a7,a1
    17b8:	010f9f93          	slli	t6,t6,0x10
    17bc:	031f05b3          	mul	a1,t5,a7
    17c0:	01079f13          	slli	t5,a5,0x10
    17c4:	010f5f13          	srli	t5,t5,0x10
    17c8:	01efef33          	or	t5,t6,t5
    17cc:	00088713          	mv	a4,a7
    17d0:	00bf7e63          	bleu	a1,t5,17ec <__umoddi3+0x364>
    17d4:	00df0f33          	add	t5,t5,a3
    17d8:	fff88713          	addi	a4,a7,-1 # ffffff <__stack+0xfddbf7>
    17dc:	00df6863          	bltu	t5,a3,17ec <__umoddi3+0x364>
    17e0:	00bf7663          	bleu	a1,t5,17ec <__umoddi3+0x364>
    17e4:	ffe88713          	addi	a4,a7,-2
    17e8:	00df0f33          	add	t5,t5,a3
    17ec:	01031313          	slli	t1,t1,0x10
    17f0:	000108b7          	lui	a7,0x10
    17f4:	00e36333          	or	t1,t1,a4
    17f8:	fff88793          	addi	a5,a7,-1 # ffff <__umoddi3+0xeb77>
    17fc:	01065813          	srli	a6,a2,0x10
    1800:	40bf0f33          	sub	t5,t5,a1
    1804:	00f375b3          	and	a1,t1,a5
    1808:	01035313          	srli	t1,t1,0x10
    180c:	00f677b3          	and	a5,a2,a5
    1810:	02f58733          	mul	a4,a1,a5
    1814:	02f307b3          	mul	a5,t1,a5
    1818:	030585b3          	mul	a1,a1,a6
    181c:	03030333          	mul	t1,t1,a6
    1820:	00f585b3          	add	a1,a1,a5
    1824:	01075813          	srli	a6,a4,0x10
    1828:	00b80833          	add	a6,a6,a1
    182c:	00f87463          	bleu	a5,a6,1834 <__umoddi3+0x3ac>
    1830:	01130333          	add	t1,t1,a7
    1834:	000107b7          	lui	a5,0x10
    1838:	fff78793          	addi	a5,a5,-1 # ffff <__umoddi3+0xeb77>
    183c:	01085593          	srli	a1,a6,0x10
    1840:	00f87833          	and	a6,a6,a5
    1844:	01081813          	slli	a6,a6,0x10
    1848:	00f77733          	and	a4,a4,a5
    184c:	006585b3          	add	a1,a1,t1
    1850:	00e80733          	add	a4,a6,a4
    1854:	00bf6663          	bltu	t5,a1,1860 <__umoddi3+0x3d8>
    1858:	00bf1e63          	bne	t5,a1,1874 <__umoddi3+0x3ec>
    185c:	00e57c63          	bleu	a4,a0,1874 <__umoddi3+0x3ec>
    1860:	40c70633          	sub	a2,a4,a2
    1864:	00c73733          	sltu	a4,a4,a2
    1868:	40d585b3          	sub	a1,a1,a3
    186c:	40e585b3          	sub	a1,a1,a4
    1870:	00060713          	mv	a4,a2
    1874:	40e50733          	sub	a4,a0,a4
    1878:	00e53533          	sltu	a0,a0,a4
    187c:	40bf05b3          	sub	a1,t5,a1
    1880:	40a585b3          	sub	a1,a1,a0
    1884:	01d597b3          	sll	a5,a1,t4
    1888:	01c75733          	srl	a4,a4,t3
    188c:	00e7e533          	or	a0,a5,a4
    1890:	01c5d5b3          	srl	a1,a1,t3
    1894:	cd1ff06f          	j	1564 <__umoddi3+0xdc>
