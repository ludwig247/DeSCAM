//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//
/**
 * \class: scoreboard
 *  - The scoreboard performs end-to-end checking by comparing expected and processed transactions
 *      Remark: in our implementation we will be comparing the expected value (coming from ISA as golden model) with the processed value (coming form DUT)
 *  - These transactions are retrieved by dedicated subscribers or listeners, which implement the "write" method of the analysis ports of each monitor, to which
 *      these subscribers are connected.
 *      Remark: one subscriber connected to Active-Agent's-Driver's analysis port representing the "fromMemory" connection, and one subscriber connected to the
 *              Passive-Agent's-Monitor's analysis port representing the "toMemory" connection.
 *  - A scoreboard may contain a predictor, which acts as reference or golden model. Alternatively, the scoreboard may contain an algorithm to calculate the expected
 *      transaction. Remark: our scoreboard will have ISA as a golden model.
 */
#ifndef UVMSYSTEMC_SCOREBOARD_H
#define UVMSYSTEMC_SCOREBOARD_H

#include <uvm>
#include "subscriber_fromMemory.h"
#include "subscriber_toMemory.h"
#include "Interfaces.h"
#include "Golden_Reference/GOLDEN_Core.h"
//#include "../Golden_Reference/dut.h"
using namespace uvm;

class scoreboard : public uvm_scoreboard {
public:
    uvm_analysis_export<vip_trans_fromMemory> listener_fromMemory; /// Exports used to connect to the subscribers
    uvm_analysis_export<vip_trans_toMemory> listener_toMemory;
    subscriber_fromMemory *subscr_fromMemory;
    subscriber_toMemory *subscr_toMemory;
    // Remark: instance of ISA need to be added to the scoreboard
    G_Core goldenReference;
//    golden_dut *goldenReference;
    // Channel instantiation
    Blocking<CUtoME_IF> toMemory_channel;//("toMemory_channel");
    Blocking<MEtoCP_IF> fromMemory_channel;//("fromMemory_channel");
    // Variables for communicating with goldenReference
    CUtoME_IF toMemory_data;
    MEtoCP_IF fromMemory_data;
    vector<unsigned int> goldenReference_mem;
    vector<unsigned int> dut_mem;
//    unsigned int goldenReference_reg[31];
//    unsigned int dut_reg[31];
    bool store_op = false;

    scoreboard(uvm_component_name name) : uvm_scoreboard(name),
                                            toMemory_channel("toMemory_channel"),
                                            fromMemory_channel("fromMemory_channel"),
                                            goldenReference("goldenModel"){
        //Port binding:
        goldenReference.COtoME_port(toMemory_channel);
        goldenReference.MEtoCO_port(fromMemory_channel);
    }

    UVM_COMPONENT_UTILS(scoreboard)

    void build_phase(uvm_phase &phase) {
        uvm_scoreboard::build_phase(phase);

        uvm_config_db<uvm_object*>::set(this, "subscr_fromMemory", "sb", this); /// a trick for subscriber to have a reference to it's containing scoreboard
        uvm_config_db<uvm_object*>::set(this, "subscr_toMemory", "sb", this);
        subscr_fromMemory = subscriber_fromMemory::type_id::create("subscr_fromMemory", this);
        assert(subscr_fromMemory);
        subscr_toMemory = subscriber_toMemory::type_id::create("subscr_toMemory", this);
        assert(subscr_toMemory);
    }

    void connect_phase(uvm_phase &phase) {
        listener_fromMemory(subscr_fromMemory->analysis_export);
        listener_toMemory(subscr_toMemory->analysis_export);
    }

//    void start_of_simulation_phase( uvm_phase& phase) {
//        //// remark reading the initial value of the port to avoid mistaking it with official transactions
//        toMemory_channel.read(toMemory_data);
//        std::cout << "+++++++++ special +++++++++ request: 0x" << std::hex << toMemory_data.addrIn << " Data: " << toMemory_data.dataIn << " AccessType: "<<toMemory_data.req << std::endl;
//        std::cout << "\t\t\t\t\t\t\t\t\t\t\t-------- special -------- reply: " << std::hex << fromMemory_data.loadedData << std::endl;
//        fromMemory_channel.write(fromMemory_data);
//    }

    /// Via the subscribers the expected and the processed transactions become available which are used for the actual checking
    void write_listener_fromMemory(const vip_trans_fromMemory &t) {
//        std::cout << "\t\t\t\t\t\t\t\t\t\t\t-------- fromMemory -------- reply: " << std::hex << t.fromMemory.loadedData << std::endl;

        fromMemory_data = t.fromMemory;
        fromMemory_channel.write(fromMemory_data);
//        if( fromMemory_data.loadedData == 0x00100073 ) {
//            std::cout<<"END OF THE STORY -*-*-*-*-*-*-*-*-*-*-\n";
//            store_op = true;
//        }
    }

    void write_listener_toMemory(const vip_trans_toMemory &t) {
        if (t.toMemory.req == ME_AccessType::ME_WR) {
            dut_mem.push_back(t.toMemory.dataIn);
            std::cout << "+++++++++ DUT store +++++++++ addr: 0x" << std::hex << t.toMemory.addrIn << " Data: " << t.toMemory.dataIn << " MaskType: " << t.toMemory.mask
                      << std::endl;
        }

        //        wait(SC_ZERO_TIME);
        toMemory_channel.read(toMemory_data);
        if (toMemory_data.req == ME_AccessType::ME_WR) {
            goldenReference_mem.push_back(toMemory_data.dataIn);
            std::cout << "+++++++++ ISA store +++++++++ addr: 0x" << std::hex << toMemory_data.addrIn << " Data: " << toMemory_data.dataIn << " MaskType: "
                      << toMemory_data.mask << std::endl;
        }
//        std::cout << "+++++++++ toMemory DUT +++++++++ request: 0x" << std::hex << t.toMemory.addrIn << " Data: " << t.toMemory.dataIn << " AccessType: "<<t.toMemory.req << std::endl;
//        std::cout << "+++++++++ toMemory ISA +++++++++ request: 0x" << std::hex << toMemory_data.addrIn << " Data: " << toMemory_data.dataIn << " AccessType: "<<toMemory_data.req << std::endl;

    }
};

#endif //UVMSYSTEMC_SCOREBOARD_H
