
Externals.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
       0:	00002fb7          	lui	t6,0x2
       4:	800f8f93          	addi	t6,t6,-2048 # 1800 <__umoddi3+0xac>
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
      cc:	aac18193          	addi	gp,gp,-1364 # 20b74 <_gp>

000000d0 <init_bss>:
      d0:	00020517          	auipc	a0,0x20
      d4:	3f050513          	addi	a0,a0,1008 # 204c0 <__bss_start>
      d8:	00020597          	auipc	a1,0x20
      dc:	4ec58593          	addi	a1,a1,1260 # 205c4 <tohost+0x4>
      e0:	00000613          	li	a2,0
      e4:	0f0000ef          	jal	ra,1d4 <fill_block>

000000e8 <init_sbss>:
      e8:	00020517          	auipc	a0,0x20
      ec:	28850513          	addi	a0,a0,648 # 20370 <num_ticks>
      f0:	00020597          	auipc	a1,0x20
      f4:	28058593          	addi	a1,a1,640 # 20370 <num_ticks>
      f8:	00000613          	li	a2,0
      fc:	0d8000ef          	jal	ra,1d4 <fill_block>

00000100 <write_stack_pattern>:
     100:	00021517          	auipc	a0,0x21
     104:	4c850513          	addi	a0,a0,1224 # 215c8 <_heap_end>
     108:	00022597          	auipc	a1,0x22
     10c:	4bc58593          	addi	a1,a1,1212 # 225c4 <_heap_end+0xffc>
     110:	ababb637          	lui	a2,0xababb
     114:	bab60613          	addi	a2,a2,-1109 # abababab <__stack+0xaba985e3>
     118:	0bc000ef          	jal	ra,1d4 <fill_block>

0000011c <init_stack>:
     11c:	00022117          	auipc	sp,0x22
     120:	4ac10113          	addi	sp,sp,1196 # 225c8 <__stack>
     124:	00001337          	lui	t1,0x1
     128:	88830313          	addi	t1,t1,-1912 # 888 <getint+0x78>
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
     2dc:	2e870713          	addi	a4,a4,744 # 205c0 <tohost>
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
     35c:	26878793          	addi	a5,a5,616 # 205c0 <tohost>
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
     384:	5b5000ef          	jal	ra,1138 <strlen>
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
     42c:	481000ef          	jal	ra,10ac <main>
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
     528:	f9c78793          	addi	a5,a5,-100 # 204c0 <__bss_start>
     52c:	0007a783          	lw	a5,0(a5)
     530:	00178693          	addi	a3,a5,1
     534:	00020717          	auipc	a4,0x20
     538:	f8c70713          	addi	a4,a4,-116 # 204c0 <__bss_start>
     53c:	00d72023          	sw	a3,0(a4)
     540:	00c12703          	lw	a4,12(sp)
     544:	0ff77713          	andi	a4,a4,255
     548:	00020697          	auipc	a3,0x20
     54c:	fb868693          	addi	a3,a3,-72 # 20500 <buf.2126>
     550:	00f687b3          	add	a5,a3,a5
     554:	00e78023          	sb	a4,0(a5)
     558:	00c12703          	lw	a4,12(sp)
     55c:	00a00793          	li	a5,10
     560:	00f70c63          	beq	a4,a5,578 <putchar+0x60>
     564:	00020797          	auipc	a5,0x20
     568:	f5c78793          	addi	a5,a5,-164 # 204c0 <__bss_start>
     56c:	0007a703          	lw	a4,0(a5)
     570:	04000793          	li	a5,64
     574:	02f71c63          	bne	a4,a5,5ac <putchar+0x94>
     578:	00020717          	auipc	a4,0x20
     57c:	f8870713          	addi	a4,a4,-120 # 20500 <buf.2126>
     580:	00020797          	auipc	a5,0x20
     584:	f4078793          	addi	a5,a5,-192 # 204c0 <__bss_start>
     588:	0007a783          	lw	a5,0(a5)
     58c:	00078693          	mv	a3,a5
     590:	00070613          	mv	a2,a4
     594:	00100593          	li	a1,1
     598:	04000513          	li	a0,64
     59c:	e19ff0ef          	jal	ra,3b4 <syscall>
     5a0:	00020797          	auipc	a5,0x20
     5a4:	f2078793          	addi	a5,a5,-224 # 204c0 <__bss_start>
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
     624:	130010ef          	jal	ra,1754 <__umoddi3>
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
     6a4:	2d5000ef          	jal	ra,1178 <__udivdi3>
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
     aa0:	6b4000ef          	jal	ra,1154 <strnlen>
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
     e00:	39370713          	addi	a4,a4,915 # 38393 <__stack+0x15dcb>
     e04:	00e5e733          	or	a4,a1,a4
     e08:	00e7a423          	sw	a4,8(a5)
     e0c:	00d67733          	and	a4,a2,a3
     e10:	01471693          	slli	a3,a4,0x14
     e14:	00030737          	lui	a4,0x30
     e18:	06770713          	addi	a4,a4,103 # 30067 <__stack+0xda9f>
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
     ea0:	00700713          	li	a4,7
     ea4:	04e78a63          	beq	a5,a4,ef8 <level_1_interrupt_handler+0x6c>
     ea8:	00b00713          	li	a4,11
     eac:	08e79863          	bne	a5,a4,f3c <level_1_interrupt_handler+0xb0>
     eb0:	000017b7          	lui	a5,0x1
     eb4:	80078293          	addi	t0,a5,-2048 # 800 <getuint+0x8c>
     eb8:	3442b073          	csrc	mip,t0
     ebc:	0c2007b7          	lui	a5,0xc200
     ec0:	00478793          	addi	a5,a5,4 # c200004 <__stack+0xc1dda3c>
     ec4:	0007a783          	lw	a5,0(a5)
     ec8:	00f12e23          	sw	a5,28(sp)
     ecc:	0001f717          	auipc	a4,0x1f
     ed0:	4c470713          	addi	a4,a4,1220 # 20390 <__data_start>
     ed4:	01c12783          	lw	a5,28(sp)
     ed8:	00279793          	slli	a5,a5,0x2
     edc:	00f707b3          	add	a5,a4,a5
     ee0:	0007a783          	lw	a5,0(a5)
     ee4:	000780e7          	jalr	a5
     ee8:	0c2007b7          	lui	a5,0xc200
     eec:	00478793          	addi	a5,a5,4 # c200004 <__stack+0xc1dda3c>
     ef0:	0007a023          	sw	zero,0(a5)
     ef4:	0480006f          	j	f3c <level_1_interrupt_handler+0xb0>
     ef8:	0001f797          	auipc	a5,0x1f
     efc:	64878793          	addi	a5,a5,1608 # 20540 <timer_irq_handler>
     f00:	0007a783          	lw	a5,0(a5)
     f04:	00078c63          	beqz	a5,f1c <level_1_interrupt_handler+0x90>
     f08:	0001f797          	auipc	a5,0x1f
     f0c:	63878793          	addi	a5,a5,1592 # 20540 <timer_irq_handler>
     f10:	0007a783          	lw	a5,0(a5)
     f14:	000780e7          	jalr	a5
     f18:	0240006f          	j	f3c <level_1_interrupt_handler+0xb0>
     f1c:	0001f797          	auipc	a5,0x1f
     f20:	46078793          	addi	a5,a5,1120 # 2037c <mtimecmp>
     f24:	0007a783          	lw	a5,0(a5)
     f28:	00000693          	li	a3,0
     f2c:	00000713          	li	a4,0
     f30:	00d7a023          	sw	a3,0(a5)
     f34:	00e7a223          	sw	a4,4(a5)
     f38:	00000013          	nop
     f3c:	02c12083          	lw	ra,44(sp)
     f40:	03010113          	addi	sp,sp,48
     f44:	00008067          	ret

00000f48 <register_timer_interrupt_handler>:
     f48:	ff010113          	addi	sp,sp,-16
     f4c:	00a12623          	sw	a0,12(sp)
     f50:	0001f797          	auipc	a5,0x1f
     f54:	5f078793          	addi	a5,a5,1520 # 20540 <timer_irq_handler>
     f58:	00c12703          	lw	a4,12(sp)
     f5c:	00e7a023          	sw	a4,0(a5)
     f60:	00000013          	nop
     f64:	01010113          	addi	sp,sp,16
     f68:	00008067          	ret

00000f6c <register_interrupt_handler>:
     f6c:	ff010113          	addi	sp,sp,-16
     f70:	00a12623          	sw	a0,12(sp)
     f74:	00b12423          	sw	a1,8(sp)
     f78:	0001f717          	auipc	a4,0x1f
     f7c:	41870713          	addi	a4,a4,1048 # 20390 <__data_start>
     f80:	00c12783          	lw	a5,12(sp)
     f84:	00279793          	slli	a5,a5,0x2
     f88:	00f707b3          	add	a5,a4,a5
     f8c:	00812703          	lw	a4,8(sp)
     f90:	00e7a023          	sw	a4,0(a5)
     f94:	00000013          	nop
     f98:	01010113          	addi	sp,sp,16
     f9c:	00008067          	ret

00000fa0 <set_next_timer_interrupt>:
     fa0:	0001f797          	auipc	a5,0x1f
     fa4:	3d878793          	addi	a5,a5,984 # 20378 <mtime>
     fa8:	0007a783          	lw	a5,0(a5)
     fac:	0047a803          	lw	a6,4(a5)
     fb0:	0007a783          	lw	a5,0(a5)
     fb4:	0001f717          	auipc	a4,0x1f
     fb8:	3c870713          	addi	a4,a4,968 # 2037c <mtimecmp>
     fbc:	00072503          	lw	a0,0(a4)
     fc0:	000f45b7          	lui	a1,0xf4
     fc4:	24058593          	addi	a1,a1,576 # f4240 <__stack+0xd1c78>
     fc8:	00000613          	li	a2,0
     fcc:	00b786b3          	add	a3,a5,a1
     fd0:	00068893          	mv	a7,a3
     fd4:	00f8b8b3          	sltu	a7,a7,a5
     fd8:	00c80733          	add	a4,a6,a2
     fdc:	00e887b3          	add	a5,a7,a4
     fe0:	00078713          	mv	a4,a5
     fe4:	00068793          	mv	a5,a3
     fe8:	00070813          	mv	a6,a4
     fec:	00f52023          	sw	a5,0(a0)
     ff0:	01052223          	sw	a6,4(a0)
     ff4:	00000013          	nop
     ff8:	00008067          	ret

00000ffc <timer_irq_handler>:
     ffc:	ff010113          	addi	sp,sp,-16
    1000:	00112623          	sw	ra,12(sp)
    1004:	0001f797          	auipc	a5,0x1f
    1008:	36c78793          	addi	a5,a5,876 # 20370 <num_ticks>
    100c:	0007a783          	lw	a5,0(a5)
    1010:	00178713          	addi	a4,a5,1
    1014:	0001f797          	auipc	a5,0x1f
    1018:	35c78793          	addi	a5,a5,860 # 20370 <num_ticks>
    101c:	00e7a023          	sw	a4,0(a5)
    1020:	f81ff0ef          	jal	ra,fa0 <set_next_timer_interrupt>
    1024:	0001f797          	auipc	a5,0x1f
    1028:	34c78793          	addi	a5,a5,844 # 20370 <num_ticks>
    102c:	0007a783          	lw	a5,0(a5)
    1030:	00078593          	mv	a1,a5
    1034:	0001f517          	auipc	a0,0x1f
    1038:	14850513          	addi	a0,a0,328 # 2017c <__rodata_start+0x17c>
    103c:	c99ff0ef          	jal	ra,cd4 <printf>
    1040:	00000013          	nop
    1044:	00c12083          	lw	ra,12(sp)
    1048:	01010113          	addi	sp,sp,16
    104c:	00008067          	ret

00001050 <external_1_handler>:
    1050:	ff010113          	addi	sp,sp,-16
    1054:	00112623          	sw	ra,12(sp)
    1058:	0001f517          	auipc	a0,0x1f
    105c:	13850513          	addi	a0,a0,312 # 20190 <__rodata_start+0x190>
    1060:	c75ff0ef          	jal	ra,cd4 <printf>
    1064:	0c0017b7          	lui	a5,0xc001
    1068:	0007a023          	sw	zero,0(a5) # c001000 <__stack+0xbfdea38>
    106c:	00000013          	nop
    1070:	00c12083          	lw	ra,12(sp)
    1074:	01010113          	addi	sp,sp,16
    1078:	00008067          	ret

0000107c <external_2_handler>:
    107c:	ff010113          	addi	sp,sp,-16
    1080:	00112623          	sw	ra,12(sp)
    1084:	0001f517          	auipc	a0,0x1f
    1088:	12050513          	addi	a0,a0,288 # 201a4 <__rodata_start+0x1a4>
    108c:	c49ff0ef          	jal	ra,cd4 <printf>
    1090:	0c0017b7          	lui	a5,0xc001
    1094:	00478793          	addi	a5,a5,4 # c001004 <__stack+0xbfdea3c>
    1098:	0007a023          	sw	zero,0(a5)
    109c:	00000013          	nop
    10a0:	00c12083          	lw	ra,12(sp)
    10a4:	01010113          	addi	sp,sp,16
    10a8:	00008067          	ret

000010ac <main>:
    10ac:	ff010113          	addi	sp,sp,-16
    10b0:	00112623          	sw	ra,12(sp)
    10b4:	00000597          	auipc	a1,0x0
    10b8:	f9c58593          	addi	a1,a1,-100 # 1050 <external_1_handler>
    10bc:	00100513          	li	a0,1
    10c0:	eadff0ef          	jal	ra,f6c <register_interrupt_handler>
    10c4:	00000597          	auipc	a1,0x0
    10c8:	fb858593          	addi	a1,a1,-72 # 107c <external_2_handler>
    10cc:	00200513          	li	a0,2
    10d0:	e9dff0ef          	jal	ra,f6c <register_interrupt_handler>
    10d4:	00000517          	auipc	a0,0x0
    10d8:	f2850513          	addi	a0,a0,-216 # ffc <timer_irq_handler>
    10dc:	e6dff0ef          	jal	ra,f48 <register_timer_interrupt_handler>
    10e0:	ec1ff0ef          	jal	ra,fa0 <set_next_timer_interrupt>
    10e4:	0c0007b7          	lui	a5,0xc000
    10e8:	00100713          	li	a4,1
    10ec:	00e7a023          	sw	a4,0(a5) # c000000 <__stack+0xbfdda38>
    10f0:	0c0007b7          	lui	a5,0xc000
    10f4:	00478793          	addi	a5,a5,4 # c000004 <__stack+0xbfdda3c>
    10f8:	00200713          	li	a4,2
    10fc:	00e7a023          	sw	a4,0(a5)
    1100:	0c0027b7          	lui	a5,0xc002
    1104:	00300713          	li	a4,3
    1108:	00e7a023          	sw	a4,0(a5) # c002000 <__stack+0xbfdfa38>
    110c:	00000013          	nop
    1110:	0001f797          	auipc	a5,0x1f
    1114:	26078793          	addi	a5,a5,608 # 20370 <num_ticks>
    1118:	0007a703          	lw	a4,0(a5)
    111c:	00500793          	li	a5,5
    1120:	fee7f8e3          	bleu	a4,a5,1110 <main+0x64>
    1124:	00000793          	li	a5,0
    1128:	00078513          	mv	a0,a5
    112c:	00c12083          	lw	ra,12(sp)
    1130:	01010113          	addi	sp,sp,16
    1134:	00008067          	ret

00001138 <strlen>:
    1138:	00050793          	mv	a5,a0
    113c:	00178793          	addi	a5,a5,1
    1140:	fff7c703          	lbu	a4,-1(a5)
    1144:	fe071ce3          	bnez	a4,113c <strlen+0x4>
    1148:	40a78533          	sub	a0,a5,a0
    114c:	fff50513          	addi	a0,a0,-1
    1150:	00008067          	ret

00001154 <strnlen>:
    1154:	00b505b3          	add	a1,a0,a1
    1158:	00050793          	mv	a5,a0
    115c:	00b78663          	beq	a5,a1,1168 <strnlen+0x14>
    1160:	0007c703          	lbu	a4,0(a5)
    1164:	00071663          	bnez	a4,1170 <strnlen+0x1c>
    1168:	40a78533          	sub	a0,a5,a0
    116c:	00008067          	ret
    1170:	00178793          	addi	a5,a5,1
    1174:	fe9ff06f          	j	115c <strnlen+0x8>

00001178 <__udivdi3>:
#endif

#ifdef L_udivdi3
UDWtype
__udivdi3 (UDWtype n, UDWtype d)
{
    1178:	fd010113          	addi	sp,sp,-48
    117c:	01612823          	sw	s6,16(sp)
    1180:	01712623          	sw	s7,12(sp)
    1184:	02112623          	sw	ra,44(sp)
    1188:	02812423          	sw	s0,40(sp)
    118c:	02912223          	sw	s1,36(sp)
    1190:	03212023          	sw	s2,32(sp)
    1194:	01312e23          	sw	s3,28(sp)
    1198:	01412c23          	sw	s4,24(sp)
    119c:	01512a23          	sw	s5,20(sp)
    11a0:	01812423          	sw	s8,8(sp)
    11a4:	01912223          	sw	s9,4(sp)
    11a8:	01a12023          	sw	s10,0(sp)
    11ac:	00050b13          	mv	s6,a0
    11b0:	00058b93          	mv	s7,a1
  if (d1 == 0)
    11b4:	38069e63          	bnez	a3,1550 <__udivdi3+0x3d8>
    11b8:	00020937          	lui	s2,0x20
    11bc:	00060493          	mv	s1,a2
    11c0:	00050a13          	mv	s4,a0
    11c4:	1b890913          	addi	s2,s2,440 # 201b8 <__clz_tab>
      if (d0 > n1)
    11c8:	12c5f863          	bleu	a2,a1,12f8 <__udivdi3+0x180>
	  count_leading_zeros (bm, d0);
    11cc:	000107b7          	lui	a5,0x10
    11d0:	00058413          	mv	s0,a1
    11d4:	10f67863          	bleu	a5,a2,12e4 <__udivdi3+0x16c>
    11d8:	0ff00713          	li	a4,255
    11dc:	00c73733          	sltu	a4,a4,a2
    11e0:	00371713          	slli	a4,a4,0x3
    11e4:	00e657b3          	srl	a5,a2,a4
    11e8:	00f90933          	add	s2,s2,a5
    11ec:	00094683          	lbu	a3,0(s2)
    11f0:	00e68733          	add	a4,a3,a4
    11f4:	02000693          	li	a3,32
    11f8:	40e686b3          	sub	a3,a3,a4
	  if (bm != 0)
    11fc:	00068c63          	beqz	a3,1214 <__udivdi3+0x9c>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    1200:	00db9433          	sll	s0,s7,a3
    1204:	00eb5733          	srl	a4,s6,a4
	      d0 = d0 << bm;
    1208:	00d614b3          	sll	s1,a2,a3
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    120c:	00876433          	or	s0,a4,s0
	      n0 = n0 << bm;
    1210:	00db1a33          	sll	s4,s6,a3
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    1214:	0104da93          	srli	s5,s1,0x10
    1218:	000a8593          	mv	a1,s5
    121c:	00040513          	mv	a0,s0
    1220:	2a9000ef          	jal	ra,1cc8 <__umodsi3>
    1224:	00050993          	mv	s3,a0
    1228:	000a8593          	mv	a1,s5
    122c:	00040513          	mv	a0,s0
    1230:	01049b13          	slli	s6,s1,0x10
    1234:	24d000ef          	jal	ra,1c80 <__udivsi3>
    1238:	010b5b13          	srli	s6,s6,0x10
    123c:	00050913          	mv	s2,a0
    1240:	00050593          	mv	a1,a0
    1244:	000b0513          	mv	a0,s6
    1248:	20d000ef          	jal	ra,1c54 <__mulsi3>
    124c:	01099993          	slli	s3,s3,0x10
    1250:	010a5793          	srli	a5,s4,0x10
    1254:	00f9e7b3          	or	a5,s3,a5
    1258:	00090413          	mv	s0,s2
    125c:	00a7fe63          	bleu	a0,a5,1278 <__udivdi3+0x100>
    1260:	009787b3          	add	a5,a5,s1
    1264:	fff90413          	addi	s0,s2,-1
    1268:	0097e863          	bltu	a5,s1,1278 <__udivdi3+0x100>
    126c:	00a7f663          	bleu	a0,a5,1278 <__udivdi3+0x100>
    1270:	ffe90413          	addi	s0,s2,-2
    1274:	009787b3          	add	a5,a5,s1
    1278:	40a78933          	sub	s2,a5,a0
    127c:	000a8593          	mv	a1,s5
    1280:	00090513          	mv	a0,s2
    1284:	245000ef          	jal	ra,1cc8 <__umodsi3>
    1288:	00050993          	mv	s3,a0
    128c:	000a8593          	mv	a1,s5
    1290:	00090513          	mv	a0,s2
    1294:	1ed000ef          	jal	ra,1c80 <__udivsi3>
    1298:	010a1a13          	slli	s4,s4,0x10
    129c:	00050913          	mv	s2,a0
    12a0:	00050593          	mv	a1,a0
    12a4:	01099993          	slli	s3,s3,0x10
    12a8:	000b0513          	mv	a0,s6
    12ac:	010a5a13          	srli	s4,s4,0x10
    12b0:	1a5000ef          	jal	ra,1c54 <__mulsi3>
    12b4:	0149ea33          	or	s4,s3,s4
    12b8:	00090613          	mv	a2,s2
    12bc:	00aa7c63          	bleu	a0,s4,12d4 <__udivdi3+0x15c>
    12c0:	01448a33          	add	s4,s1,s4
    12c4:	fff90613          	addi	a2,s2,-1
    12c8:	009a6663          	bltu	s4,s1,12d4 <__udivdi3+0x15c>
    12cc:	00aa7463          	bleu	a0,s4,12d4 <__udivdi3+0x15c>
    12d0:	ffe90613          	addi	a2,s2,-2
    12d4:	01041413          	slli	s0,s0,0x10
    12d8:	00c46433          	or	s0,s0,a2
	      q1 = 0;
    12dc:	00000a93          	li	s5,0
    12e0:	1300006f          	j	1410 <__udivdi3+0x298>
	  count_leading_zeros (bm, d0);
    12e4:	010007b7          	lui	a5,0x1000
    12e8:	01000713          	li	a4,16
    12ec:	eef66ce3          	bltu	a2,a5,11e4 <__udivdi3+0x6c>
    12f0:	01800713          	li	a4,24
    12f4:	ef1ff06f          	j	11e4 <__udivdi3+0x6c>
    12f8:	00068993          	mv	s3,a3
	  if (d0 == 0)
    12fc:	00061a63          	bnez	a2,1310 <__udivdi3+0x198>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    1300:	00000593          	li	a1,0
    1304:	00100513          	li	a0,1
    1308:	179000ef          	jal	ra,1c80 <__udivsi3>
    130c:	00050493          	mv	s1,a0
	  count_leading_zeros (bm, d0);
    1310:	000107b7          	lui	a5,0x10
    1314:	12f4fe63          	bleu	a5,s1,1450 <__udivdi3+0x2d8>
    1318:	0ff00793          	li	a5,255
    131c:	0097f463          	bleu	s1,a5,1324 <__udivdi3+0x1ac>
    1320:	00800993          	li	s3,8
    1324:	0134d7b3          	srl	a5,s1,s3
    1328:	00f90933          	add	s2,s2,a5
    132c:	00094703          	lbu	a4,0(s2)
    1330:	02000693          	li	a3,32
    1334:	01370733          	add	a4,a4,s3
    1338:	40e686b3          	sub	a3,a3,a4
	  if (bm == 0)
    133c:	12069463          	bnez	a3,1464 <__udivdi3+0x2ec>
	      n1 -= d0;
    1340:	409b8433          	sub	s0,s7,s1
	      q1 = 1;
    1344:	00100a93          	li	s5,1
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    1348:	0104db13          	srli	s6,s1,0x10
    134c:	000b0593          	mv	a1,s6
    1350:	00040513          	mv	a0,s0
    1354:	175000ef          	jal	ra,1cc8 <__umodsi3>
    1358:	00050993          	mv	s3,a0
    135c:	000b0593          	mv	a1,s6
    1360:	00040513          	mv	a0,s0
    1364:	01049b93          	slli	s7,s1,0x10
    1368:	119000ef          	jal	ra,1c80 <__udivsi3>
    136c:	010bdb93          	srli	s7,s7,0x10
    1370:	00050913          	mv	s2,a0
    1374:	00050593          	mv	a1,a0
    1378:	000b8513          	mv	a0,s7
    137c:	0d9000ef          	jal	ra,1c54 <__mulsi3>
    1380:	01099993          	slli	s3,s3,0x10
    1384:	010a5793          	srli	a5,s4,0x10
    1388:	00f9e7b3          	or	a5,s3,a5
    138c:	00090413          	mv	s0,s2
    1390:	00a7fe63          	bleu	a0,a5,13ac <__udivdi3+0x234>
    1394:	009787b3          	add	a5,a5,s1
    1398:	fff90413          	addi	s0,s2,-1
    139c:	0097e863          	bltu	a5,s1,13ac <__udivdi3+0x234>
    13a0:	00a7f663          	bleu	a0,a5,13ac <__udivdi3+0x234>
    13a4:	ffe90413          	addi	s0,s2,-2
    13a8:	009787b3          	add	a5,a5,s1
    13ac:	40a78933          	sub	s2,a5,a0
    13b0:	000b0593          	mv	a1,s6
    13b4:	00090513          	mv	a0,s2
    13b8:	111000ef          	jal	ra,1cc8 <__umodsi3>
    13bc:	00050993          	mv	s3,a0
    13c0:	000b0593          	mv	a1,s6
    13c4:	00090513          	mv	a0,s2
    13c8:	0b9000ef          	jal	ra,1c80 <__udivsi3>
    13cc:	010a1a13          	slli	s4,s4,0x10
    13d0:	00050913          	mv	s2,a0
    13d4:	00050593          	mv	a1,a0
    13d8:	01099993          	slli	s3,s3,0x10
    13dc:	000b8513          	mv	a0,s7
    13e0:	010a5a13          	srli	s4,s4,0x10
    13e4:	071000ef          	jal	ra,1c54 <__mulsi3>
    13e8:	0149ea33          	or	s4,s3,s4
    13ec:	00090613          	mv	a2,s2
    13f0:	00aa7c63          	bleu	a0,s4,1408 <__udivdi3+0x290>
    13f4:	01448a33          	add	s4,s1,s4
    13f8:	fff90613          	addi	a2,s2,-1
    13fc:	009a6663          	bltu	s4,s1,1408 <__udivdi3+0x290>
    1400:	00aa7463          	bleu	a0,s4,1408 <__udivdi3+0x290>
    1404:	ffe90613          	addi	a2,s2,-2
    1408:	01041413          	slli	s0,s0,0x10
    140c:	00c46433          	or	s0,s0,a2
  return __udivmoddi4 (n, d, (UDWtype *) 0);
}
    1410:	00040513          	mv	a0,s0
    1414:	000a8593          	mv	a1,s5
    1418:	02c12083          	lw	ra,44(sp)
    141c:	02812403          	lw	s0,40(sp)
    1420:	02412483          	lw	s1,36(sp)
    1424:	02012903          	lw	s2,32(sp)
    1428:	01c12983          	lw	s3,28(sp)
    142c:	01812a03          	lw	s4,24(sp)
    1430:	01412a83          	lw	s5,20(sp)
    1434:	01012b03          	lw	s6,16(sp)
    1438:	00c12b83          	lw	s7,12(sp)
    143c:	00812c03          	lw	s8,8(sp)
    1440:	00412c83          	lw	s9,4(sp)
    1444:	00012d03          	lw	s10,0(sp)
    1448:	03010113          	addi	sp,sp,48
    144c:	00008067          	ret
	  count_leading_zeros (bm, d0);
    1450:	010007b7          	lui	a5,0x1000
    1454:	01000993          	li	s3,16
    1458:	ecf4e6e3          	bltu	s1,a5,1324 <__udivdi3+0x1ac>
    145c:	01800993          	li	s3,24
    1460:	ec5ff06f          	j	1324 <__udivdi3+0x1ac>
	      d0 = d0 << bm;
    1464:	00d494b3          	sll	s1,s1,a3
	      n2 = n1 >> b;
    1468:	00ebd9b3          	srl	s3,s7,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    146c:	0104d413          	srli	s0,s1,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1470:	00eb5733          	srl	a4,s6,a4
    1474:	00db9bb3          	sll	s7,s7,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1478:	00040593          	mv	a1,s0
    147c:	00098513          	mv	a0,s3
	      n1 = (n1 << bm) | (n0 >> b);
    1480:	01776bb3          	or	s7,a4,s7
	      n0 = n0 << bm;
    1484:	00db1a33          	sll	s4,s6,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1488:	041000ef          	jal	ra,1cc8 <__umodsi3>
    148c:	00050913          	mv	s2,a0
    1490:	00040593          	mv	a1,s0
    1494:	00098513          	mv	a0,s3
    1498:	01049b13          	slli	s6,s1,0x10
    149c:	7e4000ef          	jal	ra,1c80 <__udivsi3>
    14a0:	010b5b13          	srli	s6,s6,0x10
    14a4:	00050993          	mv	s3,a0
    14a8:	00050593          	mv	a1,a0
    14ac:	000b0513          	mv	a0,s6
    14b0:	7a4000ef          	jal	ra,1c54 <__mulsi3>
    14b4:	01091913          	slli	s2,s2,0x10
    14b8:	010bd713          	srli	a4,s7,0x10
    14bc:	00e96733          	or	a4,s2,a4
    14c0:	00098a93          	mv	s5,s3
    14c4:	00a77e63          	bleu	a0,a4,14e0 <__udivdi3+0x368>
    14c8:	00970733          	add	a4,a4,s1
    14cc:	fff98a93          	addi	s5,s3,-1
    14d0:	00976863          	bltu	a4,s1,14e0 <__udivdi3+0x368>
    14d4:	00a77663          	bleu	a0,a4,14e0 <__udivdi3+0x368>
    14d8:	ffe98a93          	addi	s5,s3,-2
    14dc:	00970733          	add	a4,a4,s1
    14e0:	40a709b3          	sub	s3,a4,a0
    14e4:	00040593          	mv	a1,s0
    14e8:	00098513          	mv	a0,s3
    14ec:	7dc000ef          	jal	ra,1cc8 <__umodsi3>
    14f0:	00040593          	mv	a1,s0
    14f4:	00050913          	mv	s2,a0
    14f8:	00098513          	mv	a0,s3
    14fc:	784000ef          	jal	ra,1c80 <__udivsi3>
    1500:	00050413          	mv	s0,a0
    1504:	00050593          	mv	a1,a0
    1508:	000b0513          	mv	a0,s6
    150c:	748000ef          	jal	ra,1c54 <__mulsi3>
    1510:	010b9713          	slli	a4,s7,0x10
    1514:	01075713          	srli	a4,a4,0x10
    1518:	01091913          	slli	s2,s2,0x10
    151c:	00e967b3          	or	a5,s2,a4
    1520:	00040713          	mv	a4,s0
    1524:	00a7fe63          	bleu	a0,a5,1540 <__udivdi3+0x3c8>
    1528:	009787b3          	add	a5,a5,s1
    152c:	fff40713          	addi	a4,s0,-1
    1530:	0097e863          	bltu	a5,s1,1540 <__udivdi3+0x3c8>
    1534:	00a7f663          	bleu	a0,a5,1540 <__udivdi3+0x3c8>
    1538:	ffe40713          	addi	a4,s0,-2
    153c:	009787b3          	add	a5,a5,s1
    1540:	010a9a93          	slli	s5,s5,0x10
    1544:	40a78433          	sub	s0,a5,a0
    1548:	00eaeab3          	or	s5,s5,a4
    154c:	dfdff06f          	j	1348 <__udivdi3+0x1d0>
      if (d1 > n1)
    1550:	1ed5ec63          	bltu	a1,a3,1748 <__udivdi3+0x5d0>
	  count_leading_zeros (bm, d1);
    1554:	000107b7          	lui	a5,0x10
    1558:	04f6f463          	bleu	a5,a3,15a0 <__udivdi3+0x428>
    155c:	0ff00713          	li	a4,255
    1560:	00d735b3          	sltu	a1,a4,a3
    1564:	00359593          	slli	a1,a1,0x3
    1568:	00020737          	lui	a4,0x20
    156c:	1b870713          	addi	a4,a4,440 # 201b8 <__clz_tab>
    1570:	00b6d7b3          	srl	a5,a3,a1
    1574:	00e787b3          	add	a5,a5,a4
    1578:	0007c703          	lbu	a4,0(a5) # 10000 <__modsi3+0xe304>
    157c:	02000a93          	li	s5,32
    1580:	00b70733          	add	a4,a4,a1
    1584:	40ea8ab3          	sub	s5,s5,a4
	  if (bm == 0)
    1588:	020a9663          	bnez	s5,15b4 <__udivdi3+0x43c>
		  q0 = 1;
    158c:	00100413          	li	s0,1
	      if (n1 > d1 || n0 >= d0)
    1590:	e976e0e3          	bltu	a3,s7,1410 <__udivdi3+0x298>
    1594:	00cb3633          	sltu	a2,s6,a2
    1598:	00164413          	xori	s0,a2,1
    159c:	e75ff06f          	j	1410 <__udivdi3+0x298>
	  count_leading_zeros (bm, d1);
    15a0:	010007b7          	lui	a5,0x1000
    15a4:	01000593          	li	a1,16
    15a8:	fcf6e0e3          	bltu	a3,a5,1568 <__udivdi3+0x3f0>
    15ac:	01800593          	li	a1,24
    15b0:	fb9ff06f          	j	1568 <__udivdi3+0x3f0>
	      d1 = (d1 << bm) | (d0 >> b);
    15b4:	00e65cb3          	srl	s9,a2,a4
    15b8:	015696b3          	sll	a3,a3,s5
    15bc:	00dcecb3          	or	s9,s9,a3
	      n2 = n1 >> b;
    15c0:	00ebd4b3          	srl	s1,s7,a4
	      n1 = (n1 << bm) | (n0 >> b);
    15c4:	015b97b3          	sll	a5,s7,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    15c8:	010cdb93          	srli	s7,s9,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    15cc:	00eb5733          	srl	a4,s6,a4
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    15d0:	000b8593          	mv	a1,s7
    15d4:	00048513          	mv	a0,s1
	      n1 = (n1 << bm) | (n0 >> b);
    15d8:	00f76433          	or	s0,a4,a5
	      d0 = d0 << bm;
    15dc:	015619b3          	sll	s3,a2,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    15e0:	6e8000ef          	jal	ra,1cc8 <__umodsi3>
    15e4:	00050913          	mv	s2,a0
    15e8:	000b8593          	mv	a1,s7
    15ec:	00048513          	mv	a0,s1
    15f0:	010c9c13          	slli	s8,s9,0x10
    15f4:	68c000ef          	jal	ra,1c80 <__udivsi3>
    15f8:	010c5c13          	srli	s8,s8,0x10
    15fc:	00050493          	mv	s1,a0
    1600:	00050593          	mv	a1,a0
    1604:	000c0513          	mv	a0,s8
    1608:	64c000ef          	jal	ra,1c54 <__mulsi3>
    160c:	01091913          	slli	s2,s2,0x10
    1610:	01045713          	srli	a4,s0,0x10
    1614:	00e96733          	or	a4,s2,a4
    1618:	00048a13          	mv	s4,s1
    161c:	00a77e63          	bleu	a0,a4,1638 <__udivdi3+0x4c0>
    1620:	01970733          	add	a4,a4,s9
    1624:	fff48a13          	addi	s4,s1,-1
    1628:	01976863          	bltu	a4,s9,1638 <__udivdi3+0x4c0>
    162c:	00a77663          	bleu	a0,a4,1638 <__udivdi3+0x4c0>
    1630:	ffe48a13          	addi	s4,s1,-2
    1634:	01970733          	add	a4,a4,s9
    1638:	40a704b3          	sub	s1,a4,a0
    163c:	000b8593          	mv	a1,s7
    1640:	00048513          	mv	a0,s1
    1644:	684000ef          	jal	ra,1cc8 <__umodsi3>
    1648:	00050913          	mv	s2,a0
    164c:	000b8593          	mv	a1,s7
    1650:	00048513          	mv	a0,s1
    1654:	62c000ef          	jal	ra,1c80 <__udivsi3>
    1658:	00050493          	mv	s1,a0
    165c:	00050593          	mv	a1,a0
    1660:	000c0513          	mv	a0,s8
    1664:	5f0000ef          	jal	ra,1c54 <__mulsi3>
    1668:	01041793          	slli	a5,s0,0x10
    166c:	01091913          	slli	s2,s2,0x10
    1670:	0107d793          	srli	a5,a5,0x10
    1674:	00f967b3          	or	a5,s2,a5
    1678:	00048613          	mv	a2,s1
    167c:	00a7fe63          	bleu	a0,a5,1698 <__udivdi3+0x520>
    1680:	019787b3          	add	a5,a5,s9
    1684:	fff48613          	addi	a2,s1,-1
    1688:	0197e863          	bltu	a5,s9,1698 <__udivdi3+0x520>
    168c:	00a7f663          	bleu	a0,a5,1698 <__udivdi3+0x520>
    1690:	ffe48613          	addi	a2,s1,-2
    1694:	019787b3          	add	a5,a5,s9
    1698:	010a1413          	slli	s0,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    169c:	00010bb7          	lui	s7,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    16a0:	00c46433          	or	s0,s0,a2
	      umul_ppmm (m1, m0, q0, d0);
    16a4:	fffb8913          	addi	s2,s7,-1 # ffff <__modsi3+0xe303>
    16a8:	01247d33          	and	s10,s0,s2
    16ac:	0129f933          	and	s2,s3,s2
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    16b0:	40a784b3          	sub	s1,a5,a0
	      umul_ppmm (m1, m0, q0, d0);
    16b4:	00090593          	mv	a1,s2
    16b8:	000d0513          	mv	a0,s10
    16bc:	598000ef          	jal	ra,1c54 <__mulsi3>
    16c0:	01045c93          	srli	s9,s0,0x10
    16c4:	00090593          	mv	a1,s2
    16c8:	00050a13          	mv	s4,a0
    16cc:	000c8513          	mv	a0,s9
    16d0:	584000ef          	jal	ra,1c54 <__mulsi3>
    16d4:	0109d993          	srli	s3,s3,0x10
    16d8:	00050c13          	mv	s8,a0
    16dc:	00098593          	mv	a1,s3
    16e0:	000c8513          	mv	a0,s9
    16e4:	570000ef          	jal	ra,1c54 <__mulsi3>
    16e8:	00050913          	mv	s2,a0
    16ec:	00098593          	mv	a1,s3
    16f0:	000d0513          	mv	a0,s10
    16f4:	560000ef          	jal	ra,1c54 <__mulsi3>
    16f8:	01850533          	add	a0,a0,s8
    16fc:	010a5793          	srli	a5,s4,0x10
    1700:	00a78533          	add	a0,a5,a0
    1704:	01857463          	bleu	s8,a0,170c <__udivdi3+0x594>
    1708:	01790933          	add	s2,s2,s7
    170c:	01055793          	srli	a5,a0,0x10
    1710:	012787b3          	add	a5,a5,s2
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1714:	02f4e663          	bltu	s1,a5,1740 <__udivdi3+0x5c8>
    1718:	bcf492e3          	bne	s1,a5,12dc <__udivdi3+0x164>
	      umul_ppmm (m1, m0, q0, d0);
    171c:	000107b7          	lui	a5,0x10
    1720:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe303>
    1724:	00f57533          	and	a0,a0,a5
    1728:	01051513          	slli	a0,a0,0x10
    172c:	00fa7a33          	and	s4,s4,a5
	      n0 = n0 << bm;
    1730:	015b1633          	sll	a2,s6,s5
	      umul_ppmm (m1, m0, q0, d0);
    1734:	01450533          	add	a0,a0,s4
	      q1 = 0;
    1738:	00000a93          	li	s5,0
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    173c:	cca67ae3          	bleu	a0,a2,1410 <__udivdi3+0x298>
		  q0--;
    1740:	fff40413          	addi	s0,s0,-1
    1744:	b99ff06f          	j	12dc <__udivdi3+0x164>
	  q1 = 0;
    1748:	00000a93          	li	s5,0
	  q0 = 0;
    174c:	00000413          	li	s0,0
    1750:	cc1ff06f          	j	1410 <__udivdi3+0x298>

00001754 <__umoddi3>:
{
    1754:	fb010113          	addi	sp,sp,-80
    1758:	04812423          	sw	s0,72(sp)
    175c:	04912223          	sw	s1,68(sp)
    1760:	03312e23          	sw	s3,60(sp)
    1764:	03912223          	sw	s9,36(sp)
    1768:	04112623          	sw	ra,76(sp)
    176c:	05212023          	sw	s2,64(sp)
    1770:	03412c23          	sw	s4,56(sp)
    1774:	03512a23          	sw	s5,52(sp)
    1778:	03612823          	sw	s6,48(sp)
    177c:	03712623          	sw	s7,44(sp)
    1780:	03812423          	sw	s8,40(sp)
    1784:	03a12023          	sw	s10,32(sp)
    1788:	01b12e23          	sw	s11,28(sp)
    178c:	00050c93          	mv	s9,a0
    1790:	00058993          	mv	s3,a1
  n0 = nn.s.low;
    1794:	00050413          	mv	s0,a0
  n1 = nn.s.high;
    1798:	00058493          	mv	s1,a1
  if (d1 == 0)
    179c:	26069e63          	bnez	a3,1a18 <__umoddi3+0x2c4>
    17a0:	00020ab7          	lui	s5,0x20
    17a4:	00060913          	mv	s2,a2
    17a8:	00068a13          	mv	s4,a3
    17ac:	1b8a8a93          	addi	s5,s5,440 # 201b8 <__clz_tab>
      if (d0 > n1)
    17b0:	14c5f463          	bleu	a2,a1,18f8 <__umoddi3+0x1a4>
	  count_leading_zeros (bm, d0);
    17b4:	000107b7          	lui	a5,0x10
    17b8:	12f67663          	bleu	a5,a2,18e4 <__umoddi3+0x190>
    17bc:	0ff00793          	li	a5,255
    17c0:	00c7f463          	bleu	a2,a5,17c8 <__umoddi3+0x74>
    17c4:	00800a13          	li	s4,8
    17c8:	014657b3          	srl	a5,a2,s4
    17cc:	00fa8ab3          	add	s5,s5,a5
    17d0:	000ac703          	lbu	a4,0(s5)
    17d4:	02000513          	li	a0,32
    17d8:	01470733          	add	a4,a4,s4
    17dc:	40e50a33          	sub	s4,a0,a4
	  if (bm != 0)
    17e0:	000a0c63          	beqz	s4,17f8 <__umoddi3+0xa4>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    17e4:	014995b3          	sll	a1,s3,s4
    17e8:	00ecd733          	srl	a4,s9,a4
	      d0 = d0 << bm;
    17ec:	01461933          	sll	s2,a2,s4
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    17f0:	00b764b3          	or	s1,a4,a1
	      n0 = n0 << bm;
    17f4:	014c9433          	sll	s0,s9,s4
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    17f8:	01095a93          	srli	s5,s2,0x10
    17fc:	000a8593          	mv	a1,s5
    1800:	00048513          	mv	a0,s1
    1804:	4c4000ef          	jal	ra,1cc8 <__umodsi3>
    1808:	00050993          	mv	s3,a0
    180c:	000a8593          	mv	a1,s5
    1810:	01091b13          	slli	s6,s2,0x10
    1814:	00048513          	mv	a0,s1
    1818:	468000ef          	jal	ra,1c80 <__udivsi3>
    181c:	010b5b13          	srli	s6,s6,0x10
    1820:	00050593          	mv	a1,a0
    1824:	000b0513          	mv	a0,s6
    1828:	42c000ef          	jal	ra,1c54 <__mulsi3>
    182c:	01099993          	slli	s3,s3,0x10
    1830:	01045793          	srli	a5,s0,0x10
    1834:	00f9e7b3          	or	a5,s3,a5
    1838:	00a7fa63          	bleu	a0,a5,184c <__umoddi3+0xf8>
    183c:	012787b3          	add	a5,a5,s2
    1840:	0127e663          	bltu	a5,s2,184c <__umoddi3+0xf8>
    1844:	00a7f463          	bleu	a0,a5,184c <__umoddi3+0xf8>
    1848:	012787b3          	add	a5,a5,s2
    184c:	40a784b3          	sub	s1,a5,a0
    1850:	000a8593          	mv	a1,s5
    1854:	00048513          	mv	a0,s1
    1858:	470000ef          	jal	ra,1cc8 <__umodsi3>
    185c:	00050993          	mv	s3,a0
    1860:	000a8593          	mv	a1,s5
    1864:	00048513          	mv	a0,s1
    1868:	418000ef          	jal	ra,1c80 <__udivsi3>
    186c:	01041413          	slli	s0,s0,0x10
    1870:	00050593          	mv	a1,a0
    1874:	01099993          	slli	s3,s3,0x10
    1878:	000b0513          	mv	a0,s6
    187c:	01045413          	srli	s0,s0,0x10
    1880:	3d4000ef          	jal	ra,1c54 <__mulsi3>
    1884:	0089e433          	or	s0,s3,s0
    1888:	00a47a63          	bleu	a0,s0,189c <__umoddi3+0x148>
    188c:	01240433          	add	s0,s0,s2
    1890:	01246663          	bltu	s0,s2,189c <__umoddi3+0x148>
    1894:	00a47463          	bleu	a0,s0,189c <__umoddi3+0x148>
    1898:	01240433          	add	s0,s0,s2
    189c:	40a40433          	sub	s0,s0,a0
	  rr.s.low = n0 >> bm;
    18a0:	01445533          	srl	a0,s0,s4
	  *rp = rr.ll;
    18a4:	00000593          	li	a1,0
}
    18a8:	04c12083          	lw	ra,76(sp)
    18ac:	04812403          	lw	s0,72(sp)
    18b0:	04412483          	lw	s1,68(sp)
    18b4:	04012903          	lw	s2,64(sp)
    18b8:	03c12983          	lw	s3,60(sp)
    18bc:	03812a03          	lw	s4,56(sp)
    18c0:	03412a83          	lw	s5,52(sp)
    18c4:	03012b03          	lw	s6,48(sp)
    18c8:	02c12b83          	lw	s7,44(sp)
    18cc:	02812c03          	lw	s8,40(sp)
    18d0:	02412c83          	lw	s9,36(sp)
    18d4:	02012d03          	lw	s10,32(sp)
    18d8:	01c12d83          	lw	s11,28(sp)
    18dc:	05010113          	addi	sp,sp,80
    18e0:	00008067          	ret
	  count_leading_zeros (bm, d0);
    18e4:	010007b7          	lui	a5,0x1000
    18e8:	01000a13          	li	s4,16
    18ec:	ecf66ee3          	bltu	a2,a5,17c8 <__umoddi3+0x74>
    18f0:	01800a13          	li	s4,24
    18f4:	ed5ff06f          	j	17c8 <__umoddi3+0x74>
	  if (d0 == 0)
    18f8:	00061a63          	bnez	a2,190c <__umoddi3+0x1b8>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    18fc:	00000593          	li	a1,0
    1900:	00100513          	li	a0,1
    1904:	37c000ef          	jal	ra,1c80 <__udivsi3>
    1908:	00050913          	mv	s2,a0
	  count_leading_zeros (bm, d0);
    190c:	000107b7          	lui	a5,0x10
    1910:	0ef97a63          	bleu	a5,s2,1a04 <__umoddi3+0x2b0>
    1914:	0ff00793          	li	a5,255
    1918:	0127f463          	bleu	s2,a5,1920 <__umoddi3+0x1cc>
    191c:	00800a13          	li	s4,8
    1920:	014957b3          	srl	a5,s2,s4
    1924:	00fa8ab3          	add	s5,s5,a5
    1928:	000ac703          	lbu	a4,0(s5)
    192c:	02000513          	li	a0,32
	      n1 -= d0;
    1930:	412984b3          	sub	s1,s3,s2
	  count_leading_zeros (bm, d0);
    1934:	01470733          	add	a4,a4,s4
    1938:	40e50a33          	sub	s4,a0,a4
	  if (bm == 0)
    193c:	ea0a0ee3          	beqz	s4,17f8 <__umoddi3+0xa4>
	      d0 = d0 << bm;
    1940:	01491933          	sll	s2,s2,s4
	      n2 = n1 >> b;
    1944:	00e9dab3          	srl	s5,s3,a4
	      n1 = (n1 << bm) | (n0 >> b);
    1948:	014995b3          	sll	a1,s3,s4
    194c:	00ecd733          	srl	a4,s9,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1950:	01095493          	srli	s1,s2,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1954:	00b76b33          	or	s6,a4,a1
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1958:	000a8513          	mv	a0,s5
    195c:	00048593          	mv	a1,s1
    1960:	368000ef          	jal	ra,1cc8 <__umodsi3>
    1964:	00050993          	mv	s3,a0
    1968:	00048593          	mv	a1,s1
    196c:	01091b93          	slli	s7,s2,0x10
    1970:	000a8513          	mv	a0,s5
    1974:	30c000ef          	jal	ra,1c80 <__udivsi3>
    1978:	010bdb93          	srli	s7,s7,0x10
    197c:	00050593          	mv	a1,a0
    1980:	000b8513          	mv	a0,s7
    1984:	2d0000ef          	jal	ra,1c54 <__mulsi3>
    1988:	01099993          	slli	s3,s3,0x10
    198c:	010b5793          	srli	a5,s6,0x10
    1990:	00f9e7b3          	or	a5,s3,a5
	      n0 = n0 << bm;
    1994:	014c9433          	sll	s0,s9,s4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    1998:	00a7fa63          	bleu	a0,a5,19ac <__umoddi3+0x258>
    199c:	012787b3          	add	a5,a5,s2
    19a0:	0127e663          	bltu	a5,s2,19ac <__umoddi3+0x258>
    19a4:	00a7f463          	bleu	a0,a5,19ac <__umoddi3+0x258>
    19a8:	012787b3          	add	a5,a5,s2
    19ac:	40a78ab3          	sub	s5,a5,a0
    19b0:	00048593          	mv	a1,s1
    19b4:	000a8513          	mv	a0,s5
    19b8:	310000ef          	jal	ra,1cc8 <__umodsi3>
    19bc:	00050993          	mv	s3,a0
    19c0:	00048593          	mv	a1,s1
    19c4:	000a8513          	mv	a0,s5
    19c8:	2b8000ef          	jal	ra,1c80 <__udivsi3>
    19cc:	00050593          	mv	a1,a0
    19d0:	000b8513          	mv	a0,s7
    19d4:	280000ef          	jal	ra,1c54 <__mulsi3>
    19d8:	010b1593          	slli	a1,s6,0x10
    19dc:	01099993          	slli	s3,s3,0x10
    19e0:	0105d593          	srli	a1,a1,0x10
    19e4:	00b9e5b3          	or	a1,s3,a1
    19e8:	00a5fa63          	bleu	a0,a1,19fc <__umoddi3+0x2a8>
    19ec:	012585b3          	add	a1,a1,s2
    19f0:	0125e663          	bltu	a1,s2,19fc <__umoddi3+0x2a8>
    19f4:	00a5f463          	bleu	a0,a1,19fc <__umoddi3+0x2a8>
    19f8:	012585b3          	add	a1,a1,s2
    19fc:	40a584b3          	sub	s1,a1,a0
    1a00:	df9ff06f          	j	17f8 <__umoddi3+0xa4>
	  count_leading_zeros (bm, d0);
    1a04:	010007b7          	lui	a5,0x1000
    1a08:	01000a13          	li	s4,16
    1a0c:	f0f96ae3          	bltu	s2,a5,1920 <__umoddi3+0x1cc>
    1a10:	01800a13          	li	s4,24
    1a14:	f0dff06f          	j	1920 <__umoddi3+0x1cc>
      if (d1 > n1)
    1a18:	e8d5e8e3          	bltu	a1,a3,18a8 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    1a1c:	000107b7          	lui	a5,0x10
    1a20:	04f6fc63          	bleu	a5,a3,1a78 <__umoddi3+0x324>
    1a24:	0ff00b93          	li	s7,255
    1a28:	00dbb533          	sltu	a0,s7,a3
    1a2c:	00351513          	slli	a0,a0,0x3
    1a30:	00020737          	lui	a4,0x20
    1a34:	00a6d7b3          	srl	a5,a3,a0
    1a38:	1b870713          	addi	a4,a4,440 # 201b8 <__clz_tab>
    1a3c:	00e787b3          	add	a5,a5,a4
    1a40:	0007cb83          	lbu	s7,0(a5) # 10000 <__modsi3+0xe304>
    1a44:	02000593          	li	a1,32
    1a48:	00ab8bb3          	add	s7,s7,a0
    1a4c:	41758b33          	sub	s6,a1,s7
	  if (bm == 0)
    1a50:	020b1e63          	bnez	s6,1a8c <__umoddi3+0x338>
	      if (n1 > d1 || n0 >= d0)
    1a54:	0136e463          	bltu	a3,s3,1a5c <__umoddi3+0x308>
    1a58:	00ccea63          	bltu	s9,a2,1a6c <__umoddi3+0x318>
		  sub_ddmmss (n1, n0, n1, n0, d1, d0);
    1a5c:	40cc8433          	sub	s0,s9,a2
    1a60:	40d986b3          	sub	a3,s3,a3
    1a64:	008cb533          	sltu	a0,s9,s0
    1a68:	40a684b3          	sub	s1,a3,a0
		  *rp = rr.ll;
    1a6c:	00040513          	mv	a0,s0
    1a70:	00048593          	mv	a1,s1
    1a74:	e35ff06f          	j	18a8 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    1a78:	010007b7          	lui	a5,0x1000
    1a7c:	01000513          	li	a0,16
    1a80:	faf6e8e3          	bltu	a3,a5,1a30 <__umoddi3+0x2dc>
    1a84:	01800513          	li	a0,24
    1a88:	fa9ff06f          	j	1a30 <__umoddi3+0x2dc>
	      d1 = (d1 << bm) | (d0 >> b);
    1a8c:	016696b3          	sll	a3,a3,s6
    1a90:	01765d33          	srl	s10,a2,s7
    1a94:	00dd6d33          	or	s10,s10,a3
	      n2 = n1 >> b;
    1a98:	0179d433          	srl	s0,s3,s7
	      n1 = (n1 << bm) | (n0 >> b);
    1a9c:	016995b3          	sll	a1,s3,s6
    1aa0:	017cdc33          	srl	s8,s9,s7
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1aa4:	010d5493          	srli	s1,s10,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    1aa8:	00bc6c33          	or	s8,s8,a1
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1aac:	00040513          	mv	a0,s0
    1ab0:	00048593          	mv	a1,s1
	      d0 = d0 << bm;
    1ab4:	01661ab3          	sll	s5,a2,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1ab8:	210000ef          	jal	ra,1cc8 <__umodsi3>
    1abc:	00050a13          	mv	s4,a0
    1ac0:	00048593          	mv	a1,s1
    1ac4:	00040513          	mv	a0,s0
	      n0 = n0 << bm;
    1ac8:	016c9933          	sll	s2,s9,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1acc:	010d1c93          	slli	s9,s10,0x10
    1ad0:	1b0000ef          	jal	ra,1c80 <__udivsi3>
    1ad4:	010cdc93          	srli	s9,s9,0x10
    1ad8:	00050413          	mv	s0,a0
    1adc:	00050593          	mv	a1,a0
    1ae0:	000c8513          	mv	a0,s9
    1ae4:	170000ef          	jal	ra,1c54 <__mulsi3>
    1ae8:	010a1a13          	slli	s4,s4,0x10
    1aec:	010c5713          	srli	a4,s8,0x10
    1af0:	00ea6733          	or	a4,s4,a4
    1af4:	00040a13          	mv	s4,s0
    1af8:	00a77e63          	bleu	a0,a4,1b14 <__umoddi3+0x3c0>
    1afc:	01a70733          	add	a4,a4,s10
    1b00:	fff40a13          	addi	s4,s0,-1
    1b04:	01a76863          	bltu	a4,s10,1b14 <__umoddi3+0x3c0>
    1b08:	00a77663          	bleu	a0,a4,1b14 <__umoddi3+0x3c0>
    1b0c:	ffe40a13          	addi	s4,s0,-2
    1b10:	01a70733          	add	a4,a4,s10
    1b14:	40a709b3          	sub	s3,a4,a0
    1b18:	00048593          	mv	a1,s1
    1b1c:	00098513          	mv	a0,s3
    1b20:	1a8000ef          	jal	ra,1cc8 <__umodsi3>
    1b24:	00048593          	mv	a1,s1
    1b28:	00050413          	mv	s0,a0
    1b2c:	00098513          	mv	a0,s3
    1b30:	150000ef          	jal	ra,1c80 <__udivsi3>
    1b34:	00050593          	mv	a1,a0
    1b38:	00050493          	mv	s1,a0
    1b3c:	000c8513          	mv	a0,s9
    1b40:	114000ef          	jal	ra,1c54 <__mulsi3>
    1b44:	010c1593          	slli	a1,s8,0x10
    1b48:	01041413          	slli	s0,s0,0x10
    1b4c:	0105d593          	srli	a1,a1,0x10
    1b50:	00b465b3          	or	a1,s0,a1
    1b54:	00048713          	mv	a4,s1
    1b58:	00a5fe63          	bleu	a0,a1,1b74 <__umoddi3+0x420>
    1b5c:	01a585b3          	add	a1,a1,s10
    1b60:	fff48713          	addi	a4,s1,-1
    1b64:	01a5e863          	bltu	a1,s10,1b74 <__umoddi3+0x420>
    1b68:	00a5f663          	bleu	a0,a1,1b74 <__umoddi3+0x420>
    1b6c:	ffe48713          	addi	a4,s1,-2
    1b70:	01a585b3          	add	a1,a1,s10
    1b74:	010a1a13          	slli	s4,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    1b78:	00010cb7          	lui	s9,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1b7c:	00ea6a33          	or	s4,s4,a4
	      umul_ppmm (m1, m0, q0, d0);
    1b80:	fffc8413          	addi	s0,s9,-1 # ffff <__modsi3+0xe303>
    1b84:	008a77b3          	and	a5,s4,s0
    1b88:	008af433          	and	s0,s5,s0
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    1b8c:	40a584b3          	sub	s1,a1,a0
	      umul_ppmm (m1, m0, q0, d0);
    1b90:	00078513          	mv	a0,a5
    1b94:	00040593          	mv	a1,s0
    1b98:	00f12623          	sw	a5,12(sp)
    1b9c:	010a5a13          	srli	s4,s4,0x10
    1ba0:	0b4000ef          	jal	ra,1c54 <__mulsi3>
    1ba4:	00050993          	mv	s3,a0
    1ba8:	00040593          	mv	a1,s0
    1bac:	000a0513          	mv	a0,s4
    1bb0:	0a4000ef          	jal	ra,1c54 <__mulsi3>
    1bb4:	010adc13          	srli	s8,s5,0x10
    1bb8:	00050d93          	mv	s11,a0
    1bbc:	000c0593          	mv	a1,s8
    1bc0:	000a0513          	mv	a0,s4
    1bc4:	090000ef          	jal	ra,1c54 <__mulsi3>
    1bc8:	00c12783          	lw	a5,12(sp)
    1bcc:	00050a13          	mv	s4,a0
    1bd0:	000c0593          	mv	a1,s8
    1bd4:	00078513          	mv	a0,a5
    1bd8:	07c000ef          	jal	ra,1c54 <__mulsi3>
    1bdc:	01b50533          	add	a0,a0,s11
    1be0:	0109d713          	srli	a4,s3,0x10
    1be4:	00a70733          	add	a4,a4,a0
    1be8:	01b77463          	bleu	s11,a4,1bf0 <__umoddi3+0x49c>
    1bec:	019a0a33          	add	s4,s4,s9
    1bf0:	000107b7          	lui	a5,0x10
    1bf4:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0xe303>
    1bf8:	01075593          	srli	a1,a4,0x10
    1bfc:	00f77733          	and	a4,a4,a5
    1c00:	01071713          	slli	a4,a4,0x10
    1c04:	00f9f7b3          	and	a5,s3,a5
    1c08:	014585b3          	add	a1,a1,s4
    1c0c:	00f707b3          	add	a5,a4,a5
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    1c10:	00b4e663          	bltu	s1,a1,1c1c <__umoddi3+0x4c8>
    1c14:	00b49e63          	bne	s1,a1,1c30 <__umoddi3+0x4dc>
    1c18:	00f97c63          	bleu	a5,s2,1c30 <__umoddi3+0x4dc>
		  sub_ddmmss (m1, m0, m1, m0, d1, d0);
    1c1c:	41578633          	sub	a2,a5,s5
    1c20:	00c7b7b3          	sltu	a5,a5,a2
    1c24:	41a585b3          	sub	a1,a1,s10
    1c28:	40f585b3          	sub	a1,a1,a5
    1c2c:	00060793          	mv	a5,a2
		  sub_ddmmss (n1, n0, n1, n0, m1, m0);
    1c30:	40f907b3          	sub	a5,s2,a5
    1c34:	00f93933          	sltu	s2,s2,a5
    1c38:	40b485b3          	sub	a1,s1,a1
    1c3c:	412585b3          	sub	a1,a1,s2
		  rr.s.low = (n1 << b) | (n0 >> bm);
    1c40:	01759433          	sll	s0,a1,s7
    1c44:	0167d7b3          	srl	a5,a5,s6
		  *rp = rr.ll;
    1c48:	00f46533          	or	a0,s0,a5
    1c4c:	0165d5b3          	srl	a1,a1,s6
  return w;
    1c50:	c59ff06f          	j	18a8 <__umoddi3+0x154>

00001c54 <__mulsi3>:
# define __muldi3 __mulsi3
#endif

  .globl __muldi3
__muldi3:
  mv     a2, a0
    1c54:	00050613          	mv	a2,a0
  li     a0, 0
    1c58:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
    1c5c:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
    1c60:	00068463          	beqz	a3,1c68 <__mulsi3+0x14>
  add    a0, a0, a2
    1c64:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
    1c68:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
    1c6c:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
    1c70:	fe0596e3          	bnez	a1,1c5c <__mulsi3+0x8>
  ret
    1c74:	00008067          	ret

00001c78 <__divsi3>:
  beq   a1, t0, .L20
#endif

  .globl __divdi3
__divdi3:
  bltz  a0, .L10
    1c78:	06054063          	bltz	a0,1cd8 <__umodsi3+0x10>
  bltz  a1, .L11
    1c7c:	0605c663          	bltz	a1,1ce8 <__umodsi3+0x20>

00001c80 <__udivsi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

  .globl __udivdi3
__udivdi3:
  mv    a2, a1
    1c80:	00058613          	mv	a2,a1
  mv    a1, a0
    1c84:	00050593          	mv	a1,a0
  li    a0, -1
    1c88:	fff00513          	li	a0,-1
  beqz  a2, .L5
    1c8c:	02060c63          	beqz	a2,1cc4 <__udivsi3+0x44>
  li    a3, 1
    1c90:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
    1c94:	00b67a63          	bleu	a1,a2,1ca8 <__udivsi3+0x28>
.L1:
  blez  a2, .L2
    1c98:	00c05863          	blez	a2,1ca8 <__udivsi3+0x28>
  slli  a2, a2, 1
    1c9c:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
    1ca0:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
    1ca4:	feb66ae3          	bltu	a2,a1,1c98 <__udivsi3+0x18>
.L2:
  li    a0, 0
    1ca8:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
    1cac:	00c5e663          	bltu	a1,a2,1cb8 <__udivsi3+0x38>
  sub   a1, a1, a2
    1cb0:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
    1cb4:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
    1cb8:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
    1cbc:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
    1cc0:	fe0696e3          	bnez	a3,1cac <__udivsi3+0x2c>
.L5:
  ret
    1cc4:	00008067          	ret

00001cc8 <__umodsi3>:

  .globl __umoddi3
__umoddi3:
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
    1cc8:	00008293          	mv	t0,ra
  jal   __udivdi3
    1ccc:	fb5ff0ef          	jal	ra,1c80 <__udivsi3>
  move  a0, a1
    1cd0:	00058513          	mv	a0,a1
  jr    t0
    1cd4:	00028067          	jr	t0

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
    1cd8:	40a00533          	neg	a0,a0
  bgez  a1, .L12      /* Compute __udivdi3(-a0, a1), then negate the result.  */
    1cdc:	0005d863          	bgez	a1,1cec <__umodsi3+0x24>
  neg   a1, a1
    1ce0:	40b005b3          	neg	a1,a1
  j     __udivdi3     /* Compute __udivdi3(-a0, -a1).  */
    1ce4:	f9dff06f          	j	1c80 <__udivsi3>
.L11:                 /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
    1ce8:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
    1cec:	00008293          	mv	t0,ra
  jal   __udivdi3
    1cf0:	f91ff0ef          	jal	ra,1c80 <__udivsi3>
  neg   a0, a0
    1cf4:	40a00533          	neg	a0,a0
  jr    t0
    1cf8:	00028067          	jr	t0

00001cfc <__modsi3>:

  .globl __moddi3
__moddi3:
  move   t0, ra
    1cfc:	00008293          	mv	t0,ra
  bltz   a1, .L31
    1d00:	0005ca63          	bltz	a1,1d14 <__modsi3+0x18>
  bltz   a0, .L32
    1d04:	00054c63          	bltz	a0,1d1c <__modsi3+0x20>
.L30:
  jal    __udivdi3    /* The dividend is not negative.  */
    1d08:	f79ff0ef          	jal	ra,1c80 <__udivsi3>
  move   a0, a1
    1d0c:	00058513          	mv	a0,a1
  jr     t0
    1d10:	00028067          	jr	t0
.L31:
  neg    a1, a1
    1d14:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
    1d18:	fe0558e3          	bgez	a0,1d08 <__modsi3+0xc>
.L32:
  neg    a0, a0
    1d1c:	40a00533          	neg	a0,a0
  jal    __udivdi3    /* The dividend is hella negative.  */
    1d20:	f61ff0ef          	jal	ra,1c80 <__udivsi3>
  neg    a0, a1
    1d24:	40b00533          	neg	a0,a1
  jr     t0
    1d28:	00028067          	jr	t0
