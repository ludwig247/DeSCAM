//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 10/24/18.
//
/**
 * \class: Top
 *      - The top-level (e.g. sc_main) contains the test(s) and the DUT
 *              Remark: we might send the requested tests names through commandline arguments
 *      - The interface to which the DUT is connected is stored in the configuration database, so it can be used by the UVCs to connect to the DUT.
 *      - The test to be executed is either defined by the test class instantiation or by the argument of the member function run_test.
 *              Remark: run_test("arg") will be our way to present the commandline argument (desired test) to decide what test to be executed.
 */

#include <uvm>

#include "vip_components/vip_if.h"
#include "../RISCV_ISA/ESL/Core.h"
#include "Tests/Single_Type_Tests/Single_Type_Tests.h"
#include "Tests/test_init.h"
//#include "dut.h"
using namespace uvm;

int sc_main(int, char*[])
{
    /// initiate an instance of your DUT
//    CPU_dut* my_dut = new CPU_dut("my_dut");
    Core* my_dut = new Core("my_dut");



    /// initiate an instance of the test you want to run
//    test_R* my_test = new test_R("my_test");
//    test_I_I* my_test = new test_I_I("my_test");
//    test_I_L* my_test = new test_I_L("my_test");
//    test_I_J* my_test = new test_I_J("my_test");
//    test_S* my_test = new test_S("my_test");
//    test_B* my_test = new test_B("my_test");
//    test_U* my_test = new test_U("my_test");
//    test_J* my_test = new test_J("my_test");
    test_init* my_test = new test_init("my_test");

    //define the connections types and configure which one is used in which agent
    auto* vif_uvc_fromMemory = new vip_if_fromMemory;
    auto* vif_uvc_toMemory = new vip_if_toMemory;
    /// register interface using the configuration database
    ///     Remark: remember to specify which interface will go to which agent!
    uvm_config_db<vip_if_fromMemory*>::set(NULL, "*.uvc_fromMemory.*", "vif", vif_uvc_fromMemory);
    uvm_config_db<vip_if_toMemory*>::set(NULL, "*.uvc_toMemory.*", "vif", vif_uvc_toMemory);


    /// Connect DUT to the interface
    my_dut->MEtoCO_port(vif_uvc_fromMemory->fromMemory_Port);
    my_dut->COtoME_port(vif_uvc_toMemory->toMemory_Port);

    /// Dynamically instantiates the test if given as argument and start it
    uvm::run_test();
    return 0;
}
