/* RISCV includes */
#include "arch/syscalls.h"
#include "arch/clib.h"
#include "irq.h"

static void set_next_timer_interrupt() {
   *mtimecmp = *mtime + 1000000;
}

unsigned int num_ticks = 0;
unsigned int timer_ticked = 0;

void timer_irq_handler() {
    ++num_ticks;
    set_next_timer_interrupt();
    printf("Number of Ticks %d\n",num_ticks);
}

int main() {
    register_timer_interrupt_handler(timer_irq_handler);
    set_next_timer_interrupt();
    while(num_ticks < 5){}
    asm volatile ("addi t6, %0, 0"::"r"(num_ticks));
	return 0;
}
