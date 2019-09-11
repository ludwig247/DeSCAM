//#include "arch/syscalls.h"
//#include "arch/clib.h"
#include "stdint.h"

#define RISCV_MACHINE_SOFTWARE_INTERRUPT 3
#define RISCV_MACHINE_TIMER_INTERRUPT 7

#define CLINT_BASE 0x2000000

volatile uint64_t* mtime =   (uint64_t*)(CLINT_BASE + 0xbff8);
volatile uint64_t* mtimecmp = (uint64_t*)(CLINT_BASE + 0x4000);

unsigned int num_ticks = 0;
void timer_irq_handler(void);

void level_1_interrupt_handler(uint32_t cause) {
	switch (cause & 0xf) {
		case RISCV_MACHINE_TIMER_INTERRUPT: {
			timer_irq_handler();
			break;
		}
	}
    return;
}

static void set_next_timer_interrupt() {
   *mtimecmp = *mtime + 100;
}

void timer_irq_handler() {
    ++num_ticks;
    set_next_timer_interrupt();
}

int main() {
    set_next_timer_interrupt();
    while(num_ticks < 5){}
	return 0;
}
