#-----------------------------------------------------------
# This section hold the configurations of the toolchain used for compiling
#-----------------------------------------------------------
#RISCV_XLEN ?= 32
#RISCV_LIB  ?= elf
#RISCV ?= /opt/riscv32i
#RISCV ?= /import/public/Linux/riscv
CCPATH	= $(RISCV)
TARGET=$(CCPATH)/bin/riscv${RISCV_XLEN}-unknown-${RISCV_LIB}

GCC		= $(TARGET)-gcc
OBJDUMP	= $(TARGET)-objdump
OBJCOPY	= $(TARGET)-objcopy

#-----------------------------------------------------------
# This section hold the configurations of the specific program being compiled
#-----------------------------------------------------------

PROG	= Fibonacci
LDFLAGS	 = -Ttext 0x0 -fpic -march=rv32i -mabi=ilp32 -nostartfiles
OBJS = bootstrap.S main.cpp

#-----------------------------------------------------------
all: $(PROG).elf

$(PROG).elf  : $(OBJS) Makefile
	@echo Linking....
	@$(GCC) -o $@ $(LDFLAGS) $(OBJS) $(LIBS)
	@$(OBJDUMP) -S $(PROG).elf > $(PROG).asm
	@$(OBJCOPY) -O binary $(PROG).elf $(PROG).bin
	@hexdump -v -e '1/4 "%08X\n"' $(PROG).bin > $(PROG).hex
	@echo Completed $@

clean :
	@rm -f $(PROG).elf
	@rm -f $(PROG).asm
	@rm -f $(PROG).bin
	@rm -f $(PROG).hex

force_true:
	@true

#-------------------------------------------------------------
sim: all
	spike $(PROG).elf
