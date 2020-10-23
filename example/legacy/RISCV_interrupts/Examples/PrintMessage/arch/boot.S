#include "encoding.h"

#if __riscv_xlen == 64
# define STORE    sd
# define LOAD     ld
# define REGBYTES 8
#else
# define STORE    sw
# define LOAD     lw
# define REGBYTES 4
#endif

boot:
    li t6, 0x1800
    csrw mstatus, t6
    j _mstart

	.align 6
	.section .text,"ax",@progbits
	.globl _mstart
/* Startup code */
_mstart:
    la t0, trap_entry
    csrw mtvec, t0
    li	x1, 0
    li	x2, 0
    li	x3, 0
    li	x4, 0
    li	x5, 0
	li	x6, 0
    li	x7, 0
    li	x8, 0
    li	x9, 0
    li	x10, 0
    li	x11, 0
    li	x12, 0
    li	x13, 0
    li	x14, 0
    li	x15, 0
    li	x16, 0
    li	x17, 0
    li	x18, 0
    li	x19, 0
    li	x20, 0
    li	x21, 0
    li	x22, 0
    li	x23, 0
    li	x24, 0
    li	x25, 0
    li	x26, 0
    li	x27, 0
    li	x28, 0
    li	x29, 0
    li	x30, 0
    li	x31, 0

    /* initialize global pointer */
    la	gp, _gp

init_bss:
    /* init bss section */
    la	a0, __bss_start
    la	a1, __bss_end-4 /* section end is actually the start of the next section */
    li	a2, 0x0
    jal	fill_block

init_sbss:
    /* init bss section */
    la	a0, __sbss_start
    la	a1, __sbss_end-4 /* section end is actually the start of the next section */
    li	a2, 0x0
    jal	fill_block

write_stack_pattern:
    /* init bss section */
    la	a0, _stack_end  /* note the stack grows from top to bottom */
    la	a1, __stack-4   /* section end is actually the start of the next section */
    li	a2, 0xABABABAB
    jal	fill_block

init_stack:
    /* set stack pointer */
    la	sp, _stack

    /* enable no interrupts */
    li t1, 0x0
    csrw mie, t1
    csrwi mstatus, 0

	j	vSyscallInit

/* When trap is an interrupt, this function is called */
interrupt:
	slli    t0,t0,1
	srli    t0,t0,1
	addi    t0,t0,-3
	beq		t0,x0,softwareInterrupt
	LOAD	t0, 0x0(sp)
	addi	sp, sp, REGBYTES

	/* Interupt is timer interrupt */
	/* j		TIMER_CMP_INT */
	mret

softwareInterrupt:
	/* Interupt is software interrupt */
	LOAD  t0, 0x0(sp)
	addi  sp, sp, REGBYTES
	mret

/* For when a trap is fired */
.align 2
trap_entry:
	/* Check for interrupt */
	addi	sp, sp, -REGBYTES
	STORE	t0, 0x0(sp)
	csrr	t0, mcause
	blt	t0,x0,interrupt
	LOAD	t0, 0x0(sp)
	addi	sp, sp, REGBYTES

	/* System call and other traps */
	addi sp, sp, -REGBYTES*32
	STORE x1, 1*REGBYTES(sp)
	STORE x2, 2*REGBYTES(sp)
	STORE x3, 3*REGBYTES(sp)
	STORE x4, 4*REGBYTES(sp)
	STORE x5, 5*REGBYTES(sp)
	STORE x6, 6*REGBYTES(sp)
	STORE x7, 7*REGBYTES(sp)
	STORE x8, 8*REGBYTES(sp)
	STORE x9, 9*REGBYTES(sp)
	STORE x10, 10*REGBYTES(sp)
	STORE x11, 11*REGBYTES(sp)
	STORE x12, 12*REGBYTES(sp)
	STORE x13, 13*REGBYTES(sp)
	STORE x14, 14*REGBYTES(sp)
	STORE x15, 15*REGBYTES(sp)
	STORE x16, 16*REGBYTES(sp)
	STORE x17, 17*REGBYTES(sp)
	STORE x18, 18*REGBYTES(sp)
	STORE x19, 19*REGBYTES(sp)
	STORE x20, 20*REGBYTES(sp)
	STORE x21, 21*REGBYTES(sp)
	STORE x22, 22*REGBYTES(sp)
	STORE x23, 23*REGBYTES(sp)
	STORE x24, 24*REGBYTES(sp)
	STORE x25, 25*REGBYTES(sp)
	STORE x26, 26*REGBYTES(sp)
	STORE x27, 27*REGBYTES(sp)
	STORE x28, 28*REGBYTES(sp)
	STORE x29, 29*REGBYTES(sp)
	STORE x30, 30*REGBYTES(sp)
	STORE x31, 31*REGBYTES(sp)

	csrr a0, mcause
	csrr a1, mepc


	mv a2, sp
	jal ulSyscallTrap

	csrw mepc, a0

	LOAD x1, 1*REGBYTES(sp)
	LOAD x2, 2*REGBYTES(sp)
	LOAD x3, 3*REGBYTES(sp)
	LOAD x4, 4*REGBYTES(sp)
	LOAD x5, 5*REGBYTES(sp)
	LOAD x6, 6*REGBYTES(sp)
	LOAD x7, 7*REGBYTES(sp)
	LOAD x8, 8*REGBYTES(sp)
	LOAD x9, 9*REGBYTES(sp)
	LOAD x10, 10*REGBYTES(sp)
	LOAD x11, 11*REGBYTES(sp)
	LOAD x12, 12*REGBYTES(sp)
	LOAD x13, 13*REGBYTES(sp)
	LOAD x14, 14*REGBYTES(sp)
	LOAD x15, 15*REGBYTES(sp)
	LOAD x16, 16*REGBYTES(sp)
	LOAD x17, 17*REGBYTES(sp)
	LOAD x18, 18*REGBYTES(sp)
	LOAD x19, 19*REGBYTES(sp)
	LOAD x20, 20*REGBYTES(sp)
	LOAD x21, 21*REGBYTES(sp)
	LOAD x22, 22*REGBYTES(sp)
	LOAD x23, 23*REGBYTES(sp)
	LOAD x24, 24*REGBYTES(sp)
	LOAD x25, 25*REGBYTES(sp)
	LOAD x26, 26*REGBYTES(sp)
	LOAD x27, 27*REGBYTES(sp)
	LOAD x28, 28*REGBYTES(sp)
	LOAD x29, 29*REGBYTES(sp)
	LOAD x30, 30*REGBYTES(sp)
	LOAD x31, 31*REGBYTES(sp)

	addi sp, sp, REGBYTES*32
	mret

/* Fills memory blocks */
fill_block:
    sw		a2, 0(a0)
    bgeu	a0, a1, fb_end
    addi	a0, a0, 4
    j		fill_block
fb_end:
    ret
