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

WARNINGS= -Wall -Wextra -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-align -Wsign-compare \
		-Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wunused

#-----------------------------------------------------------
#-----------------------------------------------------------
# This section hold the configurations of the specific program being compiled
#-----------------------------------------------------------

PROG	= PrintMessage
CRT0	= arch/boot.S

LDFLAGS	 = -Ttext 0x0 -fpic -march=rv32i -mabi=ilp32 -nostartfiles

DEMO_SRC = \
	arch/syscalls.c \
	arch/clib.c \
	main.c

INCLUDES = \
	-I. \
	-I$(RISCV)/include/spike \
	-I./arch

CFLAGS = \
	$(WARNINGS) $(INCLUDES) \
	-fomit-frame-pointer -fno-strict-aliasing -fno-builtin \
	-D__gracefulExit -mcmodel=medany #-fPIC

GCCVER 	= $(shell $(GCC) --version | grep gcc | cut -d" " -f9)


#
# Define all object files.
#
DEMO_OBJ = $(DEMO_SRC:.c=.o)
CRT0_OBJ = $(CRT0:.S=.o)
OBJS = $(CRT0_OBJ) $(DEMO_OBJ)

LDFLAGS	 = -T arch/link.ld -nostartfiles -static -nostdlib
LIBS	 = -L$(CCPATH)/lib/gcc/$(TARGET)/$(GCCVER) \
		   -L$(CCPATH)/$(TARGET)/lib \
		   -lc -lgcc

%.o: %.c
	@echo "    CC $<"
	@$(GCC) -c $(CFLAGS) -o $@ $<

%.o: %.S
	@echo "    CC $<"
	@$(GCC) -c $(CFLAGS) -o $@ $<

all: $(PROG).elf

$(PROG).elf  : $(OBJS) Makefile
	@echo Linking....
	@$(GCC) -o $@ $(LDFLAGS) $(OBJS) $(LIBS)
	@$(OBJDUMP) -S $(PROG).elf > $(PROG).asm
	@$(OBJCOPY) -O binary $(PROG).elf $(PROG).bin
	@hexdump -v -e '1/4 "%08X\n"' $(PROG).bin > $(PROG).hex
	@echo Completed $@

clean :
	@rm -f $(OBJS)
#	@rm -f $(PROG).elf
#	@rm -f $(PROG).asm
	@rm -f $(PROG).bin
#	@rm -f $(PROG).hex

force_true:
	@true

#-------------------------------------------------------------
sim: all
	spike $(PROG).elf