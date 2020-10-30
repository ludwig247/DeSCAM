#ifndef PROJECT_MEMORY_INTERFACES_H
#define PROJECT_MEMORY_INTERFACES_H

#define MEM_DEPTH      0xFFFF
#define MEM_START_ADDR 0x00000000
#define MEM_END_ADDR   MEM_START_ADDR + MEM_DEPTH

enum ME_MaskType {
	MT_X, MT_W, MT_H, MT_B, MT_HU, MT_BU
};

enum ME_AccessType {
	ME_X, ME_RD, ME_WR
};

struct CUtoME_IF {
	ME_AccessType req;
	ME_MaskType mask;
	unsigned int addrIn;
	unsigned int dataIn;
};

struct MEtoCU_IF {
	unsigned int loadedData;
};

#endif //PROJECT_MEMORY_INTERFACES_H

