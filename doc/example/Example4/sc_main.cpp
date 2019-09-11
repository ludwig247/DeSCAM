//
// Created by tobias on 29.11.17.
//

#include "systemc.h"
#include "Example4.h"
#include "Stimuli.h"
#include "Stimuli2.h"


using namespace std;

int sc_main(int, char **) {
    //Module
    //Generating/Receiving messages
    Stimuli stimuli("stimuli");
    Stimuli2 stimuli2("stimuli2");
    Example4 example_module("example_module");



    Blocking<int> channel2("channel2");
    MasterSlave<bool> channel1("channel1");
    MasterSlave<bool> channel3("channel3");
    MasterSlave<bool> channel4("channel4");

    //Connect example_module output to stimuli input
    example_module.master_in1(channel1);
    stimuli.slave_out1(channel1);
    //Connect example_module output to stimuli input
    example_module.master_in2(channel3);
    stimuli.slave_out2(channel3);

    //Connect example_module input to stimuli output
    stimuli2.value(channel2);
    example_module.value_in(channel2);

    //Connect example_module input to stimuli output
    stimuli.report_in(channel4);
    example_module.report_out(channel4);

    sc_start(); //Start simulation
    return 0;
}