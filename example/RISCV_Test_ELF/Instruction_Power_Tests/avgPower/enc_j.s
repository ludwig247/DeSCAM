
# @author :	Dino Mehmedagić
# @name   : 	enc_j.s
# @purpose: 	Test for unconditional jump with an attempt to average out the power dependency on data

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
	
ADD0x000:
	jal x0,ADD0x1F8			# 0 switches	
ADD0x004:
	jal x2,ADD0x00C			# x2 = 0x008 -> 1 switch
ADD0x008:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x00C:
	jal x3,ADD0x01C			# x3 = 0x010 -> 1 switch
ADD0x010:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x014:
	jal x10,ADD0x024		# x10 = 0x018 -> 2 switches
ADD0x018:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x01C:
	jal x4,ADD0x03C			# x4 = 0x20 -> 1 switch
ADD0x020:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x024:
	jal x11,ADD0x02C		# x11 = 0x028 -> 2 switches
ADD0x028:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x02C:
	jal x12,ADD0x044		# x12 = 0x030 -> 2 switches
ADD0x030:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x034:
	jal x20,ADD0x054		# x20 = 0x038 -> 3 switches
ADD0x038:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x03C:
	jal x5,ADD0x1F0			# x5 = 0x040 -> 1 switch
ADD0x040:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x044:
	jal x13,ADD0x04C		# x13 = 0x48 -> 2 switches
ADD0x048:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x04C:
	jal x14,ADD0x1E0		# x14 = 0x50 -> 2 switches
ADD0x050:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x054:
	jal x21,ADD0x060		# x21 = 0x58 -> 3 switches
ADD0x058:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x05C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x060:
	jal x22,ADD0x06C		# x22 = 0x64 -> 3 switches
ADD0x064:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x068:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x06C:
	jal x23,ADD0x088		# x23 = 0x70 -> 3 switches
ADD0x070:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x074:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x078:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x07C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x080:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x084:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x088:
	jal x24,ADD0x090			# x24 = 0x8C -> 3 switches
ADD0x08C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x090:
	jal x25,ADD0x1C0		# x25 = 0x94 -> 3 switches
ADD0x094:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x098:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x09C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0A0:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0A4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0A8:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0AC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0B0:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0B4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0B8:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0BC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0C0:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0C4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0C8:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0CC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0D0:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0D4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0D8:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0DC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0E0:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0E4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0E8:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0EC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0F0:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0F4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0F8:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x0FC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x100:
	ebreak
ADD0x104:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x108:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x10C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x110:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x114:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x118:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x11C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x120:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x124:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x128:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x12C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x130:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x134:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x138:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x13C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x140:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x144:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x148:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x14C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x150:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x154:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x158:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x15C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x160:
	jal x31,ADD0x100		# x31 = 0x164 -> 4 switches
ADD0x164:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x168:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x16C:
	jal x30,ADD0x160		# x30 = 0x170 -> 4 switches
ADD0x170:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x174:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x178:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x17C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x180:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x184:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x188:
	jal x29,ADD0x16C		# x29 = 0x18C -> 4 switches
ADD0x18C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x190:
	jal x28,ADD0x188		# x28 = 0x194 -> 4 switches
ADD0x194:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x198:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x19C:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1A0:
	jal x27,ADD0x190		# x27 = 0x1A4 -> 4 switches
ADD0x1A4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1A8:
	jal x19,ADD0x034		# x19 = 0x1AC -> 5 switches
ADD0x1AC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1B0:
	jal x18,ADD0x1A8		# x18 = 0x1B4 -> 5 switches
ADD0x1B4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1B8:
	jal x9,ADD0x014			# x9 = 0x1BC -> 6 switches
ADD0x1BC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1C0:
	jal x26,ADD0x1A0		# x26 = 0x1C4 -> 4 switches
ADD0x1C4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1C8:
	jal x17,ADD0x1B0		# x17 = 0x1CC -> 5 switches
ADD0x1CC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1D0:
	jal x16,ADD0x1C8		# x16 = 0x1D4 -> 5 switches
ADD0x1D4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1D8:
	jal x8,ADD0x1B8			# x8 = 0x1DC -> 6 switches
ADD0x1DC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1E0:
	jal x15,ADD0x1D0		# x15 = 0x1E4 -> 5 switches
ADD0x1E4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1E8:
	jal x7,ADD0x1D8			# x7 = 0x1EC -> 6 switches
ADD0x1EC:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1F0:
	jal x6,ADD0x1E8 		# x6 = 0x1F4 -> 6 switches
ADD0x1F4:
	jal x2,ADD0x00C		# dummy switch; never reached
ADD0x1F8:
	jal x1,ADD0x004			# x1 = 0x1FC -> 7 switches
ADD0x1FC:
	jal x2,ADD0x00C		# dummy switch; never reached
