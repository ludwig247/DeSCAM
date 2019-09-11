//
// Created by tobias on 29.11.17.
//

#include "systemc.h"
#include "Example2.h"
#include "Stimuli.h"


using namespace std;

int sc_main(int, char **) {
    //Generating/Receiving messages
    Stimuli stimuli("stimuli");

    //Module
    Example2 example_module("example_module");


    Blocking<bool> blocking_channel2("blocking_channel2");
    Blocking<msg_type> blocking_channel1("blocking_channel1");

    //Connect example_module output to stimuli input
    stimuli.msg_port(blocking_channel1);
    example_module.msg_port(blocking_channel1);

    //Connect example_module input to stimuli output
    stimuli.new_frame_found(blocking_channel2);
    example_module.new_frame_found(blocking_channel2);

    sc_start(); //Start simulation
    if(sc_delta_count() == 500){ // Deny unlimited simulation
        sc_stop();
    }
    return 0;
}