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
            uvm_config_db<int>::set(NULL, "tb.*", "seq_type", 1);
            uvm_config_db<instr_constraint_type>::set(NULL, "tb.*", "constraint_type", Reg_Reg);
    - Tests can be selected (passed) as command line option
        * Thought it's said that this is not yet available in UVM-SystemC but we can do this manually
 */

#ifndef UVMSYSTEMC_SINGLE_TYPE_TESTS_H
#define UVMSYSTEMC_SINGLE_TYPE_TESTS_H

#include <uvm>
#include "vip_components/testbench.h"
#include "Single_Type_Sequences.h"
using namespace uvm;

class test_R : public uvm_test
{
public:
    testbench* tb;

    test_R( uvm_component_name name ) : uvm_test( name ) {}

    UVM_COMPONENT_UTILS(test_R)
    void build_phase( uvm_phase& phase )
    {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this,
                         "tb.uvc_fromMemory.agent.sequencer.run_phase", "default_sequence",  sequence_R<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "R_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase )
    {
        std::cout<< "\n\n\n";
        uvm_report_info( "R_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

class test_I_I : public uvm_test
{
public:
    testbench* tb;
    test_I_I( uvm_component_name name ) : uvm_test( name ) {}
    UVM_COMPONENT_UTILS(test_I_I)
    void build_phase( uvm_phase& phase ) {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this, "tb.uvc_fromMemory.agent.sequencer.run_phase",
                "default_sequence",  sequence_I_I<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "I_I_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase ) {
        std::cout<< "\n\n\n";
        uvm_report_info( "I_I_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

class test_I_L : public uvm_test
{
public:
    testbench* tb;
    test_I_L( uvm_component_name name ) : uvm_test( name ) {}
    UVM_COMPONENT_UTILS(test_I_L)
    void build_phase( uvm_phase& phase ) {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this, "tb.uvc_fromMemory.agent.sequencer.run_phase",
                                                 "default_sequence",  sequence_I_L<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "I_L_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase ) {
        std::cout<< "\n\n\n";
        uvm_report_info( "I_L_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

class test_I_J : public uvm_test
{
public:
    testbench* tb;
    test_I_J( uvm_component_name name ) : uvm_test( name ) {}
    UVM_COMPONENT_UTILS(test_I_J)
    void build_phase( uvm_phase& phase ) {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this, "tb.uvc_fromMemory.agent.sequencer.run_phase",
                                                 "default_sequence",  sequence_I_J<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "I_J_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase ) {
        std::cout<< "\n\n\n";
        uvm_report_info( "I_J_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

class test_S : public uvm_test
{
public:
    testbench* tb;
    test_S( uvm_component_name name ) : uvm_test( name ) {}
    UVM_COMPONENT_UTILS(test_S)
    void build_phase( uvm_phase& phase ) {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this, "tb.uvc_fromMemory.agent.sequencer.run_phase",
                                                 "default_sequence",  sequence_S<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "S_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase ) {
        std::cout<< "\n\n\n";
        uvm_report_info( "S_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

class test_B : public uvm_test
{
public:
    testbench* tb;
    test_B( uvm_component_name name ) : uvm_test( name ) {}
    UVM_COMPONENT_UTILS(test_B)
    void build_phase( uvm_phase& phase ) {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this, "tb.uvc_fromMemory.agent.sequencer.run_phase",
                                                 "default_sequence",  sequence_B<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "B_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase ) {
        std::cout<< "\n\n\n";
        uvm_report_info( "B_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

class test_U : public uvm_test
{
public:
    testbench* tb;
    test_U( uvm_component_name name ) : uvm_test( name ) {}
    UVM_COMPONENT_UTILS(test_U)
    void build_phase( uvm_phase& phase ) {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this, "tb.uvc_fromMemory.agent.sequencer.run_phase",
                                                 "default_sequence",  sequence_U<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "U_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase ) {
        std::cout<< "\n\n\n";
        uvm_report_info( "U_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

class test_J : public uvm_test
{
public:
    testbench* tb;
    test_J( uvm_component_name name ) : uvm_test( name ) {}
    UVM_COMPONENT_UTILS(test_J)
    void build_phase( uvm_phase& phase ) {
        uvm_test::build_phase(phase);
        tb = testbench::type_id::create("tb",this);
        uvm_config_db<uvm_object_wrapper*>::set( this, "tb.uvc_fromMemory.agent.sequencer.run_phase",
                                                 "default_sequence",  sequence_J<vip_trans_fromMemory>::type_id::get() );
    }

    void end_of_elaboration_phase( uvm_phase& phase){
        uvm_report_info( "J_Type Test", "**************************** UVM TEST STARTED ****************************", uvm::UVM_NONE );
        std::cout<< "\n\n\n\n\t\t\t toMemory Direction \t\t\t   ----   \t\t\t fromMemory Direction \n";
    }

    void report_phase( uvm_phase& phase ) {
        std::cout<< "\n\n\n";
        uvm_report_info( "J_Type Test", "**************************** UVM TEST ENDED ****************************", uvm::UVM_NONE );
    }
};

#endif //UVMSYSTEMC_SINGLE_TYPE_TESTS_H