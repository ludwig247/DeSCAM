//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//

#ifndef UVMSYSTEMC_VIP_TRANS_H
#define UVMSYSTEMC_VIP_TRANS_H

#include <uvm>
#include "Memory_Interfaces.h"
using namespace uvm;

class vip_trans_toMemory : public uvm_sequence_item {    /// Inherits from uvm_transaction
public:
        CUtoME_IF toMemory;

    UVM_OBJECT_UTILS(vip_trans_toMemory);

    vip_trans_toMemory(const std::string &name = "vip_trans_toMemory") {
        toMemory.addrIn = 0x0;
        toMemory.dataIn = 0x0;
        toMemory.mask = ME_MaskType::MT_B;
        toMemory.req = ME_AccessType::ME_RD;
    }

    /// A sequence item should implement all elementary member functions to print, pack, unpack, copy and compare the data items
    /// (there are no field macros in UVM-SystemC )
    virtual void do_print(uvm::uvm_printer &printer) const {
        printer.print_field_int("addr", toMemory.addrIn);
        printer.print_field_int("data", toMemory.dataIn);
        printer.print_field_int("mask", toMemory.mask);
        printer.print_field_int("req", toMemory.req);
    }
//    virtual void do_pack( uvm_packer& packer ) const { ... }
//    virtual void do_unpack( uvm_packer& packer ) { ... }
//    virtual void do_copy( const uvm_object* rhs ) { ... }
//    virtual bool do_compare( const uvm_object* rhs ) const { ... }
}; // class vip_trans


class vip_trans_fromMemory : public uvm_sequence_item {    /// Inherits from uvm_transaction
public:
    MEtoCP_IF fromMemory;

    UVM_OBJECT_UTILS(vip_trans_fromMemory);

    vip_trans_fromMemory(const std::string &name = "vip_trans_fromMemory") {
        fromMemory.loadedData = 0x0;
    }

    virtual void do_print(uvm::uvm_printer &printer) const {
        printer.print_field_int("data", fromMemory.loadedData);
    }
//    virtual void do_pack( uvm_packer& packer ) const { ... }
//    virtual void do_unpack( uvm_packer& packer ) { ... }
//    virtual void do_copy( const uvm_object* rhs ) { ... }
//    virtual bool do_compare( const uvm_object* rhs ) const { ... }
}; // class vip_trans
#endif //UVMSYSTEMC_VIP_TRANS_H
