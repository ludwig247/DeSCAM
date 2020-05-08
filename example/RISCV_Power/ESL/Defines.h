#ifndef PROJECT_DEFINES_H
#define PROJECT_DEFINES_H


#define MEM_DEPTH 512
#define START_ADDR 0x0


#define RD_MSB  11
#define RD_LSB  7
#define RS1_MSB 19
#define RS1_LSB 15
#define RS2_MSB 24
#define RS2_LSB 20

#define Fill(amt) ((1 << amt) - 1)
#define Cat(a, sz1, b, sz2) (((Fill(sz1) << sz2) & (a << sz2)) | (Fill(sz2) & b))
#define Sub(a, i1, i2) ((a >> i2) & Fill(i1 - i2 + 1))


#endif // PROJECT_DEFINES_H