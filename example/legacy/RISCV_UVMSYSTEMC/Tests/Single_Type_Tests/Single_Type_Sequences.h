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
#ifndef UVMSYSTEMC_SINGLE_TYPE_SEQUENCES_H
#define UVMSYSTEMC_SINGLE_TYPE_SEQUENCES_H

#include <uvm>
using namespace uvm;

// my version
#include <scv.h>
#include "Tests/Randomness/Data_ext.h"
#include "Tests/Randomness/Encoder.h"
#include "Tests/Randomness/Instruction_constraints.h"


/// Remark: Don't forget to register every new sequence objects that you create in the factory using this macro: UVM_OBJECT_PARAM_UTILS()
/// Remark: To make sure that your entire sequence will be sent to the DUT make sure to raise an objection at the pre_body phase and drop it at the post_body phase.
#define NUM_TRANS 30



template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_R : public uvm_sequence<REQ,RSP> {
public:
    sequence_R(const std::string &name)
            : uvm_sequence<REQ, RSP>(name) {}

    UVM_OBJECT_PARAM_UTILS(sequence_R<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, R_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();

            decodedInstr->next();

            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
//            std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item " << i << ", value " << std::hex
//                      << req->fromMemory.loadedData << std::endl;
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
//        std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item X, value " << std::hex
//                  << req->fromMemory.loadedData << std::endl;
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

}; // class sequence_R

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_I_I : public uvm_sequence<REQ,RSP> {
public:
    sequence_I_I(const std::string &name) : uvm_sequence<REQ, RSP>(name) {}
    UVM_OBJECT_PARAM_UTILS(sequence_I_I<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, I_I_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();
            decodedInstr->next();
            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code (EBREAK instruction)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
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
}; // class sequence_I_I

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_I_L : public uvm_sequence<REQ,RSP> {
public:
    sequence_I_L(const std::string &name) : uvm_sequence<REQ, RSP>(name) {}
    UVM_OBJECT_PARAM_UTILS(sequence_I_L<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");
        scv_smart_ptr<unsigned int> loadedData("loadedData");

        constrain_instr(decodedInstr, I_L_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            // send instruction
            req = new REQ();
            rsp = new RSP();
            decodedInstr->next();
            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);

            // send data
            req = new REQ();
            rsp = new RSP();
            loadedData->next();
            req->fromMemory.loadedData = (*loadedData);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code (EBREAK instruction)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
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
}; // class sequence_I_L

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_I_J : public uvm_sequence<REQ,RSP> {
public:
    sequence_I_J(const std::string &name) : uvm_sequence<REQ, RSP>(name) {}
    UVM_OBJECT_PARAM_UTILS(sequence_I_J<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, I_J_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();
            decodedInstr->next();
            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code (EBREAK instruction)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
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
}; // class sequence_I_I

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_S : public uvm_sequence<REQ,RSP> {
public:
    sequence_S(const std::string &name) : uvm_sequence<REQ, RSP>(name) {}
    UVM_OBJECT_PARAM_UTILS(sequence_S<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, S_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();
            decodedInstr->next();
            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code (EBREAK instruction)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
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
}; // class sequence_I_I

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_B : public uvm_sequence<REQ,RSP> {
public:
    sequence_B(const std::string &name) : uvm_sequence<REQ, RSP>(name) {}
    UVM_OBJECT_PARAM_UTILS(sequence_B<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, B_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();
            decodedInstr->next();
            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code (EBREAK instruction)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
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
}; // class sequence_I_I

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_U : public uvm_sequence<REQ,RSP> {
public:
    sequence_U(const std::string &name) : uvm_sequence<REQ, RSP>(name) {}
    UVM_OBJECT_PARAM_UTILS(sequence_U<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, U_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();
            decodedInstr->next();
            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code (EBREAK instruction)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
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
}; // class sequence_I_I

template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence_J : public uvm_sequence<REQ,RSP> {
public:
    sequence_J(const std::string &name) : uvm_sequence<REQ, RSP>(name) {}
    UVM_OBJECT_PARAM_UTILS(sequence_J<REQ, RSP>);

    void pre_body()
    {
        // raise objection if started as a root sequence
        if(this->starting_phase != NULL)
            this->starting_phase->raise_objection(this);
    }

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<G_DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, J_format);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();
            decodedInstr->next();
            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code (EBREAK instruction)
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x100073;
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
}; // class sequence_I_I


/*
template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence00 : public uvm_sequence<REQ,RSP> {
public:
    sequence00(const std::string &name)
            : uvm_sequence<REQ, RSP>(name) {
        std::cout << sc_core::sc_time_stamp() << ": constructor " << name << std::endl;
    }

    UVM_OBJECT_PARAM_UTILS(sequence00<REQ, RSP>);

    void body() {
        REQ *req;
        RSP *rsp;
//        scv_smart_ptr<DecodedInstr> decodedInstr("decodedInstr");

        //send one final instruction indicating the end of the program code
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x13;
        std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item " << 0 << ", value " << std::hex
                  << req->fromMemory.loadedData << std::endl;
        this->start_item(req);
        this->finish_item(req);
        this->get_response(rsp);
    }
}; // class sequence


template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence01 : public uvm_sequence<REQ,RSP> {
public:
    instr_constraint_type constraint_type;

    sequence01(const std::string &name)
            : uvm_sequence<REQ, RSP>(name) {
        std::cout << sc_core::sc_time_stamp() << ": constructor " << name << std::endl;
    }

    UVM_OBJECT_PARAM_UTILS(sequence01<REQ, RSP>);

    void body() {
        REQ *req;
        RSP *rsp; /// A sequence contains a request and (optional) response, both defined as sequence item
        scv_smart_ptr<DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, constraint_type);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();

            decodedInstr->next();

            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item " << i << ", value " << std::hex
                      << req->fromMemory.loadedData << std::endl;

            this->start_item(req);
            // req->randomize(); /// Compatibility layer to SCV or CRAVE not yet implemented
            // Remark: Shouldn't the randomizing of the req happen before "start_item" !?
            this->finish_item(req);
            this->get_response(rsp); /// Optional: get response
        }

        //send final instruction indicating the end of the program code
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x13;
        std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item " << 0 << ", value " << std::hex
                  << req->fromMemory.loadedData << std::endl;
        this->start_item(req);
        this->finish_item(req);
        this->get_response(rsp);
    }
}; // class sequence


template <typename REQ = uvm_sequence_item, typename RSP = REQ>
class sequence02 : public uvm_sequence<REQ,RSP> {
public:
    sequence02(const std::string &name)
            : uvm_sequence<REQ, RSP>(name) {
        std::cout << sc_core::sc_time_stamp() << ": constructor " << name << std::endl;
    }

    UVM_OBJECT_PARAM_UTILS(sequence02<REQ, RSP>);

    void body() {
        REQ *req;
        RSP *rsp;
        scv_smart_ptr<DecodedInstr> decodedInstr("decodedInstr");

        constrain_instr(decodedInstr, Reg_Imm);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();

            decodedInstr->next();

            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item " << i << ", value " << std::hex
                      << req->fromMemory.loadedData << std::endl;
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }
        constrain_instr(decodedInstr, Reg_Reg);
        for (int i = 0; i < NUM_TRANS; i++) {
            req = new REQ();
            rsp = new RSP();

            decodedInstr->next();

            req->fromMemory.loadedData = encode_instruction(*decodedInstr);
            std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item " << i << ", value " << std::hex
                      << req->fromMemory.loadedData << std::endl;
            this->start_item(req);
            this->finish_item(req);
            this->get_response(rsp);
        }

        //send final instruction indicating the end of the program code
        req = new REQ();
        rsp = new RSP();
        req->fromMemory.loadedData = 0x13;
        std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item " << 0 << ", value " << std::hex
                  << req->fromMemory.loadedData << std::endl;
        this->start_item(req);
        this->finish_item(req);
        this->get_response(rsp);
    }
}; // class sequence


class sequence : public uvm_sequence<vip_trans_fromMemory> {
public:
    int seq_type;
    instr_constraint_type constraint_type;
    sequence00<vip_trans_fromMemory>* seq00;
    sequence01<vip_trans_fromMemory>* seq01;
    sequence02<vip_trans_fromMemory>* seq02;

    sequence(const std::string &name)
            : uvm_sequence<vip_trans_fromMemory>(name) {
        std::cout << sc_core::sc_time_stamp() << ": constructor " << name << std::endl;
    }

    UVM_OBJECT_PARAM_UTILS(sequence);

    void body() {
        switch(seq_type){
            case 1:
                seq01 = sequence01<vip_trans_fromMemory>::type_id::create("seq01");
                seq01->constraint_type = constraint_type;
                seq01->start(m_sequencer,this); break;
            case 2:
                seq02 = sequence02<vip_trans_fromMemory>::type_id::create("seq02");
                seq02->start(m_sequencer,this); break;
            default:
                seq00 = sequence00<vip_trans_fromMemory>::type_id::create("seq00");
                seq00->start(m_sequencer,this); break;
        }
    }
}; // class sequence

*/
#endif //UVMSYSTEMC_SINGLE_TYPE_SEQUENCES_H
