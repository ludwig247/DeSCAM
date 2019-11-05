
riscv-spike.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
       0:	00002fb7          	lui	t6,0x2
       4:	800f8f93          	addi	t6,t6,-2048 # 1800 <xQueueSemaphoreTake+0x17c>
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
      44:	11428293          	addi	t0,t0,276 # 154 <trap_entry>
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
      cc:	c8c18193          	addi	gp,gp,-884 # 20d54 <_gp>

000000d0 <init_bss>:
      d0:	00020517          	auipc	a0,0x20
      d4:	4b050513          	addi	a0,a0,1200 # 20580 <xStartContext>
      d8:	0003a597          	auipc	a1,0x3a
      dc:	82c58593          	addi	a1,a1,-2004 # 39904 <tohost+0x4>
      e0:	00000613          	li	a2,0
      e4:	1a0000ef          	jal	ra,284 <fill_block>

000000e8 <init_sbss>:
      e8:	00020517          	auipc	a0,0x20
      ec:	46850513          	addi	a0,a0,1128 # 20550 <pxCurrentTCB>
      f0:	00020597          	auipc	a1,0x20
      f4:	46058593          	addi	a1,a1,1120 # 20550 <pxCurrentTCB>
      f8:	00000613          	li	a2,0
      fc:	188000ef          	jal	ra,284 <fill_block>

00000100 <write_stack_pattern>:
     100:	0003b517          	auipc	a0,0x3b
     104:	80850513          	addi	a0,a0,-2040 # 3a908 <_heap_end>
     108:	0003b597          	auipc	a1,0x3b
     10c:	7fc58593          	addi	a1,a1,2044 # 3b904 <_heap_end+0xffc>
     110:	ababb637          	lui	a2,0xababb
     114:	bab60613          	addi	a2,a2,-1109 # abababab <__stack+0xaba7f2a3>
     118:	16c000ef          	jal	ra,284 <fill_block>

0000011c <init_stack>:
     11c:	0003b117          	auipc	sp,0x3b
     120:	7ec10113          	addi	sp,sp,2028 # 3b908 <__stack>
     124:	33c0706f          	j	7460 <vSyscallInit>

00000128 <interrupt>:
     128:	00129293          	slli	t0,t0,0x1
     12c:	0012d293          	srli	t0,t0,0x1
     130:	ffd28293          	addi	t0,t0,-3
     134:	00028a63          	beqz	t0,148 <softwareInterrupt>
     138:	00012283          	lw	t0,0(sp)
     13c:	00410113          	addi	sp,sp,4
     140:	1740006f          	j	2b4 <TIMER_CMP_INT>
     144:	30200073          	mret

00000148 <softwareInterrupt>:
     148:	00012283          	lw	t0,0(sp)
     14c:	00410113          	addi	sp,sp,4
     150:	30200073          	mret

00000154 <trap_entry>:
     154:	ffc10113          	addi	sp,sp,-4
     158:	00512023          	sw	t0,0(sp)
     15c:	342022f3          	csrr	t0,mcause
     160:	fc02c4e3          	bltz	t0,128 <interrupt>
     164:	00012283          	lw	t0,0(sp)
     168:	00410113          	addi	sp,sp,4
     16c:	f8010113          	addi	sp,sp,-128
     170:	00112223          	sw	ra,4(sp)
     174:	00212423          	sw	sp,8(sp)
     178:	00312623          	sw	gp,12(sp)
     17c:	00412823          	sw	tp,16(sp)
     180:	00512a23          	sw	t0,20(sp)
     184:	00612c23          	sw	t1,24(sp)
     188:	00712e23          	sw	t2,28(sp)
     18c:	02812023          	sw	s0,32(sp)
     190:	02912223          	sw	s1,36(sp)
     194:	02a12423          	sw	a0,40(sp)
     198:	02b12623          	sw	a1,44(sp)
     19c:	02c12823          	sw	a2,48(sp)
     1a0:	02d12a23          	sw	a3,52(sp)
     1a4:	02e12c23          	sw	a4,56(sp)
     1a8:	02f12e23          	sw	a5,60(sp)
     1ac:	05012023          	sw	a6,64(sp)
     1b0:	05112223          	sw	a7,68(sp)
     1b4:	05212423          	sw	s2,72(sp)
     1b8:	05312623          	sw	s3,76(sp)
     1bc:	05412823          	sw	s4,80(sp)
     1c0:	05512a23          	sw	s5,84(sp)
     1c4:	05612c23          	sw	s6,88(sp)
     1c8:	05712e23          	sw	s7,92(sp)
     1cc:	07812023          	sw	s8,96(sp)
     1d0:	07912223          	sw	s9,100(sp)
     1d4:	07a12423          	sw	s10,104(sp)
     1d8:	07b12623          	sw	s11,108(sp)
     1dc:	07c12823          	sw	t3,112(sp)
     1e0:	07d12a23          	sw	t4,116(sp)
     1e4:	07e12c23          	sw	t5,120(sp)
     1e8:	07f12e23          	sw	t6,124(sp)
     1ec:	34202573          	csrr	a0,mcause
     1f0:	341025f3          	csrr	a1,mepc
     1f4:	00010613          	mv	a2,sp
     1f8:	298070ef          	jal	ra,7490 <ulSyscallTrap>
     1fc:	34151073          	csrw	mepc,a0
     200:	00412083          	lw	ra,4(sp)
     204:	00812103          	lw	sp,8(sp)
     208:	00c12183          	lw	gp,12(sp)
     20c:	01012203          	lw	tp,16(sp)
     210:	01412283          	lw	t0,20(sp)
     214:	01812303          	lw	t1,24(sp)
     218:	01c12383          	lw	t2,28(sp)
     21c:	02012403          	lw	s0,32(sp)
     220:	02412483          	lw	s1,36(sp)
     224:	02812503          	lw	a0,40(sp)
     228:	02c12583          	lw	a1,44(sp)
     22c:	03012603          	lw	a2,48(sp)
     230:	03412683          	lw	a3,52(sp)
     234:	03812703          	lw	a4,56(sp)
     238:	03c12783          	lw	a5,60(sp)
     23c:	04012803          	lw	a6,64(sp)
     240:	04412883          	lw	a7,68(sp)
     244:	04812903          	lw	s2,72(sp)
     248:	04c12983          	lw	s3,76(sp)
     24c:	05012a03          	lw	s4,80(sp)
     250:	05412a83          	lw	s5,84(sp)
     254:	05812b03          	lw	s6,88(sp)
     258:	05c12b83          	lw	s7,92(sp)
     25c:	06012c03          	lw	s8,96(sp)
     260:	06412c83          	lw	s9,100(sp)
     264:	06812d03          	lw	s10,104(sp)
     268:	06c12d83          	lw	s11,108(sp)
     26c:	07012e03          	lw	t3,112(sp)
     270:	07412e83          	lw	t4,116(sp)
     274:	07812f03          	lw	t5,120(sp)
     278:	07c12f83          	lw	t6,124(sp)
     27c:	08010113          	addi	sp,sp,128
     280:	30200073          	mret

00000284 <fill_block>:
     284:	00c52023          	sw	a2,0(a0)
     288:	00b57663          	bleu	a1,a0,294 <fb_end>
     28c:	00450513          	addi	a0,a0,4
     290:	ff5ff06f          	j	284 <fill_block>

00000294 <fb_end>:
     294:	00008067          	ret
	...

000002b4 <TIMER_CMP_INT>:
     2b4:	f8010113          	addi	sp,sp,-128
     2b8:	00112023          	sw	ra,0(sp)
     2bc:	00212223          	sw	sp,4(sp)
     2c0:	00312423          	sw	gp,8(sp)
     2c4:	00412623          	sw	tp,12(sp)
     2c8:	00512823          	sw	t0,16(sp)
     2cc:	00612a23          	sw	t1,20(sp)
     2d0:	00712c23          	sw	t2,24(sp)
     2d4:	00812e23          	sw	s0,28(sp)
     2d8:	02912023          	sw	s1,32(sp)
     2dc:	02a12223          	sw	a0,36(sp)
     2e0:	02b12423          	sw	a1,40(sp)
     2e4:	02c12623          	sw	a2,44(sp)
     2e8:	02d12823          	sw	a3,48(sp)
     2ec:	02e12a23          	sw	a4,52(sp)
     2f0:	02f12c23          	sw	a5,56(sp)
     2f4:	03012e23          	sw	a6,60(sp)
     2f8:	05112023          	sw	a7,64(sp)
     2fc:	05212223          	sw	s2,68(sp)
     300:	05312423          	sw	s3,72(sp)
     304:	05412623          	sw	s4,76(sp)
     308:	05512823          	sw	s5,80(sp)
     30c:	05612a23          	sw	s6,84(sp)
     310:	05712c23          	sw	s7,88(sp)
     314:	05812e23          	sw	s8,92(sp)
     318:	07912023          	sw	s9,96(sp)
     31c:	07a12223          	sw	s10,100(sp)
     320:	07b12423          	sw	s11,104(sp)
     324:	07c12623          	sw	t3,108(sp)
     328:	07d12823          	sw	t4,112(sp)
     32c:	07e12a23          	sw	t5,116(sp)
     330:	07f12c23          	sw	t6,120(sp)
     334:	00020297          	auipc	t0,0x20
     338:	21c2a283          	lw	t0,540(t0) # 20550 <pxCurrentTCB>
     33c:	0022a023          	sw	sp,0(t0)
     340:	341022f3          	csrr	t0,mepc
     344:	06512e23          	sw	t0,124(sp)
     348:	508000ef          	jal	ra,850 <vPortSysTickHandler>
     34c:	00020117          	auipc	sp,0x20
     350:	20412103          	lw	sp,516(sp) # 20550 <pxCurrentTCB>
     354:	00012103          	lw	sp,0(sp)
     358:	07c12283          	lw	t0,124(sp)
     35c:	34129073          	csrw	mepc,t0
     360:	000022b7          	lui	t0,0x2
     364:	88028293          	addi	t0,t0,-1920 # 1880 <xQueueSemaphoreTake+0x1fc>
     368:	3002a073          	csrs	mstatus,t0
     36c:	00012083          	lw	ra,0(sp)
     370:	00c12203          	lw	tp,12(sp)
     374:	01012283          	lw	t0,16(sp)
     378:	01412303          	lw	t1,20(sp)
     37c:	01812383          	lw	t2,24(sp)
     380:	01c12403          	lw	s0,28(sp)
     384:	02012483          	lw	s1,32(sp)
     388:	02412503          	lw	a0,36(sp)
     38c:	02812583          	lw	a1,40(sp)
     390:	02c12603          	lw	a2,44(sp)
     394:	03012683          	lw	a3,48(sp)
     398:	03412703          	lw	a4,52(sp)
     39c:	03812783          	lw	a5,56(sp)
     3a0:	03c12803          	lw	a6,60(sp)
     3a4:	04012883          	lw	a7,64(sp)
     3a8:	04412903          	lw	s2,68(sp)
     3ac:	04812983          	lw	s3,72(sp)
     3b0:	04c12a03          	lw	s4,76(sp)
     3b4:	05012a83          	lw	s5,80(sp)
     3b8:	05412b03          	lw	s6,84(sp)
     3bc:	05812b83          	lw	s7,88(sp)
     3c0:	05c12c03          	lw	s8,92(sp)
     3c4:	06012c83          	lw	s9,96(sp)
     3c8:	06412d03          	lw	s10,100(sp)
     3cc:	06812d83          	lw	s11,104(sp)
     3d0:	06c12e03          	lw	t3,108(sp)
     3d4:	07012e83          	lw	t4,112(sp)
     3d8:	07412f03          	lw	t5,116(sp)
     3dc:	07812f83          	lw	t6,120(sp)
     3e0:	08010113          	addi	sp,sp,128
     3e4:	30200073          	mret

000003e8 <xPortStartScheduler>:
     3e8:	00020297          	auipc	t0,0x20
     3ec:	19828293          	addi	t0,t0,408 # 20580 <xStartContext>
     3f0:	0012a023          	sw	ra,0(t0)
     3f4:	0022a223          	sw	sp,4(t0)
     3f8:	0032a423          	sw	gp,8(t0)
     3fc:	0042a623          	sw	tp,12(t0)
     400:	0052a823          	sw	t0,16(t0)
     404:	0062aa23          	sw	t1,20(t0)
     408:	0072ac23          	sw	t2,24(t0)
     40c:	0082ae23          	sw	s0,28(t0)
     410:	0292a023          	sw	s1,32(t0)
     414:	02a2a223          	sw	a0,36(t0)
     418:	02b2a423          	sw	a1,40(t0)
     41c:	02c2a623          	sw	a2,44(t0)
     420:	02d2a823          	sw	a3,48(t0)
     424:	02e2aa23          	sw	a4,52(t0)
     428:	02f2ac23          	sw	a5,56(t0)
     42c:	0302ae23          	sw	a6,60(t0)
     430:	0512a023          	sw	a7,64(t0)
     434:	0522a223          	sw	s2,68(t0)
     438:	0532a423          	sw	s3,72(t0)
     43c:	0542a623          	sw	s4,76(t0)
     440:	0552a823          	sw	s5,80(t0)
     444:	0562aa23          	sw	s6,84(t0)
     448:	0572ac23          	sw	s7,88(t0)
     44c:	0582ae23          	sw	s8,92(t0)
     450:	0792a023          	sw	s9,96(t0)
     454:	07a2a223          	sw	s10,100(t0)
     458:	07b2a423          	sw	s11,104(t0)
     45c:	07c2a623          	sw	t3,108(t0)
     460:	07d2a823          	sw	t4,112(t0)
     464:	07e2aa23          	sw	t5,116(t0)
     468:	07f2ac23          	sw	t6,120(t0)
     46c:	2d8000ef          	jal	ra,744 <vPortSetupTimer>
     470:	00020117          	auipc	sp,0x20
     474:	0e012103          	lw	sp,224(sp) # 20550 <pxCurrentTCB>
     478:	00012103          	lw	sp,0(sp)
     47c:	07c12283          	lw	t0,124(sp)
     480:	34129073          	csrw	mepc,t0
     484:	000022b7          	lui	t0,0x2
     488:	88028293          	addi	t0,t0,-1920 # 1880 <xQueueSemaphoreTake+0x1fc>
     48c:	3002a073          	csrs	mstatus,t0
     490:	00012083          	lw	ra,0(sp)
     494:	00c12203          	lw	tp,12(sp)
     498:	01012283          	lw	t0,16(sp)
     49c:	01412303          	lw	t1,20(sp)
     4a0:	01812383          	lw	t2,24(sp)
     4a4:	01c12403          	lw	s0,28(sp)
     4a8:	02012483          	lw	s1,32(sp)
     4ac:	02412503          	lw	a0,36(sp)
     4b0:	02812583          	lw	a1,40(sp)
     4b4:	02c12603          	lw	a2,44(sp)
     4b8:	03012683          	lw	a3,48(sp)
     4bc:	03412703          	lw	a4,52(sp)
     4c0:	03812783          	lw	a5,56(sp)
     4c4:	03c12803          	lw	a6,60(sp)
     4c8:	04012883          	lw	a7,64(sp)
     4cc:	04412903          	lw	s2,68(sp)
     4d0:	04812983          	lw	s3,72(sp)
     4d4:	04c12a03          	lw	s4,76(sp)
     4d8:	05012a83          	lw	s5,80(sp)
     4dc:	05412b03          	lw	s6,84(sp)
     4e0:	05812b83          	lw	s7,88(sp)
     4e4:	05c12c03          	lw	s8,92(sp)
     4e8:	06012c83          	lw	s9,96(sp)
     4ec:	06412d03          	lw	s10,100(sp)
     4f0:	06812d83          	lw	s11,104(sp)
     4f4:	06c12e03          	lw	t3,108(sp)
     4f8:	07012e83          	lw	t4,112(sp)
     4fc:	07412f03          	lw	t5,116(sp)
     500:	07812f83          	lw	t6,120(sp)
     504:	08010113          	addi	sp,sp,128
     508:	30200073          	mret

0000050c <vPortEndScheduler>:
     50c:	00020297          	auipc	t0,0x20
     510:	07428293          	addi	t0,t0,116 # 20580 <xStartContext>
     514:	0002a083          	lw	ra,0(t0)
     518:	0042a103          	lw	sp,4(t0)
     51c:	0082a183          	lw	gp,8(t0)
     520:	00c2a203          	lw	tp,12(t0)
     524:	0102a283          	lw	t0,16(t0)
     528:	0142a303          	lw	t1,20(t0)
     52c:	0182a383          	lw	t2,24(t0)
     530:	01c2a403          	lw	s0,28(t0)
     534:	0202a483          	lw	s1,32(t0)
     538:	0242a503          	lw	a0,36(t0)
     53c:	0282a583          	lw	a1,40(t0)
     540:	02c2a603          	lw	a2,44(t0)
     544:	0302a683          	lw	a3,48(t0)
     548:	0342a703          	lw	a4,52(t0)
     54c:	0382a783          	lw	a5,56(t0)
     550:	03c2a803          	lw	a6,60(t0)
     554:	0402a883          	lw	a7,64(t0)
     558:	0442a903          	lw	s2,68(t0)
     55c:	0482a983          	lw	s3,72(t0)
     560:	04c2aa03          	lw	s4,76(t0)
     564:	0502aa83          	lw	s5,80(t0)
     568:	0542ab03          	lw	s6,84(t0)
     56c:	0582ab83          	lw	s7,88(t0)
     570:	05c2ac03          	lw	s8,92(t0)
     574:	0602ac83          	lw	s9,96(t0)
     578:	0642ad03          	lw	s10,100(t0)
     57c:	0682ad83          	lw	s11,104(t0)
     580:	06c2ae03          	lw	t3,108(t0)
     584:	0702ae83          	lw	t4,112(t0)
     588:	09c2af03          	lw	t5,156(t0)
     58c:	0782af83          	lw	t6,120(t0)
     590:	00008067          	ret

00000594 <vPortYield>:
     594:	30047073          	csrci	mstatus,8
     598:	f8010113          	addi	sp,sp,-128
     59c:	00112023          	sw	ra,0(sp)
     5a0:	00212223          	sw	sp,4(sp)
     5a4:	00312423          	sw	gp,8(sp)
     5a8:	00412623          	sw	tp,12(sp)
     5ac:	00512823          	sw	t0,16(sp)
     5b0:	00612a23          	sw	t1,20(sp)
     5b4:	00712c23          	sw	t2,24(sp)
     5b8:	00812e23          	sw	s0,28(sp)
     5bc:	02912023          	sw	s1,32(sp)
     5c0:	02a12223          	sw	a0,36(sp)
     5c4:	02b12423          	sw	a1,40(sp)
     5c8:	02c12623          	sw	a2,44(sp)
     5cc:	02d12823          	sw	a3,48(sp)
     5d0:	02e12a23          	sw	a4,52(sp)
     5d4:	02f12c23          	sw	a5,56(sp)
     5d8:	03012e23          	sw	a6,60(sp)
     5dc:	05112023          	sw	a7,64(sp)
     5e0:	05212223          	sw	s2,68(sp)
     5e4:	05312423          	sw	s3,72(sp)
     5e8:	05412623          	sw	s4,76(sp)
     5ec:	05512823          	sw	s5,80(sp)
     5f0:	05612a23          	sw	s6,84(sp)
     5f4:	05712c23          	sw	s7,88(sp)
     5f8:	05812e23          	sw	s8,92(sp)
     5fc:	07912023          	sw	s9,96(sp)
     600:	07a12223          	sw	s10,100(sp)
     604:	07b12423          	sw	s11,104(sp)
     608:	07c12623          	sw	t3,108(sp)
     60c:	07d12823          	sw	t4,112(sp)
     610:	07e12a23          	sw	t5,116(sp)
     614:	07f12c23          	sw	t6,120(sp)
     618:	00020297          	auipc	t0,0x20
     61c:	f382a283          	lw	t0,-200(t0) # 20550 <pxCurrentTCB>
     620:	0022a023          	sw	sp,0(t0)
     624:	06112e23          	sw	ra,124(sp)
     628:	5b0030ef          	jal	ra,3bd8 <vTaskSwitchContext>
     62c:	00020117          	auipc	sp,0x20
     630:	f2412103          	lw	sp,-220(sp) # 20550 <pxCurrentTCB>
     634:	00012103          	lw	sp,0(sp)
     638:	07c12283          	lw	t0,124(sp)
     63c:	34129073          	csrw	mepc,t0
     640:	000022b7          	lui	t0,0x2
     644:	88028293          	addi	t0,t0,-1920 # 1880 <xQueueSemaphoreTake+0x1fc>
     648:	3002a073          	csrs	mstatus,t0
     64c:	00012083          	lw	ra,0(sp)
     650:	00c12203          	lw	tp,12(sp)
     654:	01012283          	lw	t0,16(sp)
     658:	01412303          	lw	t1,20(sp)
     65c:	01812383          	lw	t2,24(sp)
     660:	01c12403          	lw	s0,28(sp)
     664:	02012483          	lw	s1,32(sp)
     668:	02412503          	lw	a0,36(sp)
     66c:	02812583          	lw	a1,40(sp)
     670:	02c12603          	lw	a2,44(sp)
     674:	03012683          	lw	a3,48(sp)
     678:	03412703          	lw	a4,52(sp)
     67c:	03812783          	lw	a5,56(sp)
     680:	03c12803          	lw	a6,60(sp)
     684:	04012883          	lw	a7,64(sp)
     688:	04412903          	lw	s2,68(sp)
     68c:	04812983          	lw	s3,72(sp)
     690:	04c12a03          	lw	s4,76(sp)
     694:	05012a83          	lw	s5,80(sp)
     698:	05412b03          	lw	s6,84(sp)
     69c:	05812b83          	lw	s7,88(sp)
     6a0:	05c12c03          	lw	s8,92(sp)
     6a4:	06012c83          	lw	s9,96(sp)
     6a8:	06412d03          	lw	s10,100(sp)
     6ac:	06812d83          	lw	s11,104(sp)
     6b0:	06c12e03          	lw	t3,108(sp)
     6b4:	07012e83          	lw	t4,112(sp)
     6b8:	07412f03          	lw	t5,116(sp)
     6bc:	07812f83          	lw	t6,120(sp)
     6c0:	08010113          	addi	sp,sp,128
     6c4:	30200073          	mret

000006c8 <prvSetNextTimerInterrupt>:
     6c8:	00020797          	auipc	a5,0x20
     6cc:	e9078793          	addi	a5,a5,-368 # 20558 <mtime>
     6d0:	0007a783          	lw	a5,0(a5)
     6d4:	06078463          	beqz	a5,73c <prvSetNextTimerInterrupt+0x74>
     6d8:	00020797          	auipc	a5,0x20
     6dc:	e8478793          	addi	a5,a5,-380 # 2055c <timecmp>
     6e0:	0007a783          	lw	a5,0(a5)
     6e4:	04078c63          	beqz	a5,73c <prvSetNextTimerInterrupt+0x74>
     6e8:	00020797          	auipc	a5,0x20
     6ec:	e7078793          	addi	a5,a5,-400 # 20558 <mtime>
     6f0:	0007a783          	lw	a5,0(a5)
     6f4:	0047a803          	lw	a6,4(a5)
     6f8:	0007a783          	lw	a5,0(a5)
     6fc:	00020717          	auipc	a4,0x20
     700:	e6070713          	addi	a4,a4,-416 # 2055c <timecmp>
     704:	00072503          	lw	a0,0(a4)
     708:	000015b7          	lui	a1,0x1
     70c:	38858593          	addi	a1,a1,904 # 1388 <xQueueGiveFromISR+0x58>
     710:	00000613          	li	a2,0
     714:	00b786b3          	add	a3,a5,a1
     718:	00068893          	mv	a7,a3
     71c:	00f8b8b3          	sltu	a7,a7,a5
     720:	00c80733          	add	a4,a6,a2
     724:	00e887b3          	add	a5,a7,a4
     728:	00078713          	mv	a4,a5
     72c:	00068793          	mv	a5,a3
     730:	00070813          	mv	a6,a4
     734:	00f52023          	sw	a5,0(a0)
     738:	01052223          	sw	a6,4(a0)
     73c:	00000013          	nop
     740:	00008067          	ret

00000744 <vPortSetupTimer>:
     744:	ff010113          	addi	sp,sp,-16
     748:	00112623          	sw	ra,12(sp)
     74c:	f7dff0ef          	jal	ra,6c8 <prvSetNextTimerInterrupt>
     750:	08000793          	li	a5,128
     754:	3047a073          	csrs	mie,a5
     758:	00000013          	nop
     75c:	00c12083          	lw	ra,12(sp)
     760:	01010113          	addi	sp,sp,16
     764:	00008067          	ret

00000768 <prvTaskExitError>:
     768:	00020797          	auipc	a5,0x20
     76c:	dec78793          	addi	a5,a5,-532 # 20554 <__sbss_end>
     770:	0007a703          	lw	a4,0(a5)
     774:	fff00793          	li	a5,-1
     778:	00f70663          	beq	a4,a5,784 <prvTaskExitError+0x1c>
     77c:	30047073          	csrci	mstatus,8
     780:	0000006f          	j	780 <prvTaskExitError+0x18>
     784:	30047073          	csrci	mstatus,8
     788:	0000006f          	j	788 <prvTaskExitError+0x20>

0000078c <vPortClearInterruptMask>:
     78c:	ff010113          	addi	sp,sp,-16
     790:	00a12623          	sw	a0,12(sp)
     794:	00c12783          	lw	a5,12(sp)
     798:	30479073          	csrw	mie,a5
     79c:	00000013          	nop
     7a0:	01010113          	addi	sp,sp,16
     7a4:	00008067          	ret

000007a8 <vPortSetInterruptMask>:
     7a8:	ff010113          	addi	sp,sp,-16
     7ac:	304027f3          	csrr	a5,mie
     7b0:	00f12623          	sw	a5,12(sp)
     7b4:	3043f073          	csrci	mie,7
     7b8:	00c12783          	lw	a5,12(sp)
     7bc:	00078513          	mv	a0,a5
     7c0:	01010113          	addi	sp,sp,16
     7c4:	00008067          	ret

000007c8 <pxPortInitialiseStack>:
     7c8:	ff010113          	addi	sp,sp,-16
     7cc:	00a12623          	sw	a0,12(sp)
     7d0:	00b12423          	sw	a1,8(sp)
     7d4:	00c12223          	sw	a2,4(sp)
     7d8:	00c12783          	lw	a5,12(sp)
     7dc:	ffc78793          	addi	a5,a5,-4
     7e0:	00f12623          	sw	a5,12(sp)
     7e4:	00812703          	lw	a4,8(sp)
     7e8:	00c12783          	lw	a5,12(sp)
     7ec:	00e7a023          	sw	a4,0(a5)
     7f0:	00c12783          	lw	a5,12(sp)
     7f4:	fa878793          	addi	a5,a5,-88
     7f8:	00f12623          	sw	a5,12(sp)
     7fc:	00412703          	lw	a4,4(sp)
     800:	00c12783          	lw	a5,12(sp)
     804:	00e7a023          	sw	a4,0(a5)
     808:	00c12783          	lw	a5,12(sp)
     80c:	fe878793          	addi	a5,a5,-24
     810:	00f12623          	sw	a5,12(sp)
     814:	00018793          	mv	a5,gp
     818:	00078713          	mv	a4,a5
     81c:	00c12783          	lw	a5,12(sp)
     820:	00e7a023          	sw	a4,0(a5)
     824:	00c12783          	lw	a5,12(sp)
     828:	ff478793          	addi	a5,a5,-12
     82c:	00f12623          	sw	a5,12(sp)
     830:	00000717          	auipc	a4,0x0
     834:	f3870713          	addi	a4,a4,-200 # 768 <prvTaskExitError>
     838:	00c12783          	lw	a5,12(sp)
     83c:	00e7a023          	sw	a4,0(a5)
     840:	00c12783          	lw	a5,12(sp)
     844:	00078513          	mv	a0,a5
     848:	01010113          	addi	sp,sp,16
     84c:	00008067          	ret

00000850 <vPortSysTickHandler>:
     850:	ff010113          	addi	sp,sp,-16
     854:	00112623          	sw	ra,12(sp)
     858:	e71ff0ef          	jal	ra,6c8 <prvSetNextTimerInterrupt>
     85c:	0fc030ef          	jal	ra,3958 <xTaskIncrementTick>
     860:	00050793          	mv	a5,a0
     864:	00078463          	beqz	a5,86c <vPortSysTickHandler+0x1c>
     868:	370030ef          	jal	ra,3bd8 <vTaskSwitchContext>
     86c:	00000013          	nop
     870:	00c12083          	lw	ra,12(sp)
     874:	01010113          	addi	sp,sp,16
     878:	00008067          	ret

0000087c <vListInitialise>:
     87c:	ff010113          	addi	sp,sp,-16
     880:	00a12623          	sw	a0,12(sp)
     884:	00c12783          	lw	a5,12(sp)
     888:	00878713          	addi	a4,a5,8
     88c:	00c12783          	lw	a5,12(sp)
     890:	00e7a223          	sw	a4,4(a5)
     894:	00c12783          	lw	a5,12(sp)
     898:	fff00713          	li	a4,-1
     89c:	00e7a423          	sw	a4,8(a5)
     8a0:	00c12783          	lw	a5,12(sp)
     8a4:	00878713          	addi	a4,a5,8
     8a8:	00c12783          	lw	a5,12(sp)
     8ac:	00e7a623          	sw	a4,12(a5)
     8b0:	00c12783          	lw	a5,12(sp)
     8b4:	00878713          	addi	a4,a5,8
     8b8:	00c12783          	lw	a5,12(sp)
     8bc:	00e7a823          	sw	a4,16(a5)
     8c0:	00c12783          	lw	a5,12(sp)
     8c4:	0007a023          	sw	zero,0(a5)
     8c8:	00000013          	nop
     8cc:	01010113          	addi	sp,sp,16
     8d0:	00008067          	ret

000008d4 <vListInitialiseItem>:
     8d4:	ff010113          	addi	sp,sp,-16
     8d8:	00a12623          	sw	a0,12(sp)
     8dc:	00c12783          	lw	a5,12(sp)
     8e0:	0007a823          	sw	zero,16(a5)
     8e4:	00000013          	nop
     8e8:	01010113          	addi	sp,sp,16
     8ec:	00008067          	ret

000008f0 <vListInsertEnd>:
     8f0:	fe010113          	addi	sp,sp,-32
     8f4:	00a12623          	sw	a0,12(sp)
     8f8:	00b12423          	sw	a1,8(sp)
     8fc:	00c12783          	lw	a5,12(sp)
     900:	0047a783          	lw	a5,4(a5)
     904:	00f12e23          	sw	a5,28(sp)
     908:	00812783          	lw	a5,8(sp)
     90c:	01c12703          	lw	a4,28(sp)
     910:	00e7a223          	sw	a4,4(a5)
     914:	01c12783          	lw	a5,28(sp)
     918:	0087a703          	lw	a4,8(a5)
     91c:	00812783          	lw	a5,8(sp)
     920:	00e7a423          	sw	a4,8(a5)
     924:	01c12783          	lw	a5,28(sp)
     928:	0087a783          	lw	a5,8(a5)
     92c:	00812703          	lw	a4,8(sp)
     930:	00e7a223          	sw	a4,4(a5)
     934:	01c12783          	lw	a5,28(sp)
     938:	00812703          	lw	a4,8(sp)
     93c:	00e7a423          	sw	a4,8(a5)
     940:	00812783          	lw	a5,8(sp)
     944:	00c12703          	lw	a4,12(sp)
     948:	00e7a823          	sw	a4,16(a5)
     94c:	00c12783          	lw	a5,12(sp)
     950:	0007a783          	lw	a5,0(a5)
     954:	00178713          	addi	a4,a5,1
     958:	00c12783          	lw	a5,12(sp)
     95c:	00e7a023          	sw	a4,0(a5)
     960:	00000013          	nop
     964:	02010113          	addi	sp,sp,32
     968:	00008067          	ret

0000096c <vListInsert>:
     96c:	fe010113          	addi	sp,sp,-32
     970:	00a12623          	sw	a0,12(sp)
     974:	00b12423          	sw	a1,8(sp)
     978:	00812783          	lw	a5,8(sp)
     97c:	0007a783          	lw	a5,0(a5)
     980:	00f12c23          	sw	a5,24(sp)
     984:	01812703          	lw	a4,24(sp)
     988:	fff00793          	li	a5,-1
     98c:	00f71a63          	bne	a4,a5,9a0 <vListInsert+0x34>
     990:	00c12783          	lw	a5,12(sp)
     994:	0107a783          	lw	a5,16(a5)
     998:	00f12e23          	sw	a5,28(sp)
     99c:	0340006f          	j	9d0 <vListInsert+0x64>
     9a0:	00c12783          	lw	a5,12(sp)
     9a4:	00878793          	addi	a5,a5,8
     9a8:	00f12e23          	sw	a5,28(sp)
     9ac:	0100006f          	j	9bc <vListInsert+0x50>
     9b0:	01c12783          	lw	a5,28(sp)
     9b4:	0047a783          	lw	a5,4(a5)
     9b8:	00f12e23          	sw	a5,28(sp)
     9bc:	01c12783          	lw	a5,28(sp)
     9c0:	0047a783          	lw	a5,4(a5)
     9c4:	0007a783          	lw	a5,0(a5)
     9c8:	01812703          	lw	a4,24(sp)
     9cc:	fef772e3          	bleu	a5,a4,9b0 <vListInsert+0x44>
     9d0:	01c12783          	lw	a5,28(sp)
     9d4:	0047a703          	lw	a4,4(a5)
     9d8:	00812783          	lw	a5,8(sp)
     9dc:	00e7a223          	sw	a4,4(a5)
     9e0:	00812783          	lw	a5,8(sp)
     9e4:	0047a783          	lw	a5,4(a5)
     9e8:	00812703          	lw	a4,8(sp)
     9ec:	00e7a423          	sw	a4,8(a5)
     9f0:	00812783          	lw	a5,8(sp)
     9f4:	01c12703          	lw	a4,28(sp)
     9f8:	00e7a423          	sw	a4,8(a5)
     9fc:	01c12783          	lw	a5,28(sp)
     a00:	00812703          	lw	a4,8(sp)
     a04:	00e7a223          	sw	a4,4(a5)
     a08:	00812783          	lw	a5,8(sp)
     a0c:	00c12703          	lw	a4,12(sp)
     a10:	00e7a823          	sw	a4,16(a5)
     a14:	00c12783          	lw	a5,12(sp)
     a18:	0007a783          	lw	a5,0(a5)
     a1c:	00178713          	addi	a4,a5,1
     a20:	00c12783          	lw	a5,12(sp)
     a24:	00e7a023          	sw	a4,0(a5)
     a28:	00000013          	nop
     a2c:	02010113          	addi	sp,sp,32
     a30:	00008067          	ret

00000a34 <uxListRemove>:
     a34:	fe010113          	addi	sp,sp,-32
     a38:	00a12623          	sw	a0,12(sp)
     a3c:	00c12783          	lw	a5,12(sp)
     a40:	0107a783          	lw	a5,16(a5)
     a44:	00f12e23          	sw	a5,28(sp)
     a48:	00c12783          	lw	a5,12(sp)
     a4c:	0047a783          	lw	a5,4(a5)
     a50:	00c12703          	lw	a4,12(sp)
     a54:	00872703          	lw	a4,8(a4)
     a58:	00e7a423          	sw	a4,8(a5)
     a5c:	00c12783          	lw	a5,12(sp)
     a60:	0087a783          	lw	a5,8(a5)
     a64:	00c12703          	lw	a4,12(sp)
     a68:	00472703          	lw	a4,4(a4)
     a6c:	00e7a223          	sw	a4,4(a5)
     a70:	01c12783          	lw	a5,28(sp)
     a74:	0047a783          	lw	a5,4(a5)
     a78:	00c12703          	lw	a4,12(sp)
     a7c:	00f71a63          	bne	a4,a5,a90 <uxListRemove+0x5c>
     a80:	00c12783          	lw	a5,12(sp)
     a84:	0087a703          	lw	a4,8(a5)
     a88:	01c12783          	lw	a5,28(sp)
     a8c:	00e7a223          	sw	a4,4(a5)
     a90:	00c12783          	lw	a5,12(sp)
     a94:	0007a823          	sw	zero,16(a5)
     a98:	01c12783          	lw	a5,28(sp)
     a9c:	0007a783          	lw	a5,0(a5)
     aa0:	fff78713          	addi	a4,a5,-1
     aa4:	01c12783          	lw	a5,28(sp)
     aa8:	00e7a023          	sw	a4,0(a5)
     aac:	01c12783          	lw	a5,28(sp)
     ab0:	0007a783          	lw	a5,0(a5)
     ab4:	00078513          	mv	a0,a5
     ab8:	02010113          	addi	sp,sp,32
     abc:	00008067          	ret

00000ac0 <xQueueGenericReset>:
     ac0:	fd010113          	addi	sp,sp,-48
     ac4:	02112623          	sw	ra,44(sp)
     ac8:	02812423          	sw	s0,40(sp)
     acc:	00a12623          	sw	a0,12(sp)
     ad0:	00b12423          	sw	a1,8(sp)
     ad4:	00c12783          	lw	a5,12(sp)
     ad8:	00f12e23          	sw	a5,28(sp)
     adc:	01c12783          	lw	a5,28(sp)
     ae0:	00079663          	bnez	a5,aec <xQueueGenericReset+0x2c>
     ae4:	30047073          	csrci	mstatus,8
     ae8:	0000006f          	j	ae8 <xQueueGenericReset+0x28>
     aec:	21c040ef          	jal	ra,4d08 <vTaskEnterCritical>
     af0:	01c12783          	lw	a5,28(sp)
     af4:	0007a403          	lw	s0,0(a5)
     af8:	01c12783          	lw	a5,28(sp)
     afc:	03c7a703          	lw	a4,60(a5)
     b00:	01c12783          	lw	a5,28(sp)
     b04:	0407a783          	lw	a5,64(a5)
     b08:	00078593          	mv	a1,a5
     b0c:	00070513          	mv	a0,a4
     b10:	51c090ef          	jal	ra,a02c <__mulsi3>
     b14:	00050793          	mv	a5,a0
     b18:	00f40733          	add	a4,s0,a5
     b1c:	01c12783          	lw	a5,28(sp)
     b20:	00e7a423          	sw	a4,8(a5)
     b24:	01c12783          	lw	a5,28(sp)
     b28:	0207ac23          	sw	zero,56(a5)
     b2c:	01c12783          	lw	a5,28(sp)
     b30:	0007a703          	lw	a4,0(a5)
     b34:	01c12783          	lw	a5,28(sp)
     b38:	00e7a223          	sw	a4,4(a5)
     b3c:	01c12783          	lw	a5,28(sp)
     b40:	0007a403          	lw	s0,0(a5)
     b44:	01c12783          	lw	a5,28(sp)
     b48:	03c7a783          	lw	a5,60(a5)
     b4c:	fff78713          	addi	a4,a5,-1
     b50:	01c12783          	lw	a5,28(sp)
     b54:	0407a783          	lw	a5,64(a5)
     b58:	00078593          	mv	a1,a5
     b5c:	00070513          	mv	a0,a4
     b60:	4cc090ef          	jal	ra,a02c <__mulsi3>
     b64:	00050793          	mv	a5,a0
     b68:	00f40733          	add	a4,s0,a5
     b6c:	01c12783          	lw	a5,28(sp)
     b70:	00e7a623          	sw	a4,12(a5)
     b74:	01c12783          	lw	a5,28(sp)
     b78:	fff00713          	li	a4,-1
     b7c:	04e78223          	sb	a4,68(a5)
     b80:	01c12783          	lw	a5,28(sp)
     b84:	fff00713          	li	a4,-1
     b88:	04e782a3          	sb	a4,69(a5)
     b8c:	00812783          	lw	a5,8(sp)
     b90:	02079863          	bnez	a5,bc0 <xQueueGenericReset+0x100>
     b94:	01c12783          	lw	a5,28(sp)
     b98:	0107a783          	lw	a5,16(a5)
     b9c:	04078263          	beqz	a5,be0 <xQueueGenericReset+0x120>
     ba0:	01c12783          	lw	a5,28(sp)
     ba4:	01078793          	addi	a5,a5,16
     ba8:	00078513          	mv	a0,a5
     bac:	33c030ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
     bb0:	00050793          	mv	a5,a0
     bb4:	02078663          	beqz	a5,be0 <xQueueGenericReset+0x120>
     bb8:	9ddff0ef          	jal	ra,594 <vPortYield>
     bbc:	0240006f          	j	be0 <xQueueGenericReset+0x120>
     bc0:	01c12783          	lw	a5,28(sp)
     bc4:	01078793          	addi	a5,a5,16
     bc8:	00078513          	mv	a0,a5
     bcc:	cb1ff0ef          	jal	ra,87c <vListInitialise>
     bd0:	01c12783          	lw	a5,28(sp)
     bd4:	02478793          	addi	a5,a5,36
     bd8:	00078513          	mv	a0,a5
     bdc:	ca1ff0ef          	jal	ra,87c <vListInitialise>
     be0:	168040ef          	jal	ra,4d48 <vTaskExitCritical>
     be4:	00100793          	li	a5,1
     be8:	00078513          	mv	a0,a5
     bec:	02c12083          	lw	ra,44(sp)
     bf0:	02812403          	lw	s0,40(sp)
     bf4:	03010113          	addi	sp,sp,48
     bf8:	00008067          	ret

00000bfc <xQueueGenericCreate>:
     bfc:	fd010113          	addi	sp,sp,-48
     c00:	02112623          	sw	ra,44(sp)
     c04:	00a12623          	sw	a0,12(sp)
     c08:	00b12423          	sw	a1,8(sp)
     c0c:	00060793          	mv	a5,a2
     c10:	00f103a3          	sb	a5,7(sp)
     c14:	00c12783          	lw	a5,12(sp)
     c18:	00079663          	bnez	a5,c24 <xQueueGenericCreate+0x28>
     c1c:	30047073          	csrci	mstatus,8
     c20:	0000006f          	j	c20 <xQueueGenericCreate+0x24>
     c24:	00812783          	lw	a5,8(sp)
     c28:	00079663          	bnez	a5,c34 <xQueueGenericCreate+0x38>
     c2c:	00012e23          	sw	zero,28(sp)
     c30:	0180006f          	j	c48 <xQueueGenericCreate+0x4c>
     c34:	00812583          	lw	a1,8(sp)
     c38:	00c12503          	lw	a0,12(sp)
     c3c:	3f0090ef          	jal	ra,a02c <__mulsi3>
     c40:	00050793          	mv	a5,a0
     c44:	00f12e23          	sw	a5,28(sp)
     c48:	01c12783          	lw	a5,28(sp)
     c4c:	05078793          	addi	a5,a5,80
     c50:	00078513          	mv	a0,a5
     c54:	711050ef          	jal	ra,6b64 <pvPortMalloc>
     c58:	00a12c23          	sw	a0,24(sp)
     c5c:	01812783          	lw	a5,24(sp)
     c60:	02078a63          	beqz	a5,c94 <xQueueGenericCreate+0x98>
     c64:	01812783          	lw	a5,24(sp)
     c68:	00f12a23          	sw	a5,20(sp)
     c6c:	01412783          	lw	a5,20(sp)
     c70:	05078793          	addi	a5,a5,80
     c74:	00f12a23          	sw	a5,20(sp)
     c78:	00714783          	lbu	a5,7(sp)
     c7c:	01812703          	lw	a4,24(sp)
     c80:	00078693          	mv	a3,a5
     c84:	01412603          	lw	a2,20(sp)
     c88:	00812583          	lw	a1,8(sp)
     c8c:	00c12503          	lw	a0,12(sp)
     c90:	018000ef          	jal	ra,ca8 <prvInitialiseNewQueue>
     c94:	01812783          	lw	a5,24(sp)
     c98:	00078513          	mv	a0,a5
     c9c:	02c12083          	lw	ra,44(sp)
     ca0:	03010113          	addi	sp,sp,48
     ca4:	00008067          	ret

00000ca8 <prvInitialiseNewQueue>:
     ca8:	fd010113          	addi	sp,sp,-48
     cac:	02112623          	sw	ra,44(sp)
     cb0:	00a12e23          	sw	a0,28(sp)
     cb4:	00b12c23          	sw	a1,24(sp)
     cb8:	00c12a23          	sw	a2,20(sp)
     cbc:	00068793          	mv	a5,a3
     cc0:	00e12623          	sw	a4,12(sp)
     cc4:	00f109a3          	sb	a5,19(sp)
     cc8:	01812783          	lw	a5,24(sp)
     ccc:	00079a63          	bnez	a5,ce0 <prvInitialiseNewQueue+0x38>
     cd0:	00c12783          	lw	a5,12(sp)
     cd4:	00c12703          	lw	a4,12(sp)
     cd8:	00e7a023          	sw	a4,0(a5)
     cdc:	0100006f          	j	cec <prvInitialiseNewQueue+0x44>
     ce0:	00c12783          	lw	a5,12(sp)
     ce4:	01412703          	lw	a4,20(sp)
     ce8:	00e7a023          	sw	a4,0(a5)
     cec:	00c12783          	lw	a5,12(sp)
     cf0:	01c12703          	lw	a4,28(sp)
     cf4:	02e7ae23          	sw	a4,60(a5)
     cf8:	00c12783          	lw	a5,12(sp)
     cfc:	01812703          	lw	a4,24(sp)
     d00:	04e7a023          	sw	a4,64(a5)
     d04:	00100593          	li	a1,1
     d08:	00c12503          	lw	a0,12(sp)
     d0c:	db5ff0ef          	jal	ra,ac0 <xQueueGenericReset>
     d10:	00c12783          	lw	a5,12(sp)
     d14:	01314703          	lbu	a4,19(sp)
     d18:	04e78623          	sb	a4,76(a5)
     d1c:	00000013          	nop
     d20:	02c12083          	lw	ra,44(sp)
     d24:	03010113          	addi	sp,sp,48
     d28:	00008067          	ret

00000d2c <prvInitialiseMutex>:
     d2c:	fe010113          	addi	sp,sp,-32
     d30:	00112e23          	sw	ra,28(sp)
     d34:	00a12623          	sw	a0,12(sp)
     d38:	00c12783          	lw	a5,12(sp)
     d3c:	02078863          	beqz	a5,d6c <prvInitialiseMutex+0x40>
     d40:	00c12783          	lw	a5,12(sp)
     d44:	0007a423          	sw	zero,8(a5)
     d48:	00c12783          	lw	a5,12(sp)
     d4c:	0007a023          	sw	zero,0(a5)
     d50:	00c12783          	lw	a5,12(sp)
     d54:	0007a623          	sw	zero,12(a5)
     d58:	00000693          	li	a3,0
     d5c:	00000613          	li	a2,0
     d60:	00000593          	li	a1,0
     d64:	00c12503          	lw	a0,12(sp)
     d68:	210000ef          	jal	ra,f78 <xQueueGenericSend>
     d6c:	00000013          	nop
     d70:	01c12083          	lw	ra,28(sp)
     d74:	02010113          	addi	sp,sp,32
     d78:	00008067          	ret

00000d7c <xQueueCreateMutex>:
     d7c:	fd010113          	addi	sp,sp,-48
     d80:	02112623          	sw	ra,44(sp)
     d84:	00050793          	mv	a5,a0
     d88:	00f107a3          	sb	a5,15(sp)
     d8c:	00100793          	li	a5,1
     d90:	00f12e23          	sw	a5,28(sp)
     d94:	00012c23          	sw	zero,24(sp)
     d98:	00f14783          	lbu	a5,15(sp)
     d9c:	00078613          	mv	a2,a5
     da0:	01812583          	lw	a1,24(sp)
     da4:	01c12503          	lw	a0,28(sp)
     da8:	e55ff0ef          	jal	ra,bfc <xQueueGenericCreate>
     dac:	00a12a23          	sw	a0,20(sp)
     db0:	01412503          	lw	a0,20(sp)
     db4:	f79ff0ef          	jal	ra,d2c <prvInitialiseMutex>
     db8:	01412783          	lw	a5,20(sp)
     dbc:	00078513          	mv	a0,a5
     dc0:	02c12083          	lw	ra,44(sp)
     dc4:	03010113          	addi	sp,sp,48
     dc8:	00008067          	ret

00000dcc <xQueueGiveMutexRecursive>:
     dcc:	fd010113          	addi	sp,sp,-48
     dd0:	02112623          	sw	ra,44(sp)
     dd4:	02812423          	sw	s0,40(sp)
     dd8:	00a12623          	sw	a0,12(sp)
     ddc:	00c12783          	lw	a5,12(sp)
     de0:	00f12c23          	sw	a5,24(sp)
     de4:	01812783          	lw	a5,24(sp)
     de8:	00079663          	bnez	a5,df4 <xQueueGiveMutexRecursive+0x28>
     dec:	30047073          	csrci	mstatus,8
     df0:	0000006f          	j	df0 <xQueueGiveMutexRecursive+0x24>
     df4:	01812783          	lw	a5,24(sp)
     df8:	0087a403          	lw	s0,8(a5)
     dfc:	251030ef          	jal	ra,484c <xTaskGetCurrentTaskHandle>
     e00:	00050793          	mv	a5,a0
     e04:	04f41263          	bne	s0,a5,e48 <xQueueGiveMutexRecursive+0x7c>
     e08:	01812783          	lw	a5,24(sp)
     e0c:	00c7a783          	lw	a5,12(a5)
     e10:	fff78713          	addi	a4,a5,-1
     e14:	01812783          	lw	a5,24(sp)
     e18:	00e7a623          	sw	a4,12(a5)
     e1c:	01812783          	lw	a5,24(sp)
     e20:	00c7a783          	lw	a5,12(a5)
     e24:	00079c63          	bnez	a5,e3c <xQueueGiveMutexRecursive+0x70>
     e28:	00000693          	li	a3,0
     e2c:	00000613          	li	a2,0
     e30:	00000593          	li	a1,0
     e34:	01812503          	lw	a0,24(sp)
     e38:	140000ef          	jal	ra,f78 <xQueueGenericSend>
     e3c:	00100793          	li	a5,1
     e40:	00f12e23          	sw	a5,28(sp)
     e44:	0080006f          	j	e4c <xQueueGiveMutexRecursive+0x80>
     e48:	00012e23          	sw	zero,28(sp)
     e4c:	01c12783          	lw	a5,28(sp)
     e50:	00078513          	mv	a0,a5
     e54:	02c12083          	lw	ra,44(sp)
     e58:	02812403          	lw	s0,40(sp)
     e5c:	03010113          	addi	sp,sp,48
     e60:	00008067          	ret

00000e64 <xQueueTakeMutexRecursive>:
     e64:	fd010113          	addi	sp,sp,-48
     e68:	02112623          	sw	ra,44(sp)
     e6c:	02812423          	sw	s0,40(sp)
     e70:	00a12623          	sw	a0,12(sp)
     e74:	00b12423          	sw	a1,8(sp)
     e78:	00c12783          	lw	a5,12(sp)
     e7c:	00f12c23          	sw	a5,24(sp)
     e80:	01812783          	lw	a5,24(sp)
     e84:	00079663          	bnez	a5,e90 <xQueueTakeMutexRecursive+0x2c>
     e88:	30047073          	csrci	mstatus,8
     e8c:	0000006f          	j	e8c <xQueueTakeMutexRecursive+0x28>
     e90:	01812783          	lw	a5,24(sp)
     e94:	0087a403          	lw	s0,8(a5)
     e98:	1b5030ef          	jal	ra,484c <xTaskGetCurrentTaskHandle>
     e9c:	00050793          	mv	a5,a0
     ea0:	02f41263          	bne	s0,a5,ec4 <xQueueTakeMutexRecursive+0x60>
     ea4:	01812783          	lw	a5,24(sp)
     ea8:	00c7a783          	lw	a5,12(a5)
     eac:	00178713          	addi	a4,a5,1
     eb0:	01812783          	lw	a5,24(sp)
     eb4:	00e7a623          	sw	a4,12(a5)
     eb8:	00100793          	li	a5,1
     ebc:	00f12e23          	sw	a5,28(sp)
     ec0:	0300006f          	j	ef0 <xQueueTakeMutexRecursive+0x8c>
     ec4:	00812583          	lw	a1,8(sp)
     ec8:	01812503          	lw	a0,24(sp)
     ecc:	7b8000ef          	jal	ra,1684 <xQueueSemaphoreTake>
     ed0:	00a12e23          	sw	a0,28(sp)
     ed4:	01c12783          	lw	a5,28(sp)
     ed8:	00078c63          	beqz	a5,ef0 <xQueueTakeMutexRecursive+0x8c>
     edc:	01812783          	lw	a5,24(sp)
     ee0:	00c7a783          	lw	a5,12(a5)
     ee4:	00178713          	addi	a4,a5,1
     ee8:	01812783          	lw	a5,24(sp)
     eec:	00e7a623          	sw	a4,12(a5)
     ef0:	01c12783          	lw	a5,28(sp)
     ef4:	00078513          	mv	a0,a5
     ef8:	02c12083          	lw	ra,44(sp)
     efc:	02812403          	lw	s0,40(sp)
     f00:	03010113          	addi	sp,sp,48
     f04:	00008067          	ret

00000f08 <xQueueCreateCountingSemaphore>:
     f08:	fd010113          	addi	sp,sp,-48
     f0c:	02112623          	sw	ra,44(sp)
     f10:	00a12623          	sw	a0,12(sp)
     f14:	00b12423          	sw	a1,8(sp)
     f18:	00c12783          	lw	a5,12(sp)
     f1c:	00079663          	bnez	a5,f28 <xQueueCreateCountingSemaphore+0x20>
     f20:	30047073          	csrci	mstatus,8
     f24:	0000006f          	j	f24 <xQueueCreateCountingSemaphore+0x1c>
     f28:	00812703          	lw	a4,8(sp)
     f2c:	00c12783          	lw	a5,12(sp)
     f30:	00e7f663          	bleu	a4,a5,f3c <xQueueCreateCountingSemaphore+0x34>
     f34:	30047073          	csrci	mstatus,8
     f38:	0000006f          	j	f38 <xQueueCreateCountingSemaphore+0x30>
     f3c:	00200613          	li	a2,2
     f40:	00000593          	li	a1,0
     f44:	00c12503          	lw	a0,12(sp)
     f48:	cb5ff0ef          	jal	ra,bfc <xQueueGenericCreate>
     f4c:	00a12e23          	sw	a0,28(sp)
     f50:	01c12783          	lw	a5,28(sp)
     f54:	00078863          	beqz	a5,f64 <xQueueCreateCountingSemaphore+0x5c>
     f58:	01c12783          	lw	a5,28(sp)
     f5c:	00812703          	lw	a4,8(sp)
     f60:	02e7ac23          	sw	a4,56(a5)
     f64:	01c12783          	lw	a5,28(sp)
     f68:	00078513          	mv	a0,a5
     f6c:	02c12083          	lw	ra,44(sp)
     f70:	03010113          	addi	sp,sp,48
     f74:	00008067          	ret

00000f78 <xQueueGenericSend>:
     f78:	fc010113          	addi	sp,sp,-64
     f7c:	02112e23          	sw	ra,60(sp)
     f80:	00a12623          	sw	a0,12(sp)
     f84:	00b12423          	sw	a1,8(sp)
     f88:	00c12223          	sw	a2,4(sp)
     f8c:	00d12023          	sw	a3,0(sp)
     f90:	02012623          	sw	zero,44(sp)
     f94:	00c12783          	lw	a5,12(sp)
     f98:	02f12423          	sw	a5,40(sp)
     f9c:	02812783          	lw	a5,40(sp)
     fa0:	00079663          	bnez	a5,fac <xQueueGenericSend+0x34>
     fa4:	30047073          	csrci	mstatus,8
     fa8:	0000006f          	j	fa8 <xQueueGenericSend+0x30>
     fac:	00812783          	lw	a5,8(sp)
     fb0:	00079863          	bnez	a5,fc0 <xQueueGenericSend+0x48>
     fb4:	02812783          	lw	a5,40(sp)
     fb8:	0407a783          	lw	a5,64(a5)
     fbc:	00079663          	bnez	a5,fc8 <xQueueGenericSend+0x50>
     fc0:	00100793          	li	a5,1
     fc4:	0080006f          	j	fcc <xQueueGenericSend+0x54>
     fc8:	00000793          	li	a5,0
     fcc:	00079663          	bnez	a5,fd8 <xQueueGenericSend+0x60>
     fd0:	30047073          	csrci	mstatus,8
     fd4:	0000006f          	j	fd4 <xQueueGenericSend+0x5c>
     fd8:	00012703          	lw	a4,0(sp)
     fdc:	00200793          	li	a5,2
     fe0:	00f71a63          	bne	a4,a5,ff4 <xQueueGenericSend+0x7c>
     fe4:	02812783          	lw	a5,40(sp)
     fe8:	03c7a703          	lw	a4,60(a5)
     fec:	00100793          	li	a5,1
     ff0:	00f71663          	bne	a4,a5,ffc <xQueueGenericSend+0x84>
     ff4:	00100793          	li	a5,1
     ff8:	0080006f          	j	1000 <_HEAP_SIZE>
     ffc:	00000793          	li	a5,0
    1000:	00079663          	bnez	a5,100c <_HEAP_SIZE+0xc>
    1004:	30047073          	csrci	mstatus,8
    1008:	0000006f          	j	1008 <_HEAP_SIZE+0x8>
    100c:	065030ef          	jal	ra,4870 <xTaskGetSchedulerState>
    1010:	00050793          	mv	a5,a0
    1014:	00079663          	bnez	a5,1020 <_HEAP_SIZE+0x20>
    1018:	00412783          	lw	a5,4(sp)
    101c:	00079663          	bnez	a5,1028 <_HEAP_SIZE+0x28>
    1020:	00100793          	li	a5,1
    1024:	0080006f          	j	102c <_HEAP_SIZE+0x2c>
    1028:	00000793          	li	a5,0
    102c:	00079663          	bnez	a5,1038 <_HEAP_SIZE+0x38>
    1030:	30047073          	csrci	mstatus,8
    1034:	0000006f          	j	1034 <_HEAP_SIZE+0x34>
    1038:	4d1030ef          	jal	ra,4d08 <vTaskEnterCritical>
    103c:	02812783          	lw	a5,40(sp)
    1040:	0387a703          	lw	a4,56(a5)
    1044:	02812783          	lw	a5,40(sp)
    1048:	03c7a783          	lw	a5,60(a5)
    104c:	00f76863          	bltu	a4,a5,105c <_HEAP_SIZE+0x5c>
    1050:	00012703          	lw	a4,0(sp)
    1054:	00200793          	li	a5,2
    1058:	04f71e63          	bne	a4,a5,10b4 <_HEAP_SIZE+0xb4>
    105c:	00012603          	lw	a2,0(sp)
    1060:	00812583          	lw	a1,8(sp)
    1064:	02812503          	lw	a0,40(sp)
    1068:	669000ef          	jal	ra,1ed0 <prvCopyDataToQueue>
    106c:	02a12223          	sw	a0,36(sp)
    1070:	02812783          	lw	a5,40(sp)
    1074:	0247a783          	lw	a5,36(a5)
    1078:	02078263          	beqz	a5,109c <_HEAP_SIZE+0x9c>
    107c:	02812783          	lw	a5,40(sp)
    1080:	02478793          	addi	a5,a5,36
    1084:	00078513          	mv	a0,a5
    1088:	661020ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    108c:	00050793          	mv	a5,a0
    1090:	00078c63          	beqz	a5,10a8 <_HEAP_SIZE+0xa8>
    1094:	d00ff0ef          	jal	ra,594 <vPortYield>
    1098:	0100006f          	j	10a8 <_HEAP_SIZE+0xa8>
    109c:	02412783          	lw	a5,36(sp)
    10a0:	00078463          	beqz	a5,10a8 <_HEAP_SIZE+0xa8>
    10a4:	cf0ff0ef          	jal	ra,594 <vPortYield>
    10a8:	4a1030ef          	jal	ra,4d48 <vTaskExitCritical>
    10ac:	00100793          	li	a5,1
    10b0:	1040006f          	j	11b4 <_HEAP_SIZE+0x1b4>
    10b4:	00412783          	lw	a5,4(sp)
    10b8:	00079863          	bnez	a5,10c8 <_HEAP_SIZE+0xc8>
    10bc:	48d030ef          	jal	ra,4d48 <vTaskExitCritical>
    10c0:	00000793          	li	a5,0
    10c4:	0f00006f          	j	11b4 <_HEAP_SIZE+0x1b4>
    10c8:	02c12783          	lw	a5,44(sp)
    10cc:	00079c63          	bnez	a5,10e4 <_HEAP_SIZE+0xe4>
    10d0:	01c10793          	addi	a5,sp,28
    10d4:	00078513          	mv	a0,a5
    10d8:	0a8030ef          	jal	ra,4180 <vTaskInternalSetTimeOutState>
    10dc:	00100793          	li	a5,1
    10e0:	02f12623          	sw	a5,44(sp)
    10e4:	465030ef          	jal	ra,4d48 <vTaskExitCritical>
    10e8:	3ac020ef          	jal	ra,3494 <vTaskSuspendAll>
    10ec:	41d030ef          	jal	ra,4d08 <vTaskEnterCritical>
    10f0:	02812783          	lw	a5,40(sp)
    10f4:	0447c783          	lbu	a5,68(a5)
    10f8:	01879713          	slli	a4,a5,0x18
    10fc:	41875713          	srai	a4,a4,0x18
    1100:	fff00793          	li	a5,-1
    1104:	00f71663          	bne	a4,a5,1110 <_HEAP_SIZE+0x110>
    1108:	02812783          	lw	a5,40(sp)
    110c:	04078223          	sb	zero,68(a5)
    1110:	02812783          	lw	a5,40(sp)
    1114:	0457c783          	lbu	a5,69(a5)
    1118:	01879713          	slli	a4,a5,0x18
    111c:	41875713          	srai	a4,a4,0x18
    1120:	fff00793          	li	a5,-1
    1124:	00f71663          	bne	a4,a5,1130 <_HEAP_SIZE+0x130>
    1128:	02812783          	lw	a5,40(sp)
    112c:	040782a3          	sb	zero,69(a5)
    1130:	419030ef          	jal	ra,4d48 <vTaskExitCritical>
    1134:	00410713          	addi	a4,sp,4
    1138:	01c10793          	addi	a5,sp,28
    113c:	00070593          	mv	a1,a4
    1140:	00078513          	mv	a0,a5
    1144:	078030ef          	jal	ra,41bc <xTaskCheckForTimeOut>
    1148:	00050793          	mv	a5,a0
    114c:	04079c63          	bnez	a5,11a4 <_HEAP_SIZE+0x1a4>
    1150:	02812503          	lw	a0,40(sp)
    1154:	10c010ef          	jal	ra,2260 <prvIsQueueFull>
    1158:	00050793          	mv	a5,a0
    115c:	02078c63          	beqz	a5,1194 <_HEAP_SIZE+0x194>
    1160:	02812783          	lw	a5,40(sp)
    1164:	01078793          	addi	a5,a5,16
    1168:	00412703          	lw	a4,4(sp)
    116c:	00070593          	mv	a1,a4
    1170:	00078513          	mv	a0,a5
    1174:	421020ef          	jal	ra,3d94 <vTaskPlaceOnEventList>
    1178:	02812503          	lw	a0,40(sp)
    117c:	761000ef          	jal	ra,20dc <prvUnlockQueue>
    1180:	338020ef          	jal	ra,34b8 <xTaskResumeAll>
    1184:	00050793          	mv	a5,a0
    1188:	ea0798e3          	bnez	a5,1038 <_HEAP_SIZE+0x38>
    118c:	c08ff0ef          	jal	ra,594 <vPortYield>
    1190:	ea9ff06f          	j	1038 <_HEAP_SIZE+0x38>
    1194:	02812503          	lw	a0,40(sp)
    1198:	745000ef          	jal	ra,20dc <prvUnlockQueue>
    119c:	31c020ef          	jal	ra,34b8 <xTaskResumeAll>
    11a0:	e99ff06f          	j	1038 <_HEAP_SIZE+0x38>
    11a4:	02812503          	lw	a0,40(sp)
    11a8:	735000ef          	jal	ra,20dc <prvUnlockQueue>
    11ac:	30c020ef          	jal	ra,34b8 <xTaskResumeAll>
    11b0:	00000793          	li	a5,0
    11b4:	00078513          	mv	a0,a5
    11b8:	03c12083          	lw	ra,60(sp)
    11bc:	04010113          	addi	sp,sp,64
    11c0:	00008067          	ret

000011c4 <xQueueGenericSendFromISR>:
    11c4:	fd010113          	addi	sp,sp,-48
    11c8:	02112623          	sw	ra,44(sp)
    11cc:	00a12623          	sw	a0,12(sp)
    11d0:	00b12423          	sw	a1,8(sp)
    11d4:	00c12223          	sw	a2,4(sp)
    11d8:	00d12023          	sw	a3,0(sp)
    11dc:	00c12783          	lw	a5,12(sp)
    11e0:	00f12c23          	sw	a5,24(sp)
    11e4:	01812783          	lw	a5,24(sp)
    11e8:	00079663          	bnez	a5,11f4 <xQueueGenericSendFromISR+0x30>
    11ec:	30047073          	csrci	mstatus,8
    11f0:	0000006f          	j	11f0 <xQueueGenericSendFromISR+0x2c>
    11f4:	00812783          	lw	a5,8(sp)
    11f8:	00079863          	bnez	a5,1208 <xQueueGenericSendFromISR+0x44>
    11fc:	01812783          	lw	a5,24(sp)
    1200:	0407a783          	lw	a5,64(a5)
    1204:	00079663          	bnez	a5,1210 <xQueueGenericSendFromISR+0x4c>
    1208:	00100793          	li	a5,1
    120c:	0080006f          	j	1214 <xQueueGenericSendFromISR+0x50>
    1210:	00000793          	li	a5,0
    1214:	00079663          	bnez	a5,1220 <xQueueGenericSendFromISR+0x5c>
    1218:	30047073          	csrci	mstatus,8
    121c:	0000006f          	j	121c <xQueueGenericSendFromISR+0x58>
    1220:	00012703          	lw	a4,0(sp)
    1224:	00200793          	li	a5,2
    1228:	00f71a63          	bne	a4,a5,123c <xQueueGenericSendFromISR+0x78>
    122c:	01812783          	lw	a5,24(sp)
    1230:	03c7a703          	lw	a4,60(a5)
    1234:	00100793          	li	a5,1
    1238:	00f71663          	bne	a4,a5,1244 <xQueueGenericSendFromISR+0x80>
    123c:	00100793          	li	a5,1
    1240:	0080006f          	j	1248 <xQueueGenericSendFromISR+0x84>
    1244:	00000793          	li	a5,0
    1248:	00079663          	bnez	a5,1254 <xQueueGenericSendFromISR+0x90>
    124c:	30047073          	csrci	mstatus,8
    1250:	0000006f          	j	1250 <xQueueGenericSendFromISR+0x8c>
    1254:	d54ff0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    1258:	00050793          	mv	a5,a0
    125c:	00f12a23          	sw	a5,20(sp)
    1260:	01812783          	lw	a5,24(sp)
    1264:	0387a703          	lw	a4,56(a5)
    1268:	01812783          	lw	a5,24(sp)
    126c:	03c7a783          	lw	a5,60(a5)
    1270:	00f76863          	bltu	a4,a5,1280 <xQueueGenericSendFromISR+0xbc>
    1274:	00012703          	lw	a4,0(sp)
    1278:	00200793          	li	a5,2
    127c:	08f71863          	bne	a4,a5,130c <xQueueGenericSendFromISR+0x148>
    1280:	01812783          	lw	a5,24(sp)
    1284:	0457c783          	lbu	a5,69(a5)
    1288:	00f109a3          	sb	a5,19(sp)
    128c:	00012603          	lw	a2,0(sp)
    1290:	00812583          	lw	a1,8(sp)
    1294:	01812503          	lw	a0,24(sp)
    1298:	439000ef          	jal	ra,1ed0 <prvCopyDataToQueue>
    129c:	01310703          	lb	a4,19(sp)
    12a0:	fff00793          	li	a5,-1
    12a4:	04f71063          	bne	a4,a5,12e4 <xQueueGenericSendFromISR+0x120>
    12a8:	01812783          	lw	a5,24(sp)
    12ac:	0247a783          	lw	a5,36(a5)
    12b0:	04078863          	beqz	a5,1300 <xQueueGenericSendFromISR+0x13c>
    12b4:	01812783          	lw	a5,24(sp)
    12b8:	02478793          	addi	a5,a5,36
    12bc:	00078513          	mv	a0,a5
    12c0:	429020ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    12c4:	00050793          	mv	a5,a0
    12c8:	02078c63          	beqz	a5,1300 <xQueueGenericSendFromISR+0x13c>
    12cc:	00412783          	lw	a5,4(sp)
    12d0:	02078863          	beqz	a5,1300 <xQueueGenericSendFromISR+0x13c>
    12d4:	00412783          	lw	a5,4(sp)
    12d8:	00100713          	li	a4,1
    12dc:	00e7a023          	sw	a4,0(a5)
    12e0:	0200006f          	j	1300 <xQueueGenericSendFromISR+0x13c>
    12e4:	01314783          	lbu	a5,19(sp)
    12e8:	00178793          	addi	a5,a5,1
    12ec:	0ff7f793          	andi	a5,a5,255
    12f0:	01879713          	slli	a4,a5,0x18
    12f4:	41875713          	srai	a4,a4,0x18
    12f8:	01812783          	lw	a5,24(sp)
    12fc:	04e782a3          	sb	a4,69(a5)
    1300:	00100793          	li	a5,1
    1304:	00f12e23          	sw	a5,28(sp)
    1308:	0080006f          	j	1310 <xQueueGenericSendFromISR+0x14c>
    130c:	00012e23          	sw	zero,28(sp)
    1310:	01412783          	lw	a5,20(sp)
    1314:	00078513          	mv	a0,a5
    1318:	c74ff0ef          	jal	ra,78c <vPortClearInterruptMask>
    131c:	01c12783          	lw	a5,28(sp)
    1320:	00078513          	mv	a0,a5
    1324:	02c12083          	lw	ra,44(sp)
    1328:	03010113          	addi	sp,sp,48
    132c:	00008067          	ret

00001330 <xQueueGiveFromISR>:
    1330:	fc010113          	addi	sp,sp,-64
    1334:	02112e23          	sw	ra,60(sp)
    1338:	00a12623          	sw	a0,12(sp)
    133c:	00b12423          	sw	a1,8(sp)
    1340:	00c12783          	lw	a5,12(sp)
    1344:	02f12423          	sw	a5,40(sp)
    1348:	02812783          	lw	a5,40(sp)
    134c:	00079663          	bnez	a5,1358 <xQueueGiveFromISR+0x28>
    1350:	30047073          	csrci	mstatus,8
    1354:	0000006f          	j	1354 <xQueueGiveFromISR+0x24>
    1358:	02812783          	lw	a5,40(sp)
    135c:	0407a783          	lw	a5,64(a5)
    1360:	00078663          	beqz	a5,136c <xQueueGiveFromISR+0x3c>
    1364:	30047073          	csrci	mstatus,8
    1368:	0000006f          	j	1368 <xQueueGiveFromISR+0x38>
    136c:	02812783          	lw	a5,40(sp)
    1370:	0007a783          	lw	a5,0(a5)
    1374:	00079863          	bnez	a5,1384 <xQueueGiveFromISR+0x54>
    1378:	02812783          	lw	a5,40(sp)
    137c:	0087a783          	lw	a5,8(a5)
    1380:	00079663          	bnez	a5,138c <xQueueGiveFromISR+0x5c>
    1384:	00100793          	li	a5,1
    1388:	0080006f          	j	1390 <xQueueGiveFromISR+0x60>
    138c:	00000793          	li	a5,0
    1390:	00079663          	bnez	a5,139c <xQueueGiveFromISR+0x6c>
    1394:	30047073          	csrci	mstatus,8
    1398:	0000006f          	j	1398 <xQueueGiveFromISR+0x68>
    139c:	c0cff0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    13a0:	00050793          	mv	a5,a0
    13a4:	02f12223          	sw	a5,36(sp)
    13a8:	02812783          	lw	a5,40(sp)
    13ac:	0387a783          	lw	a5,56(a5)
    13b0:	02f12023          	sw	a5,32(sp)
    13b4:	02812783          	lw	a5,40(sp)
    13b8:	03c7a783          	lw	a5,60(a5)
    13bc:	02012703          	lw	a4,32(sp)
    13c0:	08f77863          	bleu	a5,a4,1450 <xQueueGiveFromISR+0x120>
    13c4:	02812783          	lw	a5,40(sp)
    13c8:	0457c783          	lbu	a5,69(a5)
    13cc:	00f10fa3          	sb	a5,31(sp)
    13d0:	02012783          	lw	a5,32(sp)
    13d4:	00178713          	addi	a4,a5,1
    13d8:	02812783          	lw	a5,40(sp)
    13dc:	02e7ac23          	sw	a4,56(a5)
    13e0:	01f10703          	lb	a4,31(sp)
    13e4:	fff00793          	li	a5,-1
    13e8:	04f71063          	bne	a4,a5,1428 <xQueueGiveFromISR+0xf8>
    13ec:	02812783          	lw	a5,40(sp)
    13f0:	0247a783          	lw	a5,36(a5)
    13f4:	04078863          	beqz	a5,1444 <xQueueGiveFromISR+0x114>
    13f8:	02812783          	lw	a5,40(sp)
    13fc:	02478793          	addi	a5,a5,36
    1400:	00078513          	mv	a0,a5
    1404:	2e5020ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    1408:	00050793          	mv	a5,a0
    140c:	02078c63          	beqz	a5,1444 <xQueueGiveFromISR+0x114>
    1410:	00812783          	lw	a5,8(sp)
    1414:	02078863          	beqz	a5,1444 <xQueueGiveFromISR+0x114>
    1418:	00812783          	lw	a5,8(sp)
    141c:	00100713          	li	a4,1
    1420:	00e7a023          	sw	a4,0(a5)
    1424:	0200006f          	j	1444 <xQueueGiveFromISR+0x114>
    1428:	01f14783          	lbu	a5,31(sp)
    142c:	00178793          	addi	a5,a5,1
    1430:	0ff7f793          	andi	a5,a5,255
    1434:	01879713          	slli	a4,a5,0x18
    1438:	41875713          	srai	a4,a4,0x18
    143c:	02812783          	lw	a5,40(sp)
    1440:	04e782a3          	sb	a4,69(a5)
    1444:	00100793          	li	a5,1
    1448:	02f12623          	sw	a5,44(sp)
    144c:	0080006f          	j	1454 <xQueueGiveFromISR+0x124>
    1450:	02012623          	sw	zero,44(sp)
    1454:	02412783          	lw	a5,36(sp)
    1458:	00078513          	mv	a0,a5
    145c:	b30ff0ef          	jal	ra,78c <vPortClearInterruptMask>
    1460:	02c12783          	lw	a5,44(sp)
    1464:	00078513          	mv	a0,a5
    1468:	03c12083          	lw	ra,60(sp)
    146c:	04010113          	addi	sp,sp,64
    1470:	00008067          	ret

00001474 <xQueueReceive>:
    1474:	fc010113          	addi	sp,sp,-64
    1478:	02112e23          	sw	ra,60(sp)
    147c:	00a12623          	sw	a0,12(sp)
    1480:	00b12423          	sw	a1,8(sp)
    1484:	00c12223          	sw	a2,4(sp)
    1488:	02012623          	sw	zero,44(sp)
    148c:	00c12783          	lw	a5,12(sp)
    1490:	02f12423          	sw	a5,40(sp)
    1494:	02812783          	lw	a5,40(sp)
    1498:	00079663          	bnez	a5,14a4 <xQueueReceive+0x30>
    149c:	30047073          	csrci	mstatus,8
    14a0:	0000006f          	j	14a0 <xQueueReceive+0x2c>
    14a4:	00812783          	lw	a5,8(sp)
    14a8:	00079863          	bnez	a5,14b8 <xQueueReceive+0x44>
    14ac:	02812783          	lw	a5,40(sp)
    14b0:	0407a783          	lw	a5,64(a5)
    14b4:	00079663          	bnez	a5,14c0 <xQueueReceive+0x4c>
    14b8:	00100793          	li	a5,1
    14bc:	0080006f          	j	14c4 <xQueueReceive+0x50>
    14c0:	00000793          	li	a5,0
    14c4:	00079663          	bnez	a5,14d0 <xQueueReceive+0x5c>
    14c8:	30047073          	csrci	mstatus,8
    14cc:	0000006f          	j	14cc <xQueueReceive+0x58>
    14d0:	3a0030ef          	jal	ra,4870 <xTaskGetSchedulerState>
    14d4:	00050793          	mv	a5,a0
    14d8:	00079663          	bnez	a5,14e4 <xQueueReceive+0x70>
    14dc:	00412783          	lw	a5,4(sp)
    14e0:	00079663          	bnez	a5,14ec <xQueueReceive+0x78>
    14e4:	00100793          	li	a5,1
    14e8:	0080006f          	j	14f0 <xQueueReceive+0x7c>
    14ec:	00000793          	li	a5,0
    14f0:	00079663          	bnez	a5,14fc <xQueueReceive+0x88>
    14f4:	30047073          	csrci	mstatus,8
    14f8:	0000006f          	j	14f8 <xQueueReceive+0x84>
    14fc:	00d030ef          	jal	ra,4d08 <vTaskEnterCritical>
    1500:	02812783          	lw	a5,40(sp)
    1504:	0387a783          	lw	a5,56(a5)
    1508:	02f12223          	sw	a5,36(sp)
    150c:	02412783          	lw	a5,36(sp)
    1510:	04078a63          	beqz	a5,1564 <xQueueReceive+0xf0>
    1514:	00812583          	lw	a1,8(sp)
    1518:	02812503          	lw	a0,40(sp)
    151c:	335000ef          	jal	ra,2050 <prvCopyDataFromQueue>
    1520:	02412783          	lw	a5,36(sp)
    1524:	fff78713          	addi	a4,a5,-1
    1528:	02812783          	lw	a5,40(sp)
    152c:	02e7ac23          	sw	a4,56(a5)
    1530:	02812783          	lw	a5,40(sp)
    1534:	0107a783          	lw	a5,16(a5)
    1538:	02078063          	beqz	a5,1558 <xQueueReceive+0xe4>
    153c:	02812783          	lw	a5,40(sp)
    1540:	01078793          	addi	a5,a5,16
    1544:	00078513          	mv	a0,a5
    1548:	1a1020ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    154c:	00050793          	mv	a5,a0
    1550:	00078463          	beqz	a5,1558 <xQueueReceive+0xe4>
    1554:	840ff0ef          	jal	ra,594 <vPortYield>
    1558:	7f0030ef          	jal	ra,4d48 <vTaskExitCritical>
    155c:	00100793          	li	a5,1
    1560:	1140006f          	j	1674 <xQueueReceive+0x200>
    1564:	00412783          	lw	a5,4(sp)
    1568:	00079863          	bnez	a5,1578 <xQueueReceive+0x104>
    156c:	7dc030ef          	jal	ra,4d48 <vTaskExitCritical>
    1570:	00000793          	li	a5,0
    1574:	1000006f          	j	1674 <xQueueReceive+0x200>
    1578:	02c12783          	lw	a5,44(sp)
    157c:	00079c63          	bnez	a5,1594 <xQueueReceive+0x120>
    1580:	01c10793          	addi	a5,sp,28
    1584:	00078513          	mv	a0,a5
    1588:	3f9020ef          	jal	ra,4180 <vTaskInternalSetTimeOutState>
    158c:	00100793          	li	a5,1
    1590:	02f12623          	sw	a5,44(sp)
    1594:	7b4030ef          	jal	ra,4d48 <vTaskExitCritical>
    1598:	6fd010ef          	jal	ra,3494 <vTaskSuspendAll>
    159c:	76c030ef          	jal	ra,4d08 <vTaskEnterCritical>
    15a0:	02812783          	lw	a5,40(sp)
    15a4:	0447c783          	lbu	a5,68(a5)
    15a8:	01879713          	slli	a4,a5,0x18
    15ac:	41875713          	srai	a4,a4,0x18
    15b0:	fff00793          	li	a5,-1
    15b4:	00f71663          	bne	a4,a5,15c0 <xQueueReceive+0x14c>
    15b8:	02812783          	lw	a5,40(sp)
    15bc:	04078223          	sb	zero,68(a5)
    15c0:	02812783          	lw	a5,40(sp)
    15c4:	0457c783          	lbu	a5,69(a5)
    15c8:	01879713          	slli	a4,a5,0x18
    15cc:	41875713          	srai	a4,a4,0x18
    15d0:	fff00793          	li	a5,-1
    15d4:	00f71663          	bne	a4,a5,15e0 <xQueueReceive+0x16c>
    15d8:	02812783          	lw	a5,40(sp)
    15dc:	040782a3          	sb	zero,69(a5)
    15e0:	768030ef          	jal	ra,4d48 <vTaskExitCritical>
    15e4:	00410713          	addi	a4,sp,4
    15e8:	01c10793          	addi	a5,sp,28
    15ec:	00070593          	mv	a1,a4
    15f0:	00078513          	mv	a0,a5
    15f4:	3c9020ef          	jal	ra,41bc <xTaskCheckForTimeOut>
    15f8:	00050793          	mv	a5,a0
    15fc:	04079c63          	bnez	a5,1654 <xQueueReceive+0x1e0>
    1600:	02812503          	lw	a0,40(sp)
    1604:	3cd000ef          	jal	ra,21d0 <prvIsQueueEmpty>
    1608:	00050793          	mv	a5,a0
    160c:	02078c63          	beqz	a5,1644 <xQueueReceive+0x1d0>
    1610:	02812783          	lw	a5,40(sp)
    1614:	02478793          	addi	a5,a5,36
    1618:	00412703          	lw	a4,4(sp)
    161c:	00070593          	mv	a1,a4
    1620:	00078513          	mv	a0,a5
    1624:	770020ef          	jal	ra,3d94 <vTaskPlaceOnEventList>
    1628:	02812503          	lw	a0,40(sp)
    162c:	2b1000ef          	jal	ra,20dc <prvUnlockQueue>
    1630:	689010ef          	jal	ra,34b8 <xTaskResumeAll>
    1634:	00050793          	mv	a5,a0
    1638:	ec0792e3          	bnez	a5,14fc <xQueueReceive+0x88>
    163c:	f59fe0ef          	jal	ra,594 <vPortYield>
    1640:	ebdff06f          	j	14fc <xQueueReceive+0x88>
    1644:	02812503          	lw	a0,40(sp)
    1648:	295000ef          	jal	ra,20dc <prvUnlockQueue>
    164c:	66d010ef          	jal	ra,34b8 <xTaskResumeAll>
    1650:	eadff06f          	j	14fc <xQueueReceive+0x88>
    1654:	02812503          	lw	a0,40(sp)
    1658:	285000ef          	jal	ra,20dc <prvUnlockQueue>
    165c:	65d010ef          	jal	ra,34b8 <xTaskResumeAll>
    1660:	02812503          	lw	a0,40(sp)
    1664:	36d000ef          	jal	ra,21d0 <prvIsQueueEmpty>
    1668:	00050793          	mv	a5,a0
    166c:	e80788e3          	beqz	a5,14fc <xQueueReceive+0x88>
    1670:	00000793          	li	a5,0
    1674:	00078513          	mv	a0,a5
    1678:	03c12083          	lw	ra,60(sp)
    167c:	04010113          	addi	sp,sp,64
    1680:	00008067          	ret

00001684 <xQueueSemaphoreTake>:
    1684:	fc010113          	addi	sp,sp,-64
    1688:	02112e23          	sw	ra,60(sp)
    168c:	00a12623          	sw	a0,12(sp)
    1690:	00b12423          	sw	a1,8(sp)
    1694:	02012623          	sw	zero,44(sp)
    1698:	00c12783          	lw	a5,12(sp)
    169c:	02f12223          	sw	a5,36(sp)
    16a0:	02012423          	sw	zero,40(sp)
    16a4:	02412783          	lw	a5,36(sp)
    16a8:	00079663          	bnez	a5,16b4 <xQueueSemaphoreTake+0x30>
    16ac:	30047073          	csrci	mstatus,8
    16b0:	0000006f          	j	16b0 <xQueueSemaphoreTake+0x2c>
    16b4:	02412783          	lw	a5,36(sp)
    16b8:	0407a783          	lw	a5,64(a5)
    16bc:	00078663          	beqz	a5,16c8 <xQueueSemaphoreTake+0x44>
    16c0:	30047073          	csrci	mstatus,8
    16c4:	0000006f          	j	16c4 <xQueueSemaphoreTake+0x40>
    16c8:	1a8030ef          	jal	ra,4870 <xTaskGetSchedulerState>
    16cc:	00050793          	mv	a5,a0
    16d0:	00079663          	bnez	a5,16dc <xQueueSemaphoreTake+0x58>
    16d4:	00812783          	lw	a5,8(sp)
    16d8:	00079663          	bnez	a5,16e4 <xQueueSemaphoreTake+0x60>
    16dc:	00100793          	li	a5,1
    16e0:	0080006f          	j	16e8 <xQueueSemaphoreTake+0x64>
    16e4:	00000793          	li	a5,0
    16e8:	00079663          	bnez	a5,16f4 <xQueueSemaphoreTake+0x70>
    16ec:	30047073          	csrci	mstatus,8
    16f0:	0000006f          	j	16f0 <xQueueSemaphoreTake+0x6c>
    16f4:	614030ef          	jal	ra,4d08 <vTaskEnterCritical>
    16f8:	02412783          	lw	a5,36(sp)
    16fc:	0387a783          	lw	a5,56(a5)
    1700:	02f12023          	sw	a5,32(sp)
    1704:	02012783          	lw	a5,32(sp)
    1708:	06078263          	beqz	a5,176c <xQueueSemaphoreTake+0xe8>
    170c:	02012783          	lw	a5,32(sp)
    1710:	fff78713          	addi	a4,a5,-1
    1714:	02412783          	lw	a5,36(sp)
    1718:	02e7ac23          	sw	a4,56(a5)
    171c:	02412783          	lw	a5,36(sp)
    1720:	0007a783          	lw	a5,0(a5)
    1724:	00079a63          	bnez	a5,1738 <xQueueSemaphoreTake+0xb4>
    1728:	6cc030ef          	jal	ra,4df4 <pvTaskIncrementMutexHeldCount>
    172c:	00050713          	mv	a4,a0
    1730:	02412783          	lw	a5,36(sp)
    1734:	00e7a423          	sw	a4,8(a5)
    1738:	02412783          	lw	a5,36(sp)
    173c:	0107a783          	lw	a5,16(a5)
    1740:	02078063          	beqz	a5,1760 <xQueueSemaphoreTake+0xdc>
    1744:	02412783          	lw	a5,36(sp)
    1748:	01078793          	addi	a5,a5,16
    174c:	00078513          	mv	a0,a5
    1750:	798020ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    1754:	00050793          	mv	a5,a0
    1758:	00078463          	beqz	a5,1760 <xQueueSemaphoreTake+0xdc>
    175c:	e39fe0ef          	jal	ra,594 <vPortYield>
    1760:	5e8030ef          	jal	ra,4d48 <vTaskExitCritical>
    1764:	00100793          	li	a5,1
    1768:	17c0006f          	j	18e4 <xQueueSemaphoreTake+0x260>
    176c:	00812783          	lw	a5,8(sp)
    1770:	02079063          	bnez	a5,1790 <xQueueSemaphoreTake+0x10c>
    1774:	02812783          	lw	a5,40(sp)
    1778:	00078663          	beqz	a5,1784 <xQueueSemaphoreTake+0x100>
    177c:	30047073          	csrci	mstatus,8
    1780:	0000006f          	j	1780 <xQueueSemaphoreTake+0xfc>
    1784:	5c4030ef          	jal	ra,4d48 <vTaskExitCritical>
    1788:	00000793          	li	a5,0
    178c:	1580006f          	j	18e4 <xQueueSemaphoreTake+0x260>
    1790:	02c12783          	lw	a5,44(sp)
    1794:	00079c63          	bnez	a5,17ac <xQueueSemaphoreTake+0x128>
    1798:	01410793          	addi	a5,sp,20
    179c:	00078513          	mv	a0,a5
    17a0:	1e1020ef          	jal	ra,4180 <vTaskInternalSetTimeOutState>
    17a4:	00100793          	li	a5,1
    17a8:	02f12623          	sw	a5,44(sp)
    17ac:	59c030ef          	jal	ra,4d48 <vTaskExitCritical>
    17b0:	4e5010ef          	jal	ra,3494 <vTaskSuspendAll>
    17b4:	554030ef          	jal	ra,4d08 <vTaskEnterCritical>
    17b8:	02412783          	lw	a5,36(sp)
    17bc:	0447c783          	lbu	a5,68(a5)
    17c0:	01879713          	slli	a4,a5,0x18
    17c4:	41875713          	srai	a4,a4,0x18
    17c8:	fff00793          	li	a5,-1
    17cc:	00f71663          	bne	a4,a5,17d8 <xQueueSemaphoreTake+0x154>
    17d0:	02412783          	lw	a5,36(sp)
    17d4:	04078223          	sb	zero,68(a5)
    17d8:	02412783          	lw	a5,36(sp)
    17dc:	0457c783          	lbu	a5,69(a5)
    17e0:	01879713          	slli	a4,a5,0x18
    17e4:	41875713          	srai	a4,a4,0x18
    17e8:	fff00793          	li	a5,-1
    17ec:	00f71663          	bne	a4,a5,17f8 <xQueueSemaphoreTake+0x174>
    17f0:	02412783          	lw	a5,36(sp)
    17f4:	040782a3          	sb	zero,69(a5)
    17f8:	550030ef          	jal	ra,4d48 <vTaskExitCritical>
    17fc:	00810713          	addi	a4,sp,8
    1800:	01410793          	addi	a5,sp,20
    1804:	00070593          	mv	a1,a4
    1808:	00078513          	mv	a0,a5
    180c:	1b1020ef          	jal	ra,41bc <xTaskCheckForTimeOut>
    1810:	00050793          	mv	a5,a0
    1814:	08079063          	bnez	a5,1894 <xQueueSemaphoreTake+0x210>
    1818:	02412503          	lw	a0,36(sp)
    181c:	1b5000ef          	jal	ra,21d0 <prvIsQueueEmpty>
    1820:	00050793          	mv	a5,a0
    1824:	06078063          	beqz	a5,1884 <xQueueSemaphoreTake+0x200>
    1828:	02412783          	lw	a5,36(sp)
    182c:	0007a783          	lw	a5,0(a5)
    1830:	02079063          	bnez	a5,1850 <xQueueSemaphoreTake+0x1cc>
    1834:	4d4030ef          	jal	ra,4d08 <vTaskEnterCritical>
    1838:	02412783          	lw	a5,36(sp)
    183c:	0087a783          	lw	a5,8(a5)
    1840:	00078513          	mv	a0,a5
    1844:	07c030ef          	jal	ra,48c0 <xTaskPriorityInherit>
    1848:	02a12423          	sw	a0,40(sp)
    184c:	4fc030ef          	jal	ra,4d48 <vTaskExitCritical>
    1850:	02412783          	lw	a5,36(sp)
    1854:	02478793          	addi	a5,a5,36
    1858:	00812703          	lw	a4,8(sp)
    185c:	00070593          	mv	a1,a4
    1860:	00078513          	mv	a0,a5
    1864:	530020ef          	jal	ra,3d94 <vTaskPlaceOnEventList>
    1868:	02412503          	lw	a0,36(sp)
    186c:	071000ef          	jal	ra,20dc <prvUnlockQueue>
    1870:	449010ef          	jal	ra,34b8 <xTaskResumeAll>
    1874:	00050793          	mv	a5,a0
    1878:	e6079ee3          	bnez	a5,16f4 <xQueueSemaphoreTake+0x70>
    187c:	d19fe0ef          	jal	ra,594 <vPortYield>
    1880:	e75ff06f          	j	16f4 <xQueueSemaphoreTake+0x70>
    1884:	02412503          	lw	a0,36(sp)
    1888:	055000ef          	jal	ra,20dc <prvUnlockQueue>
    188c:	42d010ef          	jal	ra,34b8 <xTaskResumeAll>
    1890:	e65ff06f          	j	16f4 <xQueueSemaphoreTake+0x70>
    1894:	02412503          	lw	a0,36(sp)
    1898:	045000ef          	jal	ra,20dc <prvUnlockQueue>
    189c:	41d010ef          	jal	ra,34b8 <xTaskResumeAll>
    18a0:	02412503          	lw	a0,36(sp)
    18a4:	12d000ef          	jal	ra,21d0 <prvIsQueueEmpty>
    18a8:	00050793          	mv	a5,a0
    18ac:	e40784e3          	beqz	a5,16f4 <xQueueSemaphoreTake+0x70>
    18b0:	02812783          	lw	a5,40(sp)
    18b4:	02078663          	beqz	a5,18e0 <xQueueSemaphoreTake+0x25c>
    18b8:	450030ef          	jal	ra,4d08 <vTaskEnterCritical>
    18bc:	02412503          	lw	a0,36(sp)
    18c0:	5cc000ef          	jal	ra,1e8c <prvGetDisinheritPriorityAfterTimeout>
    18c4:	00a12e23          	sw	a0,28(sp)
    18c8:	02412783          	lw	a5,36(sp)
    18cc:	0087a783          	lw	a5,8(a5)
    18d0:	01c12583          	lw	a1,28(sp)
    18d4:	00078513          	mv	a0,a5
    18d8:	2a8030ef          	jal	ra,4b80 <vTaskPriorityDisinheritAfterTimeout>
    18dc:	46c030ef          	jal	ra,4d48 <vTaskExitCritical>
    18e0:	00000793          	li	a5,0
    18e4:	00078513          	mv	a0,a5
    18e8:	03c12083          	lw	ra,60(sp)
    18ec:	04010113          	addi	sp,sp,64
    18f0:	00008067          	ret

000018f4 <xQueuePeek>:
    18f4:	fc010113          	addi	sp,sp,-64
    18f8:	02112e23          	sw	ra,60(sp)
    18fc:	00a12623          	sw	a0,12(sp)
    1900:	00b12423          	sw	a1,8(sp)
    1904:	00c12223          	sw	a2,4(sp)
    1908:	02012623          	sw	zero,44(sp)
    190c:	00c12783          	lw	a5,12(sp)
    1910:	02f12423          	sw	a5,40(sp)
    1914:	02812783          	lw	a5,40(sp)
    1918:	00079663          	bnez	a5,1924 <xQueuePeek+0x30>
    191c:	30047073          	csrci	mstatus,8
    1920:	0000006f          	j	1920 <xQueuePeek+0x2c>
    1924:	00812783          	lw	a5,8(sp)
    1928:	00079863          	bnez	a5,1938 <xQueuePeek+0x44>
    192c:	02812783          	lw	a5,40(sp)
    1930:	0407a783          	lw	a5,64(a5)
    1934:	00079663          	bnez	a5,1940 <xQueuePeek+0x4c>
    1938:	00100793          	li	a5,1
    193c:	0080006f          	j	1944 <xQueuePeek+0x50>
    1940:	00000793          	li	a5,0
    1944:	00079663          	bnez	a5,1950 <xQueuePeek+0x5c>
    1948:	30047073          	csrci	mstatus,8
    194c:	0000006f          	j	194c <xQueuePeek+0x58>
    1950:	721020ef          	jal	ra,4870 <xTaskGetSchedulerState>
    1954:	00050793          	mv	a5,a0
    1958:	00079663          	bnez	a5,1964 <xQueuePeek+0x70>
    195c:	00412783          	lw	a5,4(sp)
    1960:	00079663          	bnez	a5,196c <xQueuePeek+0x78>
    1964:	00100793          	li	a5,1
    1968:	0080006f          	j	1970 <xQueuePeek+0x7c>
    196c:	00000793          	li	a5,0
    1970:	00079663          	bnez	a5,197c <xQueuePeek+0x88>
    1974:	30047073          	csrci	mstatus,8
    1978:	0000006f          	j	1978 <xQueuePeek+0x84>
    197c:	38c030ef          	jal	ra,4d08 <vTaskEnterCritical>
    1980:	02812783          	lw	a5,40(sp)
    1984:	0387a783          	lw	a5,56(a5)
    1988:	02f12223          	sw	a5,36(sp)
    198c:	02412783          	lw	a5,36(sp)
    1990:	04078e63          	beqz	a5,19ec <xQueuePeek+0xf8>
    1994:	02812783          	lw	a5,40(sp)
    1998:	00c7a783          	lw	a5,12(a5)
    199c:	02f12023          	sw	a5,32(sp)
    19a0:	00812583          	lw	a1,8(sp)
    19a4:	02812503          	lw	a0,40(sp)
    19a8:	6a8000ef          	jal	ra,2050 <prvCopyDataFromQueue>
    19ac:	02812783          	lw	a5,40(sp)
    19b0:	02012703          	lw	a4,32(sp)
    19b4:	00e7a623          	sw	a4,12(a5)
    19b8:	02812783          	lw	a5,40(sp)
    19bc:	0247a783          	lw	a5,36(a5)
    19c0:	02078063          	beqz	a5,19e0 <xQueuePeek+0xec>
    19c4:	02812783          	lw	a5,40(sp)
    19c8:	02478793          	addi	a5,a5,36
    19cc:	00078513          	mv	a0,a5
    19d0:	518020ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    19d4:	00050793          	mv	a5,a0
    19d8:	00078463          	beqz	a5,19e0 <xQueuePeek+0xec>
    19dc:	bb9fe0ef          	jal	ra,594 <vPortYield>
    19e0:	368030ef          	jal	ra,4d48 <vTaskExitCritical>
    19e4:	00100793          	li	a5,1
    19e8:	1140006f          	j	1afc <xQueuePeek+0x208>
    19ec:	00412783          	lw	a5,4(sp)
    19f0:	00079863          	bnez	a5,1a00 <xQueuePeek+0x10c>
    19f4:	354030ef          	jal	ra,4d48 <vTaskExitCritical>
    19f8:	00000793          	li	a5,0
    19fc:	1000006f          	j	1afc <xQueuePeek+0x208>
    1a00:	02c12783          	lw	a5,44(sp)
    1a04:	00079c63          	bnez	a5,1a1c <xQueuePeek+0x128>
    1a08:	01810793          	addi	a5,sp,24
    1a0c:	00078513          	mv	a0,a5
    1a10:	770020ef          	jal	ra,4180 <vTaskInternalSetTimeOutState>
    1a14:	00100793          	li	a5,1
    1a18:	02f12623          	sw	a5,44(sp)
    1a1c:	32c030ef          	jal	ra,4d48 <vTaskExitCritical>
    1a20:	275010ef          	jal	ra,3494 <vTaskSuspendAll>
    1a24:	2e4030ef          	jal	ra,4d08 <vTaskEnterCritical>
    1a28:	02812783          	lw	a5,40(sp)
    1a2c:	0447c783          	lbu	a5,68(a5)
    1a30:	01879713          	slli	a4,a5,0x18
    1a34:	41875713          	srai	a4,a4,0x18
    1a38:	fff00793          	li	a5,-1
    1a3c:	00f71663          	bne	a4,a5,1a48 <xQueuePeek+0x154>
    1a40:	02812783          	lw	a5,40(sp)
    1a44:	04078223          	sb	zero,68(a5)
    1a48:	02812783          	lw	a5,40(sp)
    1a4c:	0457c783          	lbu	a5,69(a5)
    1a50:	01879713          	slli	a4,a5,0x18
    1a54:	41875713          	srai	a4,a4,0x18
    1a58:	fff00793          	li	a5,-1
    1a5c:	00f71663          	bne	a4,a5,1a68 <xQueuePeek+0x174>
    1a60:	02812783          	lw	a5,40(sp)
    1a64:	040782a3          	sb	zero,69(a5)
    1a68:	2e0030ef          	jal	ra,4d48 <vTaskExitCritical>
    1a6c:	00410713          	addi	a4,sp,4
    1a70:	01810793          	addi	a5,sp,24
    1a74:	00070593          	mv	a1,a4
    1a78:	00078513          	mv	a0,a5
    1a7c:	740020ef          	jal	ra,41bc <xTaskCheckForTimeOut>
    1a80:	00050793          	mv	a5,a0
    1a84:	04079c63          	bnez	a5,1adc <xQueuePeek+0x1e8>
    1a88:	02812503          	lw	a0,40(sp)
    1a8c:	744000ef          	jal	ra,21d0 <prvIsQueueEmpty>
    1a90:	00050793          	mv	a5,a0
    1a94:	02078c63          	beqz	a5,1acc <xQueuePeek+0x1d8>
    1a98:	02812783          	lw	a5,40(sp)
    1a9c:	02478793          	addi	a5,a5,36
    1aa0:	00412703          	lw	a4,4(sp)
    1aa4:	00070593          	mv	a1,a4
    1aa8:	00078513          	mv	a0,a5
    1aac:	2e8020ef          	jal	ra,3d94 <vTaskPlaceOnEventList>
    1ab0:	02812503          	lw	a0,40(sp)
    1ab4:	628000ef          	jal	ra,20dc <prvUnlockQueue>
    1ab8:	201010ef          	jal	ra,34b8 <xTaskResumeAll>
    1abc:	00050793          	mv	a5,a0
    1ac0:	ea079ee3          	bnez	a5,197c <xQueuePeek+0x88>
    1ac4:	ad1fe0ef          	jal	ra,594 <vPortYield>
    1ac8:	eb5ff06f          	j	197c <xQueuePeek+0x88>
    1acc:	02812503          	lw	a0,40(sp)
    1ad0:	60c000ef          	jal	ra,20dc <prvUnlockQueue>
    1ad4:	1e5010ef          	jal	ra,34b8 <xTaskResumeAll>
    1ad8:	ea5ff06f          	j	197c <xQueuePeek+0x88>
    1adc:	02812503          	lw	a0,40(sp)
    1ae0:	5fc000ef          	jal	ra,20dc <prvUnlockQueue>
    1ae4:	1d5010ef          	jal	ra,34b8 <xTaskResumeAll>
    1ae8:	02812503          	lw	a0,40(sp)
    1aec:	6e4000ef          	jal	ra,21d0 <prvIsQueueEmpty>
    1af0:	00050793          	mv	a5,a0
    1af4:	e80784e3          	beqz	a5,197c <xQueuePeek+0x88>
    1af8:	00000793          	li	a5,0
    1afc:	00078513          	mv	a0,a5
    1b00:	03c12083          	lw	ra,60(sp)
    1b04:	04010113          	addi	sp,sp,64
    1b08:	00008067          	ret

00001b0c <xQueueReceiveFromISR>:
    1b0c:	fc010113          	addi	sp,sp,-64
    1b10:	02112e23          	sw	ra,60(sp)
    1b14:	00a12623          	sw	a0,12(sp)
    1b18:	00b12423          	sw	a1,8(sp)
    1b1c:	00c12223          	sw	a2,4(sp)
    1b20:	00c12783          	lw	a5,12(sp)
    1b24:	02f12423          	sw	a5,40(sp)
    1b28:	02812783          	lw	a5,40(sp)
    1b2c:	00079663          	bnez	a5,1b38 <xQueueReceiveFromISR+0x2c>
    1b30:	30047073          	csrci	mstatus,8
    1b34:	0000006f          	j	1b34 <xQueueReceiveFromISR+0x28>
    1b38:	00812783          	lw	a5,8(sp)
    1b3c:	00079863          	bnez	a5,1b4c <xQueueReceiveFromISR+0x40>
    1b40:	02812783          	lw	a5,40(sp)
    1b44:	0407a783          	lw	a5,64(a5)
    1b48:	00079663          	bnez	a5,1b54 <xQueueReceiveFromISR+0x48>
    1b4c:	00100793          	li	a5,1
    1b50:	0080006f          	j	1b58 <xQueueReceiveFromISR+0x4c>
    1b54:	00000793          	li	a5,0
    1b58:	00079663          	bnez	a5,1b64 <xQueueReceiveFromISR+0x58>
    1b5c:	30047073          	csrci	mstatus,8
    1b60:	0000006f          	j	1b60 <xQueueReceiveFromISR+0x54>
    1b64:	c45fe0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    1b68:	00050793          	mv	a5,a0
    1b6c:	02f12223          	sw	a5,36(sp)
    1b70:	02812783          	lw	a5,40(sp)
    1b74:	0387a783          	lw	a5,56(a5)
    1b78:	02f12023          	sw	a5,32(sp)
    1b7c:	02012783          	lw	a5,32(sp)
    1b80:	08078e63          	beqz	a5,1c1c <xQueueReceiveFromISR+0x110>
    1b84:	02812783          	lw	a5,40(sp)
    1b88:	0447c783          	lbu	a5,68(a5)
    1b8c:	00f10fa3          	sb	a5,31(sp)
    1b90:	00812583          	lw	a1,8(sp)
    1b94:	02812503          	lw	a0,40(sp)
    1b98:	4b8000ef          	jal	ra,2050 <prvCopyDataFromQueue>
    1b9c:	02012783          	lw	a5,32(sp)
    1ba0:	fff78713          	addi	a4,a5,-1
    1ba4:	02812783          	lw	a5,40(sp)
    1ba8:	02e7ac23          	sw	a4,56(a5)
    1bac:	01f10703          	lb	a4,31(sp)
    1bb0:	fff00793          	li	a5,-1
    1bb4:	04f71063          	bne	a4,a5,1bf4 <xQueueReceiveFromISR+0xe8>
    1bb8:	02812783          	lw	a5,40(sp)
    1bbc:	0107a783          	lw	a5,16(a5)
    1bc0:	04078863          	beqz	a5,1c10 <xQueueReceiveFromISR+0x104>
    1bc4:	02812783          	lw	a5,40(sp)
    1bc8:	01078793          	addi	a5,a5,16
    1bcc:	00078513          	mv	a0,a5
    1bd0:	318020ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    1bd4:	00050793          	mv	a5,a0
    1bd8:	02078c63          	beqz	a5,1c10 <xQueueReceiveFromISR+0x104>
    1bdc:	00412783          	lw	a5,4(sp)
    1be0:	02078863          	beqz	a5,1c10 <xQueueReceiveFromISR+0x104>
    1be4:	00412783          	lw	a5,4(sp)
    1be8:	00100713          	li	a4,1
    1bec:	00e7a023          	sw	a4,0(a5)
    1bf0:	0200006f          	j	1c10 <xQueueReceiveFromISR+0x104>
    1bf4:	01f14783          	lbu	a5,31(sp)
    1bf8:	00178793          	addi	a5,a5,1
    1bfc:	0ff7f793          	andi	a5,a5,255
    1c00:	01879713          	slli	a4,a5,0x18
    1c04:	41875713          	srai	a4,a4,0x18
    1c08:	02812783          	lw	a5,40(sp)
    1c0c:	04e78223          	sb	a4,68(a5)
    1c10:	00100793          	li	a5,1
    1c14:	02f12623          	sw	a5,44(sp)
    1c18:	0080006f          	j	1c20 <xQueueReceiveFromISR+0x114>
    1c1c:	02012623          	sw	zero,44(sp)
    1c20:	02412783          	lw	a5,36(sp)
    1c24:	00078513          	mv	a0,a5
    1c28:	b65fe0ef          	jal	ra,78c <vPortClearInterruptMask>
    1c2c:	02c12783          	lw	a5,44(sp)
    1c30:	00078513          	mv	a0,a5
    1c34:	03c12083          	lw	ra,60(sp)
    1c38:	04010113          	addi	sp,sp,64
    1c3c:	00008067          	ret

00001c40 <xQueuePeekFromISR>:
    1c40:	fd010113          	addi	sp,sp,-48
    1c44:	02112623          	sw	ra,44(sp)
    1c48:	00a12623          	sw	a0,12(sp)
    1c4c:	00b12423          	sw	a1,8(sp)
    1c50:	00c12783          	lw	a5,12(sp)
    1c54:	00f12c23          	sw	a5,24(sp)
    1c58:	01812783          	lw	a5,24(sp)
    1c5c:	00079663          	bnez	a5,1c68 <xQueuePeekFromISR+0x28>
    1c60:	30047073          	csrci	mstatus,8
    1c64:	0000006f          	j	1c64 <xQueuePeekFromISR+0x24>
    1c68:	00812783          	lw	a5,8(sp)
    1c6c:	00079863          	bnez	a5,1c7c <xQueuePeekFromISR+0x3c>
    1c70:	01812783          	lw	a5,24(sp)
    1c74:	0407a783          	lw	a5,64(a5)
    1c78:	00079663          	bnez	a5,1c84 <xQueuePeekFromISR+0x44>
    1c7c:	00100793          	li	a5,1
    1c80:	0080006f          	j	1c88 <xQueuePeekFromISR+0x48>
    1c84:	00000793          	li	a5,0
    1c88:	00079663          	bnez	a5,1c94 <xQueuePeekFromISR+0x54>
    1c8c:	30047073          	csrci	mstatus,8
    1c90:	0000006f          	j	1c90 <xQueuePeekFromISR+0x50>
    1c94:	01812783          	lw	a5,24(sp)
    1c98:	0407a783          	lw	a5,64(a5)
    1c9c:	00079663          	bnez	a5,1ca8 <xQueuePeekFromISR+0x68>
    1ca0:	30047073          	csrci	mstatus,8
    1ca4:	0000006f          	j	1ca4 <xQueuePeekFromISR+0x64>
    1ca8:	b01fe0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    1cac:	00050793          	mv	a5,a0
    1cb0:	00f12a23          	sw	a5,20(sp)
    1cb4:	01812783          	lw	a5,24(sp)
    1cb8:	0387a783          	lw	a5,56(a5)
    1cbc:	02078a63          	beqz	a5,1cf0 <xQueuePeekFromISR+0xb0>
    1cc0:	01812783          	lw	a5,24(sp)
    1cc4:	00c7a783          	lw	a5,12(a5)
    1cc8:	00f12823          	sw	a5,16(sp)
    1ccc:	00812583          	lw	a1,8(sp)
    1cd0:	01812503          	lw	a0,24(sp)
    1cd4:	37c000ef          	jal	ra,2050 <prvCopyDataFromQueue>
    1cd8:	01812783          	lw	a5,24(sp)
    1cdc:	01012703          	lw	a4,16(sp)
    1ce0:	00e7a623          	sw	a4,12(a5)
    1ce4:	00100793          	li	a5,1
    1ce8:	00f12e23          	sw	a5,28(sp)
    1cec:	0080006f          	j	1cf4 <xQueuePeekFromISR+0xb4>
    1cf0:	00012e23          	sw	zero,28(sp)
    1cf4:	01412783          	lw	a5,20(sp)
    1cf8:	00078513          	mv	a0,a5
    1cfc:	a91fe0ef          	jal	ra,78c <vPortClearInterruptMask>
    1d00:	01c12783          	lw	a5,28(sp)
    1d04:	00078513          	mv	a0,a5
    1d08:	02c12083          	lw	ra,44(sp)
    1d0c:	03010113          	addi	sp,sp,48
    1d10:	00008067          	ret

00001d14 <uxQueueMessagesWaiting>:
    1d14:	fd010113          	addi	sp,sp,-48
    1d18:	02112623          	sw	ra,44(sp)
    1d1c:	00a12623          	sw	a0,12(sp)
    1d20:	00c12783          	lw	a5,12(sp)
    1d24:	00079663          	bnez	a5,1d30 <uxQueueMessagesWaiting+0x1c>
    1d28:	30047073          	csrci	mstatus,8
    1d2c:	0000006f          	j	1d2c <uxQueueMessagesWaiting+0x18>
    1d30:	7d9020ef          	jal	ra,4d08 <vTaskEnterCritical>
    1d34:	00c12783          	lw	a5,12(sp)
    1d38:	0387a783          	lw	a5,56(a5)
    1d3c:	00f12e23          	sw	a5,28(sp)
    1d40:	008030ef          	jal	ra,4d48 <vTaskExitCritical>
    1d44:	01c12783          	lw	a5,28(sp)
    1d48:	00078513          	mv	a0,a5
    1d4c:	02c12083          	lw	ra,44(sp)
    1d50:	03010113          	addi	sp,sp,48
    1d54:	00008067          	ret

00001d58 <uxQueueSpacesAvailable>:
    1d58:	fd010113          	addi	sp,sp,-48
    1d5c:	02112623          	sw	ra,44(sp)
    1d60:	00a12623          	sw	a0,12(sp)
    1d64:	00c12783          	lw	a5,12(sp)
    1d68:	00f12e23          	sw	a5,28(sp)
    1d6c:	01c12783          	lw	a5,28(sp)
    1d70:	00079663          	bnez	a5,1d7c <uxQueueSpacesAvailable+0x24>
    1d74:	30047073          	csrci	mstatus,8
    1d78:	0000006f          	j	1d78 <uxQueueSpacesAvailable+0x20>
    1d7c:	78d020ef          	jal	ra,4d08 <vTaskEnterCritical>
    1d80:	01c12783          	lw	a5,28(sp)
    1d84:	03c7a703          	lw	a4,60(a5)
    1d88:	01c12783          	lw	a5,28(sp)
    1d8c:	0387a783          	lw	a5,56(a5)
    1d90:	40f707b3          	sub	a5,a4,a5
    1d94:	00f12c23          	sw	a5,24(sp)
    1d98:	7b1020ef          	jal	ra,4d48 <vTaskExitCritical>
    1d9c:	01812783          	lw	a5,24(sp)
    1da0:	00078513          	mv	a0,a5
    1da4:	02c12083          	lw	ra,44(sp)
    1da8:	03010113          	addi	sp,sp,48
    1dac:	00008067          	ret

00001db0 <uxQueueMessagesWaitingFromISR>:
    1db0:	fe010113          	addi	sp,sp,-32
    1db4:	00a12623          	sw	a0,12(sp)
    1db8:	00c12783          	lw	a5,12(sp)
    1dbc:	00f12e23          	sw	a5,28(sp)
    1dc0:	01c12783          	lw	a5,28(sp)
    1dc4:	00079663          	bnez	a5,1dd0 <uxQueueMessagesWaitingFromISR+0x20>
    1dc8:	30047073          	csrci	mstatus,8
    1dcc:	0000006f          	j	1dcc <uxQueueMessagesWaitingFromISR+0x1c>
    1dd0:	01c12783          	lw	a5,28(sp)
    1dd4:	0387a783          	lw	a5,56(a5)
    1dd8:	00f12c23          	sw	a5,24(sp)
    1ddc:	01812783          	lw	a5,24(sp)
    1de0:	00078513          	mv	a0,a5
    1de4:	02010113          	addi	sp,sp,32
    1de8:	00008067          	ret

00001dec <vQueueDelete>:
    1dec:	fd010113          	addi	sp,sp,-48
    1df0:	02112623          	sw	ra,44(sp)
    1df4:	00a12623          	sw	a0,12(sp)
    1df8:	00c12783          	lw	a5,12(sp)
    1dfc:	00f12e23          	sw	a5,28(sp)
    1e00:	01c12783          	lw	a5,28(sp)
    1e04:	00079663          	bnez	a5,1e10 <vQueueDelete+0x24>
    1e08:	30047073          	csrci	mstatus,8
    1e0c:	0000006f          	j	1e0c <vQueueDelete+0x20>
    1e10:	01c12503          	lw	a0,28(sp)
    1e14:	5f8000ef          	jal	ra,240c <vQueueUnregisterQueue>
    1e18:	01c12503          	lw	a0,28(sp)
    1e1c:	745040ef          	jal	ra,6d60 <vPortFree>
    1e20:	00000013          	nop
    1e24:	02c12083          	lw	ra,44(sp)
    1e28:	03010113          	addi	sp,sp,48
    1e2c:	00008067          	ret

00001e30 <uxQueueGetQueueNumber>:
    1e30:	ff010113          	addi	sp,sp,-16
    1e34:	00a12623          	sw	a0,12(sp)
    1e38:	00c12783          	lw	a5,12(sp)
    1e3c:	0487a783          	lw	a5,72(a5)
    1e40:	00078513          	mv	a0,a5
    1e44:	01010113          	addi	sp,sp,16
    1e48:	00008067          	ret

00001e4c <vQueueSetQueueNumber>:
    1e4c:	ff010113          	addi	sp,sp,-16
    1e50:	00a12623          	sw	a0,12(sp)
    1e54:	00b12423          	sw	a1,8(sp)
    1e58:	00c12783          	lw	a5,12(sp)
    1e5c:	00812703          	lw	a4,8(sp)
    1e60:	04e7a423          	sw	a4,72(a5)
    1e64:	00000013          	nop
    1e68:	01010113          	addi	sp,sp,16
    1e6c:	00008067          	ret

00001e70 <ucQueueGetQueueType>:
    1e70:	ff010113          	addi	sp,sp,-16
    1e74:	00a12623          	sw	a0,12(sp)
    1e78:	00c12783          	lw	a5,12(sp)
    1e7c:	04c7c783          	lbu	a5,76(a5)
    1e80:	00078513          	mv	a0,a5
    1e84:	01010113          	addi	sp,sp,16
    1e88:	00008067          	ret

00001e8c <prvGetDisinheritPriorityAfterTimeout>:
    1e8c:	fe010113          	addi	sp,sp,-32
    1e90:	00a12623          	sw	a0,12(sp)
    1e94:	00c12783          	lw	a5,12(sp)
    1e98:	0247a783          	lw	a5,36(a5)
    1e9c:	02078063          	beqz	a5,1ebc <prvGetDisinheritPriorityAfterTimeout+0x30>
    1ea0:	00c12783          	lw	a5,12(sp)
    1ea4:	0307a783          	lw	a5,48(a5)
    1ea8:	0007a783          	lw	a5,0(a5)
    1eac:	00500713          	li	a4,5
    1eb0:	40f707b3          	sub	a5,a4,a5
    1eb4:	00f12e23          	sw	a5,28(sp)
    1eb8:	0080006f          	j	1ec0 <prvGetDisinheritPriorityAfterTimeout+0x34>
    1ebc:	00012e23          	sw	zero,28(sp)
    1ec0:	01c12783          	lw	a5,28(sp)
    1ec4:	00078513          	mv	a0,a5
    1ec8:	02010113          	addi	sp,sp,32
    1ecc:	00008067          	ret

00001ed0 <prvCopyDataToQueue>:
    1ed0:	fd010113          	addi	sp,sp,-48
    1ed4:	02112623          	sw	ra,44(sp)
    1ed8:	00a12623          	sw	a0,12(sp)
    1edc:	00b12423          	sw	a1,8(sp)
    1ee0:	00c12223          	sw	a2,4(sp)
    1ee4:	00012e23          	sw	zero,28(sp)
    1ee8:	00c12783          	lw	a5,12(sp)
    1eec:	0387a783          	lw	a5,56(a5)
    1ef0:	00f12c23          	sw	a5,24(sp)
    1ef4:	00c12783          	lw	a5,12(sp)
    1ef8:	0407a783          	lw	a5,64(a5)
    1efc:	02079863          	bnez	a5,1f2c <prvCopyDataToQueue+0x5c>
    1f00:	00c12783          	lw	a5,12(sp)
    1f04:	0007a783          	lw	a5,0(a5)
    1f08:	12079263          	bnez	a5,202c <prvCopyDataToQueue+0x15c>
    1f0c:	00c12783          	lw	a5,12(sp)
    1f10:	0087a783          	lw	a5,8(a5)
    1f14:	00078513          	mv	a0,a5
    1f18:	32d020ef          	jal	ra,4a44 <xTaskPriorityDisinherit>
    1f1c:	00a12e23          	sw	a0,28(sp)
    1f20:	00c12783          	lw	a5,12(sp)
    1f24:	0007a423          	sw	zero,8(a5)
    1f28:	1040006f          	j	202c <prvCopyDataToQueue+0x15c>
    1f2c:	00412783          	lw	a5,4(sp)
    1f30:	06079463          	bnez	a5,1f98 <prvCopyDataToQueue+0xc8>
    1f34:	00c12783          	lw	a5,12(sp)
    1f38:	0047a703          	lw	a4,4(a5)
    1f3c:	00c12783          	lw	a5,12(sp)
    1f40:	0407a783          	lw	a5,64(a5)
    1f44:	00078613          	mv	a2,a5
    1f48:	00812583          	lw	a1,8(sp)
    1f4c:	00070513          	mv	a0,a4
    1f50:	77d040ef          	jal	ra,6ecc <memcpy>
    1f54:	00c12783          	lw	a5,12(sp)
    1f58:	0047a703          	lw	a4,4(a5)
    1f5c:	00c12783          	lw	a5,12(sp)
    1f60:	0407a783          	lw	a5,64(a5)
    1f64:	00f70733          	add	a4,a4,a5
    1f68:	00c12783          	lw	a5,12(sp)
    1f6c:	00e7a223          	sw	a4,4(a5)
    1f70:	00c12783          	lw	a5,12(sp)
    1f74:	0047a703          	lw	a4,4(a5)
    1f78:	00c12783          	lw	a5,12(sp)
    1f7c:	0087a783          	lw	a5,8(a5)
    1f80:	0af76663          	bltu	a4,a5,202c <prvCopyDataToQueue+0x15c>
    1f84:	00c12783          	lw	a5,12(sp)
    1f88:	0007a703          	lw	a4,0(a5)
    1f8c:	00c12783          	lw	a5,12(sp)
    1f90:	00e7a223          	sw	a4,4(a5)
    1f94:	0980006f          	j	202c <prvCopyDataToQueue+0x15c>
    1f98:	00c12783          	lw	a5,12(sp)
    1f9c:	00c7a703          	lw	a4,12(a5)
    1fa0:	00c12783          	lw	a5,12(sp)
    1fa4:	0407a783          	lw	a5,64(a5)
    1fa8:	00078613          	mv	a2,a5
    1fac:	00812583          	lw	a1,8(sp)
    1fb0:	00070513          	mv	a0,a4
    1fb4:	719040ef          	jal	ra,6ecc <memcpy>
    1fb8:	00c12783          	lw	a5,12(sp)
    1fbc:	00c7a703          	lw	a4,12(a5)
    1fc0:	00c12783          	lw	a5,12(sp)
    1fc4:	0407a783          	lw	a5,64(a5)
    1fc8:	40f007b3          	neg	a5,a5
    1fcc:	00f70733          	add	a4,a4,a5
    1fd0:	00c12783          	lw	a5,12(sp)
    1fd4:	00e7a623          	sw	a4,12(a5)
    1fd8:	00c12783          	lw	a5,12(sp)
    1fdc:	00c7a703          	lw	a4,12(a5)
    1fe0:	00c12783          	lw	a5,12(sp)
    1fe4:	0007a783          	lw	a5,0(a5)
    1fe8:	02f77263          	bleu	a5,a4,200c <prvCopyDataToQueue+0x13c>
    1fec:	00c12783          	lw	a5,12(sp)
    1ff0:	0087a703          	lw	a4,8(a5)
    1ff4:	00c12783          	lw	a5,12(sp)
    1ff8:	0407a783          	lw	a5,64(a5)
    1ffc:	40f007b3          	neg	a5,a5
    2000:	00f70733          	add	a4,a4,a5
    2004:	00c12783          	lw	a5,12(sp)
    2008:	00e7a623          	sw	a4,12(a5)
    200c:	00412703          	lw	a4,4(sp)
    2010:	00200793          	li	a5,2
    2014:	00f71c63          	bne	a4,a5,202c <prvCopyDataToQueue+0x15c>
    2018:	01812783          	lw	a5,24(sp)
    201c:	00078863          	beqz	a5,202c <prvCopyDataToQueue+0x15c>
    2020:	01812783          	lw	a5,24(sp)
    2024:	fff78793          	addi	a5,a5,-1
    2028:	00f12c23          	sw	a5,24(sp)
    202c:	01812783          	lw	a5,24(sp)
    2030:	00178713          	addi	a4,a5,1
    2034:	00c12783          	lw	a5,12(sp)
    2038:	02e7ac23          	sw	a4,56(a5)
    203c:	01c12783          	lw	a5,28(sp)
    2040:	00078513          	mv	a0,a5
    2044:	02c12083          	lw	ra,44(sp)
    2048:	03010113          	addi	sp,sp,48
    204c:	00008067          	ret

00002050 <prvCopyDataFromQueue>:
    2050:	fe010113          	addi	sp,sp,-32
    2054:	00112e23          	sw	ra,28(sp)
    2058:	00a12623          	sw	a0,12(sp)
    205c:	00b12423          	sw	a1,8(sp)
    2060:	00c12783          	lw	a5,12(sp)
    2064:	0407a783          	lw	a5,64(a5)
    2068:	06078263          	beqz	a5,20cc <prvCopyDataFromQueue+0x7c>
    206c:	00c12783          	lw	a5,12(sp)
    2070:	00c7a703          	lw	a4,12(a5)
    2074:	00c12783          	lw	a5,12(sp)
    2078:	0407a783          	lw	a5,64(a5)
    207c:	00f70733          	add	a4,a4,a5
    2080:	00c12783          	lw	a5,12(sp)
    2084:	00e7a623          	sw	a4,12(a5)
    2088:	00c12783          	lw	a5,12(sp)
    208c:	00c7a703          	lw	a4,12(a5)
    2090:	00c12783          	lw	a5,12(sp)
    2094:	0087a783          	lw	a5,8(a5)
    2098:	00f76a63          	bltu	a4,a5,20ac <prvCopyDataFromQueue+0x5c>
    209c:	00c12783          	lw	a5,12(sp)
    20a0:	0007a703          	lw	a4,0(a5)
    20a4:	00c12783          	lw	a5,12(sp)
    20a8:	00e7a623          	sw	a4,12(a5)
    20ac:	00c12783          	lw	a5,12(sp)
    20b0:	00c7a703          	lw	a4,12(a5)
    20b4:	00c12783          	lw	a5,12(sp)
    20b8:	0407a783          	lw	a5,64(a5)
    20bc:	00078613          	mv	a2,a5
    20c0:	00070593          	mv	a1,a4
    20c4:	00812503          	lw	a0,8(sp)
    20c8:	605040ef          	jal	ra,6ecc <memcpy>
    20cc:	00000013          	nop
    20d0:	01c12083          	lw	ra,28(sp)
    20d4:	02010113          	addi	sp,sp,32
    20d8:	00008067          	ret

000020dc <prvUnlockQueue>:
    20dc:	fd010113          	addi	sp,sp,-48
    20e0:	02112623          	sw	ra,44(sp)
    20e4:	00a12623          	sw	a0,12(sp)
    20e8:	421020ef          	jal	ra,4d08 <vTaskEnterCritical>
    20ec:	00c12783          	lw	a5,12(sp)
    20f0:	0457c783          	lbu	a5,69(a5)
    20f4:	00f10fa3          	sb	a5,31(sp)
    20f8:	03c0006f          	j	2134 <prvUnlockQueue+0x58>
    20fc:	00c12783          	lw	a5,12(sp)
    2100:	0247a783          	lw	a5,36(a5)
    2104:	02078e63          	beqz	a5,2140 <prvUnlockQueue+0x64>
    2108:	00c12783          	lw	a5,12(sp)
    210c:	02478793          	addi	a5,a5,36
    2110:	00078513          	mv	a0,a5
    2114:	5d5010ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    2118:	00050793          	mv	a5,a0
    211c:	00078463          	beqz	a5,2124 <prvUnlockQueue+0x48>
    2120:	1a0020ef          	jal	ra,42c0 <vTaskMissedYield>
    2124:	01f14783          	lbu	a5,31(sp)
    2128:	fff78793          	addi	a5,a5,-1
    212c:	0ff7f793          	andi	a5,a5,255
    2130:	00f10fa3          	sb	a5,31(sp)
    2134:	01f10783          	lb	a5,31(sp)
    2138:	fcf042e3          	bgtz	a5,20fc <prvUnlockQueue+0x20>
    213c:	0080006f          	j	2144 <prvUnlockQueue+0x68>
    2140:	00000013          	nop
    2144:	00c12783          	lw	a5,12(sp)
    2148:	fff00713          	li	a4,-1
    214c:	04e782a3          	sb	a4,69(a5)
    2150:	3f9020ef          	jal	ra,4d48 <vTaskExitCritical>
    2154:	3b5020ef          	jal	ra,4d08 <vTaskEnterCritical>
    2158:	00c12783          	lw	a5,12(sp)
    215c:	0447c783          	lbu	a5,68(a5)
    2160:	00f10f23          	sb	a5,30(sp)
    2164:	03c0006f          	j	21a0 <prvUnlockQueue+0xc4>
    2168:	00c12783          	lw	a5,12(sp)
    216c:	0107a783          	lw	a5,16(a5)
    2170:	02078e63          	beqz	a5,21ac <prvUnlockQueue+0xd0>
    2174:	00c12783          	lw	a5,12(sp)
    2178:	01078793          	addi	a5,a5,16
    217c:	00078513          	mv	a0,a5
    2180:	569010ef          	jal	ra,3ee8 <xTaskRemoveFromEventList>
    2184:	00050793          	mv	a5,a0
    2188:	00078463          	beqz	a5,2190 <prvUnlockQueue+0xb4>
    218c:	134020ef          	jal	ra,42c0 <vTaskMissedYield>
    2190:	01e14783          	lbu	a5,30(sp)
    2194:	fff78793          	addi	a5,a5,-1
    2198:	0ff7f793          	andi	a5,a5,255
    219c:	00f10f23          	sb	a5,30(sp)
    21a0:	01e10783          	lb	a5,30(sp)
    21a4:	fcf042e3          	bgtz	a5,2168 <prvUnlockQueue+0x8c>
    21a8:	0080006f          	j	21b0 <prvUnlockQueue+0xd4>
    21ac:	00000013          	nop
    21b0:	00c12783          	lw	a5,12(sp)
    21b4:	fff00713          	li	a4,-1
    21b8:	04e78223          	sb	a4,68(a5)
    21bc:	38d020ef          	jal	ra,4d48 <vTaskExitCritical>
    21c0:	00000013          	nop
    21c4:	02c12083          	lw	ra,44(sp)
    21c8:	03010113          	addi	sp,sp,48
    21cc:	00008067          	ret

000021d0 <prvIsQueueEmpty>:
    21d0:	fd010113          	addi	sp,sp,-48
    21d4:	02112623          	sw	ra,44(sp)
    21d8:	00a12623          	sw	a0,12(sp)
    21dc:	32d020ef          	jal	ra,4d08 <vTaskEnterCritical>
    21e0:	00c12783          	lw	a5,12(sp)
    21e4:	0387a783          	lw	a5,56(a5)
    21e8:	00079863          	bnez	a5,21f8 <prvIsQueueEmpty+0x28>
    21ec:	00100793          	li	a5,1
    21f0:	00f12e23          	sw	a5,28(sp)
    21f4:	0080006f          	j	21fc <prvIsQueueEmpty+0x2c>
    21f8:	00012e23          	sw	zero,28(sp)
    21fc:	34d020ef          	jal	ra,4d48 <vTaskExitCritical>
    2200:	01c12783          	lw	a5,28(sp)
    2204:	00078513          	mv	a0,a5
    2208:	02c12083          	lw	ra,44(sp)
    220c:	03010113          	addi	sp,sp,48
    2210:	00008067          	ret

00002214 <xQueueIsQueueEmptyFromISR>:
    2214:	fe010113          	addi	sp,sp,-32
    2218:	00a12623          	sw	a0,12(sp)
    221c:	00c12783          	lw	a5,12(sp)
    2220:	00f12c23          	sw	a5,24(sp)
    2224:	01812783          	lw	a5,24(sp)
    2228:	00079663          	bnez	a5,2234 <xQueueIsQueueEmptyFromISR+0x20>
    222c:	30047073          	csrci	mstatus,8
    2230:	0000006f          	j	2230 <xQueueIsQueueEmptyFromISR+0x1c>
    2234:	01812783          	lw	a5,24(sp)
    2238:	0387a783          	lw	a5,56(a5)
    223c:	00079863          	bnez	a5,224c <xQueueIsQueueEmptyFromISR+0x38>
    2240:	00100793          	li	a5,1
    2244:	00f12e23          	sw	a5,28(sp)
    2248:	0080006f          	j	2250 <xQueueIsQueueEmptyFromISR+0x3c>
    224c:	00012e23          	sw	zero,28(sp)
    2250:	01c12783          	lw	a5,28(sp)
    2254:	00078513          	mv	a0,a5
    2258:	02010113          	addi	sp,sp,32
    225c:	00008067          	ret

00002260 <prvIsQueueFull>:
    2260:	fd010113          	addi	sp,sp,-48
    2264:	02112623          	sw	ra,44(sp)
    2268:	00a12623          	sw	a0,12(sp)
    226c:	29d020ef          	jal	ra,4d08 <vTaskEnterCritical>
    2270:	00c12783          	lw	a5,12(sp)
    2274:	0387a703          	lw	a4,56(a5)
    2278:	00c12783          	lw	a5,12(sp)
    227c:	03c7a783          	lw	a5,60(a5)
    2280:	00f71863          	bne	a4,a5,2290 <prvIsQueueFull+0x30>
    2284:	00100793          	li	a5,1
    2288:	00f12e23          	sw	a5,28(sp)
    228c:	0080006f          	j	2294 <prvIsQueueFull+0x34>
    2290:	00012e23          	sw	zero,28(sp)
    2294:	2b5020ef          	jal	ra,4d48 <vTaskExitCritical>
    2298:	01c12783          	lw	a5,28(sp)
    229c:	00078513          	mv	a0,a5
    22a0:	02c12083          	lw	ra,44(sp)
    22a4:	03010113          	addi	sp,sp,48
    22a8:	00008067          	ret

000022ac <xQueueIsQueueFullFromISR>:
    22ac:	fe010113          	addi	sp,sp,-32
    22b0:	00a12623          	sw	a0,12(sp)
    22b4:	00c12783          	lw	a5,12(sp)
    22b8:	00f12c23          	sw	a5,24(sp)
    22bc:	01812783          	lw	a5,24(sp)
    22c0:	00079663          	bnez	a5,22cc <xQueueIsQueueFullFromISR+0x20>
    22c4:	30047073          	csrci	mstatus,8
    22c8:	0000006f          	j	22c8 <xQueueIsQueueFullFromISR+0x1c>
    22cc:	01812783          	lw	a5,24(sp)
    22d0:	0387a703          	lw	a4,56(a5)
    22d4:	01812783          	lw	a5,24(sp)
    22d8:	03c7a783          	lw	a5,60(a5)
    22dc:	00f71863          	bne	a4,a5,22ec <xQueueIsQueueFullFromISR+0x40>
    22e0:	00100793          	li	a5,1
    22e4:	00f12e23          	sw	a5,28(sp)
    22e8:	0080006f          	j	22f0 <xQueueIsQueueFullFromISR+0x44>
    22ec:	00012e23          	sw	zero,28(sp)
    22f0:	01c12783          	lw	a5,28(sp)
    22f4:	00078513          	mv	a0,a5
    22f8:	02010113          	addi	sp,sp,32
    22fc:	00008067          	ret

00002300 <vQueueAddToRegistry>:
    2300:	fe010113          	addi	sp,sp,-32
    2304:	00a12623          	sw	a0,12(sp)
    2308:	00b12423          	sw	a1,8(sp)
    230c:	00012e23          	sw	zero,28(sp)
    2310:	0680006f          	j	2378 <vQueueAddToRegistry+0x78>
    2314:	00037717          	auipc	a4,0x37
    2318:	56470713          	addi	a4,a4,1380 # 39878 <xQueueRegistry>
    231c:	01c12783          	lw	a5,28(sp)
    2320:	00379793          	slli	a5,a5,0x3
    2324:	00f707b3          	add	a5,a4,a5
    2328:	0007a783          	lw	a5,0(a5)
    232c:	04079063          	bnez	a5,236c <vQueueAddToRegistry+0x6c>
    2330:	00037717          	auipc	a4,0x37
    2334:	54870713          	addi	a4,a4,1352 # 39878 <xQueueRegistry>
    2338:	01c12783          	lw	a5,28(sp)
    233c:	00379793          	slli	a5,a5,0x3
    2340:	00f707b3          	add	a5,a4,a5
    2344:	00812703          	lw	a4,8(sp)
    2348:	00e7a023          	sw	a4,0(a5)
    234c:	00037717          	auipc	a4,0x37
    2350:	52c70713          	addi	a4,a4,1324 # 39878 <xQueueRegistry>
    2354:	01c12783          	lw	a5,28(sp)
    2358:	00379793          	slli	a5,a5,0x3
    235c:	00f707b3          	add	a5,a4,a5
    2360:	00c12703          	lw	a4,12(sp)
    2364:	00e7a223          	sw	a4,4(a5)
    2368:	01c0006f          	j	2384 <vQueueAddToRegistry+0x84>
    236c:	01c12783          	lw	a5,28(sp)
    2370:	00178793          	addi	a5,a5,1
    2374:	00f12e23          	sw	a5,28(sp)
    2378:	01c12703          	lw	a4,28(sp)
    237c:	00700793          	li	a5,7
    2380:	f8e7fae3          	bleu	a4,a5,2314 <vQueueAddToRegistry+0x14>
    2384:	00000013          	nop
    2388:	02010113          	addi	sp,sp,32
    238c:	00008067          	ret

00002390 <pcQueueGetName>:
    2390:	fe010113          	addi	sp,sp,-32
    2394:	00a12623          	sw	a0,12(sp)
    2398:	00012c23          	sw	zero,24(sp)
    239c:	00012e23          	sw	zero,28(sp)
    23a0:	0500006f          	j	23f0 <pcQueueGetName+0x60>
    23a4:	00037717          	auipc	a4,0x37
    23a8:	4d470713          	addi	a4,a4,1236 # 39878 <xQueueRegistry>
    23ac:	01c12783          	lw	a5,28(sp)
    23b0:	00379793          	slli	a5,a5,0x3
    23b4:	00f707b3          	add	a5,a4,a5
    23b8:	0047a783          	lw	a5,4(a5)
    23bc:	00c12703          	lw	a4,12(sp)
    23c0:	02f71263          	bne	a4,a5,23e4 <pcQueueGetName+0x54>
    23c4:	00037717          	auipc	a4,0x37
    23c8:	4b470713          	addi	a4,a4,1204 # 39878 <xQueueRegistry>
    23cc:	01c12783          	lw	a5,28(sp)
    23d0:	00379793          	slli	a5,a5,0x3
    23d4:	00f707b3          	add	a5,a4,a5
    23d8:	0007a783          	lw	a5,0(a5)
    23dc:	00f12c23          	sw	a5,24(sp)
    23e0:	01c0006f          	j	23fc <pcQueueGetName+0x6c>
    23e4:	01c12783          	lw	a5,28(sp)
    23e8:	00178793          	addi	a5,a5,1
    23ec:	00f12e23          	sw	a5,28(sp)
    23f0:	01c12703          	lw	a4,28(sp)
    23f4:	00700793          	li	a5,7
    23f8:	fae7f6e3          	bleu	a4,a5,23a4 <pcQueueGetName+0x14>
    23fc:	01812783          	lw	a5,24(sp)
    2400:	00078513          	mv	a0,a5
    2404:	02010113          	addi	sp,sp,32
    2408:	00008067          	ret

0000240c <vQueueUnregisterQueue>:
    240c:	fe010113          	addi	sp,sp,-32
    2410:	00a12623          	sw	a0,12(sp)
    2414:	00012e23          	sw	zero,28(sp)
    2418:	0640006f          	j	247c <vQueueUnregisterQueue+0x70>
    241c:	00037717          	auipc	a4,0x37
    2420:	45c70713          	addi	a4,a4,1116 # 39878 <xQueueRegistry>
    2424:	01c12783          	lw	a5,28(sp)
    2428:	00379793          	slli	a5,a5,0x3
    242c:	00f707b3          	add	a5,a4,a5
    2430:	0047a783          	lw	a5,4(a5)
    2434:	00c12703          	lw	a4,12(sp)
    2438:	02f71c63          	bne	a4,a5,2470 <vQueueUnregisterQueue+0x64>
    243c:	00037717          	auipc	a4,0x37
    2440:	43c70713          	addi	a4,a4,1084 # 39878 <xQueueRegistry>
    2444:	01c12783          	lw	a5,28(sp)
    2448:	00379793          	slli	a5,a5,0x3
    244c:	00f707b3          	add	a5,a4,a5
    2450:	0007a023          	sw	zero,0(a5)
    2454:	00037717          	auipc	a4,0x37
    2458:	42470713          	addi	a4,a4,1060 # 39878 <xQueueRegistry>
    245c:	01c12783          	lw	a5,28(sp)
    2460:	00379793          	slli	a5,a5,0x3
    2464:	00f707b3          	add	a5,a4,a5
    2468:	0007a223          	sw	zero,4(a5)
    246c:	01c0006f          	j	2488 <vQueueUnregisterQueue+0x7c>
    2470:	01c12783          	lw	a5,28(sp)
    2474:	00178793          	addi	a5,a5,1
    2478:	00f12e23          	sw	a5,28(sp)
    247c:	01c12703          	lw	a4,28(sp)
    2480:	00700793          	li	a5,7
    2484:	f8e7fce3          	bleu	a4,a5,241c <vQueueUnregisterQueue+0x10>
    2488:	00000013          	nop
    248c:	02010113          	addi	sp,sp,32
    2490:	00008067          	ret

00002494 <vQueueWaitForMessageRestricted>:
    2494:	fd010113          	addi	sp,sp,-48
    2498:	02112623          	sw	ra,44(sp)
    249c:	00a12623          	sw	a0,12(sp)
    24a0:	00b12423          	sw	a1,8(sp)
    24a4:	00c12223          	sw	a2,4(sp)
    24a8:	00c12783          	lw	a5,12(sp)
    24ac:	00f12e23          	sw	a5,28(sp)
    24b0:	059020ef          	jal	ra,4d08 <vTaskEnterCritical>
    24b4:	01c12783          	lw	a5,28(sp)
    24b8:	0447c783          	lbu	a5,68(a5)
    24bc:	01879713          	slli	a4,a5,0x18
    24c0:	41875713          	srai	a4,a4,0x18
    24c4:	fff00793          	li	a5,-1
    24c8:	00f71663          	bne	a4,a5,24d4 <vQueueWaitForMessageRestricted+0x40>
    24cc:	01c12783          	lw	a5,28(sp)
    24d0:	04078223          	sb	zero,68(a5)
    24d4:	01c12783          	lw	a5,28(sp)
    24d8:	0457c783          	lbu	a5,69(a5)
    24dc:	01879713          	slli	a4,a5,0x18
    24e0:	41875713          	srai	a4,a4,0x18
    24e4:	fff00793          	li	a5,-1
    24e8:	00f71663          	bne	a4,a5,24f4 <vQueueWaitForMessageRestricted+0x60>
    24ec:	01c12783          	lw	a5,28(sp)
    24f0:	040782a3          	sb	zero,69(a5)
    24f4:	055020ef          	jal	ra,4d48 <vTaskExitCritical>
    24f8:	01c12783          	lw	a5,28(sp)
    24fc:	0387a783          	lw	a5,56(a5)
    2500:	00079e63          	bnez	a5,251c <vQueueWaitForMessageRestricted+0x88>
    2504:	01c12783          	lw	a5,28(sp)
    2508:	02478793          	addi	a5,a5,36
    250c:	00412603          	lw	a2,4(sp)
    2510:	00812583          	lw	a1,8(sp)
    2514:	00078513          	mv	a0,a5
    2518:	165010ef          	jal	ra,3e7c <vTaskPlaceOnEventListRestricted>
    251c:	01c12503          	lw	a0,28(sp)
    2520:	bbdff0ef          	jal	ra,20dc <prvUnlockQueue>
    2524:	00000013          	nop
    2528:	02c12083          	lw	ra,44(sp)
    252c:	03010113          	addi	sp,sp,48
    2530:	00008067          	ret

00002534 <xTaskCreate>:
    2534:	fc010113          	addi	sp,sp,-64
    2538:	02112e23          	sw	ra,60(sp)
    253c:	00a12e23          	sw	a0,28(sp)
    2540:	00b12c23          	sw	a1,24(sp)
    2544:	00d12823          	sw	a3,16(sp)
    2548:	00e12623          	sw	a4,12(sp)
    254c:	00f12423          	sw	a5,8(sp)
    2550:	00060793          	mv	a5,a2
    2554:	00f11b23          	sh	a5,22(sp)
    2558:	01615783          	lhu	a5,22(sp)
    255c:	00279793          	slli	a5,a5,0x2
    2560:	00078513          	mv	a0,a5
    2564:	600040ef          	jal	ra,6b64 <pvPortMalloc>
    2568:	02a12223          	sw	a0,36(sp)
    256c:	02412783          	lw	a5,36(sp)
    2570:	02078a63          	beqz	a5,25a4 <xTaskCreate+0x70>
    2574:	06000513          	li	a0,96
    2578:	5ec040ef          	jal	ra,6b64 <pvPortMalloc>
    257c:	02a12623          	sw	a0,44(sp)
    2580:	02c12783          	lw	a5,44(sp)
    2584:	00078a63          	beqz	a5,2598 <xTaskCreate+0x64>
    2588:	02c12783          	lw	a5,44(sp)
    258c:	02412703          	lw	a4,36(sp)
    2590:	02e7a823          	sw	a4,48(a5)
    2594:	0140006f          	j	25a8 <xTaskCreate+0x74>
    2598:	02412503          	lw	a0,36(sp)
    259c:	7c4040ef          	jal	ra,6d60 <vPortFree>
    25a0:	0080006f          	j	25a8 <xTaskCreate+0x74>
    25a4:	02012623          	sw	zero,44(sp)
    25a8:	02c12783          	lw	a5,44(sp)
    25ac:	02078e63          	beqz	a5,25e8 <xTaskCreate+0xb4>
    25b0:	01615603          	lhu	a2,22(sp)
    25b4:	00000893          	li	a7,0
    25b8:	02c12803          	lw	a6,44(sp)
    25bc:	00812783          	lw	a5,8(sp)
    25c0:	00c12703          	lw	a4,12(sp)
    25c4:	01012683          	lw	a3,16(sp)
    25c8:	01812583          	lw	a1,24(sp)
    25cc:	01c12503          	lw	a0,28(sp)
    25d0:	034000ef          	jal	ra,2604 <prvInitialiseNewTask>
    25d4:	02c12503          	lw	a0,44(sp)
    25d8:	204000ef          	jal	ra,27dc <prvAddNewTaskToReadyList>
    25dc:	00100793          	li	a5,1
    25e0:	02f12423          	sw	a5,40(sp)
    25e4:	00c0006f          	j	25f0 <xTaskCreate+0xbc>
    25e8:	fff00793          	li	a5,-1
    25ec:	02f12423          	sw	a5,40(sp)
    25f0:	02812783          	lw	a5,40(sp)
    25f4:	00078513          	mv	a0,a5
    25f8:	03c12083          	lw	ra,60(sp)
    25fc:	04010113          	addi	sp,sp,64
    2600:	00008067          	ret

00002604 <prvInitialiseNewTask>:
    2604:	fc010113          	addi	sp,sp,-64
    2608:	02112e23          	sw	ra,60(sp)
    260c:	00a12e23          	sw	a0,28(sp)
    2610:	00b12c23          	sw	a1,24(sp)
    2614:	00c12a23          	sw	a2,20(sp)
    2618:	00d12823          	sw	a3,16(sp)
    261c:	00e12623          	sw	a4,12(sp)
    2620:	00f12423          	sw	a5,8(sp)
    2624:	01012223          	sw	a6,4(sp)
    2628:	01112023          	sw	a7,0(sp)
    262c:	01812783          	lw	a5,24(sp)
    2630:	00079663          	bnez	a5,263c <prvInitialiseNewTask+0x38>
    2634:	30047073          	csrci	mstatus,8
    2638:	0000006f          	j	2638 <prvInitialiseNewTask+0x34>
    263c:	00412783          	lw	a5,4(sp)
    2640:	0307a703          	lw	a4,48(a5)
    2644:	01412783          	lw	a5,20(sp)
    2648:	00279793          	slli	a5,a5,0x2
    264c:	00078613          	mv	a2,a5
    2650:	0a500593          	li	a1,165
    2654:	00070513          	mv	a0,a4
    2658:	135040ef          	jal	ra,6f8c <memset>
    265c:	00412783          	lw	a5,4(sp)
    2660:	0307a703          	lw	a4,48(a5)
    2664:	01412683          	lw	a3,20(sp)
    2668:	400007b7          	lui	a5,0x40000
    266c:	fff78793          	addi	a5,a5,-1 # 3fffffff <__stack+0x3ffc46f7>
    2670:	00f687b3          	add	a5,a3,a5
    2674:	00279793          	slli	a5,a5,0x2
    2678:	00f707b3          	add	a5,a4,a5
    267c:	02f12423          	sw	a5,40(sp)
    2680:	02812783          	lw	a5,40(sp)
    2684:	ffc7f793          	andi	a5,a5,-4
    2688:	02f12423          	sw	a5,40(sp)
    268c:	02812783          	lw	a5,40(sp)
    2690:	0037f793          	andi	a5,a5,3
    2694:	00078663          	beqz	a5,26a0 <prvInitialiseNewTask+0x9c>
    2698:	30047073          	csrci	mstatus,8
    269c:	0000006f          	j	269c <prvInitialiseNewTask+0x98>
    26a0:	02012623          	sw	zero,44(sp)
    26a4:	0440006f          	j	26e8 <prvInitialiseNewTask+0xe4>
    26a8:	01812703          	lw	a4,24(sp)
    26ac:	02c12783          	lw	a5,44(sp)
    26b0:	00f707b3          	add	a5,a4,a5
    26b4:	0007c703          	lbu	a4,0(a5)
    26b8:	00412683          	lw	a3,4(sp)
    26bc:	02c12783          	lw	a5,44(sp)
    26c0:	00f687b3          	add	a5,a3,a5
    26c4:	02e78a23          	sb	a4,52(a5)
    26c8:	01812703          	lw	a4,24(sp)
    26cc:	02c12783          	lw	a5,44(sp)
    26d0:	00f707b3          	add	a5,a4,a5
    26d4:	0007c783          	lbu	a5,0(a5)
    26d8:	02078063          	beqz	a5,26f8 <prvInitialiseNewTask+0xf4>
    26dc:	02c12783          	lw	a5,44(sp)
    26e0:	00178793          	addi	a5,a5,1
    26e4:	02f12623          	sw	a5,44(sp)
    26e8:	02c12703          	lw	a4,44(sp)
    26ec:	00f00793          	li	a5,15
    26f0:	fae7fce3          	bleu	a4,a5,26a8 <prvInitialiseNewTask+0xa4>
    26f4:	0080006f          	j	26fc <prvInitialiseNewTask+0xf8>
    26f8:	00000013          	nop
    26fc:	00412783          	lw	a5,4(sp)
    2700:	040781a3          	sb	zero,67(a5)
    2704:	00c12703          	lw	a4,12(sp)
    2708:	00400793          	li	a5,4
    270c:	00e7f663          	bleu	a4,a5,2718 <prvInitialiseNewTask+0x114>
    2710:	00400793          	li	a5,4
    2714:	00f12623          	sw	a5,12(sp)
    2718:	00412783          	lw	a5,4(sp)
    271c:	00c12703          	lw	a4,12(sp)
    2720:	02e7a623          	sw	a4,44(a5)
    2724:	00412783          	lw	a5,4(sp)
    2728:	00c12703          	lw	a4,12(sp)
    272c:	04e7a823          	sw	a4,80(a5)
    2730:	00412783          	lw	a5,4(sp)
    2734:	0407aa23          	sw	zero,84(a5)
    2738:	00412783          	lw	a5,4(sp)
    273c:	00478793          	addi	a5,a5,4
    2740:	00078513          	mv	a0,a5
    2744:	990fe0ef          	jal	ra,8d4 <vListInitialiseItem>
    2748:	00412783          	lw	a5,4(sp)
    274c:	01878793          	addi	a5,a5,24
    2750:	00078513          	mv	a0,a5
    2754:	980fe0ef          	jal	ra,8d4 <vListInitialiseItem>
    2758:	00412783          	lw	a5,4(sp)
    275c:	00412703          	lw	a4,4(sp)
    2760:	00e7a823          	sw	a4,16(a5)
    2764:	00500713          	li	a4,5
    2768:	00c12783          	lw	a5,12(sp)
    276c:	40f70733          	sub	a4,a4,a5
    2770:	00412783          	lw	a5,4(sp)
    2774:	00e7ac23          	sw	a4,24(a5)
    2778:	00412783          	lw	a5,4(sp)
    277c:	00412703          	lw	a4,4(sp)
    2780:	02e7a223          	sw	a4,36(a5)
    2784:	00412783          	lw	a5,4(sp)
    2788:	0407a223          	sw	zero,68(a5)
    278c:	00412783          	lw	a5,4(sp)
    2790:	0407ac23          	sw	zero,88(a5)
    2794:	00412783          	lw	a5,4(sp)
    2798:	04078e23          	sb	zero,92(a5)
    279c:	01012603          	lw	a2,16(sp)
    27a0:	01c12583          	lw	a1,28(sp)
    27a4:	02812503          	lw	a0,40(sp)
    27a8:	820fe0ef          	jal	ra,7c8 <pxPortInitialiseStack>
    27ac:	00050713          	mv	a4,a0
    27b0:	00412783          	lw	a5,4(sp)
    27b4:	00e7a023          	sw	a4,0(a5)
    27b8:	00812783          	lw	a5,8(sp)
    27bc:	00078863          	beqz	a5,27cc <prvInitialiseNewTask+0x1c8>
    27c0:	00812783          	lw	a5,8(sp)
    27c4:	00412703          	lw	a4,4(sp)
    27c8:	00e7a023          	sw	a4,0(a5)
    27cc:	00000013          	nop
    27d0:	03c12083          	lw	ra,60(sp)
    27d4:	04010113          	addi	sp,sp,64
    27d8:	00008067          	ret

000027dc <prvAddNewTaskToReadyList>:
    27dc:	fe010113          	addi	sp,sp,-32
    27e0:	00112e23          	sw	ra,28(sp)
    27e4:	00a12623          	sw	a0,12(sp)
    27e8:	520020ef          	jal	ra,4d08 <vTaskEnterCritical>
    27ec:	0001e797          	auipc	a5,0x1e
    27f0:	ebc78793          	addi	a5,a5,-324 # 206a8 <uxCurrentNumberOfTasks>
    27f4:	0007a783          	lw	a5,0(a5)
    27f8:	00178713          	addi	a4,a5,1
    27fc:	0001e797          	auipc	a5,0x1e
    2800:	eac78793          	addi	a5,a5,-340 # 206a8 <uxCurrentNumberOfTasks>
    2804:	00e7a023          	sw	a4,0(a5)
    2808:	0001e797          	auipc	a5,0x1e
    280c:	d4878793          	addi	a5,a5,-696 # 20550 <pxCurrentTCB>
    2810:	0007a783          	lw	a5,0(a5)
    2814:	02079863          	bnez	a5,2844 <prvAddNewTaskToReadyList+0x68>
    2818:	0001e797          	auipc	a5,0x1e
    281c:	d3878793          	addi	a5,a5,-712 # 20550 <pxCurrentTCB>
    2820:	00c12703          	lw	a4,12(sp)
    2824:	00e7a023          	sw	a4,0(a5)
    2828:	0001e797          	auipc	a5,0x1e
    282c:	e8078793          	addi	a5,a5,-384 # 206a8 <uxCurrentNumberOfTasks>
    2830:	0007a703          	lw	a4,0(a5)
    2834:	00100793          	li	a5,1
    2838:	04f71463          	bne	a4,a5,2880 <prvAddNewTaskToReadyList+0xa4>
    283c:	339010ef          	jal	ra,4374 <prvInitialiseTaskLists>
    2840:	0400006f          	j	2880 <prvAddNewTaskToReadyList+0xa4>
    2844:	0001e797          	auipc	a5,0x1e
    2848:	e7078793          	addi	a5,a5,-400 # 206b4 <xSchedulerRunning>
    284c:	0007a783          	lw	a5,0(a5)
    2850:	02079863          	bnez	a5,2880 <prvAddNewTaskToReadyList+0xa4>
    2854:	0001e797          	auipc	a5,0x1e
    2858:	cfc78793          	addi	a5,a5,-772 # 20550 <pxCurrentTCB>
    285c:	0007a783          	lw	a5,0(a5)
    2860:	02c7a703          	lw	a4,44(a5)
    2864:	00c12783          	lw	a5,12(sp)
    2868:	02c7a783          	lw	a5,44(a5)
    286c:	00e7ea63          	bltu	a5,a4,2880 <prvAddNewTaskToReadyList+0xa4>
    2870:	0001e797          	auipc	a5,0x1e
    2874:	ce078793          	addi	a5,a5,-800 # 20550 <pxCurrentTCB>
    2878:	00c12703          	lw	a4,12(sp)
    287c:	00e7a023          	sw	a4,0(a5)
    2880:	0001e797          	auipc	a5,0x1e
    2884:	e4478793          	addi	a5,a5,-444 # 206c4 <uxTaskNumber>
    2888:	0007a783          	lw	a5,0(a5)
    288c:	00178713          	addi	a4,a5,1
    2890:	0001e797          	auipc	a5,0x1e
    2894:	e3478793          	addi	a5,a5,-460 # 206c4 <uxTaskNumber>
    2898:	00e7a023          	sw	a4,0(a5)
    289c:	0001e797          	auipc	a5,0x1e
    28a0:	e2878793          	addi	a5,a5,-472 # 206c4 <uxTaskNumber>
    28a4:	0007a703          	lw	a4,0(a5)
    28a8:	00c12783          	lw	a5,12(sp)
    28ac:	04e7a423          	sw	a4,72(a5)
    28b0:	00c12783          	lw	a5,12(sp)
    28b4:	02c7a703          	lw	a4,44(a5)
    28b8:	0001e797          	auipc	a5,0x1e
    28bc:	df878793          	addi	a5,a5,-520 # 206b0 <uxTopReadyPriority>
    28c0:	0007a783          	lw	a5,0(a5)
    28c4:	00e7fc63          	bleu	a4,a5,28dc <prvAddNewTaskToReadyList+0x100>
    28c8:	00c12783          	lw	a5,12(sp)
    28cc:	02c7a703          	lw	a4,44(a5)
    28d0:	0001e797          	auipc	a5,0x1e
    28d4:	de078793          	addi	a5,a5,-544 # 206b0 <uxTopReadyPriority>
    28d8:	00e7a023          	sw	a4,0(a5)
    28dc:	00c12783          	lw	a5,12(sp)
    28e0:	02c7a703          	lw	a4,44(a5)
    28e4:	00070793          	mv	a5,a4
    28e8:	00279793          	slli	a5,a5,0x2
    28ec:	00e787b3          	add	a5,a5,a4
    28f0:	00279793          	slli	a5,a5,0x2
    28f4:	0001e717          	auipc	a4,0x1e
    28f8:	d0870713          	addi	a4,a4,-760 # 205fc <pxReadyTasksLists>
    28fc:	00e78733          	add	a4,a5,a4
    2900:	00c12783          	lw	a5,12(sp)
    2904:	00478793          	addi	a5,a5,4
    2908:	00078593          	mv	a1,a5
    290c:	00070513          	mv	a0,a4
    2910:	fe1fd0ef          	jal	ra,8f0 <vListInsertEnd>
    2914:	434020ef          	jal	ra,4d48 <vTaskExitCritical>
    2918:	0001e797          	auipc	a5,0x1e
    291c:	d9c78793          	addi	a5,a5,-612 # 206b4 <xSchedulerRunning>
    2920:	0007a783          	lw	a5,0(a5)
    2924:	02078263          	beqz	a5,2948 <prvAddNewTaskToReadyList+0x16c>
    2928:	0001e797          	auipc	a5,0x1e
    292c:	c2878793          	addi	a5,a5,-984 # 20550 <pxCurrentTCB>
    2930:	0007a783          	lw	a5,0(a5)
    2934:	02c7a703          	lw	a4,44(a5)
    2938:	00c12783          	lw	a5,12(sp)
    293c:	02c7a783          	lw	a5,44(a5)
    2940:	00f77463          	bleu	a5,a4,2948 <prvAddNewTaskToReadyList+0x16c>
    2944:	c51fd0ef          	jal	ra,594 <vPortYield>
    2948:	00000013          	nop
    294c:	01c12083          	lw	ra,28(sp)
    2950:	02010113          	addi	sp,sp,32
    2954:	00008067          	ret

00002958 <vTaskDelete>:
    2958:	fd010113          	addi	sp,sp,-48
    295c:	02112623          	sw	ra,44(sp)
    2960:	00a12623          	sw	a0,12(sp)
    2964:	3a4020ef          	jal	ra,4d08 <vTaskEnterCritical>
    2968:	00c12783          	lw	a5,12(sp)
    296c:	00079a63          	bnez	a5,2980 <vTaskDelete+0x28>
    2970:	0001e797          	auipc	a5,0x1e
    2974:	be078793          	addi	a5,a5,-1056 # 20550 <pxCurrentTCB>
    2978:	0007a783          	lw	a5,0(a5)
    297c:	0080006f          	j	2984 <vTaskDelete+0x2c>
    2980:	00c12783          	lw	a5,12(sp)
    2984:	00f12e23          	sw	a5,28(sp)
    2988:	01c12783          	lw	a5,28(sp)
    298c:	00478793          	addi	a5,a5,4
    2990:	00078513          	mv	a0,a5
    2994:	8a0fe0ef          	jal	ra,a34 <uxListRemove>
    2998:	01c12783          	lw	a5,28(sp)
    299c:	0287a783          	lw	a5,40(a5)
    29a0:	00078a63          	beqz	a5,29b4 <vTaskDelete+0x5c>
    29a4:	01c12783          	lw	a5,28(sp)
    29a8:	01878793          	addi	a5,a5,24
    29ac:	00078513          	mv	a0,a5
    29b0:	884fe0ef          	jal	ra,a34 <uxListRemove>
    29b4:	0001e797          	auipc	a5,0x1e
    29b8:	d1078793          	addi	a5,a5,-752 # 206c4 <uxTaskNumber>
    29bc:	0007a783          	lw	a5,0(a5)
    29c0:	00178713          	addi	a4,a5,1
    29c4:	0001e797          	auipc	a5,0x1e
    29c8:	d0078793          	addi	a5,a5,-768 # 206c4 <uxTaskNumber>
    29cc:	00e7a023          	sw	a4,0(a5)
    29d0:	0001e797          	auipc	a5,0x1e
    29d4:	b8078793          	addi	a5,a5,-1152 # 20550 <pxCurrentTCB>
    29d8:	0007a783          	lw	a5,0(a5)
    29dc:	01c12703          	lw	a4,28(sp)
    29e0:	02f71e63          	bne	a4,a5,2a1c <vTaskDelete+0xc4>
    29e4:	01c12783          	lw	a5,28(sp)
    29e8:	00478793          	addi	a5,a5,4
    29ec:	00078593          	mv	a1,a5
    29f0:	0001e517          	auipc	a0,0x1e
    29f4:	c8c50513          	addi	a0,a0,-884 # 2067c <xTasksWaitingTermination>
    29f8:	ef9fd0ef          	jal	ra,8f0 <vListInsertEnd>
    29fc:	0001e797          	auipc	a5,0x1e
    2a00:	c9478793          	addi	a5,a5,-876 # 20690 <uxDeletedTasksWaitingCleanUp>
    2a04:	0007a783          	lw	a5,0(a5)
    2a08:	00178713          	addi	a4,a5,1
    2a0c:	0001e797          	auipc	a5,0x1e
    2a10:	c8478793          	addi	a5,a5,-892 # 20690 <uxDeletedTasksWaitingCleanUp>
    2a14:	00e7a023          	sw	a4,0(a5)
    2a18:	02c0006f          	j	2a44 <vTaskDelete+0xec>
    2a1c:	0001e797          	auipc	a5,0x1e
    2a20:	c8c78793          	addi	a5,a5,-884 # 206a8 <uxCurrentNumberOfTasks>
    2a24:	0007a783          	lw	a5,0(a5)
    2a28:	fff78713          	addi	a4,a5,-1
    2a2c:	0001e797          	auipc	a5,0x1e
    2a30:	c7c78793          	addi	a5,a5,-900 # 206a8 <uxCurrentNumberOfTasks>
    2a34:	00e7a023          	sw	a4,0(a5)
    2a38:	01c12503          	lw	a0,28(sp)
    2a3c:	579010ef          	jal	ra,47b4 <prvDeleteTCB>
    2a40:	5a9010ef          	jal	ra,47e8 <prvResetNextTaskUnblockTime>
    2a44:	304020ef          	jal	ra,4d48 <vTaskExitCritical>
    2a48:	0001e797          	auipc	a5,0x1e
    2a4c:	c6c78793          	addi	a5,a5,-916 # 206b4 <xSchedulerRunning>
    2a50:	0007a783          	lw	a5,0(a5)
    2a54:	02078a63          	beqz	a5,2a88 <vTaskDelete+0x130>
    2a58:	0001e797          	auipc	a5,0x1e
    2a5c:	af878793          	addi	a5,a5,-1288 # 20550 <pxCurrentTCB>
    2a60:	0007a783          	lw	a5,0(a5)
    2a64:	01c12703          	lw	a4,28(sp)
    2a68:	02f71063          	bne	a4,a5,2a88 <vTaskDelete+0x130>
    2a6c:	0001e797          	auipc	a5,0x1e
    2a70:	c6478793          	addi	a5,a5,-924 # 206d0 <uxSchedulerSuspended>
    2a74:	0007a783          	lw	a5,0(a5)
    2a78:	00078663          	beqz	a5,2a84 <vTaskDelete+0x12c>
    2a7c:	30047073          	csrci	mstatus,8
    2a80:	0000006f          	j	2a80 <vTaskDelete+0x128>
    2a84:	b11fd0ef          	jal	ra,594 <vPortYield>
    2a88:	00000013          	nop
    2a8c:	02c12083          	lw	ra,44(sp)
    2a90:	03010113          	addi	sp,sp,48
    2a94:	00008067          	ret

00002a98 <vTaskDelayUntil>:
    2a98:	fd010113          	addi	sp,sp,-48
    2a9c:	02112623          	sw	ra,44(sp)
    2aa0:	00a12623          	sw	a0,12(sp)
    2aa4:	00b12423          	sw	a1,8(sp)
    2aa8:	00012e23          	sw	zero,28(sp)
    2aac:	00c12783          	lw	a5,12(sp)
    2ab0:	00079663          	bnez	a5,2abc <vTaskDelayUntil+0x24>
    2ab4:	30047073          	csrci	mstatus,8
    2ab8:	0000006f          	j	2ab8 <vTaskDelayUntil+0x20>
    2abc:	00812783          	lw	a5,8(sp)
    2ac0:	00079663          	bnez	a5,2acc <vTaskDelayUntil+0x34>
    2ac4:	30047073          	csrci	mstatus,8
    2ac8:	0000006f          	j	2ac8 <vTaskDelayUntil+0x30>
    2acc:	0001e797          	auipc	a5,0x1e
    2ad0:	c0478793          	addi	a5,a5,-1020 # 206d0 <uxSchedulerSuspended>
    2ad4:	0007a783          	lw	a5,0(a5)
    2ad8:	00078663          	beqz	a5,2ae4 <vTaskDelayUntil+0x4c>
    2adc:	30047073          	csrci	mstatus,8
    2ae0:	0000006f          	j	2ae0 <vTaskDelayUntil+0x48>
    2ae4:	1b1000ef          	jal	ra,3494 <vTaskSuspendAll>
    2ae8:	0001e797          	auipc	a5,0x1e
    2aec:	bc478793          	addi	a5,a5,-1084 # 206ac <xTickCount>
    2af0:	0007a783          	lw	a5,0(a5)
    2af4:	00f12c23          	sw	a5,24(sp)
    2af8:	00c12783          	lw	a5,12(sp)
    2afc:	0007a783          	lw	a5,0(a5)
    2b00:	00812703          	lw	a4,8(sp)
    2b04:	00f707b3          	add	a5,a4,a5
    2b08:	00f12a23          	sw	a5,20(sp)
    2b0c:	00c12783          	lw	a5,12(sp)
    2b10:	0007a783          	lw	a5,0(a5)
    2b14:	01812703          	lw	a4,24(sp)
    2b18:	02f77663          	bleu	a5,a4,2b44 <vTaskDelayUntil+0xac>
    2b1c:	00c12783          	lw	a5,12(sp)
    2b20:	0007a783          	lw	a5,0(a5)
    2b24:	01412703          	lw	a4,20(sp)
    2b28:	04f77063          	bleu	a5,a4,2b68 <vTaskDelayUntil+0xd0>
    2b2c:	01412703          	lw	a4,20(sp)
    2b30:	01812783          	lw	a5,24(sp)
    2b34:	02e7fa63          	bleu	a4,a5,2b68 <vTaskDelayUntil+0xd0>
    2b38:	00100793          	li	a5,1
    2b3c:	00f12e23          	sw	a5,28(sp)
    2b40:	0280006f          	j	2b68 <vTaskDelayUntil+0xd0>
    2b44:	00c12783          	lw	a5,12(sp)
    2b48:	0007a783          	lw	a5,0(a5)
    2b4c:	01412703          	lw	a4,20(sp)
    2b50:	00f76863          	bltu	a4,a5,2b60 <vTaskDelayUntil+0xc8>
    2b54:	01412703          	lw	a4,20(sp)
    2b58:	01812783          	lw	a5,24(sp)
    2b5c:	00e7f663          	bleu	a4,a5,2b68 <vTaskDelayUntil+0xd0>
    2b60:	00100793          	li	a5,1
    2b64:	00f12e23          	sw	a5,28(sp)
    2b68:	00c12783          	lw	a5,12(sp)
    2b6c:	01412703          	lw	a4,20(sp)
    2b70:	00e7a023          	sw	a4,0(a5)
    2b74:	01c12783          	lw	a5,28(sp)
    2b78:	00078e63          	beqz	a5,2b94 <vTaskDelayUntil+0xfc>
    2b7c:	01412703          	lw	a4,20(sp)
    2b80:	01812783          	lw	a5,24(sp)
    2b84:	40f707b3          	sub	a5,a4,a5
    2b88:	00000593          	li	a1,0
    2b8c:	00078513          	mv	a0,a5
    2b90:	2d5020ef          	jal	ra,5664 <prvAddCurrentTaskToDelayedList>
    2b94:	125000ef          	jal	ra,34b8 <xTaskResumeAll>
    2b98:	00a12823          	sw	a0,16(sp)
    2b9c:	01012783          	lw	a5,16(sp)
    2ba0:	00079463          	bnez	a5,2ba8 <vTaskDelayUntil+0x110>
    2ba4:	9f1fd0ef          	jal	ra,594 <vPortYield>
    2ba8:	00000013          	nop
    2bac:	02c12083          	lw	ra,44(sp)
    2bb0:	03010113          	addi	sp,sp,48
    2bb4:	00008067          	ret

00002bb8 <vTaskDelay>:
    2bb8:	fd010113          	addi	sp,sp,-48
    2bbc:	02112623          	sw	ra,44(sp)
    2bc0:	00a12623          	sw	a0,12(sp)
    2bc4:	00012e23          	sw	zero,28(sp)
    2bc8:	00c12783          	lw	a5,12(sp)
    2bcc:	02078a63          	beqz	a5,2c00 <vTaskDelay+0x48>
    2bd0:	0001e797          	auipc	a5,0x1e
    2bd4:	b0078793          	addi	a5,a5,-1280 # 206d0 <uxSchedulerSuspended>
    2bd8:	0007a783          	lw	a5,0(a5)
    2bdc:	00078663          	beqz	a5,2be8 <vTaskDelay+0x30>
    2be0:	30047073          	csrci	mstatus,8
    2be4:	0000006f          	j	2be4 <vTaskDelay+0x2c>
    2be8:	0ad000ef          	jal	ra,3494 <vTaskSuspendAll>
    2bec:	00000593          	li	a1,0
    2bf0:	00c12503          	lw	a0,12(sp)
    2bf4:	271020ef          	jal	ra,5664 <prvAddCurrentTaskToDelayedList>
    2bf8:	0c1000ef          	jal	ra,34b8 <xTaskResumeAll>
    2bfc:	00a12e23          	sw	a0,28(sp)
    2c00:	01c12783          	lw	a5,28(sp)
    2c04:	00079463          	bnez	a5,2c0c <vTaskDelay+0x54>
    2c08:	98dfd0ef          	jal	ra,594 <vPortYield>
    2c0c:	00000013          	nop
    2c10:	02c12083          	lw	ra,44(sp)
    2c14:	03010113          	addi	sp,sp,48
    2c18:	00008067          	ret

00002c1c <eTaskGetState>:
    2c1c:	fc010113          	addi	sp,sp,-64
    2c20:	02112e23          	sw	ra,60(sp)
    2c24:	00a12623          	sw	a0,12(sp)
    2c28:	00c12783          	lw	a5,12(sp)
    2c2c:	02f12423          	sw	a5,40(sp)
    2c30:	02812783          	lw	a5,40(sp)
    2c34:	00079663          	bnez	a5,2c40 <eTaskGetState+0x24>
    2c38:	30047073          	csrci	mstatus,8
    2c3c:	0000006f          	j	2c3c <eTaskGetState+0x20>
    2c40:	0001e797          	auipc	a5,0x1e
    2c44:	91078793          	addi	a5,a5,-1776 # 20550 <pxCurrentTCB>
    2c48:	0007a783          	lw	a5,0(a5)
    2c4c:	02812703          	lw	a4,40(sp)
    2c50:	00f71663          	bne	a4,a5,2c5c <eTaskGetState+0x40>
    2c54:	02012623          	sw	zero,44(sp)
    2c58:	0dc0006f          	j	2d34 <eTaskGetState+0x118>
    2c5c:	0ac020ef          	jal	ra,4d08 <vTaskEnterCritical>
    2c60:	02812783          	lw	a5,40(sp)
    2c64:	0147a783          	lw	a5,20(a5)
    2c68:	02f12223          	sw	a5,36(sp)
    2c6c:	0001e797          	auipc	a5,0x1e
    2c70:	9f478793          	addi	a5,a5,-1548 # 20660 <pxDelayedTaskList>
    2c74:	0007a783          	lw	a5,0(a5)
    2c78:	02f12023          	sw	a5,32(sp)
    2c7c:	0001e797          	auipc	a5,0x1e
    2c80:	9e878793          	addi	a5,a5,-1560 # 20664 <pxOverflowDelayedTaskList>
    2c84:	0007a783          	lw	a5,0(a5)
    2c88:	00f12e23          	sw	a5,28(sp)
    2c8c:	0bc020ef          	jal	ra,4d48 <vTaskExitCritical>
    2c90:	02412703          	lw	a4,36(sp)
    2c94:	02012783          	lw	a5,32(sp)
    2c98:	00f70863          	beq	a4,a5,2ca8 <eTaskGetState+0x8c>
    2c9c:	02412703          	lw	a4,36(sp)
    2ca0:	01c12783          	lw	a5,28(sp)
    2ca4:	00f71863          	bne	a4,a5,2cb4 <eTaskGetState+0x98>
    2ca8:	00200793          	li	a5,2
    2cac:	02f12623          	sw	a5,44(sp)
    2cb0:	0840006f          	j	2d34 <eTaskGetState+0x118>
    2cb4:	02412703          	lw	a4,36(sp)
    2cb8:	0001e797          	auipc	a5,0x1e
    2cbc:	9dc78793          	addi	a5,a5,-1572 # 20694 <xSuspendedTaskList>
    2cc0:	04f71463          	bne	a4,a5,2d08 <eTaskGetState+0xec>
    2cc4:	02812783          	lw	a5,40(sp)
    2cc8:	0287a783          	lw	a5,40(a5)
    2ccc:	02079863          	bnez	a5,2cfc <eTaskGetState+0xe0>
    2cd0:	02812783          	lw	a5,40(sp)
    2cd4:	05c7c783          	lbu	a5,92(a5)
    2cd8:	0ff7f713          	andi	a4,a5,255
    2cdc:	00100793          	li	a5,1
    2ce0:	00f71863          	bne	a4,a5,2cf0 <eTaskGetState+0xd4>
    2ce4:	00200793          	li	a5,2
    2ce8:	02f12623          	sw	a5,44(sp)
    2cec:	0480006f          	j	2d34 <eTaskGetState+0x118>
    2cf0:	00300793          	li	a5,3
    2cf4:	02f12623          	sw	a5,44(sp)
    2cf8:	03c0006f          	j	2d34 <eTaskGetState+0x118>
    2cfc:	00200793          	li	a5,2
    2d00:	02f12623          	sw	a5,44(sp)
    2d04:	0300006f          	j	2d34 <eTaskGetState+0x118>
    2d08:	02412703          	lw	a4,36(sp)
    2d0c:	0001e797          	auipc	a5,0x1e
    2d10:	97078793          	addi	a5,a5,-1680 # 2067c <xTasksWaitingTermination>
    2d14:	00f70663          	beq	a4,a5,2d20 <eTaskGetState+0x104>
    2d18:	02412783          	lw	a5,36(sp)
    2d1c:	00079863          	bnez	a5,2d2c <eTaskGetState+0x110>
    2d20:	00400793          	li	a5,4
    2d24:	02f12623          	sw	a5,44(sp)
    2d28:	00c0006f          	j	2d34 <eTaskGetState+0x118>
    2d2c:	00100793          	li	a5,1
    2d30:	02f12623          	sw	a5,44(sp)
    2d34:	02c12783          	lw	a5,44(sp)
    2d38:	00078513          	mv	a0,a5
    2d3c:	03c12083          	lw	ra,60(sp)
    2d40:	04010113          	addi	sp,sp,64
    2d44:	00008067          	ret

00002d48 <uxTaskPriorityGet>:
    2d48:	fd010113          	addi	sp,sp,-48
    2d4c:	02112623          	sw	ra,44(sp)
    2d50:	00a12623          	sw	a0,12(sp)
    2d54:	7b5010ef          	jal	ra,4d08 <vTaskEnterCritical>
    2d58:	00c12783          	lw	a5,12(sp)
    2d5c:	00079a63          	bnez	a5,2d70 <uxTaskPriorityGet+0x28>
    2d60:	0001d797          	auipc	a5,0x1d
    2d64:	7f078793          	addi	a5,a5,2032 # 20550 <pxCurrentTCB>
    2d68:	0007a783          	lw	a5,0(a5)
    2d6c:	0080006f          	j	2d74 <uxTaskPriorityGet+0x2c>
    2d70:	00c12783          	lw	a5,12(sp)
    2d74:	00f12e23          	sw	a5,28(sp)
    2d78:	01c12783          	lw	a5,28(sp)
    2d7c:	02c7a783          	lw	a5,44(a5)
    2d80:	00f12c23          	sw	a5,24(sp)
    2d84:	7c5010ef          	jal	ra,4d48 <vTaskExitCritical>
    2d88:	01812783          	lw	a5,24(sp)
    2d8c:	00078513          	mv	a0,a5
    2d90:	02c12083          	lw	ra,44(sp)
    2d94:	03010113          	addi	sp,sp,48
    2d98:	00008067          	ret

00002d9c <uxTaskPriorityGetFromISR>:
    2d9c:	fd010113          	addi	sp,sp,-48
    2da0:	02112623          	sw	ra,44(sp)
    2da4:	00a12623          	sw	a0,12(sp)
    2da8:	a01fd0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    2dac:	00050793          	mv	a5,a0
    2db0:	00f12e23          	sw	a5,28(sp)
    2db4:	00c12783          	lw	a5,12(sp)
    2db8:	00079a63          	bnez	a5,2dcc <uxTaskPriorityGetFromISR+0x30>
    2dbc:	0001d797          	auipc	a5,0x1d
    2dc0:	79478793          	addi	a5,a5,1940 # 20550 <pxCurrentTCB>
    2dc4:	0007a783          	lw	a5,0(a5)
    2dc8:	0080006f          	j	2dd0 <uxTaskPriorityGetFromISR+0x34>
    2dcc:	00c12783          	lw	a5,12(sp)
    2dd0:	00f12c23          	sw	a5,24(sp)
    2dd4:	01812783          	lw	a5,24(sp)
    2dd8:	02c7a783          	lw	a5,44(a5)
    2ddc:	00f12a23          	sw	a5,20(sp)
    2de0:	01c12783          	lw	a5,28(sp)
    2de4:	00078513          	mv	a0,a5
    2de8:	9a5fd0ef          	jal	ra,78c <vPortClearInterruptMask>
    2dec:	01412783          	lw	a5,20(sp)
    2df0:	00078513          	mv	a0,a5
    2df4:	02c12083          	lw	ra,44(sp)
    2df8:	03010113          	addi	sp,sp,48
    2dfc:	00008067          	ret

00002e00 <vTaskPrioritySet>:
    2e00:	fd010113          	addi	sp,sp,-48
    2e04:	02112623          	sw	ra,44(sp)
    2e08:	00a12623          	sw	a0,12(sp)
    2e0c:	00b12423          	sw	a1,8(sp)
    2e10:	00012e23          	sw	zero,28(sp)
    2e14:	00812703          	lw	a4,8(sp)
    2e18:	00400793          	li	a5,4
    2e1c:	00e7f663          	bleu	a4,a5,2e28 <vTaskPrioritySet+0x28>
    2e20:	30047073          	csrci	mstatus,8
    2e24:	0000006f          	j	2e24 <vTaskPrioritySet+0x24>
    2e28:	00812703          	lw	a4,8(sp)
    2e2c:	00400793          	li	a5,4
    2e30:	00e7f663          	bleu	a4,a5,2e3c <vTaskPrioritySet+0x3c>
    2e34:	00400793          	li	a5,4
    2e38:	00f12423          	sw	a5,8(sp)
    2e3c:	6cd010ef          	jal	ra,4d08 <vTaskEnterCritical>
    2e40:	00c12783          	lw	a5,12(sp)
    2e44:	00079a63          	bnez	a5,2e58 <vTaskPrioritySet+0x58>
    2e48:	0001d797          	auipc	a5,0x1d
    2e4c:	70878793          	addi	a5,a5,1800 # 20550 <pxCurrentTCB>
    2e50:	0007a783          	lw	a5,0(a5)
    2e54:	0080006f          	j	2e5c <vTaskPrioritySet+0x5c>
    2e58:	00c12783          	lw	a5,12(sp)
    2e5c:	00f12c23          	sw	a5,24(sp)
    2e60:	01812783          	lw	a5,24(sp)
    2e64:	0507a783          	lw	a5,80(a5)
    2e68:	00f12a23          	sw	a5,20(sp)
    2e6c:	01412703          	lw	a4,20(sp)
    2e70:	00812783          	lw	a5,8(sp)
    2e74:	16f70463          	beq	a4,a5,2fdc <vTaskPrioritySet+0x1dc>
    2e78:	00812703          	lw	a4,8(sp)
    2e7c:	01412783          	lw	a5,20(sp)
    2e80:	02e7fe63          	bleu	a4,a5,2ebc <vTaskPrioritySet+0xbc>
    2e84:	0001d797          	auipc	a5,0x1d
    2e88:	6cc78793          	addi	a5,a5,1740 # 20550 <pxCurrentTCB>
    2e8c:	0007a783          	lw	a5,0(a5)
    2e90:	01812703          	lw	a4,24(sp)
    2e94:	04f70263          	beq	a4,a5,2ed8 <vTaskPrioritySet+0xd8>
    2e98:	0001d797          	auipc	a5,0x1d
    2e9c:	6b878793          	addi	a5,a5,1720 # 20550 <pxCurrentTCB>
    2ea0:	0007a783          	lw	a5,0(a5)
    2ea4:	02c7a783          	lw	a5,44(a5)
    2ea8:	00812703          	lw	a4,8(sp)
    2eac:	02f76663          	bltu	a4,a5,2ed8 <vTaskPrioritySet+0xd8>
    2eb0:	00100793          	li	a5,1
    2eb4:	00f12e23          	sw	a5,28(sp)
    2eb8:	0200006f          	j	2ed8 <vTaskPrioritySet+0xd8>
    2ebc:	0001d797          	auipc	a5,0x1d
    2ec0:	69478793          	addi	a5,a5,1684 # 20550 <pxCurrentTCB>
    2ec4:	0007a783          	lw	a5,0(a5)
    2ec8:	01812703          	lw	a4,24(sp)
    2ecc:	00f71663          	bne	a4,a5,2ed8 <vTaskPrioritySet+0xd8>
    2ed0:	00100793          	li	a5,1
    2ed4:	00f12e23          	sw	a5,28(sp)
    2ed8:	01812783          	lw	a5,24(sp)
    2edc:	02c7a783          	lw	a5,44(a5)
    2ee0:	00f12823          	sw	a5,16(sp)
    2ee4:	01812783          	lw	a5,24(sp)
    2ee8:	0507a703          	lw	a4,80(a5)
    2eec:	01812783          	lw	a5,24(sp)
    2ef0:	02c7a783          	lw	a5,44(a5)
    2ef4:	00f71863          	bne	a4,a5,2f04 <vTaskPrioritySet+0x104>
    2ef8:	01812783          	lw	a5,24(sp)
    2efc:	00812703          	lw	a4,8(sp)
    2f00:	02e7a623          	sw	a4,44(a5)
    2f04:	01812783          	lw	a5,24(sp)
    2f08:	00812703          	lw	a4,8(sp)
    2f0c:	04e7a823          	sw	a4,80(a5)
    2f10:	01812783          	lw	a5,24(sp)
    2f14:	0187a783          	lw	a5,24(a5)
    2f18:	0007cc63          	bltz	a5,2f30 <vTaskPrioritySet+0x130>
    2f1c:	00500713          	li	a4,5
    2f20:	00812783          	lw	a5,8(sp)
    2f24:	40f70733          	sub	a4,a4,a5
    2f28:	01812783          	lw	a5,24(sp)
    2f2c:	00e7ac23          	sw	a4,24(a5)
    2f30:	01812783          	lw	a5,24(sp)
    2f34:	0147a683          	lw	a3,20(a5)
    2f38:	01012703          	lw	a4,16(sp)
    2f3c:	00070793          	mv	a5,a4
    2f40:	00279793          	slli	a5,a5,0x2
    2f44:	00e787b3          	add	a5,a5,a4
    2f48:	00279793          	slli	a5,a5,0x2
    2f4c:	0001d717          	auipc	a4,0x1d
    2f50:	6b070713          	addi	a4,a4,1712 # 205fc <pxReadyTasksLists>
    2f54:	00e787b3          	add	a5,a5,a4
    2f58:	06f69c63          	bne	a3,a5,2fd0 <vTaskPrioritySet+0x1d0>
    2f5c:	01812783          	lw	a5,24(sp)
    2f60:	00478793          	addi	a5,a5,4
    2f64:	00078513          	mv	a0,a5
    2f68:	acdfd0ef          	jal	ra,a34 <uxListRemove>
    2f6c:	01812783          	lw	a5,24(sp)
    2f70:	02c7a703          	lw	a4,44(a5)
    2f74:	0001d797          	auipc	a5,0x1d
    2f78:	73c78793          	addi	a5,a5,1852 # 206b0 <uxTopReadyPriority>
    2f7c:	0007a783          	lw	a5,0(a5)
    2f80:	00e7fc63          	bleu	a4,a5,2f98 <vTaskPrioritySet+0x198>
    2f84:	01812783          	lw	a5,24(sp)
    2f88:	02c7a703          	lw	a4,44(a5)
    2f8c:	0001d797          	auipc	a5,0x1d
    2f90:	72478793          	addi	a5,a5,1828 # 206b0 <uxTopReadyPriority>
    2f94:	00e7a023          	sw	a4,0(a5)
    2f98:	01812783          	lw	a5,24(sp)
    2f9c:	02c7a703          	lw	a4,44(a5)
    2fa0:	00070793          	mv	a5,a4
    2fa4:	00279793          	slli	a5,a5,0x2
    2fa8:	00e787b3          	add	a5,a5,a4
    2fac:	00279793          	slli	a5,a5,0x2
    2fb0:	0001d717          	auipc	a4,0x1d
    2fb4:	64c70713          	addi	a4,a4,1612 # 205fc <pxReadyTasksLists>
    2fb8:	00e78733          	add	a4,a5,a4
    2fbc:	01812783          	lw	a5,24(sp)
    2fc0:	00478793          	addi	a5,a5,4
    2fc4:	00078593          	mv	a1,a5
    2fc8:	00070513          	mv	a0,a4
    2fcc:	925fd0ef          	jal	ra,8f0 <vListInsertEnd>
    2fd0:	01c12783          	lw	a5,28(sp)
    2fd4:	00078463          	beqz	a5,2fdc <vTaskPrioritySet+0x1dc>
    2fd8:	dbcfd0ef          	jal	ra,594 <vPortYield>
    2fdc:	56d010ef          	jal	ra,4d48 <vTaskExitCritical>
    2fe0:	00000013          	nop
    2fe4:	02c12083          	lw	ra,44(sp)
    2fe8:	03010113          	addi	sp,sp,48
    2fec:	00008067          	ret

00002ff0 <vTaskSuspend>:
    2ff0:	fd010113          	addi	sp,sp,-48
    2ff4:	02112623          	sw	ra,44(sp)
    2ff8:	00a12623          	sw	a0,12(sp)
    2ffc:	50d010ef          	jal	ra,4d08 <vTaskEnterCritical>
    3000:	00c12783          	lw	a5,12(sp)
    3004:	00079a63          	bnez	a5,3018 <vTaskSuspend+0x28>
    3008:	0001d797          	auipc	a5,0x1d
    300c:	54878793          	addi	a5,a5,1352 # 20550 <pxCurrentTCB>
    3010:	0007a783          	lw	a5,0(a5)
    3014:	0080006f          	j	301c <vTaskSuspend+0x2c>
    3018:	00c12783          	lw	a5,12(sp)
    301c:	00f12e23          	sw	a5,28(sp)
    3020:	01c12783          	lw	a5,28(sp)
    3024:	00478793          	addi	a5,a5,4
    3028:	00078513          	mv	a0,a5
    302c:	a09fd0ef          	jal	ra,a34 <uxListRemove>
    3030:	01c12783          	lw	a5,28(sp)
    3034:	0287a783          	lw	a5,40(a5)
    3038:	00078a63          	beqz	a5,304c <vTaskSuspend+0x5c>
    303c:	01c12783          	lw	a5,28(sp)
    3040:	01878793          	addi	a5,a5,24
    3044:	00078513          	mv	a0,a5
    3048:	9edfd0ef          	jal	ra,a34 <uxListRemove>
    304c:	01c12783          	lw	a5,28(sp)
    3050:	00478793          	addi	a5,a5,4
    3054:	00078593          	mv	a1,a5
    3058:	0001d517          	auipc	a0,0x1d
    305c:	63c50513          	addi	a0,a0,1596 # 20694 <xSuspendedTaskList>
    3060:	891fd0ef          	jal	ra,8f0 <vListInsertEnd>
    3064:	01c12783          	lw	a5,28(sp)
    3068:	05c7c783          	lbu	a5,92(a5)
    306c:	0ff7f713          	andi	a4,a5,255
    3070:	00100793          	li	a5,1
    3074:	00f71663          	bne	a4,a5,3080 <vTaskSuspend+0x90>
    3078:	01c12783          	lw	a5,28(sp)
    307c:	04078e23          	sb	zero,92(a5)
    3080:	4c9010ef          	jal	ra,4d48 <vTaskExitCritical>
    3084:	0001d797          	auipc	a5,0x1d
    3088:	63078793          	addi	a5,a5,1584 # 206b4 <xSchedulerRunning>
    308c:	0007a783          	lw	a5,0(a5)
    3090:	00078863          	beqz	a5,30a0 <vTaskSuspend+0xb0>
    3094:	475010ef          	jal	ra,4d08 <vTaskEnterCritical>
    3098:	750010ef          	jal	ra,47e8 <prvResetNextTaskUnblockTime>
    309c:	4ad010ef          	jal	ra,4d48 <vTaskExitCritical>
    30a0:	0001d797          	auipc	a5,0x1d
    30a4:	4b078793          	addi	a5,a5,1200 # 20550 <pxCurrentTCB>
    30a8:	0007a783          	lw	a5,0(a5)
    30ac:	01c12703          	lw	a4,28(sp)
    30b0:	06f71263          	bne	a4,a5,3114 <vTaskSuspend+0x124>
    30b4:	0001d797          	auipc	a5,0x1d
    30b8:	60078793          	addi	a5,a5,1536 # 206b4 <xSchedulerRunning>
    30bc:	0007a783          	lw	a5,0(a5)
    30c0:	02078263          	beqz	a5,30e4 <vTaskSuspend+0xf4>
    30c4:	0001d797          	auipc	a5,0x1d
    30c8:	60c78793          	addi	a5,a5,1548 # 206d0 <uxSchedulerSuspended>
    30cc:	0007a783          	lw	a5,0(a5)
    30d0:	00078663          	beqz	a5,30dc <vTaskSuspend+0xec>
    30d4:	30047073          	csrci	mstatus,8
    30d8:	0000006f          	j	30d8 <vTaskSuspend+0xe8>
    30dc:	cb8fd0ef          	jal	ra,594 <vPortYield>
    30e0:	0340006f          	j	3114 <vTaskSuspend+0x124>
    30e4:	0001d797          	auipc	a5,0x1d
    30e8:	5b078793          	addi	a5,a5,1456 # 20694 <xSuspendedTaskList>
    30ec:	0007a703          	lw	a4,0(a5)
    30f0:	0001d797          	auipc	a5,0x1d
    30f4:	5b878793          	addi	a5,a5,1464 # 206a8 <uxCurrentNumberOfTasks>
    30f8:	0007a783          	lw	a5,0(a5)
    30fc:	00f71a63          	bne	a4,a5,3110 <vTaskSuspend+0x120>
    3100:	0001d797          	auipc	a5,0x1d
    3104:	45078793          	addi	a5,a5,1104 # 20550 <pxCurrentTCB>
    3108:	0007a023          	sw	zero,0(a5)
    310c:	0080006f          	j	3114 <vTaskSuspend+0x124>
    3110:	2c9000ef          	jal	ra,3bd8 <vTaskSwitchContext>
    3114:	00000013          	nop
    3118:	02c12083          	lw	ra,44(sp)
    311c:	03010113          	addi	sp,sp,48
    3120:	00008067          	ret

00003124 <prvTaskIsTaskSuspended>:
    3124:	fe010113          	addi	sp,sp,-32
    3128:	00a12623          	sw	a0,12(sp)
    312c:	00012e23          	sw	zero,28(sp)
    3130:	00c12783          	lw	a5,12(sp)
    3134:	00f12c23          	sw	a5,24(sp)
    3138:	00c12783          	lw	a5,12(sp)
    313c:	00079663          	bnez	a5,3148 <prvTaskIsTaskSuspended+0x24>
    3140:	30047073          	csrci	mstatus,8
    3144:	0000006f          	j	3144 <prvTaskIsTaskSuspended+0x20>
    3148:	01812783          	lw	a5,24(sp)
    314c:	0147a703          	lw	a4,20(a5)
    3150:	0001d797          	auipc	a5,0x1d
    3154:	54478793          	addi	a5,a5,1348 # 20694 <xSuspendedTaskList>
    3158:	02f71663          	bne	a4,a5,3184 <prvTaskIsTaskSuspended+0x60>
    315c:	01812783          	lw	a5,24(sp)
    3160:	0287a703          	lw	a4,40(a5)
    3164:	0001d797          	auipc	a5,0x1d
    3168:	50478793          	addi	a5,a5,1284 # 20668 <xPendingReadyList>
    316c:	00f70c63          	beq	a4,a5,3184 <prvTaskIsTaskSuspended+0x60>
    3170:	01812783          	lw	a5,24(sp)
    3174:	0287a783          	lw	a5,40(a5)
    3178:	00079663          	bnez	a5,3184 <prvTaskIsTaskSuspended+0x60>
    317c:	00100793          	li	a5,1
    3180:	00f12e23          	sw	a5,28(sp)
    3184:	01c12783          	lw	a5,28(sp)
    3188:	00078513          	mv	a0,a5
    318c:	02010113          	addi	sp,sp,32
    3190:	00008067          	ret

00003194 <vTaskResume>:
    3194:	fd010113          	addi	sp,sp,-48
    3198:	02112623          	sw	ra,44(sp)
    319c:	00a12623          	sw	a0,12(sp)
    31a0:	00c12783          	lw	a5,12(sp)
    31a4:	00f12e23          	sw	a5,28(sp)
    31a8:	00c12783          	lw	a5,12(sp)
    31ac:	00079663          	bnez	a5,31b8 <vTaskResume+0x24>
    31b0:	30047073          	csrci	mstatus,8
    31b4:	0000006f          	j	31b4 <vTaskResume+0x20>
    31b8:	0001d797          	auipc	a5,0x1d
    31bc:	39878793          	addi	a5,a5,920 # 20550 <pxCurrentTCB>
    31c0:	0007a783          	lw	a5,0(a5)
    31c4:	01c12703          	lw	a4,28(sp)
    31c8:	0af70c63          	beq	a4,a5,3280 <vTaskResume+0xec>
    31cc:	01c12783          	lw	a5,28(sp)
    31d0:	0a078863          	beqz	a5,3280 <vTaskResume+0xec>
    31d4:	335010ef          	jal	ra,4d08 <vTaskEnterCritical>
    31d8:	01c12503          	lw	a0,28(sp)
    31dc:	f49ff0ef          	jal	ra,3124 <prvTaskIsTaskSuspended>
    31e0:	00050793          	mv	a5,a0
    31e4:	08078c63          	beqz	a5,327c <vTaskResume+0xe8>
    31e8:	01c12783          	lw	a5,28(sp)
    31ec:	00478793          	addi	a5,a5,4
    31f0:	00078513          	mv	a0,a5
    31f4:	841fd0ef          	jal	ra,a34 <uxListRemove>
    31f8:	01c12783          	lw	a5,28(sp)
    31fc:	02c7a703          	lw	a4,44(a5)
    3200:	0001d797          	auipc	a5,0x1d
    3204:	4b078793          	addi	a5,a5,1200 # 206b0 <uxTopReadyPriority>
    3208:	0007a783          	lw	a5,0(a5)
    320c:	00e7fc63          	bleu	a4,a5,3224 <vTaskResume+0x90>
    3210:	01c12783          	lw	a5,28(sp)
    3214:	02c7a703          	lw	a4,44(a5)
    3218:	0001d797          	auipc	a5,0x1d
    321c:	49878793          	addi	a5,a5,1176 # 206b0 <uxTopReadyPriority>
    3220:	00e7a023          	sw	a4,0(a5)
    3224:	01c12783          	lw	a5,28(sp)
    3228:	02c7a703          	lw	a4,44(a5)
    322c:	00070793          	mv	a5,a4
    3230:	00279793          	slli	a5,a5,0x2
    3234:	00e787b3          	add	a5,a5,a4
    3238:	00279793          	slli	a5,a5,0x2
    323c:	0001d717          	auipc	a4,0x1d
    3240:	3c070713          	addi	a4,a4,960 # 205fc <pxReadyTasksLists>
    3244:	00e78733          	add	a4,a5,a4
    3248:	01c12783          	lw	a5,28(sp)
    324c:	00478793          	addi	a5,a5,4
    3250:	00078593          	mv	a1,a5
    3254:	00070513          	mv	a0,a4
    3258:	e98fd0ef          	jal	ra,8f0 <vListInsertEnd>
    325c:	01c12783          	lw	a5,28(sp)
    3260:	02c7a703          	lw	a4,44(a5)
    3264:	0001d797          	auipc	a5,0x1d
    3268:	2ec78793          	addi	a5,a5,748 # 20550 <pxCurrentTCB>
    326c:	0007a783          	lw	a5,0(a5)
    3270:	02c7a783          	lw	a5,44(a5)
    3274:	00f76463          	bltu	a4,a5,327c <vTaskResume+0xe8>
    3278:	b1cfd0ef          	jal	ra,594 <vPortYield>
    327c:	2cd010ef          	jal	ra,4d48 <vTaskExitCritical>
    3280:	00000013          	nop
    3284:	02c12083          	lw	ra,44(sp)
    3288:	03010113          	addi	sp,sp,48
    328c:	00008067          	ret

00003290 <xTaskResumeFromISR>:
    3290:	fd010113          	addi	sp,sp,-48
    3294:	02112623          	sw	ra,44(sp)
    3298:	00a12623          	sw	a0,12(sp)
    329c:	00012e23          	sw	zero,28(sp)
    32a0:	00c12783          	lw	a5,12(sp)
    32a4:	00f12c23          	sw	a5,24(sp)
    32a8:	00c12783          	lw	a5,12(sp)
    32ac:	00079663          	bnez	a5,32b8 <xTaskResumeFromISR+0x28>
    32b0:	30047073          	csrci	mstatus,8
    32b4:	0000006f          	j	32b4 <xTaskResumeFromISR+0x24>
    32b8:	cf0fd0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    32bc:	00050793          	mv	a5,a0
    32c0:	00f12a23          	sw	a5,20(sp)
    32c4:	01812503          	lw	a0,24(sp)
    32c8:	e5dff0ef          	jal	ra,3124 <prvTaskIsTaskSuspended>
    32cc:	00050793          	mv	a5,a0
    32d0:	0c078463          	beqz	a5,3398 <xTaskResumeFromISR+0x108>
    32d4:	0001d797          	auipc	a5,0x1d
    32d8:	3fc78793          	addi	a5,a5,1020 # 206d0 <uxSchedulerSuspended>
    32dc:	0007a783          	lw	a5,0(a5)
    32e0:	0a079063          	bnez	a5,3380 <xTaskResumeFromISR+0xf0>
    32e4:	01812783          	lw	a5,24(sp)
    32e8:	02c7a703          	lw	a4,44(a5)
    32ec:	0001d797          	auipc	a5,0x1d
    32f0:	26478793          	addi	a5,a5,612 # 20550 <pxCurrentTCB>
    32f4:	0007a783          	lw	a5,0(a5)
    32f8:	02c7a783          	lw	a5,44(a5)
    32fc:	00f76663          	bltu	a4,a5,3308 <xTaskResumeFromISR+0x78>
    3300:	00100793          	li	a5,1
    3304:	00f12e23          	sw	a5,28(sp)
    3308:	01812783          	lw	a5,24(sp)
    330c:	00478793          	addi	a5,a5,4
    3310:	00078513          	mv	a0,a5
    3314:	f20fd0ef          	jal	ra,a34 <uxListRemove>
    3318:	01812783          	lw	a5,24(sp)
    331c:	02c7a703          	lw	a4,44(a5)
    3320:	0001d797          	auipc	a5,0x1d
    3324:	39078793          	addi	a5,a5,912 # 206b0 <uxTopReadyPriority>
    3328:	0007a783          	lw	a5,0(a5)
    332c:	00e7fc63          	bleu	a4,a5,3344 <xTaskResumeFromISR+0xb4>
    3330:	01812783          	lw	a5,24(sp)
    3334:	02c7a703          	lw	a4,44(a5)
    3338:	0001d797          	auipc	a5,0x1d
    333c:	37878793          	addi	a5,a5,888 # 206b0 <uxTopReadyPriority>
    3340:	00e7a023          	sw	a4,0(a5)
    3344:	01812783          	lw	a5,24(sp)
    3348:	02c7a703          	lw	a4,44(a5)
    334c:	00070793          	mv	a5,a4
    3350:	00279793          	slli	a5,a5,0x2
    3354:	00e787b3          	add	a5,a5,a4
    3358:	00279793          	slli	a5,a5,0x2
    335c:	0001d717          	auipc	a4,0x1d
    3360:	2a070713          	addi	a4,a4,672 # 205fc <pxReadyTasksLists>
    3364:	00e78733          	add	a4,a5,a4
    3368:	01812783          	lw	a5,24(sp)
    336c:	00478793          	addi	a5,a5,4
    3370:	00078593          	mv	a1,a5
    3374:	00070513          	mv	a0,a4
    3378:	d78fd0ef          	jal	ra,8f0 <vListInsertEnd>
    337c:	01c0006f          	j	3398 <xTaskResumeFromISR+0x108>
    3380:	01812783          	lw	a5,24(sp)
    3384:	01878793          	addi	a5,a5,24
    3388:	00078593          	mv	a1,a5
    338c:	0001d517          	auipc	a0,0x1d
    3390:	2dc50513          	addi	a0,a0,732 # 20668 <xPendingReadyList>
    3394:	d5cfd0ef          	jal	ra,8f0 <vListInsertEnd>
    3398:	01412783          	lw	a5,20(sp)
    339c:	00078513          	mv	a0,a5
    33a0:	becfd0ef          	jal	ra,78c <vPortClearInterruptMask>
    33a4:	01c12783          	lw	a5,28(sp)
    33a8:	00078513          	mv	a0,a5
    33ac:	02c12083          	lw	ra,44(sp)
    33b0:	03010113          	addi	sp,sp,48
    33b4:	00008067          	ret

000033b8 <vTaskStartScheduler>:
    33b8:	fe010113          	addi	sp,sp,-32
    33bc:	00112e23          	sw	ra,28(sp)
    33c0:	0001d797          	auipc	a5,0x1d
    33c4:	30c78793          	addi	a5,a5,780 # 206cc <xIdleTaskHandle>
    33c8:	00000713          	li	a4,0
    33cc:	00000693          	li	a3,0
    33d0:	40000613          	li	a2,1024
    33d4:	0001d597          	auipc	a1,0x1d
    33d8:	c2c58593          	addi	a1,a1,-980 # 20000 <__rodata_start>
    33dc:	00001517          	auipc	a0,0x1
    33e0:	f6c50513          	addi	a0,a0,-148 # 4348 <prvIdleTask>
    33e4:	950ff0ef          	jal	ra,2534 <xTaskCreate>
    33e8:	00a12623          	sw	a0,12(sp)
    33ec:	00c12703          	lw	a4,12(sp)
    33f0:	00100793          	li	a5,1
    33f4:	00f71663          	bne	a4,a5,3400 <vTaskStartScheduler+0x48>
    33f8:	394020ef          	jal	ra,578c <xTimerCreateTimerTask>
    33fc:	00a12623          	sw	a0,12(sp)
    3400:	00c12703          	lw	a4,12(sp)
    3404:	00100793          	li	a5,1
    3408:	02f71e63          	bne	a4,a5,3444 <vTaskStartScheduler+0x8c>
    340c:	30047073          	csrci	mstatus,8
    3410:	0001d797          	auipc	a5,0x1d
    3414:	2b878793          	addi	a5,a5,696 # 206c8 <xNextTaskUnblockTime>
    3418:	fff00713          	li	a4,-1
    341c:	00e7a023          	sw	a4,0(a5)
    3420:	0001d797          	auipc	a5,0x1d
    3424:	29478793          	addi	a5,a5,660 # 206b4 <xSchedulerRunning>
    3428:	00100713          	li	a4,1
    342c:	00e7a023          	sw	a4,0(a5)
    3430:	0001d797          	auipc	a5,0x1d
    3434:	27c78793          	addi	a5,a5,636 # 206ac <xTickCount>
    3438:	0007a023          	sw	zero,0(a5)
    343c:	fadfc0ef          	jal	ra,3e8 <xPortStartScheduler>
    3440:	0180006f          	j	3458 <vTaskStartScheduler+0xa0>
    3444:	00c12703          	lw	a4,12(sp)
    3448:	fff00793          	li	a5,-1
    344c:	00f71663          	bne	a4,a5,3458 <vTaskStartScheduler+0xa0>
    3450:	30047073          	csrci	mstatus,8
    3454:	0000006f          	j	3454 <vTaskStartScheduler+0x9c>
    3458:	00000013          	nop
    345c:	01c12083          	lw	ra,28(sp)
    3460:	02010113          	addi	sp,sp,32
    3464:	00008067          	ret

00003468 <vTaskEndScheduler>:
    3468:	ff010113          	addi	sp,sp,-16
    346c:	00112623          	sw	ra,12(sp)
    3470:	30047073          	csrci	mstatus,8
    3474:	0001d797          	auipc	a5,0x1d
    3478:	24078793          	addi	a5,a5,576 # 206b4 <xSchedulerRunning>
    347c:	0007a023          	sw	zero,0(a5)
    3480:	88cfd0ef          	jal	ra,50c <vPortEndScheduler>
    3484:	00000013          	nop
    3488:	00c12083          	lw	ra,12(sp)
    348c:	01010113          	addi	sp,sp,16
    3490:	00008067          	ret

00003494 <vTaskSuspendAll>:
    3494:	0001d797          	auipc	a5,0x1d
    3498:	23c78793          	addi	a5,a5,572 # 206d0 <uxSchedulerSuspended>
    349c:	0007a783          	lw	a5,0(a5)
    34a0:	00178713          	addi	a4,a5,1
    34a4:	0001d797          	auipc	a5,0x1d
    34a8:	22c78793          	addi	a5,a5,556 # 206d0 <uxSchedulerSuspended>
    34ac:	00e7a023          	sw	a4,0(a5)
    34b0:	00000013          	nop
    34b4:	00008067          	ret

000034b8 <xTaskResumeAll>:
    34b8:	fe010113          	addi	sp,sp,-32
    34bc:	00112e23          	sw	ra,28(sp)
    34c0:	00012623          	sw	zero,12(sp)
    34c4:	00012423          	sw	zero,8(sp)
    34c8:	0001d797          	auipc	a5,0x1d
    34cc:	20878793          	addi	a5,a5,520 # 206d0 <uxSchedulerSuspended>
    34d0:	0007a783          	lw	a5,0(a5)
    34d4:	00079663          	bnez	a5,34e0 <xTaskResumeAll+0x28>
    34d8:	30047073          	csrci	mstatus,8
    34dc:	0000006f          	j	34dc <xTaskResumeAll+0x24>
    34e0:	029010ef          	jal	ra,4d08 <vTaskEnterCritical>
    34e4:	0001d797          	auipc	a5,0x1d
    34e8:	1ec78793          	addi	a5,a5,492 # 206d0 <uxSchedulerSuspended>
    34ec:	0007a783          	lw	a5,0(a5)
    34f0:	fff78713          	addi	a4,a5,-1
    34f4:	0001d797          	auipc	a5,0x1d
    34f8:	1dc78793          	addi	a5,a5,476 # 206d0 <uxSchedulerSuspended>
    34fc:	00e7a023          	sw	a4,0(a5)
    3500:	0001d797          	auipc	a5,0x1d
    3504:	1d078793          	addi	a5,a5,464 # 206d0 <uxSchedulerSuspended>
    3508:	0007a783          	lw	a5,0(a5)
    350c:	16079463          	bnez	a5,3674 <xTaskResumeAll+0x1bc>
    3510:	0001d797          	auipc	a5,0x1d
    3514:	19878793          	addi	a5,a5,408 # 206a8 <uxCurrentNumberOfTasks>
    3518:	0007a783          	lw	a5,0(a5)
    351c:	14078c63          	beqz	a5,3674 <xTaskResumeAll+0x1bc>
    3520:	0c80006f          	j	35e8 <xTaskResumeAll+0x130>
    3524:	0001d797          	auipc	a5,0x1d
    3528:	14478793          	addi	a5,a5,324 # 20668 <xPendingReadyList>
    352c:	00c7a783          	lw	a5,12(a5)
    3530:	00c7a783          	lw	a5,12(a5)
    3534:	00f12623          	sw	a5,12(sp)
    3538:	00c12783          	lw	a5,12(sp)
    353c:	01878793          	addi	a5,a5,24
    3540:	00078513          	mv	a0,a5
    3544:	cf0fd0ef          	jal	ra,a34 <uxListRemove>
    3548:	00c12783          	lw	a5,12(sp)
    354c:	00478793          	addi	a5,a5,4
    3550:	00078513          	mv	a0,a5
    3554:	ce0fd0ef          	jal	ra,a34 <uxListRemove>
    3558:	00c12783          	lw	a5,12(sp)
    355c:	02c7a703          	lw	a4,44(a5)
    3560:	0001d797          	auipc	a5,0x1d
    3564:	15078793          	addi	a5,a5,336 # 206b0 <uxTopReadyPriority>
    3568:	0007a783          	lw	a5,0(a5)
    356c:	00e7fc63          	bleu	a4,a5,3584 <xTaskResumeAll+0xcc>
    3570:	00c12783          	lw	a5,12(sp)
    3574:	02c7a703          	lw	a4,44(a5)
    3578:	0001d797          	auipc	a5,0x1d
    357c:	13878793          	addi	a5,a5,312 # 206b0 <uxTopReadyPriority>
    3580:	00e7a023          	sw	a4,0(a5)
    3584:	00c12783          	lw	a5,12(sp)
    3588:	02c7a703          	lw	a4,44(a5)
    358c:	00070793          	mv	a5,a4
    3590:	00279793          	slli	a5,a5,0x2
    3594:	00e787b3          	add	a5,a5,a4
    3598:	00279793          	slli	a5,a5,0x2
    359c:	0001d717          	auipc	a4,0x1d
    35a0:	06070713          	addi	a4,a4,96 # 205fc <pxReadyTasksLists>
    35a4:	00e78733          	add	a4,a5,a4
    35a8:	00c12783          	lw	a5,12(sp)
    35ac:	00478793          	addi	a5,a5,4
    35b0:	00078593          	mv	a1,a5
    35b4:	00070513          	mv	a0,a4
    35b8:	b38fd0ef          	jal	ra,8f0 <vListInsertEnd>
    35bc:	00c12783          	lw	a5,12(sp)
    35c0:	02c7a703          	lw	a4,44(a5)
    35c4:	0001d797          	auipc	a5,0x1d
    35c8:	f8c78793          	addi	a5,a5,-116 # 20550 <pxCurrentTCB>
    35cc:	0007a783          	lw	a5,0(a5)
    35d0:	02c7a783          	lw	a5,44(a5)
    35d4:	00f76a63          	bltu	a4,a5,35e8 <xTaskResumeAll+0x130>
    35d8:	0001d797          	auipc	a5,0x1d
    35dc:	0e478793          	addi	a5,a5,228 # 206bc <xYieldPending>
    35e0:	00100713          	li	a4,1
    35e4:	00e7a023          	sw	a4,0(a5)
    35e8:	0001d797          	auipc	a5,0x1d
    35ec:	08078793          	addi	a5,a5,128 # 20668 <xPendingReadyList>
    35f0:	0007a783          	lw	a5,0(a5)
    35f4:	f20798e3          	bnez	a5,3524 <xTaskResumeAll+0x6c>
    35f8:	00c12783          	lw	a5,12(sp)
    35fc:	00078463          	beqz	a5,3604 <xTaskResumeAll+0x14c>
    3600:	1e8010ef          	jal	ra,47e8 <prvResetNextTaskUnblockTime>
    3604:	0001d797          	auipc	a5,0x1d
    3608:	0b478793          	addi	a5,a5,180 # 206b8 <uxPendedTicks>
    360c:	0007a783          	lw	a5,0(a5)
    3610:	00f12223          	sw	a5,4(sp)
    3614:	00412783          	lw	a5,4(sp)
    3618:	04078063          	beqz	a5,3658 <xTaskResumeAll+0x1a0>
    361c:	33c000ef          	jal	ra,3958 <xTaskIncrementTick>
    3620:	00050793          	mv	a5,a0
    3624:	00078a63          	beqz	a5,3638 <xTaskResumeAll+0x180>
    3628:	0001d797          	auipc	a5,0x1d
    362c:	09478793          	addi	a5,a5,148 # 206bc <xYieldPending>
    3630:	00100713          	li	a4,1
    3634:	00e7a023          	sw	a4,0(a5)
    3638:	00412783          	lw	a5,4(sp)
    363c:	fff78793          	addi	a5,a5,-1
    3640:	00f12223          	sw	a5,4(sp)
    3644:	00412783          	lw	a5,4(sp)
    3648:	fc079ae3          	bnez	a5,361c <xTaskResumeAll+0x164>
    364c:	0001d797          	auipc	a5,0x1d
    3650:	06c78793          	addi	a5,a5,108 # 206b8 <uxPendedTicks>
    3654:	0007a023          	sw	zero,0(a5)
    3658:	0001d797          	auipc	a5,0x1d
    365c:	06478793          	addi	a5,a5,100 # 206bc <xYieldPending>
    3660:	0007a783          	lw	a5,0(a5)
    3664:	00078863          	beqz	a5,3674 <xTaskResumeAll+0x1bc>
    3668:	00100793          	li	a5,1
    366c:	00f12423          	sw	a5,8(sp)
    3670:	f25fc0ef          	jal	ra,594 <vPortYield>
    3674:	6d4010ef          	jal	ra,4d48 <vTaskExitCritical>
    3678:	00812783          	lw	a5,8(sp)
    367c:	00078513          	mv	a0,a5
    3680:	01c12083          	lw	ra,28(sp)
    3684:	02010113          	addi	sp,sp,32
    3688:	00008067          	ret

0000368c <xTaskGetTickCount>:
    368c:	fe010113          	addi	sp,sp,-32
    3690:	00112e23          	sw	ra,28(sp)
    3694:	674010ef          	jal	ra,4d08 <vTaskEnterCritical>
    3698:	0001d797          	auipc	a5,0x1d
    369c:	01478793          	addi	a5,a5,20 # 206ac <xTickCount>
    36a0:	0007a783          	lw	a5,0(a5)
    36a4:	00f12623          	sw	a5,12(sp)
    36a8:	6a0010ef          	jal	ra,4d48 <vTaskExitCritical>
    36ac:	00c12783          	lw	a5,12(sp)
    36b0:	00078513          	mv	a0,a5
    36b4:	01c12083          	lw	ra,28(sp)
    36b8:	02010113          	addi	sp,sp,32
    36bc:	00008067          	ret

000036c0 <xTaskGetTickCountFromISR>:
    36c0:	fe010113          	addi	sp,sp,-32
    36c4:	00112e23          	sw	ra,28(sp)
    36c8:	8e0fd0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    36cc:	00050793          	mv	a5,a0
    36d0:	00f12623          	sw	a5,12(sp)
    36d4:	0001d797          	auipc	a5,0x1d
    36d8:	fd878793          	addi	a5,a5,-40 # 206ac <xTickCount>
    36dc:	0007a783          	lw	a5,0(a5)
    36e0:	00f12423          	sw	a5,8(sp)
    36e4:	00c12783          	lw	a5,12(sp)
    36e8:	00078513          	mv	a0,a5
    36ec:	8a0fd0ef          	jal	ra,78c <vPortClearInterruptMask>
    36f0:	00812783          	lw	a5,8(sp)
    36f4:	00078513          	mv	a0,a5
    36f8:	01c12083          	lw	ra,28(sp)
    36fc:	02010113          	addi	sp,sp,32
    3700:	00008067          	ret

00003704 <uxTaskGetNumberOfTasks>:
    3704:	0001d797          	auipc	a5,0x1d
    3708:	fa478793          	addi	a5,a5,-92 # 206a8 <uxCurrentNumberOfTasks>
    370c:	0007a783          	lw	a5,0(a5)
    3710:	00078513          	mv	a0,a5
    3714:	00008067          	ret

00003718 <pcTaskGetName>:
    3718:	fe010113          	addi	sp,sp,-32
    371c:	00a12623          	sw	a0,12(sp)
    3720:	00c12783          	lw	a5,12(sp)
    3724:	00079a63          	bnez	a5,3738 <pcTaskGetName+0x20>
    3728:	0001d797          	auipc	a5,0x1d
    372c:	e2878793          	addi	a5,a5,-472 # 20550 <pxCurrentTCB>
    3730:	0007a783          	lw	a5,0(a5)
    3734:	0080006f          	j	373c <pcTaskGetName+0x24>
    3738:	00c12783          	lw	a5,12(sp)
    373c:	00f12e23          	sw	a5,28(sp)
    3740:	01c12783          	lw	a5,28(sp)
    3744:	00079663          	bnez	a5,3750 <pcTaskGetName+0x38>
    3748:	30047073          	csrci	mstatus,8
    374c:	0000006f          	j	374c <pcTaskGetName+0x34>
    3750:	01c12783          	lw	a5,28(sp)
    3754:	03478793          	addi	a5,a5,52
    3758:	00078513          	mv	a0,a5
    375c:	02010113          	addi	sp,sp,32
    3760:	00008067          	ret

00003764 <uxTaskGetSystemState>:
    3764:	fd010113          	addi	sp,sp,-48
    3768:	02112623          	sw	ra,44(sp)
    376c:	00a12623          	sw	a0,12(sp)
    3770:	00b12423          	sw	a1,8(sp)
    3774:	00c12223          	sw	a2,4(sp)
    3778:	00012e23          	sw	zero,28(sp)
    377c:	00500793          	li	a5,5
    3780:	00f12c23          	sw	a5,24(sp)
    3784:	d11ff0ef          	jal	ra,3494 <vTaskSuspendAll>
    3788:	0001d797          	auipc	a5,0x1d
    378c:	f2078793          	addi	a5,a5,-224 # 206a8 <uxCurrentNumberOfTasks>
    3790:	0007a783          	lw	a5,0(a5)
    3794:	00812703          	lw	a4,8(sp)
    3798:	1af76463          	bltu	a4,a5,3940 <uxTaskGetSystemState+0x1dc>
    379c:	01812783          	lw	a5,24(sp)
    37a0:	fff78793          	addi	a5,a5,-1
    37a4:	00f12c23          	sw	a5,24(sp)
    37a8:	01c12703          	lw	a4,28(sp)
    37ac:	00070793          	mv	a5,a4
    37b0:	00379793          	slli	a5,a5,0x3
    37b4:	00e787b3          	add	a5,a5,a4
    37b8:	00279793          	slli	a5,a5,0x2
    37bc:	00078713          	mv	a4,a5
    37c0:	00c12783          	lw	a5,12(sp)
    37c4:	00e786b3          	add	a3,a5,a4
    37c8:	01812703          	lw	a4,24(sp)
    37cc:	00070793          	mv	a5,a4
    37d0:	00279793          	slli	a5,a5,0x2
    37d4:	00e787b3          	add	a5,a5,a4
    37d8:	00279793          	slli	a5,a5,0x2
    37dc:	0001d717          	auipc	a4,0x1d
    37e0:	e2070713          	addi	a4,a4,-480 # 205fc <pxReadyTasksLists>
    37e4:	00e787b3          	add	a5,a5,a4
    37e8:	00100613          	li	a2,1
    37ec:	00078593          	mv	a1,a5
    37f0:	00068513          	mv	a0,a3
    37f4:	639000ef          	jal	ra,462c <prvListTasksWithinSingleList>
    37f8:	00050713          	mv	a4,a0
    37fc:	01c12783          	lw	a5,28(sp)
    3800:	00e787b3          	add	a5,a5,a4
    3804:	00f12e23          	sw	a5,28(sp)
    3808:	01812783          	lw	a5,24(sp)
    380c:	f80798e3          	bnez	a5,379c <uxTaskGetSystemState+0x38>
    3810:	01c12703          	lw	a4,28(sp)
    3814:	00070793          	mv	a5,a4
    3818:	00379793          	slli	a5,a5,0x3
    381c:	00e787b3          	add	a5,a5,a4
    3820:	00279793          	slli	a5,a5,0x2
    3824:	00078713          	mv	a4,a5
    3828:	00c12783          	lw	a5,12(sp)
    382c:	00e78733          	add	a4,a5,a4
    3830:	0001d797          	auipc	a5,0x1d
    3834:	e3078793          	addi	a5,a5,-464 # 20660 <pxDelayedTaskList>
    3838:	0007a783          	lw	a5,0(a5)
    383c:	00200613          	li	a2,2
    3840:	00078593          	mv	a1,a5
    3844:	00070513          	mv	a0,a4
    3848:	5e5000ef          	jal	ra,462c <prvListTasksWithinSingleList>
    384c:	00050713          	mv	a4,a0
    3850:	01c12783          	lw	a5,28(sp)
    3854:	00e787b3          	add	a5,a5,a4
    3858:	00f12e23          	sw	a5,28(sp)
    385c:	01c12703          	lw	a4,28(sp)
    3860:	00070793          	mv	a5,a4
    3864:	00379793          	slli	a5,a5,0x3
    3868:	00e787b3          	add	a5,a5,a4
    386c:	00279793          	slli	a5,a5,0x2
    3870:	00078713          	mv	a4,a5
    3874:	00c12783          	lw	a5,12(sp)
    3878:	00e78733          	add	a4,a5,a4
    387c:	0001d797          	auipc	a5,0x1d
    3880:	de878793          	addi	a5,a5,-536 # 20664 <pxOverflowDelayedTaskList>
    3884:	0007a783          	lw	a5,0(a5)
    3888:	00200613          	li	a2,2
    388c:	00078593          	mv	a1,a5
    3890:	00070513          	mv	a0,a4
    3894:	599000ef          	jal	ra,462c <prvListTasksWithinSingleList>
    3898:	00050713          	mv	a4,a0
    389c:	01c12783          	lw	a5,28(sp)
    38a0:	00e787b3          	add	a5,a5,a4
    38a4:	00f12e23          	sw	a5,28(sp)
    38a8:	01c12703          	lw	a4,28(sp)
    38ac:	00070793          	mv	a5,a4
    38b0:	00379793          	slli	a5,a5,0x3
    38b4:	00e787b3          	add	a5,a5,a4
    38b8:	00279793          	slli	a5,a5,0x2
    38bc:	00078713          	mv	a4,a5
    38c0:	00c12783          	lw	a5,12(sp)
    38c4:	00e787b3          	add	a5,a5,a4
    38c8:	00400613          	li	a2,4
    38cc:	0001d597          	auipc	a1,0x1d
    38d0:	db058593          	addi	a1,a1,-592 # 2067c <xTasksWaitingTermination>
    38d4:	00078513          	mv	a0,a5
    38d8:	555000ef          	jal	ra,462c <prvListTasksWithinSingleList>
    38dc:	00050713          	mv	a4,a0
    38e0:	01c12783          	lw	a5,28(sp)
    38e4:	00e787b3          	add	a5,a5,a4
    38e8:	00f12e23          	sw	a5,28(sp)
    38ec:	01c12703          	lw	a4,28(sp)
    38f0:	00070793          	mv	a5,a4
    38f4:	00379793          	slli	a5,a5,0x3
    38f8:	00e787b3          	add	a5,a5,a4
    38fc:	00279793          	slli	a5,a5,0x2
    3900:	00078713          	mv	a4,a5
    3904:	00c12783          	lw	a5,12(sp)
    3908:	00e787b3          	add	a5,a5,a4
    390c:	00300613          	li	a2,3
    3910:	0001d597          	auipc	a1,0x1d
    3914:	d8458593          	addi	a1,a1,-636 # 20694 <xSuspendedTaskList>
    3918:	00078513          	mv	a0,a5
    391c:	511000ef          	jal	ra,462c <prvListTasksWithinSingleList>
    3920:	00050713          	mv	a4,a0
    3924:	01c12783          	lw	a5,28(sp)
    3928:	00e787b3          	add	a5,a5,a4
    392c:	00f12e23          	sw	a5,28(sp)
    3930:	00412783          	lw	a5,4(sp)
    3934:	00078663          	beqz	a5,3940 <uxTaskGetSystemState+0x1dc>
    3938:	00412783          	lw	a5,4(sp)
    393c:	0007a023          	sw	zero,0(a5)
    3940:	b79ff0ef          	jal	ra,34b8 <xTaskResumeAll>
    3944:	01c12783          	lw	a5,28(sp)
    3948:	00078513          	mv	a0,a5
    394c:	02c12083          	lw	ra,44(sp)
    3950:	03010113          	addi	sp,sp,48
    3954:	00008067          	ret

00003958 <xTaskIncrementTick>:
    3958:	fd010113          	addi	sp,sp,-48
    395c:	02112623          	sw	ra,44(sp)
    3960:	00012e23          	sw	zero,28(sp)
    3964:	0001d797          	auipc	a5,0x1d
    3968:	d6c78793          	addi	a5,a5,-660 # 206d0 <uxSchedulerSuspended>
    396c:	0007a783          	lw	a5,0(a5)
    3970:	22079063          	bnez	a5,3b90 <xTaskIncrementTick+0x238>
    3974:	0001d797          	auipc	a5,0x1d
    3978:	d3878793          	addi	a5,a5,-712 # 206ac <xTickCount>
    397c:	0007a783          	lw	a5,0(a5)
    3980:	00178793          	addi	a5,a5,1
    3984:	00f12c23          	sw	a5,24(sp)
    3988:	0001d797          	auipc	a5,0x1d
    398c:	d2478793          	addi	a5,a5,-732 # 206ac <xTickCount>
    3990:	01812703          	lw	a4,24(sp)
    3994:	00e7a023          	sw	a4,0(a5)
    3998:	01812783          	lw	a5,24(sp)
    399c:	06079c63          	bnez	a5,3a14 <xTaskIncrementTick+0xbc>
    39a0:	0001d797          	auipc	a5,0x1d
    39a4:	cc078793          	addi	a5,a5,-832 # 20660 <pxDelayedTaskList>
    39a8:	0007a783          	lw	a5,0(a5)
    39ac:	0007a783          	lw	a5,0(a5)
    39b0:	00078663          	beqz	a5,39bc <xTaskIncrementTick+0x64>
    39b4:	30047073          	csrci	mstatus,8
    39b8:	0000006f          	j	39b8 <xTaskIncrementTick+0x60>
    39bc:	0001d797          	auipc	a5,0x1d
    39c0:	ca478793          	addi	a5,a5,-860 # 20660 <pxDelayedTaskList>
    39c4:	0007a783          	lw	a5,0(a5)
    39c8:	00f12a23          	sw	a5,20(sp)
    39cc:	0001d797          	auipc	a5,0x1d
    39d0:	c9878793          	addi	a5,a5,-872 # 20664 <pxOverflowDelayedTaskList>
    39d4:	0007a703          	lw	a4,0(a5)
    39d8:	0001d797          	auipc	a5,0x1d
    39dc:	c8878793          	addi	a5,a5,-888 # 20660 <pxDelayedTaskList>
    39e0:	00e7a023          	sw	a4,0(a5)
    39e4:	0001d797          	auipc	a5,0x1d
    39e8:	c8078793          	addi	a5,a5,-896 # 20664 <pxOverflowDelayedTaskList>
    39ec:	01412703          	lw	a4,20(sp)
    39f0:	00e7a023          	sw	a4,0(a5)
    39f4:	0001d797          	auipc	a5,0x1d
    39f8:	ccc78793          	addi	a5,a5,-820 # 206c0 <xNumOfOverflows>
    39fc:	0007a783          	lw	a5,0(a5)
    3a00:	00178713          	addi	a4,a5,1
    3a04:	0001d797          	auipc	a5,0x1d
    3a08:	cbc78793          	addi	a5,a5,-836 # 206c0 <xNumOfOverflows>
    3a0c:	00e7a023          	sw	a4,0(a5)
    3a10:	5d9000ef          	jal	ra,47e8 <prvResetNextTaskUnblockTime>
    3a14:	0001d797          	auipc	a5,0x1d
    3a18:	cb478793          	addi	a5,a5,-844 # 206c8 <xNextTaskUnblockTime>
    3a1c:	0007a783          	lw	a5,0(a5)
    3a20:	01812703          	lw	a4,24(sp)
    3a24:	12f76463          	bltu	a4,a5,3b4c <xTaskIncrementTick+0x1f4>
    3a28:	0001d797          	auipc	a5,0x1d
    3a2c:	c3878793          	addi	a5,a5,-968 # 20660 <pxDelayedTaskList>
    3a30:	0007a783          	lw	a5,0(a5)
    3a34:	0007a783          	lw	a5,0(a5)
    3a38:	00079c63          	bnez	a5,3a50 <xTaskIncrementTick+0xf8>
    3a3c:	0001d797          	auipc	a5,0x1d
    3a40:	c8c78793          	addi	a5,a5,-884 # 206c8 <xNextTaskUnblockTime>
    3a44:	fff00713          	li	a4,-1
    3a48:	00e7a023          	sw	a4,0(a5)
    3a4c:	1000006f          	j	3b4c <xTaskIncrementTick+0x1f4>
    3a50:	0001d797          	auipc	a5,0x1d
    3a54:	c1078793          	addi	a5,a5,-1008 # 20660 <pxDelayedTaskList>
    3a58:	0007a783          	lw	a5,0(a5)
    3a5c:	00c7a783          	lw	a5,12(a5)
    3a60:	00c7a783          	lw	a5,12(a5)
    3a64:	00f12823          	sw	a5,16(sp)
    3a68:	01012783          	lw	a5,16(sp)
    3a6c:	0047a783          	lw	a5,4(a5)
    3a70:	00f12623          	sw	a5,12(sp)
    3a74:	01812703          	lw	a4,24(sp)
    3a78:	00c12783          	lw	a5,12(sp)
    3a7c:	00f77c63          	bleu	a5,a4,3a94 <xTaskIncrementTick+0x13c>
    3a80:	0001d797          	auipc	a5,0x1d
    3a84:	c4878793          	addi	a5,a5,-952 # 206c8 <xNextTaskUnblockTime>
    3a88:	00c12703          	lw	a4,12(sp)
    3a8c:	00e7a023          	sw	a4,0(a5)
    3a90:	0bc0006f          	j	3b4c <xTaskIncrementTick+0x1f4>
    3a94:	01012783          	lw	a5,16(sp)
    3a98:	00478793          	addi	a5,a5,4
    3a9c:	00078513          	mv	a0,a5
    3aa0:	f95fc0ef          	jal	ra,a34 <uxListRemove>
    3aa4:	01012783          	lw	a5,16(sp)
    3aa8:	0287a783          	lw	a5,40(a5)
    3aac:	00078a63          	beqz	a5,3ac0 <xTaskIncrementTick+0x168>
    3ab0:	01012783          	lw	a5,16(sp)
    3ab4:	01878793          	addi	a5,a5,24
    3ab8:	00078513          	mv	a0,a5
    3abc:	f79fc0ef          	jal	ra,a34 <uxListRemove>
    3ac0:	01012783          	lw	a5,16(sp)
    3ac4:	02c7a703          	lw	a4,44(a5)
    3ac8:	0001d797          	auipc	a5,0x1d
    3acc:	be878793          	addi	a5,a5,-1048 # 206b0 <uxTopReadyPriority>
    3ad0:	0007a783          	lw	a5,0(a5)
    3ad4:	00e7fc63          	bleu	a4,a5,3aec <xTaskIncrementTick+0x194>
    3ad8:	01012783          	lw	a5,16(sp)
    3adc:	02c7a703          	lw	a4,44(a5)
    3ae0:	0001d797          	auipc	a5,0x1d
    3ae4:	bd078793          	addi	a5,a5,-1072 # 206b0 <uxTopReadyPriority>
    3ae8:	00e7a023          	sw	a4,0(a5)
    3aec:	01012783          	lw	a5,16(sp)
    3af0:	02c7a703          	lw	a4,44(a5)
    3af4:	00070793          	mv	a5,a4
    3af8:	00279793          	slli	a5,a5,0x2
    3afc:	00e787b3          	add	a5,a5,a4
    3b00:	00279793          	slli	a5,a5,0x2
    3b04:	0001d717          	auipc	a4,0x1d
    3b08:	af870713          	addi	a4,a4,-1288 # 205fc <pxReadyTasksLists>
    3b0c:	00e78733          	add	a4,a5,a4
    3b10:	01012783          	lw	a5,16(sp)
    3b14:	00478793          	addi	a5,a5,4
    3b18:	00078593          	mv	a1,a5
    3b1c:	00070513          	mv	a0,a4
    3b20:	dd1fc0ef          	jal	ra,8f0 <vListInsertEnd>
    3b24:	01012783          	lw	a5,16(sp)
    3b28:	02c7a703          	lw	a4,44(a5)
    3b2c:	0001d797          	auipc	a5,0x1d
    3b30:	a2478793          	addi	a5,a5,-1500 # 20550 <pxCurrentTCB>
    3b34:	0007a783          	lw	a5,0(a5)
    3b38:	02c7a783          	lw	a5,44(a5)
    3b3c:	eef766e3          	bltu	a4,a5,3a28 <xTaskIncrementTick+0xd0>
    3b40:	00100793          	li	a5,1
    3b44:	00f12e23          	sw	a5,28(sp)
    3b48:	ee1ff06f          	j	3a28 <xTaskIncrementTick+0xd0>
    3b4c:	0001d797          	auipc	a5,0x1d
    3b50:	a0478793          	addi	a5,a5,-1532 # 20550 <pxCurrentTCB>
    3b54:	0007a783          	lw	a5,0(a5)
    3b58:	02c7a703          	lw	a4,44(a5)
    3b5c:	0001d697          	auipc	a3,0x1d
    3b60:	aa068693          	addi	a3,a3,-1376 # 205fc <pxReadyTasksLists>
    3b64:	00070793          	mv	a5,a4
    3b68:	00279793          	slli	a5,a5,0x2
    3b6c:	00e787b3          	add	a5,a5,a4
    3b70:	00279793          	slli	a5,a5,0x2
    3b74:	00f687b3          	add	a5,a3,a5
    3b78:	0007a703          	lw	a4,0(a5)
    3b7c:	00100793          	li	a5,1
    3b80:	02e7f663          	bleu	a4,a5,3bac <xTaskIncrementTick+0x254>
    3b84:	00100793          	li	a5,1
    3b88:	00f12e23          	sw	a5,28(sp)
    3b8c:	0200006f          	j	3bac <xTaskIncrementTick+0x254>
    3b90:	0001d797          	auipc	a5,0x1d
    3b94:	b2878793          	addi	a5,a5,-1240 # 206b8 <uxPendedTicks>
    3b98:	0007a783          	lw	a5,0(a5)
    3b9c:	00178713          	addi	a4,a5,1
    3ba0:	0001d797          	auipc	a5,0x1d
    3ba4:	b1878793          	addi	a5,a5,-1256 # 206b8 <uxPendedTicks>
    3ba8:	00e7a023          	sw	a4,0(a5)
    3bac:	0001d797          	auipc	a5,0x1d
    3bb0:	b1078793          	addi	a5,a5,-1264 # 206bc <xYieldPending>
    3bb4:	0007a783          	lw	a5,0(a5)
    3bb8:	00078663          	beqz	a5,3bc4 <xTaskIncrementTick+0x26c>
    3bbc:	00100793          	li	a5,1
    3bc0:	00f12e23          	sw	a5,28(sp)
    3bc4:	01c12783          	lw	a5,28(sp)
    3bc8:	00078513          	mv	a0,a5
    3bcc:	02c12083          	lw	ra,44(sp)
    3bd0:	03010113          	addi	sp,sp,48
    3bd4:	00008067          	ret

00003bd8 <vTaskSwitchContext>:
    3bd8:	fe010113          	addi	sp,sp,-32
    3bdc:	00112e23          	sw	ra,28(sp)
    3be0:	0001d797          	auipc	a5,0x1d
    3be4:	af078793          	addi	a5,a5,-1296 # 206d0 <uxSchedulerSuspended>
    3be8:	0007a783          	lw	a5,0(a5)
    3bec:	00078c63          	beqz	a5,3c04 <vTaskSwitchContext+0x2c>
    3bf0:	0001d797          	auipc	a5,0x1d
    3bf4:	acc78793          	addi	a5,a5,-1332 # 206bc <xYieldPending>
    3bf8:	00100713          	li	a4,1
    3bfc:	00e7a023          	sw	a4,0(a5)
    3c00:	1840006f          	j	3d84 <vTaskSwitchContext+0x1ac>
    3c04:	0001d797          	auipc	a5,0x1d
    3c08:	ab878793          	addi	a5,a5,-1352 # 206bc <xYieldPending>
    3c0c:	0007a023          	sw	zero,0(a5)
    3c10:	0001d797          	auipc	a5,0x1d
    3c14:	94078793          	addi	a5,a5,-1728 # 20550 <pxCurrentTCB>
    3c18:	0007a783          	lw	a5,0(a5)
    3c1c:	0307a783          	lw	a5,48(a5)
    3c20:	00f12423          	sw	a5,8(sp)
    3c24:	a5a5a7b7          	lui	a5,0xa5a5a
    3c28:	5a578793          	addi	a5,a5,1445 # a5a5a5a5 <__stack+0xa5a1ec9d>
    3c2c:	00f12223          	sw	a5,4(sp)
    3c30:	00812783          	lw	a5,8(sp)
    3c34:	0007a783          	lw	a5,0(a5)
    3c38:	00412703          	lw	a4,4(sp)
    3c3c:	04f71063          	bne	a4,a5,3c7c <vTaskSwitchContext+0xa4>
    3c40:	00812783          	lw	a5,8(sp)
    3c44:	00478793          	addi	a5,a5,4
    3c48:	0007a783          	lw	a5,0(a5)
    3c4c:	00412703          	lw	a4,4(sp)
    3c50:	02f71663          	bne	a4,a5,3c7c <vTaskSwitchContext+0xa4>
    3c54:	00812783          	lw	a5,8(sp)
    3c58:	00878793          	addi	a5,a5,8
    3c5c:	0007a783          	lw	a5,0(a5)
    3c60:	00412703          	lw	a4,4(sp)
    3c64:	00f71c63          	bne	a4,a5,3c7c <vTaskSwitchContext+0xa4>
    3c68:	00812783          	lw	a5,8(sp)
    3c6c:	00c78793          	addi	a5,a5,12
    3c70:	0007a783          	lw	a5,0(a5)
    3c74:	00412703          	lw	a4,4(sp)
    3c78:	02f70663          	beq	a4,a5,3ca4 <vTaskSwitchContext+0xcc>
    3c7c:	0001d797          	auipc	a5,0x1d
    3c80:	8d478793          	addi	a5,a5,-1836 # 20550 <pxCurrentTCB>
    3c84:	0007a703          	lw	a4,0(a5)
    3c88:	0001d797          	auipc	a5,0x1d
    3c8c:	8c878793          	addi	a5,a5,-1848 # 20550 <pxCurrentTCB>
    3c90:	0007a783          	lw	a5,0(a5)
    3c94:	03478793          	addi	a5,a5,52
    3c98:	00078593          	mv	a1,a5
    3c9c:	00070513          	mv	a0,a4
    3ca0:	3ec040ef          	jal	ra,808c <vApplicationStackOverflowHook>
    3ca4:	0001d797          	auipc	a5,0x1d
    3ca8:	a0c78793          	addi	a5,a5,-1524 # 206b0 <uxTopReadyPriority>
    3cac:	0007a783          	lw	a5,0(a5)
    3cb0:	00f12623          	sw	a5,12(sp)
    3cb4:	0200006f          	j	3cd4 <vTaskSwitchContext+0xfc>
    3cb8:	00c12783          	lw	a5,12(sp)
    3cbc:	00079663          	bnez	a5,3cc8 <vTaskSwitchContext+0xf0>
    3cc0:	30047073          	csrci	mstatus,8
    3cc4:	0000006f          	j	3cc4 <vTaskSwitchContext+0xec>
    3cc8:	00c12783          	lw	a5,12(sp)
    3ccc:	fff78793          	addi	a5,a5,-1
    3cd0:	00f12623          	sw	a5,12(sp)
    3cd4:	0001d697          	auipc	a3,0x1d
    3cd8:	92868693          	addi	a3,a3,-1752 # 205fc <pxReadyTasksLists>
    3cdc:	00c12703          	lw	a4,12(sp)
    3ce0:	00070793          	mv	a5,a4
    3ce4:	00279793          	slli	a5,a5,0x2
    3ce8:	00e787b3          	add	a5,a5,a4
    3cec:	00279793          	slli	a5,a5,0x2
    3cf0:	00f687b3          	add	a5,a3,a5
    3cf4:	0007a783          	lw	a5,0(a5)
    3cf8:	fc0780e3          	beqz	a5,3cb8 <vTaskSwitchContext+0xe0>
    3cfc:	00c12703          	lw	a4,12(sp)
    3d00:	00070793          	mv	a5,a4
    3d04:	00279793          	slli	a5,a5,0x2
    3d08:	00e787b3          	add	a5,a5,a4
    3d0c:	00279793          	slli	a5,a5,0x2
    3d10:	0001d717          	auipc	a4,0x1d
    3d14:	8ec70713          	addi	a4,a4,-1812 # 205fc <pxReadyTasksLists>
    3d18:	00e787b3          	add	a5,a5,a4
    3d1c:	00f12023          	sw	a5,0(sp)
    3d20:	00012783          	lw	a5,0(sp)
    3d24:	0047a783          	lw	a5,4(a5)
    3d28:	0047a703          	lw	a4,4(a5)
    3d2c:	00012783          	lw	a5,0(sp)
    3d30:	00e7a223          	sw	a4,4(a5)
    3d34:	00012783          	lw	a5,0(sp)
    3d38:	0047a703          	lw	a4,4(a5)
    3d3c:	00012783          	lw	a5,0(sp)
    3d40:	00878793          	addi	a5,a5,8
    3d44:	00f71c63          	bne	a4,a5,3d5c <vTaskSwitchContext+0x184>
    3d48:	00012783          	lw	a5,0(sp)
    3d4c:	0047a783          	lw	a5,4(a5)
    3d50:	0047a703          	lw	a4,4(a5)
    3d54:	00012783          	lw	a5,0(sp)
    3d58:	00e7a223          	sw	a4,4(a5)
    3d5c:	00012783          	lw	a5,0(sp)
    3d60:	0047a783          	lw	a5,4(a5)
    3d64:	00c7a703          	lw	a4,12(a5)
    3d68:	0001c797          	auipc	a5,0x1c
    3d6c:	7e878793          	addi	a5,a5,2024 # 20550 <pxCurrentTCB>
    3d70:	00e7a023          	sw	a4,0(a5)
    3d74:	0001d797          	auipc	a5,0x1d
    3d78:	93c78793          	addi	a5,a5,-1732 # 206b0 <uxTopReadyPriority>
    3d7c:	00c12703          	lw	a4,12(sp)
    3d80:	00e7a023          	sw	a4,0(a5)
    3d84:	00000013          	nop
    3d88:	01c12083          	lw	ra,28(sp)
    3d8c:	02010113          	addi	sp,sp,32
    3d90:	00008067          	ret

00003d94 <vTaskPlaceOnEventList>:
    3d94:	fe010113          	addi	sp,sp,-32
    3d98:	00112e23          	sw	ra,28(sp)
    3d9c:	00a12623          	sw	a0,12(sp)
    3da0:	00b12423          	sw	a1,8(sp)
    3da4:	00c12783          	lw	a5,12(sp)
    3da8:	00079663          	bnez	a5,3db4 <vTaskPlaceOnEventList+0x20>
    3dac:	30047073          	csrci	mstatus,8
    3db0:	0000006f          	j	3db0 <vTaskPlaceOnEventList+0x1c>
    3db4:	0001c797          	auipc	a5,0x1c
    3db8:	79c78793          	addi	a5,a5,1948 # 20550 <pxCurrentTCB>
    3dbc:	0007a783          	lw	a5,0(a5)
    3dc0:	01878793          	addi	a5,a5,24
    3dc4:	00078593          	mv	a1,a5
    3dc8:	00c12503          	lw	a0,12(sp)
    3dcc:	ba1fc0ef          	jal	ra,96c <vListInsert>
    3dd0:	00100593          	li	a1,1
    3dd4:	00812503          	lw	a0,8(sp)
    3dd8:	08d010ef          	jal	ra,5664 <prvAddCurrentTaskToDelayedList>
    3ddc:	00000013          	nop
    3de0:	01c12083          	lw	ra,28(sp)
    3de4:	02010113          	addi	sp,sp,32
    3de8:	00008067          	ret

00003dec <vTaskPlaceOnUnorderedEventList>:
    3dec:	fe010113          	addi	sp,sp,-32
    3df0:	00112e23          	sw	ra,28(sp)
    3df4:	00a12623          	sw	a0,12(sp)
    3df8:	00b12423          	sw	a1,8(sp)
    3dfc:	00c12223          	sw	a2,4(sp)
    3e00:	00c12783          	lw	a5,12(sp)
    3e04:	00079663          	bnez	a5,3e10 <vTaskPlaceOnUnorderedEventList+0x24>
    3e08:	30047073          	csrci	mstatus,8
    3e0c:	0000006f          	j	3e0c <vTaskPlaceOnUnorderedEventList+0x20>
    3e10:	0001d797          	auipc	a5,0x1d
    3e14:	8c078793          	addi	a5,a5,-1856 # 206d0 <uxSchedulerSuspended>
    3e18:	0007a783          	lw	a5,0(a5)
    3e1c:	00079663          	bnez	a5,3e28 <vTaskPlaceOnUnorderedEventList+0x3c>
    3e20:	30047073          	csrci	mstatus,8
    3e24:	0000006f          	j	3e24 <vTaskPlaceOnUnorderedEventList+0x38>
    3e28:	0001c797          	auipc	a5,0x1c
    3e2c:	72878793          	addi	a5,a5,1832 # 20550 <pxCurrentTCB>
    3e30:	0007a783          	lw	a5,0(a5)
    3e34:	00812683          	lw	a3,8(sp)
    3e38:	80000737          	lui	a4,0x80000
    3e3c:	00e6e733          	or	a4,a3,a4
    3e40:	00e7ac23          	sw	a4,24(a5)
    3e44:	0001c797          	auipc	a5,0x1c
    3e48:	70c78793          	addi	a5,a5,1804 # 20550 <pxCurrentTCB>
    3e4c:	0007a783          	lw	a5,0(a5)
    3e50:	01878793          	addi	a5,a5,24
    3e54:	00078593          	mv	a1,a5
    3e58:	00c12503          	lw	a0,12(sp)
    3e5c:	a95fc0ef          	jal	ra,8f0 <vListInsertEnd>
    3e60:	00100593          	li	a1,1
    3e64:	00412503          	lw	a0,4(sp)
    3e68:	7fc010ef          	jal	ra,5664 <prvAddCurrentTaskToDelayedList>
    3e6c:	00000013          	nop
    3e70:	01c12083          	lw	ra,28(sp)
    3e74:	02010113          	addi	sp,sp,32
    3e78:	00008067          	ret

00003e7c <vTaskPlaceOnEventListRestricted>:
    3e7c:	fe010113          	addi	sp,sp,-32
    3e80:	00112e23          	sw	ra,28(sp)
    3e84:	00a12623          	sw	a0,12(sp)
    3e88:	00b12423          	sw	a1,8(sp)
    3e8c:	00c12223          	sw	a2,4(sp)
    3e90:	00c12783          	lw	a5,12(sp)
    3e94:	00079663          	bnez	a5,3ea0 <vTaskPlaceOnEventListRestricted+0x24>
    3e98:	30047073          	csrci	mstatus,8
    3e9c:	0000006f          	j	3e9c <vTaskPlaceOnEventListRestricted+0x20>
    3ea0:	0001c797          	auipc	a5,0x1c
    3ea4:	6b078793          	addi	a5,a5,1712 # 20550 <pxCurrentTCB>
    3ea8:	0007a783          	lw	a5,0(a5)
    3eac:	01878793          	addi	a5,a5,24
    3eb0:	00078593          	mv	a1,a5
    3eb4:	00c12503          	lw	a0,12(sp)
    3eb8:	a39fc0ef          	jal	ra,8f0 <vListInsertEnd>
    3ebc:	00412783          	lw	a5,4(sp)
    3ec0:	00078663          	beqz	a5,3ecc <vTaskPlaceOnEventListRestricted+0x50>
    3ec4:	fff00793          	li	a5,-1
    3ec8:	00f12423          	sw	a5,8(sp)
    3ecc:	00412583          	lw	a1,4(sp)
    3ed0:	00812503          	lw	a0,8(sp)
    3ed4:	790010ef          	jal	ra,5664 <prvAddCurrentTaskToDelayedList>
    3ed8:	00000013          	nop
    3edc:	01c12083          	lw	ra,28(sp)
    3ee0:	02010113          	addi	sp,sp,32
    3ee4:	00008067          	ret

00003ee8 <xTaskRemoveFromEventList>:
    3ee8:	fd010113          	addi	sp,sp,-48
    3eec:	02112623          	sw	ra,44(sp)
    3ef0:	00a12623          	sw	a0,12(sp)
    3ef4:	00c12783          	lw	a5,12(sp)
    3ef8:	00c7a783          	lw	a5,12(a5)
    3efc:	00c7a783          	lw	a5,12(a5)
    3f00:	00f12c23          	sw	a5,24(sp)
    3f04:	01812783          	lw	a5,24(sp)
    3f08:	00079663          	bnez	a5,3f14 <xTaskRemoveFromEventList+0x2c>
    3f0c:	30047073          	csrci	mstatus,8
    3f10:	0000006f          	j	3f10 <xTaskRemoveFromEventList+0x28>
    3f14:	01812783          	lw	a5,24(sp)
    3f18:	01878793          	addi	a5,a5,24
    3f1c:	00078513          	mv	a0,a5
    3f20:	b15fc0ef          	jal	ra,a34 <uxListRemove>
    3f24:	0001c797          	auipc	a5,0x1c
    3f28:	7ac78793          	addi	a5,a5,1964 # 206d0 <uxSchedulerSuspended>
    3f2c:	0007a783          	lw	a5,0(a5)
    3f30:	06079e63          	bnez	a5,3fac <xTaskRemoveFromEventList+0xc4>
    3f34:	01812783          	lw	a5,24(sp)
    3f38:	00478793          	addi	a5,a5,4
    3f3c:	00078513          	mv	a0,a5
    3f40:	af5fc0ef          	jal	ra,a34 <uxListRemove>
    3f44:	01812783          	lw	a5,24(sp)
    3f48:	02c7a703          	lw	a4,44(a5)
    3f4c:	0001c797          	auipc	a5,0x1c
    3f50:	76478793          	addi	a5,a5,1892 # 206b0 <uxTopReadyPriority>
    3f54:	0007a783          	lw	a5,0(a5)
    3f58:	00e7fc63          	bleu	a4,a5,3f70 <xTaskRemoveFromEventList+0x88>
    3f5c:	01812783          	lw	a5,24(sp)
    3f60:	02c7a703          	lw	a4,44(a5)
    3f64:	0001c797          	auipc	a5,0x1c
    3f68:	74c78793          	addi	a5,a5,1868 # 206b0 <uxTopReadyPriority>
    3f6c:	00e7a023          	sw	a4,0(a5)
    3f70:	01812783          	lw	a5,24(sp)
    3f74:	02c7a703          	lw	a4,44(a5)
    3f78:	00070793          	mv	a5,a4
    3f7c:	00279793          	slli	a5,a5,0x2
    3f80:	00e787b3          	add	a5,a5,a4
    3f84:	00279793          	slli	a5,a5,0x2
    3f88:	0001c717          	auipc	a4,0x1c
    3f8c:	67470713          	addi	a4,a4,1652 # 205fc <pxReadyTasksLists>
    3f90:	00e78733          	add	a4,a5,a4
    3f94:	01812783          	lw	a5,24(sp)
    3f98:	00478793          	addi	a5,a5,4
    3f9c:	00078593          	mv	a1,a5
    3fa0:	00070513          	mv	a0,a4
    3fa4:	94dfc0ef          	jal	ra,8f0 <vListInsertEnd>
    3fa8:	01c0006f          	j	3fc4 <xTaskRemoveFromEventList+0xdc>
    3fac:	01812783          	lw	a5,24(sp)
    3fb0:	01878793          	addi	a5,a5,24
    3fb4:	00078593          	mv	a1,a5
    3fb8:	0001c517          	auipc	a0,0x1c
    3fbc:	6b050513          	addi	a0,a0,1712 # 20668 <xPendingReadyList>
    3fc0:	931fc0ef          	jal	ra,8f0 <vListInsertEnd>
    3fc4:	01812783          	lw	a5,24(sp)
    3fc8:	02c7a703          	lw	a4,44(a5)
    3fcc:	0001c797          	auipc	a5,0x1c
    3fd0:	58478793          	addi	a5,a5,1412 # 20550 <pxCurrentTCB>
    3fd4:	0007a783          	lw	a5,0(a5)
    3fd8:	02c7a783          	lw	a5,44(a5)
    3fdc:	02e7f063          	bleu	a4,a5,3ffc <xTaskRemoveFromEventList+0x114>
    3fe0:	00100793          	li	a5,1
    3fe4:	00f12e23          	sw	a5,28(sp)
    3fe8:	0001c797          	auipc	a5,0x1c
    3fec:	6d478793          	addi	a5,a5,1748 # 206bc <xYieldPending>
    3ff0:	00100713          	li	a4,1
    3ff4:	00e7a023          	sw	a4,0(a5)
    3ff8:	0080006f          	j	4000 <xTaskRemoveFromEventList+0x118>
    3ffc:	00012e23          	sw	zero,28(sp)
    4000:	01c12783          	lw	a5,28(sp)
    4004:	00078513          	mv	a0,a5
    4008:	02c12083          	lw	ra,44(sp)
    400c:	03010113          	addi	sp,sp,48
    4010:	00008067          	ret

00004014 <vTaskRemoveFromUnorderedEventList>:
    4014:	fd010113          	addi	sp,sp,-48
    4018:	02112623          	sw	ra,44(sp)
    401c:	00a12623          	sw	a0,12(sp)
    4020:	00b12423          	sw	a1,8(sp)
    4024:	0001c797          	auipc	a5,0x1c
    4028:	6ac78793          	addi	a5,a5,1708 # 206d0 <uxSchedulerSuspended>
    402c:	0007a783          	lw	a5,0(a5)
    4030:	00079663          	bnez	a5,403c <vTaskRemoveFromUnorderedEventList+0x28>
    4034:	30047073          	csrci	mstatus,8
    4038:	0000006f          	j	4038 <vTaskRemoveFromUnorderedEventList+0x24>
    403c:	00812703          	lw	a4,8(sp)
    4040:	800007b7          	lui	a5,0x80000
    4044:	00f76733          	or	a4,a4,a5
    4048:	00c12783          	lw	a5,12(sp)
    404c:	00e7a023          	sw	a4,0(a5) # 80000000 <__stack+0x7ffc46f8>
    4050:	00c12783          	lw	a5,12(sp)
    4054:	00c7a783          	lw	a5,12(a5)
    4058:	00f12e23          	sw	a5,28(sp)
    405c:	01c12783          	lw	a5,28(sp)
    4060:	00079663          	bnez	a5,406c <vTaskRemoveFromUnorderedEventList+0x58>
    4064:	30047073          	csrci	mstatus,8
    4068:	0000006f          	j	4068 <vTaskRemoveFromUnorderedEventList+0x54>
    406c:	00c12503          	lw	a0,12(sp)
    4070:	9c5fc0ef          	jal	ra,a34 <uxListRemove>
    4074:	01c12783          	lw	a5,28(sp)
    4078:	00478793          	addi	a5,a5,4
    407c:	00078513          	mv	a0,a5
    4080:	9b5fc0ef          	jal	ra,a34 <uxListRemove>
    4084:	01c12783          	lw	a5,28(sp)
    4088:	02c7a703          	lw	a4,44(a5)
    408c:	0001c797          	auipc	a5,0x1c
    4090:	62478793          	addi	a5,a5,1572 # 206b0 <uxTopReadyPriority>
    4094:	0007a783          	lw	a5,0(a5)
    4098:	00e7fc63          	bleu	a4,a5,40b0 <vTaskRemoveFromUnorderedEventList+0x9c>
    409c:	01c12783          	lw	a5,28(sp)
    40a0:	02c7a703          	lw	a4,44(a5)
    40a4:	0001c797          	auipc	a5,0x1c
    40a8:	60c78793          	addi	a5,a5,1548 # 206b0 <uxTopReadyPriority>
    40ac:	00e7a023          	sw	a4,0(a5)
    40b0:	01c12783          	lw	a5,28(sp)
    40b4:	02c7a703          	lw	a4,44(a5)
    40b8:	00070793          	mv	a5,a4
    40bc:	00279793          	slli	a5,a5,0x2
    40c0:	00e787b3          	add	a5,a5,a4
    40c4:	00279793          	slli	a5,a5,0x2
    40c8:	0001c717          	auipc	a4,0x1c
    40cc:	53470713          	addi	a4,a4,1332 # 205fc <pxReadyTasksLists>
    40d0:	00e78733          	add	a4,a5,a4
    40d4:	01c12783          	lw	a5,28(sp)
    40d8:	00478793          	addi	a5,a5,4
    40dc:	00078593          	mv	a1,a5
    40e0:	00070513          	mv	a0,a4
    40e4:	80dfc0ef          	jal	ra,8f0 <vListInsertEnd>
    40e8:	01c12783          	lw	a5,28(sp)
    40ec:	02c7a703          	lw	a4,44(a5)
    40f0:	0001c797          	auipc	a5,0x1c
    40f4:	46078793          	addi	a5,a5,1120 # 20550 <pxCurrentTCB>
    40f8:	0007a783          	lw	a5,0(a5)
    40fc:	02c7a783          	lw	a5,44(a5)
    4100:	00e7fa63          	bleu	a4,a5,4114 <vTaskRemoveFromUnorderedEventList+0x100>
    4104:	0001c797          	auipc	a5,0x1c
    4108:	5b878793          	addi	a5,a5,1464 # 206bc <xYieldPending>
    410c:	00100713          	li	a4,1
    4110:	00e7a023          	sw	a4,0(a5)
    4114:	00000013          	nop
    4118:	02c12083          	lw	ra,44(sp)
    411c:	03010113          	addi	sp,sp,48
    4120:	00008067          	ret

00004124 <vTaskSetTimeOutState>:
    4124:	fe010113          	addi	sp,sp,-32
    4128:	00112e23          	sw	ra,28(sp)
    412c:	00a12623          	sw	a0,12(sp)
    4130:	00c12783          	lw	a5,12(sp)
    4134:	00079663          	bnez	a5,4140 <vTaskSetTimeOutState+0x1c>
    4138:	30047073          	csrci	mstatus,8
    413c:	0000006f          	j	413c <vTaskSetTimeOutState+0x18>
    4140:	3c9000ef          	jal	ra,4d08 <vTaskEnterCritical>
    4144:	0001c797          	auipc	a5,0x1c
    4148:	57c78793          	addi	a5,a5,1404 # 206c0 <xNumOfOverflows>
    414c:	0007a703          	lw	a4,0(a5)
    4150:	00c12783          	lw	a5,12(sp)
    4154:	00e7a023          	sw	a4,0(a5)
    4158:	0001c797          	auipc	a5,0x1c
    415c:	55478793          	addi	a5,a5,1364 # 206ac <xTickCount>
    4160:	0007a703          	lw	a4,0(a5)
    4164:	00c12783          	lw	a5,12(sp)
    4168:	00e7a223          	sw	a4,4(a5)
    416c:	3dd000ef          	jal	ra,4d48 <vTaskExitCritical>
    4170:	00000013          	nop
    4174:	01c12083          	lw	ra,28(sp)
    4178:	02010113          	addi	sp,sp,32
    417c:	00008067          	ret

00004180 <vTaskInternalSetTimeOutState>:
    4180:	ff010113          	addi	sp,sp,-16
    4184:	00a12623          	sw	a0,12(sp)
    4188:	0001c797          	auipc	a5,0x1c
    418c:	53878793          	addi	a5,a5,1336 # 206c0 <xNumOfOverflows>
    4190:	0007a703          	lw	a4,0(a5)
    4194:	00c12783          	lw	a5,12(sp)
    4198:	00e7a023          	sw	a4,0(a5)
    419c:	0001c797          	auipc	a5,0x1c
    41a0:	51078793          	addi	a5,a5,1296 # 206ac <xTickCount>
    41a4:	0007a703          	lw	a4,0(a5)
    41a8:	00c12783          	lw	a5,12(sp)
    41ac:	00e7a223          	sw	a4,4(a5)
    41b0:	00000013          	nop
    41b4:	01010113          	addi	sp,sp,16
    41b8:	00008067          	ret

000041bc <xTaskCheckForTimeOut>:
    41bc:	fd010113          	addi	sp,sp,-48
    41c0:	02112623          	sw	ra,44(sp)
    41c4:	00a12623          	sw	a0,12(sp)
    41c8:	00b12423          	sw	a1,8(sp)
    41cc:	00c12783          	lw	a5,12(sp)
    41d0:	00079663          	bnez	a5,41dc <xTaskCheckForTimeOut+0x20>
    41d4:	30047073          	csrci	mstatus,8
    41d8:	0000006f          	j	41d8 <xTaskCheckForTimeOut+0x1c>
    41dc:	00812783          	lw	a5,8(sp)
    41e0:	00079663          	bnez	a5,41ec <xTaskCheckForTimeOut+0x30>
    41e4:	30047073          	csrci	mstatus,8
    41e8:	0000006f          	j	41e8 <xTaskCheckForTimeOut+0x2c>
    41ec:	31d000ef          	jal	ra,4d08 <vTaskEnterCritical>
    41f0:	0001c797          	auipc	a5,0x1c
    41f4:	4bc78793          	addi	a5,a5,1212 # 206ac <xTickCount>
    41f8:	0007a783          	lw	a5,0(a5)
    41fc:	00f12c23          	sw	a5,24(sp)
    4200:	00c12783          	lw	a5,12(sp)
    4204:	0047a783          	lw	a5,4(a5)
    4208:	01812703          	lw	a4,24(sp)
    420c:	40f707b3          	sub	a5,a4,a5
    4210:	00f12a23          	sw	a5,20(sp)
    4214:	00812783          	lw	a5,8(sp)
    4218:	0007a703          	lw	a4,0(a5)
    421c:	fff00793          	li	a5,-1
    4220:	00f71663          	bne	a4,a5,422c <xTaskCheckForTimeOut+0x70>
    4224:	00012e23          	sw	zero,28(sp)
    4228:	0800006f          	j	42a8 <xTaskCheckForTimeOut+0xec>
    422c:	00c12783          	lw	a5,12(sp)
    4230:	0007a703          	lw	a4,0(a5)
    4234:	0001c797          	auipc	a5,0x1c
    4238:	48c78793          	addi	a5,a5,1164 # 206c0 <xNumOfOverflows>
    423c:	0007a783          	lw	a5,0(a5)
    4240:	02f70063          	beq	a4,a5,4260 <xTaskCheckForTimeOut+0xa4>
    4244:	00c12783          	lw	a5,12(sp)
    4248:	0047a783          	lw	a5,4(a5)
    424c:	01812703          	lw	a4,24(sp)
    4250:	00f76863          	bltu	a4,a5,4260 <xTaskCheckForTimeOut+0xa4>
    4254:	00100793          	li	a5,1
    4258:	00f12e23          	sw	a5,28(sp)
    425c:	04c0006f          	j	42a8 <xTaskCheckForTimeOut+0xec>
    4260:	00812783          	lw	a5,8(sp)
    4264:	0007a783          	lw	a5,0(a5)
    4268:	01412703          	lw	a4,20(sp)
    426c:	02f77663          	bleu	a5,a4,4298 <xTaskCheckForTimeOut+0xdc>
    4270:	00812783          	lw	a5,8(sp)
    4274:	0007a703          	lw	a4,0(a5)
    4278:	01412783          	lw	a5,20(sp)
    427c:	40f70733          	sub	a4,a4,a5
    4280:	00812783          	lw	a5,8(sp)
    4284:	00e7a023          	sw	a4,0(a5)
    4288:	00c12503          	lw	a0,12(sp)
    428c:	ef5ff0ef          	jal	ra,4180 <vTaskInternalSetTimeOutState>
    4290:	00012e23          	sw	zero,28(sp)
    4294:	0140006f          	j	42a8 <xTaskCheckForTimeOut+0xec>
    4298:	00812783          	lw	a5,8(sp)
    429c:	0007a023          	sw	zero,0(a5)
    42a0:	00100793          	li	a5,1
    42a4:	00f12e23          	sw	a5,28(sp)
    42a8:	2a1000ef          	jal	ra,4d48 <vTaskExitCritical>
    42ac:	01c12783          	lw	a5,28(sp)
    42b0:	00078513          	mv	a0,a5
    42b4:	02c12083          	lw	ra,44(sp)
    42b8:	03010113          	addi	sp,sp,48
    42bc:	00008067          	ret

000042c0 <vTaskMissedYield>:
    42c0:	0001c797          	auipc	a5,0x1c
    42c4:	3fc78793          	addi	a5,a5,1020 # 206bc <xYieldPending>
    42c8:	00100713          	li	a4,1
    42cc:	00e7a023          	sw	a4,0(a5)
    42d0:	00000013          	nop
    42d4:	00008067          	ret

000042d8 <uxTaskGetTaskNumber>:
    42d8:	fe010113          	addi	sp,sp,-32
    42dc:	00a12623          	sw	a0,12(sp)
    42e0:	00c12783          	lw	a5,12(sp)
    42e4:	00078e63          	beqz	a5,4300 <uxTaskGetTaskNumber+0x28>
    42e8:	00c12783          	lw	a5,12(sp)
    42ec:	00f12c23          	sw	a5,24(sp)
    42f0:	01812783          	lw	a5,24(sp)
    42f4:	04c7a783          	lw	a5,76(a5)
    42f8:	00f12e23          	sw	a5,28(sp)
    42fc:	0080006f          	j	4304 <uxTaskGetTaskNumber+0x2c>
    4300:	00012e23          	sw	zero,28(sp)
    4304:	01c12783          	lw	a5,28(sp)
    4308:	00078513          	mv	a0,a5
    430c:	02010113          	addi	sp,sp,32
    4310:	00008067          	ret

00004314 <vTaskSetTaskNumber>:
    4314:	fe010113          	addi	sp,sp,-32
    4318:	00a12623          	sw	a0,12(sp)
    431c:	00b12423          	sw	a1,8(sp)
    4320:	00c12783          	lw	a5,12(sp)
    4324:	00078c63          	beqz	a5,433c <vTaskSetTaskNumber+0x28>
    4328:	00c12783          	lw	a5,12(sp)
    432c:	00f12e23          	sw	a5,28(sp)
    4330:	01c12783          	lw	a5,28(sp)
    4334:	00812703          	lw	a4,8(sp)
    4338:	04e7a623          	sw	a4,76(a5)
    433c:	00000013          	nop
    4340:	02010113          	addi	sp,sp,32
    4344:	00008067          	ret

00004348 <prvIdleTask>:
    4348:	fe010113          	addi	sp,sp,-32
    434c:	00112e23          	sw	ra,28(sp)
    4350:	00a12623          	sw	a0,12(sp)
    4354:	0e4000ef          	jal	ra,4438 <prvCheckTasksWaitingTermination>
    4358:	0001c797          	auipc	a5,0x1c
    435c:	2a478793          	addi	a5,a5,676 # 205fc <pxReadyTasksLists>
    4360:	0007a703          	lw	a4,0(a5)
    4364:	00100793          	li	a5,1
    4368:	fee7f6e3          	bleu	a4,a5,4354 <prvIdleTask+0xc>
    436c:	a28fc0ef          	jal	ra,594 <vPortYield>
    4370:	fe5ff06f          	j	4354 <prvIdleTask+0xc>

00004374 <prvInitialiseTaskLists>:
    4374:	fe010113          	addi	sp,sp,-32
    4378:	00112e23          	sw	ra,28(sp)
    437c:	00012623          	sw	zero,12(sp)
    4380:	0380006f          	j	43b8 <prvInitialiseTaskLists+0x44>
    4384:	00c12703          	lw	a4,12(sp)
    4388:	00070793          	mv	a5,a4
    438c:	00279793          	slli	a5,a5,0x2
    4390:	00e787b3          	add	a5,a5,a4
    4394:	00279793          	slli	a5,a5,0x2
    4398:	0001c717          	auipc	a4,0x1c
    439c:	26470713          	addi	a4,a4,612 # 205fc <pxReadyTasksLists>
    43a0:	00e787b3          	add	a5,a5,a4
    43a4:	00078513          	mv	a0,a5
    43a8:	cd4fc0ef          	jal	ra,87c <vListInitialise>
    43ac:	00c12783          	lw	a5,12(sp)
    43b0:	00178793          	addi	a5,a5,1
    43b4:	00f12623          	sw	a5,12(sp)
    43b8:	00c12703          	lw	a4,12(sp)
    43bc:	00400793          	li	a5,4
    43c0:	fce7f2e3          	bleu	a4,a5,4384 <prvInitialiseTaskLists+0x10>
    43c4:	0001c517          	auipc	a0,0x1c
    43c8:	31050513          	addi	a0,a0,784 # 206d4 <xDelayedTaskList1.2417>
    43cc:	cb0fc0ef          	jal	ra,87c <vListInitialise>
    43d0:	0001c517          	auipc	a0,0x1c
    43d4:	31850513          	addi	a0,a0,792 # 206e8 <xDelayedTaskList2.2418>
    43d8:	ca4fc0ef          	jal	ra,87c <vListInitialise>
    43dc:	0001c517          	auipc	a0,0x1c
    43e0:	28c50513          	addi	a0,a0,652 # 20668 <xPendingReadyList>
    43e4:	c98fc0ef          	jal	ra,87c <vListInitialise>
    43e8:	0001c517          	auipc	a0,0x1c
    43ec:	29450513          	addi	a0,a0,660 # 2067c <xTasksWaitingTermination>
    43f0:	c8cfc0ef          	jal	ra,87c <vListInitialise>
    43f4:	0001c517          	auipc	a0,0x1c
    43f8:	2a050513          	addi	a0,a0,672 # 20694 <xSuspendedTaskList>
    43fc:	c80fc0ef          	jal	ra,87c <vListInitialise>
    4400:	0001c797          	auipc	a5,0x1c
    4404:	26078793          	addi	a5,a5,608 # 20660 <pxDelayedTaskList>
    4408:	0001c717          	auipc	a4,0x1c
    440c:	2cc70713          	addi	a4,a4,716 # 206d4 <xDelayedTaskList1.2417>
    4410:	00e7a023          	sw	a4,0(a5)
    4414:	0001c797          	auipc	a5,0x1c
    4418:	25078793          	addi	a5,a5,592 # 20664 <pxOverflowDelayedTaskList>
    441c:	0001c717          	auipc	a4,0x1c
    4420:	2cc70713          	addi	a4,a4,716 # 206e8 <xDelayedTaskList2.2418>
    4424:	00e7a023          	sw	a4,0(a5)
    4428:	00000013          	nop
    442c:	01c12083          	lw	ra,28(sp)
    4430:	02010113          	addi	sp,sp,32
    4434:	00008067          	ret

00004438 <prvCheckTasksWaitingTermination>:
    4438:	fe010113          	addi	sp,sp,-32
    443c:	00112e23          	sw	ra,28(sp)
    4440:	0700006f          	j	44b0 <prvCheckTasksWaitingTermination+0x78>
    4444:	0c5000ef          	jal	ra,4d08 <vTaskEnterCritical>
    4448:	0001c797          	auipc	a5,0x1c
    444c:	23478793          	addi	a5,a5,564 # 2067c <xTasksWaitingTermination>
    4450:	00c7a783          	lw	a5,12(a5)
    4454:	00c7a783          	lw	a5,12(a5)
    4458:	00f12623          	sw	a5,12(sp)
    445c:	00c12783          	lw	a5,12(sp)
    4460:	00478793          	addi	a5,a5,4
    4464:	00078513          	mv	a0,a5
    4468:	dccfc0ef          	jal	ra,a34 <uxListRemove>
    446c:	0001c797          	auipc	a5,0x1c
    4470:	23c78793          	addi	a5,a5,572 # 206a8 <uxCurrentNumberOfTasks>
    4474:	0007a783          	lw	a5,0(a5)
    4478:	fff78713          	addi	a4,a5,-1
    447c:	0001c797          	auipc	a5,0x1c
    4480:	22c78793          	addi	a5,a5,556 # 206a8 <uxCurrentNumberOfTasks>
    4484:	00e7a023          	sw	a4,0(a5)
    4488:	0001c797          	auipc	a5,0x1c
    448c:	20878793          	addi	a5,a5,520 # 20690 <uxDeletedTasksWaitingCleanUp>
    4490:	0007a783          	lw	a5,0(a5)
    4494:	fff78713          	addi	a4,a5,-1
    4498:	0001c797          	auipc	a5,0x1c
    449c:	1f878793          	addi	a5,a5,504 # 20690 <uxDeletedTasksWaitingCleanUp>
    44a0:	00e7a023          	sw	a4,0(a5)
    44a4:	0a5000ef          	jal	ra,4d48 <vTaskExitCritical>
    44a8:	00c12503          	lw	a0,12(sp)
    44ac:	308000ef          	jal	ra,47b4 <prvDeleteTCB>
    44b0:	0001c797          	auipc	a5,0x1c
    44b4:	1e078793          	addi	a5,a5,480 # 20690 <uxDeletedTasksWaitingCleanUp>
    44b8:	0007a783          	lw	a5,0(a5)
    44bc:	f80794e3          	bnez	a5,4444 <prvCheckTasksWaitingTermination+0xc>
    44c0:	00000013          	nop
    44c4:	01c12083          	lw	ra,28(sp)
    44c8:	02010113          	addi	sp,sp,32
    44cc:	00008067          	ret

000044d0 <vTaskGetInfo>:
    44d0:	fd010113          	addi	sp,sp,-48
    44d4:	02112623          	sw	ra,44(sp)
    44d8:	00a12623          	sw	a0,12(sp)
    44dc:	00b12423          	sw	a1,8(sp)
    44e0:	00c12223          	sw	a2,4(sp)
    44e4:	00d12023          	sw	a3,0(sp)
    44e8:	00c12783          	lw	a5,12(sp)
    44ec:	00079a63          	bnez	a5,4500 <vTaskGetInfo+0x30>
    44f0:	0001c797          	auipc	a5,0x1c
    44f4:	06078793          	addi	a5,a5,96 # 20550 <pxCurrentTCB>
    44f8:	0007a783          	lw	a5,0(a5)
    44fc:	0080006f          	j	4504 <vTaskGetInfo+0x34>
    4500:	00c12783          	lw	a5,12(sp)
    4504:	00f12e23          	sw	a5,28(sp)
    4508:	00812783          	lw	a5,8(sp)
    450c:	01c12703          	lw	a4,28(sp)
    4510:	00e7a023          	sw	a4,0(a5)
    4514:	01c12783          	lw	a5,28(sp)
    4518:	03478713          	addi	a4,a5,52
    451c:	00812783          	lw	a5,8(sp)
    4520:	00e7a223          	sw	a4,4(a5)
    4524:	01c12783          	lw	a5,28(sp)
    4528:	02c7a703          	lw	a4,44(a5)
    452c:	00812783          	lw	a5,8(sp)
    4530:	00e7a823          	sw	a4,16(a5)
    4534:	01c12783          	lw	a5,28(sp)
    4538:	0307a703          	lw	a4,48(a5)
    453c:	00812783          	lw	a5,8(sp)
    4540:	00e7ae23          	sw	a4,28(a5)
    4544:	01c12783          	lw	a5,28(sp)
    4548:	0487a703          	lw	a4,72(a5)
    454c:	00812783          	lw	a5,8(sp)
    4550:	00e7a423          	sw	a4,8(a5)
    4554:	01c12783          	lw	a5,28(sp)
    4558:	0507a703          	lw	a4,80(a5)
    455c:	00812783          	lw	a5,8(sp)
    4560:	00e7aa23          	sw	a4,20(a5)
    4564:	00812783          	lw	a5,8(sp)
    4568:	0007ac23          	sw	zero,24(a5)
    456c:	00012703          	lw	a4,0(sp)
    4570:	00500793          	li	a5,5
    4574:	06f70063          	beq	a4,a5,45d4 <vTaskGetInfo+0x104>
    4578:	0001c797          	auipc	a5,0x1c
    457c:	fd878793          	addi	a5,a5,-40 # 20550 <pxCurrentTCB>
    4580:	0007a783          	lw	a5,0(a5)
    4584:	01c12703          	lw	a4,28(sp)
    4588:	00f71863          	bne	a4,a5,4598 <vTaskGetInfo+0xc8>
    458c:	00812783          	lw	a5,8(sp)
    4590:	0007a623          	sw	zero,12(a5)
    4594:	0540006f          	j	45e8 <vTaskGetInfo+0x118>
    4598:	00812783          	lw	a5,8(sp)
    459c:	00012703          	lw	a4,0(sp)
    45a0:	00e7a623          	sw	a4,12(a5)
    45a4:	00012703          	lw	a4,0(sp)
    45a8:	00300793          	li	a5,3
    45ac:	02f71e63          	bne	a4,a5,45e8 <vTaskGetInfo+0x118>
    45b0:	ee5fe0ef          	jal	ra,3494 <vTaskSuspendAll>
    45b4:	01c12783          	lw	a5,28(sp)
    45b8:	0287a783          	lw	a5,40(a5)
    45bc:	00078863          	beqz	a5,45cc <vTaskGetInfo+0xfc>
    45c0:	00812783          	lw	a5,8(sp)
    45c4:	00200713          	li	a4,2
    45c8:	00e7a623          	sw	a4,12(a5)
    45cc:	eedfe0ef          	jal	ra,34b8 <xTaskResumeAll>
    45d0:	0180006f          	j	45e8 <vTaskGetInfo+0x118>
    45d4:	01c12503          	lw	a0,28(sp)
    45d8:	e44fe0ef          	jal	ra,2c1c <eTaskGetState>
    45dc:	00050713          	mv	a4,a0
    45e0:	00812783          	lw	a5,8(sp)
    45e4:	00e7a623          	sw	a4,12(a5)
    45e8:	00412783          	lw	a5,4(sp)
    45ec:	02078463          	beqz	a5,4614 <vTaskGetInfo+0x144>
    45f0:	01c12783          	lw	a5,28(sp)
    45f4:	0307a783          	lw	a5,48(a5)
    45f8:	00078513          	mv	a0,a5
    45fc:	15c000ef          	jal	ra,4758 <prvTaskCheckFreeStackSpace>
    4600:	00050793          	mv	a5,a0
    4604:	00078713          	mv	a4,a5
    4608:	00812783          	lw	a5,8(sp)
    460c:	02e79023          	sh	a4,32(a5)
    4610:	00c0006f          	j	461c <vTaskGetInfo+0x14c>
    4614:	00812783          	lw	a5,8(sp)
    4618:	02079023          	sh	zero,32(a5)
    461c:	00000013          	nop
    4620:	02c12083          	lw	ra,44(sp)
    4624:	03010113          	addi	sp,sp,48
    4628:	00008067          	ret

0000462c <prvListTasksWithinSingleList>:
    462c:	fc010113          	addi	sp,sp,-64
    4630:	02112e23          	sw	ra,60(sp)
    4634:	00a12623          	sw	a0,12(sp)
    4638:	00b12423          	sw	a1,8(sp)
    463c:	00c12223          	sw	a2,4(sp)
    4640:	02012623          	sw	zero,44(sp)
    4644:	00812783          	lw	a5,8(sp)
    4648:	0007a783          	lw	a5,0(a5)
    464c:	0e078c63          	beqz	a5,4744 <prvListTasksWithinSingleList+0x118>
    4650:	00812783          	lw	a5,8(sp)
    4654:	02f12423          	sw	a5,40(sp)
    4658:	02812783          	lw	a5,40(sp)
    465c:	0047a783          	lw	a5,4(a5)
    4660:	0047a703          	lw	a4,4(a5)
    4664:	02812783          	lw	a5,40(sp)
    4668:	00e7a223          	sw	a4,4(a5)
    466c:	02812783          	lw	a5,40(sp)
    4670:	0047a703          	lw	a4,4(a5)
    4674:	02812783          	lw	a5,40(sp)
    4678:	00878793          	addi	a5,a5,8
    467c:	00f71c63          	bne	a4,a5,4694 <prvListTasksWithinSingleList+0x68>
    4680:	02812783          	lw	a5,40(sp)
    4684:	0047a783          	lw	a5,4(a5)
    4688:	0047a703          	lw	a4,4(a5)
    468c:	02812783          	lw	a5,40(sp)
    4690:	00e7a223          	sw	a4,4(a5)
    4694:	02812783          	lw	a5,40(sp)
    4698:	0047a783          	lw	a5,4(a5)
    469c:	00c7a783          	lw	a5,12(a5)
    46a0:	02f12223          	sw	a5,36(sp)
    46a4:	00812783          	lw	a5,8(sp)
    46a8:	02f12023          	sw	a5,32(sp)
    46ac:	02012783          	lw	a5,32(sp)
    46b0:	0047a783          	lw	a5,4(a5)
    46b4:	0047a703          	lw	a4,4(a5)
    46b8:	02012783          	lw	a5,32(sp)
    46bc:	00e7a223          	sw	a4,4(a5)
    46c0:	02012783          	lw	a5,32(sp)
    46c4:	0047a703          	lw	a4,4(a5)
    46c8:	02012783          	lw	a5,32(sp)
    46cc:	00878793          	addi	a5,a5,8
    46d0:	00f71c63          	bne	a4,a5,46e8 <prvListTasksWithinSingleList+0xbc>
    46d4:	02012783          	lw	a5,32(sp)
    46d8:	0047a783          	lw	a5,4(a5)
    46dc:	0047a703          	lw	a4,4(a5)
    46e0:	02012783          	lw	a5,32(sp)
    46e4:	00e7a223          	sw	a4,4(a5)
    46e8:	02012783          	lw	a5,32(sp)
    46ec:	0047a783          	lw	a5,4(a5)
    46f0:	00c7a783          	lw	a5,12(a5)
    46f4:	00f12e23          	sw	a5,28(sp)
    46f8:	02c12703          	lw	a4,44(sp)
    46fc:	00070793          	mv	a5,a4
    4700:	00379793          	slli	a5,a5,0x3
    4704:	00e787b3          	add	a5,a5,a4
    4708:	00279793          	slli	a5,a5,0x2
    470c:	00078713          	mv	a4,a5
    4710:	00c12783          	lw	a5,12(sp)
    4714:	00e787b3          	add	a5,a5,a4
    4718:	00412683          	lw	a3,4(sp)
    471c:	00100613          	li	a2,1
    4720:	00078593          	mv	a1,a5
    4724:	01c12503          	lw	a0,28(sp)
    4728:	da9ff0ef          	jal	ra,44d0 <vTaskGetInfo>
    472c:	02c12783          	lw	a5,44(sp)
    4730:	00178793          	addi	a5,a5,1
    4734:	02f12623          	sw	a5,44(sp)
    4738:	01c12703          	lw	a4,28(sp)
    473c:	02412783          	lw	a5,36(sp)
    4740:	f6f712e3          	bne	a4,a5,46a4 <prvListTasksWithinSingleList+0x78>
    4744:	02c12783          	lw	a5,44(sp)
    4748:	00078513          	mv	a0,a5
    474c:	03c12083          	lw	ra,60(sp)
    4750:	04010113          	addi	sp,sp,64
    4754:	00008067          	ret

00004758 <prvTaskCheckFreeStackSpace>:
    4758:	fe010113          	addi	sp,sp,-32
    475c:	00a12623          	sw	a0,12(sp)
    4760:	00012e23          	sw	zero,28(sp)
    4764:	01c0006f          	j	4780 <prvTaskCheckFreeStackSpace+0x28>
    4768:	00c12783          	lw	a5,12(sp)
    476c:	00178793          	addi	a5,a5,1
    4770:	00f12623          	sw	a5,12(sp)
    4774:	01c12783          	lw	a5,28(sp)
    4778:	00178793          	addi	a5,a5,1
    477c:	00f12e23          	sw	a5,28(sp)
    4780:	00c12783          	lw	a5,12(sp)
    4784:	0007c703          	lbu	a4,0(a5)
    4788:	0a500793          	li	a5,165
    478c:	fcf70ee3          	beq	a4,a5,4768 <prvTaskCheckFreeStackSpace+0x10>
    4790:	01c12783          	lw	a5,28(sp)
    4794:	0027d793          	srli	a5,a5,0x2
    4798:	00f12e23          	sw	a5,28(sp)
    479c:	01c12783          	lw	a5,28(sp)
    47a0:	01079793          	slli	a5,a5,0x10
    47a4:	0107d793          	srli	a5,a5,0x10
    47a8:	00078513          	mv	a0,a5
    47ac:	02010113          	addi	sp,sp,32
    47b0:	00008067          	ret

000047b4 <prvDeleteTCB>:
    47b4:	fe010113          	addi	sp,sp,-32
    47b8:	00112e23          	sw	ra,28(sp)
    47bc:	00a12623          	sw	a0,12(sp)
    47c0:	00c12783          	lw	a5,12(sp)
    47c4:	0307a783          	lw	a5,48(a5)
    47c8:	00078513          	mv	a0,a5
    47cc:	594020ef          	jal	ra,6d60 <vPortFree>
    47d0:	00c12503          	lw	a0,12(sp)
    47d4:	58c020ef          	jal	ra,6d60 <vPortFree>
    47d8:	00000013          	nop
    47dc:	01c12083          	lw	ra,28(sp)
    47e0:	02010113          	addi	sp,sp,32
    47e4:	00008067          	ret

000047e8 <prvResetNextTaskUnblockTime>:
    47e8:	ff010113          	addi	sp,sp,-16
    47ec:	0001c797          	auipc	a5,0x1c
    47f0:	e7478793          	addi	a5,a5,-396 # 20660 <pxDelayedTaskList>
    47f4:	0007a783          	lw	a5,0(a5)
    47f8:	0007a783          	lw	a5,0(a5)
    47fc:	00079c63          	bnez	a5,4814 <prvResetNextTaskUnblockTime+0x2c>
    4800:	0001c797          	auipc	a5,0x1c
    4804:	ec878793          	addi	a5,a5,-312 # 206c8 <xNextTaskUnblockTime>
    4808:	fff00713          	li	a4,-1
    480c:	00e7a023          	sw	a4,0(a5)
    4810:	0300006f          	j	4840 <prvResetNextTaskUnblockTime+0x58>
    4814:	0001c797          	auipc	a5,0x1c
    4818:	e4c78793          	addi	a5,a5,-436 # 20660 <pxDelayedTaskList>
    481c:	0007a783          	lw	a5,0(a5)
    4820:	00c7a783          	lw	a5,12(a5)
    4824:	00c7a783          	lw	a5,12(a5)
    4828:	00f12623          	sw	a5,12(sp)
    482c:	00c12783          	lw	a5,12(sp)
    4830:	0047a703          	lw	a4,4(a5)
    4834:	0001c797          	auipc	a5,0x1c
    4838:	e9478793          	addi	a5,a5,-364 # 206c8 <xNextTaskUnblockTime>
    483c:	00e7a023          	sw	a4,0(a5)
    4840:	00000013          	nop
    4844:	01010113          	addi	sp,sp,16
    4848:	00008067          	ret

0000484c <xTaskGetCurrentTaskHandle>:
    484c:	ff010113          	addi	sp,sp,-16
    4850:	0001c797          	auipc	a5,0x1c
    4854:	d0078793          	addi	a5,a5,-768 # 20550 <pxCurrentTCB>
    4858:	0007a783          	lw	a5,0(a5)
    485c:	00f12623          	sw	a5,12(sp)
    4860:	00c12783          	lw	a5,12(sp)
    4864:	00078513          	mv	a0,a5
    4868:	01010113          	addi	sp,sp,16
    486c:	00008067          	ret

00004870 <xTaskGetSchedulerState>:
    4870:	ff010113          	addi	sp,sp,-16
    4874:	0001c797          	auipc	a5,0x1c
    4878:	e4078793          	addi	a5,a5,-448 # 206b4 <xSchedulerRunning>
    487c:	0007a783          	lw	a5,0(a5)
    4880:	00079863          	bnez	a5,4890 <xTaskGetSchedulerState+0x20>
    4884:	00100793          	li	a5,1
    4888:	00f12623          	sw	a5,12(sp)
    488c:	0240006f          	j	48b0 <xTaskGetSchedulerState+0x40>
    4890:	0001c797          	auipc	a5,0x1c
    4894:	e4078793          	addi	a5,a5,-448 # 206d0 <uxSchedulerSuspended>
    4898:	0007a783          	lw	a5,0(a5)
    489c:	00079863          	bnez	a5,48ac <xTaskGetSchedulerState+0x3c>
    48a0:	00200793          	li	a5,2
    48a4:	00f12623          	sw	a5,12(sp)
    48a8:	0080006f          	j	48b0 <xTaskGetSchedulerState+0x40>
    48ac:	00012623          	sw	zero,12(sp)
    48b0:	00c12783          	lw	a5,12(sp)
    48b4:	00078513          	mv	a0,a5
    48b8:	01010113          	addi	sp,sp,16
    48bc:	00008067          	ret

000048c0 <xTaskPriorityInherit>:
    48c0:	fd010113          	addi	sp,sp,-48
    48c4:	02112623          	sw	ra,44(sp)
    48c8:	00a12623          	sw	a0,12(sp)
    48cc:	00c12783          	lw	a5,12(sp)
    48d0:	00f12c23          	sw	a5,24(sp)
    48d4:	00012e23          	sw	zero,28(sp)
    48d8:	00c12783          	lw	a5,12(sp)
    48dc:	14078a63          	beqz	a5,4a30 <xTaskPriorityInherit+0x170>
    48e0:	01812783          	lw	a5,24(sp)
    48e4:	02c7a703          	lw	a4,44(a5)
    48e8:	0001c797          	auipc	a5,0x1c
    48ec:	c6878793          	addi	a5,a5,-920 # 20550 <pxCurrentTCB>
    48f0:	0007a783          	lw	a5,0(a5)
    48f4:	02c7a783          	lw	a5,44(a5)
    48f8:	10f77a63          	bleu	a5,a4,4a0c <xTaskPriorityInherit+0x14c>
    48fc:	01812783          	lw	a5,24(sp)
    4900:	0187a783          	lw	a5,24(a5)
    4904:	0207c263          	bltz	a5,4928 <xTaskPriorityInherit+0x68>
    4908:	0001c797          	auipc	a5,0x1c
    490c:	c4878793          	addi	a5,a5,-952 # 20550 <pxCurrentTCB>
    4910:	0007a783          	lw	a5,0(a5)
    4914:	02c7a783          	lw	a5,44(a5)
    4918:	00500713          	li	a4,5
    491c:	40f70733          	sub	a4,a4,a5
    4920:	01812783          	lw	a5,24(sp)
    4924:	00e7ac23          	sw	a4,24(a5)
    4928:	01812783          	lw	a5,24(sp)
    492c:	0147a683          	lw	a3,20(a5)
    4930:	01812783          	lw	a5,24(sp)
    4934:	02c7a703          	lw	a4,44(a5)
    4938:	00070793          	mv	a5,a4
    493c:	00279793          	slli	a5,a5,0x2
    4940:	00e787b3          	add	a5,a5,a4
    4944:	00279793          	slli	a5,a5,0x2
    4948:	0001c717          	auipc	a4,0x1c
    494c:	cb470713          	addi	a4,a4,-844 # 205fc <pxReadyTasksLists>
    4950:	00e787b3          	add	a5,a5,a4
    4954:	08f69a63          	bne	a3,a5,49e8 <xTaskPriorityInherit+0x128>
    4958:	01812783          	lw	a5,24(sp)
    495c:	00478793          	addi	a5,a5,4
    4960:	00078513          	mv	a0,a5
    4964:	8d0fc0ef          	jal	ra,a34 <uxListRemove>
    4968:	0001c797          	auipc	a5,0x1c
    496c:	be878793          	addi	a5,a5,-1048 # 20550 <pxCurrentTCB>
    4970:	0007a783          	lw	a5,0(a5)
    4974:	02c7a703          	lw	a4,44(a5)
    4978:	01812783          	lw	a5,24(sp)
    497c:	02e7a623          	sw	a4,44(a5)
    4980:	01812783          	lw	a5,24(sp)
    4984:	02c7a703          	lw	a4,44(a5)
    4988:	0001c797          	auipc	a5,0x1c
    498c:	d2878793          	addi	a5,a5,-728 # 206b0 <uxTopReadyPriority>
    4990:	0007a783          	lw	a5,0(a5)
    4994:	00e7fc63          	bleu	a4,a5,49ac <xTaskPriorityInherit+0xec>
    4998:	01812783          	lw	a5,24(sp)
    499c:	02c7a703          	lw	a4,44(a5)
    49a0:	0001c797          	auipc	a5,0x1c
    49a4:	d1078793          	addi	a5,a5,-752 # 206b0 <uxTopReadyPriority>
    49a8:	00e7a023          	sw	a4,0(a5)
    49ac:	01812783          	lw	a5,24(sp)
    49b0:	02c7a703          	lw	a4,44(a5)
    49b4:	00070793          	mv	a5,a4
    49b8:	00279793          	slli	a5,a5,0x2
    49bc:	00e787b3          	add	a5,a5,a4
    49c0:	00279793          	slli	a5,a5,0x2
    49c4:	0001c717          	auipc	a4,0x1c
    49c8:	c3870713          	addi	a4,a4,-968 # 205fc <pxReadyTasksLists>
    49cc:	00e78733          	add	a4,a5,a4
    49d0:	01812783          	lw	a5,24(sp)
    49d4:	00478793          	addi	a5,a5,4
    49d8:	00078593          	mv	a1,a5
    49dc:	00070513          	mv	a0,a4
    49e0:	f11fb0ef          	jal	ra,8f0 <vListInsertEnd>
    49e4:	01c0006f          	j	4a00 <xTaskPriorityInherit+0x140>
    49e8:	0001c797          	auipc	a5,0x1c
    49ec:	b6878793          	addi	a5,a5,-1176 # 20550 <pxCurrentTCB>
    49f0:	0007a783          	lw	a5,0(a5)
    49f4:	02c7a703          	lw	a4,44(a5)
    49f8:	01812783          	lw	a5,24(sp)
    49fc:	02e7a623          	sw	a4,44(a5)
    4a00:	00100793          	li	a5,1
    4a04:	00f12e23          	sw	a5,28(sp)
    4a08:	0280006f          	j	4a30 <xTaskPriorityInherit+0x170>
    4a0c:	01812783          	lw	a5,24(sp)
    4a10:	0507a703          	lw	a4,80(a5)
    4a14:	0001c797          	auipc	a5,0x1c
    4a18:	b3c78793          	addi	a5,a5,-1220 # 20550 <pxCurrentTCB>
    4a1c:	0007a783          	lw	a5,0(a5)
    4a20:	02c7a783          	lw	a5,44(a5)
    4a24:	00f77663          	bleu	a5,a4,4a30 <xTaskPriorityInherit+0x170>
    4a28:	00100793          	li	a5,1
    4a2c:	00f12e23          	sw	a5,28(sp)
    4a30:	01c12783          	lw	a5,28(sp)
    4a34:	00078513          	mv	a0,a5
    4a38:	02c12083          	lw	ra,44(sp)
    4a3c:	03010113          	addi	sp,sp,48
    4a40:	00008067          	ret

00004a44 <xTaskPriorityDisinherit>:
    4a44:	fd010113          	addi	sp,sp,-48
    4a48:	02112623          	sw	ra,44(sp)
    4a4c:	00a12623          	sw	a0,12(sp)
    4a50:	00c12783          	lw	a5,12(sp)
    4a54:	00f12c23          	sw	a5,24(sp)
    4a58:	00012e23          	sw	zero,28(sp)
    4a5c:	00c12783          	lw	a5,12(sp)
    4a60:	10078663          	beqz	a5,4b6c <xTaskPriorityDisinherit+0x128>
    4a64:	0001c797          	auipc	a5,0x1c
    4a68:	aec78793          	addi	a5,a5,-1300 # 20550 <pxCurrentTCB>
    4a6c:	0007a783          	lw	a5,0(a5)
    4a70:	01812703          	lw	a4,24(sp)
    4a74:	00f70663          	beq	a4,a5,4a80 <xTaskPriorityDisinherit+0x3c>
    4a78:	30047073          	csrci	mstatus,8
    4a7c:	0000006f          	j	4a7c <xTaskPriorityDisinherit+0x38>
    4a80:	01812783          	lw	a5,24(sp)
    4a84:	0547a783          	lw	a5,84(a5)
    4a88:	00079663          	bnez	a5,4a94 <xTaskPriorityDisinherit+0x50>
    4a8c:	30047073          	csrci	mstatus,8
    4a90:	0000006f          	j	4a90 <xTaskPriorityDisinherit+0x4c>
    4a94:	01812783          	lw	a5,24(sp)
    4a98:	0547a783          	lw	a5,84(a5)
    4a9c:	fff78713          	addi	a4,a5,-1
    4aa0:	01812783          	lw	a5,24(sp)
    4aa4:	04e7aa23          	sw	a4,84(a5)
    4aa8:	01812783          	lw	a5,24(sp)
    4aac:	02c7a703          	lw	a4,44(a5)
    4ab0:	01812783          	lw	a5,24(sp)
    4ab4:	0507a783          	lw	a5,80(a5)
    4ab8:	0af70a63          	beq	a4,a5,4b6c <xTaskPriorityDisinherit+0x128>
    4abc:	01812783          	lw	a5,24(sp)
    4ac0:	0547a783          	lw	a5,84(a5)
    4ac4:	0a079463          	bnez	a5,4b6c <xTaskPriorityDisinherit+0x128>
    4ac8:	01812783          	lw	a5,24(sp)
    4acc:	00478793          	addi	a5,a5,4
    4ad0:	00078513          	mv	a0,a5
    4ad4:	f61fb0ef          	jal	ra,a34 <uxListRemove>
    4ad8:	01812783          	lw	a5,24(sp)
    4adc:	0507a703          	lw	a4,80(a5)
    4ae0:	01812783          	lw	a5,24(sp)
    4ae4:	02e7a623          	sw	a4,44(a5)
    4ae8:	01812783          	lw	a5,24(sp)
    4aec:	02c7a783          	lw	a5,44(a5)
    4af0:	00500713          	li	a4,5
    4af4:	40f70733          	sub	a4,a4,a5
    4af8:	01812783          	lw	a5,24(sp)
    4afc:	00e7ac23          	sw	a4,24(a5)
    4b00:	01812783          	lw	a5,24(sp)
    4b04:	02c7a703          	lw	a4,44(a5)
    4b08:	0001c797          	auipc	a5,0x1c
    4b0c:	ba878793          	addi	a5,a5,-1112 # 206b0 <uxTopReadyPriority>
    4b10:	0007a783          	lw	a5,0(a5)
    4b14:	00e7fc63          	bleu	a4,a5,4b2c <xTaskPriorityDisinherit+0xe8>
    4b18:	01812783          	lw	a5,24(sp)
    4b1c:	02c7a703          	lw	a4,44(a5)
    4b20:	0001c797          	auipc	a5,0x1c
    4b24:	b9078793          	addi	a5,a5,-1136 # 206b0 <uxTopReadyPriority>
    4b28:	00e7a023          	sw	a4,0(a5)
    4b2c:	01812783          	lw	a5,24(sp)
    4b30:	02c7a703          	lw	a4,44(a5)
    4b34:	00070793          	mv	a5,a4
    4b38:	00279793          	slli	a5,a5,0x2
    4b3c:	00e787b3          	add	a5,a5,a4
    4b40:	00279793          	slli	a5,a5,0x2
    4b44:	0001c717          	auipc	a4,0x1c
    4b48:	ab870713          	addi	a4,a4,-1352 # 205fc <pxReadyTasksLists>
    4b4c:	00e78733          	add	a4,a5,a4
    4b50:	01812783          	lw	a5,24(sp)
    4b54:	00478793          	addi	a5,a5,4
    4b58:	00078593          	mv	a1,a5
    4b5c:	00070513          	mv	a0,a4
    4b60:	d91fb0ef          	jal	ra,8f0 <vListInsertEnd>
    4b64:	00100793          	li	a5,1
    4b68:	00f12e23          	sw	a5,28(sp)
    4b6c:	01c12783          	lw	a5,28(sp)
    4b70:	00078513          	mv	a0,a5
    4b74:	02c12083          	lw	ra,44(sp)
    4b78:	03010113          	addi	sp,sp,48
    4b7c:	00008067          	ret

00004b80 <vTaskPriorityDisinheritAfterTimeout>:
    4b80:	fd010113          	addi	sp,sp,-48
    4b84:	02112623          	sw	ra,44(sp)
    4b88:	00a12623          	sw	a0,12(sp)
    4b8c:	00b12423          	sw	a1,8(sp)
    4b90:	00c12783          	lw	a5,12(sp)
    4b94:	00f12c23          	sw	a5,24(sp)
    4b98:	00100793          	li	a5,1
    4b9c:	00f12a23          	sw	a5,20(sp)
    4ba0:	00c12783          	lw	a5,12(sp)
    4ba4:	14078a63          	beqz	a5,4cf8 <vTaskPriorityDisinheritAfterTimeout+0x178>
    4ba8:	01812783          	lw	a5,24(sp)
    4bac:	0547a783          	lw	a5,84(a5)
    4bb0:	00079663          	bnez	a5,4bbc <vTaskPriorityDisinheritAfterTimeout+0x3c>
    4bb4:	30047073          	csrci	mstatus,8
    4bb8:	0000006f          	j	4bb8 <vTaskPriorityDisinheritAfterTimeout+0x38>
    4bbc:	01812783          	lw	a5,24(sp)
    4bc0:	0507a783          	lw	a5,80(a5)
    4bc4:	00812703          	lw	a4,8(sp)
    4bc8:	00e7f863          	bleu	a4,a5,4bd8 <vTaskPriorityDisinheritAfterTimeout+0x58>
    4bcc:	00812783          	lw	a5,8(sp)
    4bd0:	00f12e23          	sw	a5,28(sp)
    4bd4:	0100006f          	j	4be4 <vTaskPriorityDisinheritAfterTimeout+0x64>
    4bd8:	01812783          	lw	a5,24(sp)
    4bdc:	0507a783          	lw	a5,80(a5)
    4be0:	00f12e23          	sw	a5,28(sp)
    4be4:	01812783          	lw	a5,24(sp)
    4be8:	02c7a783          	lw	a5,44(a5)
    4bec:	01c12703          	lw	a4,28(sp)
    4bf0:	10f70463          	beq	a4,a5,4cf8 <vTaskPriorityDisinheritAfterTimeout+0x178>
    4bf4:	01812783          	lw	a5,24(sp)
    4bf8:	0547a783          	lw	a5,84(a5)
    4bfc:	01412703          	lw	a4,20(sp)
    4c00:	0ef71c63          	bne	a4,a5,4cf8 <vTaskPriorityDisinheritAfterTimeout+0x178>
    4c04:	0001c797          	auipc	a5,0x1c
    4c08:	94c78793          	addi	a5,a5,-1716 # 20550 <pxCurrentTCB>
    4c0c:	0007a783          	lw	a5,0(a5)
    4c10:	01812703          	lw	a4,24(sp)
    4c14:	00f71663          	bne	a4,a5,4c20 <vTaskPriorityDisinheritAfterTimeout+0xa0>
    4c18:	30047073          	csrci	mstatus,8
    4c1c:	0000006f          	j	4c1c <vTaskPriorityDisinheritAfterTimeout+0x9c>
    4c20:	01812783          	lw	a5,24(sp)
    4c24:	02c7a783          	lw	a5,44(a5)
    4c28:	00f12823          	sw	a5,16(sp)
    4c2c:	01812783          	lw	a5,24(sp)
    4c30:	01c12703          	lw	a4,28(sp)
    4c34:	02e7a623          	sw	a4,44(a5)
    4c38:	01812783          	lw	a5,24(sp)
    4c3c:	0187a783          	lw	a5,24(a5)
    4c40:	0007cc63          	bltz	a5,4c58 <vTaskPriorityDisinheritAfterTimeout+0xd8>
    4c44:	00500713          	li	a4,5
    4c48:	01c12783          	lw	a5,28(sp)
    4c4c:	40f70733          	sub	a4,a4,a5
    4c50:	01812783          	lw	a5,24(sp)
    4c54:	00e7ac23          	sw	a4,24(a5)
    4c58:	01812783          	lw	a5,24(sp)
    4c5c:	0147a683          	lw	a3,20(a5)
    4c60:	01012703          	lw	a4,16(sp)
    4c64:	00070793          	mv	a5,a4
    4c68:	00279793          	slli	a5,a5,0x2
    4c6c:	00e787b3          	add	a5,a5,a4
    4c70:	00279793          	slli	a5,a5,0x2
    4c74:	0001c717          	auipc	a4,0x1c
    4c78:	98870713          	addi	a4,a4,-1656 # 205fc <pxReadyTasksLists>
    4c7c:	00e787b3          	add	a5,a5,a4
    4c80:	06f69c63          	bne	a3,a5,4cf8 <vTaskPriorityDisinheritAfterTimeout+0x178>
    4c84:	01812783          	lw	a5,24(sp)
    4c88:	00478793          	addi	a5,a5,4
    4c8c:	00078513          	mv	a0,a5
    4c90:	da5fb0ef          	jal	ra,a34 <uxListRemove>
    4c94:	01812783          	lw	a5,24(sp)
    4c98:	02c7a703          	lw	a4,44(a5)
    4c9c:	0001c797          	auipc	a5,0x1c
    4ca0:	a1478793          	addi	a5,a5,-1516 # 206b0 <uxTopReadyPriority>
    4ca4:	0007a783          	lw	a5,0(a5)
    4ca8:	00e7fc63          	bleu	a4,a5,4cc0 <vTaskPriorityDisinheritAfterTimeout+0x140>
    4cac:	01812783          	lw	a5,24(sp)
    4cb0:	02c7a703          	lw	a4,44(a5)
    4cb4:	0001c797          	auipc	a5,0x1c
    4cb8:	9fc78793          	addi	a5,a5,-1540 # 206b0 <uxTopReadyPriority>
    4cbc:	00e7a023          	sw	a4,0(a5)
    4cc0:	01812783          	lw	a5,24(sp)
    4cc4:	02c7a703          	lw	a4,44(a5)
    4cc8:	00070793          	mv	a5,a4
    4ccc:	00279793          	slli	a5,a5,0x2
    4cd0:	00e787b3          	add	a5,a5,a4
    4cd4:	00279793          	slli	a5,a5,0x2
    4cd8:	0001c717          	auipc	a4,0x1c
    4cdc:	92470713          	addi	a4,a4,-1756 # 205fc <pxReadyTasksLists>
    4ce0:	00e78733          	add	a4,a5,a4
    4ce4:	01812783          	lw	a5,24(sp)
    4ce8:	00478793          	addi	a5,a5,4
    4cec:	00078593          	mv	a1,a5
    4cf0:	00070513          	mv	a0,a4
    4cf4:	bfdfb0ef          	jal	ra,8f0 <vListInsertEnd>
    4cf8:	00000013          	nop
    4cfc:	02c12083          	lw	ra,44(sp)
    4d00:	03010113          	addi	sp,sp,48
    4d04:	00008067          	ret

00004d08 <vTaskEnterCritical>:
    4d08:	30047073          	csrci	mstatus,8
    4d0c:	0001c797          	auipc	a5,0x1c
    4d10:	9a878793          	addi	a5,a5,-1624 # 206b4 <xSchedulerRunning>
    4d14:	0007a783          	lw	a5,0(a5)
    4d18:	02078463          	beqz	a5,4d40 <vTaskEnterCritical+0x38>
    4d1c:	0001c797          	auipc	a5,0x1c
    4d20:	83478793          	addi	a5,a5,-1996 # 20550 <pxCurrentTCB>
    4d24:	0007a783          	lw	a5,0(a5)
    4d28:	0447a703          	lw	a4,68(a5)
    4d2c:	00170713          	addi	a4,a4,1
    4d30:	04e7a223          	sw	a4,68(a5)
    4d34:	0001c797          	auipc	a5,0x1c
    4d38:	81c78793          	addi	a5,a5,-2020 # 20550 <pxCurrentTCB>
    4d3c:	0007a783          	lw	a5,0(a5)
    4d40:	00000013          	nop
    4d44:	00008067          	ret

00004d48 <vTaskExitCritical>:
    4d48:	0001c797          	auipc	a5,0x1c
    4d4c:	96c78793          	addi	a5,a5,-1684 # 206b4 <xSchedulerRunning>
    4d50:	0007a783          	lw	a5,0(a5)
    4d54:	04078463          	beqz	a5,4d9c <vTaskExitCritical+0x54>
    4d58:	0001b797          	auipc	a5,0x1b
    4d5c:	7f878793          	addi	a5,a5,2040 # 20550 <pxCurrentTCB>
    4d60:	0007a783          	lw	a5,0(a5)
    4d64:	0447a783          	lw	a5,68(a5)
    4d68:	02078a63          	beqz	a5,4d9c <vTaskExitCritical+0x54>
    4d6c:	0001b797          	auipc	a5,0x1b
    4d70:	7e478793          	addi	a5,a5,2020 # 20550 <pxCurrentTCB>
    4d74:	0007a783          	lw	a5,0(a5)
    4d78:	0447a703          	lw	a4,68(a5)
    4d7c:	fff70713          	addi	a4,a4,-1
    4d80:	04e7a223          	sw	a4,68(a5)
    4d84:	0001b797          	auipc	a5,0x1b
    4d88:	7cc78793          	addi	a5,a5,1996 # 20550 <pxCurrentTCB>
    4d8c:	0007a783          	lw	a5,0(a5)
    4d90:	0447a783          	lw	a5,68(a5)
    4d94:	00079463          	bnez	a5,4d9c <vTaskExitCritical+0x54>
    4d98:	30046073          	csrsi	mstatus,8
    4d9c:	00000013          	nop
    4da0:	00008067          	ret

00004da4 <uxTaskResetEventItemValue>:
    4da4:	ff010113          	addi	sp,sp,-16
    4da8:	0001b797          	auipc	a5,0x1b
    4dac:	7a878793          	addi	a5,a5,1960 # 20550 <pxCurrentTCB>
    4db0:	0007a783          	lw	a5,0(a5)
    4db4:	0187a783          	lw	a5,24(a5)
    4db8:	00f12623          	sw	a5,12(sp)
    4dbc:	0001b797          	auipc	a5,0x1b
    4dc0:	79478793          	addi	a5,a5,1940 # 20550 <pxCurrentTCB>
    4dc4:	0007a783          	lw	a5,0(a5)
    4dc8:	02c7a703          	lw	a4,44(a5)
    4dcc:	0001b797          	auipc	a5,0x1b
    4dd0:	78478793          	addi	a5,a5,1924 # 20550 <pxCurrentTCB>
    4dd4:	0007a783          	lw	a5,0(a5)
    4dd8:	00500693          	li	a3,5
    4ddc:	40e68733          	sub	a4,a3,a4
    4de0:	00e7ac23          	sw	a4,24(a5)
    4de4:	00c12783          	lw	a5,12(sp)
    4de8:	00078513          	mv	a0,a5
    4dec:	01010113          	addi	sp,sp,16
    4df0:	00008067          	ret

00004df4 <pvTaskIncrementMutexHeldCount>:
    4df4:	0001b797          	auipc	a5,0x1b
    4df8:	75c78793          	addi	a5,a5,1884 # 20550 <pxCurrentTCB>
    4dfc:	0007a783          	lw	a5,0(a5)
    4e00:	00078e63          	beqz	a5,4e1c <pvTaskIncrementMutexHeldCount+0x28>
    4e04:	0001b797          	auipc	a5,0x1b
    4e08:	74c78793          	addi	a5,a5,1868 # 20550 <pxCurrentTCB>
    4e0c:	0007a783          	lw	a5,0(a5)
    4e10:	0547a703          	lw	a4,84(a5)
    4e14:	00170713          	addi	a4,a4,1
    4e18:	04e7aa23          	sw	a4,84(a5)
    4e1c:	0001b797          	auipc	a5,0x1b
    4e20:	73478793          	addi	a5,a5,1844 # 20550 <pxCurrentTCB>
    4e24:	0007a783          	lw	a5,0(a5)
    4e28:	00078513          	mv	a0,a5
    4e2c:	00008067          	ret

00004e30 <ulTaskNotifyTake>:
    4e30:	fd010113          	addi	sp,sp,-48
    4e34:	02112623          	sw	ra,44(sp)
    4e38:	00a12623          	sw	a0,12(sp)
    4e3c:	00b12423          	sw	a1,8(sp)
    4e40:	ec9ff0ef          	jal	ra,4d08 <vTaskEnterCritical>
    4e44:	0001b797          	auipc	a5,0x1b
    4e48:	70c78793          	addi	a5,a5,1804 # 20550 <pxCurrentTCB>
    4e4c:	0007a783          	lw	a5,0(a5)
    4e50:	0587a783          	lw	a5,88(a5)
    4e54:	02079863          	bnez	a5,4e84 <ulTaskNotifyTake+0x54>
    4e58:	0001b797          	auipc	a5,0x1b
    4e5c:	6f878793          	addi	a5,a5,1784 # 20550 <pxCurrentTCB>
    4e60:	0007a783          	lw	a5,0(a5)
    4e64:	00100713          	li	a4,1
    4e68:	04e78e23          	sb	a4,92(a5)
    4e6c:	00812783          	lw	a5,8(sp)
    4e70:	00078a63          	beqz	a5,4e84 <ulTaskNotifyTake+0x54>
    4e74:	00100593          	li	a1,1
    4e78:	00812503          	lw	a0,8(sp)
    4e7c:	7e8000ef          	jal	ra,5664 <prvAddCurrentTaskToDelayedList>
    4e80:	f14fb0ef          	jal	ra,594 <vPortYield>
    4e84:	ec5ff0ef          	jal	ra,4d48 <vTaskExitCritical>
    4e88:	e81ff0ef          	jal	ra,4d08 <vTaskEnterCritical>
    4e8c:	0001b797          	auipc	a5,0x1b
    4e90:	6c478793          	addi	a5,a5,1732 # 20550 <pxCurrentTCB>
    4e94:	0007a783          	lw	a5,0(a5)
    4e98:	0587a783          	lw	a5,88(a5)
    4e9c:	00f12e23          	sw	a5,28(sp)
    4ea0:	01c12783          	lw	a5,28(sp)
    4ea4:	02078c63          	beqz	a5,4edc <ulTaskNotifyTake+0xac>
    4ea8:	00c12783          	lw	a5,12(sp)
    4eac:	00078c63          	beqz	a5,4ec4 <ulTaskNotifyTake+0x94>
    4eb0:	0001b797          	auipc	a5,0x1b
    4eb4:	6a078793          	addi	a5,a5,1696 # 20550 <pxCurrentTCB>
    4eb8:	0007a783          	lw	a5,0(a5)
    4ebc:	0407ac23          	sw	zero,88(a5)
    4ec0:	01c0006f          	j	4edc <ulTaskNotifyTake+0xac>
    4ec4:	0001b797          	auipc	a5,0x1b
    4ec8:	68c78793          	addi	a5,a5,1676 # 20550 <pxCurrentTCB>
    4ecc:	0007a783          	lw	a5,0(a5)
    4ed0:	01c12703          	lw	a4,28(sp)
    4ed4:	fff70713          	addi	a4,a4,-1
    4ed8:	04e7ac23          	sw	a4,88(a5)
    4edc:	0001b797          	auipc	a5,0x1b
    4ee0:	67478793          	addi	a5,a5,1652 # 20550 <pxCurrentTCB>
    4ee4:	0007a783          	lw	a5,0(a5)
    4ee8:	04078e23          	sb	zero,92(a5)
    4eec:	e5dff0ef          	jal	ra,4d48 <vTaskExitCritical>
    4ef0:	01c12783          	lw	a5,28(sp)
    4ef4:	00078513          	mv	a0,a5
    4ef8:	02c12083          	lw	ra,44(sp)
    4efc:	03010113          	addi	sp,sp,48
    4f00:	00008067          	ret

00004f04 <xTaskNotifyWait>:
    4f04:	fd010113          	addi	sp,sp,-48
    4f08:	02112623          	sw	ra,44(sp)
    4f0c:	00a12623          	sw	a0,12(sp)
    4f10:	00b12423          	sw	a1,8(sp)
    4f14:	00c12223          	sw	a2,4(sp)
    4f18:	00d12023          	sw	a3,0(sp)
    4f1c:	dedff0ef          	jal	ra,4d08 <vTaskEnterCritical>
    4f20:	0001b797          	auipc	a5,0x1b
    4f24:	63078793          	addi	a5,a5,1584 # 20550 <pxCurrentTCB>
    4f28:	0007a783          	lw	a5,0(a5)
    4f2c:	05c7c783          	lbu	a5,92(a5)
    4f30:	0ff7f713          	andi	a4,a5,255
    4f34:	00200793          	li	a5,2
    4f38:	04f70863          	beq	a4,a5,4f88 <xTaskNotifyWait+0x84>
    4f3c:	0001b797          	auipc	a5,0x1b
    4f40:	61478793          	addi	a5,a5,1556 # 20550 <pxCurrentTCB>
    4f44:	0007a783          	lw	a5,0(a5)
    4f48:	0587a683          	lw	a3,88(a5)
    4f4c:	00c12703          	lw	a4,12(sp)
    4f50:	fff74713          	not	a4,a4
    4f54:	00e6f733          	and	a4,a3,a4
    4f58:	04e7ac23          	sw	a4,88(a5)
    4f5c:	0001b797          	auipc	a5,0x1b
    4f60:	5f478793          	addi	a5,a5,1524 # 20550 <pxCurrentTCB>
    4f64:	0007a783          	lw	a5,0(a5)
    4f68:	00100713          	li	a4,1
    4f6c:	04e78e23          	sb	a4,92(a5)
    4f70:	00012783          	lw	a5,0(sp)
    4f74:	00078a63          	beqz	a5,4f88 <xTaskNotifyWait+0x84>
    4f78:	00100593          	li	a1,1
    4f7c:	00012503          	lw	a0,0(sp)
    4f80:	6e4000ef          	jal	ra,5664 <prvAddCurrentTaskToDelayedList>
    4f84:	e10fb0ef          	jal	ra,594 <vPortYield>
    4f88:	dc1ff0ef          	jal	ra,4d48 <vTaskExitCritical>
    4f8c:	d7dff0ef          	jal	ra,4d08 <vTaskEnterCritical>
    4f90:	00412783          	lw	a5,4(sp)
    4f94:	00078e63          	beqz	a5,4fb0 <xTaskNotifyWait+0xac>
    4f98:	0001b797          	auipc	a5,0x1b
    4f9c:	5b878793          	addi	a5,a5,1464 # 20550 <pxCurrentTCB>
    4fa0:	0007a783          	lw	a5,0(a5)
    4fa4:	0587a703          	lw	a4,88(a5)
    4fa8:	00412783          	lw	a5,4(sp)
    4fac:	00e7a023          	sw	a4,0(a5)
    4fb0:	0001b797          	auipc	a5,0x1b
    4fb4:	5a078793          	addi	a5,a5,1440 # 20550 <pxCurrentTCB>
    4fb8:	0007a783          	lw	a5,0(a5)
    4fbc:	05c7c783          	lbu	a5,92(a5)
    4fc0:	0ff7f713          	andi	a4,a5,255
    4fc4:	00200793          	li	a5,2
    4fc8:	00f70663          	beq	a4,a5,4fd4 <xTaskNotifyWait+0xd0>
    4fcc:	00012e23          	sw	zero,28(sp)
    4fd0:	02c0006f          	j	4ffc <xTaskNotifyWait+0xf8>
    4fd4:	0001b797          	auipc	a5,0x1b
    4fd8:	57c78793          	addi	a5,a5,1404 # 20550 <pxCurrentTCB>
    4fdc:	0007a783          	lw	a5,0(a5)
    4fe0:	0587a683          	lw	a3,88(a5)
    4fe4:	00812703          	lw	a4,8(sp)
    4fe8:	fff74713          	not	a4,a4
    4fec:	00e6f733          	and	a4,a3,a4
    4ff0:	04e7ac23          	sw	a4,88(a5)
    4ff4:	00100793          	li	a5,1
    4ff8:	00f12e23          	sw	a5,28(sp)
    4ffc:	0001b797          	auipc	a5,0x1b
    5000:	55478793          	addi	a5,a5,1364 # 20550 <pxCurrentTCB>
    5004:	0007a783          	lw	a5,0(a5)
    5008:	04078e23          	sb	zero,92(a5)
    500c:	d3dff0ef          	jal	ra,4d48 <vTaskExitCritical>
    5010:	01c12783          	lw	a5,28(sp)
    5014:	00078513          	mv	a0,a5
    5018:	02c12083          	lw	ra,44(sp)
    501c:	03010113          	addi	sp,sp,48
    5020:	00008067          	ret

00005024 <xTaskGenericNotify>:
    5024:	fd010113          	addi	sp,sp,-48
    5028:	02112623          	sw	ra,44(sp)
    502c:	00a12623          	sw	a0,12(sp)
    5030:	00b12423          	sw	a1,8(sp)
    5034:	00c12223          	sw	a2,4(sp)
    5038:	00d12023          	sw	a3,0(sp)
    503c:	00100793          	li	a5,1
    5040:	00f12e23          	sw	a5,28(sp)
    5044:	00c12783          	lw	a5,12(sp)
    5048:	00079663          	bnez	a5,5054 <xTaskGenericNotify+0x30>
    504c:	30047073          	csrci	mstatus,8
    5050:	0000006f          	j	5050 <xTaskGenericNotify+0x2c>
    5054:	00c12783          	lw	a5,12(sp)
    5058:	00f12c23          	sw	a5,24(sp)
    505c:	cadff0ef          	jal	ra,4d08 <vTaskEnterCritical>
    5060:	00012783          	lw	a5,0(sp)
    5064:	00078a63          	beqz	a5,5078 <xTaskGenericNotify+0x54>
    5068:	01812783          	lw	a5,24(sp)
    506c:	0587a703          	lw	a4,88(a5)
    5070:	00012783          	lw	a5,0(sp)
    5074:	00e7a023          	sw	a4,0(a5)
    5078:	01812783          	lw	a5,24(sp)
    507c:	05c7c783          	lbu	a5,92(a5)
    5080:	00f10ba3          	sb	a5,23(sp)
    5084:	01812783          	lw	a5,24(sp)
    5088:	00200713          	li	a4,2
    508c:	04e78e23          	sb	a4,92(a5)
    5090:	00412703          	lw	a4,4(sp)
    5094:	00400793          	li	a5,4
    5098:	08e7ea63          	bltu	a5,a4,512c <xTaskGenericNotify+0x108>
    509c:	00412783          	lw	a5,4(sp)
    50a0:	00279713          	slli	a4,a5,0x2
    50a4:	0001b797          	auipc	a5,0x1b
    50a8:	f6478793          	addi	a5,a5,-156 # 20008 <__rodata_start+0x8>
    50ac:	00f707b3          	add	a5,a4,a5
    50b0:	0007a703          	lw	a4,0(a5)
    50b4:	0001b797          	auipc	a5,0x1b
    50b8:	f5478793          	addi	a5,a5,-172 # 20008 <__rodata_start+0x8>
    50bc:	00f707b3          	add	a5,a4,a5
    50c0:	00078067          	jr	a5
    50c4:	01812783          	lw	a5,24(sp)
    50c8:	0587a703          	lw	a4,88(a5)
    50cc:	00812783          	lw	a5,8(sp)
    50d0:	00f76733          	or	a4,a4,a5
    50d4:	01812783          	lw	a5,24(sp)
    50d8:	04e7ac23          	sw	a4,88(a5)
    50dc:	0740006f          	j	5150 <xTaskGenericNotify+0x12c>
    50e0:	01812783          	lw	a5,24(sp)
    50e4:	0587a783          	lw	a5,88(a5)
    50e8:	00178713          	addi	a4,a5,1
    50ec:	01812783          	lw	a5,24(sp)
    50f0:	04e7ac23          	sw	a4,88(a5)
    50f4:	05c0006f          	j	5150 <xTaskGenericNotify+0x12c>
    50f8:	01812783          	lw	a5,24(sp)
    50fc:	00812703          	lw	a4,8(sp)
    5100:	04e7ac23          	sw	a4,88(a5)
    5104:	04c0006f          	j	5150 <xTaskGenericNotify+0x12c>
    5108:	01714703          	lbu	a4,23(sp)
    510c:	00200793          	li	a5,2
    5110:	00f70a63          	beq	a4,a5,5124 <xTaskGenericNotify+0x100>
    5114:	01812783          	lw	a5,24(sp)
    5118:	00812703          	lw	a4,8(sp)
    511c:	04e7ac23          	sw	a4,88(a5)
    5120:	0300006f          	j	5150 <xTaskGenericNotify+0x12c>
    5124:	00012e23          	sw	zero,28(sp)
    5128:	0280006f          	j	5150 <xTaskGenericNotify+0x12c>
    512c:	01812783          	lw	a5,24(sp)
    5130:	0587a703          	lw	a4,88(a5)
    5134:	fff00793          	li	a5,-1
    5138:	00f70a63          	beq	a4,a5,514c <xTaskGenericNotify+0x128>
    513c:	30047073          	csrci	mstatus,8
    5140:	0000006f          	j	5140 <xTaskGenericNotify+0x11c>
    5144:	00000013          	nop
    5148:	0080006f          	j	5150 <xTaskGenericNotify+0x12c>
    514c:	00000013          	nop
    5150:	01714703          	lbu	a4,23(sp)
    5154:	00100793          	li	a5,1
    5158:	0af71663          	bne	a4,a5,5204 <xTaskGenericNotify+0x1e0>
    515c:	01812783          	lw	a5,24(sp)
    5160:	00478793          	addi	a5,a5,4
    5164:	00078513          	mv	a0,a5
    5168:	8cdfb0ef          	jal	ra,a34 <uxListRemove>
    516c:	01812783          	lw	a5,24(sp)
    5170:	02c7a703          	lw	a4,44(a5)
    5174:	0001b797          	auipc	a5,0x1b
    5178:	53c78793          	addi	a5,a5,1340 # 206b0 <uxTopReadyPriority>
    517c:	0007a783          	lw	a5,0(a5)
    5180:	00e7fc63          	bleu	a4,a5,5198 <xTaskGenericNotify+0x174>
    5184:	01812783          	lw	a5,24(sp)
    5188:	02c7a703          	lw	a4,44(a5)
    518c:	0001b797          	auipc	a5,0x1b
    5190:	52478793          	addi	a5,a5,1316 # 206b0 <uxTopReadyPriority>
    5194:	00e7a023          	sw	a4,0(a5)
    5198:	01812783          	lw	a5,24(sp)
    519c:	02c7a703          	lw	a4,44(a5)
    51a0:	00070793          	mv	a5,a4
    51a4:	00279793          	slli	a5,a5,0x2
    51a8:	00e787b3          	add	a5,a5,a4
    51ac:	00279793          	slli	a5,a5,0x2
    51b0:	0001b717          	auipc	a4,0x1b
    51b4:	44c70713          	addi	a4,a4,1100 # 205fc <pxReadyTasksLists>
    51b8:	00e78733          	add	a4,a5,a4
    51bc:	01812783          	lw	a5,24(sp)
    51c0:	00478793          	addi	a5,a5,4
    51c4:	00078593          	mv	a1,a5
    51c8:	00070513          	mv	a0,a4
    51cc:	f24fb0ef          	jal	ra,8f0 <vListInsertEnd>
    51d0:	01812783          	lw	a5,24(sp)
    51d4:	0287a783          	lw	a5,40(a5)
    51d8:	00078663          	beqz	a5,51e4 <xTaskGenericNotify+0x1c0>
    51dc:	30047073          	csrci	mstatus,8
    51e0:	0000006f          	j	51e0 <xTaskGenericNotify+0x1bc>
    51e4:	01812783          	lw	a5,24(sp)
    51e8:	02c7a703          	lw	a4,44(a5)
    51ec:	0001b797          	auipc	a5,0x1b
    51f0:	36478793          	addi	a5,a5,868 # 20550 <pxCurrentTCB>
    51f4:	0007a783          	lw	a5,0(a5)
    51f8:	02c7a783          	lw	a5,44(a5)
    51fc:	00e7f463          	bleu	a4,a5,5204 <xTaskGenericNotify+0x1e0>
    5200:	b94fb0ef          	jal	ra,594 <vPortYield>
    5204:	b45ff0ef          	jal	ra,4d48 <vTaskExitCritical>
    5208:	01c12783          	lw	a5,28(sp)
    520c:	00078513          	mv	a0,a5
    5210:	02c12083          	lw	ra,44(sp)
    5214:	03010113          	addi	sp,sp,48
    5218:	00008067          	ret

0000521c <xTaskGenericNotifyFromISR>:
    521c:	fc010113          	addi	sp,sp,-64
    5220:	02112e23          	sw	ra,60(sp)
    5224:	00a12e23          	sw	a0,28(sp)
    5228:	00b12c23          	sw	a1,24(sp)
    522c:	00c12a23          	sw	a2,20(sp)
    5230:	00d12823          	sw	a3,16(sp)
    5234:	00e12623          	sw	a4,12(sp)
    5238:	00100793          	li	a5,1
    523c:	02f12623          	sw	a5,44(sp)
    5240:	01c12783          	lw	a5,28(sp)
    5244:	00079663          	bnez	a5,5250 <xTaskGenericNotifyFromISR+0x34>
    5248:	30047073          	csrci	mstatus,8
    524c:	0000006f          	j	524c <xTaskGenericNotifyFromISR+0x30>
    5250:	01c12783          	lw	a5,28(sp)
    5254:	02f12423          	sw	a5,40(sp)
    5258:	d50fb0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    525c:	00050793          	mv	a5,a0
    5260:	02f12223          	sw	a5,36(sp)
    5264:	01012783          	lw	a5,16(sp)
    5268:	00078a63          	beqz	a5,527c <xTaskGenericNotifyFromISR+0x60>
    526c:	02812783          	lw	a5,40(sp)
    5270:	0587a703          	lw	a4,88(a5)
    5274:	01012783          	lw	a5,16(sp)
    5278:	00e7a023          	sw	a4,0(a5)
    527c:	02812783          	lw	a5,40(sp)
    5280:	05c7c783          	lbu	a5,92(a5)
    5284:	02f101a3          	sb	a5,35(sp)
    5288:	02812783          	lw	a5,40(sp)
    528c:	00200713          	li	a4,2
    5290:	04e78e23          	sb	a4,92(a5)
    5294:	01412703          	lw	a4,20(sp)
    5298:	00400793          	li	a5,4
    529c:	08e7ea63          	bltu	a5,a4,5330 <xTaskGenericNotifyFromISR+0x114>
    52a0:	01412783          	lw	a5,20(sp)
    52a4:	00279713          	slli	a4,a5,0x2
    52a8:	0001b797          	auipc	a5,0x1b
    52ac:	d7478793          	addi	a5,a5,-652 # 2001c <__rodata_start+0x1c>
    52b0:	00f707b3          	add	a5,a4,a5
    52b4:	0007a703          	lw	a4,0(a5)
    52b8:	0001b797          	auipc	a5,0x1b
    52bc:	d6478793          	addi	a5,a5,-668 # 2001c <__rodata_start+0x1c>
    52c0:	00f707b3          	add	a5,a4,a5
    52c4:	00078067          	jr	a5
    52c8:	02812783          	lw	a5,40(sp)
    52cc:	0587a703          	lw	a4,88(a5)
    52d0:	01812783          	lw	a5,24(sp)
    52d4:	00f76733          	or	a4,a4,a5
    52d8:	02812783          	lw	a5,40(sp)
    52dc:	04e7ac23          	sw	a4,88(a5)
    52e0:	0740006f          	j	5354 <xTaskGenericNotifyFromISR+0x138>
    52e4:	02812783          	lw	a5,40(sp)
    52e8:	0587a783          	lw	a5,88(a5)
    52ec:	00178713          	addi	a4,a5,1
    52f0:	02812783          	lw	a5,40(sp)
    52f4:	04e7ac23          	sw	a4,88(a5)
    52f8:	05c0006f          	j	5354 <xTaskGenericNotifyFromISR+0x138>
    52fc:	02812783          	lw	a5,40(sp)
    5300:	01812703          	lw	a4,24(sp)
    5304:	04e7ac23          	sw	a4,88(a5)
    5308:	04c0006f          	j	5354 <xTaskGenericNotifyFromISR+0x138>
    530c:	02314703          	lbu	a4,35(sp)
    5310:	00200793          	li	a5,2
    5314:	00f70a63          	beq	a4,a5,5328 <xTaskGenericNotifyFromISR+0x10c>
    5318:	02812783          	lw	a5,40(sp)
    531c:	01812703          	lw	a4,24(sp)
    5320:	04e7ac23          	sw	a4,88(a5)
    5324:	0300006f          	j	5354 <xTaskGenericNotifyFromISR+0x138>
    5328:	02012623          	sw	zero,44(sp)
    532c:	0280006f          	j	5354 <xTaskGenericNotifyFromISR+0x138>
    5330:	02812783          	lw	a5,40(sp)
    5334:	0587a703          	lw	a4,88(a5)
    5338:	fff00793          	li	a5,-1
    533c:	00f70a63          	beq	a4,a5,5350 <xTaskGenericNotifyFromISR+0x134>
    5340:	30047073          	csrci	mstatus,8
    5344:	0000006f          	j	5344 <xTaskGenericNotifyFromISR+0x128>
    5348:	00000013          	nop
    534c:	0080006f          	j	5354 <xTaskGenericNotifyFromISR+0x138>
    5350:	00000013          	nop
    5354:	02314703          	lbu	a4,35(sp)
    5358:	00100793          	li	a5,1
    535c:	0ef71c63          	bne	a4,a5,5454 <xTaskGenericNotifyFromISR+0x238>
    5360:	02812783          	lw	a5,40(sp)
    5364:	0287a783          	lw	a5,40(a5)
    5368:	00078663          	beqz	a5,5374 <xTaskGenericNotifyFromISR+0x158>
    536c:	30047073          	csrci	mstatus,8
    5370:	0000006f          	j	5370 <xTaskGenericNotifyFromISR+0x154>
    5374:	0001b797          	auipc	a5,0x1b
    5378:	35c78793          	addi	a5,a5,860 # 206d0 <uxSchedulerSuspended>
    537c:	0007a783          	lw	a5,0(a5)
    5380:	06079e63          	bnez	a5,53fc <xTaskGenericNotifyFromISR+0x1e0>
    5384:	02812783          	lw	a5,40(sp)
    5388:	00478793          	addi	a5,a5,4
    538c:	00078513          	mv	a0,a5
    5390:	ea4fb0ef          	jal	ra,a34 <uxListRemove>
    5394:	02812783          	lw	a5,40(sp)
    5398:	02c7a703          	lw	a4,44(a5)
    539c:	0001b797          	auipc	a5,0x1b
    53a0:	31478793          	addi	a5,a5,788 # 206b0 <uxTopReadyPriority>
    53a4:	0007a783          	lw	a5,0(a5)
    53a8:	00e7fc63          	bleu	a4,a5,53c0 <xTaskGenericNotifyFromISR+0x1a4>
    53ac:	02812783          	lw	a5,40(sp)
    53b0:	02c7a703          	lw	a4,44(a5)
    53b4:	0001b797          	auipc	a5,0x1b
    53b8:	2fc78793          	addi	a5,a5,764 # 206b0 <uxTopReadyPriority>
    53bc:	00e7a023          	sw	a4,0(a5)
    53c0:	02812783          	lw	a5,40(sp)
    53c4:	02c7a703          	lw	a4,44(a5)
    53c8:	00070793          	mv	a5,a4
    53cc:	00279793          	slli	a5,a5,0x2
    53d0:	00e787b3          	add	a5,a5,a4
    53d4:	00279793          	slli	a5,a5,0x2
    53d8:	0001b717          	auipc	a4,0x1b
    53dc:	22470713          	addi	a4,a4,548 # 205fc <pxReadyTasksLists>
    53e0:	00e78733          	add	a4,a5,a4
    53e4:	02812783          	lw	a5,40(sp)
    53e8:	00478793          	addi	a5,a5,4
    53ec:	00078593          	mv	a1,a5
    53f0:	00070513          	mv	a0,a4
    53f4:	cfcfb0ef          	jal	ra,8f0 <vListInsertEnd>
    53f8:	01c0006f          	j	5414 <xTaskGenericNotifyFromISR+0x1f8>
    53fc:	02812783          	lw	a5,40(sp)
    5400:	01878793          	addi	a5,a5,24
    5404:	00078593          	mv	a1,a5
    5408:	0001b517          	auipc	a0,0x1b
    540c:	26050513          	addi	a0,a0,608 # 20668 <xPendingReadyList>
    5410:	ce0fb0ef          	jal	ra,8f0 <vListInsertEnd>
    5414:	02812783          	lw	a5,40(sp)
    5418:	02c7a703          	lw	a4,44(a5)
    541c:	0001b797          	auipc	a5,0x1b
    5420:	13478793          	addi	a5,a5,308 # 20550 <pxCurrentTCB>
    5424:	0007a783          	lw	a5,0(a5)
    5428:	02c7a783          	lw	a5,44(a5)
    542c:	02e7f463          	bleu	a4,a5,5454 <xTaskGenericNotifyFromISR+0x238>
    5430:	00c12783          	lw	a5,12(sp)
    5434:	00078863          	beqz	a5,5444 <xTaskGenericNotifyFromISR+0x228>
    5438:	00c12783          	lw	a5,12(sp)
    543c:	00100713          	li	a4,1
    5440:	00e7a023          	sw	a4,0(a5)
    5444:	0001b797          	auipc	a5,0x1b
    5448:	27878793          	addi	a5,a5,632 # 206bc <xYieldPending>
    544c:	00100713          	li	a4,1
    5450:	00e7a023          	sw	a4,0(a5)
    5454:	02412783          	lw	a5,36(sp)
    5458:	00078513          	mv	a0,a5
    545c:	b30fb0ef          	jal	ra,78c <vPortClearInterruptMask>
    5460:	02c12783          	lw	a5,44(sp)
    5464:	00078513          	mv	a0,a5
    5468:	03c12083          	lw	ra,60(sp)
    546c:	04010113          	addi	sp,sp,64
    5470:	00008067          	ret

00005474 <vTaskNotifyGiveFromISR>:
    5474:	fd010113          	addi	sp,sp,-48
    5478:	02112623          	sw	ra,44(sp)
    547c:	00a12623          	sw	a0,12(sp)
    5480:	00b12423          	sw	a1,8(sp)
    5484:	00c12783          	lw	a5,12(sp)
    5488:	00079663          	bnez	a5,5494 <vTaskNotifyGiveFromISR+0x20>
    548c:	30047073          	csrci	mstatus,8
    5490:	0000006f          	j	5490 <vTaskNotifyGiveFromISR+0x1c>
    5494:	00c12783          	lw	a5,12(sp)
    5498:	00f12e23          	sw	a5,28(sp)
    549c:	b0cfb0ef          	jal	ra,7a8 <vPortSetInterruptMask>
    54a0:	00050793          	mv	a5,a0
    54a4:	00f12c23          	sw	a5,24(sp)
    54a8:	01c12783          	lw	a5,28(sp)
    54ac:	05c7c783          	lbu	a5,92(a5)
    54b0:	00f10ba3          	sb	a5,23(sp)
    54b4:	01c12783          	lw	a5,28(sp)
    54b8:	00200713          	li	a4,2
    54bc:	04e78e23          	sb	a4,92(a5)
    54c0:	01c12783          	lw	a5,28(sp)
    54c4:	0587a783          	lw	a5,88(a5)
    54c8:	00178713          	addi	a4,a5,1
    54cc:	01c12783          	lw	a5,28(sp)
    54d0:	04e7ac23          	sw	a4,88(a5)
    54d4:	01714703          	lbu	a4,23(sp)
    54d8:	00100793          	li	a5,1
    54dc:	0ef71c63          	bne	a4,a5,55d4 <vTaskNotifyGiveFromISR+0x160>
    54e0:	01c12783          	lw	a5,28(sp)
    54e4:	0287a783          	lw	a5,40(a5)
    54e8:	00078663          	beqz	a5,54f4 <vTaskNotifyGiveFromISR+0x80>
    54ec:	30047073          	csrci	mstatus,8
    54f0:	0000006f          	j	54f0 <vTaskNotifyGiveFromISR+0x7c>
    54f4:	0001b797          	auipc	a5,0x1b
    54f8:	1dc78793          	addi	a5,a5,476 # 206d0 <uxSchedulerSuspended>
    54fc:	0007a783          	lw	a5,0(a5)
    5500:	06079e63          	bnez	a5,557c <vTaskNotifyGiveFromISR+0x108>
    5504:	01c12783          	lw	a5,28(sp)
    5508:	00478793          	addi	a5,a5,4
    550c:	00078513          	mv	a0,a5
    5510:	d24fb0ef          	jal	ra,a34 <uxListRemove>
    5514:	01c12783          	lw	a5,28(sp)
    5518:	02c7a703          	lw	a4,44(a5)
    551c:	0001b797          	auipc	a5,0x1b
    5520:	19478793          	addi	a5,a5,404 # 206b0 <uxTopReadyPriority>
    5524:	0007a783          	lw	a5,0(a5)
    5528:	00e7fc63          	bleu	a4,a5,5540 <vTaskNotifyGiveFromISR+0xcc>
    552c:	01c12783          	lw	a5,28(sp)
    5530:	02c7a703          	lw	a4,44(a5)
    5534:	0001b797          	auipc	a5,0x1b
    5538:	17c78793          	addi	a5,a5,380 # 206b0 <uxTopReadyPriority>
    553c:	00e7a023          	sw	a4,0(a5)
    5540:	01c12783          	lw	a5,28(sp)
    5544:	02c7a703          	lw	a4,44(a5)
    5548:	00070793          	mv	a5,a4
    554c:	00279793          	slli	a5,a5,0x2
    5550:	00e787b3          	add	a5,a5,a4
    5554:	00279793          	slli	a5,a5,0x2
    5558:	0001b717          	auipc	a4,0x1b
    555c:	0a470713          	addi	a4,a4,164 # 205fc <pxReadyTasksLists>
    5560:	00e78733          	add	a4,a5,a4
    5564:	01c12783          	lw	a5,28(sp)
    5568:	00478793          	addi	a5,a5,4
    556c:	00078593          	mv	a1,a5
    5570:	00070513          	mv	a0,a4
    5574:	b7cfb0ef          	jal	ra,8f0 <vListInsertEnd>
    5578:	01c0006f          	j	5594 <vTaskNotifyGiveFromISR+0x120>
    557c:	01c12783          	lw	a5,28(sp)
    5580:	01878793          	addi	a5,a5,24
    5584:	00078593          	mv	a1,a5
    5588:	0001b517          	auipc	a0,0x1b
    558c:	0e050513          	addi	a0,a0,224 # 20668 <xPendingReadyList>
    5590:	b60fb0ef          	jal	ra,8f0 <vListInsertEnd>
    5594:	01c12783          	lw	a5,28(sp)
    5598:	02c7a703          	lw	a4,44(a5)
    559c:	0001b797          	auipc	a5,0x1b
    55a0:	fb478793          	addi	a5,a5,-76 # 20550 <pxCurrentTCB>
    55a4:	0007a783          	lw	a5,0(a5)
    55a8:	02c7a783          	lw	a5,44(a5)
    55ac:	02e7f463          	bleu	a4,a5,55d4 <vTaskNotifyGiveFromISR+0x160>
    55b0:	00812783          	lw	a5,8(sp)
    55b4:	00078863          	beqz	a5,55c4 <vTaskNotifyGiveFromISR+0x150>
    55b8:	00812783          	lw	a5,8(sp)
    55bc:	00100713          	li	a4,1
    55c0:	00e7a023          	sw	a4,0(a5)
    55c4:	0001b797          	auipc	a5,0x1b
    55c8:	0f878793          	addi	a5,a5,248 # 206bc <xYieldPending>
    55cc:	00100713          	li	a4,1
    55d0:	00e7a023          	sw	a4,0(a5)
    55d4:	01812783          	lw	a5,24(sp)
    55d8:	00078513          	mv	a0,a5
    55dc:	9b0fb0ef          	jal	ra,78c <vPortClearInterruptMask>
    55e0:	00000013          	nop
    55e4:	02c12083          	lw	ra,44(sp)
    55e8:	03010113          	addi	sp,sp,48
    55ec:	00008067          	ret

000055f0 <xTaskNotifyStateClear>:
    55f0:	fd010113          	addi	sp,sp,-48
    55f4:	02112623          	sw	ra,44(sp)
    55f8:	00a12623          	sw	a0,12(sp)
    55fc:	00c12783          	lw	a5,12(sp)
    5600:	00079a63          	bnez	a5,5614 <xTaskNotifyStateClear+0x24>
    5604:	0001b797          	auipc	a5,0x1b
    5608:	f4c78793          	addi	a5,a5,-180 # 20550 <pxCurrentTCB>
    560c:	0007a783          	lw	a5,0(a5)
    5610:	0080006f          	j	5618 <xTaskNotifyStateClear+0x28>
    5614:	00c12783          	lw	a5,12(sp)
    5618:	00f12c23          	sw	a5,24(sp)
    561c:	eecff0ef          	jal	ra,4d08 <vTaskEnterCritical>
    5620:	01812783          	lw	a5,24(sp)
    5624:	05c7c783          	lbu	a5,92(a5)
    5628:	0ff7f713          	andi	a4,a5,255
    562c:	00200793          	li	a5,2
    5630:	00f71c63          	bne	a4,a5,5648 <xTaskNotifyStateClear+0x58>
    5634:	01812783          	lw	a5,24(sp)
    5638:	04078e23          	sb	zero,92(a5)
    563c:	00100793          	li	a5,1
    5640:	00f12e23          	sw	a5,28(sp)
    5644:	0080006f          	j	564c <xTaskNotifyStateClear+0x5c>
    5648:	00012e23          	sw	zero,28(sp)
    564c:	efcff0ef          	jal	ra,4d48 <vTaskExitCritical>
    5650:	01c12783          	lw	a5,28(sp)
    5654:	00078513          	mv	a0,a5
    5658:	02c12083          	lw	ra,44(sp)
    565c:	03010113          	addi	sp,sp,48
    5660:	00008067          	ret

00005664 <prvAddCurrentTaskToDelayedList>:
    5664:	fd010113          	addi	sp,sp,-48
    5668:	02112623          	sw	ra,44(sp)
    566c:	00a12623          	sw	a0,12(sp)
    5670:	00b12423          	sw	a1,8(sp)
    5674:	0001b797          	auipc	a5,0x1b
    5678:	03878793          	addi	a5,a5,56 # 206ac <xTickCount>
    567c:	0007a783          	lw	a5,0(a5)
    5680:	00f12e23          	sw	a5,28(sp)
    5684:	0001b797          	auipc	a5,0x1b
    5688:	ecc78793          	addi	a5,a5,-308 # 20550 <pxCurrentTCB>
    568c:	0007a783          	lw	a5,0(a5)
    5690:	00478793          	addi	a5,a5,4
    5694:	00078513          	mv	a0,a5
    5698:	b9cfb0ef          	jal	ra,a34 <uxListRemove>
    569c:	00c12703          	lw	a4,12(sp)
    56a0:	fff00793          	li	a5,-1
    56a4:	02f71863          	bne	a4,a5,56d4 <prvAddCurrentTaskToDelayedList+0x70>
    56a8:	00812783          	lw	a5,8(sp)
    56ac:	02078463          	beqz	a5,56d4 <prvAddCurrentTaskToDelayedList+0x70>
    56b0:	0001b797          	auipc	a5,0x1b
    56b4:	ea078793          	addi	a5,a5,-352 # 20550 <pxCurrentTCB>
    56b8:	0007a783          	lw	a5,0(a5)
    56bc:	00478793          	addi	a5,a5,4
    56c0:	00078593          	mv	a1,a5
    56c4:	0001b517          	auipc	a0,0x1b
    56c8:	fd050513          	addi	a0,a0,-48 # 20694 <xSuspendedTaskList>
    56cc:	a24fb0ef          	jal	ra,8f0 <vListInsertEnd>
    56d0:	0ac0006f          	j	577c <prvAddCurrentTaskToDelayedList+0x118>
    56d4:	01c12703          	lw	a4,28(sp)
    56d8:	00c12783          	lw	a5,12(sp)
    56dc:	00f707b3          	add	a5,a4,a5
    56e0:	00f12c23          	sw	a5,24(sp)
    56e4:	0001b797          	auipc	a5,0x1b
    56e8:	e6c78793          	addi	a5,a5,-404 # 20550 <pxCurrentTCB>
    56ec:	0007a783          	lw	a5,0(a5)
    56f0:	01812703          	lw	a4,24(sp)
    56f4:	00e7a223          	sw	a4,4(a5)
    56f8:	01812703          	lw	a4,24(sp)
    56fc:	01c12783          	lw	a5,28(sp)
    5700:	02f77863          	bleu	a5,a4,5730 <prvAddCurrentTaskToDelayedList+0xcc>
    5704:	0001b797          	auipc	a5,0x1b
    5708:	f6078793          	addi	a5,a5,-160 # 20664 <pxOverflowDelayedTaskList>
    570c:	0007a703          	lw	a4,0(a5)
    5710:	0001b797          	auipc	a5,0x1b
    5714:	e4078793          	addi	a5,a5,-448 # 20550 <pxCurrentTCB>
    5718:	0007a783          	lw	a5,0(a5)
    571c:	00478793          	addi	a5,a5,4
    5720:	00078593          	mv	a1,a5
    5724:	00070513          	mv	a0,a4
    5728:	a44fb0ef          	jal	ra,96c <vListInsert>
    572c:	0500006f          	j	577c <prvAddCurrentTaskToDelayedList+0x118>
    5730:	0001b797          	auipc	a5,0x1b
    5734:	f3078793          	addi	a5,a5,-208 # 20660 <pxDelayedTaskList>
    5738:	0007a703          	lw	a4,0(a5)
    573c:	0001b797          	auipc	a5,0x1b
    5740:	e1478793          	addi	a5,a5,-492 # 20550 <pxCurrentTCB>
    5744:	0007a783          	lw	a5,0(a5)
    5748:	00478793          	addi	a5,a5,4
    574c:	00078593          	mv	a1,a5
    5750:	00070513          	mv	a0,a4
    5754:	a18fb0ef          	jal	ra,96c <vListInsert>
    5758:	0001b797          	auipc	a5,0x1b
    575c:	f7078793          	addi	a5,a5,-144 # 206c8 <xNextTaskUnblockTime>
    5760:	0007a783          	lw	a5,0(a5)
    5764:	01812703          	lw	a4,24(sp)
    5768:	00f77a63          	bleu	a5,a4,577c <prvAddCurrentTaskToDelayedList+0x118>
    576c:	0001b797          	auipc	a5,0x1b
    5770:	f5c78793          	addi	a5,a5,-164 # 206c8 <xNextTaskUnblockTime>
    5774:	01812703          	lw	a4,24(sp)
    5778:	00e7a023          	sw	a4,0(a5)
    577c:	00000013          	nop
    5780:	02c12083          	lw	ra,44(sp)
    5784:	03010113          	addi	sp,sp,48
    5788:	00008067          	ret

0000578c <xTimerCreateTimerTask>:
    578c:	fe010113          	addi	sp,sp,-32
    5790:	00112e23          	sw	ra,28(sp)
    5794:	00012623          	sw	zero,12(sp)
    5798:	191000ef          	jal	ra,6128 <prvCheckForValidListAndQueue>
    579c:	0001b797          	auipc	a5,0x1b
    57a0:	f6878793          	addi	a5,a5,-152 # 20704 <xTimerQueue>
    57a4:	0007a783          	lw	a5,0(a5)
    57a8:	02078863          	beqz	a5,57d8 <xTimerCreateTimerTask+0x4c>
    57ac:	0001b797          	auipc	a5,0x1b
    57b0:	f5c78793          	addi	a5,a5,-164 # 20708 <xTimerTaskHandle>
    57b4:	00200713          	li	a4,2
    57b8:	00000693          	li	a3,0
    57bc:	40000613          	li	a2,1024
    57c0:	0001b597          	auipc	a1,0x1b
    57c4:	87058593          	addi	a1,a1,-1936 # 20030 <__rodata_start+0x30>
    57c8:	00000517          	auipc	a0,0x0
    57cc:	3c450513          	addi	a0,a0,964 # 5b8c <prvTimerTask>
    57d0:	d65fc0ef          	jal	ra,2534 <xTaskCreate>
    57d4:	00a12623          	sw	a0,12(sp)
    57d8:	00c12783          	lw	a5,12(sp)
    57dc:	00079663          	bnez	a5,57e8 <xTimerCreateTimerTask+0x5c>
    57e0:	30047073          	csrci	mstatus,8
    57e4:	0000006f          	j	57e4 <xTimerCreateTimerTask+0x58>
    57e8:	00c12783          	lw	a5,12(sp)
    57ec:	00078513          	mv	a0,a5
    57f0:	01c12083          	lw	ra,28(sp)
    57f4:	02010113          	addi	sp,sp,32
    57f8:	00008067          	ret

000057fc <xTimerCreate>:
    57fc:	fc010113          	addi	sp,sp,-64
    5800:	02112e23          	sw	ra,60(sp)
    5804:	00a12e23          	sw	a0,28(sp)
    5808:	00b12c23          	sw	a1,24(sp)
    580c:	00c12a23          	sw	a2,20(sp)
    5810:	00d12823          	sw	a3,16(sp)
    5814:	00e12623          	sw	a4,12(sp)
    5818:	02c00513          	li	a0,44
    581c:	348010ef          	jal	ra,6b64 <pvPortMalloc>
    5820:	02a12623          	sw	a0,44(sp)
    5824:	02c12783          	lw	a5,44(sp)
    5828:	02078063          	beqz	a5,5848 <xTimerCreate+0x4c>
    582c:	02c12783          	lw	a5,44(sp)
    5830:	00c12703          	lw	a4,12(sp)
    5834:	01012683          	lw	a3,16(sp)
    5838:	01412603          	lw	a2,20(sp)
    583c:	01812583          	lw	a1,24(sp)
    5840:	01c12503          	lw	a0,28(sp)
    5844:	018000ef          	jal	ra,585c <prvInitialiseNewTimer>
    5848:	02c12783          	lw	a5,44(sp)
    584c:	00078513          	mv	a0,a5
    5850:	03c12083          	lw	ra,60(sp)
    5854:	04010113          	addi	sp,sp,64
    5858:	00008067          	ret

0000585c <prvInitialiseNewTimer>:
    585c:	fd010113          	addi	sp,sp,-48
    5860:	02112623          	sw	ra,44(sp)
    5864:	00a12e23          	sw	a0,28(sp)
    5868:	00b12c23          	sw	a1,24(sp)
    586c:	00c12a23          	sw	a2,20(sp)
    5870:	00d12823          	sw	a3,16(sp)
    5874:	00e12623          	sw	a4,12(sp)
    5878:	00f12423          	sw	a5,8(sp)
    587c:	01812783          	lw	a5,24(sp)
    5880:	00079663          	bnez	a5,588c <prvInitialiseNewTimer+0x30>
    5884:	30047073          	csrci	mstatus,8
    5888:	0000006f          	j	5888 <prvInitialiseNewTimer+0x2c>
    588c:	00812783          	lw	a5,8(sp)
    5890:	04078a63          	beqz	a5,58e4 <prvInitialiseNewTimer+0x88>
    5894:	095000ef          	jal	ra,6128 <prvCheckForValidListAndQueue>
    5898:	00812783          	lw	a5,8(sp)
    589c:	01c12703          	lw	a4,28(sp)
    58a0:	00e7a023          	sw	a4,0(a5)
    58a4:	00812783          	lw	a5,8(sp)
    58a8:	01812703          	lw	a4,24(sp)
    58ac:	00e7ac23          	sw	a4,24(a5)
    58b0:	00812783          	lw	a5,8(sp)
    58b4:	01412703          	lw	a4,20(sp)
    58b8:	00e7ae23          	sw	a4,28(a5)
    58bc:	00812783          	lw	a5,8(sp)
    58c0:	01012703          	lw	a4,16(sp)
    58c4:	02e7a023          	sw	a4,32(a5)
    58c8:	00812783          	lw	a5,8(sp)
    58cc:	00c12703          	lw	a4,12(sp)
    58d0:	02e7a223          	sw	a4,36(a5)
    58d4:	00812783          	lw	a5,8(sp)
    58d8:	00478793          	addi	a5,a5,4
    58dc:	00078513          	mv	a0,a5
    58e0:	ff5fa0ef          	jal	ra,8d4 <vListInitialiseItem>
    58e4:	00000013          	nop
    58e8:	02c12083          	lw	ra,44(sp)
    58ec:	03010113          	addi	sp,sp,48
    58f0:	00008067          	ret

000058f4 <xTimerGenericCommand>:
    58f4:	fc010113          	addi	sp,sp,-64
    58f8:	02112e23          	sw	ra,60(sp)
    58fc:	00a12e23          	sw	a0,28(sp)
    5900:	00b12c23          	sw	a1,24(sp)
    5904:	00c12a23          	sw	a2,20(sp)
    5908:	00d12823          	sw	a3,16(sp)
    590c:	00e12623          	sw	a4,12(sp)
    5910:	02012623          	sw	zero,44(sp)
    5914:	01c12783          	lw	a5,28(sp)
    5918:	00079663          	bnez	a5,5924 <xTimerGenericCommand+0x30>
    591c:	30047073          	csrci	mstatus,8
    5920:	0000006f          	j	5920 <xTimerGenericCommand+0x2c>
    5924:	0001b797          	auipc	a5,0x1b
    5928:	de078793          	addi	a5,a5,-544 # 20704 <xTimerQueue>
    592c:	0007a783          	lw	a5,0(a5)
    5930:	0a078c63          	beqz	a5,59e8 <xTimerGenericCommand+0xf4>
    5934:	01812783          	lw	a5,24(sp)
    5938:	02f12023          	sw	a5,32(sp)
    593c:	01412783          	lw	a5,20(sp)
    5940:	02f12223          	sw	a5,36(sp)
    5944:	01c12783          	lw	a5,28(sp)
    5948:	02f12423          	sw	a5,40(sp)
    594c:	01812703          	lw	a4,24(sp)
    5950:	00500793          	li	a5,5
    5954:	06e7c663          	blt	a5,a4,59c0 <xTimerGenericCommand+0xcc>
    5958:	f19fe0ef          	jal	ra,4870 <xTaskGetSchedulerState>
    595c:	00050713          	mv	a4,a0
    5960:	00200793          	li	a5,2
    5964:	02f71863          	bne	a4,a5,5994 <xTimerGenericCommand+0xa0>
    5968:	0001b797          	auipc	a5,0x1b
    596c:	d9c78793          	addi	a5,a5,-612 # 20704 <xTimerQueue>
    5970:	0007a783          	lw	a5,0(a5)
    5974:	02010713          	addi	a4,sp,32
    5978:	00000693          	li	a3,0
    597c:	00c12603          	lw	a2,12(sp)
    5980:	00070593          	mv	a1,a4
    5984:	00078513          	mv	a0,a5
    5988:	df0fb0ef          	jal	ra,f78 <xQueueGenericSend>
    598c:	02a12623          	sw	a0,44(sp)
    5990:	0580006f          	j	59e8 <xTimerGenericCommand+0xf4>
    5994:	0001b797          	auipc	a5,0x1b
    5998:	d7078793          	addi	a5,a5,-656 # 20704 <xTimerQueue>
    599c:	0007a783          	lw	a5,0(a5)
    59a0:	02010713          	addi	a4,sp,32
    59a4:	00000693          	li	a3,0
    59a8:	00000613          	li	a2,0
    59ac:	00070593          	mv	a1,a4
    59b0:	00078513          	mv	a0,a5
    59b4:	dc4fb0ef          	jal	ra,f78 <xQueueGenericSend>
    59b8:	02a12623          	sw	a0,44(sp)
    59bc:	02c0006f          	j	59e8 <xTimerGenericCommand+0xf4>
    59c0:	0001b797          	auipc	a5,0x1b
    59c4:	d4478793          	addi	a5,a5,-700 # 20704 <xTimerQueue>
    59c8:	0007a783          	lw	a5,0(a5)
    59cc:	02010713          	addi	a4,sp,32
    59d0:	00000693          	li	a3,0
    59d4:	01012603          	lw	a2,16(sp)
    59d8:	00070593          	mv	a1,a4
    59dc:	00078513          	mv	a0,a5
    59e0:	fe4fb0ef          	jal	ra,11c4 <xQueueGenericSendFromISR>
    59e4:	02a12623          	sw	a0,44(sp)
    59e8:	02c12783          	lw	a5,44(sp)
    59ec:	00078513          	mv	a0,a5
    59f0:	03c12083          	lw	ra,60(sp)
    59f4:	04010113          	addi	sp,sp,64
    59f8:	00008067          	ret

000059fc <xTimerGetTimerDaemonTaskHandle>:
    59fc:	0001b797          	auipc	a5,0x1b
    5a00:	d0c78793          	addi	a5,a5,-756 # 20708 <xTimerTaskHandle>
    5a04:	0007a783          	lw	a5,0(a5)
    5a08:	00079663          	bnez	a5,5a14 <xTimerGetTimerDaemonTaskHandle+0x18>
    5a0c:	30047073          	csrci	mstatus,8
    5a10:	0000006f          	j	5a10 <xTimerGetTimerDaemonTaskHandle+0x14>
    5a14:	0001b797          	auipc	a5,0x1b
    5a18:	cf478793          	addi	a5,a5,-780 # 20708 <xTimerTaskHandle>
    5a1c:	0007a783          	lw	a5,0(a5)
    5a20:	00078513          	mv	a0,a5
    5a24:	00008067          	ret

00005a28 <xTimerGetPeriod>:
    5a28:	fe010113          	addi	sp,sp,-32
    5a2c:	00a12623          	sw	a0,12(sp)
    5a30:	00c12783          	lw	a5,12(sp)
    5a34:	00f12e23          	sw	a5,28(sp)
    5a38:	00c12783          	lw	a5,12(sp)
    5a3c:	00079663          	bnez	a5,5a48 <xTimerGetPeriod+0x20>
    5a40:	30047073          	csrci	mstatus,8
    5a44:	0000006f          	j	5a44 <xTimerGetPeriod+0x1c>
    5a48:	01c12783          	lw	a5,28(sp)
    5a4c:	0187a783          	lw	a5,24(a5)
    5a50:	00078513          	mv	a0,a5
    5a54:	02010113          	addi	sp,sp,32
    5a58:	00008067          	ret

00005a5c <xTimerGetExpiryTime>:
    5a5c:	fe010113          	addi	sp,sp,-32
    5a60:	00a12623          	sw	a0,12(sp)
    5a64:	00c12783          	lw	a5,12(sp)
    5a68:	00f12e23          	sw	a5,28(sp)
    5a6c:	00c12783          	lw	a5,12(sp)
    5a70:	00079663          	bnez	a5,5a7c <xTimerGetExpiryTime+0x20>
    5a74:	30047073          	csrci	mstatus,8
    5a78:	0000006f          	j	5a78 <xTimerGetExpiryTime+0x1c>
    5a7c:	01c12783          	lw	a5,28(sp)
    5a80:	0047a783          	lw	a5,4(a5)
    5a84:	00f12c23          	sw	a5,24(sp)
    5a88:	01812783          	lw	a5,24(sp)
    5a8c:	00078513          	mv	a0,a5
    5a90:	02010113          	addi	sp,sp,32
    5a94:	00008067          	ret

00005a98 <pcTimerGetName>:
    5a98:	fe010113          	addi	sp,sp,-32
    5a9c:	00a12623          	sw	a0,12(sp)
    5aa0:	00c12783          	lw	a5,12(sp)
    5aa4:	00f12e23          	sw	a5,28(sp)
    5aa8:	00c12783          	lw	a5,12(sp)
    5aac:	00079663          	bnez	a5,5ab8 <pcTimerGetName+0x20>
    5ab0:	30047073          	csrci	mstatus,8
    5ab4:	0000006f          	j	5ab4 <pcTimerGetName+0x1c>
    5ab8:	01c12783          	lw	a5,28(sp)
    5abc:	0007a783          	lw	a5,0(a5)
    5ac0:	00078513          	mv	a0,a5
    5ac4:	02010113          	addi	sp,sp,32
    5ac8:	00008067          	ret

00005acc <prvProcessExpiredTimer>:
    5acc:	fd010113          	addi	sp,sp,-48
    5ad0:	02112623          	sw	ra,44(sp)
    5ad4:	00a12623          	sw	a0,12(sp)
    5ad8:	00b12423          	sw	a1,8(sp)
    5adc:	0001b797          	auipc	a5,0x1b
    5ae0:	c2078793          	addi	a5,a5,-992 # 206fc <pxCurrentTimerList>
    5ae4:	0007a783          	lw	a5,0(a5)
    5ae8:	00c7a783          	lw	a5,12(a5)
    5aec:	00c7a783          	lw	a5,12(a5)
    5af0:	00f12e23          	sw	a5,28(sp)
    5af4:	01c12783          	lw	a5,28(sp)
    5af8:	00478793          	addi	a5,a5,4
    5afc:	00078513          	mv	a0,a5
    5b00:	f35fa0ef          	jal	ra,a34 <uxListRemove>
    5b04:	01c12783          	lw	a5,28(sp)
    5b08:	01c7a703          	lw	a4,28(a5)
    5b0c:	00100793          	li	a5,1
    5b10:	04f71e63          	bne	a4,a5,5b6c <prvProcessExpiredTimer+0xa0>
    5b14:	01c12783          	lw	a5,28(sp)
    5b18:	0187a703          	lw	a4,24(a5)
    5b1c:	00c12783          	lw	a5,12(sp)
    5b20:	00f707b3          	add	a5,a4,a5
    5b24:	00c12683          	lw	a3,12(sp)
    5b28:	00812603          	lw	a2,8(sp)
    5b2c:	00078593          	mv	a1,a5
    5b30:	01c12503          	lw	a0,28(sp)
    5b34:	230000ef          	jal	ra,5d64 <prvInsertTimerInActiveList>
    5b38:	00050793          	mv	a5,a0
    5b3c:	02078863          	beqz	a5,5b6c <prvProcessExpiredTimer+0xa0>
    5b40:	00000713          	li	a4,0
    5b44:	00000693          	li	a3,0
    5b48:	00c12603          	lw	a2,12(sp)
    5b4c:	00000593          	li	a1,0
    5b50:	01c12503          	lw	a0,28(sp)
    5b54:	da1ff0ef          	jal	ra,58f4 <xTimerGenericCommand>
    5b58:	00a12c23          	sw	a0,24(sp)
    5b5c:	01812783          	lw	a5,24(sp)
    5b60:	00079663          	bnez	a5,5b6c <prvProcessExpiredTimer+0xa0>
    5b64:	30047073          	csrci	mstatus,8
    5b68:	0000006f          	j	5b68 <prvProcessExpiredTimer+0x9c>
    5b6c:	01c12783          	lw	a5,28(sp)
    5b70:	0247a783          	lw	a5,36(a5)
    5b74:	01c12503          	lw	a0,28(sp)
    5b78:	000780e7          	jalr	a5
    5b7c:	00000013          	nop
    5b80:	02c12083          	lw	ra,44(sp)
    5b84:	03010113          	addi	sp,sp,48
    5b88:	00008067          	ret

00005b8c <prvTimerTask>:
    5b8c:	fd010113          	addi	sp,sp,-48
    5b90:	02112623          	sw	ra,44(sp)
    5b94:	00a12623          	sw	a0,12(sp)
    5b98:	01810793          	addi	a5,sp,24
    5b9c:	00078513          	mv	a0,a5
    5ba0:	0f0000ef          	jal	ra,5c90 <prvGetNextExpireTime>
    5ba4:	00a12e23          	sw	a0,28(sp)
    5ba8:	01812783          	lw	a5,24(sp)
    5bac:	00078593          	mv	a1,a5
    5bb0:	01c12503          	lw	a0,28(sp)
    5bb4:	00c000ef          	jal	ra,5bc0 <prvProcessTimerOrBlockTask>
    5bb8:	28c000ef          	jal	ra,5e44 <prvProcessReceivedCommands>
    5bbc:	fddff06f          	j	5b98 <prvTimerTask+0xc>

00005bc0 <prvProcessTimerOrBlockTask>:
    5bc0:	fd010113          	addi	sp,sp,-48
    5bc4:	02112623          	sw	ra,44(sp)
    5bc8:	00a12623          	sw	a0,12(sp)
    5bcc:	00b12423          	sw	a1,8(sp)
    5bd0:	8c5fd0ef          	jal	ra,3494 <vTaskSuspendAll>
    5bd4:	01810793          	addi	a5,sp,24
    5bd8:	00078513          	mv	a0,a5
    5bdc:	120000ef          	jal	ra,5cfc <prvSampleTimeNow>
    5be0:	00a12e23          	sw	a0,28(sp)
    5be4:	01812783          	lw	a5,24(sp)
    5be8:	08079a63          	bnez	a5,5c7c <prvProcessTimerOrBlockTask+0xbc>
    5bec:	00812783          	lw	a5,8(sp)
    5bf0:	02079263          	bnez	a5,5c14 <prvProcessTimerOrBlockTask+0x54>
    5bf4:	00c12703          	lw	a4,12(sp)
    5bf8:	01c12783          	lw	a5,28(sp)
    5bfc:	00e7ec63          	bltu	a5,a4,5c14 <prvProcessTimerOrBlockTask+0x54>
    5c00:	8b9fd0ef          	jal	ra,34b8 <xTaskResumeAll>
    5c04:	01c12583          	lw	a1,28(sp)
    5c08:	00c12503          	lw	a0,12(sp)
    5c0c:	ec1ff0ef          	jal	ra,5acc <prvProcessExpiredTimer>
    5c10:	0700006f          	j	5c80 <prvProcessTimerOrBlockTask+0xc0>
    5c14:	00812783          	lw	a5,8(sp)
    5c18:	02078463          	beqz	a5,5c40 <prvProcessTimerOrBlockTask+0x80>
    5c1c:	0001b797          	auipc	a5,0x1b
    5c20:	ae478793          	addi	a5,a5,-1308 # 20700 <pxOverflowTimerList>
    5c24:	0007a783          	lw	a5,0(a5)
    5c28:	0007a783          	lw	a5,0(a5)
    5c2c:	00079663          	bnez	a5,5c38 <prvProcessTimerOrBlockTask+0x78>
    5c30:	00100793          	li	a5,1
    5c34:	0080006f          	j	5c3c <prvProcessTimerOrBlockTask+0x7c>
    5c38:	00000793          	li	a5,0
    5c3c:	00f12423          	sw	a5,8(sp)
    5c40:	0001b797          	auipc	a5,0x1b
    5c44:	ac478793          	addi	a5,a5,-1340 # 20704 <xTimerQueue>
    5c48:	0007a683          	lw	a3,0(a5)
    5c4c:	00c12703          	lw	a4,12(sp)
    5c50:	01c12783          	lw	a5,28(sp)
    5c54:	40f707b3          	sub	a5,a4,a5
    5c58:	00812603          	lw	a2,8(sp)
    5c5c:	00078593          	mv	a1,a5
    5c60:	00068513          	mv	a0,a3
    5c64:	831fc0ef          	jal	ra,2494 <vQueueWaitForMessageRestricted>
    5c68:	851fd0ef          	jal	ra,34b8 <xTaskResumeAll>
    5c6c:	00050793          	mv	a5,a0
    5c70:	00079863          	bnez	a5,5c80 <prvProcessTimerOrBlockTask+0xc0>
    5c74:	921fa0ef          	jal	ra,594 <vPortYield>
    5c78:	0080006f          	j	5c80 <prvProcessTimerOrBlockTask+0xc0>
    5c7c:	83dfd0ef          	jal	ra,34b8 <xTaskResumeAll>
    5c80:	00000013          	nop
    5c84:	02c12083          	lw	ra,44(sp)
    5c88:	03010113          	addi	sp,sp,48
    5c8c:	00008067          	ret

00005c90 <prvGetNextExpireTime>:
    5c90:	fe010113          	addi	sp,sp,-32
    5c94:	00a12623          	sw	a0,12(sp)
    5c98:	0001b797          	auipc	a5,0x1b
    5c9c:	a6478793          	addi	a5,a5,-1436 # 206fc <pxCurrentTimerList>
    5ca0:	0007a783          	lw	a5,0(a5)
    5ca4:	0007a783          	lw	a5,0(a5)
    5ca8:	00079663          	bnez	a5,5cb4 <prvGetNextExpireTime+0x24>
    5cac:	00100793          	li	a5,1
    5cb0:	0080006f          	j	5cb8 <prvGetNextExpireTime+0x28>
    5cb4:	00000793          	li	a5,0
    5cb8:	00c12703          	lw	a4,12(sp)
    5cbc:	00f72023          	sw	a5,0(a4)
    5cc0:	00c12783          	lw	a5,12(sp)
    5cc4:	0007a783          	lw	a5,0(a5)
    5cc8:	02079063          	bnez	a5,5ce8 <prvGetNextExpireTime+0x58>
    5ccc:	0001b797          	auipc	a5,0x1b
    5cd0:	a3078793          	addi	a5,a5,-1488 # 206fc <pxCurrentTimerList>
    5cd4:	0007a783          	lw	a5,0(a5)
    5cd8:	00c7a783          	lw	a5,12(a5)
    5cdc:	0007a783          	lw	a5,0(a5)
    5ce0:	00f12e23          	sw	a5,28(sp)
    5ce4:	0080006f          	j	5cec <prvGetNextExpireTime+0x5c>
    5ce8:	00012e23          	sw	zero,28(sp)
    5cec:	01c12783          	lw	a5,28(sp)
    5cf0:	00078513          	mv	a0,a5
    5cf4:	02010113          	addi	sp,sp,32
    5cf8:	00008067          	ret

00005cfc <prvSampleTimeNow>:
    5cfc:	fd010113          	addi	sp,sp,-48
    5d00:	02112623          	sw	ra,44(sp)
    5d04:	00a12623          	sw	a0,12(sp)
    5d08:	985fd0ef          	jal	ra,368c <xTaskGetTickCount>
    5d0c:	00a12e23          	sw	a0,28(sp)
    5d10:	0001b797          	auipc	a5,0x1b
    5d14:	9fc78793          	addi	a5,a5,-1540 # 2070c <xLastTime.2180>
    5d18:	0007a783          	lw	a5,0(a5)
    5d1c:	01c12703          	lw	a4,28(sp)
    5d20:	00f77c63          	bleu	a5,a4,5d38 <prvSampleTimeNow+0x3c>
    5d24:	2b4000ef          	jal	ra,5fd8 <prvSwitchTimerLists>
    5d28:	00c12783          	lw	a5,12(sp)
    5d2c:	00100713          	li	a4,1
    5d30:	00e7a023          	sw	a4,0(a5)
    5d34:	00c0006f          	j	5d40 <prvSampleTimeNow+0x44>
    5d38:	00c12783          	lw	a5,12(sp)
    5d3c:	0007a023          	sw	zero,0(a5)
    5d40:	0001b797          	auipc	a5,0x1b
    5d44:	9cc78793          	addi	a5,a5,-1588 # 2070c <xLastTime.2180>
    5d48:	01c12703          	lw	a4,28(sp)
    5d4c:	00e7a023          	sw	a4,0(a5)
    5d50:	01c12783          	lw	a5,28(sp)
    5d54:	00078513          	mv	a0,a5
    5d58:	02c12083          	lw	ra,44(sp)
    5d5c:	03010113          	addi	sp,sp,48
    5d60:	00008067          	ret

00005d64 <prvInsertTimerInActiveList>:
    5d64:	fd010113          	addi	sp,sp,-48
    5d68:	02112623          	sw	ra,44(sp)
    5d6c:	00a12623          	sw	a0,12(sp)
    5d70:	00b12423          	sw	a1,8(sp)
    5d74:	00c12223          	sw	a2,4(sp)
    5d78:	00d12023          	sw	a3,0(sp)
    5d7c:	00012e23          	sw	zero,28(sp)
    5d80:	00c12783          	lw	a5,12(sp)
    5d84:	00812703          	lw	a4,8(sp)
    5d88:	00e7a223          	sw	a4,4(a5)
    5d8c:	00c12783          	lw	a5,12(sp)
    5d90:	00c12703          	lw	a4,12(sp)
    5d94:	00e7a823          	sw	a4,16(a5)
    5d98:	00812703          	lw	a4,8(sp)
    5d9c:	00412783          	lw	a5,4(sp)
    5da0:	04e7e663          	bltu	a5,a4,5dec <prvInsertTimerInActiveList+0x88>
    5da4:	00412703          	lw	a4,4(sp)
    5da8:	00012783          	lw	a5,0(sp)
    5dac:	40f70733          	sub	a4,a4,a5
    5db0:	00c12783          	lw	a5,12(sp)
    5db4:	0187a783          	lw	a5,24(a5)
    5db8:	00f76863          	bltu	a4,a5,5dc8 <prvInsertTimerInActiveList+0x64>
    5dbc:	00100793          	li	a5,1
    5dc0:	00f12e23          	sw	a5,28(sp)
    5dc4:	06c0006f          	j	5e30 <prvInsertTimerInActiveList+0xcc>
    5dc8:	0001b797          	auipc	a5,0x1b
    5dcc:	93878793          	addi	a5,a5,-1736 # 20700 <pxOverflowTimerList>
    5dd0:	0007a703          	lw	a4,0(a5)
    5dd4:	00c12783          	lw	a5,12(sp)
    5dd8:	00478793          	addi	a5,a5,4
    5ddc:	00078593          	mv	a1,a5
    5de0:	00070513          	mv	a0,a4
    5de4:	b89fa0ef          	jal	ra,96c <vListInsert>
    5de8:	0480006f          	j	5e30 <prvInsertTimerInActiveList+0xcc>
    5dec:	00412703          	lw	a4,4(sp)
    5df0:	00012783          	lw	a5,0(sp)
    5df4:	00f77e63          	bleu	a5,a4,5e10 <prvInsertTimerInActiveList+0xac>
    5df8:	00812703          	lw	a4,8(sp)
    5dfc:	00012783          	lw	a5,0(sp)
    5e00:	00f76863          	bltu	a4,a5,5e10 <prvInsertTimerInActiveList+0xac>
    5e04:	00100793          	li	a5,1
    5e08:	00f12e23          	sw	a5,28(sp)
    5e0c:	0240006f          	j	5e30 <prvInsertTimerInActiveList+0xcc>
    5e10:	0001b797          	auipc	a5,0x1b
    5e14:	8ec78793          	addi	a5,a5,-1812 # 206fc <pxCurrentTimerList>
    5e18:	0007a703          	lw	a4,0(a5)
    5e1c:	00c12783          	lw	a5,12(sp)
    5e20:	00478793          	addi	a5,a5,4
    5e24:	00078593          	mv	a1,a5
    5e28:	00070513          	mv	a0,a4
    5e2c:	b41fa0ef          	jal	ra,96c <vListInsert>
    5e30:	01c12783          	lw	a5,28(sp)
    5e34:	00078513          	mv	a0,a5
    5e38:	02c12083          	lw	ra,44(sp)
    5e3c:	03010113          	addi	sp,sp,48
    5e40:	00008067          	ret

00005e44 <prvProcessReceivedCommands>:
    5e44:	fd010113          	addi	sp,sp,-48
    5e48:	02112623          	sw	ra,44(sp)
    5e4c:	1540006f          	j	5fa0 <prvProcessReceivedCommands+0x15c>
    5e50:	00812783          	lw	a5,8(sp)
    5e54:	1407c463          	bltz	a5,5f9c <prvProcessReceivedCommands+0x158>
    5e58:	01012783          	lw	a5,16(sp)
    5e5c:	00f12e23          	sw	a5,28(sp)
    5e60:	01c12783          	lw	a5,28(sp)
    5e64:	0147a783          	lw	a5,20(a5)
    5e68:	00078a63          	beqz	a5,5e7c <prvProcessReceivedCommands+0x38>
    5e6c:	01c12783          	lw	a5,28(sp)
    5e70:	00478793          	addi	a5,a5,4
    5e74:	00078513          	mv	a0,a5
    5e78:	bbdfa0ef          	jal	ra,a34 <uxListRemove>
    5e7c:	00410793          	addi	a5,sp,4
    5e80:	00078513          	mv	a0,a5
    5e84:	e79ff0ef          	jal	ra,5cfc <prvSampleTimeNow>
    5e88:	00a12c23          	sw	a0,24(sp)
    5e8c:	00812783          	lw	a5,8(sp)
    5e90:	00900713          	li	a4,9
    5e94:	10f76663          	bltu	a4,a5,5fa0 <prvProcessReceivedCommands+0x15c>
    5e98:	00279713          	slli	a4,a5,0x2
    5e9c:	0001a797          	auipc	a5,0x1a
    5ea0:	19c78793          	addi	a5,a5,412 # 20038 <__rodata_start+0x38>
    5ea4:	00f707b3          	add	a5,a4,a5
    5ea8:	0007a703          	lw	a4,0(a5)
    5eac:	0001a797          	auipc	a5,0x1a
    5eb0:	18c78793          	addi	a5,a5,396 # 20038 <__rodata_start+0x38>
    5eb4:	00f707b3          	add	a5,a4,a5
    5eb8:	00078067          	jr	a5
    5ebc:	00c12703          	lw	a4,12(sp)
    5ec0:	01c12783          	lw	a5,28(sp)
    5ec4:	0187a783          	lw	a5,24(a5)
    5ec8:	00f707b3          	add	a5,a4,a5
    5ecc:	00c12703          	lw	a4,12(sp)
    5ed0:	00070693          	mv	a3,a4
    5ed4:	01812603          	lw	a2,24(sp)
    5ed8:	00078593          	mv	a1,a5
    5edc:	01c12503          	lw	a0,28(sp)
    5ee0:	e85ff0ef          	jal	ra,5d64 <prvInsertTimerInActiveList>
    5ee4:	00050793          	mv	a5,a0
    5ee8:	0a078c63          	beqz	a5,5fa0 <prvProcessReceivedCommands+0x15c>
    5eec:	01c12783          	lw	a5,28(sp)
    5ef0:	0247a783          	lw	a5,36(a5)
    5ef4:	01c12503          	lw	a0,28(sp)
    5ef8:	000780e7          	jalr	a5
    5efc:	01c12783          	lw	a5,28(sp)
    5f00:	01c7a703          	lw	a4,28(a5)
    5f04:	00100793          	li	a5,1
    5f08:	08f71c63          	bne	a4,a5,5fa0 <prvProcessReceivedCommands+0x15c>
    5f0c:	00c12703          	lw	a4,12(sp)
    5f10:	01c12783          	lw	a5,28(sp)
    5f14:	0187a783          	lw	a5,24(a5)
    5f18:	00f707b3          	add	a5,a4,a5
    5f1c:	00000713          	li	a4,0
    5f20:	00000693          	li	a3,0
    5f24:	00078613          	mv	a2,a5
    5f28:	00000593          	li	a1,0
    5f2c:	01c12503          	lw	a0,28(sp)
    5f30:	9c5ff0ef          	jal	ra,58f4 <xTimerGenericCommand>
    5f34:	00a12a23          	sw	a0,20(sp)
    5f38:	01412783          	lw	a5,20(sp)
    5f3c:	06079263          	bnez	a5,5fa0 <prvProcessReceivedCommands+0x15c>
    5f40:	30047073          	csrci	mstatus,8
    5f44:	0000006f          	j	5f44 <prvProcessReceivedCommands+0x100>
    5f48:	00c12703          	lw	a4,12(sp)
    5f4c:	01c12783          	lw	a5,28(sp)
    5f50:	00e7ac23          	sw	a4,24(a5)
    5f54:	01c12783          	lw	a5,28(sp)
    5f58:	0187a783          	lw	a5,24(a5)
    5f5c:	00079663          	bnez	a5,5f68 <prvProcessReceivedCommands+0x124>
    5f60:	30047073          	csrci	mstatus,8
    5f64:	0000006f          	j	5f64 <prvProcessReceivedCommands+0x120>
    5f68:	01c12783          	lw	a5,28(sp)
    5f6c:	0187a703          	lw	a4,24(a5)
    5f70:	01812783          	lw	a5,24(sp)
    5f74:	00f707b3          	add	a5,a4,a5
    5f78:	01812683          	lw	a3,24(sp)
    5f7c:	01812603          	lw	a2,24(sp)
    5f80:	00078593          	mv	a1,a5
    5f84:	01c12503          	lw	a0,28(sp)
    5f88:	dddff0ef          	jal	ra,5d64 <prvInsertTimerInActiveList>
    5f8c:	0140006f          	j	5fa0 <prvProcessReceivedCommands+0x15c>
    5f90:	01c12503          	lw	a0,28(sp)
    5f94:	5cd000ef          	jal	ra,6d60 <vPortFree>
    5f98:	0080006f          	j	5fa0 <prvProcessReceivedCommands+0x15c>
    5f9c:	00000013          	nop
    5fa0:	0001a797          	auipc	a5,0x1a
    5fa4:	76478793          	addi	a5,a5,1892 # 20704 <xTimerQueue>
    5fa8:	0007a783          	lw	a5,0(a5)
    5fac:	00810713          	addi	a4,sp,8
    5fb0:	00000613          	li	a2,0
    5fb4:	00070593          	mv	a1,a4
    5fb8:	00078513          	mv	a0,a5
    5fbc:	cb8fb0ef          	jal	ra,1474 <xQueueReceive>
    5fc0:	00050793          	mv	a5,a0
    5fc4:	e80796e3          	bnez	a5,5e50 <prvProcessReceivedCommands+0xc>
    5fc8:	00000013          	nop
    5fcc:	02c12083          	lw	ra,44(sp)
    5fd0:	03010113          	addi	sp,sp,48
    5fd4:	00008067          	ret

00005fd8 <prvSwitchTimerLists>:
    5fd8:	fd010113          	addi	sp,sp,-48
    5fdc:	02112623          	sw	ra,44(sp)
    5fe0:	0ec0006f          	j	60cc <prvSwitchTimerLists+0xf4>
    5fe4:	0001a797          	auipc	a5,0x1a
    5fe8:	71878793          	addi	a5,a5,1816 # 206fc <pxCurrentTimerList>
    5fec:	0007a783          	lw	a5,0(a5)
    5ff0:	00c7a783          	lw	a5,12(a5)
    5ff4:	0007a783          	lw	a5,0(a5)
    5ff8:	00f12c23          	sw	a5,24(sp)
    5ffc:	0001a797          	auipc	a5,0x1a
    6000:	70078793          	addi	a5,a5,1792 # 206fc <pxCurrentTimerList>
    6004:	0007a783          	lw	a5,0(a5)
    6008:	00c7a783          	lw	a5,12(a5)
    600c:	00c7a783          	lw	a5,12(a5)
    6010:	00f12a23          	sw	a5,20(sp)
    6014:	01412783          	lw	a5,20(sp)
    6018:	00478793          	addi	a5,a5,4
    601c:	00078513          	mv	a0,a5
    6020:	a15fa0ef          	jal	ra,a34 <uxListRemove>
    6024:	01412783          	lw	a5,20(sp)
    6028:	0247a783          	lw	a5,36(a5)
    602c:	01412503          	lw	a0,20(sp)
    6030:	000780e7          	jalr	a5
    6034:	01412783          	lw	a5,20(sp)
    6038:	01c7a703          	lw	a4,28(a5)
    603c:	00100793          	li	a5,1
    6040:	08f71663          	bne	a4,a5,60cc <prvSwitchTimerLists+0xf4>
    6044:	01412783          	lw	a5,20(sp)
    6048:	0187a783          	lw	a5,24(a5)
    604c:	01812703          	lw	a4,24(sp)
    6050:	00f707b3          	add	a5,a4,a5
    6054:	00f12823          	sw	a5,16(sp)
    6058:	01012703          	lw	a4,16(sp)
    605c:	01812783          	lw	a5,24(sp)
    6060:	04e7f063          	bleu	a4,a5,60a0 <prvSwitchTimerLists+0xc8>
    6064:	01412783          	lw	a5,20(sp)
    6068:	01012703          	lw	a4,16(sp)
    606c:	00e7a223          	sw	a4,4(a5)
    6070:	01412783          	lw	a5,20(sp)
    6074:	01412703          	lw	a4,20(sp)
    6078:	00e7a823          	sw	a4,16(a5)
    607c:	0001a797          	auipc	a5,0x1a
    6080:	68078793          	addi	a5,a5,1664 # 206fc <pxCurrentTimerList>
    6084:	0007a703          	lw	a4,0(a5)
    6088:	01412783          	lw	a5,20(sp)
    608c:	00478793          	addi	a5,a5,4
    6090:	00078593          	mv	a1,a5
    6094:	00070513          	mv	a0,a4
    6098:	8d5fa0ef          	jal	ra,96c <vListInsert>
    609c:	0300006f          	j	60cc <prvSwitchTimerLists+0xf4>
    60a0:	00000713          	li	a4,0
    60a4:	00000693          	li	a3,0
    60a8:	01812603          	lw	a2,24(sp)
    60ac:	00000593          	li	a1,0
    60b0:	01412503          	lw	a0,20(sp)
    60b4:	841ff0ef          	jal	ra,58f4 <xTimerGenericCommand>
    60b8:	00a12623          	sw	a0,12(sp)
    60bc:	00c12783          	lw	a5,12(sp)
    60c0:	00079663          	bnez	a5,60cc <prvSwitchTimerLists+0xf4>
    60c4:	30047073          	csrci	mstatus,8
    60c8:	0000006f          	j	60c8 <prvSwitchTimerLists+0xf0>
    60cc:	0001a797          	auipc	a5,0x1a
    60d0:	63078793          	addi	a5,a5,1584 # 206fc <pxCurrentTimerList>
    60d4:	0007a783          	lw	a5,0(a5)
    60d8:	0007a783          	lw	a5,0(a5)
    60dc:	f00794e3          	bnez	a5,5fe4 <prvSwitchTimerLists+0xc>
    60e0:	0001a797          	auipc	a5,0x1a
    60e4:	61c78793          	addi	a5,a5,1564 # 206fc <pxCurrentTimerList>
    60e8:	0007a783          	lw	a5,0(a5)
    60ec:	00f12e23          	sw	a5,28(sp)
    60f0:	0001a797          	auipc	a5,0x1a
    60f4:	61078793          	addi	a5,a5,1552 # 20700 <pxOverflowTimerList>
    60f8:	0007a703          	lw	a4,0(a5)
    60fc:	0001a797          	auipc	a5,0x1a
    6100:	60078793          	addi	a5,a5,1536 # 206fc <pxCurrentTimerList>
    6104:	00e7a023          	sw	a4,0(a5)
    6108:	0001a797          	auipc	a5,0x1a
    610c:	5f878793          	addi	a5,a5,1528 # 20700 <pxOverflowTimerList>
    6110:	01c12703          	lw	a4,28(sp)
    6114:	00e7a023          	sw	a4,0(a5)
    6118:	00000013          	nop
    611c:	02c12083          	lw	ra,44(sp)
    6120:	03010113          	addi	sp,sp,48
    6124:	00008067          	ret

00006128 <prvCheckForValidListAndQueue>:
    6128:	ff010113          	addi	sp,sp,-16
    612c:	00112623          	sw	ra,12(sp)
    6130:	bd9fe0ef          	jal	ra,4d08 <vTaskEnterCritical>
    6134:	0001a797          	auipc	a5,0x1a
    6138:	5d078793          	addi	a5,a5,1488 # 20704 <xTimerQueue>
    613c:	0007a783          	lw	a5,0(a5)
    6140:	08079863          	bnez	a5,61d0 <prvCheckForValidListAndQueue+0xa8>
    6144:	0001a517          	auipc	a0,0x1a
    6148:	5cc50513          	addi	a0,a0,1484 # 20710 <xActiveTimerList1.2228>
    614c:	f30fa0ef          	jal	ra,87c <vListInitialise>
    6150:	0001a517          	auipc	a0,0x1a
    6154:	5d450513          	addi	a0,a0,1492 # 20724 <xActiveTimerList2.2229>
    6158:	f24fa0ef          	jal	ra,87c <vListInitialise>
    615c:	0001a797          	auipc	a5,0x1a
    6160:	5a078793          	addi	a5,a5,1440 # 206fc <pxCurrentTimerList>
    6164:	0001a717          	auipc	a4,0x1a
    6168:	5ac70713          	addi	a4,a4,1452 # 20710 <xActiveTimerList1.2228>
    616c:	00e7a023          	sw	a4,0(a5)
    6170:	0001a797          	auipc	a5,0x1a
    6174:	59078793          	addi	a5,a5,1424 # 20700 <pxOverflowTimerList>
    6178:	0001a717          	auipc	a4,0x1a
    617c:	5ac70713          	addi	a4,a4,1452 # 20724 <xActiveTimerList2.2229>
    6180:	00e7a023          	sw	a4,0(a5)
    6184:	00000613          	li	a2,0
    6188:	00c00593          	li	a1,12
    618c:	00500513          	li	a0,5
    6190:	a6dfa0ef          	jal	ra,bfc <xQueueGenericCreate>
    6194:	00050713          	mv	a4,a0
    6198:	0001a797          	auipc	a5,0x1a
    619c:	56c78793          	addi	a5,a5,1388 # 20704 <xTimerQueue>
    61a0:	00e7a023          	sw	a4,0(a5)
    61a4:	0001a797          	auipc	a5,0x1a
    61a8:	56078793          	addi	a5,a5,1376 # 20704 <xTimerQueue>
    61ac:	0007a783          	lw	a5,0(a5)
    61b0:	02078063          	beqz	a5,61d0 <prvCheckForValidListAndQueue+0xa8>
    61b4:	0001a797          	auipc	a5,0x1a
    61b8:	55078793          	addi	a5,a5,1360 # 20704 <xTimerQueue>
    61bc:	0007a783          	lw	a5,0(a5)
    61c0:	0001a597          	auipc	a1,0x1a
    61c4:	ea058593          	addi	a1,a1,-352 # 20060 <__rodata_start+0x60>
    61c8:	00078513          	mv	a0,a5
    61cc:	934fc0ef          	jal	ra,2300 <vQueueAddToRegistry>
    61d0:	b79fe0ef          	jal	ra,4d48 <vTaskExitCritical>
    61d4:	00000013          	nop
    61d8:	00c12083          	lw	ra,12(sp)
    61dc:	01010113          	addi	sp,sp,16
    61e0:	00008067          	ret

000061e4 <xTimerIsTimerActive>:
    61e4:	fd010113          	addi	sp,sp,-48
    61e8:	02112623          	sw	ra,44(sp)
    61ec:	00a12623          	sw	a0,12(sp)
    61f0:	00c12783          	lw	a5,12(sp)
    61f4:	00f12c23          	sw	a5,24(sp)
    61f8:	00c12783          	lw	a5,12(sp)
    61fc:	00079663          	bnez	a5,6208 <xTimerIsTimerActive+0x24>
    6200:	30047073          	csrci	mstatus,8
    6204:	0000006f          	j	6204 <xTimerIsTimerActive+0x20>
    6208:	b01fe0ef          	jal	ra,4d08 <vTaskEnterCritical>
    620c:	01812783          	lw	a5,24(sp)
    6210:	0147a783          	lw	a5,20(a5)
    6214:	00079663          	bnez	a5,6220 <xTimerIsTimerActive+0x3c>
    6218:	00012e23          	sw	zero,28(sp)
    621c:	00c0006f          	j	6228 <xTimerIsTimerActive+0x44>
    6220:	00100793          	li	a5,1
    6224:	00f12e23          	sw	a5,28(sp)
    6228:	b21fe0ef          	jal	ra,4d48 <vTaskExitCritical>
    622c:	01c12783          	lw	a5,28(sp)
    6230:	00078513          	mv	a0,a5
    6234:	02c12083          	lw	ra,44(sp)
    6238:	03010113          	addi	sp,sp,48
    623c:	00008067          	ret

00006240 <pvTimerGetTimerID>:
    6240:	fd010113          	addi	sp,sp,-48
    6244:	02112623          	sw	ra,44(sp)
    6248:	00a12623          	sw	a0,12(sp)
    624c:	00c12783          	lw	a5,12(sp)
    6250:	00f12e23          	sw	a5,28(sp)
    6254:	00c12783          	lw	a5,12(sp)
    6258:	00079663          	bnez	a5,6264 <pvTimerGetTimerID+0x24>
    625c:	30047073          	csrci	mstatus,8
    6260:	0000006f          	j	6260 <pvTimerGetTimerID+0x20>
    6264:	aa5fe0ef          	jal	ra,4d08 <vTaskEnterCritical>
    6268:	01c12783          	lw	a5,28(sp)
    626c:	0207a783          	lw	a5,32(a5)
    6270:	00f12c23          	sw	a5,24(sp)
    6274:	ad5fe0ef          	jal	ra,4d48 <vTaskExitCritical>
    6278:	01812783          	lw	a5,24(sp)
    627c:	00078513          	mv	a0,a5
    6280:	02c12083          	lw	ra,44(sp)
    6284:	03010113          	addi	sp,sp,48
    6288:	00008067          	ret

0000628c <vTimerSetTimerID>:
    628c:	fd010113          	addi	sp,sp,-48
    6290:	02112623          	sw	ra,44(sp)
    6294:	00a12623          	sw	a0,12(sp)
    6298:	00b12423          	sw	a1,8(sp)
    629c:	00c12783          	lw	a5,12(sp)
    62a0:	00f12e23          	sw	a5,28(sp)
    62a4:	00c12783          	lw	a5,12(sp)
    62a8:	00079663          	bnez	a5,62b4 <vTimerSetTimerID+0x28>
    62ac:	30047073          	csrci	mstatus,8
    62b0:	0000006f          	j	62b0 <vTimerSetTimerID+0x24>
    62b4:	a55fe0ef          	jal	ra,4d08 <vTaskEnterCritical>
    62b8:	01c12783          	lw	a5,28(sp)
    62bc:	00812703          	lw	a4,8(sp)
    62c0:	02e7a023          	sw	a4,32(a5)
    62c4:	a85fe0ef          	jal	ra,4d48 <vTaskExitCritical>
    62c8:	00000013          	nop
    62cc:	02c12083          	lw	ra,44(sp)
    62d0:	03010113          	addi	sp,sp,48
    62d4:	00008067          	ret

000062d8 <uxTimerGetTimerNumber>:
    62d8:	ff010113          	addi	sp,sp,-16
    62dc:	00a12623          	sw	a0,12(sp)
    62e0:	00c12783          	lw	a5,12(sp)
    62e4:	0287a783          	lw	a5,40(a5)
    62e8:	00078513          	mv	a0,a5
    62ec:	01010113          	addi	sp,sp,16
    62f0:	00008067          	ret

000062f4 <vTimerSetTimerNumber>:
    62f4:	ff010113          	addi	sp,sp,-16
    62f8:	00a12623          	sw	a0,12(sp)
    62fc:	00b12423          	sw	a1,8(sp)
    6300:	00c12783          	lw	a5,12(sp)
    6304:	00812703          	lw	a4,8(sp)
    6308:	02e7a423          	sw	a4,40(a5)
    630c:	00000013          	nop
    6310:	01010113          	addi	sp,sp,16
    6314:	00008067          	ret

00006318 <xEventGroupCreate>:
    6318:	fe010113          	addi	sp,sp,-32
    631c:	00112e23          	sw	ra,28(sp)
    6320:	01c00513          	li	a0,28
    6324:	041000ef          	jal	ra,6b64 <pvPortMalloc>
    6328:	00a12623          	sw	a0,12(sp)
    632c:	00c12783          	lw	a5,12(sp)
    6330:	00078e63          	beqz	a5,634c <xEventGroupCreate+0x34>
    6334:	00c12783          	lw	a5,12(sp)
    6338:	0007a023          	sw	zero,0(a5)
    633c:	00c12783          	lw	a5,12(sp)
    6340:	00478793          	addi	a5,a5,4
    6344:	00078513          	mv	a0,a5
    6348:	d34fa0ef          	jal	ra,87c <vListInitialise>
    634c:	00c12783          	lw	a5,12(sp)
    6350:	00078513          	mv	a0,a5
    6354:	01c12083          	lw	ra,28(sp)
    6358:	02010113          	addi	sp,sp,32
    635c:	00008067          	ret

00006360 <xEventGroupSync>:
    6360:	fc010113          	addi	sp,sp,-64
    6364:	02112e23          	sw	ra,60(sp)
    6368:	00a12623          	sw	a0,12(sp)
    636c:	00b12423          	sw	a1,8(sp)
    6370:	00c12223          	sw	a2,4(sp)
    6374:	00d12023          	sw	a3,0(sp)
    6378:	00c12783          	lw	a5,12(sp)
    637c:	02f12423          	sw	a5,40(sp)
    6380:	02012223          	sw	zero,36(sp)
    6384:	00412703          	lw	a4,4(sp)
    6388:	ff0007b7          	lui	a5,0xff000
    638c:	00f777b3          	and	a5,a4,a5
    6390:	00078663          	beqz	a5,639c <xEventGroupSync+0x3c>
    6394:	30047073          	csrci	mstatus,8
    6398:	0000006f          	j	6398 <xEventGroupSync+0x38>
    639c:	00412783          	lw	a5,4(sp)
    63a0:	00079663          	bnez	a5,63ac <xEventGroupSync+0x4c>
    63a4:	30047073          	csrci	mstatus,8
    63a8:	0000006f          	j	63a8 <xEventGroupSync+0x48>
    63ac:	cc4fe0ef          	jal	ra,4870 <xTaskGetSchedulerState>
    63b0:	00050793          	mv	a5,a0
    63b4:	00079663          	bnez	a5,63c0 <xEventGroupSync+0x60>
    63b8:	00012783          	lw	a5,0(sp)
    63bc:	00079663          	bnez	a5,63c8 <xEventGroupSync+0x68>
    63c0:	00100793          	li	a5,1
    63c4:	0080006f          	j	63cc <xEventGroupSync+0x6c>
    63c8:	00000793          	li	a5,0
    63cc:	00079663          	bnez	a5,63d8 <xEventGroupSync+0x78>
    63d0:	30047073          	csrci	mstatus,8
    63d4:	0000006f          	j	63d4 <xEventGroupSync+0x74>
    63d8:	8bcfd0ef          	jal	ra,3494 <vTaskSuspendAll>
    63dc:	02812783          	lw	a5,40(sp)
    63e0:	0007a783          	lw	a5,0(a5) # ff000000 <__stack+0xfefc46f8>
    63e4:	02f12023          	sw	a5,32(sp)
    63e8:	00812583          	lw	a1,8(sp)
    63ec:	00c12503          	lw	a0,12(sp)
    63f0:	42c000ef          	jal	ra,681c <xEventGroupSetBits>
    63f4:	02012703          	lw	a4,32(sp)
    63f8:	00812783          	lw	a5,8(sp)
    63fc:	00f76733          	or	a4,a4,a5
    6400:	00412783          	lw	a5,4(sp)
    6404:	00f777b3          	and	a5,a4,a5
    6408:	00412703          	lw	a4,4(sp)
    640c:	02f71c63          	bne	a4,a5,6444 <xEventGroupSync+0xe4>
    6410:	02012703          	lw	a4,32(sp)
    6414:	00812783          	lw	a5,8(sp)
    6418:	00f767b3          	or	a5,a4,a5
    641c:	02f12623          	sw	a5,44(sp)
    6420:	02812783          	lw	a5,40(sp)
    6424:	0007a703          	lw	a4,0(a5)
    6428:	00412783          	lw	a5,4(sp)
    642c:	fff7c793          	not	a5,a5
    6430:	00f77733          	and	a4,a4,a5
    6434:	02812783          	lw	a5,40(sp)
    6438:	00e7a023          	sw	a4,0(a5)
    643c:	00012023          	sw	zero,0(sp)
    6440:	04c0006f          	j	648c <xEventGroupSync+0x12c>
    6444:	00012783          	lw	a5,0(sp)
    6448:	02078863          	beqz	a5,6478 <xEventGroupSync+0x118>
    644c:	02812783          	lw	a5,40(sp)
    6450:	00478693          	addi	a3,a5,4
    6454:	00412703          	lw	a4,4(sp)
    6458:	050007b7          	lui	a5,0x5000
    645c:	00f767b3          	or	a5,a4,a5
    6460:	00012603          	lw	a2,0(sp)
    6464:	00078593          	mv	a1,a5
    6468:	00068513          	mv	a0,a3
    646c:	981fd0ef          	jal	ra,3dec <vTaskPlaceOnUnorderedEventList>
    6470:	02012623          	sw	zero,44(sp)
    6474:	0180006f          	j	648c <xEventGroupSync+0x12c>
    6478:	02812783          	lw	a5,40(sp)
    647c:	0007a783          	lw	a5,0(a5) # 5000000 <__stack+0x4fc46f8>
    6480:	02f12623          	sw	a5,44(sp)
    6484:	00100793          	li	a5,1
    6488:	02f12223          	sw	a5,36(sp)
    648c:	82cfd0ef          	jal	ra,34b8 <xTaskResumeAll>
    6490:	00a12e23          	sw	a0,28(sp)
    6494:	00012783          	lw	a5,0(sp)
    6498:	08078463          	beqz	a5,6520 <xEventGroupSync+0x1c0>
    649c:	01c12783          	lw	a5,28(sp)
    64a0:	00079463          	bnez	a5,64a8 <xEventGroupSync+0x148>
    64a4:	8f0fa0ef          	jal	ra,594 <vPortYield>
    64a8:	8fdfe0ef          	jal	ra,4da4 <uxTaskResetEventItemValue>
    64ac:	02a12623          	sw	a0,44(sp)
    64b0:	02c12703          	lw	a4,44(sp)
    64b4:	020007b7          	lui	a5,0x2000
    64b8:	00f777b3          	and	a5,a4,a5
    64bc:	04079863          	bnez	a5,650c <xEventGroupSync+0x1ac>
    64c0:	849fe0ef          	jal	ra,4d08 <vTaskEnterCritical>
    64c4:	02812783          	lw	a5,40(sp)
    64c8:	0007a783          	lw	a5,0(a5) # 2000000 <__stack+0x1fc46f8>
    64cc:	02f12623          	sw	a5,44(sp)
    64d0:	02c12703          	lw	a4,44(sp)
    64d4:	00412783          	lw	a5,4(sp)
    64d8:	00f777b3          	and	a5,a4,a5
    64dc:	00412703          	lw	a4,4(sp)
    64e0:	02f71063          	bne	a4,a5,6500 <xEventGroupSync+0x1a0>
    64e4:	02812783          	lw	a5,40(sp)
    64e8:	0007a703          	lw	a4,0(a5)
    64ec:	00412783          	lw	a5,4(sp)
    64f0:	fff7c793          	not	a5,a5
    64f4:	00f77733          	and	a4,a4,a5
    64f8:	02812783          	lw	a5,40(sp)
    64fc:	00e7a023          	sw	a4,0(a5)
    6500:	849fe0ef          	jal	ra,4d48 <vTaskExitCritical>
    6504:	00100793          	li	a5,1
    6508:	02f12223          	sw	a5,36(sp)
    650c:	02c12703          	lw	a4,44(sp)
    6510:	010007b7          	lui	a5,0x1000
    6514:	fff78793          	addi	a5,a5,-1 # ffffff <__stack+0xfc46f7>
    6518:	00f777b3          	and	a5,a4,a5
    651c:	02f12623          	sw	a5,44(sp)
    6520:	02c12783          	lw	a5,44(sp)
    6524:	00078513          	mv	a0,a5
    6528:	03c12083          	lw	ra,60(sp)
    652c:	04010113          	addi	sp,sp,64
    6530:	00008067          	ret

00006534 <xEventGroupWaitBits>:
    6534:	fb010113          	addi	sp,sp,-80
    6538:	04112623          	sw	ra,76(sp)
    653c:	00a12e23          	sw	a0,28(sp)
    6540:	00b12c23          	sw	a1,24(sp)
    6544:	00c12a23          	sw	a2,20(sp)
    6548:	00d12823          	sw	a3,16(sp)
    654c:	00e12623          	sw	a4,12(sp)
    6550:	01c12783          	lw	a5,28(sp)
    6554:	02f12a23          	sw	a5,52(sp)
    6558:	02012c23          	sw	zero,56(sp)
    655c:	02012823          	sw	zero,48(sp)
    6560:	01c12783          	lw	a5,28(sp)
    6564:	00079663          	bnez	a5,6570 <xEventGroupWaitBits+0x3c>
    6568:	30047073          	csrci	mstatus,8
    656c:	0000006f          	j	656c <xEventGroupWaitBits+0x38>
    6570:	01812703          	lw	a4,24(sp)
    6574:	ff0007b7          	lui	a5,0xff000
    6578:	00f777b3          	and	a5,a4,a5
    657c:	00078663          	beqz	a5,6588 <xEventGroupWaitBits+0x54>
    6580:	30047073          	csrci	mstatus,8
    6584:	0000006f          	j	6584 <xEventGroupWaitBits+0x50>
    6588:	01812783          	lw	a5,24(sp)
    658c:	00079663          	bnez	a5,6598 <xEventGroupWaitBits+0x64>
    6590:	30047073          	csrci	mstatus,8
    6594:	0000006f          	j	6594 <xEventGroupWaitBits+0x60>
    6598:	ad8fe0ef          	jal	ra,4870 <xTaskGetSchedulerState>
    659c:	00050793          	mv	a5,a0
    65a0:	00079663          	bnez	a5,65ac <xEventGroupWaitBits+0x78>
    65a4:	00c12783          	lw	a5,12(sp)
    65a8:	00079663          	bnez	a5,65b4 <xEventGroupWaitBits+0x80>
    65ac:	00100793          	li	a5,1
    65b0:	0080006f          	j	65b8 <xEventGroupWaitBits+0x84>
    65b4:	00000793          	li	a5,0
    65b8:	00079663          	bnez	a5,65c4 <xEventGroupWaitBits+0x90>
    65bc:	30047073          	csrci	mstatus,8
    65c0:	0000006f          	j	65c0 <xEventGroupWaitBits+0x8c>
    65c4:	ed1fc0ef          	jal	ra,3494 <vTaskSuspendAll>
    65c8:	03412783          	lw	a5,52(sp)
    65cc:	0007a783          	lw	a5,0(a5) # ff000000 <__stack+0xfefc46f8>
    65d0:	02f12623          	sw	a5,44(sp)
    65d4:	01012603          	lw	a2,16(sp)
    65d8:	01812583          	lw	a1,24(sp)
    65dc:	02c12503          	lw	a0,44(sp)
    65e0:	4c0000ef          	jal	ra,6aa0 <prvTestWaitCondition>
    65e4:	02a12423          	sw	a0,40(sp)
    65e8:	02812783          	lw	a5,40(sp)
    65ec:	02078c63          	beqz	a5,6624 <xEventGroupWaitBits+0xf0>
    65f0:	02c12783          	lw	a5,44(sp)
    65f4:	02f12e23          	sw	a5,60(sp)
    65f8:	00012623          	sw	zero,12(sp)
    65fc:	01412783          	lw	a5,20(sp)
    6600:	08078c63          	beqz	a5,6698 <xEventGroupWaitBits+0x164>
    6604:	03412783          	lw	a5,52(sp)
    6608:	0007a703          	lw	a4,0(a5)
    660c:	01812783          	lw	a5,24(sp)
    6610:	fff7c793          	not	a5,a5
    6614:	00f77733          	and	a4,a4,a5
    6618:	03412783          	lw	a5,52(sp)
    661c:	00e7a023          	sw	a4,0(a5)
    6620:	0780006f          	j	6698 <xEventGroupWaitBits+0x164>
    6624:	00c12783          	lw	a5,12(sp)
    6628:	00079c63          	bnez	a5,6640 <xEventGroupWaitBits+0x10c>
    662c:	02c12783          	lw	a5,44(sp)
    6630:	02f12e23          	sw	a5,60(sp)
    6634:	00100793          	li	a5,1
    6638:	02f12823          	sw	a5,48(sp)
    663c:	05c0006f          	j	6698 <xEventGroupWaitBits+0x164>
    6640:	01412783          	lw	a5,20(sp)
    6644:	00078a63          	beqz	a5,6658 <xEventGroupWaitBits+0x124>
    6648:	03812703          	lw	a4,56(sp)
    664c:	010007b7          	lui	a5,0x1000
    6650:	00f767b3          	or	a5,a4,a5
    6654:	02f12c23          	sw	a5,56(sp)
    6658:	01012783          	lw	a5,16(sp)
    665c:	00078a63          	beqz	a5,6670 <xEventGroupWaitBits+0x13c>
    6660:	03812703          	lw	a4,56(sp)
    6664:	040007b7          	lui	a5,0x4000
    6668:	00f767b3          	or	a5,a4,a5
    666c:	02f12c23          	sw	a5,56(sp)
    6670:	03412783          	lw	a5,52(sp)
    6674:	00478693          	addi	a3,a5,4 # 4000004 <__stack+0x3fc46fc>
    6678:	01812703          	lw	a4,24(sp)
    667c:	03812783          	lw	a5,56(sp)
    6680:	00f767b3          	or	a5,a4,a5
    6684:	00c12603          	lw	a2,12(sp)
    6688:	00078593          	mv	a1,a5
    668c:	00068513          	mv	a0,a3
    6690:	f5cfd0ef          	jal	ra,3dec <vTaskPlaceOnUnorderedEventList>
    6694:	02012e23          	sw	zero,60(sp)
    6698:	e21fc0ef          	jal	ra,34b8 <xTaskResumeAll>
    669c:	02a12223          	sw	a0,36(sp)
    66a0:	00c12783          	lw	a5,12(sp)
    66a4:	08078a63          	beqz	a5,6738 <xEventGroupWaitBits+0x204>
    66a8:	02412783          	lw	a5,36(sp)
    66ac:	00079463          	bnez	a5,66b4 <xEventGroupWaitBits+0x180>
    66b0:	ee5f90ef          	jal	ra,594 <vPortYield>
    66b4:	ef0fe0ef          	jal	ra,4da4 <uxTaskResetEventItemValue>
    66b8:	02a12e23          	sw	a0,60(sp)
    66bc:	03c12703          	lw	a4,60(sp)
    66c0:	020007b7          	lui	a5,0x2000
    66c4:	00f777b3          	and	a5,a4,a5
    66c8:	04079e63          	bnez	a5,6724 <xEventGroupWaitBits+0x1f0>
    66cc:	e3cfe0ef          	jal	ra,4d08 <vTaskEnterCritical>
    66d0:	03412783          	lw	a5,52(sp)
    66d4:	0007a783          	lw	a5,0(a5) # 2000000 <__stack+0x1fc46f8>
    66d8:	02f12e23          	sw	a5,60(sp)
    66dc:	01012603          	lw	a2,16(sp)
    66e0:	01812583          	lw	a1,24(sp)
    66e4:	03c12503          	lw	a0,60(sp)
    66e8:	3b8000ef          	jal	ra,6aa0 <prvTestWaitCondition>
    66ec:	00050793          	mv	a5,a0
    66f0:	02078463          	beqz	a5,6718 <xEventGroupWaitBits+0x1e4>
    66f4:	01412783          	lw	a5,20(sp)
    66f8:	02078063          	beqz	a5,6718 <xEventGroupWaitBits+0x1e4>
    66fc:	03412783          	lw	a5,52(sp)
    6700:	0007a703          	lw	a4,0(a5)
    6704:	01812783          	lw	a5,24(sp)
    6708:	fff7c793          	not	a5,a5
    670c:	00f77733          	and	a4,a4,a5
    6710:	03412783          	lw	a5,52(sp)
    6714:	00e7a023          	sw	a4,0(a5)
    6718:	00100793          	li	a5,1
    671c:	02f12823          	sw	a5,48(sp)
    6720:	e28fe0ef          	jal	ra,4d48 <vTaskExitCritical>
    6724:	03c12703          	lw	a4,60(sp)
    6728:	010007b7          	lui	a5,0x1000
    672c:	fff78793          	addi	a5,a5,-1 # ffffff <__stack+0xfc46f7>
    6730:	00f777b3          	and	a5,a4,a5
    6734:	02f12e23          	sw	a5,60(sp)
    6738:	03c12783          	lw	a5,60(sp)
    673c:	00078513          	mv	a0,a5
    6740:	04c12083          	lw	ra,76(sp)
    6744:	05010113          	addi	sp,sp,80
    6748:	00008067          	ret

0000674c <xEventGroupClearBits>:
    674c:	fd010113          	addi	sp,sp,-48
    6750:	02112623          	sw	ra,44(sp)
    6754:	00a12623          	sw	a0,12(sp)
    6758:	00b12423          	sw	a1,8(sp)
    675c:	00c12783          	lw	a5,12(sp)
    6760:	00f12e23          	sw	a5,28(sp)
    6764:	00c12783          	lw	a5,12(sp)
    6768:	00079663          	bnez	a5,6774 <xEventGroupClearBits+0x28>
    676c:	30047073          	csrci	mstatus,8
    6770:	0000006f          	j	6770 <xEventGroupClearBits+0x24>
    6774:	00812703          	lw	a4,8(sp)
    6778:	ff0007b7          	lui	a5,0xff000
    677c:	00f777b3          	and	a5,a4,a5
    6780:	00078663          	beqz	a5,678c <xEventGroupClearBits+0x40>
    6784:	30047073          	csrci	mstatus,8
    6788:	0000006f          	j	6788 <xEventGroupClearBits+0x3c>
    678c:	d7cfe0ef          	jal	ra,4d08 <vTaskEnterCritical>
    6790:	01c12783          	lw	a5,28(sp)
    6794:	0007a783          	lw	a5,0(a5) # ff000000 <__stack+0xfefc46f8>
    6798:	00f12c23          	sw	a5,24(sp)
    679c:	01c12783          	lw	a5,28(sp)
    67a0:	0007a703          	lw	a4,0(a5)
    67a4:	00812783          	lw	a5,8(sp)
    67a8:	fff7c793          	not	a5,a5
    67ac:	00f77733          	and	a4,a4,a5
    67b0:	01c12783          	lw	a5,28(sp)
    67b4:	00e7a023          	sw	a4,0(a5)
    67b8:	d90fe0ef          	jal	ra,4d48 <vTaskExitCritical>
    67bc:	01812783          	lw	a5,24(sp)
    67c0:	00078513          	mv	a0,a5
    67c4:	02c12083          	lw	ra,44(sp)
    67c8:	03010113          	addi	sp,sp,48
    67cc:	00008067          	ret

000067d0 <xEventGroupGetBitsFromISR>:
    67d0:	fd010113          	addi	sp,sp,-48
    67d4:	02112623          	sw	ra,44(sp)
    67d8:	00a12623          	sw	a0,12(sp)
    67dc:	00c12783          	lw	a5,12(sp)
    67e0:	00f12e23          	sw	a5,28(sp)
    67e4:	fc5f90ef          	jal	ra,7a8 <vPortSetInterruptMask>
    67e8:	00050793          	mv	a5,a0
    67ec:	00f12c23          	sw	a5,24(sp)
    67f0:	01c12783          	lw	a5,28(sp)
    67f4:	0007a783          	lw	a5,0(a5)
    67f8:	00f12a23          	sw	a5,20(sp)
    67fc:	01812783          	lw	a5,24(sp)
    6800:	00078513          	mv	a0,a5
    6804:	f89f90ef          	jal	ra,78c <vPortClearInterruptMask>
    6808:	01412783          	lw	a5,20(sp)
    680c:	00078513          	mv	a0,a5
    6810:	02c12083          	lw	ra,44(sp)
    6814:	03010113          	addi	sp,sp,48
    6818:	00008067          	ret

0000681c <xEventGroupSetBits>:
    681c:	fb010113          	addi	sp,sp,-80
    6820:	04112623          	sw	ra,76(sp)
    6824:	00a12623          	sw	a0,12(sp)
    6828:	00b12423          	sw	a1,8(sp)
    682c:	02012c23          	sw	zero,56(sp)
    6830:	00c12783          	lw	a5,12(sp)
    6834:	02f12823          	sw	a5,48(sp)
    6838:	02012a23          	sw	zero,52(sp)
    683c:	00c12783          	lw	a5,12(sp)
    6840:	00079663          	bnez	a5,684c <xEventGroupSetBits+0x30>
    6844:	30047073          	csrci	mstatus,8
    6848:	0000006f          	j	6848 <xEventGroupSetBits+0x2c>
    684c:	00812703          	lw	a4,8(sp)
    6850:	ff0007b7          	lui	a5,0xff000
    6854:	00f777b3          	and	a5,a4,a5
    6858:	00078663          	beqz	a5,6864 <xEventGroupSetBits+0x48>
    685c:	30047073          	csrci	mstatus,8
    6860:	0000006f          	j	6860 <xEventGroupSetBits+0x44>
    6864:	03012783          	lw	a5,48(sp)
    6868:	00478793          	addi	a5,a5,4 # ff000004 <__stack+0xfefc46fc>
    686c:	02f12623          	sw	a5,44(sp)
    6870:	02c12783          	lw	a5,44(sp)
    6874:	00878793          	addi	a5,a5,8
    6878:	02f12423          	sw	a5,40(sp)
    687c:	c19fc0ef          	jal	ra,3494 <vTaskSuspendAll>
    6880:	02c12783          	lw	a5,44(sp)
    6884:	00c7a783          	lw	a5,12(a5)
    6888:	02f12e23          	sw	a5,60(sp)
    688c:	03012783          	lw	a5,48(sp)
    6890:	0007a703          	lw	a4,0(a5)
    6894:	00812783          	lw	a5,8(sp)
    6898:	00f76733          	or	a4,a4,a5
    689c:	03012783          	lw	a5,48(sp)
    68a0:	00e7a023          	sw	a4,0(a5)
    68a4:	0e00006f          	j	6984 <xEventGroupSetBits+0x168>
    68a8:	03c12783          	lw	a5,60(sp)
    68ac:	0047a783          	lw	a5,4(a5)
    68b0:	02f12223          	sw	a5,36(sp)
    68b4:	03c12783          	lw	a5,60(sp)
    68b8:	0007a783          	lw	a5,0(a5)
    68bc:	02f12023          	sw	a5,32(sp)
    68c0:	02012a23          	sw	zero,52(sp)
    68c4:	02012703          	lw	a4,32(sp)
    68c8:	ff0007b7          	lui	a5,0xff000
    68cc:	00f777b3          	and	a5,a4,a5
    68d0:	00f12e23          	sw	a5,28(sp)
    68d4:	02012703          	lw	a4,32(sp)
    68d8:	010007b7          	lui	a5,0x1000
    68dc:	fff78793          	addi	a5,a5,-1 # ffffff <__stack+0xfc46f7>
    68e0:	00f777b3          	and	a5,a4,a5
    68e4:	02f12023          	sw	a5,32(sp)
    68e8:	01c12703          	lw	a4,28(sp)
    68ec:	040007b7          	lui	a5,0x4000
    68f0:	00f777b3          	and	a5,a4,a5
    68f4:	02079263          	bnez	a5,6918 <xEventGroupSetBits+0xfc>
    68f8:	03012783          	lw	a5,48(sp)
    68fc:	0007a703          	lw	a4,0(a5) # 4000000 <__stack+0x3fc46f8>
    6900:	02012783          	lw	a5,32(sp)
    6904:	00f777b3          	and	a5,a4,a5
    6908:	02078863          	beqz	a5,6938 <xEventGroupSetBits+0x11c>
    690c:	00100793          	li	a5,1
    6910:	02f12a23          	sw	a5,52(sp)
    6914:	0240006f          	j	6938 <xEventGroupSetBits+0x11c>
    6918:	03012783          	lw	a5,48(sp)
    691c:	0007a703          	lw	a4,0(a5)
    6920:	02012783          	lw	a5,32(sp)
    6924:	00f777b3          	and	a5,a4,a5
    6928:	02012703          	lw	a4,32(sp)
    692c:	00f71663          	bne	a4,a5,6938 <xEventGroupSetBits+0x11c>
    6930:	00100793          	li	a5,1
    6934:	02f12a23          	sw	a5,52(sp)
    6938:	03412783          	lw	a5,52(sp)
    693c:	04078063          	beqz	a5,697c <xEventGroupSetBits+0x160>
    6940:	01c12703          	lw	a4,28(sp)
    6944:	010007b7          	lui	a5,0x1000
    6948:	00f777b3          	and	a5,a4,a5
    694c:	00078a63          	beqz	a5,6960 <xEventGroupSetBits+0x144>
    6950:	03812703          	lw	a4,56(sp)
    6954:	02012783          	lw	a5,32(sp)
    6958:	00f767b3          	or	a5,a4,a5
    695c:	02f12c23          	sw	a5,56(sp)
    6960:	03012783          	lw	a5,48(sp)
    6964:	0007a703          	lw	a4,0(a5) # 1000000 <__stack+0xfc46f8>
    6968:	020007b7          	lui	a5,0x2000
    696c:	00f767b3          	or	a5,a4,a5
    6970:	00078593          	mv	a1,a5
    6974:	03c12503          	lw	a0,60(sp)
    6978:	e9cfd0ef          	jal	ra,4014 <vTaskRemoveFromUnorderedEventList>
    697c:	02412783          	lw	a5,36(sp)
    6980:	02f12e23          	sw	a5,60(sp)
    6984:	03c12703          	lw	a4,60(sp)
    6988:	02812783          	lw	a5,40(sp)
    698c:	f0f71ee3          	bne	a4,a5,68a8 <xEventGroupSetBits+0x8c>
    6990:	03012783          	lw	a5,48(sp)
    6994:	0007a703          	lw	a4,0(a5) # 2000000 <__stack+0x1fc46f8>
    6998:	03812783          	lw	a5,56(sp)
    699c:	fff7c793          	not	a5,a5
    69a0:	00f77733          	and	a4,a4,a5
    69a4:	03012783          	lw	a5,48(sp)
    69a8:	00e7a023          	sw	a4,0(a5)
    69ac:	b0dfc0ef          	jal	ra,34b8 <xTaskResumeAll>
    69b0:	03012783          	lw	a5,48(sp)
    69b4:	0007a783          	lw	a5,0(a5)
    69b8:	00078513          	mv	a0,a5
    69bc:	04c12083          	lw	ra,76(sp)
    69c0:	05010113          	addi	sp,sp,80
    69c4:	00008067          	ret

000069c8 <vEventGroupDelete>:
    69c8:	fd010113          	addi	sp,sp,-48
    69cc:	02112623          	sw	ra,44(sp)
    69d0:	00a12623          	sw	a0,12(sp)
    69d4:	00c12783          	lw	a5,12(sp)
    69d8:	00f12e23          	sw	a5,28(sp)
    69dc:	01c12783          	lw	a5,28(sp)
    69e0:	00478793          	addi	a5,a5,4
    69e4:	00f12c23          	sw	a5,24(sp)
    69e8:	aadfc0ef          	jal	ra,3494 <vTaskSuspendAll>
    69ec:	0340006f          	j	6a20 <vEventGroupDelete+0x58>
    69f0:	01812783          	lw	a5,24(sp)
    69f4:	00c7a703          	lw	a4,12(a5)
    69f8:	01812783          	lw	a5,24(sp)
    69fc:	00878793          	addi	a5,a5,8
    6a00:	00f71663          	bne	a4,a5,6a0c <vEventGroupDelete+0x44>
    6a04:	30047073          	csrci	mstatus,8
    6a08:	0000006f          	j	6a08 <vEventGroupDelete+0x40>
    6a0c:	01812783          	lw	a5,24(sp)
    6a10:	00c7a783          	lw	a5,12(a5)
    6a14:	020005b7          	lui	a1,0x2000
    6a18:	00078513          	mv	a0,a5
    6a1c:	df8fd0ef          	jal	ra,4014 <vTaskRemoveFromUnorderedEventList>
    6a20:	01812783          	lw	a5,24(sp)
    6a24:	0007a783          	lw	a5,0(a5)
    6a28:	fc0794e3          	bnez	a5,69f0 <vEventGroupDelete+0x28>
    6a2c:	01c12503          	lw	a0,28(sp)
    6a30:	330000ef          	jal	ra,6d60 <vPortFree>
    6a34:	a85fc0ef          	jal	ra,34b8 <xTaskResumeAll>
    6a38:	00000013          	nop
    6a3c:	02c12083          	lw	ra,44(sp)
    6a40:	03010113          	addi	sp,sp,48
    6a44:	00008067          	ret

00006a48 <vEventGroupSetBitsCallback>:
    6a48:	fe010113          	addi	sp,sp,-32
    6a4c:	00112e23          	sw	ra,28(sp)
    6a50:	00a12623          	sw	a0,12(sp)
    6a54:	00b12423          	sw	a1,8(sp)
    6a58:	00812583          	lw	a1,8(sp)
    6a5c:	00c12503          	lw	a0,12(sp)
    6a60:	dbdff0ef          	jal	ra,681c <xEventGroupSetBits>
    6a64:	00000013          	nop
    6a68:	01c12083          	lw	ra,28(sp)
    6a6c:	02010113          	addi	sp,sp,32
    6a70:	00008067          	ret

00006a74 <vEventGroupClearBitsCallback>:
    6a74:	fe010113          	addi	sp,sp,-32
    6a78:	00112e23          	sw	ra,28(sp)
    6a7c:	00a12623          	sw	a0,12(sp)
    6a80:	00b12423          	sw	a1,8(sp)
    6a84:	00812583          	lw	a1,8(sp)
    6a88:	00c12503          	lw	a0,12(sp)
    6a8c:	cc1ff0ef          	jal	ra,674c <xEventGroupClearBits>
    6a90:	00000013          	nop
    6a94:	01c12083          	lw	ra,28(sp)
    6a98:	02010113          	addi	sp,sp,32
    6a9c:	00008067          	ret

00006aa0 <prvTestWaitCondition>:
    6aa0:	fe010113          	addi	sp,sp,-32
    6aa4:	00a12623          	sw	a0,12(sp)
    6aa8:	00b12423          	sw	a1,8(sp)
    6aac:	00c12223          	sw	a2,4(sp)
    6ab0:	00012e23          	sw	zero,28(sp)
    6ab4:	00412783          	lw	a5,4(sp)
    6ab8:	02079063          	bnez	a5,6ad8 <prvTestWaitCondition+0x38>
    6abc:	00c12703          	lw	a4,12(sp)
    6ac0:	00812783          	lw	a5,8(sp)
    6ac4:	00f777b3          	and	a5,a4,a5
    6ac8:	02078663          	beqz	a5,6af4 <prvTestWaitCondition+0x54>
    6acc:	00100793          	li	a5,1
    6ad0:	00f12e23          	sw	a5,28(sp)
    6ad4:	0200006f          	j	6af4 <prvTestWaitCondition+0x54>
    6ad8:	00c12703          	lw	a4,12(sp)
    6adc:	00812783          	lw	a5,8(sp)
    6ae0:	00f777b3          	and	a5,a4,a5
    6ae4:	00812703          	lw	a4,8(sp)
    6ae8:	00f71663          	bne	a4,a5,6af4 <prvTestWaitCondition+0x54>
    6aec:	00100793          	li	a5,1
    6af0:	00f12e23          	sw	a5,28(sp)
    6af4:	01c12783          	lw	a5,28(sp)
    6af8:	00078513          	mv	a0,a5
    6afc:	02010113          	addi	sp,sp,32
    6b00:	00008067          	ret

00006b04 <uxEventGroupGetNumber>:
    6b04:	fe010113          	addi	sp,sp,-32
    6b08:	00a12623          	sw	a0,12(sp)
    6b0c:	00c12783          	lw	a5,12(sp)
    6b10:	00f12c23          	sw	a5,24(sp)
    6b14:	00c12783          	lw	a5,12(sp)
    6b18:	00079663          	bnez	a5,6b24 <uxEventGroupGetNumber+0x20>
    6b1c:	00012e23          	sw	zero,28(sp)
    6b20:	0100006f          	j	6b30 <uxEventGroupGetNumber+0x2c>
    6b24:	01812783          	lw	a5,24(sp)
    6b28:	0187a783          	lw	a5,24(a5)
    6b2c:	00f12e23          	sw	a5,28(sp)
    6b30:	01c12783          	lw	a5,28(sp)
    6b34:	00078513          	mv	a0,a5
    6b38:	02010113          	addi	sp,sp,32
    6b3c:	00008067          	ret

00006b40 <vEventGroupSetNumber>:
    6b40:	ff010113          	addi	sp,sp,-16
    6b44:	00a12623          	sw	a0,12(sp)
    6b48:	00b12423          	sw	a1,8(sp)
    6b4c:	00c12783          	lw	a5,12(sp)
    6b50:	00812703          	lw	a4,8(sp)
    6b54:	00e7ac23          	sw	a4,24(a5)
    6b58:	00000013          	nop
    6b5c:	01010113          	addi	sp,sp,16
    6b60:	00008067          	ret

00006b64 <pvPortMalloc>:
    6b64:	fc010113          	addi	sp,sp,-64
    6b68:	02112e23          	sw	ra,60(sp)
    6b6c:	00a12623          	sw	a0,12(sp)
    6b70:	02012223          	sw	zero,36(sp)
    6b74:	921fc0ef          	jal	ra,3494 <vTaskSuspendAll>
    6b78:	00033797          	auipc	a5,0x33
    6b7c:	bd078793          	addi	a5,a5,-1072 # 39748 <xHeapHasBeenInitialised.1887>
    6b80:	0007a783          	lw	a5,0(a5)
    6b84:	00079c63          	bnez	a5,6b9c <pvPortMalloc+0x38>
    6b88:	2c0000ef          	jal	ra,6e48 <prvHeapInit>
    6b8c:	00033797          	auipc	a5,0x33
    6b90:	bbc78793          	addi	a5,a5,-1092 # 39748 <xHeapHasBeenInitialised.1887>
    6b94:	00100713          	li	a4,1
    6b98:	00e7a023          	sw	a4,0(a5)
    6b9c:	00c12783          	lw	a5,12(sp)
    6ba0:	02078a63          	beqz	a5,6bd4 <pvPortMalloc+0x70>
    6ba4:	00800793          	li	a5,8
    6ba8:	00078713          	mv	a4,a5
    6bac:	00c12783          	lw	a5,12(sp)
    6bb0:	00e787b3          	add	a5,a5,a4
    6bb4:	00f12623          	sw	a5,12(sp)
    6bb8:	00c12783          	lw	a5,12(sp)
    6bbc:	0037f793          	andi	a5,a5,3
    6bc0:	00078a63          	beqz	a5,6bd4 <pvPortMalloc+0x70>
    6bc4:	00c12783          	lw	a5,12(sp)
    6bc8:	ffc7f793          	andi	a5,a5,-4
    6bcc:	00478793          	addi	a5,a5,4
    6bd0:	00f12623          	sw	a5,12(sp)
    6bd4:	00c12783          	lw	a5,12(sp)
    6bd8:	16078263          	beqz	a5,6d3c <pvPortMalloc+0x1d8>
    6bdc:	00c12703          	lw	a4,12(sp)
    6be0:	000197b7          	lui	a5,0x19
    6be4:	ffb78793          	addi	a5,a5,-5 # 18ffb <__modsi3+0xef27>
    6be8:	14e7ea63          	bltu	a5,a4,6d3c <pvPortMalloc+0x1d8>
    6bec:	00033797          	auipc	a5,0x33
    6bf0:	b4c78793          	addi	a5,a5,-1204 # 39738 <xStart>
    6bf4:	02f12423          	sw	a5,40(sp)
    6bf8:	00033797          	auipc	a5,0x33
    6bfc:	b4078793          	addi	a5,a5,-1216 # 39738 <xStart>
    6c00:	0007a783          	lw	a5,0(a5)
    6c04:	02f12623          	sw	a5,44(sp)
    6c08:	0180006f          	j	6c20 <pvPortMalloc+0xbc>
    6c0c:	02c12783          	lw	a5,44(sp)
    6c10:	02f12423          	sw	a5,40(sp)
    6c14:	02c12783          	lw	a5,44(sp)
    6c18:	0007a783          	lw	a5,0(a5)
    6c1c:	02f12623          	sw	a5,44(sp)
    6c20:	02c12783          	lw	a5,44(sp)
    6c24:	0047a783          	lw	a5,4(a5)
    6c28:	00c12703          	lw	a4,12(sp)
    6c2c:	00e7f863          	bleu	a4,a5,6c3c <pvPortMalloc+0xd8>
    6c30:	02c12783          	lw	a5,44(sp)
    6c34:	0007a783          	lw	a5,0(a5)
    6c38:	fc079ae3          	bnez	a5,6c0c <pvPortMalloc+0xa8>
    6c3c:	02c12703          	lw	a4,44(sp)
    6c40:	00033797          	auipc	a5,0x33
    6c44:	b0078793          	addi	a5,a5,-1280 # 39740 <xEnd>
    6c48:	0ef70a63          	beq	a4,a5,6d3c <pvPortMalloc+0x1d8>
    6c4c:	02812783          	lw	a5,40(sp)
    6c50:	0007a783          	lw	a5,0(a5)
    6c54:	00800713          	li	a4,8
    6c58:	00e787b3          	add	a5,a5,a4
    6c5c:	02f12223          	sw	a5,36(sp)
    6c60:	02c12783          	lw	a5,44(sp)
    6c64:	0007a703          	lw	a4,0(a5)
    6c68:	02812783          	lw	a5,40(sp)
    6c6c:	00e7a023          	sw	a4,0(a5)
    6c70:	02c12783          	lw	a5,44(sp)
    6c74:	0047a703          	lw	a4,4(a5)
    6c78:	00c12783          	lw	a5,12(sp)
    6c7c:	40f707b3          	sub	a5,a4,a5
    6c80:	00800713          	li	a4,8
    6c84:	00171713          	slli	a4,a4,0x1
    6c88:	08f77863          	bleu	a5,a4,6d18 <pvPortMalloc+0x1b4>
    6c8c:	02c12703          	lw	a4,44(sp)
    6c90:	00c12783          	lw	a5,12(sp)
    6c94:	00f707b3          	add	a5,a4,a5
    6c98:	00f12e23          	sw	a5,28(sp)
    6c9c:	02c12783          	lw	a5,44(sp)
    6ca0:	0047a703          	lw	a4,4(a5)
    6ca4:	00c12783          	lw	a5,12(sp)
    6ca8:	40f70733          	sub	a4,a4,a5
    6cac:	01c12783          	lw	a5,28(sp)
    6cb0:	00e7a223          	sw	a4,4(a5)
    6cb4:	02c12783          	lw	a5,44(sp)
    6cb8:	00c12703          	lw	a4,12(sp)
    6cbc:	00e7a223          	sw	a4,4(a5)
    6cc0:	01c12783          	lw	a5,28(sp)
    6cc4:	0047a783          	lw	a5,4(a5)
    6cc8:	00f12c23          	sw	a5,24(sp)
    6ccc:	00033797          	auipc	a5,0x33
    6cd0:	a6c78793          	addi	a5,a5,-1428 # 39738 <xStart>
    6cd4:	02f12023          	sw	a5,32(sp)
    6cd8:	0100006f          	j	6ce8 <pvPortMalloc+0x184>
    6cdc:	02012783          	lw	a5,32(sp)
    6ce0:	0007a783          	lw	a5,0(a5)
    6ce4:	02f12023          	sw	a5,32(sp)
    6ce8:	02012783          	lw	a5,32(sp)
    6cec:	0007a783          	lw	a5,0(a5)
    6cf0:	0047a783          	lw	a5,4(a5)
    6cf4:	01812703          	lw	a4,24(sp)
    6cf8:	fee7e2e3          	bltu	a5,a4,6cdc <pvPortMalloc+0x178>
    6cfc:	02012783          	lw	a5,32(sp)
    6d00:	0007a703          	lw	a4,0(a5)
    6d04:	01c12783          	lw	a5,28(sp)
    6d08:	00e7a023          	sw	a4,0(a5)
    6d0c:	02012783          	lw	a5,32(sp)
    6d10:	01c12703          	lw	a4,28(sp)
    6d14:	00e7a023          	sw	a4,0(a5)
    6d18:	0001a797          	auipc	a5,0x1a
    6d1c:	84c78793          	addi	a5,a5,-1972 # 20564 <xFreeBytesRemaining>
    6d20:	0007a703          	lw	a4,0(a5)
    6d24:	02c12783          	lw	a5,44(sp)
    6d28:	0047a783          	lw	a5,4(a5)
    6d2c:	40f70733          	sub	a4,a4,a5
    6d30:	0001a797          	auipc	a5,0x1a
    6d34:	83478793          	addi	a5,a5,-1996 # 20564 <xFreeBytesRemaining>
    6d38:	00e7a023          	sw	a4,0(a5)
    6d3c:	f7cfc0ef          	jal	ra,34b8 <xTaskResumeAll>
    6d40:	02412783          	lw	a5,36(sp)
    6d44:	00079463          	bnez	a5,6d4c <pvPortMalloc+0x1e8>
    6d48:	304010ef          	jal	ra,804c <vApplicationMallocFailedHook>
    6d4c:	02412783          	lw	a5,36(sp)
    6d50:	00078513          	mv	a0,a5
    6d54:	03c12083          	lw	ra,60(sp)
    6d58:	04010113          	addi	sp,sp,64
    6d5c:	00008067          	ret

00006d60 <vPortFree>:
    6d60:	fd010113          	addi	sp,sp,-48
    6d64:	02112623          	sw	ra,44(sp)
    6d68:	00a12623          	sw	a0,12(sp)
    6d6c:	00c12783          	lw	a5,12(sp)
    6d70:	00f12c23          	sw	a5,24(sp)
    6d74:	00c12783          	lw	a5,12(sp)
    6d78:	0a078263          	beqz	a5,6e1c <vPortFree+0xbc>
    6d7c:	00800793          	li	a5,8
    6d80:	40f007b3          	neg	a5,a5
    6d84:	01812703          	lw	a4,24(sp)
    6d88:	00f707b3          	add	a5,a4,a5
    6d8c:	00f12c23          	sw	a5,24(sp)
    6d90:	01812783          	lw	a5,24(sp)
    6d94:	00f12a23          	sw	a5,20(sp)
    6d98:	efcfc0ef          	jal	ra,3494 <vTaskSuspendAll>
    6d9c:	01412783          	lw	a5,20(sp)
    6da0:	0047a783          	lw	a5,4(a5)
    6da4:	00f12823          	sw	a5,16(sp)
    6da8:	00033797          	auipc	a5,0x33
    6dac:	99078793          	addi	a5,a5,-1648 # 39738 <xStart>
    6db0:	00f12e23          	sw	a5,28(sp)
    6db4:	0100006f          	j	6dc4 <vPortFree+0x64>
    6db8:	01c12783          	lw	a5,28(sp)
    6dbc:	0007a783          	lw	a5,0(a5)
    6dc0:	00f12e23          	sw	a5,28(sp)
    6dc4:	01c12783          	lw	a5,28(sp)
    6dc8:	0007a783          	lw	a5,0(a5)
    6dcc:	0047a783          	lw	a5,4(a5)
    6dd0:	01012703          	lw	a4,16(sp)
    6dd4:	fee7e2e3          	bltu	a5,a4,6db8 <vPortFree+0x58>
    6dd8:	01c12783          	lw	a5,28(sp)
    6ddc:	0007a703          	lw	a4,0(a5)
    6de0:	01412783          	lw	a5,20(sp)
    6de4:	00e7a023          	sw	a4,0(a5)
    6de8:	01c12783          	lw	a5,28(sp)
    6dec:	01412703          	lw	a4,20(sp)
    6df0:	00e7a023          	sw	a4,0(a5)
    6df4:	01412783          	lw	a5,20(sp)
    6df8:	0047a703          	lw	a4,4(a5)
    6dfc:	00019797          	auipc	a5,0x19
    6e00:	76878793          	addi	a5,a5,1896 # 20564 <xFreeBytesRemaining>
    6e04:	0007a783          	lw	a5,0(a5)
    6e08:	00f70733          	add	a4,a4,a5
    6e0c:	00019797          	auipc	a5,0x19
    6e10:	75878793          	addi	a5,a5,1880 # 20564 <xFreeBytesRemaining>
    6e14:	00e7a023          	sw	a4,0(a5)
    6e18:	ea0fc0ef          	jal	ra,34b8 <xTaskResumeAll>
    6e1c:	00000013          	nop
    6e20:	02c12083          	lw	ra,44(sp)
    6e24:	03010113          	addi	sp,sp,48
    6e28:	00008067          	ret

00006e2c <xPortGetFreeHeapSize>:
    6e2c:	00019797          	auipc	a5,0x19
    6e30:	73878793          	addi	a5,a5,1848 # 20564 <xFreeBytesRemaining>
    6e34:	0007a783          	lw	a5,0(a5)
    6e38:	00078513          	mv	a0,a5
    6e3c:	00008067          	ret

00006e40 <vPortInitialiseBlocks>:
    6e40:	00000013          	nop
    6e44:	00008067          	ret

00006e48 <prvHeapInit>:
    6e48:	ff010113          	addi	sp,sp,-16
    6e4c:	0001a797          	auipc	a5,0x1a
    6e50:	8f078793          	addi	a5,a5,-1808 # 2073c <ucHeap+0x4>
    6e54:	ffc7f793          	andi	a5,a5,-4
    6e58:	00f12623          	sw	a5,12(sp)
    6e5c:	00033797          	auipc	a5,0x33
    6e60:	8dc78793          	addi	a5,a5,-1828 # 39738 <xStart>
    6e64:	00c12703          	lw	a4,12(sp)
    6e68:	00e7a023          	sw	a4,0(a5)
    6e6c:	00033797          	auipc	a5,0x33
    6e70:	8cc78793          	addi	a5,a5,-1844 # 39738 <xStart>
    6e74:	0007a223          	sw	zero,4(a5)
    6e78:	00033797          	auipc	a5,0x33
    6e7c:	8c878793          	addi	a5,a5,-1848 # 39740 <xEnd>
    6e80:	00019737          	lui	a4,0x19
    6e84:	ffc70713          	addi	a4,a4,-4 # 18ffc <__modsi3+0xef28>
    6e88:	00e7a223          	sw	a4,4(a5)
    6e8c:	00033797          	auipc	a5,0x33
    6e90:	8b478793          	addi	a5,a5,-1868 # 39740 <xEnd>
    6e94:	0007a023          	sw	zero,0(a5)
    6e98:	00c12783          	lw	a5,12(sp)
    6e9c:	00f12423          	sw	a5,8(sp)
    6ea0:	00812783          	lw	a5,8(sp)
    6ea4:	00019737          	lui	a4,0x19
    6ea8:	ffc70713          	addi	a4,a4,-4 # 18ffc <__modsi3+0xef28>
    6eac:	00e7a223          	sw	a4,4(a5)
    6eb0:	00812783          	lw	a5,8(sp)
    6eb4:	00033717          	auipc	a4,0x33
    6eb8:	88c70713          	addi	a4,a4,-1908 # 39740 <xEnd>
    6ebc:	00e7a023          	sw	a4,0(a5)
    6ec0:	00000013          	nop
    6ec4:	01010113          	addi	sp,sp,16
    6ec8:	00008067          	ret

00006ecc <memcpy>:
    6ecc:	fe010113          	addi	sp,sp,-32
    6ed0:	00a12623          	sw	a0,12(sp)
    6ed4:	00b12423          	sw	a1,8(sp)
    6ed8:	00c12223          	sw	a2,4(sp)
    6edc:	00812783          	lw	a5,8(sp)
    6ee0:	00f12e23          	sw	a5,28(sp)
    6ee4:	00c12783          	lw	a5,12(sp)
    6ee8:	00f12c23          	sw	a5,24(sp)
    6eec:	00c12703          	lw	a4,12(sp)
    6ef0:	00812783          	lw	a5,8(sp)
    6ef4:	00f767b3          	or	a5,a4,a5
    6ef8:	0037f793          	andi	a5,a5,3
    6efc:	06079663          	bnez	a5,6f68 <memcpy+0x9c>
    6f00:	02c0006f          	j	6f2c <memcpy+0x60>
    6f04:	01c12783          	lw	a5,28(sp)
    6f08:	0007a703          	lw	a4,0(a5)
    6f0c:	01812783          	lw	a5,24(sp)
    6f10:	00e7a023          	sw	a4,0(a5)
    6f14:	01812783          	lw	a5,24(sp)
    6f18:	00478793          	addi	a5,a5,4
    6f1c:	00f12c23          	sw	a5,24(sp)
    6f20:	01c12783          	lw	a5,28(sp)
    6f24:	00478793          	addi	a5,a5,4
    6f28:	00f12e23          	sw	a5,28(sp)
    6f2c:	00412783          	lw	a5,4(sp)
    6f30:	ffd78793          	addi	a5,a5,-3
    6f34:	00c12703          	lw	a4,12(sp)
    6f38:	00f707b3          	add	a5,a4,a5
    6f3c:	01812703          	lw	a4,24(sp)
    6f40:	fcf762e3          	bltu	a4,a5,6f04 <memcpy+0x38>
    6f44:	0240006f          	j	6f68 <memcpy+0x9c>
    6f48:	01c12703          	lw	a4,28(sp)
    6f4c:	00170793          	addi	a5,a4,1
    6f50:	00f12e23          	sw	a5,28(sp)
    6f54:	01812783          	lw	a5,24(sp)
    6f58:	00178693          	addi	a3,a5,1
    6f5c:	00d12c23          	sw	a3,24(sp)
    6f60:	00074703          	lbu	a4,0(a4)
    6f64:	00e78023          	sb	a4,0(a5)
    6f68:	00c12703          	lw	a4,12(sp)
    6f6c:	00412783          	lw	a5,4(sp)
    6f70:	00f707b3          	add	a5,a4,a5
    6f74:	01812703          	lw	a4,24(sp)
    6f78:	fcf768e3          	bltu	a4,a5,6f48 <memcpy+0x7c>
    6f7c:	00c12783          	lw	a5,12(sp)
    6f80:	00078513          	mv	a0,a5
    6f84:	02010113          	addi	sp,sp,32
    6f88:	00008067          	ret

00006f8c <memset>:
    6f8c:	fe010113          	addi	sp,sp,-32
    6f90:	00a12623          	sw	a0,12(sp)
    6f94:	00b12423          	sw	a1,8(sp)
    6f98:	00c12223          	sw	a2,4(sp)
    6f9c:	00c12703          	lw	a4,12(sp)
    6fa0:	00412783          	lw	a5,4(sp)
    6fa4:	00f767b3          	or	a5,a4,a5
    6fa8:	0037f793          	andi	a5,a5,3
    6fac:	06079863          	bnez	a5,701c <memset+0x90>
    6fb0:	00812783          	lw	a5,8(sp)
    6fb4:	0ff7f793          	andi	a5,a5,255
    6fb8:	00f12a23          	sw	a5,20(sp)
    6fbc:	01412783          	lw	a5,20(sp)
    6fc0:	00879793          	slli	a5,a5,0x8
    6fc4:	01412703          	lw	a4,20(sp)
    6fc8:	00f767b3          	or	a5,a4,a5
    6fcc:	00f12a23          	sw	a5,20(sp)
    6fd0:	01412783          	lw	a5,20(sp)
    6fd4:	01079793          	slli	a5,a5,0x10
    6fd8:	01412703          	lw	a4,20(sp)
    6fdc:	00f767b3          	or	a5,a4,a5
    6fe0:	00f12a23          	sw	a5,20(sp)
    6fe4:	00c12783          	lw	a5,12(sp)
    6fe8:	00f12e23          	sw	a5,28(sp)
    6fec:	0180006f          	j	7004 <memset+0x78>
    6ff0:	01c12783          	lw	a5,28(sp)
    6ff4:	00478713          	addi	a4,a5,4
    6ff8:	00e12e23          	sw	a4,28(sp)
    6ffc:	01412703          	lw	a4,20(sp)
    7000:	00e7a023          	sw	a4,0(a5)
    7004:	00c12703          	lw	a4,12(sp)
    7008:	00412783          	lw	a5,4(sp)
    700c:	00f707b3          	add	a5,a4,a5
    7010:	01c12703          	lw	a4,28(sp)
    7014:	fcf76ee3          	bltu	a4,a5,6ff0 <memset+0x64>
    7018:	03c0006f          	j	7054 <memset+0xc8>
    701c:	00c12783          	lw	a5,12(sp)
    7020:	00f12c23          	sw	a5,24(sp)
    7024:	01c0006f          	j	7040 <memset+0xb4>
    7028:	01812783          	lw	a5,24(sp)
    702c:	00178713          	addi	a4,a5,1
    7030:	00e12c23          	sw	a4,24(sp)
    7034:	00812703          	lw	a4,8(sp)
    7038:	0ff77713          	andi	a4,a4,255
    703c:	00e78023          	sb	a4,0(a5)
    7040:	00c12703          	lw	a4,12(sp)
    7044:	00412783          	lw	a5,4(sp)
    7048:	00f707b3          	add	a5,a4,a5
    704c:	01812703          	lw	a4,24(sp)
    7050:	fcf76ce3          	bltu	a4,a5,7028 <memset+0x9c>
    7054:	00c12783          	lw	a5,12(sp)
    7058:	00078513          	mv	a0,a5
    705c:	02010113          	addi	sp,sp,32
    7060:	00008067          	ret

00007064 <strlen>:
    7064:	fe010113          	addi	sp,sp,-32
    7068:	00a12623          	sw	a0,12(sp)
    706c:	00c12783          	lw	a5,12(sp)
    7070:	00f12e23          	sw	a5,28(sp)
    7074:	0100006f          	j	7084 <strlen+0x20>
    7078:	01c12783          	lw	a5,28(sp)
    707c:	00178793          	addi	a5,a5,1
    7080:	00f12e23          	sw	a5,28(sp)
    7084:	01c12783          	lw	a5,28(sp)
    7088:	0007c783          	lbu	a5,0(a5)
    708c:	fe0796e3          	bnez	a5,7078 <strlen+0x14>
    7090:	01c12703          	lw	a4,28(sp)
    7094:	00c12783          	lw	a5,12(sp)
    7098:	40f707b3          	sub	a5,a4,a5
    709c:	00078513          	mv	a0,a5
    70a0:	02010113          	addi	sp,sp,32
    70a4:	00008067          	ret

000070a8 <strcmp>:
    70a8:	fe010113          	addi	sp,sp,-32
    70ac:	00a12623          	sw	a0,12(sp)
    70b0:	00b12423          	sw	a1,8(sp)
    70b4:	00c12783          	lw	a5,12(sp)
    70b8:	00178713          	addi	a4,a5,1
    70bc:	00e12623          	sw	a4,12(sp)
    70c0:	0007c783          	lbu	a5,0(a5)
    70c4:	00f10fa3          	sb	a5,31(sp)
    70c8:	00812783          	lw	a5,8(sp)
    70cc:	00178713          	addi	a4,a5,1
    70d0:	00e12423          	sw	a4,8(sp)
    70d4:	0007c783          	lbu	a5,0(a5)
    70d8:	00f10f23          	sb	a5,30(sp)
    70dc:	01f14783          	lbu	a5,31(sp)
    70e0:	00078863          	beqz	a5,70f0 <strcmp+0x48>
    70e4:	01f14703          	lbu	a4,31(sp)
    70e8:	01e14783          	lbu	a5,30(sp)
    70ec:	fcf704e3          	beq	a4,a5,70b4 <strcmp+0xc>
    70f0:	01f14703          	lbu	a4,31(sp)
    70f4:	01e14783          	lbu	a5,30(sp)
    70f8:	40f707b3          	sub	a5,a4,a5
    70fc:	00078513          	mv	a0,a5
    7100:	02010113          	addi	sp,sp,32
    7104:	00008067          	ret

00007108 <strcpy>:
    7108:	fe010113          	addi	sp,sp,-32
    710c:	00a12623          	sw	a0,12(sp)
    7110:	00b12423          	sw	a1,8(sp)
    7114:	00c12783          	lw	a5,12(sp)
    7118:	00f12e23          	sw	a5,28(sp)
    711c:	00000013          	nop
    7120:	00812703          	lw	a4,8(sp)
    7124:	00170793          	addi	a5,a4,1
    7128:	00f12423          	sw	a5,8(sp)
    712c:	01c12783          	lw	a5,28(sp)
    7130:	00178693          	addi	a3,a5,1
    7134:	00d12e23          	sw	a3,28(sp)
    7138:	00074703          	lbu	a4,0(a4)
    713c:	00e78023          	sb	a4,0(a5)
    7140:	0007c783          	lbu	a5,0(a5)
    7144:	fc079ee3          	bnez	a5,7120 <strcpy+0x18>
    7148:	00c12783          	lw	a5,12(sp)
    714c:	00078513          	mv	a0,a5
    7150:	02010113          	addi	sp,sp,32
    7154:	00008067          	ret

00007158 <atol>:
    7158:	fe010113          	addi	sp,sp,-32
    715c:	00a12623          	sw	a0,12(sp)
    7160:	00012e23          	sw	zero,28(sp)
    7164:	00012c23          	sw	zero,24(sp)
    7168:	0100006f          	j	7178 <atol+0x20>
    716c:	00c12783          	lw	a5,12(sp)
    7170:	00178793          	addi	a5,a5,1
    7174:	00f12623          	sw	a5,12(sp)
    7178:	00c12783          	lw	a5,12(sp)
    717c:	0007c703          	lbu	a4,0(a5)
    7180:	02000793          	li	a5,32
    7184:	fef704e3          	beq	a4,a5,716c <atol+0x14>
    7188:	00c12783          	lw	a5,12(sp)
    718c:	0007c703          	lbu	a4,0(a5)
    7190:	02d00793          	li	a5,45
    7194:	00f70a63          	beq	a4,a5,71a8 <atol+0x50>
    7198:	00c12783          	lw	a5,12(sp)
    719c:	0007c703          	lbu	a4,0(a5)
    71a0:	02b00793          	li	a5,43
    71a4:	06f71263          	bne	a4,a5,7208 <atol+0xb0>
    71a8:	00c12783          	lw	a5,12(sp)
    71ac:	0007c783          	lbu	a5,0(a5)
    71b0:	fd378793          	addi	a5,a5,-45
    71b4:	0017b793          	seqz	a5,a5
    71b8:	0ff7f793          	andi	a5,a5,255
    71bc:	00f12c23          	sw	a5,24(sp)
    71c0:	00c12783          	lw	a5,12(sp)
    71c4:	00178793          	addi	a5,a5,1
    71c8:	00f12623          	sw	a5,12(sp)
    71cc:	03c0006f          	j	7208 <atol+0xb0>
    71d0:	01c12703          	lw	a4,28(sp)
    71d4:	00070793          	mv	a5,a4
    71d8:	00279793          	slli	a5,a5,0x2
    71dc:	00e787b3          	add	a5,a5,a4
    71e0:	00179793          	slli	a5,a5,0x1
    71e4:	00f12e23          	sw	a5,28(sp)
    71e8:	00c12783          	lw	a5,12(sp)
    71ec:	00178713          	addi	a4,a5,1
    71f0:	00e12623          	sw	a4,12(sp)
    71f4:	0007c783          	lbu	a5,0(a5)
    71f8:	fd078793          	addi	a5,a5,-48
    71fc:	01c12703          	lw	a4,28(sp)
    7200:	00f707b3          	add	a5,a4,a5
    7204:	00f12e23          	sw	a5,28(sp)
    7208:	00c12783          	lw	a5,12(sp)
    720c:	0007c783          	lbu	a5,0(a5)
    7210:	fc0790e3          	bnez	a5,71d0 <atol+0x78>
    7214:	01812783          	lw	a5,24(sp)
    7218:	00078863          	beqz	a5,7228 <atol+0xd0>
    721c:	01c12783          	lw	a5,28(sp)
    7220:	40f007b3          	neg	a5,a5
    7224:	0080006f          	j	722c <atol+0xd4>
    7228:	01c12783          	lw	a5,28(sp)
    722c:	00078513          	mv	a0,a5
    7230:	02010113          	addi	sp,sp,32
    7234:	00008067          	ret

00007238 <zeroExtend>:
    7238:	fe010113          	addi	sp,sp,-32
    723c:	00a12623          	sw	a0,12(sp)
    7240:	00c12783          	lw	a5,12(sp)
    7244:	00f12c23          	sw	a5,24(sp)
    7248:	41f7d793          	srai	a5,a5,0x1f
    724c:	00f12e23          	sw	a5,28(sp)
    7250:	00c12783          	lw	a5,12(sp)
    7254:	00f12c23          	sw	a5,24(sp)
    7258:	00012e23          	sw	zero,28(sp)
    725c:	01812783          	lw	a5,24(sp)
    7260:	01c12803          	lw	a6,28(sp)
    7264:	00078513          	mv	a0,a5
    7268:	00080593          	mv	a1,a6
    726c:	02010113          	addi	sp,sp,32
    7270:	00008067          	ret

00007274 <prvSyscallToHost>:
    7274:	f6010113          	addi	sp,sp,-160
    7278:	08112e23          	sw	ra,156(sp)
    727c:	08812c23          	sw	s0,152(sp)
    7280:	00a12623          	sw	a0,12(sp)
    7284:	00b12423          	sw	a1,8(sp)
    7288:	00c12223          	sw	a2,4(sp)
    728c:	00d12023          	sw	a3,0(sp)
    7290:	09010793          	addi	a5,sp,144
    7294:	f8078793          	addi	a5,a5,-128
    7298:	03f78793          	addi	a5,a5,63
    729c:	0067d793          	srli	a5,a5,0x6
    72a0:	00679413          	slli	s0,a5,0x6
    72a4:	00c12503          	lw	a0,12(sp)
    72a8:	f91ff0ef          	jal	ra,7238 <zeroExtend>
    72ac:	00050793          	mv	a5,a0
    72b0:	00058813          	mv	a6,a1
    72b4:	00f42023          	sw	a5,0(s0)
    72b8:	01042223          	sw	a6,4(s0)
    72bc:	00812503          	lw	a0,8(sp)
    72c0:	f79ff0ef          	jal	ra,7238 <zeroExtend>
    72c4:	00050793          	mv	a5,a0
    72c8:	00058813          	mv	a6,a1
    72cc:	00f42423          	sw	a5,8(s0)
    72d0:	01042623          	sw	a6,12(s0)
    72d4:	00412503          	lw	a0,4(sp)
    72d8:	f61ff0ef          	jal	ra,7238 <zeroExtend>
    72dc:	00050793          	mv	a5,a0
    72e0:	00058813          	mv	a6,a1
    72e4:	00f42823          	sw	a5,16(s0)
    72e8:	01042a23          	sw	a6,20(s0)
    72ec:	00012503          	lw	a0,0(sp)
    72f0:	f49ff0ef          	jal	ra,7238 <zeroExtend>
    72f4:	00050793          	mv	a5,a0
    72f8:	00058813          	mv	a6,a1
    72fc:	00f42c23          	sw	a5,24(s0)
    7300:	01042e23          	sw	a6,28(s0)
    7304:	0ff0000f          	fence
    7308:	00040793          	mv	a5,s0
    730c:	00078513          	mv	a0,a5
    7310:	f29ff0ef          	jal	ra,7238 <zeroExtend>
    7314:	00050793          	mv	a5,a0
    7318:	00058813          	mv	a6,a1
    731c:	00032717          	auipc	a4,0x32
    7320:	5e470713          	addi	a4,a4,1508 # 39900 <tohost>
    7324:	00f72023          	sw	a5,0(a4)
    7328:	01072223          	sw	a6,4(a4)
    732c:	00042783          	lw	a5,0(s0)
    7330:	00442803          	lw	a6,4(s0)
    7334:	00078513          	mv	a0,a5
    7338:	00080593          	mv	a1,a6
    733c:	09c12083          	lw	ra,156(sp)
    7340:	09812403          	lw	s0,152(sp)
    7344:	0a010113          	addi	sp,sp,160
    7348:	00008067          	ret

0000734c <prvSyscallExit>:
    734c:	fc010113          	addi	sp,sp,-64
    7350:	02112e23          	sw	ra,60(sp)
    7354:	02812c23          	sw	s0,56(sp)
    7358:	02912a23          	sw	s1,52(sp)
    735c:	03212823          	sw	s2,48(sp)
    7360:	03312623          	sw	s3,44(sp)
    7364:	00a12623          	sw	a0,12(sp)
    7368:	00c12503          	lw	a0,12(sp)
    736c:	ecdff0ef          	jal	ra,7238 <zeroExtend>
    7370:	00a12c23          	sw	a0,24(sp)
    7374:	00b12e23          	sw	a1,28(sp)
    7378:	01812783          	lw	a5,24(sp)
    737c:	01f7d793          	srli	a5,a5,0x1f
    7380:	01c12703          	lw	a4,28(sp)
    7384:	00171493          	slli	s1,a4,0x1
    7388:	0097e4b3          	or	s1,a5,s1
    738c:	01812783          	lw	a5,24(sp)
    7390:	00179413          	slli	s0,a5,0x1
    7394:	00146913          	ori	s2,s0,1
    7398:	0004e993          	ori	s3,s1,0
    739c:	00032797          	auipc	a5,0x32
    73a0:	56478793          	addi	a5,a5,1380 # 39900 <tohost>
    73a4:	0127a023          	sw	s2,0(a5)
    73a8:	0137a223          	sw	s3,4(a5)
    73ac:	0000006f          	j	73ac <prvSyscallExit+0x60>

000073b0 <printstr>:
    73b0:	fe010113          	addi	sp,sp,-32
    73b4:	00112e23          	sw	ra,28(sp)
    73b8:	00812c23          	sw	s0,24(sp)
    73bc:	00a12623          	sw	a0,12(sp)
    73c0:	00c12403          	lw	s0,12(sp)
    73c4:	00c12503          	lw	a0,12(sp)
    73c8:	c9dff0ef          	jal	ra,7064 <strlen>
    73cc:	00050793          	mv	a5,a0
    73d0:	00078693          	mv	a3,a5
    73d4:	00040613          	mv	a2,s0
    73d8:	00100593          	li	a1,1
    73dc:	04000513          	li	a0,64
    73e0:	018000ef          	jal	ra,73f8 <syscall>
    73e4:	00000013          	nop
    73e8:	01c12083          	lw	ra,28(sp)
    73ec:	01812403          	lw	s0,24(sp)
    73f0:	02010113          	addi	sp,sp,32
    73f4:	00008067          	ret

000073f8 <syscall>:
    73f8:	ff010113          	addi	sp,sp,-16
    73fc:	00a12623          	sw	a0,12(sp)
    7400:	00b12423          	sw	a1,8(sp)
    7404:	00c12223          	sw	a2,4(sp)
    7408:	00d12023          	sw	a3,0(sp)
    740c:	00c12883          	lw	a7,12(sp)
    7410:	00812503          	lw	a0,8(sp)
    7414:	00412583          	lw	a1,4(sp)
    7418:	00012603          	lw	a2,0(sp)
    741c:	00000073          	ecall
    7420:	00050793          	mv	a5,a0
    7424:	00078513          	mv	a0,a5
    7428:	01010113          	addi	sp,sp,16
    742c:	00008067          	ret
    7430:	fe010113          	addi	sp,sp,-32
    7434:	00112e23          	sw	ra,28(sp)
    7438:	00a12623          	sw	a0,12(sp)
    743c:	00b12423          	sw	a1,8(sp)
    7440:	00019517          	auipc	a0,0x19
    7444:	c2850513          	addi	a0,a0,-984 # 20068 <__rodata_start+0x68>
    7448:	f69ff0ef          	jal	ra,73b0 <printstr>
    744c:	fff00793          	li	a5,-1
    7450:	00078513          	mv	a0,a5
    7454:	01c12083          	lw	ra,28(sp)
    7458:	02010113          	addi	sp,sp,32
    745c:	00008067          	ret

00007460 <vSyscallInit>:
    7460:	fe010113          	addi	sp,sp,-32
    7464:	00112e23          	sw	ra,28(sp)
    7468:	00000593          	li	a1,0
    746c:	00000513          	li	a0,0
    7470:	259000ef          	jal	ra,7ec8 <main>
    7474:	00a12623          	sw	a0,12(sp)
    7478:	00c12503          	lw	a0,12(sp)
    747c:	079000ef          	jal	ra,7cf4 <exit>
    7480:	00000013          	nop
    7484:	01c12083          	lw	ra,28(sp)
    7488:	02010113          	addi	sp,sp,32
    748c:	00008067          	ret

00007490 <ulSyscallTrap>:
    7490:	fd010113          	addi	sp,sp,-48
    7494:	02112623          	sw	ra,44(sp)
    7498:	00a12623          	sw	a0,12(sp)
    749c:	00b12423          	sw	a1,8(sp)
    74a0:	00c12223          	sw	a2,4(sp)
    74a4:	00012e23          	sw	zero,28(sp)
    74a8:	00c12703          	lw	a4,12(sp)
    74ac:	00b00793          	li	a5,11
    74b0:	00f70863          	beq	a4,a5,74c0 <ulSyscallTrap+0x30>
    74b4:	00c12503          	lw	a0,12(sp)
    74b8:	e95ff0ef          	jal	ra,734c <prvSyscallExit>
    74bc:	0780006f          	j	7534 <ulSyscallTrap+0xa4>
    74c0:	00412783          	lw	a5,4(sp)
    74c4:	04478793          	addi	a5,a5,68
    74c8:	0007a703          	lw	a4,0(a5)
    74cc:	05d00793          	li	a5,93
    74d0:	00f71e63          	bne	a4,a5,74ec <ulSyscallTrap+0x5c>
    74d4:	00412783          	lw	a5,4(sp)
    74d8:	02878793          	addi	a5,a5,40
    74dc:	0007a783          	lw	a5,0(a5)
    74e0:	00078513          	mv	a0,a5
    74e4:	e69ff0ef          	jal	ra,734c <prvSyscallExit>
    74e8:	04c0006f          	j	7534 <ulSyscallTrap+0xa4>
    74ec:	00412783          	lw	a5,4(sp)
    74f0:	04478793          	addi	a5,a5,68
    74f4:	0007a703          	lw	a4,0(a5)
    74f8:	00412783          	lw	a5,4(sp)
    74fc:	02878793          	addi	a5,a5,40
    7500:	0007a583          	lw	a1,0(a5)
    7504:	00412783          	lw	a5,4(sp)
    7508:	02c78793          	addi	a5,a5,44
    750c:	0007a603          	lw	a2,0(a5)
    7510:	00412783          	lw	a5,4(sp)
    7514:	03078793          	addi	a5,a5,48
    7518:	0007a783          	lw	a5,0(a5)
    751c:	00078693          	mv	a3,a5
    7520:	00070513          	mv	a0,a4
    7524:	d51ff0ef          	jal	ra,7274 <prvSyscallToHost>
    7528:	00050793          	mv	a5,a0
    752c:	00058813          	mv	a6,a1
    7530:	00f12e23          	sw	a5,28(sp)
    7534:	00412783          	lw	a5,4(sp)
    7538:	02878793          	addi	a5,a5,40
    753c:	01c12703          	lw	a4,28(sp)
    7540:	00e7a023          	sw	a4,0(a5)
    7544:	00812783          	lw	a5,8(sp)
    7548:	00478793          	addi	a5,a5,4
    754c:	00078513          	mv	a0,a5
    7550:	02c12083          	lw	ra,44(sp)
    7554:	03010113          	addi	sp,sp,48
    7558:	00008067          	ret

0000755c <putchar>:
    755c:	fe010113          	addi	sp,sp,-32
    7560:	00112e23          	sw	ra,28(sp)
    7564:	00a12623          	sw	a0,12(sp)
    7568:	00032797          	auipc	a5,0x32
    756c:	21878793          	addi	a5,a5,536 # 39780 <buflen.2127>
    7570:	0007a783          	lw	a5,0(a5)
    7574:	00178693          	addi	a3,a5,1
    7578:	00032717          	auipc	a4,0x32
    757c:	20870713          	addi	a4,a4,520 # 39780 <buflen.2127>
    7580:	00d72023          	sw	a3,0(a4)
    7584:	00c12703          	lw	a4,12(sp)
    7588:	0ff77713          	andi	a4,a4,255
    758c:	00032697          	auipc	a3,0x32
    7590:	23468693          	addi	a3,a3,564 # 397c0 <buf.2126>
    7594:	00f687b3          	add	a5,a3,a5
    7598:	00e78023          	sb	a4,0(a5)
    759c:	00c12703          	lw	a4,12(sp)
    75a0:	00a00793          	li	a5,10
    75a4:	00f70c63          	beq	a4,a5,75bc <putchar+0x60>
    75a8:	00032797          	auipc	a5,0x32
    75ac:	1d878793          	addi	a5,a5,472 # 39780 <buflen.2127>
    75b0:	0007a703          	lw	a4,0(a5)
    75b4:	04000793          	li	a5,64
    75b8:	02f71c63          	bne	a4,a5,75f0 <putchar+0x94>
    75bc:	00032717          	auipc	a4,0x32
    75c0:	20470713          	addi	a4,a4,516 # 397c0 <buf.2126>
    75c4:	00032797          	auipc	a5,0x32
    75c8:	1bc78793          	addi	a5,a5,444 # 39780 <buflen.2127>
    75cc:	0007a783          	lw	a5,0(a5)
    75d0:	00078693          	mv	a3,a5
    75d4:	00070613          	mv	a2,a4
    75d8:	00100593          	li	a1,1
    75dc:	04000513          	li	a0,64
    75e0:	e19ff0ef          	jal	ra,73f8 <syscall>
    75e4:	00032797          	auipc	a5,0x32
    75e8:	19c78793          	addi	a5,a5,412 # 39780 <buflen.2127>
    75ec:	0007a023          	sw	zero,0(a5)
    75f0:	00000793          	li	a5,0
    75f4:	00078513          	mv	a0,a5
    75f8:	01c12083          	lw	ra,28(sp)
    75fc:	02010113          	addi	sp,sp,32
    7600:	00008067          	ret

00007604 <printnum>:
    7604:	eb010113          	addi	sp,sp,-336
    7608:	14112623          	sw	ra,332(sp)
    760c:	14812423          	sw	s0,328(sp)
    7610:	14912223          	sw	s1,324(sp)
    7614:	15212023          	sw	s2,320(sp)
    7618:	13312e23          	sw	s3,316(sp)
    761c:	13412c23          	sw	s4,312(sp)
    7620:	13512a23          	sw	s5,308(sp)
    7624:	00a12e23          	sw	a0,28(sp)
    7628:	00b12c23          	sw	a1,24(sp)
    762c:	00c12823          	sw	a2,16(sp)
    7630:	00d12a23          	sw	a3,20(sp)
    7634:	00e12623          	sw	a4,12(sp)
    7638:	00f12423          	sw	a5,8(sp)
    763c:	01012223          	sw	a6,4(sp)
    7640:	12012623          	sw	zero,300(sp)
    7644:	00c12783          	lw	a5,12(sp)
    7648:	00078a13          	mv	s4,a5
    764c:	00000a93          	li	s5,0
    7650:	01012783          	lw	a5,16(sp)
    7654:	01412803          	lw	a6,20(sp)
    7658:	000a0613          	mv	a2,s4
    765c:	000a8693          	mv	a3,s5
    7660:	00078513          	mv	a0,a5
    7664:	00080593          	mv	a1,a6
    7668:	4c4020ef          	jal	ra,9b2c <__umoddi3>
    766c:	00050793          	mv	a5,a0
    7670:	00058813          	mv	a6,a1
    7674:	00078613          	mv	a2,a5
    7678:	00080693          	mv	a3,a6
    767c:	12c12783          	lw	a5,300(sp)
    7680:	00178713          	addi	a4,a5,1
    7684:	12e12623          	sw	a4,300(sp)
    7688:	00060713          	mv	a4,a2
    768c:	00279793          	slli	a5,a5,0x2
    7690:	13010693          	addi	a3,sp,304
    7694:	00f687b3          	add	a5,a3,a5
    7698:	eee7ae23          	sw	a4,-260(a5)
    769c:	00c12783          	lw	a5,12(sp)
    76a0:	00078413          	mv	s0,a5
    76a4:	00000493          	li	s1,0
    76a8:	01412783          	lw	a5,20(sp)
    76ac:	00048713          	mv	a4,s1
    76b0:	04e7e863          	bltu	a5,a4,7700 <printnum+0xfc>
    76b4:	01412783          	lw	a5,20(sp)
    76b8:	00048713          	mv	a4,s1
    76bc:	00e79863          	bne	a5,a4,76cc <printnum+0xc8>
    76c0:	01012783          	lw	a5,16(sp)
    76c4:	00040713          	mv	a4,s0
    76c8:	02e7ec63          	bltu	a5,a4,7700 <printnum+0xfc>
    76cc:	00c12783          	lw	a5,12(sp)
    76d0:	00078913          	mv	s2,a5
    76d4:	00000993          	li	s3,0
    76d8:	00090613          	mv	a2,s2
    76dc:	00098693          	mv	a3,s3
    76e0:	01012503          	lw	a0,16(sp)
    76e4:	01412583          	lw	a1,20(sp)
    76e8:	669010ef          	jal	ra,9550 <__udivdi3>
    76ec:	00050793          	mv	a5,a0
    76f0:	00058813          	mv	a6,a1
    76f4:	00f12823          	sw	a5,16(sp)
    76f8:	01012a23          	sw	a6,20(sp)
    76fc:	f49ff06f          	j	7644 <printnum+0x40>
    7700:	00000013          	nop
    7704:	0140006f          	j	7718 <printnum+0x114>
    7708:	01c12783          	lw	a5,28(sp)
    770c:	01812583          	lw	a1,24(sp)
    7710:	00412503          	lw	a0,4(sp)
    7714:	000780e7          	jalr	a5
    7718:	00812783          	lw	a5,8(sp)
    771c:	fff78713          	addi	a4,a5,-1
    7720:	00e12423          	sw	a4,8(sp)
    7724:	12c12703          	lw	a4,300(sp)
    7728:	fef740e3          	blt	a4,a5,7708 <printnum+0x104>
    772c:	0540006f          	j	7780 <printnum+0x17c>
    7730:	12c12783          	lw	a5,300(sp)
    7734:	00279793          	slli	a5,a5,0x2
    7738:	13010713          	addi	a4,sp,304
    773c:	00f707b3          	add	a5,a4,a5
    7740:	efc7a703          	lw	a4,-260(a5)
    7744:	12c12783          	lw	a5,300(sp)
    7748:	00279793          	slli	a5,a5,0x2
    774c:	13010693          	addi	a3,sp,304
    7750:	00f687b3          	add	a5,a3,a5
    7754:	efc7a683          	lw	a3,-260(a5)
    7758:	00900793          	li	a5,9
    775c:	00d7f663          	bleu	a3,a5,7768 <printnum+0x164>
    7760:	05700793          	li	a5,87
    7764:	0080006f          	j	776c <printnum+0x168>
    7768:	03000793          	li	a5,48
    776c:	00e787b3          	add	a5,a5,a4
    7770:	01c12703          	lw	a4,28(sp)
    7774:	01812583          	lw	a1,24(sp)
    7778:	00078513          	mv	a0,a5
    777c:	000700e7          	jalr	a4
    7780:	12c12783          	lw	a5,300(sp)
    7784:	fff78713          	addi	a4,a5,-1
    7788:	12e12623          	sw	a4,300(sp)
    778c:	faf042e3          	bgtz	a5,7730 <printnum+0x12c>
    7790:	00000013          	nop
    7794:	14c12083          	lw	ra,332(sp)
    7798:	14812403          	lw	s0,328(sp)
    779c:	14412483          	lw	s1,324(sp)
    77a0:	14012903          	lw	s2,320(sp)
    77a4:	13c12983          	lw	s3,316(sp)
    77a8:	13812a03          	lw	s4,312(sp)
    77ac:	13412a83          	lw	s5,308(sp)
    77b0:	15010113          	addi	sp,sp,336
    77b4:	00008067          	ret

000077b8 <getuint>:
    77b8:	ff010113          	addi	sp,sp,-16
    77bc:	00a12623          	sw	a0,12(sp)
    77c0:	00b12423          	sw	a1,8(sp)
    77c4:	00812683          	lw	a3,8(sp)
    77c8:	00100713          	li	a4,1
    77cc:	02d75663          	ble	a3,a4,77f8 <getuint+0x40>
    77d0:	00c12783          	lw	a5,12(sp)
    77d4:	0007a783          	lw	a5,0(a5)
    77d8:	00778793          	addi	a5,a5,7
    77dc:	ff87f793          	andi	a5,a5,-8
    77e0:	00878693          	addi	a3,a5,8
    77e4:	00c12703          	lw	a4,12(sp)
    77e8:	00d72023          	sw	a3,0(a4)
    77ec:	0047a803          	lw	a6,4(a5)
    77f0:	0007a783          	lw	a5,0(a5)
    77f4:	0500006f          	j	7844 <getuint+0x8c>
    77f8:	00812703          	lw	a4,8(sp)
    77fc:	02070463          	beqz	a4,7824 <getuint+0x6c>
    7800:	00c12703          	lw	a4,12(sp)
    7804:	00072703          	lw	a4,0(a4)
    7808:	00470613          	addi	a2,a4,4
    780c:	00c12683          	lw	a3,12(sp)
    7810:	00c6a023          	sw	a2,0(a3)
    7814:	00072703          	lw	a4,0(a4)
    7818:	00070793          	mv	a5,a4
    781c:	00000813          	li	a6,0
    7820:	0240006f          	j	7844 <getuint+0x8c>
    7824:	00c12703          	lw	a4,12(sp)
    7828:	00072703          	lw	a4,0(a4)
    782c:	00470613          	addi	a2,a4,4
    7830:	00c12683          	lw	a3,12(sp)
    7834:	00c6a023          	sw	a2,0(a3)
    7838:	00072703          	lw	a4,0(a4)
    783c:	00070793          	mv	a5,a4
    7840:	00000813          	li	a6,0
    7844:	00078513          	mv	a0,a5
    7848:	00080593          	mv	a1,a6
    784c:	01010113          	addi	sp,sp,16
    7850:	00008067          	ret

00007854 <getint>:
    7854:	ff010113          	addi	sp,sp,-16
    7858:	00a12623          	sw	a0,12(sp)
    785c:	00b12423          	sw	a1,8(sp)
    7860:	00812683          	lw	a3,8(sp)
    7864:	00100713          	li	a4,1
    7868:	02d75663          	ble	a3,a4,7894 <getint+0x40>
    786c:	00c12783          	lw	a5,12(sp)
    7870:	0007a783          	lw	a5,0(a5)
    7874:	00778793          	addi	a5,a5,7
    7878:	ff87f793          	andi	a5,a5,-8
    787c:	00878693          	addi	a3,a5,8
    7880:	00c12703          	lw	a4,12(sp)
    7884:	00d72023          	sw	a3,0(a4)
    7888:	0047a803          	lw	a6,4(a5)
    788c:	0007a783          	lw	a5,0(a5)
    7890:	0580006f          	j	78e8 <getint+0x94>
    7894:	00812703          	lw	a4,8(sp)
    7898:	02070663          	beqz	a4,78c4 <getint+0x70>
    789c:	00c12703          	lw	a4,12(sp)
    78a0:	00072703          	lw	a4,0(a4)
    78a4:	00470613          	addi	a2,a4,4
    78a8:	00c12683          	lw	a3,12(sp)
    78ac:	00c6a023          	sw	a2,0(a3)
    78b0:	00072703          	lw	a4,0(a4)
    78b4:	00070793          	mv	a5,a4
    78b8:	41f75713          	srai	a4,a4,0x1f
    78bc:	00070813          	mv	a6,a4
    78c0:	0280006f          	j	78e8 <getint+0x94>
    78c4:	00c12703          	lw	a4,12(sp)
    78c8:	00072703          	lw	a4,0(a4)
    78cc:	00470613          	addi	a2,a4,4
    78d0:	00c12683          	lw	a3,12(sp)
    78d4:	00c6a023          	sw	a2,0(a3)
    78d8:	00072703          	lw	a4,0(a4)
    78dc:	00070793          	mv	a5,a4
    78e0:	41f75713          	srai	a4,a4,0x1f
    78e4:	00070813          	mv	a6,a4
    78e8:	00078513          	mv	a0,a5
    78ec:	00080593          	mv	a1,a6
    78f0:	01010113          	addi	sp,sp,16
    78f4:	00008067          	ret

000078f8 <vFormatPrintString>:
    78f8:	fc010113          	addi	sp,sp,-64
    78fc:	02112e23          	sw	ra,60(sp)
    7900:	02812c23          	sw	s0,56(sp)
    7904:	02912a23          	sw	s1,52(sp)
    7908:	00a12623          	sw	a0,12(sp)
    790c:	00b12423          	sw	a1,8(sp)
    7910:	00c12223          	sw	a2,4(sp)
    7914:	00d12023          	sw	a3,0(sp)
    7918:	0240006f          	j	793c <vFormatPrintString+0x44>
    791c:	3c040063          	beqz	s0,7cdc <vFormatPrintString+0x3e4>
    7920:	00412783          	lw	a5,4(sp)
    7924:	00178793          	addi	a5,a5,1
    7928:	00f12223          	sw	a5,4(sp)
    792c:	00c12783          	lw	a5,12(sp)
    7930:	00812583          	lw	a1,8(sp)
    7934:	00040513          	mv	a0,s0
    7938:	000780e7          	jalr	a5
    793c:	00412783          	lw	a5,4(sp)
    7940:	0007c783          	lbu	a5,0(a5)
    7944:	00078413          	mv	s0,a5
    7948:	02500793          	li	a5,37
    794c:	fcf418e3          	bne	s0,a5,791c <vFormatPrintString+0x24>
    7950:	00412783          	lw	a5,4(sp)
    7954:	00178793          	addi	a5,a5,1
    7958:	00f12223          	sw	a5,4(sp)
    795c:	00412783          	lw	a5,4(sp)
    7960:	00f12823          	sw	a5,16(sp)
    7964:	02000793          	li	a5,32
    7968:	00f10ba3          	sb	a5,23(sp)
    796c:	fff00793          	li	a5,-1
    7970:	00f12e23          	sw	a5,28(sp)
    7974:	fff00793          	li	a5,-1
    7978:	00f12c23          	sw	a5,24(sp)
    797c:	02012023          	sw	zero,32(sp)
    7980:	00412783          	lw	a5,4(sp)
    7984:	00178713          	addi	a4,a5,1
    7988:	00e12223          	sw	a4,4(sp)
    798c:	0007c783          	lbu	a5,0(a5)
    7990:	00078413          	mv	s0,a5
    7994:	fdd40793          	addi	a5,s0,-35
    7998:	05500713          	li	a4,85
    799c:	32f76063          	bltu	a4,a5,7cbc <vFormatPrintString+0x3c4>
    79a0:	00279713          	slli	a4,a5,0x2
    79a4:	00018797          	auipc	a5,0x18
    79a8:	6e878793          	addi	a5,a5,1768 # 2008c <__rodata_start+0x8c>
    79ac:	00f707b3          	add	a5,a4,a5
    79b0:	0007a703          	lw	a4,0(a5)
    79b4:	00018797          	auipc	a5,0x18
    79b8:	6d878793          	addi	a5,a5,1752 # 2008c <__rodata_start+0x8c>
    79bc:	00f707b3          	add	a5,a4,a5
    79c0:	00078067          	jr	a5
    79c4:	02d00793          	li	a5,45
    79c8:	00f10ba3          	sb	a5,23(sp)
    79cc:	fb5ff06f          	j	7980 <vFormatPrintString+0x88>
    79d0:	03000793          	li	a5,48
    79d4:	00f10ba3          	sb	a5,23(sp)
    79d8:	fa9ff06f          	j	7980 <vFormatPrintString+0x88>
    79dc:	00012c23          	sw	zero,24(sp)
    79e0:	01812703          	lw	a4,24(sp)
    79e4:	00070793          	mv	a5,a4
    79e8:	00279793          	slli	a5,a5,0x2
    79ec:	00e787b3          	add	a5,a5,a4
    79f0:	00179793          	slli	a5,a5,0x1
    79f4:	00f407b3          	add	a5,s0,a5
    79f8:	fd078793          	addi	a5,a5,-48
    79fc:	00f12c23          	sw	a5,24(sp)
    7a00:	00412783          	lw	a5,4(sp)
    7a04:	0007c783          	lbu	a5,0(a5)
    7a08:	00078413          	mv	s0,a5
    7a0c:	02f00793          	li	a5,47
    7a10:	0487d263          	ble	s0,a5,7a54 <vFormatPrintString+0x15c>
    7a14:	03900793          	li	a5,57
    7a18:	0287ce63          	blt	a5,s0,7a54 <vFormatPrintString+0x15c>
    7a1c:	00412783          	lw	a5,4(sp)
    7a20:	00178793          	addi	a5,a5,1
    7a24:	00f12223          	sw	a5,4(sp)
    7a28:	fb9ff06f          	j	79e0 <vFormatPrintString+0xe8>
    7a2c:	00012783          	lw	a5,0(sp)
    7a30:	00478713          	addi	a4,a5,4
    7a34:	00e12023          	sw	a4,0(sp)
    7a38:	0007a783          	lw	a5,0(a5)
    7a3c:	00f12c23          	sw	a5,24(sp)
    7a40:	0180006f          	j	7a58 <vFormatPrintString+0x160>
    7a44:	01c12783          	lw	a5,28(sp)
    7a48:	f207dce3          	bgez	a5,7980 <vFormatPrintString+0x88>
    7a4c:	00012e23          	sw	zero,28(sp)
    7a50:	f31ff06f          	j	7980 <vFormatPrintString+0x88>
    7a54:	00000013          	nop
    7a58:	01c12783          	lw	a5,28(sp)
    7a5c:	f207d2e3          	bgez	a5,7980 <vFormatPrintString+0x88>
    7a60:	01812783          	lw	a5,24(sp)
    7a64:	00f12e23          	sw	a5,28(sp)
    7a68:	fff00793          	li	a5,-1
    7a6c:	00f12c23          	sw	a5,24(sp)
    7a70:	f11ff06f          	j	7980 <vFormatPrintString+0x88>
    7a74:	02012783          	lw	a5,32(sp)
    7a78:	00178793          	addi	a5,a5,1
    7a7c:	02f12023          	sw	a5,32(sp)
    7a80:	f01ff06f          	j	7980 <vFormatPrintString+0x88>
    7a84:	00012783          	lw	a5,0(sp)
    7a88:	00478713          	addi	a4,a5,4
    7a8c:	00e12023          	sw	a4,0(sp)
    7a90:	0007a783          	lw	a5,0(a5)
    7a94:	00c12703          	lw	a4,12(sp)
    7a98:	00812583          	lw	a1,8(sp)
    7a9c:	00078513          	mv	a0,a5
    7aa0:	000700e7          	jalr	a4
    7aa4:	2340006f          	j	7cd8 <vFormatPrintString+0x3e0>
    7aa8:	00012783          	lw	a5,0(sp)
    7aac:	00478713          	addi	a4,a5,4
    7ab0:	00e12023          	sw	a4,0(sp)
    7ab4:	0007a483          	lw	s1,0(a5)
    7ab8:	00049663          	bnez	s1,7ac4 <vFormatPrintString+0x1cc>
    7abc:	00018497          	auipc	s1,0x18
    7ac0:	5c848493          	addi	s1,s1,1480 # 20084 <__rodata_start+0x84>
    7ac4:	01c12783          	lw	a5,28(sp)
    7ac8:	08f05063          	blez	a5,7b48 <vFormatPrintString+0x250>
    7acc:	01714703          	lbu	a4,23(sp)
    7ad0:	02d00793          	li	a5,45
    7ad4:	06f70a63          	beq	a4,a5,7b48 <vFormatPrintString+0x250>
    7ad8:	01812783          	lw	a5,24(sp)
    7adc:	00078593          	mv	a1,a5
    7ae0:	00048513          	mv	a0,s1
    7ae4:	249010ef          	jal	ra,952c <strnlen>
    7ae8:	00050713          	mv	a4,a0
    7aec:	01c12783          	lw	a5,28(sp)
    7af0:	40e787b3          	sub	a5,a5,a4
    7af4:	00f12e23          	sw	a5,28(sp)
    7af8:	0240006f          	j	7b1c <vFormatPrintString+0x224>
    7afc:	01714783          	lbu	a5,23(sp)
    7b00:	00c12703          	lw	a4,12(sp)
    7b04:	00812583          	lw	a1,8(sp)
    7b08:	00078513          	mv	a0,a5
    7b0c:	000700e7          	jalr	a4
    7b10:	01c12783          	lw	a5,28(sp)
    7b14:	fff78793          	addi	a5,a5,-1
    7b18:	00f12e23          	sw	a5,28(sp)
    7b1c:	01c12783          	lw	a5,28(sp)
    7b20:	fcf04ee3          	bgtz	a5,7afc <vFormatPrintString+0x204>
    7b24:	0240006f          	j	7b48 <vFormatPrintString+0x250>
    7b28:	00c12783          	lw	a5,12(sp)
    7b2c:	00812583          	lw	a1,8(sp)
    7b30:	00040513          	mv	a0,s0
    7b34:	000780e7          	jalr	a5
    7b38:	00148493          	addi	s1,s1,1
    7b3c:	01c12783          	lw	a5,28(sp)
    7b40:	fff78793          	addi	a5,a5,-1
    7b44:	00f12e23          	sw	a5,28(sp)
    7b48:	0004c783          	lbu	a5,0(s1)
    7b4c:	00078413          	mv	s0,a5
    7b50:	04040063          	beqz	s0,7b90 <vFormatPrintString+0x298>
    7b54:	01812783          	lw	a5,24(sp)
    7b58:	fc07c8e3          	bltz	a5,7b28 <vFormatPrintString+0x230>
    7b5c:	01812783          	lw	a5,24(sp)
    7b60:	fff78793          	addi	a5,a5,-1
    7b64:	00f12c23          	sw	a5,24(sp)
    7b68:	01812783          	lw	a5,24(sp)
    7b6c:	fa07dee3          	bgez	a5,7b28 <vFormatPrintString+0x230>
    7b70:	0200006f          	j	7b90 <vFormatPrintString+0x298>
    7b74:	00c12783          	lw	a5,12(sp)
    7b78:	00812583          	lw	a1,8(sp)
    7b7c:	02000513          	li	a0,32
    7b80:	000780e7          	jalr	a5
    7b84:	01c12783          	lw	a5,28(sp)
    7b88:	fff78793          	addi	a5,a5,-1
    7b8c:	00f12e23          	sw	a5,28(sp)
    7b90:	01c12783          	lw	a5,28(sp)
    7b94:	fef040e3          	bgtz	a5,7b74 <vFormatPrintString+0x27c>
    7b98:	1400006f          	j	7cd8 <vFormatPrintString+0x3e0>
    7b9c:	00010793          	mv	a5,sp
    7ba0:	02012583          	lw	a1,32(sp)
    7ba4:	00078513          	mv	a0,a5
    7ba8:	cadff0ef          	jal	ra,7854 <getint>
    7bac:	00050793          	mv	a5,a0
    7bb0:	00058813          	mv	a6,a1
    7bb4:	02f12423          	sw	a5,40(sp)
    7bb8:	03012623          	sw	a6,44(sp)
    7bbc:	02812783          	lw	a5,40(sp)
    7bc0:	02c12803          	lw	a6,44(sp)
    7bc4:	00080793          	mv	a5,a6
    7bc8:	0407d663          	bgez	a5,7c14 <vFormatPrintString+0x31c>
    7bcc:	00c12783          	lw	a5,12(sp)
    7bd0:	00812583          	lw	a1,8(sp)
    7bd4:	02d00513          	li	a0,45
    7bd8:	000780e7          	jalr	a5
    7bdc:	02812583          	lw	a1,40(sp)
    7be0:	02c12603          	lw	a2,44(sp)
    7be4:	00000793          	li	a5,0
    7be8:	00000813          	li	a6,0
    7bec:	40b786b3          	sub	a3,a5,a1
    7bf0:	00068513          	mv	a0,a3
    7bf4:	00a7b533          	sltu	a0,a5,a0
    7bf8:	40c80733          	sub	a4,a6,a2
    7bfc:	40a707b3          	sub	a5,a4,a0
    7c00:	00078713          	mv	a4,a5
    7c04:	00068793          	mv	a5,a3
    7c08:	00070813          	mv	a6,a4
    7c0c:	02f12423          	sw	a5,40(sp)
    7c10:	03012623          	sw	a6,44(sp)
    7c14:	00a00793          	li	a5,10
    7c18:	02f12223          	sw	a5,36(sp)
    7c1c:	0640006f          	j	7c80 <vFormatPrintString+0x388>
    7c20:	00a00793          	li	a5,10
    7c24:	02f12223          	sw	a5,36(sp)
    7c28:	0400006f          	j	7c68 <vFormatPrintString+0x370>
    7c2c:	00800793          	li	a5,8
    7c30:	02f12223          	sw	a5,36(sp)
    7c34:	0340006f          	j	7c68 <vFormatPrintString+0x370>
    7c38:	00100793          	li	a5,1
    7c3c:	02f12023          	sw	a5,32(sp)
    7c40:	00c12783          	lw	a5,12(sp)
    7c44:	00812583          	lw	a1,8(sp)
    7c48:	03000513          	li	a0,48
    7c4c:	000780e7          	jalr	a5
    7c50:	00c12783          	lw	a5,12(sp)
    7c54:	00812583          	lw	a1,8(sp)
    7c58:	07800513          	li	a0,120
    7c5c:	000780e7          	jalr	a5
    7c60:	01000793          	li	a5,16
    7c64:	02f12223          	sw	a5,36(sp)
    7c68:	00010793          	mv	a5,sp
    7c6c:	02012583          	lw	a1,32(sp)
    7c70:	00078513          	mv	a0,a5
    7c74:	b45ff0ef          	jal	ra,77b8 <getuint>
    7c78:	02a12423          	sw	a0,40(sp)
    7c7c:	02b12623          	sw	a1,44(sp)
    7c80:	02412703          	lw	a4,36(sp)
    7c84:	01714783          	lbu	a5,23(sp)
    7c88:	00078813          	mv	a6,a5
    7c8c:	01c12783          	lw	a5,28(sp)
    7c90:	02812603          	lw	a2,40(sp)
    7c94:	02c12683          	lw	a3,44(sp)
    7c98:	00812583          	lw	a1,8(sp)
    7c9c:	00c12503          	lw	a0,12(sp)
    7ca0:	965ff0ef          	jal	ra,7604 <printnum>
    7ca4:	0340006f          	j	7cd8 <vFormatPrintString+0x3e0>
    7ca8:	00c12783          	lw	a5,12(sp)
    7cac:	00812583          	lw	a1,8(sp)
    7cb0:	00040513          	mv	a0,s0
    7cb4:	000780e7          	jalr	a5
    7cb8:	0200006f          	j	7cd8 <vFormatPrintString+0x3e0>
    7cbc:	00c12783          	lw	a5,12(sp)
    7cc0:	00812583          	lw	a1,8(sp)
    7cc4:	02500513          	li	a0,37
    7cc8:	000780e7          	jalr	a5
    7ccc:	01012783          	lw	a5,16(sp)
    7cd0:	00f12223          	sw	a5,4(sp)
    7cd4:	00000013          	nop
    7cd8:	c65ff06f          	j	793c <vFormatPrintString+0x44>
    7cdc:	00000013          	nop
    7ce0:	03c12083          	lw	ra,60(sp)
    7ce4:	03812403          	lw	s0,56(sp)
    7ce8:	03412483          	lw	s1,52(sp)
    7cec:	04010113          	addi	sp,sp,64
    7cf0:	00008067          	ret

00007cf4 <exit>:
    7cf4:	fe010113          	addi	sp,sp,-32
    7cf8:	00112e23          	sw	ra,28(sp)
    7cfc:	00a12623          	sw	a0,12(sp)
    7d00:	00000693          	li	a3,0
    7d04:	00000613          	li	a2,0
    7d08:	00c12583          	lw	a1,12(sp)
    7d0c:	05d00513          	li	a0,93
    7d10:	ee8ff0ef          	jal	ra,73f8 <syscall>
    7d14:	0000006f          	j	7d14 <exit+0x20>

00007d18 <printf>:
    7d18:	fb010113          	addi	sp,sp,-80
    7d1c:	02112623          	sw	ra,44(sp)
    7d20:	00a12623          	sw	a0,12(sp)
    7d24:	02b12a23          	sw	a1,52(sp)
    7d28:	02c12c23          	sw	a2,56(sp)
    7d2c:	02d12e23          	sw	a3,60(sp)
    7d30:	04e12023          	sw	a4,64(sp)
    7d34:	04f12223          	sw	a5,68(sp)
    7d38:	05012423          	sw	a6,72(sp)
    7d3c:	05112623          	sw	a7,76(sp)
    7d40:	05010793          	addi	a5,sp,80
    7d44:	fe478793          	addi	a5,a5,-28
    7d48:	00f12e23          	sw	a5,28(sp)
    7d4c:	01c12783          	lw	a5,28(sp)
    7d50:	00078693          	mv	a3,a5
    7d54:	00c12603          	lw	a2,12(sp)
    7d58:	00000593          	li	a1,0
    7d5c:	00000517          	auipc	a0,0x0
    7d60:	80050513          	addi	a0,a0,-2048 # 755c <putchar>
    7d64:	b95ff0ef          	jal	ra,78f8 <vFormatPrintString>
    7d68:	00000793          	li	a5,0
    7d6c:	00078513          	mv	a0,a5
    7d70:	02c12083          	lw	ra,44(sp)
    7d74:	05010113          	addi	sp,sp,80
    7d78:	00008067          	ret

00007d7c <sprintf_putch.2235>:
    7d7c:	fe010113          	addi	sp,sp,-32
    7d80:	00a12623          	sw	a0,12(sp)
    7d84:	00b12423          	sw	a1,8(sp)
    7d88:	00712223          	sw	t2,4(sp)
    7d8c:	00812783          	lw	a5,8(sp)
    7d90:	00f12e23          	sw	a5,28(sp)
    7d94:	01c12783          	lw	a5,28(sp)
    7d98:	0007a783          	lw	a5,0(a5)
    7d9c:	00c12703          	lw	a4,12(sp)
    7da0:	0ff77713          	andi	a4,a4,255
    7da4:	00e78023          	sb	a4,0(a5)
    7da8:	01c12783          	lw	a5,28(sp)
    7dac:	0007a783          	lw	a5,0(a5)
    7db0:	00178713          	addi	a4,a5,1
    7db4:	01c12783          	lw	a5,28(sp)
    7db8:	00e7a023          	sw	a4,0(a5)
    7dbc:	00000013          	nop
    7dc0:	02010113          	addi	sp,sp,32
    7dc4:	00008067          	ret

00007dc8 <sprintf>:
    7dc8:	fa010113          	addi	sp,sp,-96
    7dcc:	02112e23          	sw	ra,60(sp)
    7dd0:	00a12623          	sw	a0,12(sp)
    7dd4:	00b12423          	sw	a1,8(sp)
    7dd8:	04c12423          	sw	a2,72(sp)
    7ddc:	04d12623          	sw	a3,76(sp)
    7de0:	04e12823          	sw	a4,80(sp)
    7de4:	04f12a23          	sw	a5,84(sp)
    7de8:	05012c23          	sw	a6,88(sp)
    7dec:	05112e23          	sw	a7,92(sp)
    7df0:	06010793          	addi	a5,sp,96
    7df4:	02f12223          	sw	a5,36(sp)
    7df8:	01410793          	addi	a5,sp,20
    7dfc:	01410593          	addi	a1,sp,20
    7e00:	00000617          	auipc	a2,0x0
    7e04:	f7c60613          	addi	a2,a2,-132 # 7d7c <sprintf_putch.2235>
    7e08:	fffff737          	lui	a4,0xfffff
    7e0c:	fff74693          	not	a3,a4
    7e10:	00001537          	lui	a0,0x1
    7e14:	80050513          	addi	a0,a0,-2048 # 800 <pxPortInitialiseStack+0x38>
    7e18:	00a58833          	add	a6,a1,a0
    7e1c:	00e87833          	and	a6,a6,a4
    7e20:	3b786813          	ori	a6,a6,951
    7e24:	0107a023          	sw	a6,0(a5)
    7e28:	00a60533          	add	a0,a2,a0
    7e2c:	00e57733          	and	a4,a0,a4
    7e30:	33776713          	ori	a4,a4,823
    7e34:	00e7a223          	sw	a4,4(a5)
    7e38:	00d5f733          	and	a4,a1,a3
    7e3c:	01471593          	slli	a1,a4,0x14
    7e40:	00038737          	lui	a4,0x38
    7e44:	39370713          	addi	a4,a4,915 # 38393 <_gp+0x1763f>
    7e48:	00e5e733          	or	a4,a1,a4
    7e4c:	00e7a423          	sw	a4,8(a5)
    7e50:	00d67733          	and	a4,a2,a3
    7e54:	01471693          	slli	a3,a4,0x14
    7e58:	00030737          	lui	a4,0x30
    7e5c:	06770713          	addi	a4,a4,103 # 30067 <_gp+0xf313>
    7e60:	00e6e733          	or	a4,a3,a4
    7e64:	00e7a623          	sw	a4,12(a5)
    7e68:	0000100f          	fence.i
    7e6c:	00c12783          	lw	a5,12(sp)
    7e70:	02f12623          	sw	a5,44(sp)
    7e74:	06010793          	addi	a5,sp,96
    7e78:	fe878793          	addi	a5,a5,-24
    7e7c:	02f12423          	sw	a5,40(sp)
    7e80:	02812703          	lw	a4,40(sp)
    7e84:	01410793          	addi	a5,sp,20
    7e88:	00078513          	mv	a0,a5
    7e8c:	00c10793          	addi	a5,sp,12
    7e90:	00070693          	mv	a3,a4
    7e94:	00812603          	lw	a2,8(sp)
    7e98:	00078593          	mv	a1,a5
    7e9c:	a5dff0ef          	jal	ra,78f8 <vFormatPrintString>
    7ea0:	00c12783          	lw	a5,12(sp)
    7ea4:	00078023          	sb	zero,0(a5)
    7ea8:	00c12783          	lw	a5,12(sp)
    7eac:	00078713          	mv	a4,a5
    7eb0:	02c12783          	lw	a5,44(sp)
    7eb4:	40f707b3          	sub	a5,a4,a5
    7eb8:	00078513          	mv	a0,a5
    7ebc:	03c12083          	lw	ra,60(sp)
    7ec0:	06010113          	addi	sp,sp,96
    7ec4:	00008067          	ret

00007ec8 <main>:
    7ec8:	fe010113          	addi	sp,sp,-32
    7ecc:	00112e23          	sw	ra,28(sp)
    7ed0:	00012623          	sw	zero,12(sp)
    7ed4:	1dc000ef          	jal	ra,80b0 <vCreateBlockTimeTasks>
    7ed8:	389000ef          	jal	ra,8a60 <vStartCountingSemaphoreTasks>
    7edc:	00c010ef          	jal	ra,8ee8 <vStartRecursiveMutexTasks>
    7ee0:	00000717          	auipc	a4,0x0
    7ee4:	08070713          	addi	a4,a4,128 # 7f60 <prvCheckTimerCallback>
    7ee8:	00000693          	li	a3,0
    7eec:	00100613          	li	a2,1
    7ef0:	000017b7          	lui	a5,0x1
    7ef4:	bb878593          	addi	a1,a5,-1096 # bb8 <xQueueGenericReset+0xf8>
    7ef8:	00018517          	auipc	a0,0x18
    7efc:	2ec50513          	addi	a0,a0,748 # 201e4 <__rodata_start+0x1e4>
    7f00:	8fdfd0ef          	jal	ra,57fc <xTimerCreate>
    7f04:	00a12623          	sw	a0,12(sp)
    7f08:	00c12783          	lw	a5,12(sp)
    7f0c:	02078263          	beqz	a5,7f30 <main+0x68>
    7f10:	f7cfb0ef          	jal	ra,368c <xTaskGetTickCount>
    7f14:	00050793          	mv	a5,a0
    7f18:	00000713          	li	a4,0
    7f1c:	00000693          	li	a3,0
    7f20:	00078613          	mv	a2,a5
    7f24:	00100593          	li	a1,1
    7f28:	00c12503          	lw	a0,12(sp)
    7f2c:	9c9fd0ef          	jal	ra,58f4 <xTimerGenericCommand>
    7f30:	00018517          	auipc	a0,0x18
    7f34:	2c050513          	addi	a0,a0,704 # 201f0 <__rodata_start+0x1f0>
    7f38:	de1ff0ef          	jal	ra,7d18 <printf>
    7f3c:	c7cfb0ef          	jal	ra,33b8 <vTaskStartScheduler>
    7f40:	00018517          	auipc	a0,0x18
    7f44:	2c050513          	addi	a0,a0,704 # 20200 <__rodata_start+0x200>
    7f48:	dd1ff0ef          	jal	ra,7d18 <printf>
    7f4c:	00000793          	li	a5,0
    7f50:	00078513          	mv	a0,a5
    7f54:	01c12083          	lw	ra,28(sp)
    7f58:	02010113          	addi	sp,sp,32
    7f5c:	00008067          	ret

00007f60 <prvCheckTimerCallback>:
    7f60:	fd010113          	addi	sp,sp,-48
    7f64:	02112623          	sw	ra,44(sp)
    7f68:	00a12623          	sw	a0,12(sp)
    7f6c:	00012e23          	sw	zero,28(sp)
    7f70:	24d000ef          	jal	ra,89bc <xAreBlockTimeTestTasksStillRunning>
    7f74:	00050713          	mv	a4,a0
    7f78:	00100793          	li	a5,1
    7f7c:	00f70e63          	beq	a4,a5,7f98 <prvCheckTimerCallback+0x38>
    7f80:	00018517          	auipc	a0,0x18
    7f84:	28c50513          	addi	a0,a0,652 # 2020c <__rodata_start+0x20c>
    7f88:	d91ff0ef          	jal	ra,7d18 <printf>
    7f8c:	01c12783          	lw	a5,28(sp)
    7f90:	0027e793          	ori	a5,a5,2
    7f94:	00f12e23          	sw	a5,28(sp)
    7f98:	6a9000ef          	jal	ra,8e40 <xAreCountingSemaphoreTasksStillRunning>
    7f9c:	00050713          	mv	a4,a0
    7fa0:	00100793          	li	a5,1
    7fa4:	00f70e63          	beq	a4,a5,7fc0 <prvCheckTimerCallback+0x60>
    7fa8:	00018517          	auipc	a0,0x18
    7fac:	28850513          	addi	a0,a0,648 # 20230 <__rodata_start+0x230>
    7fb0:	d69ff0ef          	jal	ra,7d18 <printf>
    7fb4:	01c12783          	lw	a5,28(sp)
    7fb8:	0047e793          	ori	a5,a5,4
    7fbc:	00f12e23          	sw	a5,28(sp)
    7fc0:	45c010ef          	jal	ra,941c <xAreRecursiveMutexTasksStillRunning>
    7fc4:	00050713          	mv	a4,a0
    7fc8:	00100793          	li	a5,1
    7fcc:	00f70e63          	beq	a4,a5,7fe8 <prvCheckTimerCallback+0x88>
    7fd0:	00018517          	auipc	a0,0x18
    7fd4:	28850513          	addi	a0,a0,648 # 20258 <__rodata_start+0x258>
    7fd8:	d41ff0ef          	jal	ra,7d18 <printf>
    7fdc:	01c12783          	lw	a5,28(sp)
    7fe0:	0087e793          	ori	a5,a5,8
    7fe4:	00f12e23          	sw	a5,28(sp)
    7fe8:	01c12783          	lw	a5,28(sp)
    7fec:	00078e63          	beqz	a5,8008 <prvCheckTimerCallback+0xa8>
    7ff0:	beefefb7          	lui	t6,0xbeefe
    7ff4:	eadf8f93          	addi	t6,t6,-339 # beefdead <__stack+0xbeec25a5>
    7ff8:	00018517          	auipc	a0,0x18
    7ffc:	28450513          	addi	a0,a0,644 # 2027c <__rodata_start+0x27c>
    8000:	d19ff0ef          	jal	ra,7d18 <printf>
    8004:	0380006f          	j	803c <prvCheckTimerCallback+0xdc>
    8008:	deadcfb7          	lui	t6,0xdeadc
    800c:	eeff8f93          	addi	t6,t6,-273 # deadbeef <__stack+0xdeaa05e7>
    8010:	00031797          	auipc	a5,0x31
    8014:	7f078793          	addi	a5,a5,2032 # 39800 <count.1501>
    8018:	0007a783          	lw	a5,0(a5)
    801c:	00178693          	addi	a3,a5,1
    8020:	00031717          	auipc	a4,0x31
    8024:	7e070713          	addi	a4,a4,2016 # 39800 <count.1501>
    8028:	00d72023          	sw	a3,0(a4)
    802c:	00078593          	mv	a1,a5
    8030:	00018517          	auipc	a0,0x18
    8034:	27050513          	addi	a0,a0,624 # 202a0 <__rodata_start+0x2a0>
    8038:	ce1ff0ef          	jal	ra,7d18 <printf>
    803c:	00000013          	nop
    8040:	02c12083          	lw	ra,44(sp)
    8044:	03010113          	addi	sp,sp,48
    8048:	00008067          	ret

0000804c <vApplicationMallocFailedHook>:
    804c:	ff010113          	addi	sp,sp,-16
    8050:	00112623          	sw	ra,12(sp)
    8054:	00018517          	auipc	a0,0x18
    8058:	27050513          	addi	a0,a0,624 # 202c4 <__rodata_start+0x2c4>
    805c:	cbdff0ef          	jal	ra,7d18 <printf>
    8060:	30047073          	csrci	mstatus,8
    8064:	0000006f          	j	8064 <vApplicationMallocFailedHook+0x18>

00008068 <vApplicationIdleHook>:
    8068:	ff010113          	addi	sp,sp,-16
    806c:	00112623          	sw	ra,12(sp)
    8070:	00018517          	auipc	a0,0x18
    8074:	27450513          	addi	a0,a0,628 # 202e4 <__rodata_start+0x2e4>
    8078:	ca1ff0ef          	jal	ra,7d18 <printf>
    807c:	00000013          	nop
    8080:	00c12083          	lw	ra,12(sp)
    8084:	01010113          	addi	sp,sp,16
    8088:	00008067          	ret

0000808c <vApplicationStackOverflowHook>:
    808c:	fe010113          	addi	sp,sp,-32
    8090:	00112e23          	sw	ra,28(sp)
    8094:	00a12623          	sw	a0,12(sp)
    8098:	00b12423          	sw	a1,8(sp)
    809c:	00018517          	auipc	a0,0x18
    80a0:	26050513          	addi	a0,a0,608 # 202fc <__rodata_start+0x2fc>
    80a4:	c75ff0ef          	jal	ra,7d18 <printf>
    80a8:	30047073          	csrci	mstatus,8
    80ac:	0000006f          	j	80ac <vApplicationStackOverflowHook+0x20>

000080b0 <vCreateBlockTimeTasks>:
    80b0:	ff010113          	addi	sp,sp,-16
    80b4:	00112623          	sw	ra,12(sp)
    80b8:	00000613          	li	a2,0
    80bc:	00400593          	li	a1,4
    80c0:	00500513          	li	a0,5
    80c4:	b39f80ef          	jal	ra,bfc <xQueueGenericCreate>
    80c8:	00050713          	mv	a4,a0
    80cc:	00031797          	auipc	a5,0x31
    80d0:	73878793          	addi	a5,a5,1848 # 39804 <xTestQueue>
    80d4:	00e7a023          	sw	a4,0(a5)
    80d8:	00031797          	auipc	a5,0x31
    80dc:	72c78793          	addi	a5,a5,1836 # 39804 <xTestQueue>
    80e0:	0007a783          	lw	a5,0(a5)
    80e4:	06078663          	beqz	a5,8150 <vCreateBlockTimeTasks+0xa0>
    80e8:	00031797          	auipc	a5,0x31
    80ec:	71c78793          	addi	a5,a5,1820 # 39804 <xTestQueue>
    80f0:	0007a783          	lw	a5,0(a5)
    80f4:	00018597          	auipc	a1,0x18
    80f8:	22858593          	addi	a1,a1,552 # 2031c <__rodata_start+0x31c>
    80fc:	00078513          	mv	a0,a5
    8100:	a00fa0ef          	jal	ra,2300 <vQueueAddToRegistry>
    8104:	00000793          	li	a5,0
    8108:	00200713          	li	a4,2
    810c:	00000693          	li	a3,0
    8110:	40000613          	li	a2,1024
    8114:	00018597          	auipc	a1,0x18
    8118:	21c58593          	addi	a1,a1,540 # 20330 <__rodata_start+0x330>
    811c:	00000517          	auipc	a0,0x0
    8120:	04450513          	addi	a0,a0,68 # 8160 <vPrimaryBlockTimeTestTask>
    8124:	c10fa0ef          	jal	ra,2534 <xTaskCreate>
    8128:	00031797          	auipc	a5,0x31
    812c:	6e078793          	addi	a5,a5,1760 # 39808 <xSecondary>
    8130:	00100713          	li	a4,1
    8134:	00000693          	li	a3,0
    8138:	40000613          	li	a2,1024
    813c:	00018597          	auipc	a1,0x18
    8140:	1fc58593          	addi	a1,a1,508 # 20338 <__rodata_start+0x338>
    8144:	00000517          	auipc	a0,0x0
    8148:	5ac50513          	addi	a0,a0,1452 # 86f0 <vSecondaryBlockTimeTestTask>
    814c:	be8fa0ef          	jal	ra,2534 <xTaskCreate>
    8150:	00000013          	nop
    8154:	00c12083          	lw	ra,12(sp)
    8158:	01010113          	addi	sp,sp,16
    815c:	00008067          	ret

00008160 <vPrimaryBlockTimeTestTask>:
    8160:	fc010113          	addi	sp,sp,-64
    8164:	02112e23          	sw	ra,60(sp)
    8168:	00a12623          	sw	a0,12(sp)
    816c:	720000ef          	jal	ra,888c <prvBasicDelayTests>
    8170:	02012023          	sw	zero,32(sp)
    8174:	0b00006f          	j	8224 <vPrimaryBlockTimeTestTask+0xc4>
    8178:	02012783          	lw	a5,32(sp)
    817c:	00a00713          	li	a4,10
    8180:	00f717b3          	sll	a5,a4,a5
    8184:	02f12623          	sw	a5,44(sp)
    8188:	d04fb0ef          	jal	ra,368c <xTaskGetTickCount>
    818c:	02a12423          	sw	a0,40(sp)
    8190:	00031797          	auipc	a5,0x31
    8194:	67478793          	addi	a5,a5,1652 # 39804 <xTestQueue>
    8198:	0007a783          	lw	a5,0(a5)
    819c:	01c10713          	addi	a4,sp,28
    81a0:	02c12603          	lw	a2,44(sp)
    81a4:	00070593          	mv	a1,a4
    81a8:	00078513          	mv	a0,a5
    81ac:	ac8f90ef          	jal	ra,1474 <xQueueReceive>
    81b0:	00050793          	mv	a5,a0
    81b4:	00078a63          	beqz	a5,81c8 <vPrimaryBlockTimeTestTask+0x68>
    81b8:	00031797          	auipc	a5,0x31
    81bc:	65c78793          	addi	a5,a5,1628 # 39814 <xErrorOccurred>
    81c0:	00100713          	li	a4,1
    81c4:	00e7a023          	sw	a4,0(a5)
    81c8:	cc4fb0ef          	jal	ra,368c <xTaskGetTickCount>
    81cc:	00050713          	mv	a4,a0
    81d0:	02812783          	lw	a5,40(sp)
    81d4:	40f707b3          	sub	a5,a4,a5
    81d8:	02f12223          	sw	a5,36(sp)
    81dc:	02412703          	lw	a4,36(sp)
    81e0:	02c12783          	lw	a5,44(sp)
    81e4:	00f77a63          	bleu	a5,a4,81f8 <vPrimaryBlockTimeTestTask+0x98>
    81e8:	00031797          	auipc	a5,0x31
    81ec:	62c78793          	addi	a5,a5,1580 # 39814 <xErrorOccurred>
    81f0:	00100713          	li	a4,1
    81f4:	00e7a023          	sw	a4,0(a5)
    81f8:	02c12783          	lw	a5,44(sp)
    81fc:	00f78793          	addi	a5,a5,15
    8200:	02412703          	lw	a4,36(sp)
    8204:	00e7fa63          	bleu	a4,a5,8218 <vPrimaryBlockTimeTestTask+0xb8>
    8208:	00031797          	auipc	a5,0x31
    820c:	60c78793          	addi	a5,a5,1548 # 39814 <xErrorOccurred>
    8210:	00100713          	li	a4,1
    8214:	00e7a023          	sw	a4,0(a5)
    8218:	02012783          	lw	a5,32(sp)
    821c:	00178793          	addi	a5,a5,1
    8220:	02f12023          	sw	a5,32(sp)
    8224:	02012703          	lw	a4,32(sp)
    8228:	00400793          	li	a5,4
    822c:	f4e7d6e3          	ble	a4,a5,8178 <vPrimaryBlockTimeTestTask+0x18>
    8230:	02012023          	sw	zero,32(sp)
    8234:	0500006f          	j	8284 <vPrimaryBlockTimeTestTask+0x124>
    8238:	00031797          	auipc	a5,0x31
    823c:	5cc78793          	addi	a5,a5,1484 # 39804 <xTestQueue>
    8240:	0007a783          	lw	a5,0(a5)
    8244:	02010713          	addi	a4,sp,32
    8248:	00000693          	li	a3,0
    824c:	00000613          	li	a2,0
    8250:	00070593          	mv	a1,a4
    8254:	00078513          	mv	a0,a5
    8258:	d21f80ef          	jal	ra,f78 <xQueueGenericSend>
    825c:	00050713          	mv	a4,a0
    8260:	00100793          	li	a5,1
    8264:	00f70a63          	beq	a4,a5,8278 <vPrimaryBlockTimeTestTask+0x118>
    8268:	00031797          	auipc	a5,0x31
    826c:	5ac78793          	addi	a5,a5,1452 # 39814 <xErrorOccurred>
    8270:	00100713          	li	a4,1
    8274:	00e7a023          	sw	a4,0(a5)
    8278:	02012783          	lw	a5,32(sp)
    827c:	00178793          	addi	a5,a5,1
    8280:	02f12023          	sw	a5,32(sp)
    8284:	02012703          	lw	a4,32(sp)
    8288:	00400793          	li	a5,4
    828c:	fae7d6e3          	ble	a4,a5,8238 <vPrimaryBlockTimeTestTask+0xd8>
    8290:	02012023          	sw	zero,32(sp)
    8294:	0b40006f          	j	8348 <vPrimaryBlockTimeTestTask+0x1e8>
    8298:	02012783          	lw	a5,32(sp)
    829c:	00a00713          	li	a4,10
    82a0:	00f717b3          	sll	a5,a4,a5
    82a4:	02f12623          	sw	a5,44(sp)
    82a8:	be4fb0ef          	jal	ra,368c <xTaskGetTickCount>
    82ac:	02a12423          	sw	a0,40(sp)
    82b0:	00031797          	auipc	a5,0x31
    82b4:	55478793          	addi	a5,a5,1364 # 39804 <xTestQueue>
    82b8:	0007a783          	lw	a5,0(a5)
    82bc:	02010713          	addi	a4,sp,32
    82c0:	00000693          	li	a3,0
    82c4:	02c12603          	lw	a2,44(sp)
    82c8:	00070593          	mv	a1,a4
    82cc:	00078513          	mv	a0,a5
    82d0:	ca9f80ef          	jal	ra,f78 <xQueueGenericSend>
    82d4:	00050793          	mv	a5,a0
    82d8:	00078a63          	beqz	a5,82ec <vPrimaryBlockTimeTestTask+0x18c>
    82dc:	00031797          	auipc	a5,0x31
    82e0:	53878793          	addi	a5,a5,1336 # 39814 <xErrorOccurred>
    82e4:	00100713          	li	a4,1
    82e8:	00e7a023          	sw	a4,0(a5)
    82ec:	ba0fb0ef          	jal	ra,368c <xTaskGetTickCount>
    82f0:	00050713          	mv	a4,a0
    82f4:	02812783          	lw	a5,40(sp)
    82f8:	40f707b3          	sub	a5,a4,a5
    82fc:	02f12223          	sw	a5,36(sp)
    8300:	02412703          	lw	a4,36(sp)
    8304:	02c12783          	lw	a5,44(sp)
    8308:	00f77a63          	bleu	a5,a4,831c <vPrimaryBlockTimeTestTask+0x1bc>
    830c:	00031797          	auipc	a5,0x31
    8310:	50878793          	addi	a5,a5,1288 # 39814 <xErrorOccurred>
    8314:	00100713          	li	a4,1
    8318:	00e7a023          	sw	a4,0(a5)
    831c:	02c12783          	lw	a5,44(sp)
    8320:	00f78793          	addi	a5,a5,15
    8324:	02412703          	lw	a4,36(sp)
    8328:	00e7fa63          	bleu	a4,a5,833c <vPrimaryBlockTimeTestTask+0x1dc>
    832c:	00031797          	auipc	a5,0x31
    8330:	4e878793          	addi	a5,a5,1256 # 39814 <xErrorOccurred>
    8334:	00100713          	li	a4,1
    8338:	00e7a023          	sw	a4,0(a5)
    833c:	02012783          	lw	a5,32(sp)
    8340:	00178793          	addi	a5,a5,1
    8344:	02f12023          	sw	a5,32(sp)
    8348:	02012703          	lw	a4,32(sp)
    834c:	00400793          	li	a5,4
    8350:	f4e7d4e3          	ble	a4,a5,8298 <vPrimaryBlockTimeTestTask+0x138>
    8354:	00031797          	auipc	a5,0x31
    8358:	4c478793          	addi	a5,a5,1220 # 39818 <xRunIndicator>
    835c:	0007a023          	sw	zero,0(a5)
    8360:	00031797          	auipc	a5,0x31
    8364:	4a878793          	addi	a5,a5,1192 # 39808 <xSecondary>
    8368:	0007a783          	lw	a5,0(a5)
    836c:	00078513          	mv	a0,a5
    8370:	e25fa0ef          	jal	ra,3194 <vTaskResume>
    8374:	00c0006f          	j	8380 <vPrimaryBlockTimeTestTask+0x220>
    8378:	01400513          	li	a0,20
    837c:	83dfa0ef          	jal	ra,2bb8 <vTaskDelay>
    8380:	00031797          	auipc	a5,0x31
    8384:	49878793          	addi	a5,a5,1176 # 39818 <xRunIndicator>
    8388:	0007a703          	lw	a4,0(a5)
    838c:	05500793          	li	a5,85
    8390:	fef714e3          	bne	a4,a5,8378 <vPrimaryBlockTimeTestTask+0x218>
    8394:	01400513          	li	a0,20
    8398:	821fa0ef          	jal	ra,2bb8 <vTaskDelay>
    839c:	00031797          	auipc	a5,0x31
    83a0:	47c78793          	addi	a5,a5,1148 # 39818 <xRunIndicator>
    83a4:	0007a023          	sw	zero,0(a5)
    83a8:	02012023          	sw	zero,32(sp)
    83ac:	1040006f          	j	84b0 <vPrimaryBlockTimeTestTask+0x350>
    83b0:	00031797          	auipc	a5,0x31
    83b4:	45478793          	addi	a5,a5,1108 # 39804 <xTestQueue>
    83b8:	0007a783          	lw	a5,0(a5)
    83bc:	01c10713          	addi	a4,sp,28
    83c0:	00000613          	li	a2,0
    83c4:	00070593          	mv	a1,a4
    83c8:	00078513          	mv	a0,a5
    83cc:	8a8f90ef          	jal	ra,1474 <xQueueReceive>
    83d0:	00050713          	mv	a4,a0
    83d4:	00100793          	li	a5,1
    83d8:	00f70a63          	beq	a4,a5,83ec <vPrimaryBlockTimeTestTask+0x28c>
    83dc:	00031797          	auipc	a5,0x31
    83e0:	43878793          	addi	a5,a5,1080 # 39814 <xErrorOccurred>
    83e4:	00100713          	li	a4,1
    83e8:	00e7a023          	sw	a4,0(a5)
    83ec:	00031797          	auipc	a5,0x31
    83f0:	41878793          	addi	a5,a5,1048 # 39804 <xTestQueue>
    83f4:	0007a783          	lw	a5,0(a5)
    83f8:	02010713          	addi	a4,sp,32
    83fc:	00000693          	li	a3,0
    8400:	00000613          	li	a2,0
    8404:	00070593          	mv	a1,a4
    8408:	00078513          	mv	a0,a5
    840c:	b6df80ef          	jal	ra,f78 <xQueueGenericSend>
    8410:	00050713          	mv	a4,a0
    8414:	00100793          	li	a5,1
    8418:	00f70a63          	beq	a4,a5,842c <vPrimaryBlockTimeTestTask+0x2cc>
    841c:	00031797          	auipc	a5,0x31
    8420:	3f878793          	addi	a5,a5,1016 # 39814 <xErrorOccurred>
    8424:	00100713          	li	a4,1
    8428:	00e7a023          	sw	a4,0(a5)
    842c:	00031797          	auipc	a5,0x31
    8430:	3ec78793          	addi	a5,a5,1004 # 39818 <xRunIndicator>
    8434:	0007a703          	lw	a4,0(a5)
    8438:	05500793          	li	a5,85
    843c:	00f71a63          	bne	a4,a5,8450 <vPrimaryBlockTimeTestTask+0x2f0>
    8440:	00031797          	auipc	a5,0x31
    8444:	3d478793          	addi	a5,a5,980 # 39814 <xErrorOccurred>
    8448:	00100713          	li	a4,1
    844c:	00e7a023          	sw	a4,0(a5)
    8450:	00031797          	auipc	a5,0x31
    8454:	3b878793          	addi	a5,a5,952 # 39808 <xSecondary>
    8458:	0007a783          	lw	a5,0(a5)
    845c:	00400593          	li	a1,4
    8460:	00078513          	mv	a0,a5
    8464:	99dfa0ef          	jal	ra,2e00 <vTaskPrioritySet>
    8468:	00031797          	auipc	a5,0x31
    846c:	3b078793          	addi	a5,a5,944 # 39818 <xRunIndicator>
    8470:	0007a703          	lw	a4,0(a5)
    8474:	05500793          	li	a5,85
    8478:	00f71a63          	bne	a4,a5,848c <vPrimaryBlockTimeTestTask+0x32c>
    847c:	00031797          	auipc	a5,0x31
    8480:	39878793          	addi	a5,a5,920 # 39814 <xErrorOccurred>
    8484:	00100713          	li	a4,1
    8488:	00e7a023          	sw	a4,0(a5)
    848c:	00031797          	auipc	a5,0x31
    8490:	37c78793          	addi	a5,a5,892 # 39808 <xSecondary>
    8494:	0007a783          	lw	a5,0(a5)
    8498:	00100593          	li	a1,1
    849c:	00078513          	mv	a0,a5
    84a0:	961fa0ef          	jal	ra,2e00 <vTaskPrioritySet>
    84a4:	02012783          	lw	a5,32(sp)
    84a8:	00178793          	addi	a5,a5,1
    84ac:	02f12023          	sw	a5,32(sp)
    84b0:	02012703          	lw	a4,32(sp)
    84b4:	00400793          	li	a5,4
    84b8:	eee7dce3          	ble	a4,a5,83b0 <vPrimaryBlockTimeTestTask+0x250>
    84bc:	00c0006f          	j	84c8 <vPrimaryBlockTimeTestTask+0x368>
    84c0:	01400513          	li	a0,20
    84c4:	ef4fa0ef          	jal	ra,2bb8 <vTaskDelay>
    84c8:	00031797          	auipc	a5,0x31
    84cc:	35078793          	addi	a5,a5,848 # 39818 <xRunIndicator>
    84d0:	0007a703          	lw	a4,0(a5)
    84d4:	05500793          	li	a5,85
    84d8:	fef714e3          	bne	a4,a5,84c0 <vPrimaryBlockTimeTestTask+0x360>
    84dc:	01400513          	li	a0,20
    84e0:	ed8fa0ef          	jal	ra,2bb8 <vTaskDelay>
    84e4:	00031797          	auipc	a5,0x31
    84e8:	33478793          	addi	a5,a5,820 # 39818 <xRunIndicator>
    84ec:	0007a023          	sw	zero,0(a5)
    84f0:	02012023          	sw	zero,32(sp)
    84f4:	04c0006f          	j	8540 <vPrimaryBlockTimeTestTask+0x3e0>
    84f8:	00031797          	auipc	a5,0x31
    84fc:	30c78793          	addi	a5,a5,780 # 39804 <xTestQueue>
    8500:	0007a783          	lw	a5,0(a5)
    8504:	01c10713          	addi	a4,sp,28
    8508:	00000613          	li	a2,0
    850c:	00070593          	mv	a1,a4
    8510:	00078513          	mv	a0,a5
    8514:	f61f80ef          	jal	ra,1474 <xQueueReceive>
    8518:	00050713          	mv	a4,a0
    851c:	00100793          	li	a5,1
    8520:	00f70a63          	beq	a4,a5,8534 <vPrimaryBlockTimeTestTask+0x3d4>
    8524:	00031797          	auipc	a5,0x31
    8528:	2f078793          	addi	a5,a5,752 # 39814 <xErrorOccurred>
    852c:	00100713          	li	a4,1
    8530:	00e7a023          	sw	a4,0(a5)
    8534:	02012783          	lw	a5,32(sp)
    8538:	00178793          	addi	a5,a5,1
    853c:	02f12023          	sw	a5,32(sp)
    8540:	02012703          	lw	a4,32(sp)
    8544:	00400793          	li	a5,4
    8548:	fae7d8e3          	ble	a4,a5,84f8 <vPrimaryBlockTimeTestTask+0x398>
    854c:	00031797          	auipc	a5,0x31
    8550:	2bc78793          	addi	a5,a5,700 # 39808 <xSecondary>
    8554:	0007a783          	lw	a5,0(a5)
    8558:	00078513          	mv	a0,a5
    855c:	c39fa0ef          	jal	ra,3194 <vTaskResume>
    8560:	00c0006f          	j	856c <vPrimaryBlockTimeTestTask+0x40c>
    8564:	01400513          	li	a0,20
    8568:	e50fa0ef          	jal	ra,2bb8 <vTaskDelay>
    856c:	00031797          	auipc	a5,0x31
    8570:	2ac78793          	addi	a5,a5,684 # 39818 <xRunIndicator>
    8574:	0007a703          	lw	a4,0(a5)
    8578:	05500793          	li	a5,85
    857c:	fef714e3          	bne	a4,a5,8564 <vPrimaryBlockTimeTestTask+0x404>
    8580:	01400513          	li	a0,20
    8584:	e34fa0ef          	jal	ra,2bb8 <vTaskDelay>
    8588:	00031797          	auipc	a5,0x31
    858c:	29078793          	addi	a5,a5,656 # 39818 <xRunIndicator>
    8590:	0007a023          	sw	zero,0(a5)
    8594:	02012023          	sw	zero,32(sp)
    8598:	1040006f          	j	869c <vPrimaryBlockTimeTestTask+0x53c>
    859c:	00031797          	auipc	a5,0x31
    85a0:	26878793          	addi	a5,a5,616 # 39804 <xTestQueue>
    85a4:	0007a783          	lw	a5,0(a5)
    85a8:	02010713          	addi	a4,sp,32
    85ac:	00000693          	li	a3,0
    85b0:	00000613          	li	a2,0
    85b4:	00070593          	mv	a1,a4
    85b8:	00078513          	mv	a0,a5
    85bc:	9bdf80ef          	jal	ra,f78 <xQueueGenericSend>
    85c0:	00050713          	mv	a4,a0
    85c4:	00100793          	li	a5,1
    85c8:	00f70a63          	beq	a4,a5,85dc <vPrimaryBlockTimeTestTask+0x47c>
    85cc:	00031797          	auipc	a5,0x31
    85d0:	24878793          	addi	a5,a5,584 # 39814 <xErrorOccurred>
    85d4:	00100713          	li	a4,1
    85d8:	00e7a023          	sw	a4,0(a5)
    85dc:	00031797          	auipc	a5,0x31
    85e0:	22878793          	addi	a5,a5,552 # 39804 <xTestQueue>
    85e4:	0007a783          	lw	a5,0(a5)
    85e8:	01c10713          	addi	a4,sp,28
    85ec:	00000613          	li	a2,0
    85f0:	00070593          	mv	a1,a4
    85f4:	00078513          	mv	a0,a5
    85f8:	e7df80ef          	jal	ra,1474 <xQueueReceive>
    85fc:	00050713          	mv	a4,a0
    8600:	00100793          	li	a5,1
    8604:	00f70a63          	beq	a4,a5,8618 <vPrimaryBlockTimeTestTask+0x4b8>
    8608:	00031797          	auipc	a5,0x31
    860c:	20c78793          	addi	a5,a5,524 # 39814 <xErrorOccurred>
    8610:	00100713          	li	a4,1
    8614:	00e7a023          	sw	a4,0(a5)
    8618:	00031797          	auipc	a5,0x31
    861c:	20078793          	addi	a5,a5,512 # 39818 <xRunIndicator>
    8620:	0007a703          	lw	a4,0(a5)
    8624:	05500793          	li	a5,85
    8628:	00f71a63          	bne	a4,a5,863c <vPrimaryBlockTimeTestTask+0x4dc>
    862c:	00031797          	auipc	a5,0x31
    8630:	1e878793          	addi	a5,a5,488 # 39814 <xErrorOccurred>
    8634:	00100713          	li	a4,1
    8638:	00e7a023          	sw	a4,0(a5)
    863c:	00031797          	auipc	a5,0x31
    8640:	1cc78793          	addi	a5,a5,460 # 39808 <xSecondary>
    8644:	0007a783          	lw	a5,0(a5)
    8648:	00400593          	li	a1,4
    864c:	00078513          	mv	a0,a5
    8650:	fb0fa0ef          	jal	ra,2e00 <vTaskPrioritySet>
    8654:	00031797          	auipc	a5,0x31
    8658:	1c478793          	addi	a5,a5,452 # 39818 <xRunIndicator>
    865c:	0007a703          	lw	a4,0(a5)
    8660:	05500793          	li	a5,85
    8664:	00f71a63          	bne	a4,a5,8678 <vPrimaryBlockTimeTestTask+0x518>
    8668:	00031797          	auipc	a5,0x31
    866c:	1ac78793          	addi	a5,a5,428 # 39814 <xErrorOccurred>
    8670:	00100713          	li	a4,1
    8674:	00e7a023          	sw	a4,0(a5)
    8678:	00031797          	auipc	a5,0x31
    867c:	19078793          	addi	a5,a5,400 # 39808 <xSecondary>
    8680:	0007a783          	lw	a5,0(a5)
    8684:	00100593          	li	a1,1
    8688:	00078513          	mv	a0,a5
    868c:	f74fa0ef          	jal	ra,2e00 <vTaskPrioritySet>
    8690:	02012783          	lw	a5,32(sp)
    8694:	00178793          	addi	a5,a5,1
    8698:	02f12023          	sw	a5,32(sp)
    869c:	02012703          	lw	a4,32(sp)
    86a0:	00400793          	li	a5,4
    86a4:	eee7dce3          	ble	a4,a5,859c <vPrimaryBlockTimeTestTask+0x43c>
    86a8:	00c0006f          	j	86b4 <vPrimaryBlockTimeTestTask+0x554>
    86ac:	01400513          	li	a0,20
    86b0:	d08fa0ef          	jal	ra,2bb8 <vTaskDelay>
    86b4:	00031797          	auipc	a5,0x31
    86b8:	16478793          	addi	a5,a5,356 # 39818 <xRunIndicator>
    86bc:	0007a703          	lw	a4,0(a5)
    86c0:	05500793          	li	a5,85
    86c4:	fef714e3          	bne	a4,a5,86ac <vPrimaryBlockTimeTestTask+0x54c>
    86c8:	01400513          	li	a0,20
    86cc:	cecfa0ef          	jal	ra,2bb8 <vTaskDelay>
    86d0:	00031797          	auipc	a5,0x31
    86d4:	13c78793          	addi	a5,a5,316 # 3980c <xPrimaryCycles>
    86d8:	0007a783          	lw	a5,0(a5)
    86dc:	00178713          	addi	a4,a5,1
    86e0:	00031797          	auipc	a5,0x31
    86e4:	12c78793          	addi	a5,a5,300 # 3980c <xPrimaryCycles>
    86e8:	00e7a023          	sw	a4,0(a5)
    86ec:	a81ff06f          	j	816c <vPrimaryBlockTimeTestTask+0xc>

000086f0 <vSecondaryBlockTimeTestTask>:
    86f0:	fd010113          	addi	sp,sp,-48
    86f4:	02112623          	sw	ra,44(sp)
    86f8:	00a12623          	sw	a0,12(sp)
    86fc:	00000513          	li	a0,0
    8700:	8f1fa0ef          	jal	ra,2ff0 <vTaskSuspend>
    8704:	f89fa0ef          	jal	ra,368c <xTaskGetTickCount>
    8708:	00a12e23          	sw	a0,28(sp)
    870c:	00012a23          	sw	zero,20(sp)
    8710:	00031797          	auipc	a5,0x31
    8714:	10878793          	addi	a5,a5,264 # 39818 <xRunIndicator>
    8718:	05500713          	li	a4,85
    871c:	00e7a023          	sw	a4,0(a5)
    8720:	00031797          	auipc	a5,0x31
    8724:	0e478793          	addi	a5,a5,228 # 39804 <xTestQueue>
    8728:	0007a783          	lw	a5,0(a5)
    872c:	01410713          	addi	a4,sp,20
    8730:	00000693          	li	a3,0
    8734:	0af00613          	li	a2,175
    8738:	00070593          	mv	a1,a4
    873c:	00078513          	mv	a0,a5
    8740:	839f80ef          	jal	ra,f78 <xQueueGenericSend>
    8744:	00050793          	mv	a5,a0
    8748:	00078a63          	beqz	a5,875c <vSecondaryBlockTimeTestTask+0x6c>
    874c:	00031797          	auipc	a5,0x31
    8750:	0c878793          	addi	a5,a5,200 # 39814 <xErrorOccurred>
    8754:	00100713          	li	a4,1
    8758:	00e7a023          	sw	a4,0(a5)
    875c:	f31fa0ef          	jal	ra,368c <xTaskGetTickCount>
    8760:	00050713          	mv	a4,a0
    8764:	01c12783          	lw	a5,28(sp)
    8768:	40f707b3          	sub	a5,a4,a5
    876c:	00f12c23          	sw	a5,24(sp)
    8770:	01812703          	lw	a4,24(sp)
    8774:	0ae00793          	li	a5,174
    8778:	00e7ea63          	bltu	a5,a4,878c <vSecondaryBlockTimeTestTask+0x9c>
    877c:	00031797          	auipc	a5,0x31
    8780:	09878793          	addi	a5,a5,152 # 39814 <xErrorOccurred>
    8784:	00100713          	li	a4,1
    8788:	00e7a023          	sw	a4,0(a5)
    878c:	01812703          	lw	a4,24(sp)
    8790:	0be00793          	li	a5,190
    8794:	00e7fa63          	bleu	a4,a5,87a8 <vSecondaryBlockTimeTestTask+0xb8>
    8798:	00031797          	auipc	a5,0x31
    879c:	07c78793          	addi	a5,a5,124 # 39814 <xErrorOccurred>
    87a0:	00100713          	li	a4,1
    87a4:	00e7a023          	sw	a4,0(a5)
    87a8:	00031797          	auipc	a5,0x31
    87ac:	07078793          	addi	a5,a5,112 # 39818 <xRunIndicator>
    87b0:	05500713          	li	a4,85
    87b4:	00e7a023          	sw	a4,0(a5)
    87b8:	00000513          	li	a0,0
    87bc:	835fa0ef          	jal	ra,2ff0 <vTaskSuspend>
    87c0:	ecdfa0ef          	jal	ra,368c <xTaskGetTickCount>
    87c4:	00a12e23          	sw	a0,28(sp)
    87c8:	00031797          	auipc	a5,0x31
    87cc:	05078793          	addi	a5,a5,80 # 39818 <xRunIndicator>
    87d0:	05500713          	li	a4,85
    87d4:	00e7a023          	sw	a4,0(a5)
    87d8:	00031797          	auipc	a5,0x31
    87dc:	02c78793          	addi	a5,a5,44 # 39804 <xTestQueue>
    87e0:	0007a783          	lw	a5,0(a5)
    87e4:	01410713          	addi	a4,sp,20
    87e8:	0af00613          	li	a2,175
    87ec:	00070593          	mv	a1,a4
    87f0:	00078513          	mv	a0,a5
    87f4:	c81f80ef          	jal	ra,1474 <xQueueReceive>
    87f8:	00050793          	mv	a5,a0
    87fc:	00078a63          	beqz	a5,8810 <vSecondaryBlockTimeTestTask+0x120>
    8800:	00031797          	auipc	a5,0x31
    8804:	01478793          	addi	a5,a5,20 # 39814 <xErrorOccurred>
    8808:	00100713          	li	a4,1
    880c:	00e7a023          	sw	a4,0(a5)
    8810:	e7dfa0ef          	jal	ra,368c <xTaskGetTickCount>
    8814:	00050713          	mv	a4,a0
    8818:	01c12783          	lw	a5,28(sp)
    881c:	40f707b3          	sub	a5,a4,a5
    8820:	00f12c23          	sw	a5,24(sp)
    8824:	01812703          	lw	a4,24(sp)
    8828:	0ae00793          	li	a5,174
    882c:	00e7ea63          	bltu	a5,a4,8840 <vSecondaryBlockTimeTestTask+0x150>
    8830:	00031797          	auipc	a5,0x31
    8834:	fe478793          	addi	a5,a5,-28 # 39814 <xErrorOccurred>
    8838:	00100713          	li	a4,1
    883c:	00e7a023          	sw	a4,0(a5)
    8840:	01812703          	lw	a4,24(sp)
    8844:	0be00793          	li	a5,190
    8848:	00e7fa63          	bleu	a4,a5,885c <vSecondaryBlockTimeTestTask+0x16c>
    884c:	00031797          	auipc	a5,0x31
    8850:	fc878793          	addi	a5,a5,-56 # 39814 <xErrorOccurred>
    8854:	00100713          	li	a4,1
    8858:	00e7a023          	sw	a4,0(a5)
    885c:	00031797          	auipc	a5,0x31
    8860:	fbc78793          	addi	a5,a5,-68 # 39818 <xRunIndicator>
    8864:	05500713          	li	a4,85
    8868:	00e7a023          	sw	a4,0(a5)
    886c:	00031797          	auipc	a5,0x31
    8870:	fa478793          	addi	a5,a5,-92 # 39810 <xSecondaryCycles>
    8874:	0007a783          	lw	a5,0(a5)
    8878:	00178713          	addi	a4,a5,1
    887c:	00031797          	auipc	a5,0x31
    8880:	f9478793          	addi	a5,a5,-108 # 39810 <xSecondaryCycles>
    8884:	00e7a023          	sw	a4,0(a5)
    8888:	e75ff06f          	j	86fc <vSecondaryBlockTimeTestTask+0xc>

0000888c <prvBasicDelayTests>:
    888c:	fd010113          	addi	sp,sp,-48
    8890:	02112623          	sw	ra,44(sp)
    8894:	04b00793          	li	a5,75
    8898:	00f12c23          	sw	a5,24(sp)
    889c:	00500793          	li	a5,5
    88a0:	00f12a23          	sw	a5,20(sp)
    88a4:	00700793          	li	a5,7
    88a8:	00f12823          	sw	a5,16(sp)
    88ac:	00100593          	li	a1,1
    88b0:	00000513          	li	a0,0
    88b4:	d4cfa0ef          	jal	ra,2e00 <vTaskPrioritySet>
    88b8:	dd5fa0ef          	jal	ra,368c <xTaskGetTickCount>
    88bc:	00a12623          	sw	a0,12(sp)
    88c0:	0af00513          	li	a0,175
    88c4:	af4fa0ef          	jal	ra,2bb8 <vTaskDelay>
    88c8:	dc5fa0ef          	jal	ra,368c <xTaskGetTickCount>
    88cc:	00a12423          	sw	a0,8(sp)
    88d0:	00812703          	lw	a4,8(sp)
    88d4:	00c12783          	lw	a5,12(sp)
    88d8:	40f70733          	sub	a4,a4,a5
    88dc:	01012783          	lw	a5,16(sp)
    88e0:	0af78793          	addi	a5,a5,175
    88e4:	00e7fa63          	bleu	a4,a5,88f8 <prvBasicDelayTests+0x6c>
    88e8:	00031797          	auipc	a5,0x31
    88ec:	f2c78793          	addi	a5,a5,-212 # 39814 <xErrorOccurred>
    88f0:	00100713          	li	a4,1
    88f4:	00e7a023          	sw	a4,0(a5)
    88f8:	d95fa0ef          	jal	ra,368c <xTaskGetTickCount>
    88fc:	00a12423          	sw	a0,8(sp)
    8900:	00812783          	lw	a5,8(sp)
    8904:	00f12023          	sw	a5,0(sp)
    8908:	00012e23          	sw	zero,28(sp)
    890c:	0880006f          	j	8994 <prvBasicDelayTests+0x108>
    8910:	01812583          	lw	a1,24(sp)
    8914:	01c12503          	lw	a0,28(sp)
    8918:	714010ef          	jal	ra,a02c <__mulsi3>
    891c:	00050793          	mv	a5,a0
    8920:	00078713          	mv	a4,a5
    8924:	00812783          	lw	a5,8(sp)
    8928:	00e787b3          	add	a5,a5,a4
    892c:	00f12223          	sw	a5,4(sp)
    8930:	00010793          	mv	a5,sp
    8934:	01812583          	lw	a1,24(sp)
    8938:	00078513          	mv	a0,a5
    893c:	95cfa0ef          	jal	ra,2a98 <vTaskDelayUntil>
    8940:	d4dfa0ef          	jal	ra,368c <xTaskGetTickCount>
    8944:	00050713          	mv	a4,a0
    8948:	00412783          	lw	a5,4(sp)
    894c:	40f70733          	sub	a4,a4,a5
    8950:	01012783          	lw	a5,16(sp)
    8954:	0af78793          	addi	a5,a5,175
    8958:	00e7fa63          	bleu	a4,a5,896c <prvBasicDelayTests+0xe0>
    895c:	00031797          	auipc	a5,0x31
    8960:	eb878793          	addi	a5,a5,-328 # 39814 <xErrorOccurred>
    8964:	00100713          	li	a4,1
    8968:	00e7a023          	sw	a4,0(a5)
    896c:	00031797          	auipc	a5,0x31
    8970:	ea078793          	addi	a5,a5,-352 # 3980c <xPrimaryCycles>
    8974:	0007a783          	lw	a5,0(a5)
    8978:	00178713          	addi	a4,a5,1
    897c:	00031797          	auipc	a5,0x31
    8980:	e9078793          	addi	a5,a5,-368 # 3980c <xPrimaryCycles>
    8984:	00e7a023          	sw	a4,0(a5)
    8988:	01c12783          	lw	a5,28(sp)
    898c:	00178793          	addi	a5,a5,1
    8990:	00f12e23          	sw	a5,28(sp)
    8994:	01c12703          	lw	a4,28(sp)
    8998:	01412783          	lw	a5,20(sp)
    899c:	f6f76ae3          	bltu	a4,a5,8910 <prvBasicDelayTests+0x84>
    89a0:	00200593          	li	a1,2
    89a4:	00000513          	li	a0,0
    89a8:	c58fa0ef          	jal	ra,2e00 <vTaskPrioritySet>
    89ac:	00000013          	nop
    89b0:	02c12083          	lw	ra,44(sp)
    89b4:	03010113          	addi	sp,sp,48
    89b8:	00008067          	ret

000089bc <xAreBlockTimeTestTasksStillRunning>:
    89bc:	ff010113          	addi	sp,sp,-16
    89c0:	00100793          	li	a5,1
    89c4:	00f12623          	sw	a5,12(sp)
    89c8:	00031797          	auipc	a5,0x31
    89cc:	e4478793          	addi	a5,a5,-444 # 3980c <xPrimaryCycles>
    89d0:	0007a703          	lw	a4,0(a5)
    89d4:	00031797          	auipc	a5,0x31
    89d8:	e4878793          	addi	a5,a5,-440 # 3981c <xLastPrimaryCycleCount.1486>
    89dc:	0007a783          	lw	a5,0(a5)
    89e0:	00f71463          	bne	a4,a5,89e8 <xAreBlockTimeTestTasksStillRunning+0x2c>
    89e4:	00012623          	sw	zero,12(sp)
    89e8:	00031797          	auipc	a5,0x31
    89ec:	e2878793          	addi	a5,a5,-472 # 39810 <xSecondaryCycles>
    89f0:	0007a703          	lw	a4,0(a5)
    89f4:	00031797          	auipc	a5,0x31
    89f8:	e2c78793          	addi	a5,a5,-468 # 39820 <xLastSecondaryCycleCount.1487>
    89fc:	0007a783          	lw	a5,0(a5)
    8a00:	00f71463          	bne	a4,a5,8a08 <xAreBlockTimeTestTasksStillRunning+0x4c>
    8a04:	00012623          	sw	zero,12(sp)
    8a08:	00031797          	auipc	a5,0x31
    8a0c:	e0c78793          	addi	a5,a5,-500 # 39814 <xErrorOccurred>
    8a10:	0007a703          	lw	a4,0(a5)
    8a14:	00100793          	li	a5,1
    8a18:	00f71463          	bne	a4,a5,8a20 <xAreBlockTimeTestTasksStillRunning+0x64>
    8a1c:	00012623          	sw	zero,12(sp)
    8a20:	00031797          	auipc	a5,0x31
    8a24:	df078793          	addi	a5,a5,-528 # 39810 <xSecondaryCycles>
    8a28:	0007a703          	lw	a4,0(a5)
    8a2c:	00031797          	auipc	a5,0x31
    8a30:	df478793          	addi	a5,a5,-524 # 39820 <xLastSecondaryCycleCount.1487>
    8a34:	00e7a023          	sw	a4,0(a5)
    8a38:	00031797          	auipc	a5,0x31
    8a3c:	dd478793          	addi	a5,a5,-556 # 3980c <xPrimaryCycles>
    8a40:	0007a703          	lw	a4,0(a5)
    8a44:	00031797          	auipc	a5,0x31
    8a48:	dd878793          	addi	a5,a5,-552 # 3981c <xLastPrimaryCycleCount.1486>
    8a4c:	00e7a023          	sw	a4,0(a5)
    8a50:	00c12783          	lw	a5,12(sp)
    8a54:	00078513          	mv	a0,a5
    8a58:	01010113          	addi	sp,sp,16
    8a5c:	00008067          	ret

00008a60 <vStartCountingSemaphoreTasks>:
    8a60:	ff010113          	addi	sp,sp,-16
    8a64:	00112623          	sw	ra,12(sp)
    8a68:	0c800593          	li	a1,200
    8a6c:	0c800513          	li	a0,200
    8a70:	c98f80ef          	jal	ra,f08 <xQueueCreateCountingSemaphore>
    8a74:	00050713          	mv	a4,a0
    8a78:	00031797          	auipc	a5,0x31
    8a7c:	db078793          	addi	a5,a5,-592 # 39828 <xParameters>
    8a80:	00e7a023          	sw	a4,0(a5)
    8a84:	00031797          	auipc	a5,0x31
    8a88:	da478793          	addi	a5,a5,-604 # 39828 <xParameters>
    8a8c:	0aa00713          	li	a4,170
    8a90:	00e7a223          	sw	a4,4(a5)
    8a94:	00031797          	auipc	a5,0x31
    8a98:	d9478793          	addi	a5,a5,-620 # 39828 <xParameters>
    8a9c:	0007a423          	sw	zero,8(a5)
    8aa0:	00000593          	li	a1,0
    8aa4:	0c800513          	li	a0,200
    8aa8:	c60f80ef          	jal	ra,f08 <xQueueCreateCountingSemaphore>
    8aac:	00050713          	mv	a4,a0
    8ab0:	00031797          	auipc	a5,0x31
    8ab4:	d7878793          	addi	a5,a5,-648 # 39828 <xParameters>
    8ab8:	00e7a623          	sw	a4,12(a5)
    8abc:	00031797          	auipc	a5,0x31
    8ac0:	d6c78793          	addi	a5,a5,-660 # 39828 <xParameters>
    8ac4:	0007a823          	sw	zero,16(a5)
    8ac8:	00031797          	auipc	a5,0x31
    8acc:	d6078793          	addi	a5,a5,-672 # 39828 <xParameters>
    8ad0:	0007aa23          	sw	zero,20(a5)
    8ad4:	00031797          	auipc	a5,0x31
    8ad8:	d5478793          	addi	a5,a5,-684 # 39828 <xParameters>
    8adc:	0007a783          	lw	a5,0(a5)
    8ae0:	00079a63          	bnez	a5,8af4 <vStartCountingSemaphoreTasks+0x94>
    8ae4:	00031797          	auipc	a5,0x31
    8ae8:	d4478793          	addi	a5,a5,-700 # 39828 <xParameters>
    8aec:	00c7a783          	lw	a5,12(a5)
    8af0:	08078663          	beqz	a5,8b7c <vStartCountingSemaphoreTasks+0x11c>
    8af4:	00031797          	auipc	a5,0x31
    8af8:	d3478793          	addi	a5,a5,-716 # 39828 <xParameters>
    8afc:	0007a783          	lw	a5,0(a5)
    8b00:	00018597          	auipc	a1,0x18
    8b04:	84058593          	addi	a1,a1,-1984 # 20340 <__rodata_start+0x340>
    8b08:	00078513          	mv	a0,a5
    8b0c:	ff4f90ef          	jal	ra,2300 <vQueueAddToRegistry>
    8b10:	00031797          	auipc	a5,0x31
    8b14:	d1878793          	addi	a5,a5,-744 # 39828 <xParameters>
    8b18:	00c7a783          	lw	a5,12(a5)
    8b1c:	00018597          	auipc	a1,0x18
    8b20:	83458593          	addi	a1,a1,-1996 # 20350 <__rodata_start+0x350>
    8b24:	00078513          	mv	a0,a5
    8b28:	fd8f90ef          	jal	ra,2300 <vQueueAddToRegistry>
    8b2c:	00000793          	li	a5,0
    8b30:	00000713          	li	a4,0
    8b34:	00031697          	auipc	a3,0x31
    8b38:	cf468693          	addi	a3,a3,-780 # 39828 <xParameters>
    8b3c:	40000613          	li	a2,1024
    8b40:	00018597          	auipc	a1,0x18
    8b44:	82058593          	addi	a1,a1,-2016 # 20360 <__rodata_start+0x360>
    8b48:	00000517          	auipc	a0,0x0
    8b4c:	24c50513          	addi	a0,a0,588 # 8d94 <prvCountingSemaphoreTask>
    8b50:	9e5f90ef          	jal	ra,2534 <xTaskCreate>
    8b54:	00000793          	li	a5,0
    8b58:	00000713          	li	a4,0
    8b5c:	00031697          	auipc	a3,0x31
    8b60:	cd868693          	addi	a3,a3,-808 # 39834 <xParameters+0xc>
    8b64:	40000613          	li	a2,1024
    8b68:	00018597          	auipc	a1,0x18
    8b6c:	80058593          	addi	a1,a1,-2048 # 20368 <__rodata_start+0x368>
    8b70:	00000517          	auipc	a0,0x0
    8b74:	22450513          	addi	a0,a0,548 # 8d94 <prvCountingSemaphoreTask>
    8b78:	9bdf90ef          	jal	ra,2534 <xTaskCreate>
    8b7c:	00000013          	nop
    8b80:	00c12083          	lw	ra,12(sp)
    8b84:	01010113          	addi	sp,sp,16
    8b88:	00008067          	ret

00008b8c <prvDecrementSemaphoreCount>:
    8b8c:	fd010113          	addi	sp,sp,-48
    8b90:	02112623          	sw	ra,44(sp)
    8b94:	00a12623          	sw	a0,12(sp)
    8b98:	00b12423          	sw	a1,8(sp)
    8b9c:	00000693          	li	a3,0
    8ba0:	00000613          	li	a2,0
    8ba4:	00000593          	li	a1,0
    8ba8:	00c12503          	lw	a0,12(sp)
    8bac:	bccf80ef          	jal	ra,f78 <xQueueGenericSend>
    8bb0:	00050713          	mv	a4,a0
    8bb4:	00100793          	li	a5,1
    8bb8:	00f71a63          	bne	a4,a5,8bcc <prvDecrementSemaphoreCount+0x40>
    8bbc:	00031797          	auipc	a5,0x31
    8bc0:	c6878793          	addi	a5,a5,-920 # 39824 <xErrorDetected>
    8bc4:	00100713          	li	a4,1
    8bc8:	00e7a023          	sw	a4,0(a5)
    8bcc:	00012e23          	sw	zero,28(sp)
    8bd0:	0700006f          	j	8c40 <prvDecrementSemaphoreCount+0xb4>
    8bd4:	00c12503          	lw	a0,12(sp)
    8bd8:	93cf90ef          	jal	ra,1d14 <uxQueueMessagesWaiting>
    8bdc:	00050693          	mv	a3,a0
    8be0:	0c800713          	li	a4,200
    8be4:	01c12783          	lw	a5,28(sp)
    8be8:	40f707b3          	sub	a5,a4,a5
    8bec:	00f68663          	beq	a3,a5,8bf8 <prvDecrementSemaphoreCount+0x6c>
    8bf0:	30047073          	csrci	mstatus,8
    8bf4:	0000006f          	j	8bf4 <prvDecrementSemaphoreCount+0x68>
    8bf8:	00000593          	li	a1,0
    8bfc:	00c12503          	lw	a0,12(sp)
    8c00:	a85f80ef          	jal	ra,1684 <xQueueSemaphoreTake>
    8c04:	00050713          	mv	a4,a0
    8c08:	00100793          	li	a5,1
    8c0c:	00f70a63          	beq	a4,a5,8c20 <prvDecrementSemaphoreCount+0x94>
    8c10:	00031797          	auipc	a5,0x31
    8c14:	c1478793          	addi	a5,a5,-1004 # 39824 <xErrorDetected>
    8c18:	00100713          	li	a4,1
    8c1c:	00e7a023          	sw	a4,0(a5)
    8c20:	00812783          	lw	a5,8(sp)
    8c24:	0007a783          	lw	a5,0(a5)
    8c28:	00178713          	addi	a4,a5,1
    8c2c:	00812783          	lw	a5,8(sp)
    8c30:	00e7a023          	sw	a4,0(a5)
    8c34:	01c12783          	lw	a5,28(sp)
    8c38:	00178793          	addi	a5,a5,1
    8c3c:	00f12e23          	sw	a5,28(sp)
    8c40:	01c12703          	lw	a4,28(sp)
    8c44:	0c700793          	li	a5,199
    8c48:	f8e7f6e3          	bleu	a4,a5,8bd4 <prvDecrementSemaphoreCount+0x48>
    8c4c:	00c12503          	lw	a0,12(sp)
    8c50:	8c4f90ef          	jal	ra,1d14 <uxQueueMessagesWaiting>
    8c54:	00050793          	mv	a5,a0
    8c58:	00078663          	beqz	a5,8c64 <prvDecrementSemaphoreCount+0xd8>
    8c5c:	30047073          	csrci	mstatus,8
    8c60:	0000006f          	j	8c60 <prvDecrementSemaphoreCount+0xd4>
    8c64:	00000593          	li	a1,0
    8c68:	00c12503          	lw	a0,12(sp)
    8c6c:	a19f80ef          	jal	ra,1684 <xQueueSemaphoreTake>
    8c70:	00050713          	mv	a4,a0
    8c74:	00100793          	li	a5,1
    8c78:	00f71a63          	bne	a4,a5,8c8c <prvDecrementSemaphoreCount+0x100>
    8c7c:	00031797          	auipc	a5,0x31
    8c80:	ba878793          	addi	a5,a5,-1112 # 39824 <xErrorDetected>
    8c84:	00100713          	li	a4,1
    8c88:	00e7a023          	sw	a4,0(a5)
    8c8c:	00000013          	nop
    8c90:	02c12083          	lw	ra,44(sp)
    8c94:	03010113          	addi	sp,sp,48
    8c98:	00008067          	ret

00008c9c <prvIncrementSemaphoreCount>:
    8c9c:	fd010113          	addi	sp,sp,-48
    8ca0:	02112623          	sw	ra,44(sp)
    8ca4:	00a12623          	sw	a0,12(sp)
    8ca8:	00b12423          	sw	a1,8(sp)
    8cac:	00000593          	li	a1,0
    8cb0:	00c12503          	lw	a0,12(sp)
    8cb4:	9d1f80ef          	jal	ra,1684 <xQueueSemaphoreTake>
    8cb8:	00050713          	mv	a4,a0
    8cbc:	00100793          	li	a5,1
    8cc0:	00f71a63          	bne	a4,a5,8cd4 <prvIncrementSemaphoreCount+0x38>
    8cc4:	00031797          	auipc	a5,0x31
    8cc8:	b6078793          	addi	a5,a5,-1184 # 39824 <xErrorDetected>
    8ccc:	00100713          	li	a4,1
    8cd0:	00e7a023          	sw	a4,0(a5)
    8cd4:	00012e23          	sw	zero,28(sp)
    8cd8:	0700006f          	j	8d48 <prvIncrementSemaphoreCount+0xac>
    8cdc:	00c12503          	lw	a0,12(sp)
    8ce0:	834f90ef          	jal	ra,1d14 <uxQueueMessagesWaiting>
    8ce4:	00050713          	mv	a4,a0
    8ce8:	01c12783          	lw	a5,28(sp)
    8cec:	00e78663          	beq	a5,a4,8cf8 <prvIncrementSemaphoreCount+0x5c>
    8cf0:	30047073          	csrci	mstatus,8
    8cf4:	0000006f          	j	8cf4 <prvIncrementSemaphoreCount+0x58>
    8cf8:	00000693          	li	a3,0
    8cfc:	00000613          	li	a2,0
    8d00:	00000593          	li	a1,0
    8d04:	00c12503          	lw	a0,12(sp)
    8d08:	a70f80ef          	jal	ra,f78 <xQueueGenericSend>
    8d0c:	00050713          	mv	a4,a0
    8d10:	00100793          	li	a5,1
    8d14:	00f70a63          	beq	a4,a5,8d28 <prvIncrementSemaphoreCount+0x8c>
    8d18:	00031797          	auipc	a5,0x31
    8d1c:	b0c78793          	addi	a5,a5,-1268 # 39824 <xErrorDetected>
    8d20:	00100713          	li	a4,1
    8d24:	00e7a023          	sw	a4,0(a5)
    8d28:	00812783          	lw	a5,8(sp)
    8d2c:	0007a783          	lw	a5,0(a5)
    8d30:	00178713          	addi	a4,a5,1
    8d34:	00812783          	lw	a5,8(sp)
    8d38:	00e7a023          	sw	a4,0(a5)
    8d3c:	01c12783          	lw	a5,28(sp)
    8d40:	00178793          	addi	a5,a5,1
    8d44:	00f12e23          	sw	a5,28(sp)
    8d48:	01c12703          	lw	a4,28(sp)
    8d4c:	0c700793          	li	a5,199
    8d50:	f8e7f6e3          	bleu	a4,a5,8cdc <prvIncrementSemaphoreCount+0x40>
    8d54:	00000693          	li	a3,0
    8d58:	00000613          	li	a2,0
    8d5c:	00000593          	li	a1,0
    8d60:	00c12503          	lw	a0,12(sp)
    8d64:	a14f80ef          	jal	ra,f78 <xQueueGenericSend>
    8d68:	00050713          	mv	a4,a0
    8d6c:	00100793          	li	a5,1
    8d70:	00f71a63          	bne	a4,a5,8d84 <prvIncrementSemaphoreCount+0xe8>
    8d74:	00031797          	auipc	a5,0x31
    8d78:	ab078793          	addi	a5,a5,-1360 # 39824 <xErrorDetected>
    8d7c:	00100713          	li	a4,1
    8d80:	00e7a023          	sw	a4,0(a5)
    8d84:	00000013          	nop
    8d88:	02c12083          	lw	ra,44(sp)
    8d8c:	03010113          	addi	sp,sp,48
    8d90:	00008067          	ret

00008d94 <prvCountingSemaphoreTask>:
    8d94:	fd010113          	addi	sp,sp,-48
    8d98:	02112623          	sw	ra,44(sp)
    8d9c:	00a12623          	sw	a0,12(sp)
    8da0:	00c12783          	lw	a5,12(sp)
    8da4:	00f12e23          	sw	a5,28(sp)
    8da8:	01c12783          	lw	a5,28(sp)
    8dac:	0047a703          	lw	a4,4(a5)
    8db0:	0aa00793          	li	a5,170
    8db4:	02f71063          	bne	a4,a5,8dd4 <prvCountingSemaphoreTask+0x40>
    8db8:	01c12783          	lw	a5,28(sp)
    8dbc:	0007a703          	lw	a4,0(a5)
    8dc0:	01c12783          	lw	a5,28(sp)
    8dc4:	00878793          	addi	a5,a5,8
    8dc8:	00078593          	mv	a1,a5
    8dcc:	00070513          	mv	a0,a4
    8dd0:	dbdff0ef          	jal	ra,8b8c <prvDecrementSemaphoreCount>
    8dd4:	01c12783          	lw	a5,28(sp)
    8dd8:	0007a783          	lw	a5,0(a5)
    8ddc:	00000593          	li	a1,0
    8de0:	00078513          	mv	a0,a5
    8de4:	8a1f80ef          	jal	ra,1684 <xQueueSemaphoreTake>
    8de8:	00050713          	mv	a4,a0
    8dec:	00100793          	li	a5,1
    8df0:	00f71a63          	bne	a4,a5,8e04 <prvCountingSemaphoreTask+0x70>
    8df4:	00031797          	auipc	a5,0x31
    8df8:	a3078793          	addi	a5,a5,-1488 # 39824 <xErrorDetected>
    8dfc:	00100713          	li	a4,1
    8e00:	00e7a023          	sw	a4,0(a5)
    8e04:	01c12783          	lw	a5,28(sp)
    8e08:	0007a703          	lw	a4,0(a5)
    8e0c:	01c12783          	lw	a5,28(sp)
    8e10:	00878793          	addi	a5,a5,8
    8e14:	00078593          	mv	a1,a5
    8e18:	00070513          	mv	a0,a4
    8e1c:	e81ff0ef          	jal	ra,8c9c <prvIncrementSemaphoreCount>
    8e20:	01c12783          	lw	a5,28(sp)
    8e24:	0007a703          	lw	a4,0(a5)
    8e28:	01c12783          	lw	a5,28(sp)
    8e2c:	00878793          	addi	a5,a5,8
    8e30:	00078593          	mv	a1,a5
    8e34:	00070513          	mv	a0,a4
    8e38:	d55ff0ef          	jal	ra,8b8c <prvDecrementSemaphoreCount>
    8e3c:	fc9ff06f          	j	8e04 <prvCountingSemaphoreTask+0x70>

00008e40 <xAreCountingSemaphoreTasksStillRunning>:
    8e40:	ff010113          	addi	sp,sp,-16
    8e44:	00100793          	li	a5,1
    8e48:	00f12623          	sw	a5,12(sp)
    8e4c:	00031797          	auipc	a5,0x31
    8e50:	9d878793          	addi	a5,a5,-1576 # 39824 <xErrorDetected>
    8e54:	0007a783          	lw	a5,0(a5)
    8e58:	00078463          	beqz	a5,8e60 <xAreCountingSemaphoreTasksStillRunning+0x20>
    8e5c:	00012623          	sw	zero,12(sp)
    8e60:	00031797          	auipc	a5,0x31
    8e64:	9c878793          	addi	a5,a5,-1592 # 39828 <xParameters>
    8e68:	0087a703          	lw	a4,8(a5)
    8e6c:	00031797          	auipc	a5,0x31
    8e70:	9d478793          	addi	a5,a5,-1580 # 39840 <uxLastCount0.1454>
    8e74:	0007a783          	lw	a5,0(a5)
    8e78:	00f71663          	bne	a4,a5,8e84 <xAreCountingSemaphoreTasksStillRunning+0x44>
    8e7c:	00012623          	sw	zero,12(sp)
    8e80:	01c0006f          	j	8e9c <xAreCountingSemaphoreTasksStillRunning+0x5c>
    8e84:	00031797          	auipc	a5,0x31
    8e88:	9a478793          	addi	a5,a5,-1628 # 39828 <xParameters>
    8e8c:	0087a703          	lw	a4,8(a5)
    8e90:	00031797          	auipc	a5,0x31
    8e94:	9b078793          	addi	a5,a5,-1616 # 39840 <uxLastCount0.1454>
    8e98:	00e7a023          	sw	a4,0(a5)
    8e9c:	00031797          	auipc	a5,0x31
    8ea0:	98c78793          	addi	a5,a5,-1652 # 39828 <xParameters>
    8ea4:	0147a703          	lw	a4,20(a5)
    8ea8:	00031797          	auipc	a5,0x31
    8eac:	99c78793          	addi	a5,a5,-1636 # 39844 <uxLastCount1.1455>
    8eb0:	0007a783          	lw	a5,0(a5)
    8eb4:	00f71663          	bne	a4,a5,8ec0 <xAreCountingSemaphoreTasksStillRunning+0x80>
    8eb8:	00012623          	sw	zero,12(sp)
    8ebc:	01c0006f          	j	8ed8 <xAreCountingSemaphoreTasksStillRunning+0x98>
    8ec0:	00031797          	auipc	a5,0x31
    8ec4:	96878793          	addi	a5,a5,-1688 # 39828 <xParameters>
    8ec8:	0147a703          	lw	a4,20(a5)
    8ecc:	00031797          	auipc	a5,0x31
    8ed0:	97878793          	addi	a5,a5,-1672 # 39844 <uxLastCount1.1455>
    8ed4:	00e7a023          	sw	a4,0(a5)
    8ed8:	00c12783          	lw	a5,12(sp)
    8edc:	00078513          	mv	a0,a5
    8ee0:	01010113          	addi	sp,sp,16
    8ee4:	00008067          	ret

00008ee8 <vStartRecursiveMutexTasks>:
    8ee8:	ff010113          	addi	sp,sp,-16
    8eec:	00112623          	sw	ra,12(sp)
    8ef0:	00400513          	li	a0,4
    8ef4:	e89f70ef          	jal	ra,d7c <xQueueCreateMutex>
    8ef8:	00050713          	mv	a4,a0
    8efc:	00031797          	auipc	a5,0x31
    8f00:	94c78793          	addi	a5,a5,-1716 # 39848 <xMutex>
    8f04:	00e7a023          	sw	a4,0(a5)
    8f08:	00031797          	auipc	a5,0x31
    8f0c:	94078793          	addi	a5,a5,-1728 # 39848 <xMutex>
    8f10:	0007a783          	lw	a5,0(a5)
    8f14:	08078a63          	beqz	a5,8fa8 <vStartRecursiveMutexTasks+0xc0>
    8f18:	00031797          	auipc	a5,0x31
    8f1c:	93078793          	addi	a5,a5,-1744 # 39848 <xMutex>
    8f20:	0007a783          	lw	a5,0(a5)
    8f24:	00017597          	auipc	a1,0x17
    8f28:	44c58593          	addi	a1,a1,1100 # 20370 <__rodata_start+0x370>
    8f2c:	00078513          	mv	a0,a5
    8f30:	bd0f90ef          	jal	ra,2300 <vQueueAddToRegistry>
    8f34:	00031797          	auipc	a5,0x31
    8f38:	93078793          	addi	a5,a5,-1744 # 39864 <xControllingTaskHandle>
    8f3c:	00200713          	li	a4,2
    8f40:	00000693          	li	a3,0
    8f44:	40000613          	li	a2,1024
    8f48:	00017597          	auipc	a1,0x17
    8f4c:	43858593          	addi	a1,a1,1080 # 20380 <__rodata_start+0x380>
    8f50:	00000517          	auipc	a0,0x0
    8f54:	06850513          	addi	a0,a0,104 # 8fb8 <prvRecursiveMutexControllingTask>
    8f58:	ddcf90ef          	jal	ra,2534 <xTaskCreate>
    8f5c:	00031797          	auipc	a5,0x31
    8f60:	90c78793          	addi	a5,a5,-1780 # 39868 <xBlockingTaskHandle>
    8f64:	00100713          	li	a4,1
    8f68:	00000693          	li	a3,0
    8f6c:	40000613          	li	a2,1024
    8f70:	00017597          	auipc	a1,0x17
    8f74:	41858593          	addi	a1,a1,1048 # 20388 <__rodata_start+0x388>
    8f78:	00000517          	auipc	a0,0x0
    8f7c:	1a450513          	addi	a0,a0,420 # 911c <prvRecursiveMutexBlockingTask>
    8f80:	db4f90ef          	jal	ra,2534 <xTaskCreate>
    8f84:	00000793          	li	a5,0
    8f88:	00000713          	li	a4,0
    8f8c:	00000693          	li	a3,0
    8f90:	40000613          	li	a2,1024
    8f94:	00017597          	auipc	a1,0x17
    8f98:	3fc58593          	addi	a1,a1,1020 # 20390 <__rodata_start+0x390>
    8f9c:	00000517          	auipc	a0,0x0
    8fa0:	29050513          	addi	a0,a0,656 # 922c <prvRecursiveMutexPollingTask>
    8fa4:	d90f90ef          	jal	ra,2534 <xTaskCreate>
    8fa8:	00000013          	nop
    8fac:	00c12083          	lw	ra,12(sp)
    8fb0:	01010113          	addi	sp,sp,16
    8fb4:	00008067          	ret

00008fb8 <prvRecursiveMutexControllingTask>:
    8fb8:	fd010113          	addi	sp,sp,-48
    8fbc:	02112623          	sw	ra,44(sp)
    8fc0:	00a12623          	sw	a0,12(sp)
    8fc4:	00031797          	auipc	a5,0x31
    8fc8:	88478793          	addi	a5,a5,-1916 # 39848 <xMutex>
    8fcc:	0007a783          	lw	a5,0(a5)
    8fd0:	00078513          	mv	a0,a5
    8fd4:	df9f70ef          	jal	ra,dcc <xQueueGiveMutexRecursive>
    8fd8:	00050713          	mv	a4,a0
    8fdc:	00100793          	li	a5,1
    8fe0:	00f71a63          	bne	a4,a5,8ff4 <prvRecursiveMutexControllingTask+0x3c>
    8fe4:	00031797          	auipc	a5,0x31
    8fe8:	86878793          	addi	a5,a5,-1944 # 3984c <xErrorOccurred>
    8fec:	00100713          	li	a4,1
    8ff0:	00e7a023          	sw	a4,0(a5)
    8ff4:	00012e23          	sw	zero,28(sp)
    8ff8:	04c0006f          	j	9044 <prvRecursiveMutexControllingTask+0x8c>
    8ffc:	00031797          	auipc	a5,0x31
    9000:	84c78793          	addi	a5,a5,-1972 # 39848 <xMutex>
    9004:	0007a783          	lw	a5,0(a5)
    9008:	00f00593          	li	a1,15
    900c:	00078513          	mv	a0,a5
    9010:	e55f70ef          	jal	ra,e64 <xQueueTakeMutexRecursive>
    9014:	00050713          	mv	a4,a0
    9018:	00100793          	li	a5,1
    901c:	00f70a63          	beq	a4,a5,9030 <prvRecursiveMutexControllingTask+0x78>
    9020:	00031797          	auipc	a5,0x31
    9024:	82c78793          	addi	a5,a5,-2004 # 3984c <xErrorOccurred>
    9028:	00100713          	li	a4,1
    902c:	00e7a023          	sw	a4,0(a5)
    9030:	01400513          	li	a0,20
    9034:	b85f90ef          	jal	ra,2bb8 <vTaskDelay>
    9038:	01c12783          	lw	a5,28(sp)
    903c:	00178793          	addi	a5,a5,1
    9040:	00f12e23          	sw	a5,28(sp)
    9044:	01c12703          	lw	a4,28(sp)
    9048:	00900793          	li	a5,9
    904c:	fae7f8e3          	bleu	a4,a5,8ffc <prvRecursiveMutexControllingTask+0x44>
    9050:	00012e23          	sw	zero,28(sp)
    9054:	0480006f          	j	909c <prvRecursiveMutexControllingTask+0xe4>
    9058:	01400513          	li	a0,20
    905c:	b5df90ef          	jal	ra,2bb8 <vTaskDelay>
    9060:	00030797          	auipc	a5,0x30
    9064:	7e878793          	addi	a5,a5,2024 # 39848 <xMutex>
    9068:	0007a783          	lw	a5,0(a5)
    906c:	00078513          	mv	a0,a5
    9070:	d5df70ef          	jal	ra,dcc <xQueueGiveMutexRecursive>
    9074:	00050713          	mv	a4,a0
    9078:	00100793          	li	a5,1
    907c:	00f70a63          	beq	a4,a5,9090 <prvRecursiveMutexControllingTask+0xd8>
    9080:	00030797          	auipc	a5,0x30
    9084:	7cc78793          	addi	a5,a5,1996 # 3984c <xErrorOccurred>
    9088:	00100713          	li	a4,1
    908c:	00e7a023          	sw	a4,0(a5)
    9090:	01c12783          	lw	a5,28(sp)
    9094:	00178793          	addi	a5,a5,1
    9098:	00f12e23          	sw	a5,28(sp)
    909c:	01c12703          	lw	a4,28(sp)
    90a0:	00900793          	li	a5,9
    90a4:	fae7fae3          	bleu	a4,a5,9058 <prvRecursiveMutexControllingTask+0xa0>
    90a8:	00030797          	auipc	a5,0x30
    90ac:	7a078793          	addi	a5,a5,1952 # 39848 <xMutex>
    90b0:	0007a783          	lw	a5,0(a5)
    90b4:	00078513          	mv	a0,a5
    90b8:	d15f70ef          	jal	ra,dcc <xQueueGiveMutexRecursive>
    90bc:	00050713          	mv	a4,a0
    90c0:	00100793          	li	a5,1
    90c4:	00f71a63          	bne	a4,a5,90d8 <prvRecursiveMutexControllingTask+0x120>
    90c8:	00030797          	auipc	a5,0x30
    90cc:	78478793          	addi	a5,a5,1924 # 3984c <xErrorOccurred>
    90d0:	00100713          	li	a4,1
    90d4:	00e7a023          	sw	a4,0(a5)
    90d8:	00030797          	auipc	a5,0x30
    90dc:	78078793          	addi	a5,a5,1920 # 39858 <uxControllingCycles>
    90e0:	0007a783          	lw	a5,0(a5)
    90e4:	00178713          	addi	a4,a5,1
    90e8:	00030797          	auipc	a5,0x30
    90ec:	77078793          	addi	a5,a5,1904 # 39858 <uxControllingCycles>
    90f0:	00e7a023          	sw	a4,0(a5)
    90f4:	00030797          	auipc	a5,0x30
    90f8:	75c78793          	addi	a5,a5,1884 # 39850 <xControllingIsSuspended>
    90fc:	00100713          	li	a4,1
    9100:	00e7a023          	sw	a4,0(a5)
    9104:	00000513          	li	a0,0
    9108:	ee9f90ef          	jal	ra,2ff0 <vTaskSuspend>
    910c:	00030797          	auipc	a5,0x30
    9110:	74478793          	addi	a5,a5,1860 # 39850 <xControllingIsSuspended>
    9114:	0007a023          	sw	zero,0(a5)
    9118:	eadff06f          	j	8fc4 <prvRecursiveMutexControllingTask+0xc>

0000911c <prvRecursiveMutexBlockingTask>:
    911c:	fe010113          	addi	sp,sp,-32
    9120:	00112e23          	sw	ra,28(sp)
    9124:	00a12623          	sw	a0,12(sp)
    9128:	00030797          	auipc	a5,0x30
    912c:	72078793          	addi	a5,a5,1824 # 39848 <xMutex>
    9130:	0007a783          	lw	a5,0(a5)
    9134:	ffe00593          	li	a1,-2
    9138:	00078513          	mv	a0,a5
    913c:	d29f70ef          	jal	ra,e64 <xQueueTakeMutexRecursive>
    9140:	00050713          	mv	a4,a0
    9144:	00100793          	li	a5,1
    9148:	08f71263          	bne	a4,a5,91cc <prvRecursiveMutexBlockingTask+0xb0>
    914c:	00030797          	auipc	a5,0x30
    9150:	70478793          	addi	a5,a5,1796 # 39850 <xControllingIsSuspended>
    9154:	0007a703          	lw	a4,0(a5)
    9158:	00100793          	li	a5,1
    915c:	00f70c63          	beq	a4,a5,9174 <prvRecursiveMutexBlockingTask+0x58>
    9160:	00030797          	auipc	a5,0x30
    9164:	6ec78793          	addi	a5,a5,1772 # 3984c <xErrorOccurred>
    9168:	00100713          	li	a4,1
    916c:	00e7a023          	sw	a4,0(a5)
    9170:	06c0006f          	j	91dc <prvRecursiveMutexBlockingTask+0xc0>
    9174:	00030797          	auipc	a5,0x30
    9178:	6d478793          	addi	a5,a5,1748 # 39848 <xMutex>
    917c:	0007a783          	lw	a5,0(a5)
    9180:	00078513          	mv	a0,a5
    9184:	c49f70ef          	jal	ra,dcc <xQueueGiveMutexRecursive>
    9188:	00050713          	mv	a4,a0
    918c:	00100793          	li	a5,1
    9190:	00f70a63          	beq	a4,a5,91a4 <prvRecursiveMutexBlockingTask+0x88>
    9194:	00030797          	auipc	a5,0x30
    9198:	6b878793          	addi	a5,a5,1720 # 3984c <xErrorOccurred>
    919c:	00100713          	li	a4,1
    91a0:	00e7a023          	sw	a4,0(a5)
    91a4:	00030797          	auipc	a5,0x30
    91a8:	6b078793          	addi	a5,a5,1712 # 39854 <xBlockingIsSuspended>
    91ac:	00100713          	li	a4,1
    91b0:	00e7a023          	sw	a4,0(a5)
    91b4:	00000513          	li	a0,0
    91b8:	e39f90ef          	jal	ra,2ff0 <vTaskSuspend>
    91bc:	00030797          	auipc	a5,0x30
    91c0:	69878793          	addi	a5,a5,1688 # 39854 <xBlockingIsSuspended>
    91c4:	0007a023          	sw	zero,0(a5)
    91c8:	0140006f          	j	91dc <prvRecursiveMutexBlockingTask+0xc0>
    91cc:	00030797          	auipc	a5,0x30
    91d0:	68078793          	addi	a5,a5,1664 # 3984c <xErrorOccurred>
    91d4:	00100713          	li	a4,1
    91d8:	00e7a023          	sw	a4,0(a5)
    91dc:	00030797          	auipc	a5,0x30
    91e0:	68078793          	addi	a5,a5,1664 # 3985c <uxBlockingCycles>
    91e4:	0007a783          	lw	a5,0(a5)
    91e8:	00178713          	addi	a4,a5,1
    91ec:	00030797          	auipc	a5,0x30
    91f0:	66c78793          	addi	a5,a5,1644 # 39858 <uxControllingCycles>
    91f4:	0007a783          	lw	a5,0(a5)
    91f8:	00f70a63          	beq	a4,a5,920c <prvRecursiveMutexBlockingTask+0xf0>
    91fc:	00030797          	auipc	a5,0x30
    9200:	65078793          	addi	a5,a5,1616 # 3984c <xErrorOccurred>
    9204:	00100713          	li	a4,1
    9208:	00e7a023          	sw	a4,0(a5)
    920c:	00030797          	auipc	a5,0x30
    9210:	65078793          	addi	a5,a5,1616 # 3985c <uxBlockingCycles>
    9214:	0007a783          	lw	a5,0(a5)
    9218:	00178713          	addi	a4,a5,1
    921c:	00030797          	auipc	a5,0x30
    9220:	64078793          	addi	a5,a5,1600 # 3985c <uxBlockingCycles>
    9224:	00e7a023          	sw	a4,0(a5)
    9228:	f01ff06f          	j	9128 <prvRecursiveMutexBlockingTask+0xc>

0000922c <prvRecursiveMutexPollingTask>:
    922c:	fe010113          	addi	sp,sp,-32
    9230:	00112e23          	sw	ra,28(sp)
    9234:	00a12623          	sw	a0,12(sp)
    9238:	00030797          	auipc	a5,0x30
    923c:	61078793          	addi	a5,a5,1552 # 39848 <xMutex>
    9240:	0007a783          	lw	a5,0(a5)
    9244:	00000593          	li	a1,0
    9248:	00078513          	mv	a0,a5
    924c:	c19f70ef          	jal	ra,e64 <xQueueTakeMutexRecursive>
    9250:	00050713          	mv	a4,a0
    9254:	00100793          	li	a5,1
    9258:	fef710e3          	bne	a4,a5,9238 <prvRecursiveMutexPollingTask+0xc>
    925c:	00030797          	auipc	a5,0x30
    9260:	60878793          	addi	a5,a5,1544 # 39864 <xControllingTaskHandle>
    9264:	0007a783          	lw	a5,0(a5)
    9268:	00078513          	mv	a0,a5
    926c:	9b1f90ef          	jal	ra,2c1c <eTaskGetState>
    9270:	00050713          	mv	a4,a0
    9274:	00300793          	li	a5,3
    9278:	00f70663          	beq	a4,a5,9284 <prvRecursiveMutexPollingTask+0x58>
    927c:	30047073          	csrci	mstatus,8
    9280:	0000006f          	j	9280 <prvRecursiveMutexPollingTask+0x54>
    9284:	00030797          	auipc	a5,0x30
    9288:	5e478793          	addi	a5,a5,1508 # 39868 <xBlockingTaskHandle>
    928c:	0007a783          	lw	a5,0(a5)
    9290:	00078513          	mv	a0,a5
    9294:	989f90ef          	jal	ra,2c1c <eTaskGetState>
    9298:	00050713          	mv	a4,a0
    929c:	00300793          	li	a5,3
    92a0:	00f70663          	beq	a4,a5,92ac <prvRecursiveMutexPollingTask+0x80>
    92a4:	30047073          	csrci	mstatus,8
    92a8:	0000006f          	j	92a8 <prvRecursiveMutexPollingTask+0x7c>
    92ac:	00030797          	auipc	a5,0x30
    92b0:	5a878793          	addi	a5,a5,1448 # 39854 <xBlockingIsSuspended>
    92b4:	0007a703          	lw	a4,0(a5)
    92b8:	00100793          	li	a5,1
    92bc:	00f71c63          	bne	a4,a5,92d4 <prvRecursiveMutexPollingTask+0xa8>
    92c0:	00030797          	auipc	a5,0x30
    92c4:	59078793          	addi	a5,a5,1424 # 39850 <xControllingIsSuspended>
    92c8:	0007a703          	lw	a4,0(a5)
    92cc:	00100793          	li	a5,1
    92d0:	00f70c63          	beq	a4,a5,92e8 <prvRecursiveMutexPollingTask+0xbc>
    92d4:	00030797          	auipc	a5,0x30
    92d8:	57878793          	addi	a5,a5,1400 # 3984c <xErrorOccurred>
    92dc:	00100713          	li	a4,1
    92e0:	00e7a023          	sw	a4,0(a5)
    92e4:	1340006f          	j	9418 <prvRecursiveMutexPollingTask+0x1ec>
    92e8:	00030797          	auipc	a5,0x30
    92ec:	57878793          	addi	a5,a5,1400 # 39860 <uxPollingCycles>
    92f0:	0007a783          	lw	a5,0(a5)
    92f4:	00178713          	addi	a4,a5,1
    92f8:	00030797          	auipc	a5,0x30
    92fc:	56878793          	addi	a5,a5,1384 # 39860 <uxPollingCycles>
    9300:	00e7a023          	sw	a4,0(a5)
    9304:	00030797          	auipc	a5,0x30
    9308:	56478793          	addi	a5,a5,1380 # 39868 <xBlockingTaskHandle>
    930c:	0007a783          	lw	a5,0(a5)
    9310:	00078513          	mv	a0,a5
    9314:	e81f90ef          	jal	ra,3194 <vTaskResume>
    9318:	00030797          	auipc	a5,0x30
    931c:	54c78793          	addi	a5,a5,1356 # 39864 <xControllingTaskHandle>
    9320:	0007a783          	lw	a5,0(a5)
    9324:	00078513          	mv	a0,a5
    9328:	e6df90ef          	jal	ra,3194 <vTaskResume>
    932c:	00030797          	auipc	a5,0x30
    9330:	52878793          	addi	a5,a5,1320 # 39854 <xBlockingIsSuspended>
    9334:	0007a703          	lw	a4,0(a5)
    9338:	00100793          	li	a5,1
    933c:	00f70c63          	beq	a4,a5,9354 <prvRecursiveMutexPollingTask+0x128>
    9340:	00030797          	auipc	a5,0x30
    9344:	51078793          	addi	a5,a5,1296 # 39850 <xControllingIsSuspended>
    9348:	0007a703          	lw	a4,0(a5)
    934c:	00100793          	li	a5,1
    9350:	00f71a63          	bne	a4,a5,9364 <prvRecursiveMutexPollingTask+0x138>
    9354:	00030797          	auipc	a5,0x30
    9358:	4f878793          	addi	a5,a5,1272 # 3984c <xErrorOccurred>
    935c:	00100713          	li	a4,1
    9360:	00e7a023          	sw	a4,0(a5)
    9364:	00000513          	li	a0,0
    9368:	9e1f90ef          	jal	ra,2d48 <uxTaskPriorityGet>
    936c:	00050713          	mv	a4,a0
    9370:	00200793          	li	a5,2
    9374:	00f70663          	beq	a4,a5,9380 <prvRecursiveMutexPollingTask+0x154>
    9378:	30047073          	csrci	mstatus,8
    937c:	0000006f          	j	937c <prvRecursiveMutexPollingTask+0x150>
    9380:	00030797          	auipc	a5,0x30
    9384:	4e478793          	addi	a5,a5,1252 # 39864 <xControllingTaskHandle>
    9388:	0007a783          	lw	a5,0(a5)
    938c:	00078513          	mv	a0,a5
    9390:	88df90ef          	jal	ra,2c1c <eTaskGetState>
    9394:	00050713          	mv	a4,a0
    9398:	00200793          	li	a5,2
    939c:	00f70663          	beq	a4,a5,93a8 <prvRecursiveMutexPollingTask+0x17c>
    93a0:	30047073          	csrci	mstatus,8
    93a4:	0000006f          	j	93a4 <prvRecursiveMutexPollingTask+0x178>
    93a8:	00030797          	auipc	a5,0x30
    93ac:	4c078793          	addi	a5,a5,1216 # 39868 <xBlockingTaskHandle>
    93b0:	0007a783          	lw	a5,0(a5)
    93b4:	00078513          	mv	a0,a5
    93b8:	865f90ef          	jal	ra,2c1c <eTaskGetState>
    93bc:	00050713          	mv	a4,a0
    93c0:	00200793          	li	a5,2
    93c4:	00f70663          	beq	a4,a5,93d0 <prvRecursiveMutexPollingTask+0x1a4>
    93c8:	30047073          	csrci	mstatus,8
    93cc:	0000006f          	j	93cc <prvRecursiveMutexPollingTask+0x1a0>
    93d0:	00030797          	auipc	a5,0x30
    93d4:	47878793          	addi	a5,a5,1144 # 39848 <xMutex>
    93d8:	0007a783          	lw	a5,0(a5)
    93dc:	00078513          	mv	a0,a5
    93e0:	9edf70ef          	jal	ra,dcc <xQueueGiveMutexRecursive>
    93e4:	00050713          	mv	a4,a0
    93e8:	00100793          	li	a5,1
    93ec:	00f70a63          	beq	a4,a5,9400 <prvRecursiveMutexPollingTask+0x1d4>
    93f0:	00030797          	auipc	a5,0x30
    93f4:	45c78793          	addi	a5,a5,1116 # 3984c <xErrorOccurred>
    93f8:	00100713          	li	a4,1
    93fc:	00e7a023          	sw	a4,0(a5)
    9400:	00000513          	li	a0,0
    9404:	945f90ef          	jal	ra,2d48 <uxTaskPriorityGet>
    9408:	00050793          	mv	a5,a0
    940c:	e20786e3          	beqz	a5,9238 <prvRecursiveMutexPollingTask+0xc>
    9410:	30047073          	csrci	mstatus,8
    9414:	0000006f          	j	9414 <prvRecursiveMutexPollingTask+0x1e8>
    9418:	e21ff06f          	j	9238 <prvRecursiveMutexPollingTask+0xc>

0000941c <xAreRecursiveMutexTasksStillRunning>:
    941c:	ff010113          	addi	sp,sp,-16
    9420:	00030797          	auipc	a5,0x30
    9424:	44c78793          	addi	a5,a5,1100 # 3986c <uxLastControllingCycles.1456>
    9428:	0007a703          	lw	a4,0(a5)
    942c:	00030797          	auipc	a5,0x30
    9430:	42c78793          	addi	a5,a5,1068 # 39858 <uxControllingCycles>
    9434:	0007a783          	lw	a5,0(a5)
    9438:	00f71c63          	bne	a4,a5,9450 <xAreRecursiveMutexTasksStillRunning+0x34>
    943c:	00030797          	auipc	a5,0x30
    9440:	41078793          	addi	a5,a5,1040 # 3984c <xErrorOccurred>
    9444:	00100713          	li	a4,1
    9448:	00e7a023          	sw	a4,0(a5)
    944c:	01c0006f          	j	9468 <xAreRecursiveMutexTasksStillRunning+0x4c>
    9450:	00030797          	auipc	a5,0x30
    9454:	40878793          	addi	a5,a5,1032 # 39858 <uxControllingCycles>
    9458:	0007a703          	lw	a4,0(a5)
    945c:	00030797          	auipc	a5,0x30
    9460:	41078793          	addi	a5,a5,1040 # 3986c <uxLastControllingCycles.1456>
    9464:	00e7a023          	sw	a4,0(a5)
    9468:	00030797          	auipc	a5,0x30
    946c:	40878793          	addi	a5,a5,1032 # 39870 <uxLastBlockingCycles.1457>
    9470:	0007a703          	lw	a4,0(a5)
    9474:	00030797          	auipc	a5,0x30
    9478:	3e878793          	addi	a5,a5,1000 # 3985c <uxBlockingCycles>
    947c:	0007a783          	lw	a5,0(a5)
    9480:	00f71c63          	bne	a4,a5,9498 <xAreRecursiveMutexTasksStillRunning+0x7c>
    9484:	00030797          	auipc	a5,0x30
    9488:	3c878793          	addi	a5,a5,968 # 3984c <xErrorOccurred>
    948c:	00100713          	li	a4,1
    9490:	00e7a023          	sw	a4,0(a5)
    9494:	01c0006f          	j	94b0 <xAreRecursiveMutexTasksStillRunning+0x94>
    9498:	00030797          	auipc	a5,0x30
    949c:	3c478793          	addi	a5,a5,964 # 3985c <uxBlockingCycles>
    94a0:	0007a703          	lw	a4,0(a5)
    94a4:	00030797          	auipc	a5,0x30
    94a8:	3cc78793          	addi	a5,a5,972 # 39870 <uxLastBlockingCycles.1457>
    94ac:	00e7a023          	sw	a4,0(a5)
    94b0:	00030797          	auipc	a5,0x30
    94b4:	3c478793          	addi	a5,a5,964 # 39874 <uxLastPollingCycles.1458>
    94b8:	0007a703          	lw	a4,0(a5)
    94bc:	00030797          	auipc	a5,0x30
    94c0:	3a478793          	addi	a5,a5,932 # 39860 <uxPollingCycles>
    94c4:	0007a783          	lw	a5,0(a5)
    94c8:	00f71c63          	bne	a4,a5,94e0 <xAreRecursiveMutexTasksStillRunning+0xc4>
    94cc:	00030797          	auipc	a5,0x30
    94d0:	38078793          	addi	a5,a5,896 # 3984c <xErrorOccurred>
    94d4:	00100713          	li	a4,1
    94d8:	00e7a023          	sw	a4,0(a5)
    94dc:	01c0006f          	j	94f8 <xAreRecursiveMutexTasksStillRunning+0xdc>
    94e0:	00030797          	auipc	a5,0x30
    94e4:	38078793          	addi	a5,a5,896 # 39860 <uxPollingCycles>
    94e8:	0007a703          	lw	a4,0(a5)
    94ec:	00030797          	auipc	a5,0x30
    94f0:	38878793          	addi	a5,a5,904 # 39874 <uxLastPollingCycles.1458>
    94f4:	00e7a023          	sw	a4,0(a5)
    94f8:	00030797          	auipc	a5,0x30
    94fc:	35478793          	addi	a5,a5,852 # 3984c <xErrorOccurred>
    9500:	0007a703          	lw	a4,0(a5)
    9504:	00100793          	li	a5,1
    9508:	00f71663          	bne	a4,a5,9514 <xAreRecursiveMutexTasksStillRunning+0xf8>
    950c:	00012623          	sw	zero,12(sp)
    9510:	00c0006f          	j	951c <xAreRecursiveMutexTasksStillRunning+0x100>
    9514:	00100793          	li	a5,1
    9518:	00f12623          	sw	a5,12(sp)
    951c:	00c12783          	lw	a5,12(sp)
    9520:	00078513          	mv	a0,a5
    9524:	01010113          	addi	sp,sp,16
    9528:	00008067          	ret

0000952c <strnlen>:
    952c:	00b505b3          	add	a1,a0,a1
    9530:	00050793          	mv	a5,a0
    9534:	00b78663          	beq	a5,a1,9540 <strnlen+0x14>
    9538:	0007c703          	lbu	a4,0(a5)
    953c:	00071663          	bnez	a4,9548 <strnlen+0x1c>
    9540:	40a78533          	sub	a0,a5,a0
    9544:	00008067          	ret
    9548:	00178793          	addi	a5,a5,1
    954c:	fe9ff06f          	j	9534 <strnlen+0x8>

00009550 <__udivdi3>:
#endif

#ifdef L_udivdi3
UDWtype
__udivdi3 (UDWtype n, UDWtype d)
{
    9550:	fd010113          	addi	sp,sp,-48
    9554:	01612823          	sw	s6,16(sp)
    9558:	01712623          	sw	s7,12(sp)
    955c:	02112623          	sw	ra,44(sp)
    9560:	02812423          	sw	s0,40(sp)
    9564:	02912223          	sw	s1,36(sp)
    9568:	03212023          	sw	s2,32(sp)
    956c:	01312e23          	sw	s3,28(sp)
    9570:	01412c23          	sw	s4,24(sp)
    9574:	01512a23          	sw	s5,20(sp)
    9578:	01812423          	sw	s8,8(sp)
    957c:	01912223          	sw	s9,4(sp)
    9580:	01a12023          	sw	s10,0(sp)
    9584:	00050b13          	mv	s6,a0
    9588:	00058b93          	mv	s7,a1
  if (d1 == 0)
    958c:	38069e63          	bnez	a3,9928 <__udivdi3+0x3d8>
    9590:	00020937          	lui	s2,0x20
    9594:	00060493          	mv	s1,a2
    9598:	00050a13          	mv	s4,a0
    959c:	39890913          	addi	s2,s2,920 # 20398 <__clz_tab>
      if (d0 > n1)
    95a0:	12c5f863          	bleu	a2,a1,96d0 <__udivdi3+0x180>
	  count_leading_zeros (bm, d0);
    95a4:	000107b7          	lui	a5,0x10
    95a8:	00058413          	mv	s0,a1
    95ac:	10f67863          	bleu	a5,a2,96bc <__udivdi3+0x16c>
    95b0:	0ff00713          	li	a4,255
    95b4:	00c73733          	sltu	a4,a4,a2
    95b8:	00371713          	slli	a4,a4,0x3
    95bc:	00e657b3          	srl	a5,a2,a4
    95c0:	00f90933          	add	s2,s2,a5
    95c4:	00094683          	lbu	a3,0(s2)
    95c8:	00e68733          	add	a4,a3,a4
    95cc:	02000693          	li	a3,32
    95d0:	40e686b3          	sub	a3,a3,a4
	  if (bm != 0)
    95d4:	00068c63          	beqz	a3,95ec <__udivdi3+0x9c>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    95d8:	00db9433          	sll	s0,s7,a3
    95dc:	00eb5733          	srl	a4,s6,a4
	      d0 = d0 << bm;
    95e0:	00d614b3          	sll	s1,a2,a3
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    95e4:	00876433          	or	s0,a4,s0
	      n0 = n0 << bm;
    95e8:	00db1a33          	sll	s4,s6,a3
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    95ec:	0104da93          	srli	s5,s1,0x10
    95f0:	000a8593          	mv	a1,s5
    95f4:	00040513          	mv	a0,s0
    95f8:	2a9000ef          	jal	ra,a0a0 <__umodsi3>
    95fc:	00050993          	mv	s3,a0
    9600:	000a8593          	mv	a1,s5
    9604:	00040513          	mv	a0,s0
    9608:	01049b13          	slli	s6,s1,0x10
    960c:	24d000ef          	jal	ra,a058 <__udivsi3>
    9610:	010b5b13          	srli	s6,s6,0x10
    9614:	00050913          	mv	s2,a0
    9618:	00050593          	mv	a1,a0
    961c:	000b0513          	mv	a0,s6
    9620:	20d000ef          	jal	ra,a02c <__mulsi3>
    9624:	01099993          	slli	s3,s3,0x10
    9628:	010a5793          	srli	a5,s4,0x10
    962c:	00f9e7b3          	or	a5,s3,a5
    9630:	00090413          	mv	s0,s2
    9634:	00a7fe63          	bleu	a0,a5,9650 <__udivdi3+0x100>
    9638:	009787b3          	add	a5,a5,s1
    963c:	fff90413          	addi	s0,s2,-1
    9640:	0097e863          	bltu	a5,s1,9650 <__udivdi3+0x100>
    9644:	00a7f663          	bleu	a0,a5,9650 <__udivdi3+0x100>
    9648:	ffe90413          	addi	s0,s2,-2
    964c:	009787b3          	add	a5,a5,s1
    9650:	40a78933          	sub	s2,a5,a0
    9654:	000a8593          	mv	a1,s5
    9658:	00090513          	mv	a0,s2
    965c:	245000ef          	jal	ra,a0a0 <__umodsi3>
    9660:	00050993          	mv	s3,a0
    9664:	000a8593          	mv	a1,s5
    9668:	00090513          	mv	a0,s2
    966c:	1ed000ef          	jal	ra,a058 <__udivsi3>
    9670:	010a1a13          	slli	s4,s4,0x10
    9674:	00050913          	mv	s2,a0
    9678:	00050593          	mv	a1,a0
    967c:	01099993          	slli	s3,s3,0x10
    9680:	000b0513          	mv	a0,s6
    9684:	010a5a13          	srli	s4,s4,0x10
    9688:	1a5000ef          	jal	ra,a02c <__mulsi3>
    968c:	0149ea33          	or	s4,s3,s4
    9690:	00090613          	mv	a2,s2
    9694:	00aa7c63          	bleu	a0,s4,96ac <__udivdi3+0x15c>
    9698:	01448a33          	add	s4,s1,s4
    969c:	fff90613          	addi	a2,s2,-1
    96a0:	009a6663          	bltu	s4,s1,96ac <__udivdi3+0x15c>
    96a4:	00aa7463          	bleu	a0,s4,96ac <__udivdi3+0x15c>
    96a8:	ffe90613          	addi	a2,s2,-2
    96ac:	01041413          	slli	s0,s0,0x10
    96b0:	00c46433          	or	s0,s0,a2
	      q1 = 0;
    96b4:	00000a93          	li	s5,0
    96b8:	1300006f          	j	97e8 <__udivdi3+0x298>
	  count_leading_zeros (bm, d0);
    96bc:	010007b7          	lui	a5,0x1000
    96c0:	01000713          	li	a4,16
    96c4:	eef66ce3          	bltu	a2,a5,95bc <__udivdi3+0x6c>
    96c8:	01800713          	li	a4,24
    96cc:	ef1ff06f          	j	95bc <__udivdi3+0x6c>
    96d0:	00068993          	mv	s3,a3
	  if (d0 == 0)
    96d4:	00061a63          	bnez	a2,96e8 <__udivdi3+0x198>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    96d8:	00000593          	li	a1,0
    96dc:	00100513          	li	a0,1
    96e0:	179000ef          	jal	ra,a058 <__udivsi3>
    96e4:	00050493          	mv	s1,a0
	  count_leading_zeros (bm, d0);
    96e8:	000107b7          	lui	a5,0x10
    96ec:	12f4fe63          	bleu	a5,s1,9828 <__udivdi3+0x2d8>
    96f0:	0ff00793          	li	a5,255
    96f4:	0097f463          	bleu	s1,a5,96fc <__udivdi3+0x1ac>
    96f8:	00800993          	li	s3,8
    96fc:	0134d7b3          	srl	a5,s1,s3
    9700:	00f90933          	add	s2,s2,a5
    9704:	00094703          	lbu	a4,0(s2)
    9708:	02000693          	li	a3,32
    970c:	01370733          	add	a4,a4,s3
    9710:	40e686b3          	sub	a3,a3,a4
	  if (bm == 0)
    9714:	12069463          	bnez	a3,983c <__udivdi3+0x2ec>
	      n1 -= d0;
    9718:	409b8433          	sub	s0,s7,s1
	      q1 = 1;
    971c:	00100a93          	li	s5,1
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    9720:	0104db13          	srli	s6,s1,0x10
    9724:	000b0593          	mv	a1,s6
    9728:	00040513          	mv	a0,s0
    972c:	175000ef          	jal	ra,a0a0 <__umodsi3>
    9730:	00050993          	mv	s3,a0
    9734:	000b0593          	mv	a1,s6
    9738:	00040513          	mv	a0,s0
    973c:	01049b93          	slli	s7,s1,0x10
    9740:	119000ef          	jal	ra,a058 <__udivsi3>
    9744:	010bdb93          	srli	s7,s7,0x10
    9748:	00050913          	mv	s2,a0
    974c:	00050593          	mv	a1,a0
    9750:	000b8513          	mv	a0,s7
    9754:	0d9000ef          	jal	ra,a02c <__mulsi3>
    9758:	01099993          	slli	s3,s3,0x10
    975c:	010a5793          	srli	a5,s4,0x10
    9760:	00f9e7b3          	or	a5,s3,a5
    9764:	00090413          	mv	s0,s2
    9768:	00a7fe63          	bleu	a0,a5,9784 <__udivdi3+0x234>
    976c:	009787b3          	add	a5,a5,s1
    9770:	fff90413          	addi	s0,s2,-1
    9774:	0097e863          	bltu	a5,s1,9784 <__udivdi3+0x234>
    9778:	00a7f663          	bleu	a0,a5,9784 <__udivdi3+0x234>
    977c:	ffe90413          	addi	s0,s2,-2
    9780:	009787b3          	add	a5,a5,s1
    9784:	40a78933          	sub	s2,a5,a0
    9788:	000b0593          	mv	a1,s6
    978c:	00090513          	mv	a0,s2
    9790:	111000ef          	jal	ra,a0a0 <__umodsi3>
    9794:	00050993          	mv	s3,a0
    9798:	000b0593          	mv	a1,s6
    979c:	00090513          	mv	a0,s2
    97a0:	0b9000ef          	jal	ra,a058 <__udivsi3>
    97a4:	010a1a13          	slli	s4,s4,0x10
    97a8:	00050913          	mv	s2,a0
    97ac:	00050593          	mv	a1,a0
    97b0:	01099993          	slli	s3,s3,0x10
    97b4:	000b8513          	mv	a0,s7
    97b8:	010a5a13          	srli	s4,s4,0x10
    97bc:	071000ef          	jal	ra,a02c <__mulsi3>
    97c0:	0149ea33          	or	s4,s3,s4
    97c4:	00090613          	mv	a2,s2
    97c8:	00aa7c63          	bleu	a0,s4,97e0 <__udivdi3+0x290>
    97cc:	01448a33          	add	s4,s1,s4
    97d0:	fff90613          	addi	a2,s2,-1
    97d4:	009a6663          	bltu	s4,s1,97e0 <__udivdi3+0x290>
    97d8:	00aa7463          	bleu	a0,s4,97e0 <__udivdi3+0x290>
    97dc:	ffe90613          	addi	a2,s2,-2
    97e0:	01041413          	slli	s0,s0,0x10
    97e4:	00c46433          	or	s0,s0,a2
  return __udivmoddi4 (n, d, (UDWtype *) 0);
}
    97e8:	00040513          	mv	a0,s0
    97ec:	000a8593          	mv	a1,s5
    97f0:	02c12083          	lw	ra,44(sp)
    97f4:	02812403          	lw	s0,40(sp)
    97f8:	02412483          	lw	s1,36(sp)
    97fc:	02012903          	lw	s2,32(sp)
    9800:	01c12983          	lw	s3,28(sp)
    9804:	01812a03          	lw	s4,24(sp)
    9808:	01412a83          	lw	s5,20(sp)
    980c:	01012b03          	lw	s6,16(sp)
    9810:	00c12b83          	lw	s7,12(sp)
    9814:	00812c03          	lw	s8,8(sp)
    9818:	00412c83          	lw	s9,4(sp)
    981c:	00012d03          	lw	s10,0(sp)
    9820:	03010113          	addi	sp,sp,48
    9824:	00008067          	ret
	  count_leading_zeros (bm, d0);
    9828:	010007b7          	lui	a5,0x1000
    982c:	01000993          	li	s3,16
    9830:	ecf4e6e3          	bltu	s1,a5,96fc <__udivdi3+0x1ac>
    9834:	01800993          	li	s3,24
    9838:	ec5ff06f          	j	96fc <__udivdi3+0x1ac>
	      d0 = d0 << bm;
    983c:	00d494b3          	sll	s1,s1,a3
	      n2 = n1 >> b;
    9840:	00ebd9b3          	srl	s3,s7,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    9844:	0104d413          	srli	s0,s1,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    9848:	00eb5733          	srl	a4,s6,a4
    984c:	00db9bb3          	sll	s7,s7,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    9850:	00040593          	mv	a1,s0
    9854:	00098513          	mv	a0,s3
	      n1 = (n1 << bm) | (n0 >> b);
    9858:	01776bb3          	or	s7,a4,s7
	      n0 = n0 << bm;
    985c:	00db1a33          	sll	s4,s6,a3
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    9860:	041000ef          	jal	ra,a0a0 <__umodsi3>
    9864:	00050913          	mv	s2,a0
    9868:	00040593          	mv	a1,s0
    986c:	00098513          	mv	a0,s3
    9870:	01049b13          	slli	s6,s1,0x10
    9874:	7e4000ef          	jal	ra,a058 <__udivsi3>
    9878:	010b5b13          	srli	s6,s6,0x10
    987c:	00050993          	mv	s3,a0
    9880:	00050593          	mv	a1,a0
    9884:	000b0513          	mv	a0,s6
    9888:	7a4000ef          	jal	ra,a02c <__mulsi3>
    988c:	01091913          	slli	s2,s2,0x10
    9890:	010bd713          	srli	a4,s7,0x10
    9894:	00e96733          	or	a4,s2,a4
    9898:	00098a93          	mv	s5,s3
    989c:	00a77e63          	bleu	a0,a4,98b8 <__udivdi3+0x368>
    98a0:	00970733          	add	a4,a4,s1
    98a4:	fff98a93          	addi	s5,s3,-1
    98a8:	00976863          	bltu	a4,s1,98b8 <__udivdi3+0x368>
    98ac:	00a77663          	bleu	a0,a4,98b8 <__udivdi3+0x368>
    98b0:	ffe98a93          	addi	s5,s3,-2
    98b4:	00970733          	add	a4,a4,s1
    98b8:	40a709b3          	sub	s3,a4,a0
    98bc:	00040593          	mv	a1,s0
    98c0:	00098513          	mv	a0,s3
    98c4:	7dc000ef          	jal	ra,a0a0 <__umodsi3>
    98c8:	00040593          	mv	a1,s0
    98cc:	00050913          	mv	s2,a0
    98d0:	00098513          	mv	a0,s3
    98d4:	784000ef          	jal	ra,a058 <__udivsi3>
    98d8:	00050413          	mv	s0,a0
    98dc:	00050593          	mv	a1,a0
    98e0:	000b0513          	mv	a0,s6
    98e4:	748000ef          	jal	ra,a02c <__mulsi3>
    98e8:	010b9713          	slli	a4,s7,0x10
    98ec:	01075713          	srli	a4,a4,0x10
    98f0:	01091913          	slli	s2,s2,0x10
    98f4:	00e967b3          	or	a5,s2,a4
    98f8:	00040713          	mv	a4,s0
    98fc:	00a7fe63          	bleu	a0,a5,9918 <__udivdi3+0x3c8>
    9900:	009787b3          	add	a5,a5,s1
    9904:	fff40713          	addi	a4,s0,-1
    9908:	0097e863          	bltu	a5,s1,9918 <__udivdi3+0x3c8>
    990c:	00a7f663          	bleu	a0,a5,9918 <__udivdi3+0x3c8>
    9910:	ffe40713          	addi	a4,s0,-2
    9914:	009787b3          	add	a5,a5,s1
    9918:	010a9a93          	slli	s5,s5,0x10
    991c:	40a78433          	sub	s0,a5,a0
    9920:	00eaeab3          	or	s5,s5,a4
    9924:	dfdff06f          	j	9720 <__udivdi3+0x1d0>
      if (d1 > n1)
    9928:	1ed5ec63          	bltu	a1,a3,9b20 <__udivdi3+0x5d0>
	  count_leading_zeros (bm, d1);
    992c:	000107b7          	lui	a5,0x10
    9930:	04f6f463          	bleu	a5,a3,9978 <__udivdi3+0x428>
    9934:	0ff00713          	li	a4,255
    9938:	00d735b3          	sltu	a1,a4,a3
    993c:	00359593          	slli	a1,a1,0x3
    9940:	00020737          	lui	a4,0x20
    9944:	39870713          	addi	a4,a4,920 # 20398 <__clz_tab>
    9948:	00b6d7b3          	srl	a5,a3,a1
    994c:	00e787b3          	add	a5,a5,a4
    9950:	0007c703          	lbu	a4,0(a5) # 10000 <__modsi3+0x5f2c>
    9954:	02000a93          	li	s5,32
    9958:	00b70733          	add	a4,a4,a1
    995c:	40ea8ab3          	sub	s5,s5,a4
	  if (bm == 0)
    9960:	020a9663          	bnez	s5,998c <__udivdi3+0x43c>
		  q0 = 1;
    9964:	00100413          	li	s0,1
	      if (n1 > d1 || n0 >= d0)
    9968:	e976e0e3          	bltu	a3,s7,97e8 <__udivdi3+0x298>
    996c:	00cb3633          	sltu	a2,s6,a2
    9970:	00164413          	xori	s0,a2,1
    9974:	e75ff06f          	j	97e8 <__udivdi3+0x298>
	  count_leading_zeros (bm, d1);
    9978:	010007b7          	lui	a5,0x1000
    997c:	01000593          	li	a1,16
    9980:	fcf6e0e3          	bltu	a3,a5,9940 <__udivdi3+0x3f0>
    9984:	01800593          	li	a1,24
    9988:	fb9ff06f          	j	9940 <__udivdi3+0x3f0>
	      d1 = (d1 << bm) | (d0 >> b);
    998c:	00e65cb3          	srl	s9,a2,a4
    9990:	015696b3          	sll	a3,a3,s5
    9994:	00dcecb3          	or	s9,s9,a3
	      n2 = n1 >> b;
    9998:	00ebd4b3          	srl	s1,s7,a4
	      n1 = (n1 << bm) | (n0 >> b);
    999c:	015b97b3          	sll	a5,s7,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    99a0:	010cdb93          	srli	s7,s9,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    99a4:	00eb5733          	srl	a4,s6,a4
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    99a8:	000b8593          	mv	a1,s7
    99ac:	00048513          	mv	a0,s1
	      n1 = (n1 << bm) | (n0 >> b);
    99b0:	00f76433          	or	s0,a4,a5
	      d0 = d0 << bm;
    99b4:	015619b3          	sll	s3,a2,s5
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    99b8:	6e8000ef          	jal	ra,a0a0 <__umodsi3>
    99bc:	00050913          	mv	s2,a0
    99c0:	000b8593          	mv	a1,s7
    99c4:	00048513          	mv	a0,s1
    99c8:	010c9c13          	slli	s8,s9,0x10
    99cc:	68c000ef          	jal	ra,a058 <__udivsi3>
    99d0:	010c5c13          	srli	s8,s8,0x10
    99d4:	00050493          	mv	s1,a0
    99d8:	00050593          	mv	a1,a0
    99dc:	000c0513          	mv	a0,s8
    99e0:	64c000ef          	jal	ra,a02c <__mulsi3>
    99e4:	01091913          	slli	s2,s2,0x10
    99e8:	01045713          	srli	a4,s0,0x10
    99ec:	00e96733          	or	a4,s2,a4
    99f0:	00048a13          	mv	s4,s1
    99f4:	00a77e63          	bleu	a0,a4,9a10 <__udivdi3+0x4c0>
    99f8:	01970733          	add	a4,a4,s9
    99fc:	fff48a13          	addi	s4,s1,-1
    9a00:	01976863          	bltu	a4,s9,9a10 <__udivdi3+0x4c0>
    9a04:	00a77663          	bleu	a0,a4,9a10 <__udivdi3+0x4c0>
    9a08:	ffe48a13          	addi	s4,s1,-2
    9a0c:	01970733          	add	a4,a4,s9
    9a10:	40a704b3          	sub	s1,a4,a0
    9a14:	000b8593          	mv	a1,s7
    9a18:	00048513          	mv	a0,s1
    9a1c:	684000ef          	jal	ra,a0a0 <__umodsi3>
    9a20:	00050913          	mv	s2,a0
    9a24:	000b8593          	mv	a1,s7
    9a28:	00048513          	mv	a0,s1
    9a2c:	62c000ef          	jal	ra,a058 <__udivsi3>
    9a30:	00050493          	mv	s1,a0
    9a34:	00050593          	mv	a1,a0
    9a38:	000c0513          	mv	a0,s8
    9a3c:	5f0000ef          	jal	ra,a02c <__mulsi3>
    9a40:	01041793          	slli	a5,s0,0x10
    9a44:	01091913          	slli	s2,s2,0x10
    9a48:	0107d793          	srli	a5,a5,0x10
    9a4c:	00f967b3          	or	a5,s2,a5
    9a50:	00048613          	mv	a2,s1
    9a54:	00a7fe63          	bleu	a0,a5,9a70 <__udivdi3+0x520>
    9a58:	019787b3          	add	a5,a5,s9
    9a5c:	fff48613          	addi	a2,s1,-1
    9a60:	0197e863          	bltu	a5,s9,9a70 <__udivdi3+0x520>
    9a64:	00a7f663          	bleu	a0,a5,9a70 <__udivdi3+0x520>
    9a68:	ffe48613          	addi	a2,s1,-2
    9a6c:	019787b3          	add	a5,a5,s9
    9a70:	010a1413          	slli	s0,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    9a74:	00010bb7          	lui	s7,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9a78:	00c46433          	or	s0,s0,a2
	      umul_ppmm (m1, m0, q0, d0);
    9a7c:	fffb8913          	addi	s2,s7,-1 # ffff <__modsi3+0x5f2b>
    9a80:	01247d33          	and	s10,s0,s2
    9a84:	0129f933          	and	s2,s3,s2
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9a88:	40a784b3          	sub	s1,a5,a0
	      umul_ppmm (m1, m0, q0, d0);
    9a8c:	00090593          	mv	a1,s2
    9a90:	000d0513          	mv	a0,s10
    9a94:	598000ef          	jal	ra,a02c <__mulsi3>
    9a98:	01045c93          	srli	s9,s0,0x10
    9a9c:	00090593          	mv	a1,s2
    9aa0:	00050a13          	mv	s4,a0
    9aa4:	000c8513          	mv	a0,s9
    9aa8:	584000ef          	jal	ra,a02c <__mulsi3>
    9aac:	0109d993          	srli	s3,s3,0x10
    9ab0:	00050c13          	mv	s8,a0
    9ab4:	00098593          	mv	a1,s3
    9ab8:	000c8513          	mv	a0,s9
    9abc:	570000ef          	jal	ra,a02c <__mulsi3>
    9ac0:	00050913          	mv	s2,a0
    9ac4:	00098593          	mv	a1,s3
    9ac8:	000d0513          	mv	a0,s10
    9acc:	560000ef          	jal	ra,a02c <__mulsi3>
    9ad0:	01850533          	add	a0,a0,s8
    9ad4:	010a5793          	srli	a5,s4,0x10
    9ad8:	00a78533          	add	a0,a5,a0
    9adc:	01857463          	bleu	s8,a0,9ae4 <__udivdi3+0x594>
    9ae0:	01790933          	add	s2,s2,s7
    9ae4:	01055793          	srli	a5,a0,0x10
    9ae8:	012787b3          	add	a5,a5,s2
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    9aec:	02f4e663          	bltu	s1,a5,9b18 <__udivdi3+0x5c8>
    9af0:	bcf492e3          	bne	s1,a5,96b4 <__udivdi3+0x164>
	      umul_ppmm (m1, m0, q0, d0);
    9af4:	000107b7          	lui	a5,0x10
    9af8:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0x5f2b>
    9afc:	00f57533          	and	a0,a0,a5
    9b00:	01051513          	slli	a0,a0,0x10
    9b04:	00fa7a33          	and	s4,s4,a5
	      n0 = n0 << bm;
    9b08:	015b1633          	sll	a2,s6,s5
	      umul_ppmm (m1, m0, q0, d0);
    9b0c:	01450533          	add	a0,a0,s4
	      q1 = 0;
    9b10:	00000a93          	li	s5,0
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    9b14:	cca67ae3          	bleu	a0,a2,97e8 <__udivdi3+0x298>
		  q0--;
    9b18:	fff40413          	addi	s0,s0,-1
    9b1c:	b99ff06f          	j	96b4 <__udivdi3+0x164>
	  q1 = 0;
    9b20:	00000a93          	li	s5,0
	  q0 = 0;
    9b24:	00000413          	li	s0,0
    9b28:	cc1ff06f          	j	97e8 <__udivdi3+0x298>

00009b2c <__umoddi3>:
{
    9b2c:	fb010113          	addi	sp,sp,-80
    9b30:	04812423          	sw	s0,72(sp)
    9b34:	04912223          	sw	s1,68(sp)
    9b38:	03312e23          	sw	s3,60(sp)
    9b3c:	03912223          	sw	s9,36(sp)
    9b40:	04112623          	sw	ra,76(sp)
    9b44:	05212023          	sw	s2,64(sp)
    9b48:	03412c23          	sw	s4,56(sp)
    9b4c:	03512a23          	sw	s5,52(sp)
    9b50:	03612823          	sw	s6,48(sp)
    9b54:	03712623          	sw	s7,44(sp)
    9b58:	03812423          	sw	s8,40(sp)
    9b5c:	03a12023          	sw	s10,32(sp)
    9b60:	01b12e23          	sw	s11,28(sp)
    9b64:	00050c93          	mv	s9,a0
    9b68:	00058993          	mv	s3,a1
  n0 = nn.s.low;
    9b6c:	00050413          	mv	s0,a0
  n1 = nn.s.high;
    9b70:	00058493          	mv	s1,a1
  if (d1 == 0)
    9b74:	26069e63          	bnez	a3,9df0 <__umoddi3+0x2c4>
    9b78:	00020ab7          	lui	s5,0x20
    9b7c:	00060913          	mv	s2,a2
    9b80:	00068a13          	mv	s4,a3
    9b84:	398a8a93          	addi	s5,s5,920 # 20398 <__clz_tab>
      if (d0 > n1)
    9b88:	14c5f463          	bleu	a2,a1,9cd0 <__umoddi3+0x1a4>
	  count_leading_zeros (bm, d0);
    9b8c:	000107b7          	lui	a5,0x10
    9b90:	12f67663          	bleu	a5,a2,9cbc <__umoddi3+0x190>
    9b94:	0ff00793          	li	a5,255
    9b98:	00c7f463          	bleu	a2,a5,9ba0 <__umoddi3+0x74>
    9b9c:	00800a13          	li	s4,8
    9ba0:	014657b3          	srl	a5,a2,s4
    9ba4:	00fa8ab3          	add	s5,s5,a5
    9ba8:	000ac703          	lbu	a4,0(s5)
    9bac:	02000513          	li	a0,32
    9bb0:	01470733          	add	a4,a4,s4
    9bb4:	40e50a33          	sub	s4,a0,a4
	  if (bm != 0)
    9bb8:	000a0c63          	beqz	s4,9bd0 <__umoddi3+0xa4>
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    9bbc:	014995b3          	sll	a1,s3,s4
    9bc0:	00ecd733          	srl	a4,s9,a4
	      d0 = d0 << bm;
    9bc4:	01461933          	sll	s2,a2,s4
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
    9bc8:	00b764b3          	or	s1,a4,a1
	      n0 = n0 << bm;
    9bcc:	014c9433          	sll	s0,s9,s4
	  udiv_qrnnd (q0, n0, n1, n0, d0);
    9bd0:	01095a93          	srli	s5,s2,0x10
    9bd4:	000a8593          	mv	a1,s5
    9bd8:	00048513          	mv	a0,s1
    9bdc:	4c4000ef          	jal	ra,a0a0 <__umodsi3>
    9be0:	00050993          	mv	s3,a0
    9be4:	000a8593          	mv	a1,s5
    9be8:	01091b13          	slli	s6,s2,0x10
    9bec:	00048513          	mv	a0,s1
    9bf0:	468000ef          	jal	ra,a058 <__udivsi3>
    9bf4:	010b5b13          	srli	s6,s6,0x10
    9bf8:	00050593          	mv	a1,a0
    9bfc:	000b0513          	mv	a0,s6
    9c00:	42c000ef          	jal	ra,a02c <__mulsi3>
    9c04:	01099993          	slli	s3,s3,0x10
    9c08:	01045793          	srli	a5,s0,0x10
    9c0c:	00f9e7b3          	or	a5,s3,a5
    9c10:	00a7fa63          	bleu	a0,a5,9c24 <__umoddi3+0xf8>
    9c14:	012787b3          	add	a5,a5,s2
    9c18:	0127e663          	bltu	a5,s2,9c24 <__umoddi3+0xf8>
    9c1c:	00a7f463          	bleu	a0,a5,9c24 <__umoddi3+0xf8>
    9c20:	012787b3          	add	a5,a5,s2
    9c24:	40a784b3          	sub	s1,a5,a0
    9c28:	000a8593          	mv	a1,s5
    9c2c:	00048513          	mv	a0,s1
    9c30:	470000ef          	jal	ra,a0a0 <__umodsi3>
    9c34:	00050993          	mv	s3,a0
    9c38:	000a8593          	mv	a1,s5
    9c3c:	00048513          	mv	a0,s1
    9c40:	418000ef          	jal	ra,a058 <__udivsi3>
    9c44:	01041413          	slli	s0,s0,0x10
    9c48:	00050593          	mv	a1,a0
    9c4c:	01099993          	slli	s3,s3,0x10
    9c50:	000b0513          	mv	a0,s6
    9c54:	01045413          	srli	s0,s0,0x10
    9c58:	3d4000ef          	jal	ra,a02c <__mulsi3>
    9c5c:	0089e433          	or	s0,s3,s0
    9c60:	00a47a63          	bleu	a0,s0,9c74 <__umoddi3+0x148>
    9c64:	01240433          	add	s0,s0,s2
    9c68:	01246663          	bltu	s0,s2,9c74 <__umoddi3+0x148>
    9c6c:	00a47463          	bleu	a0,s0,9c74 <__umoddi3+0x148>
    9c70:	01240433          	add	s0,s0,s2
    9c74:	40a40433          	sub	s0,s0,a0
	  rr.s.low = n0 >> bm;
    9c78:	01445533          	srl	a0,s0,s4
	  *rp = rr.ll;
    9c7c:	00000593          	li	a1,0
}
    9c80:	04c12083          	lw	ra,76(sp)
    9c84:	04812403          	lw	s0,72(sp)
    9c88:	04412483          	lw	s1,68(sp)
    9c8c:	04012903          	lw	s2,64(sp)
    9c90:	03c12983          	lw	s3,60(sp)
    9c94:	03812a03          	lw	s4,56(sp)
    9c98:	03412a83          	lw	s5,52(sp)
    9c9c:	03012b03          	lw	s6,48(sp)
    9ca0:	02c12b83          	lw	s7,44(sp)
    9ca4:	02812c03          	lw	s8,40(sp)
    9ca8:	02412c83          	lw	s9,36(sp)
    9cac:	02012d03          	lw	s10,32(sp)
    9cb0:	01c12d83          	lw	s11,28(sp)
    9cb4:	05010113          	addi	sp,sp,80
    9cb8:	00008067          	ret
	  count_leading_zeros (bm, d0);
    9cbc:	010007b7          	lui	a5,0x1000
    9cc0:	01000a13          	li	s4,16
    9cc4:	ecf66ee3          	bltu	a2,a5,9ba0 <__umoddi3+0x74>
    9cc8:	01800a13          	li	s4,24
    9ccc:	ed5ff06f          	j	9ba0 <__umoddi3+0x74>
	  if (d0 == 0)
    9cd0:	00061a63          	bnez	a2,9ce4 <__umoddi3+0x1b8>
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */
    9cd4:	00000593          	li	a1,0
    9cd8:	00100513          	li	a0,1
    9cdc:	37c000ef          	jal	ra,a058 <__udivsi3>
    9ce0:	00050913          	mv	s2,a0
	  count_leading_zeros (bm, d0);
    9ce4:	000107b7          	lui	a5,0x10
    9ce8:	0ef97a63          	bleu	a5,s2,9ddc <__umoddi3+0x2b0>
    9cec:	0ff00793          	li	a5,255
    9cf0:	0127f463          	bleu	s2,a5,9cf8 <__umoddi3+0x1cc>
    9cf4:	00800a13          	li	s4,8
    9cf8:	014957b3          	srl	a5,s2,s4
    9cfc:	00fa8ab3          	add	s5,s5,a5
    9d00:	000ac703          	lbu	a4,0(s5)
    9d04:	02000513          	li	a0,32
	      n1 -= d0;
    9d08:	412984b3          	sub	s1,s3,s2
	  count_leading_zeros (bm, d0);
    9d0c:	01470733          	add	a4,a4,s4
    9d10:	40e50a33          	sub	s4,a0,a4
	  if (bm == 0)
    9d14:	ea0a0ee3          	beqz	s4,9bd0 <__umoddi3+0xa4>
	      d0 = d0 << bm;
    9d18:	01491933          	sll	s2,s2,s4
	      n2 = n1 >> b;
    9d1c:	00e9dab3          	srl	s5,s3,a4
	      n1 = (n1 << bm) | (n0 >> b);
    9d20:	014995b3          	sll	a1,s3,s4
    9d24:	00ecd733          	srl	a4,s9,a4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    9d28:	01095493          	srli	s1,s2,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    9d2c:	00b76b33          	or	s6,a4,a1
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    9d30:	000a8513          	mv	a0,s5
    9d34:	00048593          	mv	a1,s1
    9d38:	368000ef          	jal	ra,a0a0 <__umodsi3>
    9d3c:	00050993          	mv	s3,a0
    9d40:	00048593          	mv	a1,s1
    9d44:	01091b93          	slli	s7,s2,0x10
    9d48:	000a8513          	mv	a0,s5
    9d4c:	30c000ef          	jal	ra,a058 <__udivsi3>
    9d50:	010bdb93          	srli	s7,s7,0x10
    9d54:	00050593          	mv	a1,a0
    9d58:	000b8513          	mv	a0,s7
    9d5c:	2d0000ef          	jal	ra,a02c <__mulsi3>
    9d60:	01099993          	slli	s3,s3,0x10
    9d64:	010b5793          	srli	a5,s6,0x10
    9d68:	00f9e7b3          	or	a5,s3,a5
	      n0 = n0 << bm;
    9d6c:	014c9433          	sll	s0,s9,s4
	      udiv_qrnnd (q1, n1, n2, n1, d0);
    9d70:	00a7fa63          	bleu	a0,a5,9d84 <__umoddi3+0x258>
    9d74:	012787b3          	add	a5,a5,s2
    9d78:	0127e663          	bltu	a5,s2,9d84 <__umoddi3+0x258>
    9d7c:	00a7f463          	bleu	a0,a5,9d84 <__umoddi3+0x258>
    9d80:	012787b3          	add	a5,a5,s2
    9d84:	40a78ab3          	sub	s5,a5,a0
    9d88:	00048593          	mv	a1,s1
    9d8c:	000a8513          	mv	a0,s5
    9d90:	310000ef          	jal	ra,a0a0 <__umodsi3>
    9d94:	00050993          	mv	s3,a0
    9d98:	00048593          	mv	a1,s1
    9d9c:	000a8513          	mv	a0,s5
    9da0:	2b8000ef          	jal	ra,a058 <__udivsi3>
    9da4:	00050593          	mv	a1,a0
    9da8:	000b8513          	mv	a0,s7
    9dac:	280000ef          	jal	ra,a02c <__mulsi3>
    9db0:	010b1593          	slli	a1,s6,0x10
    9db4:	01099993          	slli	s3,s3,0x10
    9db8:	0105d593          	srli	a1,a1,0x10
    9dbc:	00b9e5b3          	or	a1,s3,a1
    9dc0:	00a5fa63          	bleu	a0,a1,9dd4 <__umoddi3+0x2a8>
    9dc4:	012585b3          	add	a1,a1,s2
    9dc8:	0125e663          	bltu	a1,s2,9dd4 <__umoddi3+0x2a8>
    9dcc:	00a5f463          	bleu	a0,a1,9dd4 <__umoddi3+0x2a8>
    9dd0:	012585b3          	add	a1,a1,s2
    9dd4:	40a584b3          	sub	s1,a1,a0
    9dd8:	df9ff06f          	j	9bd0 <__umoddi3+0xa4>
	  count_leading_zeros (bm, d0);
    9ddc:	010007b7          	lui	a5,0x1000
    9de0:	01000a13          	li	s4,16
    9de4:	f0f96ae3          	bltu	s2,a5,9cf8 <__umoddi3+0x1cc>
    9de8:	01800a13          	li	s4,24
    9dec:	f0dff06f          	j	9cf8 <__umoddi3+0x1cc>
      if (d1 > n1)
    9df0:	e8d5e8e3          	bltu	a1,a3,9c80 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    9df4:	000107b7          	lui	a5,0x10
    9df8:	04f6fc63          	bleu	a5,a3,9e50 <__umoddi3+0x324>
    9dfc:	0ff00b93          	li	s7,255
    9e00:	00dbb533          	sltu	a0,s7,a3
    9e04:	00351513          	slli	a0,a0,0x3
    9e08:	00020737          	lui	a4,0x20
    9e0c:	00a6d7b3          	srl	a5,a3,a0
    9e10:	39870713          	addi	a4,a4,920 # 20398 <__clz_tab>
    9e14:	00e787b3          	add	a5,a5,a4
    9e18:	0007cb83          	lbu	s7,0(a5) # 10000 <__modsi3+0x5f2c>
    9e1c:	02000593          	li	a1,32
    9e20:	00ab8bb3          	add	s7,s7,a0
    9e24:	41758b33          	sub	s6,a1,s7
	  if (bm == 0)
    9e28:	020b1e63          	bnez	s6,9e64 <__umoddi3+0x338>
	      if (n1 > d1 || n0 >= d0)
    9e2c:	0136e463          	bltu	a3,s3,9e34 <__umoddi3+0x308>
    9e30:	00ccea63          	bltu	s9,a2,9e44 <__umoddi3+0x318>
		  sub_ddmmss (n1, n0, n1, n0, d1, d0);
    9e34:	40cc8433          	sub	s0,s9,a2
    9e38:	40d986b3          	sub	a3,s3,a3
    9e3c:	008cb533          	sltu	a0,s9,s0
    9e40:	40a684b3          	sub	s1,a3,a0
		  *rp = rr.ll;
    9e44:	00040513          	mv	a0,s0
    9e48:	00048593          	mv	a1,s1
    9e4c:	e35ff06f          	j	9c80 <__umoddi3+0x154>
	  count_leading_zeros (bm, d1);
    9e50:	010007b7          	lui	a5,0x1000
    9e54:	01000513          	li	a0,16
    9e58:	faf6e8e3          	bltu	a3,a5,9e08 <__umoddi3+0x2dc>
    9e5c:	01800513          	li	a0,24
    9e60:	fa9ff06f          	j	9e08 <__umoddi3+0x2dc>
	      d1 = (d1 << bm) | (d0 >> b);
    9e64:	016696b3          	sll	a3,a3,s6
    9e68:	01765d33          	srl	s10,a2,s7
    9e6c:	00dd6d33          	or	s10,s10,a3
	      n2 = n1 >> b;
    9e70:	0179d433          	srl	s0,s3,s7
	      n1 = (n1 << bm) | (n0 >> b);
    9e74:	016995b3          	sll	a1,s3,s6
    9e78:	017cdc33          	srl	s8,s9,s7
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9e7c:	010d5493          	srli	s1,s10,0x10
	      n1 = (n1 << bm) | (n0 >> b);
    9e80:	00bc6c33          	or	s8,s8,a1
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9e84:	00040513          	mv	a0,s0
    9e88:	00048593          	mv	a1,s1
	      d0 = d0 << bm;
    9e8c:	01661ab3          	sll	s5,a2,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9e90:	210000ef          	jal	ra,a0a0 <__umodsi3>
    9e94:	00050a13          	mv	s4,a0
    9e98:	00048593          	mv	a1,s1
    9e9c:	00040513          	mv	a0,s0
	      n0 = n0 << bm;
    9ea0:	016c9933          	sll	s2,s9,s6
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9ea4:	010d1c93          	slli	s9,s10,0x10
    9ea8:	1b0000ef          	jal	ra,a058 <__udivsi3>
    9eac:	010cdc93          	srli	s9,s9,0x10
    9eb0:	00050413          	mv	s0,a0
    9eb4:	00050593          	mv	a1,a0
    9eb8:	000c8513          	mv	a0,s9
    9ebc:	170000ef          	jal	ra,a02c <__mulsi3>
    9ec0:	010a1a13          	slli	s4,s4,0x10
    9ec4:	010c5713          	srli	a4,s8,0x10
    9ec8:	00ea6733          	or	a4,s4,a4
    9ecc:	00040a13          	mv	s4,s0
    9ed0:	00a77e63          	bleu	a0,a4,9eec <__umoddi3+0x3c0>
    9ed4:	01a70733          	add	a4,a4,s10
    9ed8:	fff40a13          	addi	s4,s0,-1
    9edc:	01a76863          	bltu	a4,s10,9eec <__umoddi3+0x3c0>
    9ee0:	00a77663          	bleu	a0,a4,9eec <__umoddi3+0x3c0>
    9ee4:	ffe40a13          	addi	s4,s0,-2
    9ee8:	01a70733          	add	a4,a4,s10
    9eec:	40a709b3          	sub	s3,a4,a0
    9ef0:	00048593          	mv	a1,s1
    9ef4:	00098513          	mv	a0,s3
    9ef8:	1a8000ef          	jal	ra,a0a0 <__umodsi3>
    9efc:	00048593          	mv	a1,s1
    9f00:	00050413          	mv	s0,a0
    9f04:	00098513          	mv	a0,s3
    9f08:	150000ef          	jal	ra,a058 <__udivsi3>
    9f0c:	00050593          	mv	a1,a0
    9f10:	00050493          	mv	s1,a0
    9f14:	000c8513          	mv	a0,s9
    9f18:	114000ef          	jal	ra,a02c <__mulsi3>
    9f1c:	010c1593          	slli	a1,s8,0x10
    9f20:	01041413          	slli	s0,s0,0x10
    9f24:	0105d593          	srli	a1,a1,0x10
    9f28:	00b465b3          	or	a1,s0,a1
    9f2c:	00048713          	mv	a4,s1
    9f30:	00a5fe63          	bleu	a0,a1,9f4c <__umoddi3+0x420>
    9f34:	01a585b3          	add	a1,a1,s10
    9f38:	fff48713          	addi	a4,s1,-1
    9f3c:	01a5e863          	bltu	a1,s10,9f4c <__umoddi3+0x420>
    9f40:	00a5f663          	bleu	a0,a1,9f4c <__umoddi3+0x420>
    9f44:	ffe48713          	addi	a4,s1,-2
    9f48:	01a585b3          	add	a1,a1,s10
    9f4c:	010a1a13          	slli	s4,s4,0x10
	      umul_ppmm (m1, m0, q0, d0);
    9f50:	00010cb7          	lui	s9,0x10
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9f54:	00ea6a33          	or	s4,s4,a4
	      umul_ppmm (m1, m0, q0, d0);
    9f58:	fffc8413          	addi	s0,s9,-1 # ffff <__modsi3+0x5f2b>
    9f5c:	008a77b3          	and	a5,s4,s0
    9f60:	008af433          	and	s0,s5,s0
	      udiv_qrnnd (q0, n1, n2, n1, d1);
    9f64:	40a584b3          	sub	s1,a1,a0
	      umul_ppmm (m1, m0, q0, d0);
    9f68:	00078513          	mv	a0,a5
    9f6c:	00040593          	mv	a1,s0
    9f70:	00f12623          	sw	a5,12(sp)
    9f74:	010a5a13          	srli	s4,s4,0x10
    9f78:	0b4000ef          	jal	ra,a02c <__mulsi3>
    9f7c:	00050993          	mv	s3,a0
    9f80:	00040593          	mv	a1,s0
    9f84:	000a0513          	mv	a0,s4
    9f88:	0a4000ef          	jal	ra,a02c <__mulsi3>
    9f8c:	010adc13          	srli	s8,s5,0x10
    9f90:	00050d93          	mv	s11,a0
    9f94:	000c0593          	mv	a1,s8
    9f98:	000a0513          	mv	a0,s4
    9f9c:	090000ef          	jal	ra,a02c <__mulsi3>
    9fa0:	00c12783          	lw	a5,12(sp)
    9fa4:	00050a13          	mv	s4,a0
    9fa8:	000c0593          	mv	a1,s8
    9fac:	00078513          	mv	a0,a5
    9fb0:	07c000ef          	jal	ra,a02c <__mulsi3>
    9fb4:	01b50533          	add	a0,a0,s11
    9fb8:	0109d713          	srli	a4,s3,0x10
    9fbc:	00a70733          	add	a4,a4,a0
    9fc0:	01b77463          	bleu	s11,a4,9fc8 <__umoddi3+0x49c>
    9fc4:	019a0a33          	add	s4,s4,s9
    9fc8:	000107b7          	lui	a5,0x10
    9fcc:	fff78793          	addi	a5,a5,-1 # ffff <__modsi3+0x5f2b>
    9fd0:	01075593          	srli	a1,a4,0x10
    9fd4:	00f77733          	and	a4,a4,a5
    9fd8:	01071713          	slli	a4,a4,0x10
    9fdc:	00f9f7b3          	and	a5,s3,a5
    9fe0:	014585b3          	add	a1,a1,s4
    9fe4:	00f707b3          	add	a5,a4,a5
	      if (m1 > n1 || (m1 == n1 && m0 > n0))
    9fe8:	00b4e663          	bltu	s1,a1,9ff4 <__umoddi3+0x4c8>
    9fec:	00b49e63          	bne	s1,a1,a008 <__umoddi3+0x4dc>
    9ff0:	00f97c63          	bleu	a5,s2,a008 <__umoddi3+0x4dc>
		  sub_ddmmss (m1, m0, m1, m0, d1, d0);
    9ff4:	41578633          	sub	a2,a5,s5
    9ff8:	00c7b7b3          	sltu	a5,a5,a2
    9ffc:	41a585b3          	sub	a1,a1,s10
    a000:	40f585b3          	sub	a1,a1,a5
    a004:	00060793          	mv	a5,a2
		  sub_ddmmss (n1, n0, n1, n0, m1, m0);
    a008:	40f907b3          	sub	a5,s2,a5
    a00c:	00f93933          	sltu	s2,s2,a5
    a010:	40b485b3          	sub	a1,s1,a1
    a014:	412585b3          	sub	a1,a1,s2
		  rr.s.low = (n1 << b) | (n0 >> bm);
    a018:	01759433          	sll	s0,a1,s7
    a01c:	0167d7b3          	srl	a5,a5,s6
		  *rp = rr.ll;
    a020:	00f46533          	or	a0,s0,a5
    a024:	0165d5b3          	srl	a1,a1,s6
  return w;
    a028:	c59ff06f          	j	9c80 <__umoddi3+0x154>

0000a02c <__mulsi3>:
# define __muldi3 __mulsi3
#endif

  .globl __muldi3
__muldi3:
  mv     a2, a0
    a02c:	00050613          	mv	a2,a0
  li     a0, 0
    a030:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
    a034:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
    a038:	00068463          	beqz	a3,a040 <__mulsi3+0x14>
  add    a0, a0, a2
    a03c:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
    a040:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
    a044:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
    a048:	fe0596e3          	bnez	a1,a034 <__mulsi3+0x8>
  ret
    a04c:	00008067          	ret

0000a050 <__divsi3>:
  beq   a1, t0, .L20
#endif

  .globl __divdi3
__divdi3:
  bltz  a0, .L10
    a050:	06054063          	bltz	a0,a0b0 <__umodsi3+0x10>
  bltz  a1, .L11
    a054:	0605c663          	bltz	a1,a0c0 <__umodsi3+0x20>

0000a058 <__udivsi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

  .globl __udivdi3
__udivdi3:
  mv    a2, a1
    a058:	00058613          	mv	a2,a1
  mv    a1, a0
    a05c:	00050593          	mv	a1,a0
  li    a0, -1
    a060:	fff00513          	li	a0,-1
  beqz  a2, .L5
    a064:	02060c63          	beqz	a2,a09c <__udivsi3+0x44>
  li    a3, 1
    a068:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
    a06c:	00b67a63          	bleu	a1,a2,a080 <__udivsi3+0x28>
.L1:
  blez  a2, .L2
    a070:	00c05863          	blez	a2,a080 <__udivsi3+0x28>
  slli  a2, a2, 1
    a074:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
    a078:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
    a07c:	feb66ae3          	bltu	a2,a1,a070 <__udivsi3+0x18>
.L2:
  li    a0, 0
    a080:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
    a084:	00c5e663          	bltu	a1,a2,a090 <__udivsi3+0x38>
  sub   a1, a1, a2
    a088:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
    a08c:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
    a090:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
    a094:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
    a098:	fe0696e3          	bnez	a3,a084 <__udivsi3+0x2c>
.L5:
  ret
    a09c:	00008067          	ret

0000a0a0 <__umodsi3>:

  .globl __umoddi3
__umoddi3:
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
    a0a0:	00008293          	mv	t0,ra
  jal   __udivdi3
    a0a4:	fb5ff0ef          	jal	ra,a058 <__udivsi3>
  move  a0, a1
    a0a8:	00058513          	mv	a0,a1
  jr    t0
    a0ac:	00028067          	jr	t0

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
    a0b0:	40a00533          	neg	a0,a0
  bgez  a1, .L12      /* Compute __udivdi3(-a0, a1), then negate the result.  */
    a0b4:	0005d863          	bgez	a1,a0c4 <__umodsi3+0x24>
  neg   a1, a1
    a0b8:	40b005b3          	neg	a1,a1
  j     __udivdi3     /* Compute __udivdi3(-a0, -a1).  */
    a0bc:	f9dff06f          	j	a058 <__udivsi3>
.L11:                 /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
    a0c0:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
    a0c4:	00008293          	mv	t0,ra
  jal   __udivdi3
    a0c8:	f91ff0ef          	jal	ra,a058 <__udivsi3>
  neg   a0, a0
    a0cc:	40a00533          	neg	a0,a0
  jr    t0
    a0d0:	00028067          	jr	t0

0000a0d4 <__modsi3>:

  .globl __moddi3
__moddi3:
  move   t0, ra
    a0d4:	00008293          	mv	t0,ra
  bltz   a1, .L31
    a0d8:	0005ca63          	bltz	a1,a0ec <__modsi3+0x18>
  bltz   a0, .L32
    a0dc:	00054c63          	bltz	a0,a0f4 <__modsi3+0x20>
.L30:
  jal    __udivdi3    /* The dividend is not negative.  */
    a0e0:	f79ff0ef          	jal	ra,a058 <__udivsi3>
  move   a0, a1
    a0e4:	00058513          	mv	a0,a1
  jr     t0
    a0e8:	00028067          	jr	t0
.L31:
  neg    a1, a1
    a0ec:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
    a0f0:	fe0558e3          	bgez	a0,a0e0 <__modsi3+0xc>
.L32:
  neg    a0, a0
    a0f4:	40a00533          	neg	a0,a0
  jal    __udivdi3    /* The dividend is hella negative.  */
    a0f8:	f61ff0ef          	jal	ra,a058 <__udivsi3>
  neg    a0, a1
    a0fc:	40b00533          	neg	a0,a1
  jr     t0
    a100:	00028067          	jr	t0
