
TempSensor.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
       0:	00002fb7          	lui	t6,0x2
       4:	800f8f93          	addi	t6,t6,-2048 # 1800 <__umoddi3+0xc8>
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
      44:	0f828293          	addi	t0,t0,248 # 138 <level_0_interrupt_handler>
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
      cc:	a9418193          	addi	gp,gp,-1388 # 20b5c <_gp>

000000d0 <init_bss>:
      d0:	00020517          	auipc	a0,0x20
      d4:	3b050513          	addi	a0,a0,944 # 20480 <__bss_start>
      d8:	00020597          	auipc	a1,0x20
      dc:	4ac58593          	addi	a1,a1,1196 # 20584 <tohost+0x4>
      e0:	00000613          	li	a2,0
      e4:	0f0000ef          	jal	ra,1d4 <fill_block>

000000e8 <init_sbss>:
      e8:	00020517          	auipc	a0,0x20
      ec:	27050513          	addi	a0,a0,624 # 20358 <num_ticks>
      f0:	00020597          	auipc	a1,0x20
      f4:	26858593          	addi	a1,a1,616 # 20358 <num_ticks>
      f8:	00000613          	li	a2,0
      fc:	0d8000ef          	jal	ra,1d4 <fill_block>

00000100 <write_stack_pattern>:
     100:	00021517          	auipc	a0,0x21
     104:	48850513          	addi	a0,a0,1160 # 21588 <_heap_end>
     108:	00022597          	auipc	a1,0x22
     10c:	47c58593          	addi	a1,a1,1148 # 22584 <_heap_end+0xffc>
     110:	ababb637          	lui	a2,0xababb
     114:	bab60613          	addi	a2,a2,-1109 # abababab <__stack+0xaba98623>
     118:	0bc000ef          	jal	ra,1d4 <fill_block>

0000011c <init_stack>:
     11c:	00022117          	auipc	sp,0x22
     120:	46c10113          	addi	sp,sp,1132 # 22588 <__stack>
     124:	00002337          	lui	t1,0x2
     128:	88830313          	addi	t1,t1,-1912 # 1888 <__umoddi3+0x150>
     12c:	30431073          	csrw	mie,t1
     130:	30045073          	csrwi	mstatus,8
     134:	2e80006f          	j	41c <vSyscallInit>

00000138 <level_0_interrupt_handler>:
     138:	f8010113          	addi	sp,sp,-128
     13c:	00112023          	sw	ra,0(sp)
     140:	00412623          	sw	tp,12(sp)
     144:	00512823          	sw	t0,16(sp)
     148:	00612a23          	sw	t1,20(sp)
     14c:	00712c23          	sw	t2,24(sp)
     150:	02a12223          	sw	a0,36(sp)
     154:	02b12423          	sw	a1,40(sp)
     158:	02c12623          	sw	a2,44(sp)
     15c:	02d12823          	sw	a3,48(sp)
     160:	02e12a23          	sw	a4,52(sp)
     164:	02f12c23          	sw	a5,56(sp)
     168:	03012e23          	sw	a6,60(sp)
     16c:	05112023          	sw	a7,64(sp)
     170:	07c12623          	sw	t3,108(sp)
     174:	07d12823          	sw	t4,112(sp)
     178:	07e12a23          	sw	t5,116(sp)
     17c:	07f12c23          	sw	t6,120(sp)
     180:	34202573          	csrr	a0,mcause
     184:	509000ef          	jal	ra,e8c <level_1_interrupt_handler>
     188:	00012083          	lw	ra,0(sp)
     18c:	00c12203          	lw	tp,12(sp)
     190:	01012283          	lw	t0,16(sp)
     194:	01412303          	lw	t1,20(sp)
     198:	01812383          	lw	t2,24(sp)
     19c:	02412503          	lw	a0,36(sp)
     1a0:	02812583          	lw	a1,40(sp)
     1a4:	02c12603          	lw	a2,44(sp)
     1a8:	03012683          	lw	a3,48(sp)
     1ac:	03412703          	lw	a4,52(sp)
     1b0:	03812783          	lw	a5,56(sp)
     1b4:	03c12803          	lw	a6,60(sp)
     1b8:	04012883          	lw	a7,64(sp)
     1bc:	06c12e03          	lw	t3,108(sp)
     1c0:	07012e83          	lw	t4,112(sp)
     1c4:	07412f03          	lw	t5,116(sp)
     1c8:	07812f83          	lw	t6,120(sp)
     1cc:	08010113          	addi	sp,sp,128
     1d0:	30200073          	mret

000001d4 <fill_block>:
     1d4:	00c52023          	sw	a2,0(a0)
     1d8:	00b57663          	bleu	a1,a0,1e4 <fb_end>
     1dc:	00450513          	addi	a0,a0,4
     1e0:	ff5ff06f          	j	1d4 <fill_block>

000001e4 <fb_end>:
     1e4:	00008067          	ret
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
     2dc:	2a870713          	addi	a4,a4,680 # 20580 <tohost>
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
     35c:	22878793          	addi	a5,a5,552 # 20580 <tohost>
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
     384:	599000ef          	jal	ra,111c <strlen>
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
     42c:	48d000ef          	jal	ra,10b8 <main>
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
     528:	f5c78793          	addi	a5,a5,-164 # 20480 <__bss_start>
     52c:	0007a783          	lw	a5,0(a5)
     530:	00178693          	addi	a3,a5,1
     534:	00020717          	auipc	a4,0x20
     538:	f4c70713          	addi	a4,a4,-180 # 20480 <__bss_start>
     53c:	00d72023          	sw	a3,0(a4)
     540:	00c12703          	lw	a4,12(sp)
     544:	0ff77713          	andi	a4,a4,255
     548:	00020697          	auipc	a3,0x20
     54c:	f7868693          	addi	a3,a3,-136 # 204c0 <buf.2126>
     550:	00f687b3          	add	a5,a3,a5
     554:	00e78023          	sb	a4,0(a5)
     558:	00c12703          	lw	a4,12(sp)
     55c:	00a00793          	li	a5,10
     560:	00f70c63          	beq	a4,a5,578 <putchar+0x60>
     564:	00020797          	auipc	a5,0x20
     568:	f1c78793          	addi	a5,a5,-228 # 20480 <__bss_start>
     56c:	0007a703          	lw	a4,0(a5)
     570:	04000793          	li	a5,64
     574:	02f71c63          	bne	a4,a5,5ac <putchar+0x94>
     578:	00020717          	auipc	a4,0x20
     57c:	f4870713          	addi	a4,a4,-184 # 204c0 <buf.2126>
     580:	00020797          	auipc	a5,0x20
     584:	f0078793          	addi	a5,a5,-256 # 20480 <__bss_start>
     588:	0007a783          	lw	a5,0(a5)
     58c:	00078693          	mv	a3,a5
     590:	00070613          	mv	a2,a4
     594:	00100593          	li	a1,1
     598:	04000513          	li	a0,64
     59c:	e19ff0ef          	jal	ra,3b4 <syscall>
     5a0:	00020797          	auipc	a5,0x20
     5a4:	ee078793          	addi	a5,a5,-288 # 20480 <__bss_start>
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
     624:	114010ef          	jal	ra,1738 <__umoddi3>
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
     6a4:	2b9000ef          	jal	ra,115c <__udivdi3>
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
     aa0:	698000ef          	jal	ra,1138 <strnlen>
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
     e00:	39370713          	addi	a4,a4,915 # 38393 <__stack+0x15e0b>
     e04:	00e5e733          	or	a4,a1,a4
     e08:	00e7a423          	sw	a4,8(a5)
     e0c:	00d67733          	and	a4,a2,a3
     e10:	01471693          	slli	a3,a4,0x14
     e14:	00030737          	lui	a4,0x30
     e18:	06770713          	addi	a4,a4,103 # 30067 <__stack+0xdadf>
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

00000e84 <irq_empty_handler>:
     e84:	00000013          	nop
     e88:	00008067          	ret

00000e8c <level_1_interrupt_handler>:
     e8c:	fd010113          	addi	sp,sp,-48
     e90:	02112623          	sw	ra,44(sp)
     e94:	00a12623          	sw	a0,12(sp)
     e98:	00c12783          	lw	a5,12(sp)
     e9c:	00f7f793          	andi	a5,a5,15
     ea0:	00b00713          	li	a4,11
     ea4:	04e78e63          	beq	a5,a4,f00 <level_1_interrupt_handler+0x74>
     ea8:	00c00713          	li	a4,12
     eac:	00e78863          	beq	a5,a4,ebc <level_1_interrupt_handler+0x30>
     eb0:	00700713          	li	a4,7
     eb4:	08e78c63          	beq	a5,a4,f4c <level_1_interrupt_handler+0xc0>
     eb8:	0d80006f          	j	f90 <level_1_interrupt_handler+0x104>
     ebc:	000012b7          	lui	t0,0x1
     ec0:	3442b073          	csrc	mip,t0
     ec4:	0001f797          	auipc	a5,0x1f
     ec8:	64078793          	addi	a5,a5,1600 # 20504 <tempSensor_irq_handler>
     ecc:	0007a783          	lw	a5,0(a5)
     ed0:	00078c63          	beqz	a5,ee8 <level_1_interrupt_handler+0x5c>
     ed4:	0001f797          	auipc	a5,0x1f
     ed8:	63078793          	addi	a5,a5,1584 # 20504 <tempSensor_irq_handler>
     edc:	0007a783          	lw	a5,0(a5)
     ee0:	000780e7          	jalr	a5
     ee4:	0ac0006f          	j	f90 <level_1_interrupt_handler+0x104>
     ee8:	0001f797          	auipc	a5,0x1f
     eec:	48078793          	addi	a5,a5,1152 # 20368 <Tthreshold>
     ef0:	0007a783          	lw	a5,0(a5)
     ef4:	22b00713          	li	a4,555
     ef8:	00e7a023          	sw	a4,0(a5)
     efc:	0940006f          	j	f90 <level_1_interrupt_handler+0x104>
     f00:	000017b7          	lui	a5,0x1
     f04:	80078293          	addi	t0,a5,-2048 # 800 <getuint+0x8c>
     f08:	3442b073          	csrc	mip,t0
     f0c:	0c2007b7          	lui	a5,0xc200
     f10:	00478793          	addi	a5,a5,4 # c200004 <__stack+0xc1dda7c>
     f14:	0007a783          	lw	a5,0(a5)
     f18:	00f12e23          	sw	a5,28(sp)
     f1c:	0001f717          	auipc	a4,0x1f
     f20:	45470713          	addi	a4,a4,1108 # 20370 <__data_start>
     f24:	01c12783          	lw	a5,28(sp)
     f28:	00279793          	slli	a5,a5,0x2
     f2c:	00f707b3          	add	a5,a4,a5
     f30:	0007a783          	lw	a5,0(a5)
     f34:	000780e7          	jalr	a5
     f38:	0c2007b7          	lui	a5,0xc200
     f3c:	00478793          	addi	a5,a5,4 # c200004 <__stack+0xc1dda7c>
     f40:	00100713          	li	a4,1
     f44:	00e7a023          	sw	a4,0(a5)
     f48:	0480006f          	j	f90 <level_1_interrupt_handler+0x104>
     f4c:	0001f797          	auipc	a5,0x1f
     f50:	5b478793          	addi	a5,a5,1460 # 20500 <timer_irq_handler>
     f54:	0007a783          	lw	a5,0(a5)
     f58:	00078c63          	beqz	a5,f70 <level_1_interrupt_handler+0xe4>
     f5c:	0001f797          	auipc	a5,0x1f
     f60:	5a478793          	addi	a5,a5,1444 # 20500 <timer_irq_handler>
     f64:	0007a783          	lw	a5,0(a5)
     f68:	000780e7          	jalr	a5
     f6c:	0240006f          	j	f90 <level_1_interrupt_handler+0x104>
     f70:	0001f797          	auipc	a5,0x1f
     f74:	3f478793          	addi	a5,a5,1012 # 20364 <mtimecmp>
     f78:	0007a783          	lw	a5,0(a5)
     f7c:	00000693          	li	a3,0
     f80:	00000713          	li	a4,0
     f84:	00d7a023          	sw	a3,0(a5)
     f88:	00e7a223          	sw	a4,4(a5)
     f8c:	00000013          	nop
     f90:	02c12083          	lw	ra,44(sp)
     f94:	03010113          	addi	sp,sp,48
     f98:	00008067          	ret

00000f9c <register_timer_interrupt_handler>:
     f9c:	ff010113          	addi	sp,sp,-16
     fa0:	00a12623          	sw	a0,12(sp)
     fa4:	0001f797          	auipc	a5,0x1f
     fa8:	55c78793          	addi	a5,a5,1372 # 20500 <timer_irq_handler>
     fac:	00c12703          	lw	a4,12(sp)
     fb0:	00e7a023          	sw	a4,0(a5)
     fb4:	00000013          	nop
     fb8:	01010113          	addi	sp,sp,16
     fbc:	00008067          	ret

00000fc0 <register_tempSensor_interrupt_handler>:
     fc0:	ff010113          	addi	sp,sp,-16
     fc4:	00a12623          	sw	a0,12(sp)
     fc8:	0001f797          	auipc	a5,0x1f
     fcc:	53c78793          	addi	a5,a5,1340 # 20504 <tempSensor_irq_handler>
     fd0:	00c12703          	lw	a4,12(sp)
     fd4:	00e7a023          	sw	a4,0(a5)
     fd8:	00000013          	nop
     fdc:	01010113          	addi	sp,sp,16
     fe0:	00008067          	ret

00000fe4 <set_next_timer_interrupt>:
     fe4:	0001f797          	auipc	a5,0x1f
     fe8:	37c78793          	addi	a5,a5,892 # 20360 <mtime>
     fec:	0007a783          	lw	a5,0(a5)
     ff0:	0047a803          	lw	a6,4(a5)
     ff4:	0007a783          	lw	a5,0(a5)
     ff8:	0001f717          	auipc	a4,0x1f
     ffc:	36c70713          	addi	a4,a4,876 # 20364 <mtimecmp>
    1000:	00072503          	lw	a0,0(a4)
    1004:	000f45b7          	lui	a1,0xf4
    1008:	24058593          	addi	a1,a1,576 # f4240 <__stack+0xd1cb8>
    100c:	00000613          	li	a2,0
    1010:	00b786b3          	add	a3,a5,a1
    1014:	00068893          	mv	a7,a3
    1018:	00f8b8b3          	sltu	a7,a7,a5
    101c:	00c80733          	add	a4,a6,a2
    1020:	00e887b3          	add	a5,a7,a4
    1024:	00078713          	mv	a4,a5
    1028:	00068793          	mv	a5,a3
    102c:	00070813          	mv	a6,a4
    1030:	00f52023          	sw	a5,0(a0)
    1034:	01052223          	sw	a6,4(a0)
    1038:	00000013          	nop
    103c:	00008067          	ret

00001040 <timer_irq_handler>:
    1040:	ff010113          	addi	sp,sp,-16
    1044:	00112623          	sw	ra,12(sp)
    1048:	0001f797          	auipc	a5,0x1f
    104c:	31078793          	addi	a5,a5,784 # 20358 <num_ticks>
    1050:	0007a783          	lw	a5,0(a5)
    1054:	00178713          	addi	a4,a5,1
    1058:	0001f797          	auipc	a5,0x1f
    105c:	30078793          	addi	a5,a5,768 # 20358 <num_ticks>
    1060:	00e7a023          	sw	a4,0(a5)
    1064:	f81ff0ef          	jal	ra,fe4 <set_next_timer_interrupt>
    1068:	0001f797          	auipc	a5,0x1f
    106c:	2f078793          	addi	a5,a5,752 # 20358 <num_ticks>
    1070:	0007a783          	lw	a5,0(a5)
    1074:	00078593          	mv	a1,a5
    1078:	0001f517          	auipc	a0,0x1f
    107c:	10450513          	addi	a0,a0,260 # 2017c <__rodata_start+0x17c>
    1080:	c55ff0ef          	jal	ra,cd4 <printf>
    1084:	00000013          	nop
    1088:	00c12083          	lw	ra,12(sp)
    108c:	01010113          	addi	sp,sp,16
    1090:	00008067          	ret

00001094 <tempSensor_irq_handler>:
    1094:	ff010113          	addi	sp,sp,-16
    1098:	00112623          	sw	ra,12(sp)
    109c:	0001f517          	auipc	a0,0x1f
    10a0:	0f450513          	addi	a0,a0,244 # 20190 <__rodata_start+0x190>
    10a4:	c31ff0ef          	jal	ra,cd4 <printf>
    10a8:	00000013          	nop
    10ac:	00c12083          	lw	ra,12(sp)
    10b0:	01010113          	addi	sp,sp,16
    10b4:	00008067          	ret

000010b8 <main>:
    10b8:	ff010113          	addi	sp,sp,-16
    10bc:	00112623          	sw	ra,12(sp)
    10c0:	00000517          	auipc	a0,0x0
    10c4:	f8050513          	addi	a0,a0,-128 # 1040 <timer_irq_handler>
    10c8:	ed5ff0ef          	jal	ra,f9c <register_timer_interrupt_handler>
    10cc:	f19ff0ef          	jal	ra,fe4 <set_next_timer_interrupt>
    10d0:	00000517          	auipc	a0,0x0
    10d4:	fc450513          	addi	a0,a0,-60 # 1094 <tempSensor_irq_handler>
    10d8:	ee9ff0ef          	jal	ra,fc0 <register_tempSensor_interrupt_handler>
    10dc:	0001f797          	auipc	a5,0x1f
    10e0:	28c78793          	addi	a5,a5,652 # 20368 <Tthreshold>
    10e4:	0007a783          	lw	a5,0(a5)
    10e8:	03200713          	li	a4,50
    10ec:	00e7a023          	sw	a4,0(a5)
    10f0:	00000013          	nop
    10f4:	0001f797          	auipc	a5,0x1f
    10f8:	26478793          	addi	a5,a5,612 # 20358 <num_ticks>
    10fc:	0007a703          	lw	a4,0(a5)
    1100:	00500793          	li	a5,5
    1104:	fee7f8e3          	bleu	a4,a5,10f4 <main+0x3c>
    1108:	00000793          	li	a5,0
    110c:	00078513          	mv	a0,a5
    1110:	00c12083          	lw	ra,12(sp)
    1114:	01010113          	addi	sp,sp,16
    1118:	00008067          	ret

0000111c <strlen>:
    111c:	00050793          	mv	a5,a0
    1120:	00178793          	addi	a5,a5,1
    1124:	fff7c703          	lbu	a4,-1(a5)
    1128:	fe071ce3          	bnez	a4,1120 <strlen+0x4>
    112c:	40a78533          	sub	a0,a5,a0
    1130:	fff50513          	addi	a0,a0,-1
    1134:	00008067          	ret

00001138 <strnlen>:
    1138:	00b505b3          	add	a1,a0,a1
    113c:	00050793          	mv	a5,a0
    1140:	00b78663          	beq	a5,a1,114c <strnlen+0x14>
    1144:	0007c703          	lbu	a4,0(a5)
    1148:	00071663          	bnez	a4,1154 <strnlen+0x1c>
    114c:	40a78533          	sub	a0,a5,a0
    1150:	00008067          	ret
    1154:	00178793          	addi	a5,a5,1
    1158:	fe9ff06f          	j	1140 <strnlen+0x8>

0000115c <__udivdi3>:
#endif

#ifdef L_udivdi3
UDWtype
__udivdi3 (UDWtype n, UDWtype d)
{
    115c:	fd010113          	addi	sp,sp,-48
    1160:	01612823          	sw	s6,16(sp)
    1164:	01712623          	sw	s7,12(sp)
    1168:	02112623          	sw	ra,44(sp)
    116c:	02812423          	sw	s0,40(sp)
    1170:	02912223          	sw	s1,36(sp)
    1174:	03212023          	sw	s2,32(sp)
    1178:	01312e23          	sw	s3,28(sp)
    117c:	01412c23          	sw	s4,24(sp)
    1180:	01512a23          	sw	s5,20(sp)
    1184:	01812423          	sw	s8,8(sp)
    1188:	01912223          	sw	s9,4(sp)
    118c:	01a12023          	sw	s10,0(sp)
    1190:	00050b13          	mv	s6,a0
    1194:	00058b93          	mv	s7,a1
  if (d1 == 0)
    1198:	38069e63          	bnez	a3,1534 <__udivdi3+0x3d8>
    119c:	00020937          	lui	s2,0x20
    11a0:	00060493          	mv	s1,a2
    11a4:	00050a13          	mv	s4,a0
    11a8:	1a090913          	addi	s2,s2,416 # 201a0 <__clz_tab>
      if (d0 > n1)
    11ac:	12c5f863          	bleu	a2,a1,12dc <__udivdi3+0x180>
	  count_leading_zeros (bm, d0);
    11b0:	000107b7          	lui	a5,0x10
    11b4:	00058413          	mv	s0,a1
    11b8:	10f67863          	bleu	a5,a2,12c8 <__udivdi3+0x16c>
    11bc:	0ff00713          	li	a4,255
    11c0:	00c73733          	sltu	a4,a4,a2
    11c4:	00371713          	slli	a4,a4,0x3
    11c8:	00e657b3          	srl	a5,a2,a4
    11cc:	00f90933          	add	s2,s2,a5
    11d0:	00094683          	lbu	a3,0(s2)
    11d4:	00e68733          	add	a4,a3,a4
    11d8:	02000693          	li	a3,32
    11dc:	40e686b3          	sub	a3,a3,a4
	  if (bm != 0)
    11e0:	00068c63          	beqz	a3,11f8 <__udivdi3+0x9c>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    11e4:	00db9433          	sll	s0,s7,a3
    11e8:	00eb5733          	srl	a4,s6,a4
	      d0 = d0 << bm;
    11ec:	00d614b3          	sll	s1,a2,a3
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    11f0:	00876433          	or	s0,a4,s0
	      n0 = n0 << bm;
    11f4:	00db1a33          	sll	s4,s6,a3
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    11f8:	0104da93          	srli	s5,s1,0x10
    11fc:	000a8593          	mv	a1,s5
    1200:	00040513          	mv	a0,s0
    1204:	2a9000ef          	jal	ra,1cac <__umodsi3>
    1208:	00050993          	mv	s3,a0
    120c:	000a8593          	mv	a1,s5
    1210:	00040513          	mv	a0,s0
    1214:	01049b13          	slli	s6,s1,0x10
    1218:	24d000ef          	jal	ra,1c64 <__udivsi3>
    121c:	010b5b13          	srli	s6,s6,0x10
    1220:	00050913          	mv	s2,a0
    1224:	00050593          	mv	a1,a0
    1228:	000b0513          	mv	a0,s6
    122c:	20d000ef          	jal	ra,1c38 <__mulsi3>
    1230:	01099993          	slli	s3,s3,0x10
    1234:	010a5793          	srli	a5,s4,0x10
    1238:	00f9e7b3          	or	a5,s3,a5
    123c:	00090413          	mv	s0,s2
    1240:	00a7fe63          	bleu	a0,a5,125c <__udivdi3+0x100>
    1244:	009787b3          	add	a5,a5,s1
    1248:	fff90413          	addi	s0,s2,-1
    124c:	0097e863          	bltu	a5,s1,125c <__udivdi3+0x100>
    1250:	00a7f663          	bleu	a0,a5,125c <__udivdi3+0x100>
    1254:	ffe90413          	addi	s0,s2,-2
    1258:	009787b3          	add	a5,a5,s1
    125c:	40a78933          	sub	s2,a5,a0
    1260:	000a8593          	mv	a1,s5
    1264:	00090513          	mv	a0,s2
    1268:	245000ef          	jal	ra,1cac <__umodsi3>
    126c:	00050993          	mv	s3,a0
    1270:	000a8593          	mv	a1,s5
    1274:	00090513          	mv	a0,s2
    1278:	1ed000ef          	jal	ra,1c64 <__udivsi3>
    127c:	010a1a13          	slli	s4,s4,0x10
    1280:	00050913          	mv	s2,a0
    1284:	00050593          	mv	a1,a0
    1288:	01099993          	slli	s3,s3,0x10
    128c:	000b0513          	mv	a0,s6
    1290:	010a5a13          	srli	s4,s4,0x10
    1294:	1a5000ef          	jal	ra,1c38 <__mulsi3>
    1298:	0149ea33          	or	s4,s3,s4
    129c:	00090613          	mv	a2,s2
    12a0:	00aa7c63          	bleu	a0,s4,12b8 <__udivdi3+0x15c>
    12a4:	01448a33          	add	s4,s1,s4
    12a8:	fff90613          	addi	a2,s2,-1
    12ac:	009a6663          	bltu	s4,s1,12b8 <__udivdi3+0x15c>
    12b0:	00aa7463          	bleu	a0,s4,12b8 <__udivdi3+0x15c>
    12b4:	ffe90613          	addi	a2,s2,-2
    12b8:	01041413          	slli	s0,s0,0x10
    12bc:	00c46433          	or	s0,s0,a2
	      q1 = 0;
    12c0:	00000a93          	li	s5,0
    12c4:	1300006f          	j	13f4 <__udivdi3+0x298>
	  count_leading_zeros (bm, d0);
    12c8:	010007b7          	lui	a5,0x1000
    12cc:	01000713          	li	a4,16
    12d0:	eef66ce3          	bltu	a2,a5,11c8 <__udivdi3+0x6c>
    12d4:	01800713          	li	a4,24
    12d8:	ef1ff06f          	j	11c8 <__udivdi3+0x6c>
    12dc:	00068993          	mv	s3,a3
	  if (d0 == 0)
    12e0:	00061a63          	bnez	a2,12f4 <__udivdi3+0x198>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    12e4:	00000593          	li	a1,0
    12e8:	00100513          	li	a0,1
    12ec:	179000ef          	jal	ra,1c64 <__udivsi3>
    12f0:	00050493          	mv	s1,a0
	  count_leading_zeros (bm, d0);
    12f4:	000107b7          	lui	a5,0x10
    12f8:	12f4fe63          	bleu	a5,s1,1434 <__udivdi3+0x2d8>
    12fc:	0ff00793          	li	a5,255
    1300:	0097f463          	bleu	s1,a5,1308 <__udivdi3+0x1ac>
    1304:	00800993          	li	s3,8
    1308:	0134d7b3          	srl	a5,s1,s3
    130c:	00f90933          	add	s2,s2,a5
    1310:	00094703          	lbu	a4,0(s2)
    1314:	02000693          	li	a3,32
    1318:	01370733          	add	a4,a4,s3
    131c:	40e686b3          	sub	a3,a3,a4
	  if (bm == 0)
    1320:	12069463          	bnez	a3,1448 <__udivdi3+0x2ec>
	      n1 -= d0;
    1324:	409b8433          	sub	s0,s7,s1
	      q1 = 1;
    1328:	00100a93          	li	s5,1
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    132c:	0104db13          	srli	s6,s1,0x10
    1330:	000b0593          	mv	a1,s6
    1334:	00040513          	mv	a0,s0
    1338:	175000ef          	jal	ra,1cac <__umodsi3>
    133c:	00050993          	mv	s3,a0
    1340:	000b0593          	mv	a1,s6
    1344:	00040513          	mv	a0,s0
    1348:	01049b93          	slli	s7,s1,0x10
    134c:	119000ef          	jal	ra,1c64 <__udivsi3>
    1350:	010bdb93          	srli	s7,s7,0x10
    1354:	00050913          	mv	s2,a0
    1358:	00050593          	mv	a1,a0
    135c:	000b8513          	mv	a0,s7
    1360:	0d9000ef          	jal	ra,1c38 <__mulsi3>
    1364:	01099993          	slli	s3,s3,0x10
    1368:	010a5793          	srli	a5,s4,0x10
    136c:	00f9e7b3          	or	a5,s3,a5
    1370:	00090413          	mv	s0,s2
    1374:	00a7fe63          	bleu	a0,a5,1390 <__udivdi3+0x234>
    1378:	009787b3          	add	a5,a5,s1
    137c:	fff90413          	addi	s0,s2,-1
    1380:	0097e863          	bltu	a5,s1,1390 <__udivdi3+0x234>
    1384:	00a7f663          	bleu	a0,a5,1390 <__udivdi3+0x234>
    1388:	ffe90413          	addi	s0,s2,-2
    138c:	009787b3          	add	a5,a5,s1
    1390:	40a78933          	sub	s2,a5,a0
    1394:	000b0593          	mv	a1,s6
    1398:	00090513          	mv	a0,s2
    139c:	111000ef          	jal	ra,1cac <__umodsi3>
    13a0:	00050993          	mv	s3,a0
    13a4:	000b0593          	mv	a1,s6
    13a8:	00090513          	mv	a0,s2
    13ac:	0b9000ef          	jal	ra,1c64 <__udivsi3>
    13b0:	010a1a13          	slli	s4,s4,0x10
    13b4:	00050913          	mv	s2,a0
    13b8:	00050593          	mv	a1,a0
    13bc:	01099993          	slli	s3,s3,0x10
    13c0:	000b8513          	mv	a0,s7
    13c4:	010a5a13          	srli	s4,s4,0x10
    13c8:	071000ef          	jal	ra,1c38 <__mulsi3>
    13cc:	0149ea33          	or	s4,s3,s4
    13d0:	00090613          	mv	a2,s2
    13d4:	00aa7c63          	bleu	a0,s4,13ec <__udivdi3+0x290>
    13d8:	01448a33          	add	s4,s1,s4
    13dc:	fff90613          	addi	a2,s2,-1
    13e0:	009a6663          	bltu	s4,s1,13ec <__udivdi3+0x290>
    13e4:	00aa7463          	bleu	a0,s4,13ec <__udivdi3+0x290>
    13e8:	ffe90613          	addi	a2,s2,-2
    13ec:	01041413          	slli	s0,s0,0x10
    13f0:	00c46433          	or	s0,s0,a2
  return __udivmoddi4 (n, d, (UDWtype *) 0);
}
    13f4:	00040513          	mv	a0,s0
    13f8:	000a8593          	mv	a1,s5
    13fc:	02c12083          	lw	ra,44(sp)
    1400:	02812403          	lw	s0,40(sp)
    1404:	02412483          	lw	s1,36(sp)
    1408:	02012903          	lw	s2,32(sp)
    140c:	01c12983          	lw	s3,28(sp)
    1410:	01812a03          	lw	s4,24(sp)
    1414:	01412a83          	lw	s5,20(sp)
    1418:	01012b03          	lw	s6,16(sp)
    141c:	00c12b83          	lw	s7,12(sp)
    1420:	00812c03          	lw	s8,8(sp)
    1424:	00412c83          	lw	s9,4(sp)
    1428:	00012d03          	lw	s10,0(sp)
    142c:	03010113          	addi	sp,sp,48
    1430:	00008067          	ret
	  count_leading_zeros (bm, d0);
    1434:	010007b7          	lui	a5,0x1000
    1438:	01000993          	li	s3,16
    143c:	ecf4e6e3          	bltu	s1,a5,1308 <__udivdi3+0x1ac>
    1440:	01800993          	li	s3,24
    1444:	ec5ff06f          	j	1308 <__udivdi3+0x1ac>
	      d0 = d0 << bm;
    1448:	00d494b3          	sll	s1,s1,a3
	      n2 = n1 >> b;
    144c:	00ebd9b3          	srl	s3,s7,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1450:	0104d413          	srli	s0,s1,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1454:	00eb5733          	srl	a4,s6,a4
    1458:	00db9bb3          	sll	s7,s7,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    145c:	00040593          	mv	a1,s0
    1460:	00098513          	mv	a0,s3
	      n1 = (n1 << bm) | (n0 >> b);
    1464:	01776bb3          	or	s7,a4,s7
	      n0 = n0 << bm;
    1468:	00db1a33          	sll	s4,s6,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    146c:	041000ef          	jal	ra,1cac <__umodsi3>
    1470:	00050913          	mv	s2,a0
    1474:	00040593          	mv	a1,s0
    1478:	00098513          	mv	a0,s3
    147c:	01049b13          	slli	s6,s1,0x10
    1480:	7e4000ef          	jal	ra,1c64 <__udivsi3>
    1484:	010b5b13          	srli	s6,s6,0x10
    1488:	00050993          	mv	s3,a0
    148c:	00050593          	mv	a1,a0
    1490:	000b0513          	mv	a0,s6
    1494:	7a4000ef          	jal	ra,1c38 <__mulsi3>
    1498:	01091913          	slli	s2,s2,0x10
    149c:	010bd713          	srli	a4,s7,0x10
    14a0:	00e96733          	or	a4,s2,a4
    14a4:	00098a93          	mv	s5,s3
    14a8:	00a77e63          	bleu	a0,a4,14c4 <__udivdi3+0x368>
    14ac:	00970733          	add	a4,a4,s1
    14b0:	fff98a93          	addi	s5,s3,-1
    14b4:	00976863          	bltu	a4,s1,14c4 <__udivdi3+0x368>
    14b8:	00a77663          	bleu	a0,a4,14c4 <__udivdi3+0x368>
    14bc:	ffe98a93          	addi	s5,s3,-2
    14c0:	00970733          	add	a4,a4,s1
    14c4:	40a709b3          	sub	s3,a4,a0
    14c8:	00040593          	mv	a1,s0
    14cc:	00098513          	mv	a0,s3
    14d0:	7dc000ef          	jal	ra,1cac <__umodsi3>
    14d4:	00040593          	mv	a1,s0
    14d8:	00050913          	mv	s2,a0
    14dc:	00098513          	mv	a0,s3
    14e0:	784000ef          	jal	ra,1c64 <__udivsi3>
    14e4:	00050413          	mv	s0,a0
    14e8:	00050593          	mv	a1,a0
    14ec:	000b0513          	mv	a0,s6
    14f0:	748000ef          	jal	ra,1c38 <__mulsi3>
    14f4:	010b9713          	slli	a4,s7,0x10
    14f8:	01075713          	srli	a4,a4,0x10
    14fc:	01091913          	slli	s2,s2,0x10
    1500:	00e967b3          	or	a5,s2,a4
    1504:	00040713          	mv	a4,s0
    1508:	00a7fe63          	bleu	a0,a5,1524 <__udivdi3+0x3c8>
    150c:	009787b3          	add	a5,a5,s1
    1510:	fff40713          	addi	a4,s0,-1
    1514:	0097e863          	bltu	a5,s1,1524 <__udivdi3+0x3c8>
    1518:	00a7f663          	bleu	a0,a5,1524 <__udivdi3+0x3c8>
    151c:	ffe40713          	addi	a4,s0,-2
    1520:	009787b3          	add	a5,a5,s1
    1524:	010a9a93          	slli	s5,s5,0x10
    1528:	40a78433          	sub	s0,a5,a0
    152c:	00eaeab3          	or	s5,s5,a4
    1530:	dfdff06f          	j	132c <__udivdi3+0x1d0>
      if (d1 > n1)
    1534:	1ed5ec63          	bltu	a1,a3,172c <__udivdi3+0x5d0>
	  count_leading_zeros (bm, d1);
    1538:	000107b7          	lui	a5,0x10
    153c:	04f6f463          	bleu	a5,a3,1584 <__udivdi3+0x428>
    1540:	0ff00713          	li	a4,255
    1544:	00d735b3          	sltu	a1,a4,a3
    1548:	00359593          	slli	a1,a1,0x3
    154c:	00020737          	lui	a4,0x20
    1550:	1a070713          	addi	a4,a4,416 # 201a0 <__clz_tab>
    1554:	00b6d7b3          	srl	a5,a3,a1
    1558:	00e787b3          	add	a5,a5,a4
    155c:	0007c703          	lbu	a4,0(a5) # 10000 <__modsi3+0xe320>
    1560:	02000a93          	li	s5,32
    1564:	00b70733          	add	a4,a4,a1
    1568:	40ea8ab3          	sub	s5,s5,a4
	  if (bm == 0)
    156c:	020a9663          	bnez	s5,1598 <__udivdi3+0x43c>
		  q0 = 1;
    1570:	00100413          	li	s0,1
	      if (n1 > d1 || n0 >= d0)
    1574:	e976e0e3          	bltu	a3,s7,13f4 <__udivdi3+0x298>
    1578:	00cb3633          	sltu	a2,s6,a2
    157c:	00164413          	xori	s0,a2,1
    1580:	e75ff06f          	j	13f4 <__udivdi3+0x298>
	  count_leading_zeros (bm, d1);
    1584:	010007b7          	lui	a5,0x1000
    1588:	01000593          	li	a1,16
    158c:	fcf6e0e3          	bltu	a3,a5,154c <__udivdi3+0x3f0>
    1590:	01800593          	li	a1,24
    1594:	fb9ff06f          	j	154c <__udivdi3+0x3f0>
	      d1 = (d1 << bm) | (d0 >> b);
    1598:	00e65cb3          	srl	s9,a2,a4
    159c:	015696b3          	sll	a3,a3,s5
    15a0:	00dcecb3          	or	s9,s9,a3
	      n2 = n1 >> b;
    15a4:	00ebd4b3          	srl	s1,s7,a4
	      n1 = (n1 << bm) | (n0 >> b);
    15a8:	015b97b3          	sll	a5,s7,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    15ac:	010cdb93          	srli	s7,s9,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    15b0:	00eb5733          	srl	a4,s6,a4
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    15b4:	000b8593          	mv	a1,s7
    15b8:	00048513          	mv	a0,s1
	      n1 = (n1 << bm) | (n0 >> b);
    15bc:	00f76433          	or	s0,a4,a5
	      d0 = d0 << bm;
    15c0:	015619b3          	sll	s3,a2,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    15c4:	6e8000ef          	jal	ra,1cac <__umodsi3>
    15c8:	00050913          	mv	s2,a0
    15cc:	000b8593          	mv	a1,s7
    15d0:	00048513          	mv	a0,s1
    15d4:	010c9c13          	slli	s8,s9,0x10
    15d8:	68c000ef          	jal	ra,1c64 <__udivsi3>
    15dc:	010c5c13          	srli	s8,s8,0x10
    15e0:	00050493          	mv	s1,a0
    15e4:	00050593          	mv	a1,a0
    15e8:	000c0513          	mv	a0,s8
    15ec:	64c000ef          	jal	ra,1c38 <__mulsi3>
    15f0:	01091913          	slli	s2,s2,0x10
    15f4:	01045713          	srli	a4,s0,0x10
    15f8:	00e96733          	or	a4,s2,a4
    15fc:	00048a13          	mv	s4,s1
    1600:	00a77e63          	bleu	a0,a4,161c <__udivdi3+0x4c0>
    1604:	01970733          	add	a4,a4,s9
    1608:	fff48a13          	addi	s4,s1,-1
    160c:	01976863          	bltu	a4,s9,161c <__udivdi3+0x4c0>
    1610:	00a77663          	bleu	a0,a4,161c <__udivdi3+0x4c0>
    1614:	ffe48a13          	addi	s4,s1,-2
    1618:	01970733          	add	a4,a4,s9
    161c:	40a704b3          	sub	s1,a4,a0
    1620:	000b8593          	mv	a1,s7
    1624:	00048513          	mv	a0,s1
    1628:	684000ef          	jal	ra,1cac <__umodsi3>
    162c:	00050913          	mv	s2,a0
    1630:	000b8593          	mv	a1,s7
    1634:	00048513          	mv	a0,s1
    1638:	62c000ef          	jal	ra,1c64 <__udivsi3>
    163c:	00050493          	mv	s1,a0
    1640:	00050593          	mv	a1,a0
    1644:	000c0513          	mv	a0,s8
    1648:	5f0000ef          	jal	ra,1c38 <__mulsi3>
    164c:	01041793          	slli	a5,s0,0x10
    1650:	01091913          	slli	s2,s2,0x10
    1654:	0107d793          	srli	a5,a5,0x10
    1658:	00f967b3          	or	a5,s2,a5
    165c:	00048613          	mv	a2,s1
    1660:	00a7fe63          	bleu	a0,a5,167c <__udivdi3+0x520>
    1664:	019787b3          	add	a5,a5,s9
    1668:	fff48613          	addi	a2,s1,-1
    166c:	0197e863          	bltu	a5,s9,167c <__udivdi3+0x520>
    1670:	00a7f663          	bleu	a0,a5,167c <__udivdi3+0x520>
    1674:	ffe48613          	addi	a2,s1,-2
    1678:	019787b3          	add	a5,a5,s9
    167c:	010a1413          	slli	s0,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    1680:	00010bb7          	lui	s7,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1684:	00c46433          	or	s0,s0,a2
	      umul_ppmm (m1, m0, q0, d0);
    1688:	fffb8913          	addi	s2,s7,-1 # ffff <__modsi3+0xe31f>
    168c:	01247d33          	and	s10,s0,s2
    1690:	0129f933          	and	s2,s3,s2
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1694:	40a784b3          	sub	s1,a5,a0
	      umul_ppmm (m1, m0, q0, d0);
    1698:	00090593          	mv	a1,s2
    169c:	000d0513          	mv	a0,s10
    16a0:	598000ef          	jal	ra,1c38 <__mulsi3>
    16a4:	01045c93          	srli	s9,s0,0x10
    16a8:	00090593          	mv	a1,s2
    16ac:	00050a13          	mv	s4,a0
    16b0:	000c8513          	mv	a0,s9
    16b4:	584000ef          	jal	ra,1c38 <__mulsi3>
    16b8:	0109d993          	srli	s3,s3,0x10
    16bc:	00050c13          	mv	s8,a0
    16c0:	00098593          	mv	a1,s3
    16c4:	000c8513          	mv	a0,s9
    16c8:	570000ef          	jal	ra,1c38 <__mulsi3>
    16cc:	00050913          	mv	s2,a0
    16d0:	00098593          	mv	a1,s3
    16d4:	000d0513          	mv	a0,s10
    16d8:	560000ef          	jal	ra,1c38 <__mulsi3>
    16dc:	01850533          	add	a0,a0,s8
    16e0:	010a5793          	srli	a5,s4,0x10
    16e4:	00a78533          	add	a0,a5,a0
    16e8:	01857463          	bleu	s8,a0,16f0 <__udivdi3+0x594>
    16ec:	01790933          	add	s2,s2,s7
    16f0:	01055793          	srli	a5,a0,0x10
    16f4:	012787b3          	add	a5,a5,s2
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    16f8:	02f4e663          	bltu	s1,a5,1724 <__udivdi3+0x5c8>
    16fc:	bcf492e3          	bne	s1,a5,12c0 <__udivdi3+0x164>
	      umul_ppmm (m1, m0, q0, d0);
    1700:	000107b7          	lui	a5,0x10
    1704:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe31f>
    1708:	00f57533          	and	a0,a0,a5
    170c:	01051513          	slli	a0,a0,0x10
    1710:	00fa7a33          	and	s4,s4,a5
	      n0 = n0 << bm;
    1714:	015b1633          	sll	a2,s6,s5
	      umul_ppmm (m1, m0, q0, d0);
    1718:	01450533          	add	a0,a0,s4
	      q1 = 0;
    171c:	00000a93          	li	s5,0
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1720:	cca67ae3          	bleu	a0,a2,13f4 <__udivdi3+0x298>
		  q0--;
    1724:	fff40413          	addi	s0,s0,-1
    1728:	b99ff06f          	j	12c0 <__udivdi3+0x164>
	  q1 = 0;
    172c:	00000a93          	li	s5,0
	  q0 = 0;
    1730:	00000413          	li	s0,0
    1734:	cc1ff06f          	j	13f4 <__udivdi3+0x298>

00001738 <__umoddi3>:
{
    1738:	fb010113          	addi	sp,sp,-80
    173c:	04812423          	sw	s0,72(sp)
    1740:	04912223          	sw	s1,68(sp)
    1744:	03312e23          	sw	s3,60(sp)
    1748:	03912223          	sw	s9,36(sp)
    174c:	04112623          	sw	ra,76(sp)
    1750:	05212023          	sw	s2,64(sp)
    1754:	03412c23          	sw	s4,56(sp)
    1758:	03512a23          	sw	s5,52(sp)
    175c:	03612823          	sw	s6,48(sp)
    1760:	03712623          	sw	s7,44(sp)
    1764:	03812423          	sw	s8,40(sp)
    1768:	03a12023          	sw	s10,32(sp)
    176c:	01b12e23          	sw	s11,28(sp)
    1770:	00050c93          	mv	s9,a0
    1774:	00058993          	mv	s3,a1
  n0 = nn.s.low;
    1778:	00050413          	mv	s0,a0
  n1 = nn.s.high;
    177c:	00058493          	mv	s1,a1
  if (d1 == 0)
    1780:	26069e63          	bnez	a3,19fc <__umoddi3+0x2c4>
    1784:	00020ab7          	lui	s5,0x20
    1788:	00060913          	mv	s2,a2
    178c:	00068a13          	mv	s4,a3
    1790:	1a0a8a93          	addi	s5,s5,416 # 201a0 <__clz_tab>
      if (d0 > n1)
    1794:	14c5f463          	bleu	a2,a1,18dc <__umoddi3+0x1a4>
	  count_leading_zeros (bm, d0);
    1798:	000107b7          	lui	a5,0x10
    179c:	12f67663          	bleu	a5,a2,18c8 <__umoddi3+0x190>
    17a0:	0ff00793          	li	a5,255
    17a4:	00c7f463          	bleu	a2,a5,17ac <__umoddi3+0x74>
    17a8:	00800a13          	li	s4,8
    17ac:	014657b3          	srl	a5,a2,s4
    17b0:	00fa8ab3          	add	s5,s5,a5
    17b4:	000ac703          	lbu	a4,0(s5)
    17b8:	02000513          	li	a0,32
    17bc:	01470733          	add	a4,a4,s4
    17c0:	40e50a33          	sub	s4,a0,a4
	  if (bm != 0)
    17c4:	000a0c63          	beqz	s4,17dc <__umoddi3+0xa4>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    17c8:	014995b3          	sll	a1,s3,s4
    17cc:	00ecd733          	srl	a4,s9,a4
	      d0 = d0 << bm;
    17d0:	01461933          	sll	s2,a2,s4
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    17d4:	00b764b3          	or	s1,a4,a1
	      n0 = n0 << bm;
    17d8:	014c9433          	sll	s0,s9,s4
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    17dc:	01095a93          	srli	s5,s2,0x10
    17e0:	000a8593          	mv	a1,s5
    17e4:	00048513          	mv	a0,s1
    17e8:	4c4000ef          	jal	ra,1cac <__umodsi3>
    17ec:	00050993          	mv	s3,a0
    17f0:	000a8593          	mv	a1,s5
    17f4:	01091b13          	slli	s6,s2,0x10
    17f8:	00048513          	mv	a0,s1
    17fc:	468000ef          	jal	ra,1c64 <__udivsi3>
    1800:	010b5b13          	srli	s6,s6,0x10
    1804:	00050593          	mv	a1,a0
    1808:	000b0513          	mv	a0,s6
    180c:	42c000ef          	jal	ra,1c38 <__mulsi3>
    1810:	01099993          	slli	s3,s3,0x10
    1814:	01045793          	srli	a5,s0,0x10
    1818:	00f9e7b3          	or	a5,s3,a5
    181c:	00a7fa63          	bleu	a0,a5,1830 <__umoddi3+0xf8>
    1820:	012787b3          	add	a5,a5,s2
    1824:	0127e663          	bltu	a5,s2,1830 <__umoddi3+0xf8>
    1828:	00a7f463          	bleu	a0,a5,1830 <__umoddi3+0xf8>
    182c:	012787b3          	add	a5,a5,s2
    1830:	40a784b3          	sub	s1,a5,a0
    1834:	000a8593          	mv	a1,s5
    1838:	00048513          	mv	a0,s1
    183c:	470000ef          	jal	ra,1cac <__umodsi3>
    1840:	00050993          	mv	s3,a0
    1844:	000a8593          	mv	a1,s5
    1848:	00048513          	mv	a0,s1
    184c:	418000ef          	jal	ra,1c64 <__udivsi3>
    1850:	01041413          	slli	s0,s0,0x10
    1854:	00050593          	mv	a1,a0
    1858:	01099993          	slli	s3,s3,0x10
    185c:	000b0513          	mv	a0,s6
    1860:	01045413          	srli	s0,s0,0x10
    1864:	3d4000ef          	jal	ra,1c38 <__mulsi3>
    1868:	0089e433          	or	s0,s3,s0
    186c:	00a47a63          	bleu	a0,s0,1880 <__umoddi3+0x148>
    1870:	01240433          	add	s0,s0,s2
    1874:	01246663          	bltu	s0,s2,1880 <__umoddi3+0x148>
    1878:	00a47463          	bleu	a0,s0,1880 <__umoddi3+0x148>
    187c:	01240433          	add	s0,s0,s2
    1880:	40a40433          	sub	s0,s0,a0
	  rr.s.low = n0 >> bm;
    1884:	01445533          	srl	a0,s0,s4
	  *rp = rr.ll;
    1888:	00000593          	li	a1,0
}
    188c:	04c12083          	lw	ra,76(sp)
    1890:	04812403          	lw	s0,72(sp)
    1894:	04412483          	lw	s1,68(sp)
    1898:	04012903          	lw	s2,64(sp)
    189c:	03c12983          	lw	s3,60(sp)
    18a0:	03812a03          	lw	s4,56(sp)
    18a4:	03412a83          	lw	s5,52(sp)
    18a8:	03012b03          	lw	s6,48(sp)
    18ac:	02c12b83          	lw	s7,44(sp)
    18b0:	02812c03          	lw	s8,40(sp)
    18b4:	02412c83          	lw	s9,36(sp)
    18b8:	02012d03          	lw	s10,32(sp)
    18bc:	01c12d83          	lw	s11,28(sp)
    18c0:	05010113          	addi	sp,sp,80
    18c4:	00008067          	ret
	  count_leading_zeros (bm, d0);
    18c8:	010007b7          	lui	a5,0x1000
    18cc:	01000a13          	li	s4,16
    18d0:	ecf66ee3          	bltu	a2,a5,17ac <__umoddi3+0x74>
    18d4:	01800a13          	li	s4,24
    18d8:	ed5ff06f          	j	17ac <__umoddi3+0x74>
	  if (d0 == 0)
    18dc:	00061a63          	bnez	a2,18f0 <__umoddi3+0x1b8>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    18e0:	00000593          	li	a1,0
    18e4:	00100513          	li	a0,1
    18e8:	37c000ef          	jal	ra,1c64 <__udivsi3>
    18ec:	00050913          	mv	s2,a0
	  count_leading_zeros (bm, d0);
    18f0:	000107b7          	lui	a5,0x10
    18f4:	0ef97a63          	bleu	a5,s2,19e8 <__umoddi3+0x2b0>
    18f8:	0ff00793          	li	a5,255
    18fc:	0127f463          	bleu	s2,a5,1904 <__umoddi3+0x1cc>
    1900:	00800a13          	li	s4,8
    1904:	014957b3          	srl	a5,s2,s4
    1908:	00fa8ab3          	add	s5,s5,a5
    190c:	000ac703          	lbu	a4,0(s5)
    1910:	02000513          	li	a0,32
	      n1 -= d0;
    1914:	412984b3          	sub	s1,s3,s2
	  count_leading_zeros (bm, d0);
    1918:	01470733          	add	a4,a4,s4
    191c:	40e50a33          	sub	s4,a0,a4
	  if (bm == 0)
    1920:	ea0a0ee3          	beqz	s4,17dc <__umoddi3+0xa4>
	      d0 = d0 << bm;
    1924:	01491933          	sll	s2,s2,s4
	      n2 = n1 >> b;
    1928:	00e9dab3          	srl	s5,s3,a4
	      n1 = (n1 << bm) | (n0 >> b);
    192c:	014995b3          	sll	a1,s3,s4
    1930:	00ecd733          	srl	a4,s9,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1934:	01095493          	srli	s1,s2,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1938:	00b76b33          	or	s6,a4,a1
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    193c:	000a8513          	mv	a0,s5
    1940:	00048593          	mv	a1,s1
    1944:	368000ef          	jal	ra,1cac <__umodsi3>
    1948:	00050993          	mv	s3,a0
    194c:	00048593          	mv	a1,s1
    1950:	01091b93          	slli	s7,s2,0x10
    1954:	000a8513          	mv	a0,s5
    1958:	30c000ef          	jal	ra,1c64 <__udivsi3>
    195c:	010bdb93          	srli	s7,s7,0x10
    1960:	00050593          	mv	a1,a0
    1964:	000b8513          	mv	a0,s7
    1968:	2d0000ef          	jal	ra,1c38 <__mulsi3>
    196c:	01099993          	slli	s3,s3,0x10
    1970:	010b5793          	srli	a5,s6,0x10
    1974:	00f9e7b3          	or	a5,s3,a5
	      n0 = n0 << bm;
    1978:	014c9433          	sll	s0,s9,s4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    197c:	00a7fa63          	bleu	a0,a5,1990 <__umoddi3+0x258>
    1980:	012787b3          	add	a5,a5,s2
    1984:	0127e663          	bltu	a5,s2,1990 <__umoddi3+0x258>
    1988:	00a7f463          	bleu	a0,a5,1990 <__umoddi3+0x258>
    198c:	012787b3          	add	a5,a5,s2
    1990:	40a78ab3          	sub	s5,a5,a0
    1994:	00048593          	mv	a1,s1
    1998:	000a8513          	mv	a0,s5
    199c:	310000ef          	jal	ra,1cac <__umodsi3>
    19a0:	00050993          	mv	s3,a0
    19a4:	00048593          	mv	a1,s1
    19a8:	000a8513          	mv	a0,s5
    19ac:	2b8000ef          	jal	ra,1c64 <__udivsi3>
    19b0:	00050593          	mv	a1,a0
    19b4:	000b8513          	mv	a0,s7
    19b8:	280000ef          	jal	ra,1c38 <__mulsi3>
    19bc:	010b1593          	slli	a1,s6,0x10
    19c0:	01099993          	slli	s3,s3,0x10
    19c4:	0105d593          	srli	a1,a1,0x10
    19c8:	00b9e5b3          	or	a1,s3,a1
    19cc:	00a5fa63          	bleu	a0,a1,19e0 <__umoddi3+0x2a8>
    19d0:	012585b3          	add	a1,a1,s2
    19d4:	0125e663          	bltu	a1,s2,19e0 <__umoddi3+0x2a8>
    19d8:	00a5f463          	bleu	a0,a1,19e0 <__umoddi3+0x2a8>
    19dc:	012585b3          	add	a1,a1,s2
    19e0:	40a584b3          	sub	s1,a1,a0
    19e4:	df9ff06f          	j	17dc <__umoddi3+0xa4>
	  count_leading_zeros (bm, d0);
    19e8:	010007b7          	lui	a5,0x1000
    19ec:	01000a13          	li	s4,16
    19f0:	f0f96ae3          	bltu	s2,a5,1904 <__umoddi3+0x1cc>
    19f4:	01800a13          	li	s4,24
    19f8:	f0dff06f          	j	1904 <__umoddi3+0x1cc>
      if (d1 > n1)
    19fc:	e8d5e8e3          	bltu	a1,a3,188c <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    1a00:	000107b7          	lui	a5,0x10
    1a04:	04f6fc63          	bleu	a5,a3,1a5c <__umoddi3+0x324>
    1a08:	0ff00b93          	li	s7,255
    1a0c:	00dbb533          	sltu	a0,s7,a3
    1a10:	00351513          	slli	a0,a0,0x3
    1a14:	00020737          	lui	a4,0x20
    1a18:	00a6d7b3          	srl	a5,a3,a0
    1a1c:	1a070713          	addi	a4,a4,416 # 201a0 <__clz_tab>
    1a20:	00e787b3          	add	a5,a5,a4
    1a24:	0007cb83          	lbu	s7,0(a5) # 10000 <__modsi3+0xe320>
    1a28:	02000593          	li	a1,32
    1a2c:	00ab8bb3          	add	s7,s7,a0
    1a30:	41758b33          	sub	s6,a1,s7
	  if (bm == 0)
    1a34:	020b1e63          	bnez	s6,1a70 <__umoddi3+0x338>
	      if (n1 > d1 || n0 >= d0)
    1a38:	0136e463          	bltu	a3,s3,1a40 <__umoddi3+0x308>
    1a3c:	00ccea63          	bltu	s9,a2,1a50 <__umoddi3+0x318>
		  sub_ddmmss (n1, n0, n1, n0, d1, d0);
    1a40:	40cc8433          	sub	s0,s9,a2
    1a44:	40d986b3          	sub	a3,s3,a3
    1a48:	008cb533          	sltu	a0,s9,s0
    1a4c:	40a684b3          	sub	s1,a3,a0
		  *rp = rr.ll;
    1a50:	00040513          	mv	a0,s0
    1a54:	00048593          	mv	a1,s1
    1a58:	e35ff06f          	j	188c <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    1a5c:	010007b7          	lui	a5,0x1000
    1a60:	01000513          	li	a0,16
    1a64:	faf6e8e3          	bltu	a3,a5,1a14 <__umoddi3+0x2dc>
    1a68:	01800513          	li	a0,24
    1a6c:	fa9ff06f          	j	1a14 <__umoddi3+0x2dc>
	      d1 = (d1 << bm) | (d0 >> b);
    1a70:	016696b3          	sll	a3,a3,s6
    1a74:	01765d33          	srl	s10,a2,s7
    1a78:	00dd6d33          	or	s10,s10,a3
	      n2 = n1 >> b;
    1a7c:	0179d433          	srl	s0,s3,s7
	      n1 = (n1 << bm) | (n0 >> b);
    1a80:	016995b3          	sll	a1,s3,s6
    1a84:	017cdc33          	srl	s8,s9,s7
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1a88:	010d5493          	srli	s1,s10,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1a8c:	00bc6c33          	or	s8,s8,a1
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1a90:	00040513          	mv	a0,s0
    1a94:	00048593          	mv	a1,s1
	      d0 = d0 << bm;
    1a98:	01661ab3          	sll	s5,a2,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1a9c:	210000ef          	jal	ra,1cac <__umodsi3>
    1aa0:	00050a13          	mv	s4,a0
    1aa4:	00048593          	mv	a1,s1
    1aa8:	00040513          	mv	a0,s0
	      n0 = n0 << bm;
    1aac:	016c9933          	sll	s2,s9,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1ab0:	010d1c93          	slli	s9,s10,0x10
    1ab4:	1b0000ef          	jal	ra,1c64 <__udivsi3>
    1ab8:	010cdc93          	srli	s9,s9,0x10
    1abc:	00050413          	mv	s0,a0
    1ac0:	00050593          	mv	a1,a0
    1ac4:	000c8513          	mv	a0,s9
    1ac8:	170000ef          	jal	ra,1c38 <__mulsi3>
    1acc:	010a1a13          	slli	s4,s4,0x10
    1ad0:	010c5713          	srli	a4,s8,0x10
    1ad4:	00ea6733          	or	a4,s4,a4
    1ad8:	00040a13          	mv	s4,s0
    1adc:	00a77e63          	bleu	a0,a4,1af8 <__umoddi3+0x3c0>
    1ae0:	01a70733          	add	a4,a4,s10
    1ae4:	fff40a13          	addi	s4,s0,-1
    1ae8:	01a76863          	bltu	a4,s10,1af8 <__umoddi3+0x3c0>
    1aec:	00a77663          	bleu	a0,a4,1af8 <__umoddi3+0x3c0>
    1af0:	ffe40a13          	addi	s4,s0,-2
    1af4:	01a70733          	add	a4,a4,s10
    1af8:	40a709b3          	sub	s3,a4,a0
    1afc:	00048593          	mv	a1,s1
    1b00:	00098513          	mv	a0,s3
    1b04:	1a8000ef          	jal	ra,1cac <__umodsi3>
    1b08:	00048593          	mv	a1,s1
    1b0c:	00050413          	mv	s0,a0
    1b10:	00098513          	mv	a0,s3
    1b14:	150000ef          	jal	ra,1c64 <__udivsi3>
    1b18:	00050593          	mv	a1,a0
    1b1c:	00050493          	mv	s1,a0
    1b20:	000c8513          	mv	a0,s9
    1b24:	114000ef          	jal	ra,1c38 <__mulsi3>
    1b28:	010c1593          	slli	a1,s8,0x10
    1b2c:	01041413          	slli	s0,s0,0x10
    1b30:	0105d593          	srli	a1,a1,0x10
    1b34:	00b465b3          	or	a1,s0,a1
    1b38:	00048713          	mv	a4,s1
    1b3c:	00a5fe63          	bleu	a0,a1,1b58 <__umoddi3+0x420>
    1b40:	01a585b3          	add	a1,a1,s10
    1b44:	fff48713          	addi	a4,s1,-1
    1b48:	01a5e863          	bltu	a1,s10,1b58 <__umoddi3+0x420>
    1b4c:	00a5f663          	bleu	a0,a1,1b58 <__umoddi3+0x420>
    1b50:	ffe48713          	addi	a4,s1,-2
    1b54:	01a585b3          	add	a1,a1,s10
    1b58:	010a1a13          	slli	s4,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    1b5c:	00010cb7          	lui	s9,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1b60:	00ea6a33          	or	s4,s4,a4
	      umul_ppmm (m1, m0, q0, d0);
    1b64:	fffc8413          	addi	s0,s9,-1 # ffff <__modsi3+0xe31f>
    1b68:	008a77b3          	and	a5,s4,s0
    1b6c:	008af433          	and	s0,s5,s0
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1b70:	40a584b3          	sub	s1,a1,a0
	      umul_ppmm (m1, m0, q0, d0);
    1b74:	00078513          	mv	a0,a5
    1b78:	00040593          	mv	a1,s0
    1b7c:	00f12623          	sw	a5,12(sp)
    1b80:	010a5a13          	srli	s4,s4,0x10
    1b84:	0b4000ef          	jal	ra,1c38 <__mulsi3>
    1b88:	00050993          	mv	s3,a0
    1b8c:	00040593          	mv	a1,s0
    1b90:	000a0513          	mv	a0,s4
    1b94:	0a4000ef          	jal	ra,1c38 <__mulsi3>
    1b98:	010adc13          	srli	s8,s5,0x10
    1b9c:	00050d93          	mv	s11,a0
    1ba0:	000c0593          	mv	a1,s8
    1ba4:	000a0513          	mv	a0,s4
    1ba8:	090000ef          	jal	ra,1c38 <__mulsi3>
    1bac:	00c12783          	lw	a5,12(sp)
    1bb0:	00050a13          	mv	s4,a0
    1bb4:	000c0593          	mv	a1,s8
    1bb8:	00078513          	mv	a0,a5
    1bbc:	07c000ef          	jal	ra,1c38 <__mulsi3>
    1bc0:	01b50533          	add	a0,a0,s11
    1bc4:	0109d713          	srli	a4,s3,0x10
    1bc8:	00a70733          	add	a4,a4,a0
    1bcc:	01b77463          	bleu	s11,a4,1bd4 <__umoddi3+0x49c>
    1bd0:	019a0a33          	add	s4,s4,s9
    1bd4:	000107b7          	lui	a5,0x10
    1bd8:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe31f>
    1bdc:	01075593          	srli	a1,a4,0x10
    1be0:	00f77733          	and	a4,a4,a5
    1be4:	01071713          	slli	a4,a4,0x10
    1be8:	00f9f7b3          	and	a5,s3,a5
    1bec:	014585b3          	add	a1,a1,s4
    1bf0:	00f707b3          	add	a5,a4,a5
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1bf4:	00b4e663          	bltu	s1,a1,1c00 <__umoddi3+0x4c8>
    1bf8:	00b49e63          	bne	s1,a1,1c14 <__umoddi3+0x4dc>
    1bfc:	00f97c63          	bleu	a5,s2,1c14 <__umoddi3+0x4dc>
		  sub_ddmmss (m1, m0, m1, m0, d1, d0);
    1c00:	41578633          	sub	a2,a5,s5
    1c04:	00c7b7b3          	sltu	a5,a5,a2
    1c08:	41a585b3          	sub	a1,a1,s10
    1c0c:	40f585b3          	sub	a1,a1,a5
    1c10:	00060793          	mv	a5,a2
		  sub_ddmmss (n1, n0, n1, n0, m1, m0);
    1c14:	40f907b3          	sub	a5,s2,a5
    1c18:	00f93933          	sltu	s2,s2,a5
    1c1c:	40b485b3          	sub	a1,s1,a1
    1c20:	412585b3          	sub	a1,a1,s2
		  rr.s.low = (n1 << b) | (n0 >> bm);
    1c24:	01759433          	sll	s0,a1,s7
    1c28:	0167d7b3          	srl	a5,a5,s6
		  *rp = rr.ll;
    1c2c:	00f46533          	or	a0,s0,a5
    1c30:	0165d5b3          	srl	a1,a1,s6
  return w;
    1c34:	c59ff06f          	j	188c <__umoddi3+0x154>

00001c38 <__mulsi3>:
# define __muldi3 __mulsi3
#endif

  .globl __muldi3
__muldi3:
  mv     a2, a0
    1c38:	00050613          	mv	a2,a0
  li     a0, 0
    1c3c:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
    1c40:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
    1c44:	00068463          	beqz	a3,1c4c <__mulsi3+0x14>
  add    a0, a0, a2
    1c48:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
    1c4c:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
    1c50:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
    1c54:	fe0596e3          	bnez	a1,1c40 <__mulsi3+0x8>
  ret
    1c58:	00008067          	ret

00001c5c <__divsi3>:
  beq   a1, t0, .L20
#endif

  .globl __divdi3
__divdi3:
  bltz  a0, .L10
    1c5c:	06054063          	bltz	a0,1cbc <__umodsi3+0x10>
  bltz  a1, .L11
    1c60:	0605c663          	bltz	a1,1ccc <__umodsi3+0x20>

00001c64 <__udivsi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

  .globl __udivdi3
__udivdi3:
  mv    a2, a1
    1c64:	00058613          	mv	a2,a1
  mv    a1, a0
    1c68:	00050593          	mv	a1,a0
  li    a0, -1
    1c6c:	fff00513          	li	a0,-1
  beqz  a2, .L5
    1c70:	02060c63          	beqz	a2,1ca8 <__udivsi3+0x44>
  li    a3, 1
    1c74:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
    1c78:	00b67a63          	bleu	a1,a2,1c8c <__udivsi3+0x28>
.L1:
  blez  a2, .L2
    1c7c:	00c05863          	blez	a2,1c8c <__udivsi3+0x28>
  slli  a2, a2, 1
    1c80:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
    1c84:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
    1c88:	feb66ae3          	bltu	a2,a1,1c7c <__udivsi3+0x18>
.L2:
  li    a0, 0
    1c8c:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
    1c90:	00c5e663          	bltu	a1,a2,1c9c <__udivsi3+0x38>
  sub   a1, a1, a2
    1c94:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
    1c98:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
    1c9c:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
    1ca0:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
    1ca4:	fe0696e3          	bnez	a3,1c90 <__udivsi3+0x2c>
.L5:
  ret
    1ca8:	00008067          	ret

00001cac <__umodsi3>:

  .globl __umoddi3
__umoddi3:
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
    1cac:	00008293          	mv	t0,ra
  jal   __udivdi3
    1cb0:	fb5ff0ef          	jal	ra,1c64 <__udivsi3>
  move  a0, a1
    1cb4:	00058513          	mv	a0,a1
  jr    t0
    1cb8:	00028067          	jr	t0

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
    1cbc:	40a00533          	neg	a0,a0
  bgez  a1, .L12      /* Compute __udivdi3(-a0, a1), then negate the result.  */
    1cc0:	0005d863          	bgez	a1,1cd0 <__umodsi3+0x24>
  neg   a1, a1
    1cc4:	40b005b3          	neg	a1,a1
  j     __udivdi3     /* Compute __udivdi3(-a0, -a1).  */
    1cc8:	f9dff06f          	j	1c64 <__udivsi3>
.L11:                 /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
    1ccc:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
    1cd0:	00008293          	mv	t0,ra
  jal   __udivdi3
    1cd4:	f91ff0ef          	jal	ra,1c64 <__udivsi3>
  neg   a0, a0
    1cd8:	40a00533          	neg	a0,a0
  jr    t0
    1cdc:	00028067          	jr	t0

00001ce0 <__modsi3>:

  .globl __moddi3
__moddi3:
  move   t0, ra
    1ce0:	00008293          	mv	t0,ra
  bltz   a1, .L31
    1ce4:	0005ca63          	bltz	a1,1cf8 <__modsi3+0x18>
  bltz   a0, .L32
    1ce8:	00054c63          	bltz	a0,1d00 <__modsi3+0x20>
.L30:
  jal    __udivdi3    /* The dividend is not negative.  */
    1cec:	f79ff0ef          	jal	ra,1c64 <__udivsi3>
  move   a0, a1
    1cf0:	00058513          	mv	a0,a1
  jr     t0
    1cf4:	00028067          	jr	t0
.L31:
  neg    a1, a1
    1cf8:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
    1cfc:	fe0558e3          	bgez	a0,1cec <__modsi3+0xc>
.L32:
  neg    a0, a0
    1d00:	40a00533          	neg	a0,a0
  jal    __udivdi3    /* The dividend is hella negative.  */
    1d04:	f61ff0ef          	jal	ra,1c64 <__udivsi3>
  neg    a0, a1
    1d08:	40b00533          	neg	a0,a1
  jr     t0
    1d0c:	00028067          	jr	t0
