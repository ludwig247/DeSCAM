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
#define SLAVE2_END   0x00030400

#define idle 0
#define nonseq 2

#define ok_resp 0
#define error_resp 1



enum trans_type {AHB_READ, AHB_WRITE};
enum mask {MT_B, MT_BU, MT_H, MT_HU, MT_W, MT_X};
enum mAgent_sec{idle_phase, request_phase, address_phase, data_phase, response_phase};

struct bus_req_t{
    unsigned int haddr;
    unsigned int hwdata; //data width for now left at max 32
    trans_type hwrite;
    mask hsize;
};

struct slv_to_mst{
 //  unsigned int hgrant;
 //unsigned int hready;
   unsigned int hresp;
   unsigned int hrdata;
};

struct ahb_to_slv{
    unsigned int haddr;
    unsigned int hwdata;
    mask hsize;
    trans_type hwrite;
};

struct mst_to_ahb{
    unsigned int haddr;
    unsigned int hwdata;
    unsigned int htrans;
    mask hsize;
    trans_type hwrite;
};

enum grant{m0_grant, m1_grant, m2_grant, m3_grant};

struct ahb_mst_in_t{
      grant hgrant;
  //  bool hready;
    unsigned int hresp;
    unsigned int hrdata;
};

struct ahb_mst_out_t  {
    unsigned int haddr;
    unsigned int hwdata;
    unsigned int hburst;
    unsigned int htrans;
    mask hsize;
    trans_type hwrite;
       unsigned int hprot;
       bool hlock;
};

struct request_comp {
    bool m0_request;
    bool m1_request;
    bool m2_request;
    bool m3_request;
};


struct compound_in{
    bool m0_request;
    bool m1_request;
    unsigned int master0_haddr;
    unsigned int master0_hwdata; //data width for now left at max 32
    trans_type master0_hwrite;
    mask master0_hsize;
    unsigned int master0_hprot;
    unsigned int master0_hburst;
    bool master0_hlock;
    unsigned int master0_htrans;

    unsigned int master1_haddr;
    unsigned int master1_hwdata; //data width for now left at max 32
    trans_type master1_hwrite;
    mask master1_hsize;
    unsigned int master1_hprot;
    unsigned int master1_hburst;
    bool master1_hlock;
    unsigned int master1_htrans;

};




struct compound_out{
    unsigned int master0_hrdata;
 //   bool master0_hready;
    grant master0_hgrant;
    unsigned int master0_hresp;

    unsigned int master1_hrdata;
//    bool master1_hready;
    grant master1_hgrant;
    unsigned int master1_hresp;

    unsigned int master2_hrdata;
//    bool master1_hready;
    grant master2_hgrant;
    unsigned int master2_hresp;

    unsigned int master3_hrdata;
//    bool master1_hready;
    grant master3_hgrant;
    unsigned int master3_hresp;
};




//enum mWrp_sec {idle_phase_, req_phase_, addr_, data_, error_phase_, resp_};
//
//struct system_state{
//    mWrp_sec master0_stage;
//    mWrp_sec master1_stage;
//};


struct bus_resp_t{
    unsigned int hrdata; //data width for now left at max 32
    unsigned int hresp;
};




#endif //ABSTRACT_BUS_COMPOUND_H
