#-----------------------------------------------------------
# This section hold the configurations of the toolchain used for compiling
#-----------------------------------------------------------
RISCV_XLEN ?= 32
RISCV_LIB  ?= elf
RISCV ?= /opt/riscv32i
#RISCV ?= /import/public/Linux/riscv
CCPATH	= $(RISCV)
TARGET=$(CCPATH)/bin/riscv${RISCV_XLEN}-unknown-${RISCV_LIB}

GCC		= $(TARGET)-gcc
OBJDUMP	= $(TARGET)-objdump
OBJCOPY	= $(TARGET)-objcopy

#-----------------------------------------------------------
# This section hold the configurations of the specific programs being compiled
#-----------------------------------------------------------

LDFLAGS	 = -Ttext 0x0 -fpic -march=rv32i -mabi=ilp32 -nostartfiles

PROG_ASM = \
 	enc_r.s \
 	enc_b.s \
 	enc_s.s \
	enc_u.s \
 	enc_j.s \
 	enc_i_l.s \
 	enc_i_j.s \
	baseline.s

#
# Define all object files.
#
OBJS = $(PROG_ASM:.s=)

#-----------------------------------------------------------
%: %.s
	@echo " Create elf for $<"
	@$(GCC) $(LDFLAGS) -o $@.elf $<
	@$(OBJDUMP) -S $@.elf > $@.asm
	@$(OBJCOPY) -O binary $@.elf $@.bin
	@hexdump -v -e '1/4 "%08X\n"' $@.bin > $@.hex

all: $(OBJS) Makefile
	@echo Completed

clean :
	@rm -f *.elf
	@rm -f *.asm
	@rm -f *.bin
	@rm -f *.hex

force_true:
	@true
