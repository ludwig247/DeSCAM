//
// Created by ludwig on 29.08.17.
//

#ifndef PROJECT_FRAMER_UPDATE_H
#define PROJECT_FRAMER_UPDATE_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"

//FIXME: ALL created types need to be put in a separate file (like FPI example)
struct marker_t {
    bool isMarker;
    int markerAlignment;
};

struct Framer : public sc_module {
    enum Sections {
        INITIALISE, SEARCH, FIND_SYNC, SYNC, MISS
    };
    Sections section;
    Sections nextsection;
    //Constructor
    SC_HAS_PROCESS(Framer);

    Framer(sc_module_name name) :
            frame_pulse("frame_pulse"),
            data_word("data_word"),
            lof("lof"),
            oof("oof"),
            WORDS_IN_FRAME(64),
            frm_cnt(63),
            FRM_PULSE_POS(0),
            section(INITIALISE),
            nextsection(INITIALISE) {
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
        while (true) {
            section = nextsection;
            if (section == INITIALISE) {
                oof->set(true);
                nextsection = SEARCH;
            }

            if (section == SEARCH) {
                //std::cout << "SEARCH" << std::endl;
                newDataWord = data_word->nb_read(data_word_tmp);
                if (newDataWord) {
                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->write(true); //should set frm_pulse_notify active for 1 cycle (independent of frm_pulse_sync)
                    }
                    if (data_word_tmp.isMarker) {
                        align = data_word_tmp.markerAlignment;
                        frm_cnt = 0; //the marker is defined to be the word 0 in the frame
                        nextsection = FIND_SYNC;
                    } else {
                        ++frm_cnt;
                        frm_cnt = frm_cnt % WORDS_IN_FRAME;
                    }
                }
            }
            if (section == FIND_SYNC) {
                //std::cout << "FIND_SYNC" << std::endl;
                newDataWord = data_word->nb_read(data_word_tmp);
                if (newDataWord) {
                    //Notify monitor for 1 clock cycle
                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->write(true);
                    }
                    is_pos = ((frm_cnt + 1) % WORDS_IN_FRAME) == 0;
                    is_align = data_word_tmp.isMarker && align == data_word_tmp.markerAlignment;
                    if (is_pos) {
                        if (!is_align) {
                            nextsection = SEARCH;
                        } else {
                            nextsection = SYNC;
                            oof->set(false);
                        }
                    }

                    ++frm_cnt; //update to point to match the current word id
                    frm_cnt = frm_cnt % WORDS_IN_FRAME;
                }
            }
            if (section == SYNC) {
                //std::cout << "SYNC" << std::endl;
                newDataWord = data_word->nb_read(data_word_tmp);
                if (newDataWord) {

                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->write(true);
                    }
                    is_pos = ((frm_cnt + 1) % WORDS_IN_FRAME) == 0;
                    is_align = data_word_tmp.isMarker && align == data_word_tmp.markerAlignment;
                    if (is_pos) {
                        if (!is_align) {
                            nextsection = MISS;
                        } else {
                            nextsection = SYNC;
                        }
                    }
                    ++frm_cnt; //update to point to match the current word id
                    frm_cnt = frm_cnt % WORDS_IN_FRAME;
                }
            }
            if (section == MISS) {
                //std::cout << "MISS" << std::endl;
                newDataWord = data_word->nb_read(data_word_tmp);
                if (newDataWord) {
                    if (frm_cnt == FRM_PULSE_POS) {
                        frame_pulse->write(true);
                    }
                    is_pos = ((frm_cnt + 1) % WORDS_IN_FRAME) == 0;
                    is_align = data_word_tmp.isMarker && align == data_word_tmp.markerAlignment;
                    if (is_pos) {
                        if (!is_align) {
                            oof->set(true);
                            nextsection = SEARCH;
                        } else {
                            nextsection = SYNC;
                        }
                    }
                    ++frm_cnt; //update to point to match the current word id
                    frm_cnt = frm_cnt % WORDS_IN_FRAME;
                }
            }
            wait(SC_ZERO_TIME);
        }
    }


};


#endif //PROJECT_FRAMER_UPDATE_H
