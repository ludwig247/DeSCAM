//
// Created by ovsthus on 19.08.19.
//

#ifndef ABSTRACT_BUS_COMPOUND_H
#define ABSTRACT_BUS_COMPOUND_H



#define SLAVE0_START 0x00000000
#define SLAVE0_END   0x00010000
#define SLAVE1_START 0x00010000
#define SLAVE1_END   0x00020000
#define SLAVE2_START 0x00020000
#define SLAVE2_END   0x00030000

#define SLAVE3_START 0x00030000
#define SLAVE3_END   0x00040000
#define SLAVE4_START 0x00040000
#define SLAVE4_END   0x00050000
#define SLAVE5_START 0x00050000
#define SLAVE5_END   0x00060000
#define SLAVE6_START 0x00060000
#define SLAVE6_END   0x00070000
#define SLAVE7_START 0x00070000
#define SLAVE7_END   0x00080400

#define idle 0
#define nonseq 2

#define ok_resp 0
#define error_resp 1

enum trans_type {AHB_READ, AHB_WRITE};
enum mask {MT_W, MT_BU, MT_H, MT_HU, MT_B, MT_X};

struct bus_req_t{
    unsigned int haddr;
    unsigned int hwdata; //data width for now left at max 32
    trans_type hwrite;
    mask hsize;
};

struct bus_resp_t{
    unsigned int hrdata; //data width for now left at max 32
    unsigned int hresp;
};


#endif //ABSTRACT_BUS_COMPOUND_H
