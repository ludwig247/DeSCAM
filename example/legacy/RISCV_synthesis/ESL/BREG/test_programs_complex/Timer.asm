
Timer.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
       0:	00002fb7          	lui	t6,0x2
       4:	800f8f93          	addi	t6,t6,-2048 # 1800 <__umoddi3+0x1cc>
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
     130:	2ec0006f          	j	41c <vSyscallInit>

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
     180:	505000ef          	jal	ra,e84 <level_1_interrupt_handler>
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
     384:	495000ef          	jal	ra,1018 <strlen>
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
     3c8:	00c12883          	lw	a7,12(sp)
     3cc:	00812503          	lw	a0,8(sp)
     3d0:	00412583          	lw	a1,4(sp)
     3d4:	00012603          	lw	a2,0(sp)
     3d8:	00000073          	ecall
     3dc:	00050793          	mv	a5,a0
     3e0:	00078513          	mv	a0,a5
     3e4:	01010113          	addi	sp,sp,16
     3e8:	00008067          	ret
     3ec:	fe010113          	addi	sp,sp,-32
     3f0:	00112e23          	sw	ra,28(sp)
     3f4:	00a12623          	sw	a0,12(sp)
     3f8:	00b12423          	sw	a1,8(sp)
     3fc:	00020517          	auipc	a0,0x20
     400:	c0450513          	addi	a0,a0,-1020 # 20000 <__rodata_start>
     404:	f69ff0ef          	jal	ra,36c <printstr>
     408:	fff00793          	li	a5,-1
     40c:	00078513          	mv	a0,a5
     410:	01c12083          	lw	ra,28(sp)
     414:	02010113          	addi	sp,sp,32
     418:	00008067          	ret

0000041c <vSyscallInit>:
     41c:	fe010113          	addi	sp,sp,-32
     420:	00112e23          	sw	ra,28(sp)
     424:	00000593          	li	a1,0
     428:	00000513          	li	a0,0
     42c:	399000ef          	jal	ra,fc4 <main>
     430:	00a12623          	sw	a0,12(sp)
     434:	00c12503          	lw	a0,12(sp)
     438:	079000ef          	jal	ra,cb0 <exit>
     43c:	00000013          	nop
     440:	01c12083          	lw	ra,28(sp)
     444:	02010113          	addi	sp,sp,32
     448:	00008067          	ret

0000044c <ulSyscallTrap>:
     44c:	fd010113          	addi	sp,sp,-48
     450:	02112623          	sw	ra,44(sp)
     454:	00a12623          	sw	a0,12(sp)
     458:	00b12423          	sw	a1,8(sp)
     45c:	00c12223          	sw	a2,4(sp)
     460:	00012e23          	sw	zero,28(sp)
     464:	00c12703          	lw	a4,12(sp)
     468:	00b00793          	li	a5,11
     46c:	00f70863          	beq	a4,a5,47c <ulSyscallTrap+0x30>
     470:	00c12503          	lw	a0,12(sp)
     474:	e95ff0ef          	jal	ra,308 <prvSyscallExit>
     478:	0780006f          	j	4f0 <ulSyscallTrap+0xa4>
     47c:	00412783          	lw	a5,4(sp)
     480:	04478793          	addi	a5,a5,68
     484:	0007a703          	lw	a4,0(a5)
     488:	05d00793          	li	a5,93
     48c:	00f71e63          	bne	a4,a5,4a8 <ulSyscallTrap+0x5c>
     490:	00412783          	lw	a5,4(sp)
     494:	02878793          	addi	a5,a5,40
     498:	0007a783          	lw	a5,0(a5)
     49c:	00078513          	mv	a0,a5
     4a0:	e69ff0ef          	jal	ra,308 <prvSyscallExit>
     4a4:	04c0006f          	j	4f0 <ulSyscallTrap+0xa4>
     4a8:	00412783          	lw	a5,4(sp)
     4ac:	04478793          	addi	a5,a5,68
     4b0:	0007a703          	lw	a4,0(a5)
     4b4:	00412783          	lw	a5,4(sp)
     4b8:	02878793          	addi	a5,a5,40
     4bc:	0007a583          	lw	a1,0(a5)
     4c0:	00412783          	lw	a5,4(sp)
     4c4:	02c78793          	addi	a5,a5,44
     4c8:	0007a603          	lw	a2,0(a5)
     4cc:	00412783          	lw	a5,4(sp)
     4d0:	03078793          	addi	a5,a5,48
     4d4:	0007a783          	lw	a5,0(a5)
     4d8:	00078693          	mv	a3,a5
     4dc:	00070513          	mv	a0,a4
     4e0:	d51ff0ef          	jal	ra,230 <prvSyscallToHost>
     4e4:	00050793          	mv	a5,a0
     4e8:	00058813          	mv	a6,a1
     4ec:	00f12e23          	sw	a5,28(sp)
     4f0:	00412783          	lw	a5,4(sp)
     4f4:	02878793          	addi	a5,a5,40
     4f8:	01c12703          	lw	a4,28(sp)
     4fc:	00e7a023          	sw	a4,0(a5)
     500:	00812783          	lw	a5,8(sp)
     504:	00478793          	addi	a5,a5,4
     508:	00078513          	mv	a0,a5
     50c:	02c12083          	lw	ra,44(sp)
     510:	03010113          	addi	sp,sp,48
     514:	00008067          	ret

00000518 <putchar>:
     518:	fe010113          	addi	sp,sp,-32
     51c:	00112e23          	sw	ra,28(sp)
     520:	00a12623          	sw	a0,12(sp)
     524:	00020797          	auipc	a5,0x20
     528:	e5c78793          	addi	a5,a5,-420 # 20380 <__bss_start>
     52c:	0007a783          	lw	a5,0(a5)
     530:	00178693          	addi	a3,a5,1
     534:	00020717          	auipc	a4,0x20
     538:	e4c70713          	addi	a4,a4,-436 # 20380 <__bss_start>
     53c:	00d72023          	sw	a3,0(a4)
     540:	00c12703          	lw	a4,12(sp)
     544:	0ff77713          	andi	a4,a4,255
     548:	00020697          	auipc	a3,0x20
     54c:	e7868693          	addi	a3,a3,-392 # 203c0 <buf.2126>
     550:	00f687b3          	add	a5,a3,a5
     554:	00e78023          	sb	a4,0(a5)
     558:	00c12703          	lw	a4,12(sp)
     55c:	00a00793          	li	a5,10
     560:	00f70c63          	beq	a4,a5,578 <putchar+0x60>
     564:	00020797          	auipc	a5,0x20
     568:	e1c78793          	addi	a5,a5,-484 # 20380 <__bss_start>
     56c:	0007a703          	lw	a4,0(a5)
     570:	04000793          	li	a5,64
     574:	02f71c63          	bne	a4,a5,5ac <putchar+0x94>
     578:	00020717          	auipc	a4,0x20
     57c:	e4870713          	addi	a4,a4,-440 # 203c0 <buf.2126>
     580:	00020797          	auipc	a5,0x20
     584:	e0078793          	addi	a5,a5,-512 # 20380 <__bss_start>
     588:	0007a783          	lw	a5,0(a5)
     58c:	00078693          	mv	a3,a5
     590:	00070613          	mv	a2,a4
     594:	00100593          	li	a1,1
     598:	04000513          	li	a0,64
     59c:	e19ff0ef          	jal	ra,3b4 <syscall>
     5a0:	00020797          	auipc	a5,0x20
     5a4:	de078793          	addi	a5,a5,-544 # 20380 <__bss_start>
     5a8:	0007a023          	sw	zero,0(a5)
     5ac:	00000793          	li	a5,0
     5b0:	00078513          	mv	a0,a5
     5b4:	01c12083          	lw	ra,28(sp)
     5b8:	02010113          	addi	sp,sp,32
     5bc:	00008067          	ret

000005c0 <printnum>:
     5c0:	eb010113          	addi	sp,sp,-336
     5c4:	14112623          	sw	ra,332(sp)
     5c8:	14812423          	sw	s0,328(sp)
     5cc:	14912223          	sw	s1,324(sp)
     5d0:	15212023          	sw	s2,320(sp)
     5d4:	13312e23          	sw	s3,316(sp)
     5d8:	13412c23          	sw	s4,312(sp)
     5dc:	13512a23          	sw	s5,308(sp)
     5e0:	00a12e23          	sw	a0,28(sp)
     5e4:	00b12c23          	sw	a1,24(sp)
     5e8:	00c12823          	sw	a2,16(sp)
     5ec:	00d12a23          	sw	a3,20(sp)
     5f0:	00e12623          	sw	a4,12(sp)
     5f4:	00f12423          	sw	a5,8(sp)
     5f8:	01012223          	sw	a6,4(sp)
     5fc:	12012623          	sw	zero,300(sp)
     600:	00c12783          	lw	a5,12(sp)
     604:	00078a13          	mv	s4,a5
     608:	00000a93          	li	s5,0
     60c:	01012783          	lw	a5,16(sp)
     610:	01412803          	lw	a6,20(sp)
     614:	000a0613          	mv	a2,s4
     618:	000a8693          	mv	a3,s5
     61c:	00078513          	mv	a0,a5
     620:	00080593          	mv	a1,a6
     624:	010010ef          	jal	ra,1634 <__umoddi3>
     628:	00050793          	mv	a5,a0
     62c:	00058813          	mv	a6,a1
     630:	00078613          	mv	a2,a5
     634:	00080693          	mv	a3,a6
     638:	12c12783          	lw	a5,300(sp)
     63c:	00178713          	addi	a4,a5,1
     640:	12e12623          	sw	a4,300(sp)
     644:	00060713          	mv	a4,a2
     648:	00279793          	slli	a5,a5,0x2
     64c:	13010693          	addi	a3,sp,304
     650:	00f687b3          	add	a5,a3,a5
     654:	eee7ae23          	sw	a4,-260(a5)
     658:	00c12783          	lw	a5,12(sp)
     65c:	00078413          	mv	s0,a5
     660:	00000493          	li	s1,0
     664:	01412783          	lw	a5,20(sp)
     668:	00048713          	mv	a4,s1
     66c:	04e7e863          	bltu	a5,a4,6bc <printnum+0xfc>
     670:	01412783          	lw	a5,20(sp)
     674:	00048713          	mv	a4,s1
     678:	00e79863          	bne	a5,a4,688 <printnum+0xc8>
     67c:	01012783          	lw	a5,16(sp)
     680:	00040713          	mv	a4,s0
     684:	02e7ec63          	bltu	a5,a4,6bc <printnum+0xfc>
     688:	00c12783          	lw	a5,12(sp)
     68c:	00078913          	mv	s2,a5
     690:	00000993          	li	s3,0
     694:	00090613          	mv	a2,s2
     698:	00098693          	mv	a3,s3
     69c:	01012503          	lw	a0,16(sp)
     6a0:	01412583          	lw	a1,20(sp)
     6a4:	1b5000ef          	jal	ra,1058 <__udivdi3>
     6a8:	00050793          	mv	a5,a0
     6ac:	00058813          	mv	a6,a1
     6b0:	00f12823          	sw	a5,16(sp)
     6b4:	01012a23          	sw	a6,20(sp)
     6b8:	f49ff06f          	j	600 <printnum+0x40>
     6bc:	00000013          	nop
     6c0:	0140006f          	j	6d4 <printnum+0x114>
     6c4:	01c12783          	lw	a5,28(sp)
     6c8:	01812583          	lw	a1,24(sp)
     6cc:	00412503          	lw	a0,4(sp)
     6d0:	000780e7          	jalr	a5
     6d4:	00812783          	lw	a5,8(sp)
     6d8:	fff78713          	addi	a4,a5,-1
     6dc:	00e12423          	sw	a4,8(sp)
     6e0:	12c12703          	lw	a4,300(sp)
     6e4:	fef740e3          	blt	a4,a5,6c4 <printnum+0x104>
     6e8:	0540006f          	j	73c <printnum+0x17c>
     6ec:	12c12783          	lw	a5,300(sp)
     6f0:	00279793          	slli	a5,a5,0x2
     6f4:	13010713          	addi	a4,sp,304
     6f8:	00f707b3          	add	a5,a4,a5
     6fc:	efc7a703          	lw	a4,-260(a5)
     700:	12c12783          	lw	a5,300(sp)
     704:	00279793          	slli	a5,a5,0x2
     708:	13010693          	addi	a3,sp,304
     70c:	00f687b3          	add	a5,a3,a5
     710:	efc7a683          	lw	a3,-260(a5)
     714:	00900793          	li	a5,9
     718:	00d7f663          	bleu	a3,a5,724 <printnum+0x164>
     71c:	05700793          	li	a5,87
     720:	0080006f          	j	728 <printnum+0x168>
     724:	03000793          	li	a5,48
     728:	00e787b3          	add	a5,a5,a4
     72c:	01c12703          	lw	a4,28(sp)
     730:	01812583          	lw	a1,24(sp)
     734:	00078513          	mv	a0,a5
     738:	000700e7          	jalr	a4
     73c:	12c12783          	lw	a5,300(sp)
     740:	fff78713          	addi	a4,a5,-1
     744:	12e12623          	sw	a4,300(sp)
     748:	faf042e3          	bgtz	a5,6ec <printnum+0x12c>
     74c:	00000013          	nop
     750:	14c12083          	lw	ra,332(sp)
     754:	14812403          	lw	s0,328(sp)
     758:	14412483          	lw	s1,324(sp)
     75c:	14012903          	lw	s2,320(sp)
     760:	13c12983          	lw	s3,316(sp)
     764:	13812a03          	lw	s4,312(sp)
     768:	13412a83          	lw	s5,308(sp)
     76c:	15010113          	addi	sp,sp,336
     770:	00008067          	ret

00000774 <getuint>:
     774:	ff010113          	addi	sp,sp,-16
     778:	00a12623          	sw	a0,12(sp)
     77c:	00b12423          	sw	a1,8(sp)
     780:	00812683          	lw	a3,8(sp)
     784:	00100713          	li	a4,1
     788:	02d75663          	ble	a3,a4,7b4 <getuint+0x40>
     78c:	00c12783          	lw	a5,12(sp)
     790:	0007a783          	lw	a5,0(a5)
     794:	00778793          	addi	a5,a5,7
     798:	ff87f793          	andi	a5,a5,-8
     79c:	00878693          	addi	a3,a5,8
     7a0:	00c12703          	lw	a4,12(sp)
     7a4:	00d72023          	sw	a3,0(a4)
     7a8:	0047a803          	lw	a6,4(a5)
     7ac:	0007a783          	lw	a5,0(a5)
     7b0:	0500006f          	j	800 <getuint+0x8c>
     7b4:	00812703          	lw	a4,8(sp)
     7b8:	02070463          	beqz	a4,7e0 <getuint+0x6c>
     7bc:	00c12703          	lw	a4,12(sp)
     7c0:	00072703          	lw	a4,0(a4)
     7c4:	00470613          	addi	a2,a4,4
     7c8:	00c12683          	lw	a3,12(sp)
     7cc:	00c6a023          	sw	a2,0(a3)
     7d0:	00072703          	lw	a4,0(a4)
     7d4:	00070793          	mv	a5,a4
     7d8:	00000813          	li	a6,0
     7dc:	0240006f          	j	800 <getuint+0x8c>
     7e0:	00c12703          	lw	a4,12(sp)
     7e4:	00072703          	lw	a4,0(a4)
     7e8:	00470613          	addi	a2,a4,4
     7ec:	00c12683          	lw	a3,12(sp)
     7f0:	00c6a023          	sw	a2,0(a3)
     7f4:	00072703          	lw	a4,0(a4)
     7f8:	00070793          	mv	a5,a4
     7fc:	00000813          	li	a6,0
     800:	00078513          	mv	a0,a5
     804:	00080593          	mv	a1,a6
     808:	01010113          	addi	sp,sp,16
     80c:	00008067          	ret

00000810 <getint>:
     810:	ff010113          	addi	sp,sp,-16
     814:	00a12623          	sw	a0,12(sp)
     818:	00b12423          	sw	a1,8(sp)
     81c:	00812683          	lw	a3,8(sp)
     820:	00100713          	li	a4,1
     824:	02d75663          	ble	a3,a4,850 <getint+0x40>
     828:	00c12783          	lw	a5,12(sp)
     82c:	0007a783          	lw	a5,0(a5)
     830:	00778793          	addi	a5,a5,7
     834:	ff87f793          	andi	a5,a5,-8
     838:	00878693          	addi	a3,a5,8
     83c:	00c12703          	lw	a4,12(sp)
     840:	00d72023          	sw	a3,0(a4)
     844:	0047a803          	lw	a6,4(a5)
     848:	0007a783          	lw	a5,0(a5)
     84c:	0580006f          	j	8a4 <getint+0x94>
     850:	00812703          	lw	a4,8(sp)
     854:	02070663          	beqz	a4,880 <getint+0x70>
     858:	00c12703          	lw	a4,12(sp)
     85c:	00072703          	lw	a4,0(a4)
     860:	00470613          	addi	a2,a4,4
     864:	00c12683          	lw	a3,12(sp)
     868:	00c6a023          	sw	a2,0(a3)
     86c:	00072703          	lw	a4,0(a4)
     870:	00070793          	mv	a5,a4
     874:	41f75713          	srai	a4,a4,0x1f
     878:	00070813          	mv	a6,a4
     87c:	0280006f          	j	8a4 <getint+0x94>
     880:	00c12703          	lw	a4,12(sp)
     884:	00072703          	lw	a4,0(a4)
     888:	00470613          	addi	a2,a4,4
     88c:	00c12683          	lw	a3,12(sp)
     890:	00c6a023          	sw	a2,0(a3)
     894:	00072703          	lw	a4,0(a4)
     898:	00070793          	mv	a5,a4
     89c:	41f75713          	srai	a4,a4,0x1f
     8a0:	00070813          	mv	a6,a4
     8a4:	00078513          	mv	a0,a5
     8a8:	00080593          	mv	a1,a6
     8ac:	01010113          	addi	sp,sp,16
     8b0:	00008067          	ret

000008b4 <vFormatPrintString>:
     8b4:	fc010113          	addi	sp,sp,-64
     8b8:	02112e23          	sw	ra,60(sp)
     8bc:	02812c23          	sw	s0,56(sp)
     8c0:	02912a23          	sw	s1,52(sp)
     8c4:	00a12623          	sw	a0,12(sp)
     8c8:	00b12423          	sw	a1,8(sp)
     8cc:	00c12223          	sw	a2,4(sp)
     8d0:	00d12023          	sw	a3,0(sp)
     8d4:	0240006f          	j	8f8 <vFormatPrintString+0x44>
     8d8:	3c040063          	beqz	s0,c98 <vFormatPrintString+0x3e4>
     8dc:	00412783          	lw	a5,4(sp)
     8e0:	00178793          	addi	a5,a5,1
     8e4:	00f12223          	sw	a5,4(sp)
     8e8:	00c12783          	lw	a5,12(sp)
     8ec:	00812583          	lw	a1,8(sp)
     8f0:	00040513          	mv	a0,s0
     8f4:	000780e7          	jalr	a5
     8f8:	00412783          	lw	a5,4(sp)
     8fc:	0007c783          	lbu	a5,0(a5)
     900:	00078413          	mv	s0,a5
     904:	02500793          	li	a5,37
     908:	fcf418e3          	bne	s0,a5,8d8 <vFormatPrintString+0x24>
     90c:	00412783          	lw	a5,4(sp)
     910:	00178793          	addi	a5,a5,1
     914:	00f12223          	sw	a5,4(sp)
     918:	00412783          	lw	a5,4(sp)
     91c:	00f12823          	sw	a5,16(sp)
     920:	02000793          	li	a5,32
     924:	00f10ba3          	sb	a5,23(sp)
     928:	fff00793          	li	a5,-1
     92c:	00f12e23          	sw	a5,28(sp)
     930:	fff00793          	li	a5,-1
     934:	00f12c23          	sw	a5,24(sp)
     938:	02012023          	sw	zero,32(sp)
     93c:	00412783          	lw	a5,4(sp)
     940:	00178713          	addi	a4,a5,1
     944:	00e12223          	sw	a4,4(sp)
     948:	0007c783          	lbu	a5,0(a5)
     94c:	00078413          	mv	s0,a5
     950:	fdd40793          	addi	a5,s0,-35
     954:	05500713          	li	a4,85
     958:	32f76063          	bltu	a4,a5,c78 <vFormatPrintString+0x3c4>
     95c:	00279713          	slli	a4,a5,0x2
     960:	0001f797          	auipc	a5,0x1f
     964:	6c478793          	addi	a5,a5,1732 # 20024 <__rodata_start+0x24>
     968:	00f707b3          	add	a5,a4,a5
     96c:	0007a703          	lw	a4,0(a5)
     970:	0001f797          	auipc	a5,0x1f
     974:	6b478793          	addi	a5,a5,1716 # 20024 <__rodata_start+0x24>
     978:	00f707b3          	add	a5,a4,a5
     97c:	00078067          	jr	a5
     980:	02d00793          	li	a5,45
     984:	00f10ba3          	sb	a5,23(sp)
     988:	fb5ff06f          	j	93c <vFormatPrintString+0x88>
     98c:	03000793          	li	a5,48
     990:	00f10ba3          	sb	a5,23(sp)
     994:	fa9ff06f          	j	93c <vFormatPrintString+0x88>
     998:	00012c23          	sw	zero,24(sp)
     99c:	01812703          	lw	a4,24(sp)
     9a0:	00070793          	mv	a5,a4
     9a4:	00279793          	slli	a5,a5,0x2
     9a8:	00e787b3          	add	a5,a5,a4
     9ac:	00179793          	slli	a5,a5,0x1
     9b0:	00f407b3          	add	a5,s0,a5
     9b4:	fd078793          	addi	a5,a5,-48
     9b8:	00f12c23          	sw	a5,24(sp)
     9bc:	00412783          	lw	a5,4(sp)
     9c0:	0007c783          	lbu	a5,0(a5)
     9c4:	00078413          	mv	s0,a5
     9c8:	02f00793          	li	a5,47
     9cc:	0487d263          	ble	s0,a5,a10 <vFormatPrintString+0x15c>
     9d0:	03900793          	li	a5,57
     9d4:	0287ce63          	blt	a5,s0,a10 <vFormatPrintString+0x15c>
     9d8:	00412783          	lw	a5,4(sp)
     9dc:	00178793          	addi	a5,a5,1
     9e0:	00f12223          	sw	a5,4(sp)
     9e4:	fb9ff06f          	j	99c <vFormatPrintString+0xe8>
     9e8:	00012783          	lw	a5,0(sp)
     9ec:	00478713          	addi	a4,a5,4
     9f0:	00e12023          	sw	a4,0(sp)
     9f4:	0007a783          	lw	a5,0(a5)
     9f8:	00f12c23          	sw	a5,24(sp)
     9fc:	0180006f          	j	a14 <vFormatPrintString+0x160>
     a00:	01c12783          	lw	a5,28(sp)
     a04:	f207dce3          	bgez	a5,93c <vFormatPrintString+0x88>
     a08:	00012e23          	sw	zero,28(sp)
     a0c:	f31ff06f          	j	93c <vFormatPrintString+0x88>
     a10:	00000013          	nop
     a14:	01c12783          	lw	a5,28(sp)
     a18:	f207d2e3          	bgez	a5,93c <vFormatPrintString+0x88>
     a1c:	01812783          	lw	a5,24(sp)
     a20:	00f12e23          	sw	a5,28(sp)
     a24:	fff00793          	li	a5,-1
     a28:	00f12c23          	sw	a5,24(sp)
     a2c:	f11ff06f          	j	93c <vFormatPrintString+0x88>
     a30:	02012783          	lw	a5,32(sp)
     a34:	00178793          	addi	a5,a5,1
     a38:	02f12023          	sw	a5,32(sp)
     a3c:	f01ff06f          	j	93c <vFormatPrintString+0x88>
     a40:	00012783          	lw	a5,0(sp)
     a44:	00478713          	addi	a4,a5,4
     a48:	00e12023          	sw	a4,0(sp)
     a4c:	0007a783          	lw	a5,0(a5)
     a50:	00c12703          	lw	a4,12(sp)
     a54:	00812583          	lw	a1,8(sp)
     a58:	00078513          	mv	a0,a5
     a5c:	000700e7          	jalr	a4
     a60:	2340006f          	j	c94 <vFormatPrintString+0x3e0>
     a64:	00012783          	lw	a5,0(sp)
     a68:	00478713          	addi	a4,a5,4
     a6c:	00e12023          	sw	a4,0(sp)
     a70:	0007a483          	lw	s1,0(a5)
     a74:	00049663          	bnez	s1,a80 <vFormatPrintString+0x1cc>
     a78:	0001f497          	auipc	s1,0x1f
     a7c:	5a448493          	addi	s1,s1,1444 # 2001c <__rodata_start+0x1c>
     a80:	01c12783          	lw	a5,28(sp)
     a84:	08f05063          	blez	a5,b04 <vFormatPrintString+0x250>
     a88:	01714703          	lbu	a4,23(sp)
     a8c:	02d00793          	li	a5,45
     a90:	06f70a63          	beq	a4,a5,b04 <vFormatPrintString+0x250>
     a94:	01812783          	lw	a5,24(sp)
     a98:	00078593          	mv	a1,a5
     a9c:	00048513          	mv	a0,s1
     aa0:	594000ef          	jal	ra,1034 <strnlen>
     aa4:	00050713          	mv	a4,a0
     aa8:	01c12783          	lw	a5,28(sp)
     aac:	40e787b3          	sub	a5,a5,a4
     ab0:	00f12e23          	sw	a5,28(sp)
     ab4:	0240006f          	j	ad8 <vFormatPrintString+0x224>
     ab8:	01714783          	lbu	a5,23(sp)
     abc:	00c12703          	lw	a4,12(sp)
     ac0:	00812583          	lw	a1,8(sp)
     ac4:	00078513          	mv	a0,a5
     ac8:	000700e7          	jalr	a4
     acc:	01c12783          	lw	a5,28(sp)
     ad0:	fff78793          	addi	a5,a5,-1
     ad4:	00f12e23          	sw	a5,28(sp)
     ad8:	01c12783          	lw	a5,28(sp)
     adc:	fcf04ee3          	bgtz	a5,ab8 <vFormatPrintString+0x204>
     ae0:	0240006f          	j	b04 <vFormatPrintString+0x250>
     ae4:	00c12783          	lw	a5,12(sp)
     ae8:	00812583          	lw	a1,8(sp)
     aec:	00040513          	mv	a0,s0
     af0:	000780e7          	jalr	a5
     af4:	00148493          	addi	s1,s1,1
     af8:	01c12783          	lw	a5,28(sp)
     afc:	fff78793          	addi	a5,a5,-1
     b00:	00f12e23          	sw	a5,28(sp)
     b04:	0004c783          	lbu	a5,0(s1)
     b08:	00078413          	mv	s0,a5
     b0c:	04040063          	beqz	s0,b4c <vFormatPrintString+0x298>
     b10:	01812783          	lw	a5,24(sp)
     b14:	fc07c8e3          	bltz	a5,ae4 <vFormatPrintString+0x230>
     b18:	01812783          	lw	a5,24(sp)
     b1c:	fff78793          	addi	a5,a5,-1
     b20:	00f12c23          	sw	a5,24(sp)
     b24:	01812783          	lw	a5,24(sp)
     b28:	fa07dee3          	bgez	a5,ae4 <vFormatPrintString+0x230>
     b2c:	0200006f          	j	b4c <vFormatPrintString+0x298>
     b30:	00c12783          	lw	a5,12(sp)
     b34:	00812583          	lw	a1,8(sp)
     b38:	02000513          	li	a0,32
     b3c:	000780e7          	jalr	a5
     b40:	01c12783          	lw	a5,28(sp)
     b44:	fff78793          	addi	a5,a5,-1
     b48:	00f12e23          	sw	a5,28(sp)
     b4c:	01c12783          	lw	a5,28(sp)
     b50:	fef040e3          	bgtz	a5,b30 <vFormatPrintString+0x27c>
     b54:	1400006f          	j	c94 <vFormatPrintString+0x3e0>
     b58:	00010793          	mv	a5,sp
     b5c:	02012583          	lw	a1,32(sp)
     b60:	00078513          	mv	a0,a5
     b64:	cadff0ef          	jal	ra,810 <getint>
     b68:	00050793          	mv	a5,a0
     b6c:	00058813          	mv	a6,a1
     b70:	02f12423          	sw	a5,40(sp)
     b74:	03012623          	sw	a6,44(sp)
     b78:	02812783          	lw	a5,40(sp)
     b7c:	02c12803          	lw	a6,44(sp)
     b80:	00080793          	mv	a5,a6
     b84:	0407d663          	bgez	a5,bd0 <vFormatPrintString+0x31c>
     b88:	00c12783          	lw	a5,12(sp)
     b8c:	00812583          	lw	a1,8(sp)
     b90:	02d00513          	li	a0,45
     b94:	000780e7          	jalr	a5
     b98:	02812583          	lw	a1,40(sp)
     b9c:	02c12603          	lw	a2,44(sp)
     ba0:	00000793          	li	a5,0
     ba4:	00000813          	li	a6,0
     ba8:	40b786b3          	sub	a3,a5,a1
     bac:	00068513          	mv	a0,a3
     bb0:	00a7b533          	sltu	a0,a5,a0
     bb4:	40c80733          	sub	a4,a6,a2
     bb8:	40a707b3          	sub	a5,a4,a0
     bbc:	00078713          	mv	a4,a5
     bc0:	00068793          	mv	a5,a3
     bc4:	00070813          	mv	a6,a4
     bc8:	02f12423          	sw	a5,40(sp)
     bcc:	03012623          	sw	a6,44(sp)
     bd0:	00a00793          	li	a5,10
     bd4:	02f12223          	sw	a5,36(sp)
     bd8:	0640006f          	j	c3c <vFormatPrintString+0x388>
     bdc:	00a00793          	li	a5,10
     be0:	02f12223          	sw	a5,36(sp)
     be4:	0400006f          	j	c24 <vFormatPrintString+0x370>
     be8:	00800793          	li	a5,8
     bec:	02f12223          	sw	a5,36(sp)
     bf0:	0340006f          	j	c24 <vFormatPrintString+0x370>
     bf4:	00100793          	li	a5,1
     bf8:	02f12023          	sw	a5,32(sp)
     bfc:	00c12783          	lw	a5,12(sp)
     c00:	00812583          	lw	a1,8(sp)
     c04:	03000513          	li	a0,48
     c08:	000780e7          	jalr	a5
     c0c:	00c12783          	lw	a5,12(sp)
     c10:	00812583          	lw	a1,8(sp)
     c14:	07800513          	li	a0,120
     c18:	000780e7          	jalr	a5
     c1c:	01000793          	li	a5,16
     c20:	02f12223          	sw	a5,36(sp)
     c24:	00010793          	mv	a5,sp
     c28:	02012583          	lw	a1,32(sp)
     c2c:	00078513          	mv	a0,a5
     c30:	b45ff0ef          	jal	ra,774 <getuint>
     c34:	02a12423          	sw	a0,40(sp)
     c38:	02b12623          	sw	a1,44(sp)
     c3c:	02412703          	lw	a4,36(sp)
     c40:	01714783          	lbu	a5,23(sp)
     c44:	00078813          	mv	a6,a5
     c48:	01c12783          	lw	a5,28(sp)
     c4c:	02812603          	lw	a2,40(sp)
     c50:	02c12683          	lw	a3,44(sp)
     c54:	00812583          	lw	a1,8(sp)
     c58:	00c12503          	lw	a0,12(sp)
     c5c:	965ff0ef          	jal	ra,5c0 <printnum>
     c60:	0340006f          	j	c94 <vFormatPrintString+0x3e0>
     c64:	00c12783          	lw	a5,12(sp)
     c68:	00812583          	lw	a1,8(sp)
     c6c:	00040513          	mv	a0,s0
     c70:	000780e7          	jalr	a5
     c74:	0200006f          	j	c94 <vFormatPrintString+0x3e0>
     c78:	00c12783          	lw	a5,12(sp)
     c7c:	00812583          	lw	a1,8(sp)
     c80:	02500513          	li	a0,37
     c84:	000780e7          	jalr	a5
     c88:	01012783          	lw	a5,16(sp)
     c8c:	00f12223          	sw	a5,4(sp)
     c90:	00000013          	nop
     c94:	c65ff06f          	j	8f8 <vFormatPrintString+0x44>
     c98:	00000013          	nop
     c9c:	03c12083          	lw	ra,60(sp)
     ca0:	03812403          	lw	s0,56(sp)
     ca4:	03412483          	lw	s1,52(sp)
     ca8:	04010113          	addi	sp,sp,64
     cac:	00008067          	ret

00000cb0 <exit>:
     cb0:	fe010113          	addi	sp,sp,-32
     cb4:	00112e23          	sw	ra,28(sp)
     cb8:	00a12623          	sw	a0,12(sp)
     cbc:	00000693          	li	a3,0
     cc0:	00000613          	li	a2,0
     cc4:	00c12583          	lw	a1,12(sp)
     cc8:	05d00513          	li	a0,93
     ccc:	ee8ff0ef          	jal	ra,3b4 <syscall>
     cd0:	0000006f          	j	cd0 <exit+0x20>

00000cd4 <printf>:
     cd4:	fb010113          	addi	sp,sp,-80
     cd8:	02112623          	sw	ra,44(sp)
     cdc:	00a12623          	sw	a0,12(sp)
     ce0:	02b12a23          	sw	a1,52(sp)
     ce4:	02c12c23          	sw	a2,56(sp)
     ce8:	02d12e23          	sw	a3,60(sp)
     cec:	04e12023          	sw	a4,64(sp)
     cf0:	04f12223          	sw	a5,68(sp)
     cf4:	05012423          	sw	a6,72(sp)
     cf8:	05112623          	sw	a7,76(sp)
     cfc:	05010793          	addi	a5,sp,80
     d00:	fe478793          	addi	a5,a5,-28
     d04:	00f12e23          	sw	a5,28(sp)
     d08:	01c12783          	lw	a5,28(sp)
     d0c:	00078693          	mv	a3,a5
     d10:	00c12603          	lw	a2,12(sp)
     d14:	00000593          	li	a1,0
     d18:	00000517          	auipc	a0,0x0
     d1c:	80050513          	addi	a0,a0,-2048 # 518 <putchar>
     d20:	b95ff0ef          	jal	ra,8b4 <vFormatPrintString>
     d24:	00000793          	li	a5,0
     d28:	00078513          	mv	a0,a5
     d2c:	02c12083          	lw	ra,44(sp)
     d30:	05010113          	addi	sp,sp,80
     d34:	00008067          	ret

00000d38 <sprintf_putch.2235>:
     d38:	fe010113          	addi	sp,sp,-32
     d3c:	00a12623          	sw	a0,12(sp)
     d40:	00b12423          	sw	a1,8(sp)
     d44:	00712223          	sw	t2,4(sp)
     d48:	00812783          	lw	a5,8(sp)
     d4c:	00f12e23          	sw	a5,28(sp)
     d50:	01c12783          	lw	a5,28(sp)
     d54:	0007a783          	lw	a5,0(a5)
     d58:	00c12703          	lw	a4,12(sp)
     d5c:	0ff77713          	andi	a4,a4,255
     d60:	00e78023          	sb	a4,0(a5)
     d64:	01c12783          	lw	a5,28(sp)
     d68:	0007a783          	lw	a5,0(a5)
     d6c:	00178713          	addi	a4,a5,1
     d70:	01c12783          	lw	a5,28(sp)
     d74:	00e7a023          	sw	a4,0(a5)
     d78:	00000013          	nop
     d7c:	02010113          	addi	sp,sp,32
     d80:	00008067          	ret

00000d84 <sprintf>:
     d84:	fa010113          	addi	sp,sp,-96
     d88:	02112e23          	sw	ra,60(sp)
     d8c:	00a12623          	sw	a0,12(sp)
     d90:	00b12423          	sw	a1,8(sp)
     d94:	04c12423          	sw	a2,72(sp)
     d98:	04d12623          	sw	a3,76(sp)
     d9c:	04e12823          	sw	a4,80(sp)
     da0:	04f12a23          	sw	a5,84(sp)
     da4:	05012c23          	sw	a6,88(sp)
     da8:	05112e23          	sw	a7,92(sp)
     dac:	06010793          	addi	a5,sp,96
     db0:	02f12223          	sw	a5,36(sp)
     db4:	01410793          	addi	a5,sp,20
     db8:	01410593          	addi	a1,sp,20
     dbc:	00000617          	auipc	a2,0x0
     dc0:	f7c60613          	addi	a2,a2,-132 # d38 <sprintf_putch.2235>
     dc4:	fffff737          	lui	a4,0xfffff
     dc8:	fff74693          	not	a3,a4
     dcc:	00001537          	lui	a0,0x1
     dd0:	80050513          	addi	a0,a0,-2048 # 800 <getuint+0x8c>
     dd4:	00a58833          	add	a6,a1,a0
     dd8:	00e87833          	and	a6,a6,a4
     ddc:	3b786813          	ori	a6,a6,951
     de0:	0107a023          	sw	a6,0(a5)
     de4:	00a60533          	add	a0,a2,a0
     de8:	00e57733          	and	a4,a0,a4
     dec:	33776713          	ori	a4,a4,823
     df0:	00e7a223          	sw	a4,4(a5)
     df4:	00d5f733          	and	a4,a1,a3
     df8:	01471593          	slli	a1,a4,0x14
     dfc:	00038737          	lui	a4,0x38
     e00:	39370713          	addi	a4,a4,915 # 38393 <__stack+0x15f0b>
     e04:	00e5e733          	or	a4,a1,a4
     e08:	00e7a423          	sw	a4,8(a5)
     e0c:	00d67733          	and	a4,a2,a3
     e10:	01471693          	slli	a3,a4,0x14
     e14:	00030737          	lui	a4,0x30
     e18:	06770713          	addi	a4,a4,103 # 30067 <__stack+0xdbdf>
     e1c:	00e6e733          	or	a4,a3,a4
     e20:	00e7a623          	sw	a4,12(a5)
     e24:	0000100f          	fence.i
     e28:	00c12783          	lw	a5,12(sp)
     e2c:	02f12623          	sw	a5,44(sp)
     e30:	06010793          	addi	a5,sp,96
     e34:	fe878793          	addi	a5,a5,-24
     e38:	02f12423          	sw	a5,40(sp)
     e3c:	02812703          	lw	a4,40(sp)
     e40:	01410793          	addi	a5,sp,20
     e44:	00078513          	mv	a0,a5
     e48:	00c10793          	addi	a5,sp,12
     e4c:	00070693          	mv	a3,a4
     e50:	00812603          	lw	a2,8(sp)
     e54:	00078593          	mv	a1,a5
     e58:	a5dff0ef          	jal	ra,8b4 <vFormatPrintString>
     e5c:	00c12783          	lw	a5,12(sp)
     e60:	00078023          	sb	zero,0(a5)
     e64:	00c12783          	lw	a5,12(sp)
     e68:	00078713          	mv	a4,a5
     e6c:	02c12783          	lw	a5,44(sp)
     e70:	40f707b3          	sub	a5,a4,a5
     e74:	00078513          	mv	a0,a5
     e78:	03c12083          	lw	ra,60(sp)
     e7c:	06010113          	addi	sp,sp,96
     e80:	00008067          	ret

00000e84 <level_1_interrupt_handler>:
     e84:	fe010113          	addi	sp,sp,-32
     e88:	00112e23          	sw	ra,28(sp)
     e8c:	00a12623          	sw	a0,12(sp)
     e90:	00c12783          	lw	a5,12(sp)
     e94:	00f7f713          	andi	a4,a5,15
     e98:	00700793          	li	a5,7
     e9c:	04f71463          	bne	a4,a5,ee4 <level_1_interrupt_handler+0x60>
     ea0:	0001f797          	auipc	a5,0x1f
     ea4:	56078793          	addi	a5,a5,1376 # 20400 <timer_irq_handler>
     ea8:	0007a783          	lw	a5,0(a5)
     eac:	00078c63          	beqz	a5,ec4 <level_1_interrupt_handler+0x40>
     eb0:	0001f797          	auipc	a5,0x1f
     eb4:	55078793          	addi	a5,a5,1360 # 20400 <timer_irq_handler>
     eb8:	0007a783          	lw	a5,0(a5)
     ebc:	000780e7          	jalr	a5
     ec0:	0240006f          	j	ee4 <level_1_interrupt_handler+0x60>
     ec4:	0001f797          	auipc	a5,0x1f
     ec8:	49078793          	addi	a5,a5,1168 # 20354 <mtimecmp>
     ecc:	0007a783          	lw	a5,0(a5)
     ed0:	00000693          	li	a3,0
     ed4:	00000713          	li	a4,0
     ed8:	00d7a023          	sw	a3,0(a5)
     edc:	00e7a223          	sw	a4,4(a5)
     ee0:	00000013          	nop
     ee4:	01c12083          	lw	ra,28(sp)
     ee8:	02010113          	addi	sp,sp,32
     eec:	00008067          	ret

00000ef0 <register_timer_interrupt_handler>:
     ef0:	ff010113          	addi	sp,sp,-16
     ef4:	00a12623          	sw	a0,12(sp)
     ef8:	0001f797          	auipc	a5,0x1f
     efc:	50878793          	addi	a5,a5,1288 # 20400 <timer_irq_handler>
     f00:	00c12703          	lw	a4,12(sp)
     f04:	00e7a023          	sw	a4,0(a5)
     f08:	00000013          	nop
     f0c:	01010113          	addi	sp,sp,16
     f10:	00008067          	ret

00000f14 <set_next_timer_interrupt>:
     f14:	0001f797          	auipc	a5,0x1f
     f18:	43c78793          	addi	a5,a5,1084 # 20350 <__sbss_end>
     f1c:	0007a783          	lw	a5,0(a5)
     f20:	0047a803          	lw	a6,4(a5)
     f24:	0007a783          	lw	a5,0(a5)
     f28:	0001f717          	auipc	a4,0x1f
     f2c:	42c70713          	addi	a4,a4,1068 # 20354 <mtimecmp>
     f30:	00072503          	lw	a0,0(a4)
     f34:	000f45b7          	lui	a1,0xf4
     f38:	24058593          	addi	a1,a1,576 # f4240 <__stack+0xd1db8>
     f3c:	00000613          	li	a2,0
     f40:	00b786b3          	add	a3,a5,a1
     f44:	00068893          	mv	a7,a3
     f48:	00f8b8b3          	sltu	a7,a7,a5
     f4c:	00c80733          	add	a4,a6,a2
     f50:	00e887b3          	add	a5,a7,a4
     f54:	00078713          	mv	a4,a5
     f58:	00068793          	mv	a5,a3
     f5c:	00070813          	mv	a6,a4
     f60:	00f52023          	sw	a5,0(a0)
     f64:	01052223          	sw	a6,4(a0)
     f68:	00000013          	nop
     f6c:	00008067          	ret

00000f70 <timer_irq_handler>:
     f70:	ff010113          	addi	sp,sp,-16
     f74:	00112623          	sw	ra,12(sp)
     f78:	0001f797          	auipc	a5,0x1f
     f7c:	3d078793          	addi	a5,a5,976 # 20348 <num_ticks>
     f80:	0007a783          	lw	a5,0(a5)
     f84:	00178713          	addi	a4,a5,1
     f88:	0001f797          	auipc	a5,0x1f
     f8c:	3c078793          	addi	a5,a5,960 # 20348 <num_ticks>
     f90:	00e7a023          	sw	a4,0(a5)
     f94:	f81ff0ef          	jal	ra,f14 <set_next_timer_interrupt>
     f98:	0001f797          	auipc	a5,0x1f
     f9c:	3b078793          	addi	a5,a5,944 # 20348 <num_ticks>
     fa0:	0007a783          	lw	a5,0(a5)
     fa4:	00078593          	mv	a1,a5
     fa8:	0001f517          	auipc	a0,0x1f
     fac:	1d450513          	addi	a0,a0,468 # 2017c <__rodata_start+0x17c>
     fb0:	d25ff0ef          	jal	ra,cd4 <printf>
     fb4:	00000013          	nop
     fb8:	00c12083          	lw	ra,12(sp)
     fbc:	01010113          	addi	sp,sp,16
     fc0:	00008067          	ret

00000fc4 <main>:
     fc4:	ff010113          	addi	sp,sp,-16
     fc8:	00112623          	sw	ra,12(sp)
     fcc:	00000517          	auipc	a0,0x0
     fd0:	fa450513          	addi	a0,a0,-92 # f70 <timer_irq_handler>
     fd4:	f1dff0ef          	jal	ra,ef0 <register_timer_interrupt_handler>
     fd8:	f3dff0ef          	jal	ra,f14 <set_next_timer_interrupt>
     fdc:	00000013          	nop
     fe0:	0001f797          	auipc	a5,0x1f
     fe4:	36878793          	addi	a5,a5,872 # 20348 <num_ticks>
     fe8:	0007a703          	lw	a4,0(a5)
     fec:	00400793          	li	a5,4
     ff0:	fee7f8e3          	bleu	a4,a5,fe0 <main+0x1c>
     ff4:	0001f797          	auipc	a5,0x1f
     ff8:	35478793          	addi	a5,a5,852 # 20348 <num_ticks>
     ffc:	0007a783          	lw	a5,0(a5)
    1000:	00078f93          	mv	t6,a5
    1004:	00000793          	li	a5,0
    1008:	00078513          	mv	a0,a5
    100c:	00c12083          	lw	ra,12(sp)
    1010:	01010113          	addi	sp,sp,16
    1014:	00008067          	ret

00001018 <strlen>:
    1018:	00050793          	mv	a5,a0
    101c:	00178793          	addi	a5,a5,1
    1020:	fff7c703          	lbu	a4,-1(a5)
    1024:	fe071ce3          	bnez	a4,101c <strlen+0x4>
    1028:	40a78533          	sub	a0,a5,a0
    102c:	fff50513          	addi	a0,a0,-1
    1030:	00008067          	ret

00001034 <strnlen>:
    1034:	00b505b3          	add	a1,a0,a1
    1038:	00050793          	mv	a5,a0
    103c:	00b78663          	beq	a5,a1,1048 <strnlen+0x14>
    1040:	0007c703          	lbu	a4,0(a5)
    1044:	00071663          	bnez	a4,1050 <strnlen+0x1c>
    1048:	40a78533          	sub	a0,a5,a0
    104c:	00008067          	ret
    1050:	00178793          	addi	a5,a5,1
    1054:	fe9ff06f          	j	103c <strnlen+0x8>

00001058 <__udivdi3>:
#endif

#ifdef L_udivdi3
UDWtype
__udivdi3 (UDWtype n, UDWtype d)
{
    1058:	fd010113          	addi	sp,sp,-48
    105c:	01612823          	sw	s6,16(sp)
    1060:	01712623          	sw	s7,12(sp)
    1064:	02112623          	sw	ra,44(sp)
    1068:	02812423          	sw	s0,40(sp)
    106c:	02912223          	sw	s1,36(sp)
    1070:	03212023          	sw	s2,32(sp)
    1074:	01312e23          	sw	s3,28(sp)
    1078:	01412c23          	sw	s4,24(sp)
    107c:	01512a23          	sw	s5,20(sp)
    1080:	01812423          	sw	s8,8(sp)
    1084:	01912223          	sw	s9,4(sp)
    1088:	01a12023          	sw	s10,0(sp)
    108c:	00050b13          	mv	s6,a0
    1090:	00058b93          	mv	s7,a1
  if (d1 == 0)
    1094:	38069e63          	bnez	a3,1430 <__udivdi3+0x3d8>
    1098:	00020937          	lui	s2,0x20
    109c:	00060493          	mv	s1,a2
    10a0:	00050a13          	mv	s4,a0
    10a4:	19090913          	addi	s2,s2,400 # 20190 <__clz_tab>
      if (d0 > n1)
    10a8:	12c5f863          	bleu	a2,a1,11d8 <__udivdi3+0x180>
	  count_leading_zeros (bm, d0);
    10ac:	000107b7          	lui	a5,0x10
    10b0:	00058413          	mv	s0,a1
    10b4:	10f67863          	bleu	a5,a2,11c4 <__udivdi3+0x16c>
    10b8:	0ff00713          	li	a4,255
    10bc:	00c73733          	sltu	a4,a4,a2
    10c0:	00371713          	slli	a4,a4,0x3
    10c4:	00e657b3          	srl	a5,a2,a4
    10c8:	00f90933          	add	s2,s2,a5
    10cc:	00094683          	lbu	a3,0(s2)
    10d0:	00e68733          	add	a4,a3,a4
    10d4:	02000693          	li	a3,32
    10d8:	40e686b3          	sub	a3,a3,a4
	  if (bm != 0)
    10dc:	00068c63          	beqz	a3,10f4 <__udivdi3+0x9c>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    10e0:	00db9433          	sll	s0,s7,a3
    10e4:	00eb5733          	srl	a4,s6,a4
	      d0 = d0 << bm;
    10e8:	00d614b3          	sll	s1,a2,a3
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    10ec:	00876433          	or	s0,a4,s0
	      n0 = n0 << bm;
    10f0:	00db1a33          	sll	s4,s6,a3
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    10f4:	0104da93          	srli	s5,s1,0x10
    10f8:	000a8593          	mv	a1,s5
    10fc:	00040513          	mv	a0,s0
    1100:	2a9000ef          	jal	ra,1ba8 <__umodsi3>
    1104:	00050993          	mv	s3,a0
    1108:	000a8593          	mv	a1,s5
    110c:	00040513          	mv	a0,s0
    1110:	01049b13          	slli	s6,s1,0x10
    1114:	24d000ef          	jal	ra,1b60 <__udivsi3>
    1118:	010b5b13          	srli	s6,s6,0x10
    111c:	00050913          	mv	s2,a0
    1120:	00050593          	mv	a1,a0
    1124:	000b0513          	mv	a0,s6
    1128:	20d000ef          	jal	ra,1b34 <__mulsi3>
    112c:	01099993          	slli	s3,s3,0x10
    1130:	010a5793          	srli	a5,s4,0x10
    1134:	00f9e7b3          	or	a5,s3,a5
    1138:	00090413          	mv	s0,s2
    113c:	00a7fe63          	bleu	a0,a5,1158 <__udivdi3+0x100>
    1140:	009787b3          	add	a5,a5,s1
    1144:	fff90413          	addi	s0,s2,-1
    1148:	0097e863          	bltu	a5,s1,1158 <__udivdi3+0x100>
    114c:	00a7f663          	bleu	a0,a5,1158 <__udivdi3+0x100>
    1150:	ffe90413          	addi	s0,s2,-2
    1154:	009787b3          	add	a5,a5,s1
    1158:	40a78933          	sub	s2,a5,a0
    115c:	000a8593          	mv	a1,s5
    1160:	00090513          	mv	a0,s2
    1164:	245000ef          	jal	ra,1ba8 <__umodsi3>
    1168:	00050993          	mv	s3,a0
    116c:	000a8593          	mv	a1,s5
    1170:	00090513          	mv	a0,s2
    1174:	1ed000ef          	jal	ra,1b60 <__udivsi3>
    1178:	010a1a13          	slli	s4,s4,0x10
    117c:	00050913          	mv	s2,a0
    1180:	00050593          	mv	a1,a0
    1184:	01099993          	slli	s3,s3,0x10
    1188:	000b0513          	mv	a0,s6
    118c:	010a5a13          	srli	s4,s4,0x10
    1190:	1a5000ef          	jal	ra,1b34 <__mulsi3>
    1194:	0149ea33          	or	s4,s3,s4
    1198:	00090613          	mv	a2,s2
    119c:	00aa7c63          	bleu	a0,s4,11b4 <__udivdi3+0x15c>
    11a0:	01448a33          	add	s4,s1,s4
    11a4:	fff90613          	addi	a2,s2,-1
    11a8:	009a6663          	bltu	s4,s1,11b4 <__udivdi3+0x15c>
    11ac:	00aa7463          	bleu	a0,s4,11b4 <__udivdi3+0x15c>
    11b0:	ffe90613          	addi	a2,s2,-2
    11b4:	01041413          	slli	s0,s0,0x10
    11b8:	00c46433          	or	s0,s0,a2
	      q1 = 0;
    11bc:	00000a93          	li	s5,0
    11c0:	1300006f          	j	12f0 <__udivdi3+0x298>
	  count_leading_zeros (bm, d0);
    11c4:	010007b7          	lui	a5,0x1000
    11c8:	01000713          	li	a4,16
    11cc:	eef66ce3          	bltu	a2,a5,10c4 <__udivdi3+0x6c>
    11d0:	01800713          	li	a4,24
    11d4:	ef1ff06f          	j	10c4 <__udivdi3+0x6c>
    11d8:	00068993          	mv	s3,a3
	  if (d0 == 0)
    11dc:	00061a63          	bnez	a2,11f0 <__udivdi3+0x198>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    11e0:	00000593          	li	a1,0
    11e4:	00100513          	li	a0,1
    11e8:	179000ef          	jal	ra,1b60 <__udivsi3>
    11ec:	00050493          	mv	s1,a0
	  count_leading_zeros (bm, d0);
    11f0:	000107b7          	lui	a5,0x10
    11f4:	12f4fe63          	bleu	a5,s1,1330 <__udivdi3+0x2d8>
    11f8:	0ff00793          	li	a5,255
    11fc:	0097f463          	bleu	s1,a5,1204 <__udivdi3+0x1ac>
    1200:	00800993          	li	s3,8
    1204:	0134d7b3          	srl	a5,s1,s3
    1208:	00f90933          	add	s2,s2,a5
    120c:	00094703          	lbu	a4,0(s2)
    1210:	02000693          	li	a3,32
    1214:	01370733          	add	a4,a4,s3
    1218:	40e686b3          	sub	a3,a3,a4
	  if (bm == 0)
    121c:	12069463          	bnez	a3,1344 <__udivdi3+0x2ec>
	      n1 -= d0;
    1220:	409b8433          	sub	s0,s7,s1
	      q1 = 1;
    1224:	00100a93          	li	s5,1
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    1228:	0104db13          	srli	s6,s1,0x10
    122c:	000b0593          	mv	a1,s6
    1230:	00040513          	mv	a0,s0
    1234:	175000ef          	jal	ra,1ba8 <__umodsi3>
    1238:	00050993          	mv	s3,a0
    123c:	000b0593          	mv	a1,s6
    1240:	00040513          	mv	a0,s0
    1244:	01049b93          	slli	s7,s1,0x10
    1248:	119000ef          	jal	ra,1b60 <__udivsi3>
    124c:	010bdb93          	srli	s7,s7,0x10
    1250:	00050913          	mv	s2,a0
    1254:	00050593          	mv	a1,a0
    1258:	000b8513          	mv	a0,s7
    125c:	0d9000ef          	jal	ra,1b34 <__mulsi3>
    1260:	01099993          	slli	s3,s3,0x10
    1264:	010a5793          	srli	a5,s4,0x10
    1268:	00f9e7b3          	or	a5,s3,a5
    126c:	00090413          	mv	s0,s2
    1270:	00a7fe63          	bleu	a0,a5,128c <__udivdi3+0x234>
    1274:	009787b3          	add	a5,a5,s1
    1278:	fff90413          	addi	s0,s2,-1
    127c:	0097e863          	bltu	a5,s1,128c <__udivdi3+0x234>
    1280:	00a7f663          	bleu	a0,a5,128c <__udivdi3+0x234>
    1284:	ffe90413          	addi	s0,s2,-2
    1288:	009787b3          	add	a5,a5,s1
    128c:	40a78933          	sub	s2,a5,a0
    1290:	000b0593          	mv	a1,s6
    1294:	00090513          	mv	a0,s2
    1298:	111000ef          	jal	ra,1ba8 <__umodsi3>
    129c:	00050993          	mv	s3,a0
    12a0:	000b0593          	mv	a1,s6
    12a4:	00090513          	mv	a0,s2
    12a8:	0b9000ef          	jal	ra,1b60 <__udivsi3>
    12ac:	010a1a13          	slli	s4,s4,0x10
    12b0:	00050913          	mv	s2,a0
    12b4:	00050593          	mv	a1,a0
    12b8:	01099993          	slli	s3,s3,0x10
    12bc:	000b8513          	mv	a0,s7
    12c0:	010a5a13          	srli	s4,s4,0x10
    12c4:	071000ef          	jal	ra,1b34 <__mulsi3>
    12c8:	0149ea33          	or	s4,s3,s4
    12cc:	00090613          	mv	a2,s2
    12d0:	00aa7c63          	bleu	a0,s4,12e8 <__udivdi3+0x290>
    12d4:	01448a33          	add	s4,s1,s4
    12d8:	fff90613          	addi	a2,s2,-1
    12dc:	009a6663          	bltu	s4,s1,12e8 <__udivdi3+0x290>
    12e0:	00aa7463          	bleu	a0,s4,12e8 <__udivdi3+0x290>
    12e4:	ffe90613          	addi	a2,s2,-2
    12e8:	01041413          	slli	s0,s0,0x10
    12ec:	00c46433          	or	s0,s0,a2
  return __udivmoddi4 (n, d, (UDWtype *) 0);
}
    12f0:	00040513          	mv	a0,s0
    12f4:	000a8593          	mv	a1,s5
    12f8:	02c12083          	lw	ra,44(sp)
    12fc:	02812403          	lw	s0,40(sp)
    1300:	02412483          	lw	s1,36(sp)
    1304:	02012903          	lw	s2,32(sp)
    1308:	01c12983          	lw	s3,28(sp)
    130c:	01812a03          	lw	s4,24(sp)
    1310:	01412a83          	lw	s5,20(sp)
    1314:	01012b03          	lw	s6,16(sp)
    1318:	00c12b83          	lw	s7,12(sp)
    131c:	00812c03          	lw	s8,8(sp)
    1320:	00412c83          	lw	s9,4(sp)
    1324:	00012d03          	lw	s10,0(sp)
    1328:	03010113          	addi	sp,sp,48
    132c:	00008067          	ret
	  count_leading_zeros (bm, d0);
    1330:	010007b7          	lui	a5,0x1000
    1334:	01000993          	li	s3,16
    1338:	ecf4e6e3          	bltu	s1,a5,1204 <__udivdi3+0x1ac>
    133c:	01800993          	li	s3,24
    1340:	ec5ff06f          	j	1204 <__udivdi3+0x1ac>
	      d0 = d0 << bm;
    1344:	00d494b3          	sll	s1,s1,a3
	      n2 = n1 >> b;
    1348:	00ebd9b3          	srl	s3,s7,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    134c:	0104d413          	srli	s0,s1,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1350:	00eb5733          	srl	a4,s6,a4
    1354:	00db9bb3          	sll	s7,s7,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1358:	00040593          	mv	a1,s0
    135c:	00098513          	mv	a0,s3
	      n1 = (n1 << bm) | (n0 >> b);
    1360:	01776bb3          	or	s7,a4,s7
	      n0 = n0 << bm;
    1364:	00db1a33          	sll	s4,s6,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1368:	041000ef          	jal	ra,1ba8 <__umodsi3>
    136c:	00050913          	mv	s2,a0
    1370:	00040593          	mv	a1,s0
    1374:	00098513          	mv	a0,s3
    1378:	01049b13          	slli	s6,s1,0x10
    137c:	7e4000ef          	jal	ra,1b60 <__udivsi3>
    1380:	010b5b13          	srli	s6,s6,0x10
    1384:	00050993          	mv	s3,a0
    1388:	00050593          	mv	a1,a0
    138c:	000b0513          	mv	a0,s6
    1390:	7a4000ef          	jal	ra,1b34 <__mulsi3>
    1394:	01091913          	slli	s2,s2,0x10
    1398:	010bd713          	srli	a4,s7,0x10
    139c:	00e96733          	or	a4,s2,a4
    13a0:	00098a93          	mv	s5,s3
    13a4:	00a77e63          	bleu	a0,a4,13c0 <__udivdi3+0x368>
    13a8:	00970733          	add	a4,a4,s1
    13ac:	fff98a93          	addi	s5,s3,-1
    13b0:	00976863          	bltu	a4,s1,13c0 <__udivdi3+0x368>
    13b4:	00a77663          	bleu	a0,a4,13c0 <__udivdi3+0x368>
    13b8:	ffe98a93          	addi	s5,s3,-2
    13bc:	00970733          	add	a4,a4,s1
    13c0:	40a709b3          	sub	s3,a4,a0
    13c4:	00040593          	mv	a1,s0
    13c8:	00098513          	mv	a0,s3
    13cc:	7dc000ef          	jal	ra,1ba8 <__umodsi3>
    13d0:	00040593          	mv	a1,s0
    13d4:	00050913          	mv	s2,a0
    13d8:	00098513          	mv	a0,s3
    13dc:	784000ef          	jal	ra,1b60 <__udivsi3>
    13e0:	00050413          	mv	s0,a0
    13e4:	00050593          	mv	a1,a0
    13e8:	000b0513          	mv	a0,s6
    13ec:	748000ef          	jal	ra,1b34 <__mulsi3>
    13f0:	010b9713          	slli	a4,s7,0x10
    13f4:	01075713          	srli	a4,a4,0x10
    13f8:	01091913          	slli	s2,s2,0x10
    13fc:	00e967b3          	or	a5,s2,a4
    1400:	00040713          	mv	a4,s0
    1404:	00a7fe63          	bleu	a0,a5,1420 <__udivdi3+0x3c8>
    1408:	009787b3          	add	a5,a5,s1
    140c:	fff40713          	addi	a4,s0,-1
    1410:	0097e863          	bltu	a5,s1,1420 <__udivdi3+0x3c8>
    1414:	00a7f663          	bleu	a0,a5,1420 <__udivdi3+0x3c8>
    1418:	ffe40713          	addi	a4,s0,-2
    141c:	009787b3          	add	a5,a5,s1
    1420:	010a9a93          	slli	s5,s5,0x10
    1424:	40a78433          	sub	s0,a5,a0
    1428:	00eaeab3          	or	s5,s5,a4
    142c:	dfdff06f          	j	1228 <__udivdi3+0x1d0>
      if (d1 > n1)
    1430:	1ed5ec63          	bltu	a1,a3,1628 <__udivdi3+0x5d0>
	  count_leading_zeros (bm, d1);
    1434:	000107b7          	lui	a5,0x10
    1438:	04f6f463          	bleu	a5,a3,1480 <__udivdi3+0x428>
    143c:	0ff00713          	li	a4,255
    1440:	00d735b3          	sltu	a1,a4,a3
    1444:	00359593          	slli	a1,a1,0x3
    1448:	00020737          	lui	a4,0x20
    144c:	19070713          	addi	a4,a4,400 # 20190 <__clz_tab>
    1450:	00b6d7b3          	srl	a5,a3,a1
    1454:	00e787b3          	add	a5,a5,a4
    1458:	0007c703          	lbu	a4,0(a5) # 10000 <__modsi3+0xe424>
    145c:	02000a93          	li	s5,32
    1460:	00b70733          	add	a4,a4,a1
    1464:	40ea8ab3          	sub	s5,s5,a4
	  if (bm == 0)
    1468:	020a9663          	bnez	s5,1494 <__udivdi3+0x43c>
		  q0 = 1;
    146c:	00100413          	li	s0,1
	      if (n1 > d1 || n0 >= d0)
    1470:	e976e0e3          	bltu	a3,s7,12f0 <__udivdi3+0x298>
    1474:	00cb3633          	sltu	a2,s6,a2
    1478:	00164413          	xori	s0,a2,1
    147c:	e75ff06f          	j	12f0 <__udivdi3+0x298>
	  count_leading_zeros (bm, d1);
    1480:	010007b7          	lui	a5,0x1000
    1484:	01000593          	li	a1,16
    1488:	fcf6e0e3          	bltu	a3,a5,1448 <__udivdi3+0x3f0>
    148c:	01800593          	li	a1,24
    1490:	fb9ff06f          	j	1448 <__udivdi3+0x3f0>
	      d1 = (d1 << bm) | (d0 >> b);
    1494:	00e65cb3          	srl	s9,a2,a4
    1498:	015696b3          	sll	a3,a3,s5
    149c:	00dcecb3          	or	s9,s9,a3
	      n2 = n1 >> b;
    14a0:	00ebd4b3          	srl	s1,s7,a4
	      n1 = (n1 << bm) | (n0 >> b);
    14a4:	015b97b3          	sll	a5,s7,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    14a8:	010cdb93          	srli	s7,s9,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    14ac:	00eb5733          	srl	a4,s6,a4
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    14b0:	000b8593          	mv	a1,s7
    14b4:	00048513          	mv	a0,s1
	      n1 = (n1 << bm) | (n0 >> b);
    14b8:	00f76433          	or	s0,a4,a5
	      d0 = d0 << bm;
    14bc:	015619b3          	sll	s3,a2,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    14c0:	6e8000ef          	jal	ra,1ba8 <__umodsi3>
    14c4:	00050913          	mv	s2,a0
    14c8:	000b8593          	mv	a1,s7
    14cc:	00048513          	mv	a0,s1
    14d0:	010c9c13          	slli	s8,s9,0x10
    14d4:	68c000ef          	jal	ra,1b60 <__udivsi3>
    14d8:	010c5c13          	srli	s8,s8,0x10
    14dc:	00050493          	mv	s1,a0
    14e0:	00050593          	mv	a1,a0
    14e4:	000c0513          	mv	a0,s8
    14e8:	64c000ef          	jal	ra,1b34 <__mulsi3>
    14ec:	01091913          	slli	s2,s2,0x10
    14f0:	01045713          	srli	a4,s0,0x10
    14f4:	00e96733          	or	a4,s2,a4
    14f8:	00048a13          	mv	s4,s1
    14fc:	00a77e63          	bleu	a0,a4,1518 <__udivdi3+0x4c0>
    1500:	01970733          	add	a4,a4,s9
    1504:	fff48a13          	addi	s4,s1,-1
    1508:	01976863          	bltu	a4,s9,1518 <__udivdi3+0x4c0>
    150c:	00a77663          	bleu	a0,a4,1518 <__udivdi3+0x4c0>
    1510:	ffe48a13          	addi	s4,s1,-2
    1514:	01970733          	add	a4,a4,s9
    1518:	40a704b3          	sub	s1,a4,a0
    151c:	000b8593          	mv	a1,s7
    1520:	00048513          	mv	a0,s1
    1524:	684000ef          	jal	ra,1ba8 <__umodsi3>
    1528:	00050913          	mv	s2,a0
    152c:	000b8593          	mv	a1,s7
    1530:	00048513          	mv	a0,s1
    1534:	62c000ef          	jal	ra,1b60 <__udivsi3>
    1538:	00050493          	mv	s1,a0
    153c:	00050593          	mv	a1,a0
    1540:	000c0513          	mv	a0,s8
    1544:	5f0000ef          	jal	ra,1b34 <__mulsi3>
    1548:	01041793          	slli	a5,s0,0x10
    154c:	01091913          	slli	s2,s2,0x10
    1550:	0107d793          	srli	a5,a5,0x10
    1554:	00f967b3          	or	a5,s2,a5
    1558:	00048613          	mv	a2,s1
    155c:	00a7fe63          	bleu	a0,a5,1578 <__udivdi3+0x520>
    1560:	019787b3          	add	a5,a5,s9
    1564:	fff48613          	addi	a2,s1,-1
    1568:	0197e863          	bltu	a5,s9,1578 <__udivdi3+0x520>
    156c:	00a7f663          	bleu	a0,a5,1578 <__udivdi3+0x520>
    1570:	ffe48613          	addi	a2,s1,-2
    1574:	019787b3          	add	a5,a5,s9
    1578:	010a1413          	slli	s0,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    157c:	00010bb7          	lui	s7,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1580:	00c46433          	or	s0,s0,a2
	      umul_ppmm (m1, m0, q0, d0);
    1584:	fffb8913          	addi	s2,s7,-1 # ffff <__modsi3+0xe423>
    1588:	01247d33          	and	s10,s0,s2
    158c:	0129f933          	and	s2,s3,s2
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1590:	40a784b3          	sub	s1,a5,a0
	      umul_ppmm (m1, m0, q0, d0);
    1594:	00090593          	mv	a1,s2
    1598:	000d0513          	mv	a0,s10
    159c:	598000ef          	jal	ra,1b34 <__mulsi3>
    15a0:	01045c93          	srli	s9,s0,0x10
    15a4:	00090593          	mv	a1,s2
    15a8:	00050a13          	mv	s4,a0
    15ac:	000c8513          	mv	a0,s9
    15b0:	584000ef          	jal	ra,1b34 <__mulsi3>
    15b4:	0109d993          	srli	s3,s3,0x10
    15b8:	00050c13          	mv	s8,a0
    15bc:	00098593          	mv	a1,s3
    15c0:	000c8513          	mv	a0,s9
    15c4:	570000ef          	jal	ra,1b34 <__mulsi3>
    15c8:	00050913          	mv	s2,a0
    15cc:	00098593          	mv	a1,s3
    15d0:	000d0513          	mv	a0,s10
    15d4:	560000ef          	jal	ra,1b34 <__mulsi3>
    15d8:	01850533          	add	a0,a0,s8
    15dc:	010a5793          	srli	a5,s4,0x10
    15e0:	00a78533          	add	a0,a5,a0
    15e4:	01857463          	bleu	s8,a0,15ec <__udivdi3+0x594>
    15e8:	01790933          	add	s2,s2,s7
    15ec:	01055793          	srli	a5,a0,0x10
    15f0:	012787b3          	add	a5,a5,s2
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    15f4:	02f4e663          	bltu	s1,a5,1620 <__udivdi3+0x5c8>
    15f8:	bcf492e3          	bne	s1,a5,11bc <__udivdi3+0x164>
	      umul_ppmm (m1, m0, q0, d0);
    15fc:	000107b7          	lui	a5,0x10
    1600:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe423>
    1604:	00f57533          	and	a0,a0,a5
    1608:	01051513          	slli	a0,a0,0x10
    160c:	00fa7a33          	and	s4,s4,a5
	      n0 = n0 << bm;
    1610:	015b1633          	sll	a2,s6,s5
	      umul_ppmm (m1, m0, q0, d0);
    1614:	01450533          	add	a0,a0,s4
	      q1 = 0;
    1618:	00000a93          	li	s5,0
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    161c:	cca67ae3          	bleu	a0,a2,12f0 <__udivdi3+0x298>
		  q0--;
    1620:	fff40413          	addi	s0,s0,-1
    1624:	b99ff06f          	j	11bc <__udivdi3+0x164>
	  q1 = 0;
    1628:	00000a93          	li	s5,0
	  q0 = 0;
    162c:	00000413          	li	s0,0
    1630:	cc1ff06f          	j	12f0 <__udivdi3+0x298>

00001634 <__umoddi3>:
{
    1634:	fb010113          	addi	sp,sp,-80
    1638:	04812423          	sw	s0,72(sp)
    163c:	04912223          	sw	s1,68(sp)
    1640:	03312e23          	sw	s3,60(sp)
    1644:	03912223          	sw	s9,36(sp)
    1648:	04112623          	sw	ra,76(sp)
    164c:	05212023          	sw	s2,64(sp)
    1650:	03412c23          	sw	s4,56(sp)
    1654:	03512a23          	sw	s5,52(sp)
    1658:	03612823          	sw	s6,48(sp)
    165c:	03712623          	sw	s7,44(sp)
    1660:	03812423          	sw	s8,40(sp)
    1664:	03a12023          	sw	s10,32(sp)
    1668:	01b12e23          	sw	s11,28(sp)
    166c:	00050c93          	mv	s9,a0
    1670:	00058993          	mv	s3,a1
  n0 = nn.s.low;
    1674:	00050413          	mv	s0,a0
  n1 = nn.s.high;
    1678:	00058493          	mv	s1,a1
  if (d1 == 0)
    167c:	26069e63          	bnez	a3,18f8 <__umoddi3+0x2c4>
    1680:	00020ab7          	lui	s5,0x20
    1684:	00060913          	mv	s2,a2
    1688:	00068a13          	mv	s4,a3
    168c:	190a8a93          	addi	s5,s5,400 # 20190 <__clz_tab>
      if (d0 > n1)
    1690:	14c5f463          	bleu	a2,a1,17d8 <__umoddi3+0x1a4>
	  count_leading_zeros (bm, d0);
    1694:	000107b7          	lui	a5,0x10
    1698:	12f67663          	bleu	a5,a2,17c4 <__umoddi3+0x190>
    169c:	0ff00793          	li	a5,255
    16a0:	00c7f463          	bleu	a2,a5,16a8 <__umoddi3+0x74>
    16a4:	00800a13          	li	s4,8
    16a8:	014657b3          	srl	a5,a2,s4
    16ac:	00fa8ab3          	add	s5,s5,a5
    16b0:	000ac703          	lbu	a4,0(s5)
    16b4:	02000513          	li	a0,32
    16b8:	01470733          	add	a4,a4,s4
    16bc:	40e50a33          	sub	s4,a0,a4
	  if (bm != 0)
    16c0:	000a0c63          	beqz	s4,16d8 <__umoddi3+0xa4>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    16c4:	014995b3          	sll	a1,s3,s4
    16c8:	00ecd733          	srl	a4,s9,a4
	      d0 = d0 << bm;
    16cc:	01461933          	sll	s2,a2,s4
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    16d0:	00b764b3          	or	s1,a4,a1
	      n0 = n0 << bm;
    16d4:	014c9433          	sll	s0,s9,s4
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    16d8:	01095a93          	srli	s5,s2,0x10
    16dc:	000a8593          	mv	a1,s5
    16e0:	00048513          	mv	a0,s1
    16e4:	4c4000ef          	jal	ra,1ba8 <__umodsi3>
    16e8:	00050993          	mv	s3,a0
    16ec:	000a8593          	mv	a1,s5
    16f0:	01091b13          	slli	s6,s2,0x10
    16f4:	00048513          	mv	a0,s1
    16f8:	468000ef          	jal	ra,1b60 <__udivsi3>
    16fc:	010b5b13          	srli	s6,s6,0x10
    1700:	00050593          	mv	a1,a0
    1704:	000b0513          	mv	a0,s6
    1708:	42c000ef          	jal	ra,1b34 <__mulsi3>
    170c:	01099993          	slli	s3,s3,0x10
    1710:	01045793          	srli	a5,s0,0x10
    1714:	00f9e7b3          	or	a5,s3,a5
    1718:	00a7fa63          	bleu	a0,a5,172c <__umoddi3+0xf8>
    171c:	012787b3          	add	a5,a5,s2
    1720:	0127e663          	bltu	a5,s2,172c <__umoddi3+0xf8>
    1724:	00a7f463          	bleu	a0,a5,172c <__umoddi3+0xf8>
    1728:	012787b3          	add	a5,a5,s2
    172c:	40a784b3          	sub	s1,a5,a0
    1730:	000a8593          	mv	a1,s5
    1734:	00048513          	mv	a0,s1
    1738:	470000ef          	jal	ra,1ba8 <__umodsi3>
    173c:	00050993          	mv	s3,a0
    1740:	000a8593          	mv	a1,s5
    1744:	00048513          	mv	a0,s1
    1748:	418000ef          	jal	ra,1b60 <__udivsi3>
    174c:	01041413          	slli	s0,s0,0x10
    1750:	00050593          	mv	a1,a0
    1754:	01099993          	slli	s3,s3,0x10
    1758:	000b0513          	mv	a0,s6
    175c:	01045413          	srli	s0,s0,0x10
    1760:	3d4000ef          	jal	ra,1b34 <__mulsi3>
    1764:	0089e433          	or	s0,s3,s0
    1768:	00a47a63          	bleu	a0,s0,177c <__umoddi3+0x148>
    176c:	01240433          	add	s0,s0,s2
    1770:	01246663          	bltu	s0,s2,177c <__umoddi3+0x148>
    1774:	00a47463          	bleu	a0,s0,177c <__umoddi3+0x148>
    1778:	01240433          	add	s0,s0,s2
    177c:	40a40433          	sub	s0,s0,a0
	  rr.s.low = n0 >> bm;
    1780:	01445533          	srl	a0,s0,s4
	  *rp = rr.ll;
    1784:	00000593          	li	a1,0
}
    1788:	04c12083          	lw	ra,76(sp)
    178c:	04812403          	lw	s0,72(sp)
    1790:	04412483          	lw	s1,68(sp)
    1794:	04012903          	lw	s2,64(sp)
    1798:	03c12983          	lw	s3,60(sp)
    179c:	03812a03          	lw	s4,56(sp)
    17a0:	03412a83          	lw	s5,52(sp)
    17a4:	03012b03          	lw	s6,48(sp)
    17a8:	02c12b83          	lw	s7,44(sp)
    17ac:	02812c03          	lw	s8,40(sp)
    17b0:	02412c83          	lw	s9,36(sp)
    17b4:	02012d03          	lw	s10,32(sp)
    17b8:	01c12d83          	lw	s11,28(sp)
    17bc:	05010113          	addi	sp,sp,80
    17c0:	00008067          	ret
	  count_leading_zeros (bm, d0);
    17c4:	010007b7          	lui	a5,0x1000
    17c8:	01000a13          	li	s4,16
    17cc:	ecf66ee3          	bltu	a2,a5,16a8 <__umoddi3+0x74>
    17d0:	01800a13          	li	s4,24
    17d4:	ed5ff06f          	j	16a8 <__umoddi3+0x74>
	  if (d0 == 0)
    17d8:	00061a63          	bnez	a2,17ec <__umoddi3+0x1b8>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    17dc:	00000593          	li	a1,0
    17e0:	00100513          	li	a0,1
    17e4:	37c000ef          	jal	ra,1b60 <__udivsi3>
    17e8:	00050913          	mv	s2,a0
	  count_leading_zeros (bm, d0);
    17ec:	000107b7          	lui	a5,0x10
    17f0:	0ef97a63          	bleu	a5,s2,18e4 <__umoddi3+0x2b0>
    17f4:	0ff00793          	li	a5,255
    17f8:	0127f463          	bleu	s2,a5,1800 <__umoddi3+0x1cc>
    17fc:	00800a13          	li	s4,8
    1800:	014957b3          	srl	a5,s2,s4
    1804:	00fa8ab3          	add	s5,s5,a5
    1808:	000ac703          	lbu	a4,0(s5)
    180c:	02000513          	li	a0,32
	      n1 -= d0;
    1810:	412984b3          	sub	s1,s3,s2
	  count_leading_zeros (bm, d0);
    1814:	01470733          	add	a4,a4,s4
    1818:	40e50a33          	sub	s4,a0,a4
	  if (bm == 0)
    181c:	ea0a0ee3          	beqz	s4,16d8 <__umoddi3+0xa4>
	      d0 = d0 << bm;
    1820:	01491933          	sll	s2,s2,s4
	      n2 = n1 >> b;
    1824:	00e9dab3          	srl	s5,s3,a4
	      n1 = (n1 << bm) | (n0 >> b);
    1828:	014995b3          	sll	a1,s3,s4
    182c:	00ecd733          	srl	a4,s9,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1830:	01095493          	srli	s1,s2,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1834:	00b76b33          	or	s6,a4,a1
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1838:	000a8513          	mv	a0,s5
    183c:	00048593          	mv	a1,s1
    1840:	368000ef          	jal	ra,1ba8 <__umodsi3>
    1844:	00050993          	mv	s3,a0
    1848:	00048593          	mv	a1,s1
    184c:	01091b93          	slli	s7,s2,0x10
    1850:	000a8513          	mv	a0,s5
    1854:	30c000ef          	jal	ra,1b60 <__udivsi3>
    1858:	010bdb93          	srli	s7,s7,0x10
    185c:	00050593          	mv	a1,a0
    1860:	000b8513          	mv	a0,s7
    1864:	2d0000ef          	jal	ra,1b34 <__mulsi3>
    1868:	01099993          	slli	s3,s3,0x10
    186c:	010b5793          	srli	a5,s6,0x10
    1870:	00f9e7b3          	or	a5,s3,a5
	      n0 = n0 << bm;
    1874:	014c9433          	sll	s0,s9,s4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1878:	00a7fa63          	bleu	a0,a5,188c <__umoddi3+0x258>
    187c:	012787b3          	add	a5,a5,s2
    1880:	0127e663          	bltu	a5,s2,188c <__umoddi3+0x258>
    1884:	00a7f463          	bleu	a0,a5,188c <__umoddi3+0x258>
    1888:	012787b3          	add	a5,a5,s2
    188c:	40a78ab3          	sub	s5,a5,a0
    1890:	00048593          	mv	a1,s1
    1894:	000a8513          	mv	a0,s5
    1898:	310000ef          	jal	ra,1ba8 <__umodsi3>
    189c:	00050993          	mv	s3,a0
    18a0:	00048593          	mv	a1,s1
    18a4:	000a8513          	mv	a0,s5
    18a8:	2b8000ef          	jal	ra,1b60 <__udivsi3>
    18ac:	00050593          	mv	a1,a0
    18b0:	000b8513          	mv	a0,s7
    18b4:	280000ef          	jal	ra,1b34 <__mulsi3>
    18b8:	010b1593          	slli	a1,s6,0x10
    18bc:	01099993          	slli	s3,s3,0x10
    18c0:	0105d593          	srli	a1,a1,0x10
    18c4:	00b9e5b3          	or	a1,s3,a1
    18c8:	00a5fa63          	bleu	a0,a1,18dc <__umoddi3+0x2a8>
    18cc:	012585b3          	add	a1,a1,s2
    18d0:	0125e663          	bltu	a1,s2,18dc <__umoddi3+0x2a8>
    18d4:	00a5f463          	bleu	a0,a1,18dc <__umoddi3+0x2a8>
    18d8:	012585b3          	add	a1,a1,s2
    18dc:	40a584b3          	sub	s1,a1,a0
    18e0:	df9ff06f          	j	16d8 <__umoddi3+0xa4>
	  count_leading_zeros (bm, d0);
    18e4:	010007b7          	lui	a5,0x1000
    18e8:	01000a13          	li	s4,16
    18ec:	f0f96ae3          	bltu	s2,a5,1800 <__umoddi3+0x1cc>
    18f0:	01800a13          	li	s4,24
    18f4:	f0dff06f          	j	1800 <__umoddi3+0x1cc>
      if (d1 > n1)
    18f8:	e8d5e8e3          	bltu	a1,a3,1788 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    18fc:	000107b7          	lui	a5,0x10
    1900:	04f6fc63          	bleu	a5,a3,1958 <__umoddi3+0x324>
    1904:	0ff00b93          	li	s7,255
    1908:	00dbb533          	sltu	a0,s7,a3
    190c:	00351513          	slli	a0,a0,0x3
    1910:	00020737          	lui	a4,0x20
    1914:	00a6d7b3          	srl	a5,a3,a0
    1918:	19070713          	addi	a4,a4,400 # 20190 <__clz_tab>
    191c:	00e787b3          	add	a5,a5,a4
    1920:	0007cb83          	lbu	s7,0(a5) # 10000 <__modsi3+0xe424>
    1924:	02000593          	li	a1,32
    1928:	00ab8bb3          	add	s7,s7,a0
    192c:	41758b33          	sub	s6,a1,s7
	  if (bm == 0)
    1930:	020b1e63          	bnez	s6,196c <__umoddi3+0x338>
	      if (n1 > d1 || n0 >= d0)
    1934:	0136e463          	bltu	a3,s3,193c <__umoddi3+0x308>
    1938:	00ccea63          	bltu	s9,a2,194c <__umoddi3+0x318>
		  sub_ddmmss (n1, n0, n1, n0, d1, d0);
    193c:	40cc8433          	sub	s0,s9,a2
    1940:	40d986b3          	sub	a3,s3,a3
    1944:	008cb533          	sltu	a0,s9,s0
    1948:	40a684b3          	sub	s1,a3,a0
		  *rp = rr.ll;
    194c:	00040513          	mv	a0,s0
    1950:	00048593          	mv	a1,s1
    1954:	e35ff06f          	j	1788 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    1958:	010007b7          	lui	a5,0x1000
    195c:	01000513          	li	a0,16
    1960:	faf6e8e3          	bltu	a3,a5,1910 <__umoddi3+0x2dc>
    1964:	01800513          	li	a0,24
    1968:	fa9ff06f          	j	1910 <__umoddi3+0x2dc>
	      d1 = (d1 << bm) | (d0 >> b);
    196c:	016696b3          	sll	a3,a3,s6
    1970:	01765d33          	srl	s10,a2,s7
    1974:	00dd6d33          	or	s10,s10,a3
	      n2 = n1 >> b;
    1978:	0179d433          	srl	s0,s3,s7
	      n1 = (n1 << bm) | (n0 >> b);
    197c:	016995b3          	sll	a1,s3,s6
    1980:	017cdc33          	srl	s8,s9,s7
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1984:	010d5493          	srli	s1,s10,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1988:	00bc6c33          	or	s8,s8,a1
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    198c:	00040513          	mv	a0,s0
    1990:	00048593          	mv	a1,s1
	      d0 = d0 << bm;
    1994:	01661ab3          	sll	s5,a2,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1998:	210000ef          	jal	ra,1ba8 <__umodsi3>
    199c:	00050a13          	mv	s4,a0
    19a0:	00048593          	mv	a1,s1
    19a4:	00040513          	mv	a0,s0
	      n0 = n0 << bm;
    19a8:	016c9933          	sll	s2,s9,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    19ac:	010d1c93          	slli	s9,s10,0x10
    19b0:	1b0000ef          	jal	ra,1b60 <__udivsi3>
    19b4:	010cdc93          	srli	s9,s9,0x10
    19b8:	00050413          	mv	s0,a0
    19bc:	00050593          	mv	a1,a0
    19c0:	000c8513          	mv	a0,s9
    19c4:	170000ef          	jal	ra,1b34 <__mulsi3>
    19c8:	010a1a13          	slli	s4,s4,0x10
    19cc:	010c5713          	srli	a4,s8,0x10
    19d0:	00ea6733          	or	a4,s4,a4
    19d4:	00040a13          	mv	s4,s0
    19d8:	00a77e63          	bleu	a0,a4,19f4 <__umoddi3+0x3c0>
    19dc:	01a70733          	add	a4,a4,s10
    19e0:	fff40a13          	addi	s4,s0,-1
    19e4:	01a76863          	bltu	a4,s10,19f4 <__umoddi3+0x3c0>
    19e8:	00a77663          	bleu	a0,a4,19f4 <__umoddi3+0x3c0>
    19ec:	ffe40a13          	addi	s4,s0,-2
    19f0:	01a70733          	add	a4,a4,s10
    19f4:	40a709b3          	sub	s3,a4,a0
    19f8:	00048593          	mv	a1,s1
    19fc:	00098513          	mv	a0,s3
    1a00:	1a8000ef          	jal	ra,1ba8 <__umodsi3>
    1a04:	00048593          	mv	a1,s1
    1a08:	00050413          	mv	s0,a0
    1a0c:	00098513          	mv	a0,s3
    1a10:	150000ef          	jal	ra,1b60 <__udivsi3>
    1a14:	00050593          	mv	a1,a0
    1a18:	00050493          	mv	s1,a0
    1a1c:	000c8513          	mv	a0,s9
    1a20:	114000ef          	jal	ra,1b34 <__mulsi3>
    1a24:	010c1593          	slli	a1,s8,0x10
    1a28:	01041413          	slli	s0,s0,0x10
    1a2c:	0105d593          	srli	a1,a1,0x10
    1a30:	00b465b3          	or	a1,s0,a1
    1a34:	00048713          	mv	a4,s1
    1a38:	00a5fe63          	bleu	a0,a1,1a54 <__umoddi3+0x420>
    1a3c:	01a585b3          	add	a1,a1,s10
    1a40:	fff48713          	addi	a4,s1,-1
    1a44:	01a5e863          	bltu	a1,s10,1a54 <__umoddi3+0x420>
    1a48:	00a5f663          	bleu	a0,a1,1a54 <__umoddi3+0x420>
    1a4c:	ffe48713          	addi	a4,s1,-2
    1a50:	01a585b3          	add	a1,a1,s10
    1a54:	010a1a13          	slli	s4,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    1a58:	00010cb7          	lui	s9,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1a5c:	00ea6a33          	or	s4,s4,a4
	      umul_ppmm (m1, m0, q0, d0);
    1a60:	fffc8413          	addi	s0,s9,-1 # ffff <__modsi3+0xe423>
    1a64:	008a77b3          	and	a5,s4,s0
    1a68:	008af433          	and	s0,s5,s0
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1a6c:	40a584b3          	sub	s1,a1,a0
	      umul_ppmm (m1, m0, q0, d0);
    1a70:	00078513          	mv	a0,a5
    1a74:	00040593          	mv	a1,s0
    1a78:	00f12623          	sw	a5,12(sp)
    1a7c:	010a5a13          	srli	s4,s4,0x10
    1a80:	0b4000ef          	jal	ra,1b34 <__mulsi3>
    1a84:	00050993          	mv	s3,a0
    1a88:	00040593          	mv	a1,s0
    1a8c:	000a0513          	mv	a0,s4
    1a90:	0a4000ef          	jal	ra,1b34 <__mulsi3>
    1a94:	010adc13          	srli	s8,s5,0x10
    1a98:	00050d93          	mv	s11,a0
    1a9c:	000c0593          	mv	a1,s8
    1aa0:	000a0513          	mv	a0,s4
    1aa4:	090000ef          	jal	ra,1b34 <__mulsi3>
    1aa8:	00c12783          	lw	a5,12(sp)
    1aac:	00050a13          	mv	s4,a0
    1ab0:	000c0593          	mv	a1,s8
    1ab4:	00078513          	mv	a0,a5
    1ab8:	07c000ef          	jal	ra,1b34 <__mulsi3>
    1abc:	01b50533          	add	a0,a0,s11
    1ac0:	0109d713          	srli	a4,s3,0x10
    1ac4:	00a70733          	add	a4,a4,a0
    1ac8:	01b77463          	bleu	s11,a4,1ad0 <__umoddi3+0x49c>
    1acc:	019a0a33          	add	s4,s4,s9
    1ad0:	000107b7          	lui	a5,0x10
    1ad4:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe423>
    1ad8:	01075593          	srli	a1,a4,0x10
    1adc:	00f77733          	and	a4,a4,a5
    1ae0:	01071713          	slli	a4,a4,0x10
    1ae4:	00f9f7b3          	and	a5,s3,a5
    1ae8:	014585b3          	add	a1,a1,s4
    1aec:	00f707b3          	add	a5,a4,a5
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1af0:	00b4e663          	bltu	s1,a1,1afc <__umoddi3+0x4c8>
    1af4:	00b49e63          	bne	s1,a1,1b10 <__umoddi3+0x4dc>
    1af8:	00f97c63          	bleu	a5,s2,1b10 <__umoddi3+0x4dc>
		  sub_ddmmss (m1, m0, m1, m0, d1, d0);
    1afc:	41578633          	sub	a2,a5,s5
    1b00:	00c7b7b3          	sltu	a5,a5,a2
    1b04:	41a585b3          	sub	a1,a1,s10
    1b08:	40f585b3          	sub	a1,a1,a5
    1b0c:	00060793          	mv	a5,a2
		  sub_ddmmss (n1, n0, n1, n0, m1, m0);
    1b10:	40f907b3          	sub	a5,s2,a5
    1b14:	00f93933          	sltu	s2,s2,a5
    1b18:	40b485b3          	sub	a1,s1,a1
    1b1c:	412585b3          	sub	a1,a1,s2
		  rr.s.low = (n1 << b) | (n0 >> bm);
    1b20:	01759433          	sll	s0,a1,s7
    1b24:	0167d7b3          	srl	a5,a5,s6
		  *rp = rr.ll;
    1b28:	00f46533          	or	a0,s0,a5
    1b2c:	0165d5b3          	srl	a1,a1,s6
  return w;
    1b30:	c59ff06f          	j	1788 <__umoddi3+0x154>

00001b34 <__mulsi3>:
# define __muldi3 __mulsi3
#endif

  .globl __muldi3
__muldi3:
  mv     a2, a0
    1b34:	00050613          	mv	a2,a0
  li     a0, 0
    1b38:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
    1b3c:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
    1b40:	00068463          	beqz	a3,1b48 <__mulsi3+0x14>
  add    a0, a0, a2
    1b44:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
    1b48:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
    1b4c:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
    1b50:	fe0596e3          	bnez	a1,1b3c <__mulsi3+0x8>
  ret
    1b54:	00008067          	ret

00001b58 <__divsi3>:
  beq   a1, t0, .L20
#endif

  .globl __divdi3
__divdi3:
  bltz  a0, .L10
    1b58:	06054063          	bltz	a0,1bb8 <__umodsi3+0x10>
  bltz  a1, .L11
    1b5c:	0605c663          	bltz	a1,1bc8 <__umodsi3+0x20>

00001b60 <__udivsi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

  .globl __udivdi3
__udivdi3:
  mv    a2, a1
    1b60:	00058613          	mv	a2,a1
  mv    a1, a0
    1b64:	00050593          	mv	a1,a0
  li    a0, -1
    1b68:	fff00513          	li	a0,-1
  beqz  a2, .L5
    1b6c:	02060c63          	beqz	a2,1ba4 <__udivsi3+0x44>
  li    a3, 1
    1b70:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
    1b74:	00b67a63          	bleu	a1,a2,1b88 <__udivsi3+0x28>
.L1:
  blez  a2, .L2
    1b78:	00c05863          	blez	a2,1b88 <__udivsi3+0x28>
  slli  a2, a2, 1
    1b7c:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
    1b80:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
    1b84:	feb66ae3          	bltu	a2,a1,1b78 <__udivsi3+0x18>
.L2:
  li    a0, 0
    1b88:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
    1b8c:	00c5e663          	bltu	a1,a2,1b98 <__udivsi3+0x38>
  sub   a1, a1, a2
    1b90:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
    1b94:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
    1b98:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
    1b9c:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
    1ba0:	fe0696e3          	bnez	a3,1b8c <__udivsi3+0x2c>
.L5:
  ret
    1ba4:	00008067          	ret

00001ba8 <__umodsi3>:

  .globl __umoddi3
__umoddi3:
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
    1ba8:	00008293          	mv	t0,ra
  jal   __udivdi3
    1bac:	fb5ff0ef          	jal	ra,1b60 <__udivsi3>
  move  a0, a1
    1bb0:	00058513          	mv	a0,a1
  jr    t0
    1bb4:	00028067          	jr	t0

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
    1bb8:	40a00533          	neg	a0,a0
  bgez  a1, .L12      /* Compute __udivdi3(-a0, a1), then negate the result.  */
    1bbc:	0005d863          	bgez	a1,1bcc <__umodsi3+0x24>
  neg   a1, a1
    1bc0:	40b005b3          	neg	a1,a1
  j     __udivdi3     /* Compute __udivdi3(-a0, -a1).  */
    1bc4:	f9dff06f          	j	1b60 <__udivsi3>
.L11:                 /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
    1bc8:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
    1bcc:	00008293          	mv	t0,ra
  jal   __udivdi3
    1bd0:	f91ff0ef          	jal	ra,1b60 <__udivsi3>
  neg   a0, a0
    1bd4:	40a00533          	neg	a0,a0
  jr    t0
    1bd8:	00028067          	jr	t0

00001bdc <__modsi3>:

  .globl __moddi3
__moddi3:
  move   t0, ra
    1bdc:	00008293          	mv	t0,ra
  bltz   a1, .L31
    1be0:	0005ca63          	bltz	a1,1bf4 <__modsi3+0x18>
  bltz   a0, .L32
    1be4:	00054c63          	bltz	a0,1bfc <__modsi3+0x20>
.L30:
  jal    __udivdi3    /* The dividend is not negative.  */
    1be8:	f79ff0ef          	jal	ra,1b60 <__udivsi3>
  move   a0, a1
    1bec:	00058513          	mv	a0,a1
  jr     t0
    1bf0:	00028067          	jr	t0
.L31:
  neg    a1, a1
    1bf4:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
    1bf8:	fe0558e3          	bgez	a0,1be8 <__modsi3+0xc>
.L32:
  neg    a0, a0
    1bfc:	40a00533          	neg	a0,a0
  jal    __udivdi3    /* The dividend is hella negative.  */
    1c00:	f61ff0ef          	jal	ra,1b60 <__udivsi3>
  neg    a0, a1
    1c04:	40b00533          	neg	a0,a1
  jr     t0
    1c08:	00028067          	jr	t0
