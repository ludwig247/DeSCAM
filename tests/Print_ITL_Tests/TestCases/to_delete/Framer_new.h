//
// Created by ludwig on 29.08.17.
//

#ifndef PROJECT_FRAMER_UPDATE_H
#define PROJECT_FRAMER_UPDATE_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

//FIXME: ALL created types need to be put in a separate file (like FPI example)
struct marker_t {
    bool isMarker;
    int markerAlignment;
};

struct Framer_new : public sc_module {
    enum Phases {
        INITIALISE, SEARCH, FIND_SYNC, SYNC, MISS
    };
    Phases phase;
    Phases nextphase;
    //Constructor
    SC_HAS_PROCESS(Framer_new);

    Framer_new(sc_module_name name) :
            frame_pulse("frame_pulse"),
            data_word("data_word"),
            lof("lof"),
            oof("oof"),
            WORDS_IN_FRAME(64),
            frm_cnt(63),
            FRM_PULSE_POS(0) {
        SC_THREAD(fsm);
    }

    //In-port
    slave_in<marker_t> data_word;
    shared_in<bool> lof;
    //Output
    master_out<bool> frame_pulse;
    shared_out<bool> oof;

    //Visible Registers
    int align;
    int frm_cnt;
    marker_t data_word_tmp;

    //Constants
    int FRM_PULSE_POS;
    int WORDS_IN_FRAME;

    //TMP Vars
    bool newDataWord;
    bool is_pos;
    bool is_align;

    void fsm() {
        nextphase = INITIALISE;
        while (true) {
            phase = nextphase;
            if (phase == INITIALISE) {
                oof->set(true);
                nextphase = SEARCH;
            }

            else if (phase == SEARCH) {
                //std::cout << "SEARCH" << std::endl;
                wait(WAIT_TIME, SC_PS);//state
                data_word->slave_read(data_word_tmp, newDataWord);
                if (newDataWord) {
                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->master_write(true); //should set frm_pulse_notify active for 1 cycle (independent of frm_pulse_sync)
                    }
                    if (data_word_tmp.isMarker) {
                        align = data_word_tmp.markerAlignment;
                        frm_cnt = 0; //the marker is defined to be the word 0 in the frame
                        nextphase = FIND_SYNC;
                    } else {
                        ++frm_cnt;
                        frm_cnt = frm_cnt % WORDS_IN_FRAME;
                    }
                }
            }
            else if (phase == FIND_SYNC) {
                //std::cout << "FIND_SYNC" << std::endl;
                wait(WAIT_TIME, SC_PS);//state
                data_word->slave_read(data_word_tmp, newDataWord);
                if (newDataWord) {
                    //Notify monitor for 1 clock cycle
                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->master_write(true);
                    }
                    is_pos = ((frm_cnt + 1) % WORDS_IN_FRAME) == 0;
                    is_align = data_word_tmp.isMarker && align == data_word_tmp.markerAlignment;
                    if (is_pos) {
                        if (!is_align) {
                            nextphase = SEARCH;
                        } else {
                            nextphase = SYNC;
                            oof->set(false);
                        }
                    }

                    ++frm_cnt; //update to point to match the current word id
                    frm_cnt = frm_cnt % WORDS_IN_FRAME;
                }
            }
            else if (phase == SYNC) {
                //std::cout << "SYNC" << std::endl;
                wait(WAIT_TIME, SC_PS);//state
                data_word->slave_read(data_word_tmp, newDataWord);
                if (newDataWord) {

                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->master_write(true);
                    }
                    is_pos = ((frm_cnt + 1) % WORDS_IN_FRAME) == 0;
                    is_align = data_word_tmp.isMarker && align == data_word_tmp.markerAlignment;
                    if (is_pos) {
                        if (!is_align) {
                            nextphase = MISS;
                        } else {
                            nextphase = SYNC;
                        }
                    }
                    ++frm_cnt; //update to point to match the current word id
                    frm_cnt = frm_cnt % WORDS_IN_FRAME;
                }
            }
            else if (phase == MISS) {
                //std::cout << "MISS" << std::endl;
                wait(WAIT_TIME, SC_PS);//state
                data_word->slave_read(data_word_tmp, newDataWord);
                if (newDataWord) {
                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->master_write(true);
                    }
                    is_pos = ((frm_cnt + 1) % WORDS_IN_FRAME) == 0;
                    is_align = data_word_tmp.isMarker && align == data_word_tmp.markerAlignment;
                    if (is_pos) {
                        if (!is_align) {
                            oof->set(true);
                            nextphase = SEARCH;
                        } else {
                            nextphase = SYNC;
                        }
                    }
                    ++frm_cnt; //update to point to match the current word id
                    frm_cnt = frm_cnt % WORDS_IN_FRAME;
                }
            }
            else{}
            wait(SC_ZERO_TIME);
        }
    }


};


#endif //PROJECT_FRAMER_UPDATE_H
