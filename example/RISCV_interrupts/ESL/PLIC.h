//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

/*
 * Platform Level Interrupt Controller (PLIC)
 * Used to prioritizes and distributes global interrupts
 */

#ifndef PROJECT_PLIC_H
#define PROJECT_PLIC_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#include "systemc.h"
#include "Interfaces.h"
#include "Defines.h"
#include <scv.h>
#ifdef NOSCAM
#include "../../RISCV_commons/Memory_Interfaces.h"
#endif

/////////////////   PLIC Gateway   /////////////////
class TheUNKNOWN : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(TheUNKNOWN);

    TheUNKNOWN(sc_module_name name) :
            rand_Int("rand_Int"),
            IntSig_1("IntSig_1"),
            IntSig_2("IntSig_2")//,
//            IntSig_3("IntSig_3"),
//            IntSig_4("IntSig_4"),
//            IntSig_5("IntSig_5"),
//            IntSig_6("IntSig_6"),
//            IntSig_7("IntSig_7"),
//            IntSig_8("IntSig_8"),
//            IntSig_9("IntSig_9")
    {
        scv_bag< bool > field_dist;
        field_dist.add(false, 500000);
        field_dist.add(true, 1);
        rand_Int->set_mode(field_dist);
        SC_THREAD(run);
    }

    sc_out<sc_logic> IntSig_1;
    sc_out<sc_logic> IntSig_2;
//    sc_out<sc_logic> IntSig_3;
//    sc_out<sc_logic> IntSig_4;
//    sc_out<sc_logic> IntSig_5;
//    sc_out<sc_logic> IntSig_6;
//    sc_out<sc_logic> IntSig_7;
//    sc_out<sc_logic> IntSig_8;
//    sc_out<sc_logic> IntSig_9;

    scv_smart_ptr<bool> rand_Int;

    void run() {
        while (true) {
            rand_Int->next();
            if(*rand_Int)
                IntSig_1->write(SC_LOGIC_1);
            else
                IntSig_1->write(SC_LOGIC_0);


            rand_Int->next();
            if(*rand_Int)
                IntSig_2->write(SC_LOGIC_1);
            else
                IntSig_2->write(SC_LOGIC_0);


//            rand_Int->next();
//            if(*rand_Int)
//                IntSig_3.write(SC_LOGIC_1);
//            else
//                IntSig_3.write(SC_LOGIC_0);
//
//
//            rand_Int->next();
//            if(*rand_Int)
//                IntSig_4.write(SC_LOGIC_1);
//            else
//                IntSig_4.write(SC_LOGIC_0);
//
//
//            rand_Int->next();
//            if(*rand_Int)
//                IntSig_5.write(SC_LOGIC_1);
//            else
//                IntSig_5.write(SC_LOGIC_0);
//
//
//            rand_Int->next();
//            if(*rand_Int)
//                IntSig_6.write(SC_LOGIC_1);
//            else
//                IntSig_6.write(SC_LOGIC_0);
//
//
//            rand_Int->next();
//            if(*rand_Int)
//                IntSig_7.write(SC_LOGIC_1);
//            else
//                IntSig_7.write(SC_LOGIC_0);
//
//
//            rand_Int->next();
//            if(*rand_Int)
//                IntSig_8.write(SC_LOGIC_1);
//            else
//                IntSig_8.write(SC_LOGIC_0);
//
//            rand_Int->next();
//            if(*rand_Int)
//                IntSig_9.write(SC_LOGIC_1);
//            else
//                IntSig_9.write(SC_LOGIC_0);


            wait(SC_ZERO_TIME);
        }
    }
};

class PLIC_Gateways : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Gateways);

    PLIC_Gateways(sc_module_name name) :
            IntSig_1("IntSig_1"),
            IntSig_2("IntSig_2"),
//            IntSig_3("IntSig_3"),
//            IntSig_4("IntSig_4"),
//            IntSig_5("IntSig_5"),
//            IntSig_6("IntSig_6"),
//            IntSig_7("IntSig_7"),
//            IntSig_8("IntSig_8"),
//            IntSig_9("IntSig_9"),
            IntReq_1("IntReq_1"),
            IntReq_2("IntReq_2"),
//            IntReq_3("IntReq_3"),
//            IntReq_4("IntReq_4"),
//            IntReq_5("IntReq_5"),
//            IntReq_6("IntReq_6"),
//            IntReq_7("IntReq_7"),
//            IntReq_8("IntReq_8"),
//            IntReq_9("IntReq_9"),
            int_1_data(SC_LOGIC_0),
            int_2_data(SC_LOGIC_0)
    {
        SC_METHOD(Process_Int_1);
        sensitive << IntSig_1;
        SC_METHOD(Process_Int_2);
        sensitive << IntSig_2;

//        SC_METHOD(Process_Int_3);
//        sensitive << IntSig_3;
//        SC_METHOD(Process_Int_4);
//        sensitive << IntSig_4;
//        SC_METHOD(Process_Int_5);
//        sensitive << IntSig_5;
//        SC_METHOD(Process_Int_6);
//        sensitive << IntSig_6;
//        SC_METHOD(Process_Int_7);
//        sensitive << IntSig_7;
//        SC_METHOD(Process_Int_8);
//        sensitive << IntSig_8;
//        SC_METHOD(Process_Int_9);
//        sensitive << IntSig_9;
        SC_THREAD(run);
    }

    sc_in<sc_logic> IntSig_1;
    sc_in<sc_logic> IntSig_2;
//    sc_in<sc_logic> IntSig_3;
//    sc_in<sc_logic> IntSig_4;
//    sc_in<sc_logic> IntSig_5;
//    sc_in<sc_logic> IntSig_6;
//    sc_in<sc_logic> IntSig_7;
//    sc_in<sc_logic> IntSig_8;
//    sc_in<sc_logic> IntSig_9;
    master_out<bool> IntReq_1;
    master_out<bool> IntReq_2;
//    slave_out<bool> IntReq_3;
//    slave_out<bool> IntReq_4;
//    slave_out<bool> IntReq_5;
//    slave_out<bool> IntReq_6;
//    slave_out<bool> IntReq_7;
//    slave_out<bool> IntReq_8;
//    slave_out<bool> IntReq_9;
    sc_logic int_1_data;
    sc_logic int_2_data;

    void Process_Int_1() {
        int_1_data = IntSig_1->read();
//        while (true) {
//            if (IntSig_1->read() == SC_LOGIC_1)
//                IntReq_1->write(true);
//            else
//                IntReq_1->write(false);
//        }
    }

    void Process_Int_2() {
        int_2_data = IntSig_2->read();
//        while (true) {
//            if (IntSig_2->read() == SC_LOGIC_1)
//                IntReq_2->write(true);
//            else
//                IntReq_2->write(false);
//        }
    }

//    void Process_Int_3() {
//        if(IntSig_3.read() == SC_LOGIC_1)
//            IntReq_3->write(true);
//        else
//            IntReq_3->write(false);
//    }
//
//    void Process_Int_4() {
//        if(IntSig_4.read() == SC_LOGIC_1)
//            IntReq_4->write(true);
//        else
//            IntReq_4->write(false);
//    }
//
//    void Process_Int_5() {
//        if(IntSig_5.read() == SC_LOGIC_1)
//            IntReq_5->write(true);
//        else
//            IntReq_5->write(false);
//    }
//
//    void Process_Int_6() {
//        if(IntSig_6.read() == SC_LOGIC_1)
//            IntReq_6->write(true);
//        else
//            IntReq_6->write(false);
//    }
//
//    void Process_Int_7() {
//        if(IntSig_7.read() == SC_LOGIC_1)
//            IntReq_7->write(true);
//        else
//            IntReq_7->write(false);
//    }
//
//    void Process_Int_8() {
//        if(IntSig_8.read() == SC_LOGIC_1)
//            IntReq_8->write(true);
//        else
//            IntReq_8->write(false);
//    }
//
//    void Process_Int_9() {
//        if(IntSig_9.read() == SC_LOGIC_1)
//            IntReq_9->write(true);
//        else
//            IntReq_9->write(false);
//    }

    void run(){
        while(true){
            if(int_1_data == SC_LOGIC_1)
                IntReq_1->write(true);
            else
                IntReq_1->write(false);


            if(int_2_data == SC_LOGIC_1)
                IntReq_2->write(true);
            else
                IntReq_2->write(false);
        }
    }
};

class PLIC_Gateway : public sc_module {
public:

    TheUNKNOWN sources;
    PLIC_Gateways gateways;

    //Constructor
    SC_HAS_PROCESS(PLIC_Gateway);

    PLIC_Gateway(sc_module_name name) :
            sources("IntSources"),
            gateways("IntGateways"),
            IntSig_1("IntSig_1"),
            IntSig_2("IntSig_2"),
//            IntSig_3("IntSig_3"),
//            IntSig_4("IntSig_4"),
//            IntSig_5("IntSig_5"),
//            IntSig_6("IntSig_6"),
//            IntSig_7("IntSig_7"),
//            IntSig_8("IntSig_8"),
//            IntSig_9("IntSig_9"),
            IntReq_1("IntReq_1"),
            IntReq_2("IntReq_2")//,
//            IntReq_3("IntReq_3"),
//            IntReq_4("IntReq_4"),
//            IntReq_5("IntReq_5"),
//            IntReq_6("IntReq_6"),
//            IntReq_7("IntReq_7"),
//            IntReq_8("IntReq_8"),
//            IntReq_9("IntReq_9")
    {
        sources.IntSig_1(IntSig_1);
        sources.IntSig_2(IntSig_2);
//        sources.IntSig_3(IntSig_3);
//        sources.IntSig_4(IntSig_4);
//        sources.IntSig_5(IntSig_5);
//        sources.IntSig_6(IntSig_6);
//        sources.IntSig_7(IntSig_7);
//        sources.IntSig_8(IntSig_8);
//        sources.IntSig_9(IntSig_9);
        gateways.IntSig_1(IntSig_1);
        gateways.IntSig_2(IntSig_2);
//        gateways.IntSig_3(IntSig_3);
//        gateways.IntSig_4(IntSig_4);
//        gateways.IntSig_5(IntSig_5);
//        gateways.IntSig_6(IntSig_6);
//        gateways.IntSig_7(IntSig_7);
//        gateways.IntSig_8(IntSig_8);
//        gateways.IntSig_9(IntSig_9);

        gateways.IntReq_1(IntReq_1);
        gateways.IntReq_2(IntReq_2);
//        gateways.IntReq_3(IntReq_3);
//        gateways.IntReq_4(IntReq_4);
//        gateways.IntReq_5(IntReq_5);
//        gateways.IntReq_6(IntReq_6);
//        gateways.IntReq_7(IntReq_7);
//        gateways.IntReq_8(IntReq_8);
//        gateways.IntReq_9(IntReq_9);
    }

//    MasterSlave<bool> IntSig_1;
//    MasterSlave<bool> IntSig_2;
    sc_signal<sc_logic> IntSig_1;
    sc_signal<sc_logic> IntSig_2;
//    sc_signal<sc_logic> IntSig_3;
//    sc_signal<sc_logic> IntSig_4;
//    sc_signal<sc_logic> IntSig_5;
//    sc_signal<sc_logic> IntSig_6;
//    sc_signal<sc_logic> IntSig_7;
//    sc_signal<sc_logic> IntSig_8;
//    sc_signal<sc_logic> IntSig_9;
    master_out<bool> IntReq_1;
    master_out<bool> IntReq_2;
//    slave_out<bool> IntReq_3;
//    slave_out<bool> IntReq_4;
//    slave_out<bool> IntReq_5;
//    slave_out<bool> IntReq_6;
//    slave_out<bool> IntReq_7;
//    slave_out<bool> IntReq_8;
//    slave_out<bool> IntReq_9;
};


/////////////////   PLIC Core   /////////////////

class PLIC_Core : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Core);

    PLIC_Core(sc_module_name name) :
            fromGateway_Int1("fromGateway_Int1"),
            fromGateway_Int2("fromGateway_Int2"),
            pending_Int_1(false),
            pending_Int_2(false),
            fromMemory_Priority_Int_1("fromMemory_Priority_Int_1"),
            fromMemory_Priority_Int_2("fromMemory_Priority_Int_2"),
            fromMemory_Enabled("fromMemory_Enabled"),
            fromMemory_Threshold("fromMemory_Threshold"),
            toMemory_MaxPriority("toMemory_MaxPriority"),
            toMemory_MaxID("toMemory_MaxID"),
            priority_Int_1_data(0),
            priority_Int_2_data(0),
            enabled_data(0),
            threshold_data(0),
            MEIP_port("MEIP_port"),
            max_priority(0),
            max_id(0),
            traversing_priority(0),
            traversing_id(0) {
        SC_THREAD(run);
    }

    /// Communication and data with Gateway
    slave_in<bool> fromGateway_Int1;
    slave_in<bool> fromGateway_Int2;

    bool pending_Int_1;
    bool pending_Int_2;
    /// Communication and data with Memory
    slave_in<unsigned int> fromMemory_Priority_Int_1;
    slave_in<unsigned int> fromMemory_Priority_Int_2;
    slave_in<unsigned int> fromMemory_Enabled;
    slave_in<unsigned int> fromMemory_Threshold;
    slave_out<unsigned int> toMemory_MaxPriority;
    slave_out<unsigned int> toMemory_MaxID;

    unsigned int priority_Int_1_data;
    unsigned int priority_Int_2_data;
    unsigned int enabled_data;
    unsigned int threshold_data;

    /// Communication with Core
    slave_out<bool> MEIP_port;

    /// Internal variables
    unsigned int max_priority;
    unsigned int max_id;
    unsigned int traversing_priority;
    unsigned int traversing_id;

    void run() {
        while (true) {
            /// read pending interrupts from gateway
            fromGateway_Int1->nb_read(pending_Int_1);
            fromGateway_Int2->nb_read(pending_Int_2);

            /// read configuration from memory manager
            fromMemory_Priority_Int_1->nb_read(priority_Int_1_data);
            fromMemory_Priority_Int_2->nb_read(priority_Int_2_data);
            fromMemory_Enabled->nb_read(enabled_data);
            fromMemory_Threshold->nb_read(threshold_data);

            /// reset traversing variables to start a new round
            traversing_priority = 0;
            traversing_id = 0;
            /// process interrupt 1
            if (pending_Int_1 && (enabled_data & 0x1)) {
                traversing_priority = priority_Int_1_data;
                traversing_id = 1;
            }

            /// process interrupt 2
            if (pending_Int_2 && (enabled_data & 0x2)) {
                if(priority_Int_2_data > traversing_priority) {
                    traversing_priority = priority_Int_2_data;
                    traversing_id = 2;
                }
            }

            if (traversing_priority > threshold_data) {
                MEIP_port->nb_write(true);
                max_priority = traversing_priority;
                max_id = traversing_id;
            } else {
                MEIP_port->nb_write(false);
            }

            toMemory_MaxPriority->nb_write(max_priority);
            toMemory_MaxID->nb_write(max_id);
        }
    }
};


/////////////////   PLIC Memory Manager   /////////////////

class PLIC_Memory_Manager : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Memory_Manager);

    PLIC_Memory_Manager(sc_module_name name) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            toCore_Priority_Int_1("toCore_Priority_Int_1"),
            toCore_Priority_Int_2("toCore_Priority_Int_2"),
            toCore_Enabled("toCore_Enabled"),
            toCore_Threshold("toCore_Threshold"),
            fromCore_MaxPriority("fromCore_MaxPriority"),
            fromCore_MaxID("fromCore_MaxID"),
            priority_Int_1_data(0),
            priority_Int_2_data(0),
            enabled_data(0),
            threshold_data(0),
            max_priority_data(0),
            max_id_data(0),
            ClaimComplete(0) {
        SC_THREAD(run);
    }

    /// Communication and data with Core
    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    /// Communication and data with PLIC_Core
    master_out<unsigned int> toCore_Priority_Int_1;
    master_out<unsigned int> toCore_Priority_Int_2;
    master_out<unsigned int> toCore_Enabled;
    master_out<unsigned int> toCore_Threshold;
    master_in<unsigned int> fromCore_MaxPriority;
    master_in<unsigned int> fromCore_MaxID;

    unsigned int priority_Int_1_data;
    unsigned int priority_Int_2_data;
    unsigned int enabled_data;
    unsigned int threshold_data;
    unsigned int max_priority_data;
    unsigned int max_id_data;

    unsigned int ClaimComplete;

    void run() {
        while (true) {
            /// start with a memory request
            MEtoCP_data.loadedData = 0;
            COtoME_port->read(CPtoME_data); //Wait for next request

            /// get the most recent values from PLIC_Core
            fromCore_MaxPriority->read(max_priority_data);
            fromCore_MaxID->read(max_id_data);
            if(max_id_data != ClaimComplete)
                ClaimComplete = max_id_data;

            if (CPtoME_data.addrIn < PLIC_START_ADDR && CPtoME_data.addrIn > PLIC_END_ADDR) {
#ifndef NOSCAM
                cout << "@PLIC: Accessing out of bound. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }

            if (CPtoME_data.req == ME_RD) { // LOAD
                if (CPtoME_data.addrIn == PLIC_Priority_ADDR) {
                    MEtoCP_data.loadedData = priority_Int_1_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Priority_ADDR + 4) {
                    MEtoCP_data.loadedData = priority_Int_2_data;
                    MEtoCO_port->write(MEtoCP_data);
//                } else if (CPtoME_data.addrIn == PLIC_Pending_ADDR) {
//                    MEtoCP_data.loadedData = Pending_reg;
//                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR) {
                    MEtoCP_data.loadedData = enabled_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR) {
                    MEtoCP_data.loadedData = threshold_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR) {
                    MEtoCP_data.loadedData = ClaimComplete;
                    MEtoCO_port->write(MEtoCP_data);
                } else {
#ifndef NOSCAM
                    cout << "@PLIC: Unauthorized read. Terminating!" << hex << CPtoME_data.addrIn << endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
#endif
                }
            } else if (CPtoME_data.req == ME_WR) {
                if (CPtoME_data.addrIn == PLIC_Priority_ADDR) {
                    priority_Int_1_data = CPtoME_data.dataIn;
                    toCore_Priority_Int_1->write(priority_Int_1_data);
                } else if (CPtoME_data.addrIn == PLIC_Priority_ADDR + 4) {
                    priority_Int_2_data = CPtoME_data.dataIn;
                    toCore_Priority_Int_2->write(priority_Int_2_data);
//                } else if (CPtoME_data.addrIn == PLIC_Pending_ADDR) {
//                    Pending_reg = CPtoME_data.dataIn;
                } else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR) {
                    enabled_data = CPtoME_data.dataIn;
                    toCore_Enabled->write(enabled_data);
                } else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR) {
                    threshold_data = CPtoME_data.dataIn;
                    toCore_Threshold->write(threshold_data);
                } else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR) {
                    ClaimComplete = CPtoME_data.dataIn;
                } else {

#ifndef NOSCAM
                    cout << "@PLIC: Unauthorized write. Terminating!" << hex << CPtoME_data.addrIn << endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
#endif
                }
            } else {
#ifndef NOSCAM
                throw std::logic_error(std::string("@PLIC: Undefined memory's req value."));
#endif
            }
        }
    }
};


/////////////////   PLIC    /////////////////


class PLIC : public sc_module {
public:
    //Components
    PLIC_Gateway plic_gateway;
    PLIC_Core plic_core;
    PLIC_Memory_Manager plic_memory_manager;

    //Constructor
    SC_HAS_PROCESS(PLIC);

    /// Communication with Core
    blocking_in<CUtoME_IF> COtoME_port;
    blocking_out<MEtoCU_IF> MEtoCO_port;
    slave_out<bool> MEIP_port;

    /// Communication between Gateway and Core
    MasterSlave<bool> IntReq_1;
    MasterSlave<bool> IntReq_2;

    MasterSlave<unsigned int> MEtoCO_Priority_Int_1;
    MasterSlave<unsigned int> MEtoCO_Priority_Int_2;
    MasterSlave<unsigned int> MEtoCO_Enabled;
    MasterSlave<unsigned int> MEtoCO_Threshold;
    MasterSlave<unsigned int> MEtoCO_MaxPriority;
    MasterSlave<unsigned int> MEtoCO_MaxID;

    PLIC(sc_module_name name) :
            plic_gateway("plic_gateway"),
            plic_core("plic_core"),
            plic_memory_manager("plic_memory_manager"),

            IntReq_1("IntReq_1"),
            IntReq_2("IntReq_2"),

            MEtoCO_Priority_Int_1("MEtoCO_Priority_Int_1"),
            MEtoCO_Priority_Int_2("MEtoCO_Priority_Int_2"),
            MEtoCO_Enabled("MEtoCO_Enabled"),
            MEtoCO_Threshold("MEtoCO_Threshold"),
            MEtoCO_MaxPriority("MEtoCO_MaxPriority"),
            MEtoCO_MaxID("MEtoCO_MaxID"),

            MEIP_port("MEIP_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port") {

        plic_gateway.IntReq_1(IntReq_1);
        plic_gateway.IntReq_2(IntReq_2);
        plic_core.fromGateway_Int1(IntReq_1);
        plic_core.fromGateway_Int2(IntReq_2);

        plic_memory_manager.toCore_Priority_Int_1(MEtoCO_Priority_Int_1);
        plic_memory_manager.toCore_Priority_Int_2(MEtoCO_Priority_Int_2);
        plic_memory_manager.toCore_Enabled(MEtoCO_Enabled);
        plic_memory_manager.toCore_Threshold(MEtoCO_Threshold);
        plic_memory_manager.fromCore_MaxPriority(MEtoCO_MaxPriority);
        plic_memory_manager.fromCore_MaxID(MEtoCO_MaxID);

        plic_core.fromMemory_Priority_Int_1(MEtoCO_Priority_Int_1);
        plic_core.fromMemory_Priority_Int_2(MEtoCO_Priority_Int_2);
        plic_core.fromMemory_Enabled(MEtoCO_Enabled);
        plic_core.fromMemory_Threshold(MEtoCO_Threshold);
        plic_core.toMemory_MaxPriority(MEtoCO_MaxPriority);
        plic_core.toMemory_MaxID(MEtoCO_MaxID);

        plic_memory_manager.COtoME_port(COtoME_port);
        plic_memory_manager.MEtoCO_port(MEtoCO_port);
        plic_core.MEIP_port(MEIP_port);
    }

};

/*

class PLIC_Status : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Status);

    PLIC_Status(sc_module_name name) :
            fromOutside_Pending("fromOutside_Pending"),
            fromMemory_Pending("fromMemory_Pending"),
            fromMemory_Threshold("fromMemory_Threshold"),
            MEIP_port("MEIP_port"),
            pending_data(0),
            threshold_data(0) {
        SC_THREAD(run);
    }

    master_in<unsigned int> fromOutside_Pending;

    slave_in<unsigned int> fromMemory_Pending;
    slave_in<unsigned int> fromMemory_Threshold;

    slave_out<bool> MEIP_port;

    unsigned int pending_data;
    unsigned int threshold_data;

    void run() {
        while (true) {
            fromMemory_Pending->nb_read(pending_data);
            fromMemory_Threshold->nb_read(threshold_data);

            /// read outside status after memory becuase its effect is newer
            fromOutside_Pending->read(pending_data);

            if (pending_data > threshold_data) {
                MEIP_port->nb_write(true);
            } else {
                MEIP_port->nb_write(false);
            }
        }
    }
};


class PLIC_Outside : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Outside);

    PLIC_Outside(sc_module_name name) :
            toMemory_pending("toMemory_pending"),
            toStatus_pending("toStatus_pending"),
            pending(0)
    {
        SC_THREAD(run);
    }

    slave_out<unsigned int> toMemory_pending;
    slave_out<unsigned int> toStatus_pending;

    unsigned int pending;

    void run() {
        while (true) {
            toMemory_pending->nb_write(pending);
            toStatus_pending->nb_write(pending);

            pending = 0;
        }
    }
};


class PLIC_Memory : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(PLIC_Memory);

    PLIC_Memory(sc_module_name name) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            fromOutside_Pending("fromOutside_Pending"),
            toStatus_Pending("toStatus_Pending"),
            toStatus_Threshold("toStatus_Threshold"),
            Priority_reg(0),
            Pending_reg(0),
            Interrupt_enables(0),
            Threshold(0),
            ClaimComplete(0) {
        SC_THREAD(run);
    }

    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    master_in<unsigned int> fromOutside_Pending;
    master_out<unsigned int> toStatus_Pending;
    master_out<unsigned int> toStatus_Threshold;

    unsigned int Priority_reg;
    unsigned int Pending_reg;
    unsigned int Interrupt_enables;
    unsigned int Threshold;
    unsigned int ClaimComplete;

    void run() {
        while (true) {
            /// start with a memory request
            MEtoCP_data.loadedData = 0;
            COtoME_port->read(CPtoME_data); //Wait for next request

            /// get the most recent values from other parts
            fromOutside_Pending->read(Pending_reg);

            if (CPtoME_data.addrIn < PLIC_START_ADDR && CPtoME_data.addrIn > PLIC_END_ADDR) {
#ifndef NOSCAM
                cout << "@PLIC: Accessing out of bound. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }

            if (CPtoME_data.req == ME_RD) { // LOAD
                if (CPtoME_data.addrIn == PLIC_Priority_ADDR) {
                    MEtoCP_data.loadedData = Priority_reg;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Pending_ADDR) {
                    MEtoCP_data.loadedData = Pending_reg;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR) {
                    MEtoCP_data.loadedData = Interrupt_enables;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR) {
                    MEtoCP_data.loadedData = Threshold;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR) {
                    MEtoCP_data.loadedData = ClaimComplete;
                    MEtoCO_port->write(MEtoCP_data);
                } else {
#ifndef NOSCAM
                    cout << "@PLIC: Unauthorized read. Terminating!" << endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
#endif
                }
            } else if (CPtoME_data.req == ME_WR) {
                if (CPtoME_data.addrIn == PLIC_Priority_ADDR) {
                    Priority_reg = CPtoME_data.dataIn;
                    toStatus_Pending->write(Priority_reg);
                } else if (CPtoME_data.addrIn == PLIC_Pending_ADDR)
                    Pending_reg = CPtoME_data.dataIn;
                else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR)
                    Interrupt_enables = CPtoME_data.dataIn;
                else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR) {
                    Threshold = CPtoME_data.dataIn;
                    toStatus_Threshold->write(Threshold);
                } else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR)
                    ClaimComplete = CPtoME_data.dataIn;
                else {

#ifndef NOSCAM
                    cout << "@PLIC: Unauthorized write. Terminating!" << endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
#endif
                }
            } else {
#ifndef NOSCAM
                throw std::logic_error(std::string("@PLIC: Undefined memory's req value."));
#endif
            }
        }
    }
};

#ifndef NOSCAM
class PLIC : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(PLIC);

    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done
    slave_out<bool> MEIP_port;

    MasterSlave<unsigned int> Outside_Memory_Channel;
    MasterSlave<unsigned int> Outside_Status_Channel;

    MasterSlave<unsigned int> Memory_Status_Pending_Channel;
    MasterSlave<unsigned int> Memory_Status_Threshold_Channel;


    PLIC_Memory plic_memory;
    PLIC_Status plic_status;
    PLIC_Outside plic_outside;

    PLIC(sc_module_name name) :
            plic_memory("plic_memory"),
            plic_status("plic_status"),
            plic_outside("plic_outside"),
            Outside_Memory_Channel("Outside_Memory_Channel"),
            Outside_Status_Channel("Outside_Status_Channel"),
            Memory_Status_Pending_Channel("Memory_Status_Pending_Channel"),
            Memory_Status_Threshold_Channel("Memory_Status_Threshold_Channel"),
            MEIP_port("MEIP_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port") {

        plic_memory.fromOutside_Pending(Outside_Memory_Channel);
        plic_memory.toStatus_Pending(Memory_Status_Pending_Channel);
        plic_memory.toStatus_Threshold(Memory_Status_Threshold_Channel);

        plic_outside.toMemory_pending(Outside_Memory_Channel);
        plic_outside.toStatus_pending(Outside_Status_Channel);

        plic_status.fromOutside_Pending(Outside_Status_Channel);
        plic_status.fromMemory_Pending(Memory_Status_Pending_Channel);
        plic_status.fromMemory_Threshold(Memory_Status_Threshold_Channel);

        plic_memory.COtoME_port(COtoME_port);
        plic_memory.MEtoCO_port(MEtoCO_port);
        plic_status.MEIP_port(MEIP_port);
    }

};
#endif
*/
#endif  // PROJECT_PLIC_H