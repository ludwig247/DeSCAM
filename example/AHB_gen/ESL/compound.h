//
// Created by ovsthus on 19.08.19.
//

#ifndef ABSTRACT_BUS_COMPOUND_H
#define ABSTRACT_BUS_COMPOUND_H



#define slave0_start 0x00000000
#define slave0_end   0x00010000
#define slave1_start 0x10000000
#define slave1_end   0x10010000
#define slave2_start 0x20000000
#define slave2_end   0x20010000





enum trans_type {AHB_READ, AHB_WRITE};
enum mask {MT_B, MT_BU, MT_H, MT_HU, MT_W, MT_X};


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
