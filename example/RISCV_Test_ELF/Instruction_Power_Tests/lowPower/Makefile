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
 	enc_r_low.s \
 	enc_b_low.s \
 	enc_s_low.s \
	enc_u_low.s \
 	enc_j_low.s \
 	enc_i_i_low.s \
 	enc_i_l_low.s \
 	enc_i_j_low.s \
	power_test_1.s  \
	power_test_2.s \
	power_test_3.s \
	power_test_4.s \
	power_test_5.s \
	power_test_6.s \
	power_test_7.s \
	power_test_8.s \
	power_test_9.s \
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
