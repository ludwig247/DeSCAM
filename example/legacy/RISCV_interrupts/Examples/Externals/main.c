/* RISCV includes */
#include "arch/syscalls.h"
#include "arch/clib.h"
#include "irq.h"

static volatile uint32_t * const PLIC_Priority_ADDR_REGISTER = (uint32_t * const)0x0C000000;
static volatile uint32_t * const PLIC_Pending_ADDR_REGISTER = (uint32_t * const)0x0C001000;
static volatile uint32_t * const PLIC_Interrupt_Enables_ADDR = (uint32_t * const)0x0C002000;
static volatile uint32_t * const PLIC_CLAIM_AND_RESPONSE_REGISTER = (uint32_t * const)0x0C200004;

static void set_next_timer_interrupt() {
    *mtimecmp = *mtime + 1000000;
}

unsigned int num_ticks = 0;

void timer_irq_handler() {
    ++num_ticks;
    set_next_timer_interrupt();
    printf("Number of Ticks %d\n",num_ticks);
}

void external_1_handler() {
    printf("external 1 !!!!\n");
    *(PLIC_Pending_ADDR_REGISTER + 0) = 0;
}

void external_2_handler() {
    printf("external 2 !!!!\n");
    *(PLIC_Pending_ADDR_REGISTER + 1) = 0;
}

int main() {
    register_interrupt_handler(1, external_1_handler);
    register_interrupt_handler(2, external_2_handler);
    register_timer_interrupt_handler(timer_irq_handler);
    set_next_timer_interrupt();

    *PLIC_Priority_ADDR_REGISTER = 1;
    *(PLIC_Priority_ADDR_REGISTER + 1) = 2;
    *PLIC_Interrupt_Enables_ADDR = 0x3;
    while(num_ticks < 6){}
	return 0;
}
