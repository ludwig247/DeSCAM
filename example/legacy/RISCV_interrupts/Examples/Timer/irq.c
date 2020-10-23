#include "irq.h"

#define RISCV_MACHINE_SOFTWARE_INTERRUPT 3
#define RISCV_MACHINE_TIMER_INTERRUPT 7

#define CLINT_BASE 0x2000000

volatile uint64_t* mtime =   (uint64_t*)(CLINT_BASE + 0xbff8);
volatile uint64_t* mtimecmp = (uint64_t*)(CLINT_BASE + 0x4000);

static irq_handler_t timer_irq_handler = 0;

void level_1_interrupt_handler(uint32_t cause) {

	switch (cause & 0xf) {
		case RISCV_MACHINE_TIMER_INTERRUPT: {
		    // Note: the pending timer interrupt bit will be automatically cleared when writing to the *mtimecmp* register of this hart
            if (timer_irq_handler) {
                // let the user registered handler clear the timer interrupt bit
                timer_irq_handler();
            } else {
                // reset the *mtimecmp* register to zero to clear the pending bit
                *mtimecmp = 0;
            }
		    return;
		}
	}
}

void register_timer_interrupt_handler(irq_handler_t fn) {
    timer_irq_handler = fn;
}
