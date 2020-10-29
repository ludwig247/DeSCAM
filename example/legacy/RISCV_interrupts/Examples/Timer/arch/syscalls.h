#ifndef SYSCALLS_H
#define SYSCALLS_H

#define SYS_write 64
#define SYS_exit 93
#define SYS_timer 1234

long syscall(long num, long arg0, long arg1, long arg2);

void vSyscallInit(void);
unsigned long ulSyscallTrap(long cause, long epc, long regs[32]);

#endif /* SYSCALLS_H */
