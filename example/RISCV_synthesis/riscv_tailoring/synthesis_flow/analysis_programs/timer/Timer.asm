
Timer.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
   0:	00002fb7          	lui	t6,0x2
   4:	800f8f93          	addi	t6,t6,-2048 # 1800 <_HEAP_SIZE+0x800>
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
  c8:	00020197          	auipc	gp,0x20
  cc:	73c18193          	addi	gp,gp,1852 # 20804 <_gp>

000000d0 <init_bss>:
  d0:	00020517          	auipc	a0,0x20
  d4:	f3c50513          	addi	a0,a0,-196 # 2000c <__data_end>
  d8:	00020597          	auipc	a1,0x20
  dc:	f3058593          	addi	a1,a1,-208 # 20008 <mtimecmp>
  e0:	00000613          	li	a2,0
  e4:	0ec000ef          	jal	ra,1d0 <fill_block>

000000e8 <init_sbss>:
  e8:	00020517          	auipc	a0,0x20
  ec:	f1850513          	addi	a0,a0,-232 # 20000 <__rodata_end>
  f0:	00020597          	auipc	a1,0x20
  f4:	f1058593          	addi	a1,a1,-240 # 20000 <__rodata_end>
  f8:	00000613          	li	a2,0
  fc:	0d4000ef          	jal	ra,1d0 <fill_block>

00000100 <write_stack_pattern>:
 100:	00021517          	auipc	a0,0x21
 104:	f0c50513          	addi	a0,a0,-244 # 2100c <_heap_end>
 108:	00022597          	auipc	a1,0x22
 10c:	f0058593          	addi	a1,a1,-256 # 22008 <_heap_end+0xffc>
 110:	ababb637          	lui	a2,0xababb
 114:	bab60613          	addi	a2,a2,-1109 # abababab <__stack+0xaba98b9f>
 118:	0b8000ef          	jal	ra,1d0 <fill_block>

0000011c <init_stack>:
 11c:	00022117          	auipc	sp,0x22
 120:	ef010113          	addi	sp,sp,-272 # 2200c <__stack>
 124:	08000313          	li	t1,128
 128:	30431073          	csrw	mie,t1
 12c:	30045073          	csrwi	mstatus,8
 130:	18c0006f          	j	2bc <main>

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
 180:	074000ef          	jal	ra,1f4 <level_1_interrupt_handler>
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

000001f4 <level_1_interrupt_handler>:
 1f4:	fe010113          	addi	sp,sp,-32
 1f8:	00112e23          	sw	ra,28(sp)
 1fc:	00a12623          	sw	a0,12(sp)
 200:	00c12783          	lw	a5,12(sp)
 204:	00f7f713          	andi	a4,a5,15
 208:	00700793          	li	a5,7
 20c:	00f70463          	beq	a4,a5,214 <level_1_interrupt_handler+0x20>
 210:	0100006f          	j	220 <level_1_interrupt_handler+0x2c>
 214:	070000ef          	jal	ra,284 <timer_irq_handler>
 218:	00000013          	nop
 21c:	00000013          	nop
 220:	01c12083          	lw	ra,28(sp)
 224:	02010113          	addi	sp,sp,32
 228:	00008067          	ret

0000022c <set_next_timer_interrupt>:
 22c:	00020797          	auipc	a5,0x20
 230:	dd878793          	addi	a5,a5,-552 # 20004 <__sbss_end>
 234:	0007a783          	lw	a5,0(a5)
 238:	0047a803          	lw	a6,4(a5)
 23c:	0007a783          	lw	a5,0(a5)
 240:	00020717          	auipc	a4,0x20
 244:	dc870713          	addi	a4,a4,-568 # 20008 <mtimecmp>
 248:	00072503          	lw	a0,0(a4)
 24c:	06400593          	li	a1,100
 250:	00000613          	li	a2,0
 254:	00b786b3          	add	a3,a5,a1
 258:	00068893          	mv	a7,a3
 25c:	00f8b8b3          	sltu	a7,a7,a5
 260:	00c80733          	add	a4,a6,a2
 264:	00e887b3          	add	a5,a7,a4
 268:	00078713          	mv	a4,a5
 26c:	00068793          	mv	a5,a3
 270:	00070813          	mv	a6,a4
 274:	00f52023          	sw	a5,0(a0)
 278:	01052223          	sw	a6,4(a0)
 27c:	00000013          	nop
 280:	00008067          	ret

00000284 <timer_irq_handler>:
 284:	ff010113          	addi	sp,sp,-16
 288:	00112623          	sw	ra,12(sp)
 28c:	00020797          	auipc	a5,0x20
 290:	d7478793          	addi	a5,a5,-652 # 20000 <__rodata_end>
 294:	0007a783          	lw	a5,0(a5)
 298:	00178713          	addi	a4,a5,1
 29c:	00020797          	auipc	a5,0x20
 2a0:	d6478793          	addi	a5,a5,-668 # 20000 <__rodata_end>
 2a4:	00e7a023          	sw	a4,0(a5)
 2a8:	f85ff0ef          	jal	ra,22c <set_next_timer_interrupt>
 2ac:	00000013          	nop
 2b0:	00c12083          	lw	ra,12(sp)
 2b4:	01010113          	addi	sp,sp,16
 2b8:	00008067          	ret

000002bc <main>:
 2bc:	ff010113          	addi	sp,sp,-16
 2c0:	00112623          	sw	ra,12(sp)
 2c4:	f69ff0ef          	jal	ra,22c <set_next_timer_interrupt>
 2c8:	00000013          	nop
 2cc:	00020797          	auipc	a5,0x20
 2d0:	d3478793          	addi	a5,a5,-716 # 20000 <__rodata_end>
 2d4:	0007a703          	lw	a4,0(a5)
 2d8:	00400793          	li	a5,4
 2dc:	fee7f8e3          	bleu	a4,a5,2cc <main+0x10>
 2e0:	00000793          	li	a5,0
 2e4:	00078513          	mv	a0,a5
 2e8:	00c12083          	lw	ra,12(sp)
 2ec:	01010113          	addi	sp,sp,16
 2f0:	00008067          	ret
