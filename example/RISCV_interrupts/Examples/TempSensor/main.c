/* RISCV includes */
#include "arch/syscalls.h"
#include "arch/clib.h"
#include "irq.h"

static void set_next_timer_interrupt() {
   *mtimecmp = *mtime + 1000000;
}

unsigned int num_ticks = 0;

void timer_irq_handler() {
    ++num_ticks;
    set_next_timer_interrupt();
    printf("Number of Ticks %d\n",num_ticks);
}

void tempSensor_irq_handler() {
    printf("OVERHEAT!!!!\n");
}

int main() {
    register_timer_interrupt_handler(timer_irq_handler);
    set_next_timer_interrupt();
    register_tempSensor_interrupt_handler(tempSensor_irq_handler);
    *Tthreshold = 50;
    while(num_ticks < 6){}
	return 0;
}
