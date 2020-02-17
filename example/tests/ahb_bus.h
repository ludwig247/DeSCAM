#ifndef GEN_BUS_AHB_MATRIX
#define GEN_BUS_AHB_MATRIX

#include "Interfaces.h"

#include "systemc.h"


#ifndef GEN_BUS_AHB_COMPOUND
#define GEN_BUS_AHB_COMPOUND


#define SLAVE0_START 0x00000000
#define SLAVE0_END   0x00010000
#define SLAVE1_START 0x00010000
#define SLAVE1_END   0x00020000
#define SLAVE2_START 0x00020000
#define SLAVE2_END   0x00030000
#define SLAVE3_START 0x00030000
#define SLAVE3_END   0x00040400


#define idle 0
#define nonseq 2
#define ok_resp 0
#define error_resp 1

enum trans_type {AHB_READ, AHB_WRITE};
enum mask {MT_B, MT_BU, MT_H, MT_HU, MT_W, MT_X};
enum mAgent_sec{idle_phase, request_phase, address_phase, data_phase, response_phase};

struct slv_to_mst{
    unsigned int hresp;
    unsigned int hrdata;
};

struct mst_to_slv{
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
    unsigned int hresp;
    unsigned int hrdata;
};

struct ahb_mst_out_t{
    unsigned int haddr;
    unsigned int hwdata;
    unsigned int hburst;
    unsigned int htrans;
    mask hsize;
    trans_type hwrite;
    unsigned int hprot;
    bool hlock;
};

struct request_comp{
    bool m0_request;
    bool m1_request;
    bool m2_request;
    bool m3_request;
};

#endif


struct ahb_matrix : public sc_module {


    enum phases {idle_state, address_state, data_state};
    phases phase, nextphase;


    blocking_out<bool> update_requests;
    shared_in<request_comp> requests_in;

    blocking_in<slv_to_mst> slave_to_bus0;
    blocking_out<mst_to_slv> bus_to_slave0;
    blocking_in<slv_to_mst> slave_to_bus1;
    blocking_out<mst_to_slv> bus_to_slave1;
    blocking_in<slv_to_mst> slave_to_bus2;
    blocking_out<mst_to_slv> bus_to_slave2;
    blocking_in<slv_to_mst> slave_to_bus3;
    blocking_out<mst_to_slv> bus_to_slave3;

    shared_in<ahb_mst_out_t> mAgent_to_bus0;
    shared_out<ahb_mst_in_t> bus_to_mAgent0;
    ahb_mst_in_t to_mAgent0;
    ahb_mst_out_t payload0;
    shared_in<ahb_mst_out_t> mAgent_to_bus1;
    shared_out<ahb_mst_in_t> bus_to_mAgent1;
    ahb_mst_in_t to_mAgent1;
    ahb_mst_out_t payload1;
    shared_in<ahb_mst_out_t> mAgent_to_bus2;
    shared_out<ahb_mst_in_t> bus_to_mAgent2;
    ahb_mst_in_t to_mAgent2;
    ahb_mst_out_t payload2;
    shared_in<ahb_mst_out_t> mAgent_to_bus3;
    shared_out<ahb_mst_in_t> bus_to_mAgent3;
    ahb_mst_in_t to_mAgent3;
    ahb_mst_out_t payload3;

    request_comp reqs;
    bool sync;

    mst_to_ahb AS_regs;
    mst_to_slv DS_regs;
    slv_to_mst resp;

    SC_HAS_PROCESS(ahb_matrix);
    ahb_matrix(sc_module_name name):
            update_requests("update_requests"),
            requests_in("requests_in"),
            mAgent_to_bus0("mAgent_to_bus0"),
            bus_to_mAgent0("bus_to_mAgent0"),
            mAgent_to_bus1("mAgent_to_bus1"),
            bus_to_mAgent1("bus_to_mAgent1"),
            mAgent_to_bus2("mAgent_to_bus2"),
            bus_to_mAgent2("bus_to_mAgent2"),
            mAgent_to_bus3("mAgent_to_bus3"),
            bus_to_mAgent3("bus_to_mAgent3"),
            bus_to_slave0("bus_to_slave0"),
            slave_to_bus0("slave_to_bus0"),
            bus_to_slave1("bus_to_slave1"),
            slave_to_bus1("slave_to_bus1"),
            bus_to_slave2("bus_to_slave2"),
            slave_to_bus2("slave_to_bus2"),
            bus_to_slave3("bus_to_slave3"),
            slave_to_bus3("slave_to_bus3")
    {
        SC_THREAD(fsm);
    }

    void fsm() {

        AS_regs.hsize = MT_W;
        DS_regs.hsize = MT_W;

        to_mAgent0.hresp = ok_resp;
        to_mAgent0.hrdata = 0;
        to_mAgent0.hgrant = m0_grant;
        bus_to_mAgent0->set(to_mAgent0);
        to_mAgent1.hresp = ok_resp;
        to_mAgent1.hrdata = 0;
        to_mAgent1.hgrant = m1_grant;
        bus_to_mAgent1->set(to_mAgent1);
        to_mAgent2.hresp = ok_resp;
        to_mAgent2.hrdata = 0;
        to_mAgent2.hgrant = m2_grant;
        bus_to_mAgent2->set(to_mAgent2);
        to_mAgent3.hresp = ok_resp;
        to_mAgent3.hrdata = 0;
        to_mAgent3.hgrant = m3_grant;
        bus_to_mAgent3->set(to_mAgent3);

        nextphase = idle_state;

        while (true) {

            phase = nextphase;

            if(phase == idle_state){
                update_requests->try_write(true, sync, "idle_state");
                requests_in->get(reqs);
                mAgent_to_bus0->get(payload0);
                mAgent_to_bus1->get(payload1);
                mAgent_to_bus2->get(payload2);
                mAgent_to_bus3->get(payload3);
                if(sync) {
                    if(reqs.m0_request){
                        AS_regs.haddr = payload0.haddr;
                        AS_regs.hwdata = payload0.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload0.hwrite;
                        AS_regs.hsize = payload0.hsize;
                        nextphase = address_state;
                    }else if(reqs.m1_request){
                        AS_regs.haddr = payload1.haddr;
                        AS_regs.hwdata = payload1.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload1.hwrite;
                        AS_regs.hsize = payload1.hsize;
                        nextphase = address_state;
                    }else if(reqs.m2_request){
                        AS_regs.haddr = payload2.haddr;
                        AS_regs.hwdata = payload2.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload2.hwrite;
                        AS_regs.hsize = payload2.hsize;
                        nextphase = address_state;
                    }else if(reqs.m3_request){
                        AS_regs.haddr = payload3.haddr;
                        AS_regs.hwdata = payload3.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload3.hwrite;
                        AS_regs.hsize = payload3.hsize;
                        nextphase = address_state;
                    }
                }
                to_mAgent0.hresp = ok_resp;
                to_mAgent0.hrdata = 0;
                to_mAgent0.hgrant = m0_grant;
                bus_to_mAgent0->set(to_mAgent0);
                to_mAgent1.hresp = ok_resp;
                to_mAgent1.hrdata = 0;
                to_mAgent1.hgrant = m1_grant;
                bus_to_mAgent1->set(to_mAgent1);
                to_mAgent2.hresp = ok_resp;
                to_mAgent2.hrdata = 0;
                to_mAgent2.hgrant = m2_grant;
                bus_to_mAgent2->set(to_mAgent2);
                to_mAgent3.hresp = ok_resp;
                to_mAgent3.hrdata = 0;
                to_mAgent3.hgrant = m3_grant;
                bus_to_mAgent3->set(to_mAgent3);
            } // end idle state


            if(phase == address_state){
                update_requests->try_write(true, sync, "address_state");
                requests_in->get(reqs);
                mAgent_to_bus0->get(payload0);
                mAgent_to_bus1->get(payload1);
                mAgent_to_bus2->get(payload2);
                mAgent_to_bus3->get(payload3);

                DS_regs.haddr = AS_regs.haddr;
                DS_regs.hwdata = AS_regs.hwdata;
                DS_regs.hwrite = AS_regs.hwrite;
                DS_regs.hsize = AS_regs.hsize;

                if(reqs.m0_request){
                    AS_regs.haddr = payload0.haddr;
                    AS_regs.hwdata = payload0.hwdata;
                    AS_regs.htrans = nonseq;
                    AS_regs.hwrite = payload0.hwrite;
                    AS_regs.hsize = payload0.hsize;
                } else if(reqs.m1_request){
                    AS_regs.haddr = payload1.haddr;
                    AS_regs.hwdata = payload1.hwdata;
                    AS_regs.htrans = nonseq;
                    AS_regs.hwrite = payload1.hwrite;
                    AS_regs.hsize = payload1.hsize;
                } else if(reqs.m2_request){
                    AS_regs.haddr = payload2.haddr;
                    AS_regs.hwdata = payload2.hwdata;
                    AS_regs.htrans = nonseq;
                    AS_regs.hwrite = payload2.hwrite;
                    AS_regs.hsize = payload2.hsize;
                } else if(reqs.m3_request){
                    AS_regs.haddr = payload3.haddr;
                    AS_regs.hwdata = payload3.hwdata;
                    AS_regs.htrans = nonseq;
                    AS_regs.hwrite = payload3.hwrite;
                    AS_regs.hsize = payload3.hsize;
                }else{
                    AS_regs.haddr = 0;
                    AS_regs.hwdata = 0;
                    AS_regs.htrans = idle;
                    AS_regs.hwrite = AHB_READ;
                    AS_regs.hsize = MT_W;
                }

                to_mAgent0.hresp = ok_resp;
                to_mAgent0.hrdata = 0;
                to_mAgent0.hgrant = m0_grant;
                bus_to_mAgent0->set(to_mAgent0);
                to_mAgent1.hresp = ok_resp;
                to_mAgent1.hrdata = 0;
                to_mAgent1.hgrant = m1_grant;
                bus_to_mAgent1->set(to_mAgent1);
                to_mAgent2.hresp = ok_resp;
                to_mAgent2.hrdata = 0;
                to_mAgent2.hgrant = m2_grant;
                bus_to_mAgent2->set(to_mAgent2);
                to_mAgent3.hresp = ok_resp;
                to_mAgent3.hrdata = 0;
                to_mAgent3.hgrant = m3_grant;
                bus_to_mAgent3->set(to_mAgent3);
                nextphase = data_state;
            } //end address_state



            if(phase == data_state){
                if(DS_regs.haddr >= SLAVE0_START && DS_regs.haddr < SLAVE0_END){
                    insert_state("slave_agent0_start");
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    bus_to_slave0->write(DS_regs, "slave_agent0_writes_out");
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    slave_to_bus0->read(resp, "slave_agent0_reads_back");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    insert_state("slave_agent0_end");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                }else if(DS_regs.haddr >= SLAVE1_START && DS_regs.haddr < SLAVE1_END){
                    insert_state("slave_agent1_start");
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    DS_regs.haddr = DS_regs.haddr - SLAVE1_START;
                    bus_to_slave1->write(DS_regs, "slave_agent1_writes_out");
                    DS_regs.haddr = DS_regs.haddr + SLAVE1_START;
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    slave_to_bus1->read(resp, "slave_agent1_reads_back");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    insert_state("slave_agent1_end");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                }else if(DS_regs.haddr >= SLAVE2_START && DS_regs.haddr < SLAVE2_END){
                    insert_state("slave_agent2_start");
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    DS_regs.haddr = DS_regs.haddr - SLAVE2_START;
                    bus_to_slave2->write(DS_regs, "slave_agent2_writes_out");
                    DS_regs.haddr = DS_regs.haddr + SLAVE2_START;
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    slave_to_bus2->read(resp, "slave_agent2_reads_back");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    insert_state("slave_agent2_end");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                }else if(DS_regs.haddr >= SLAVE3_START && DS_regs.haddr < SLAVE3_END){
                    insert_state("slave_agent3_start");
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    DS_regs.haddr = DS_regs.haddr - SLAVE3_START;
                    bus_to_slave3->write(DS_regs, "slave_agent3_writes_out");
                    DS_regs.haddr = DS_regs.haddr + SLAVE3_START;
                    to_mAgent0.hresp = ok_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = ok_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = ok_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = ok_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    slave_to_bus3->read(resp, "slave_agent3_reads_back");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    insert_state("slave_agent3_end");
                    to_mAgent0.hresp = resp.hresp;
                    to_mAgent0.hrdata = resp.hrdata;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = resp.hresp;
                    to_mAgent1.hrdata = resp.hrdata;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = resp.hresp;
                    to_mAgent2.hrdata = resp.hrdata;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = resp.hresp;
                    to_mAgent3.hrdata = resp.hrdata;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                }else{
                    to_mAgent0.hresp = error_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = error_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = error_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = error_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                    insert_state("default_slave");
                    to_mAgent0.hresp = error_resp;
                    to_mAgent0.hrdata = 0;
                    to_mAgent0.hgrant = m0_grant;
                    bus_to_mAgent0->set(to_mAgent0);
                    to_mAgent1.hresp = error_resp;
                    to_mAgent1.hrdata = 0;
                    to_mAgent1.hgrant = m1_grant;
                    bus_to_mAgent1->set(to_mAgent1);
                    to_mAgent2.hresp = error_resp;
                    to_mAgent2.hrdata = 0;
                    to_mAgent2.hgrant = m2_grant;
                    bus_to_mAgent2->set(to_mAgent2);
                    to_mAgent3.hresp = error_resp;
                    to_mAgent3.hrdata = 0;
                    to_mAgent3.hgrant = m3_grant;
                    bus_to_mAgent3->set(to_mAgent3);
                }

                update_requests->try_write(true, sync, "data_state");
                requests_in->get(reqs);
                mAgent_to_bus0->get(payload0);
                mAgent_to_bus1->get(payload1);
                mAgent_to_bus2->get(payload2);
                mAgent_to_bus3->get(payload3);
                resp.hresp = 0;
                resp.hrdata = 0;

                to_mAgent0.hresp = ok_resp;
                to_mAgent0.hrdata = 0;
                to_mAgent0.hgrant = m0_grant;
                bus_to_mAgent0->set(to_mAgent0);
                to_mAgent1.hresp = ok_resp;
                to_mAgent1.hrdata = 0;
                to_mAgent1.hgrant = m1_grant;
                bus_to_mAgent1->set(to_mAgent1);
                to_mAgent2.hresp = ok_resp;
                to_mAgent2.hrdata = 0;
                to_mAgent2.hgrant = m2_grant;
                bus_to_mAgent2->set(to_mAgent2);
                to_mAgent3.hresp = ok_resp;
                to_mAgent3.hrdata = 0;
                to_mAgent3.hgrant = m3_grant;
                bus_to_mAgent3->set(to_mAgent3);

                if(AS_regs.htrans == nonseq){
                    DS_regs.haddr = AS_regs.haddr;
                    DS_regs.hwdata = AS_regs.hwdata;
                    DS_regs.hwrite = AS_regs.hwrite;
                    DS_regs.hsize = AS_regs.hsize;
                    nextphase = data_state;
                    if(reqs.m0_request){
                        AS_regs.haddr = payload0.haddr;
                        AS_regs.hwdata = payload0.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload0.hwrite;
                        AS_regs.hsize = payload0.hsize;
                    }else if(reqs.m1_request){
                        AS_regs.haddr = payload1.haddr;
                        AS_regs.hwdata = payload1.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload1.hwrite;
                        AS_regs.hsize = payload1.hsize;
                    }else if(reqs.m2_request){
                        AS_regs.haddr = payload2.haddr;
                        AS_regs.hwdata = payload2.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload2.hwrite;
                        AS_regs.hsize = payload2.hsize;
                    }else if(reqs.m3_request){
                        AS_regs.haddr = payload3.haddr;
                        AS_regs.hwdata = payload3.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload3.hwrite;
                        AS_regs.hsize = payload3.hsize;
                    }else{
                        AS_regs.haddr = 0;
                        AS_regs.hwdata = 0;
                        AS_regs.htrans = idle;
                        AS_regs.hwrite = AHB_READ;
                        AS_regs.hsize = MT_W;
                    }
                } else{
                    DS_regs.haddr = 0;
                    DS_regs.hwdata = 0;
                    DS_regs.hwrite = AHB_READ;
                    DS_regs.hsize = MT_W;
                    nextphase = address_state;
                    if(reqs.m0_request){
                        AS_regs.haddr = payload0.haddr;
                        AS_regs.hwdata = payload0.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload0.hwrite;
                        AS_regs.hsize = payload0.hsize;
                    }else if(reqs.m1_request){
                        AS_regs.haddr = payload1.haddr;
                        AS_regs.hwdata = payload1.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload1.hwrite;
                        AS_regs.hsize = payload1.hsize;
                    }else if(reqs.m2_request){
                        AS_regs.haddr = payload2.haddr;
                        AS_regs.hwdata = payload2.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload2.hwrite;
                        AS_regs.hsize = payload2.hsize;
                    }else if(reqs.m3_request){
                        AS_regs.haddr = payload3.haddr;
                        AS_regs.hwdata = payload3.hwdata;
                        AS_regs.htrans = nonseq;
                        AS_regs.hwrite = payload3.hwrite;
                        AS_regs.hsize = payload3.hsize;
                    }else{
                        AS_regs.haddr = 0;
                        AS_regs.hwdata = 0;
                        AS_regs.htrans = idle;
                        AS_regs.hwrite = AHB_READ;
                        AS_regs.hsize = MT_W;
                        nextphase = idle_state;
                    }
                }
            } //end data state


        } //end while
    } //end fsm
}; //end module
#endif