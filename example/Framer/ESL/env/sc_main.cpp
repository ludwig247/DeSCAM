//
// Created by ludwig on 04.07.17.
//

#include "systemc.h"
#include "../Framer_new.h"
#include "../Monitor_new.h"
#include "Environment.h"

int sc_main(int, char **) {

    Framer_new framer("framer");
    Monitor_new monitor("monitor");
    Environment environment("environment");


    //Dataword
    MasterSlave<marker_t> data_word("data_word_chan");
    framer.data_word(data_word);
    environment.data_word(data_word);

    //Oof
    Shared<bool> oof("oof_chan");
    framer.oof(oof);
    monitor.oof(oof);
    //Lof
    Shared<bool> lof("lof_chan");
    framer.lof(lof);
    monitor.lof(lof);
    //frame_puls
    MasterSlave<bool> frame_pulse("frame_puls");
    framer.frame_pulse(frame_pulse);
    monitor.frame_pulse(frame_pulse);

    //Config;
    Shared<Config> config_chan("config_chan");
    monitor.config_in(config_chan);
    environment.config_out(config_chan);

    sc_start();

}