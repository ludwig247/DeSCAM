//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//
/**
 * \class: UVM sequence
 * - Sequences are part of the test scenario and define streams of transactions.
 *      Remark: That's why we should separate different scenarios (Reg_Reg, Reg_Imm ..) into different tests having specific sequences (with specific constrains)
 * - The properties (or attributes) of a transaction are captured in a sequence item.
 * - Sequences are NOT part of the testbench hierarchy, but are mapped onto one or more sequenceRs.
 * - Sequences can be layered, hierarchical or virtual, and may contain multiple sequences or sequence items.
 *      Remark: does this mean that the same sequence will have a sub_sequence for instructions and a sub_sequence for loaded data!?
 * - Sequences and transactions can be configured via the factory.
 * -
 */
#ifndef UVMSYSTEMC_SEQUENCE_INIT_H
#define UVMSYSTEMC_SEQUENCE_INIT_H

#include <uvm>
using namespace uvm;

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_init : public uvm_sequence<REQ,RSP> {
private:
    unsigned int li_instr[32] = {
            0x06400013,     //li	x0,100
            0x06500093,     //li	x1,101
            0x06600113,     //li	x2,102
            0x06700193,     //li	x3,103
            0x06800213,     //li	x4,104
            0x06900293,     //li	x5,105
            0x06A00313,     //li	x6,106
            0x06B00393,     //li	x7,107
            0x06C00413,     //li	x8,108
            0x06D00493,     //li	x9,109
            0x06E00513,     //li	x10,110
            0x06F00593,     //li	x11,111
            0x07000613,     //li	x12,112
            0x07100693,     //li	x13,113
            0x07200713,     //li	x14,114
            0x07300793,     //li	x15,115
            0x07400813,     //li	x16,116
            0x07500893,     //li	x17,117
            0x07600913,     //li	x18,118
            0x07700993,     //li	x19,119
            0x07800A13,     //li	x20,120
            0x07900A93,     //li	x21,121
            0x07A00B13,     //li	x22,122
            0x07B00B93,     //li	x23,123
            0x07C00C13,     //li	x24,124
            0x07D00C93,     //li	x25,125
            0x07E00D13,     //li	x26,126
            0x07F00D93,     //li	x27,127
            0x08000E13,     //li	x28,128
            0x08100E93,     //li	x29,129
            0x08200F13,     //li	x30,130
            0x08300F93      //li	x31,131
    };


    unsigned int sw_instr[32] = {
            0x00002023,     //sw x0, 0(x0)
            0x001020A3,     //sw x1, 1(x0)
            0x00202123,     //sw x2, 2(x0)
            0x003021A3,     //sw x3, 3(x0)
            0x00402223,     //sw x4, 4(x0)
            0x005022A3,     //sw x5, 5(x0)
            0x00602323,     //sw x6, 6(x0)
            0x007023A3,     //sw x7, 7(x0)
            0x00802423,     //sw x8, 8(x0)
            0x009024A3,     //sw x9, 9(x0)
            0x00A02523,     //sw x10, 10(x0)
            0x00B025A3,     //sw x11, 11(x0)
            0x00C02623,     //sw x12, 12(x0)
            0x00D026A3,     //sw x13, 13(x0)
            0x00E02723,     //sw x14, 14(x0)
            0x00F027A3,     //sw x15, 15(x0)
            0x01002823,     //sw x16, 16(x0)
            0x011028A3,     //sw x17, 17(x0)
            0x01202923,     //sw x18, 18(x0)
            0x013029A3,     //sw x19, 19(x0)
            0x01402A23,     //sw x20, 20(x0)
            0x01502AA3,     //sw x21, 21(x0)
            0x01602B23,     //sw x22, 22(x0)
            0x01702BA3,     //sw x23, 23(x0)
            0x01802C23,     //sw x24, 24(x0)
            0x01902CA3,     //sw x25, 25(x0)
            0x01A02D23,     //sw x26, 26(x0)
            0x01B02DA3,     //sw x27, 27(x0)
            0x01C02E23,     //sw x28, 28(x0)
            0x01D02EA3,     //sw x29, 29(x0)
            0x01E02F23,     //sw x30, 30(x0)
            0x01F02FA3      //sw x31, 31(x0)
    };

public:
    sequence_init(const std::string &name)
            : uvm_sequence<REQ, RSP>(name) {}

    UVM_OBJECT_PARAM_UTILS(sequence_init<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;

        /// Load regesters with immediate values
        for (int i = 0; i < 32; i++) {
            req = new REQ();
            rsp = new RSP();

            req->fromMemory.loadedData = li_instr[i];
//            std::cout<<"sequence ........... " <<req->fromMemory.loadedData<<"\n";
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        /// store regesters values to memory
        for (int i = 0; i < 32; i++) {
            req = new REQ();
            rsp = new RSP();

            req->fromMemory.loadedData = sw_instr[i];
//            std::cout<<"sequence ........... " <<req->fromMemory.loadedData<<"\n";
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        /// final instruction (eBreak)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x00100073;
//        std::cout<<"sequence ........... " <<req->fromMemory.loadedData<<"\n";
        this->start_item(req);
        this->finish_item(req);
        this->get_response(rsp);
    }

    void post_body()
    {
        // drop objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->drop_objection(this);
    }

}; // class sequence
#endif //UVMSYSTEMC_SEQUENCE_INIT_H
