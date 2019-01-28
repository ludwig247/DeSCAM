//
// Created by tobias on 29.11.17.
//

#include "systemc.h"
#include "Example3.h"
#include "Stimuli.h"
#include "Stimuli2.h"


using namespace std;

int sc_main(int, char **) {
    //Module
    //Generating/Receiving messages
    Stimuli2 stimuli2("stimuli2");
    Example3 example_module("example_module");
    Stimuli stimuli("stimuli");

    Blocking<int> channel2("channel2");
    MasterSlave<bool> channel1("channel1");

    //Connect example_module output to stimuli input
    stimuli.slave_in1(channel1);
    example_module.master_out1(channel1);

    //Connect example_module input to stimuli output
    stimuli2.value(channel2);
    example_module.value_in(channel2);

    sc_start(); //Start simulation
    return 0;
}