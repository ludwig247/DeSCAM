//
// Created by tobias on 29.11.17.
//

#include "systemc.h"
#include "Stimuli.h"
#include "Example1.h"


using namespace std;

int sc_main(int, char **) {
    //Generating/Receiving messages
    Stimuli stimuli("stimuli");
    //Module
    Example1 example_module("example_module");
    //Channels
    Blocking<int> blocking_channel2("blocking_channel2");
    Shared<bool> shared_channel("blocking_channel");
    Blocking<int> blocking_channel1("blocking_channel1");

    //Connect example_module output to stimuli input
    stimuli.block_in(blocking_channel1);
    example_module.block_out(blocking_channel1);

    //Connect example_module input to stimuli output
    stimuli.block_out(blocking_channel2);
    example_module.block_in(blocking_channel2);

    //Connect shared ports
    example_module.share_out(shared_channel);
    stimuli.share_in(shared_channel);

    sc_start(); //Start simulation
    return 0;
}