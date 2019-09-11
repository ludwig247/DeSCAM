//
// Created by lukadejanovic on 27.3.18..
//

#ifndef PROJECT_TLM_BRIDGE_H
#define PROJECT_TLM_BRIDGE_H

#include <tlm.h>
#include "systemc.h"
#include "Interfaces.h"
#include "../../RISCV_commons/Memory_Interfaces.h"
#include "./../RISCV_commons/Utilities.h"
#include "./../RISCV_commons/Defines.h"


class TLM_bridge : public sc_module, tlm::tlm_bw_transport_if<> {
public:

    SC_HAS_PROCESS(TLM_bridge);

    tlm::tlm_initiator_socket<> bridgeSocket;

    //Ports
    blocking_in<CUtoME_IF> COtoBR_port;  // read_instruction/load/store
    blocking_out<MEtoCU_IF> BRtoCO_port;    // store/load done

    // Dummy method:
    void invalidate_direct_mem_ptr(sc_dt::uint64 start_range,
                                   sc_dt::uint64 end_range) {
        SC_REPORT_FATAL(this->name(), "@TLM_bridge: invalidate_direct_mem_ptr not implemented");
    }

    // Dummy method:
    tlm::tlm_sync_enum nb_transport_bw(
            tlm::tlm_generic_payload &trans,
            tlm::tlm_phase &phase,
            sc_time &delay) {
        SC_REPORT_FATAL(this->name(), "@TLM_bridge: nb_transport_bw is not implemented");
        return tlm::TLM_ACCEPTED;
    }

    TLM_bridge(sc_module_name name) :
            bridgeSocket("bridgeSocket"),
            COtoBR_port("COtoBR_port"),
            BRtoCO_port("BRtoCO_port"),
            delay(sc_time(0, SC_NS))
    {
        bridgeSocket.bind(*this);
        SC_THREAD(run);
        trans.set_streaming_width(1);
        trans.set_data_ptr(data);
    }

    // SCAM interface data
    CUtoME_IF COtoBR_data;
    MEtoCU_IF BRtoCO_data;

    // TLM interface data
    unsigned char data[4];
    tlm::tlm_generic_payload trans;
    sc_time delay;

    // thread
    void run();
};


void TLM_bridge::run() {

    while (true) {

        // Core requests data from memory
        COtoBR_port->read(COtoBR_data);

        // set TLM data
        trans.set_address(COtoBR_data.addrIn);
        trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
        delay = sc_time(0, SC_NS);

        if (COtoBR_data.req != ME_X) {

            if (COtoBR_data.req == ME_RD) {

                trans.set_command(tlm::TLM_READ_COMMAND);

                // set TLM data length
                if (COtoBR_data.mask != MT_X) {

                    if (COtoBR_data.mask == MT_B || COtoBR_data.mask == MT_BU) {
                        trans.set_data_length(1);
                    } else if (COtoBR_data.mask == MT_H || COtoBR_data.mask == MT_HU) {
                        trans.set_data_length(2);
                    } else if (COtoBR_data.mask == MT_W) {
                        trans.set_data_length(4);
                    } else {
                        cout << "@TLM_bridge: Read memory mask not defined!" << endl;
                        exit(0);
                    }
                }
            } else if (COtoBR_data.req == ME_WR) {

                trans.set_command(tlm::TLM_WRITE_COMMAND);

                // set TLM data length
                if (COtoBR_data.mask != MT_X) {

                    if (COtoBR_data.mask == MT_B) {
                        trans.set_data_length(1);
                        data[0] = COtoBR_data.dataIn;
                    } else if (COtoBR_data.mask == MT_H) {
                        trans.set_data_length(2);
                        data[0] = COtoBR_data.dataIn;
                        data[1] = COtoBR_data.dataIn >> 8;
                    } else if (COtoBR_data.mask == MT_W) {
                        trans.set_data_length(4);
                        data[0] = COtoBR_data.dataIn;
                        data[1] = COtoBR_data.dataIn >> 8;
                        data[2] = COtoBR_data.dataIn >> 16;
                        data[3] = COtoBR_data.dataIn >> 24;
                    } else if (COtoBR_data.mask == MT_BU || COtoBR_data.mask == MT_HU) {

                        throw std::logic_error(std::string("@TLM_bridge: Store mask illegal!"));

                    } else {
                        cout << "@TLM_bridge: Store mask not defined!" << endl;
                        exit(0);
                    }
                }
            } else {

                throw std::logic_error(std::string("@TLM_bridge: Undefined memory's req value"));
            }
        }

        // Access TLM memory (blocking transport)
        bridgeSocket->b_transport(trans, delay);
        wait(delay);

        // check response for errors
        if (trans.is_response_error()) {
            SC_REPORT_FATAL(name(), "@TLM_bridge: Response error from b_transport");
        }

        BRtoCO_data.loadedData = 0;

        // set SCAM data
        if (COtoBR_data.req != ME_X) {

            if (COtoBR_data.req == ME_RD) {

                if (COtoBR_data.mask != MT_X) {

                    if (COtoBR_data.mask == MT_B) {

                        BRtoCO_data.loadedData = data[0];

                        // sign extend
                        if (Sub(BRtoCO_data.loadedData, 7, 7) == 1) {
                            BRtoCO_data.loadedData = Cat(Fill(24), 24, BRtoCO_data.loadedData, 8);
                        }

                    } else if (COtoBR_data.mask == MT_H) {

                        BRtoCO_data.loadedData = data[0] | (data[1] << 8);

                        // sign extend
                        if (Sub(BRtoCO_data.loadedData, 15, 15) == 1) {
                            BRtoCO_data.loadedData = Cat(Fill(16), 16, BRtoCO_data.loadedData, 16);
                        }

                    } else if (COtoBR_data.mask == MT_W) {

                        BRtoCO_data.loadedData = data[0] | data[1] << 8 | data[2] << 16 | data[3] << 24;

                    } else if (COtoBR_data.mask == MT_BU) {

                        // read 8 bits, zero extend implicit
                        BRtoCO_data.loadedData = data[0];

                    } else if (COtoBR_data.mask == MT_HU) {

                        // read 16 bits, zero extend implicit
                        BRtoCO_data.loadedData = data[0] | data[1] << 8;

                    } else {

                        cout << "@TLM_bridge: Load mask illegal!" << endl;
                        exit(0);
                    }
                }
            } else if (COtoBR_data.req == ME_WR) {

                BRtoCO_data.loadedData = 1; // store success
            } else {

                throw std::logic_error(std::string("@TLM_bridge: Undefined memory's req value"));
            }
        }
        // Give the requested data to core
        BRtoCO_port->write(BRtoCO_data);
    }
}


#endif //PROJECT_TLM_BRIDGE_H