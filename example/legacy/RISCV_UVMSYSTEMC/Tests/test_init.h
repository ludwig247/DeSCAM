//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/22/18.
//
/**
 * \class: UVM test
    - Each UVM test is defined as a dedicated test class, which instantiates the testbench and defines the test sequence(s).
        * exp. test for Register type instructions
        * in some tests we might change the testbench used. i.e. when we are including interrupts as signals to the DUT.
    - Reuse of tests and topologies is possible by deriving tests from a test base class.
        * creating future test can be much easier because you only need to change the sequences (scenarios) for the test.
    - The configuration and factory concept can be used to configure or override UVM components, sequences or sequence items
        * something like this:
            uvm::uvm_config_db<int>::set(NULL, "tb.*", "seq_type", 1);
            uvm::uvm_config_db<instr_constraint_type>::set(NULL, "tb.*", "constraint_type", Reg_Reg);
    - Tests can be selected (passed) as command line option
        * Thought it's said that this is not yet available in UVM-SystemC but we can do this manually
 */

#ifndef UVMSYSTEMC_TEST_INIT_H
#define UVMSYSTEMC_TEST_INIT_H

#include <uvm>
#include "vip_components/testbench.h"
#include "sequence_init.h"
using namespace uvm;

class test_init : public uvm_test
{
public:
    testbench* tb;

    test_init( uvm_component_name name ) : uvm_test( name ) {}

    UVM_COMPONENT_UTILS(test_init)
    void build_phase( uvm_phase& phase )
    {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this,
                         "tb.uvc_fromMemory.agent.sequencer.run_phase", "default_sequence",  sequence_init<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "Init Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase )
    {
        std::cout<< "\n\n\n";
        uvm_report_info( "Init Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

#endif //UVMSYSTEMC_TEST_INIT_H