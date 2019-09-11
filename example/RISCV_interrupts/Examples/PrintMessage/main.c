/* RISCV includes */
#include "arch/syscalls.h"
#include "arch/clib.h"


int main() {
    printf("This Test only prints this message.\n");
    printf("BTW Paulius, keep holding on\n");
    asm volatile ("addi t5, %0, 0"::"r"(5));
    asm volatile ("addi t6, %0, 0"::"r"(6));

    return 0;
}