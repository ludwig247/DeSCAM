#ifndef PROJECT_FRAMER_H
#define PROJECT_FRAMER_H

#include "systemc.h"
#include "../../../Interfaces/Interfaces.h"

enum status_t {
    in_frame, oof_frame
};
struct msg_t {
    status_t status;
    int data;
};

SC_MODULE(Example) {
    SC_CTOR(Example) :
            nextsection(idle) {SC_THREAD(fsm)};
    enum Sections {
        idle, frame_start, frame_data, unreachable
    };
    Sections section, nextsection;
    blocking_in<msg_t> b_in;
    master_out<int> m_out;
    shared_out<bool> s_out;
    int cnt;
    bool ready;
    msg_t msg;
	//bool unreachable;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == idle) {
                s_out->set(false);
                b_in->read(msg);
                if (msg.status == in_frame) {
                    s_out->set(true);
                    nextsection = frame_start;
                    cnt = 3;
                }
            } else if (section == frame_start) {
                m_out->write(cnt);
                cnt = cnt - 1;
                if (cnt == 0) {
                    cnt = 15;
                    nextsection = frame_data;
                }
            } else if (section == frame_data) {
                ready = b_in->nb_read(msg);
                if (!ready) {
                    m_out->write(msg.data);
                    if (cnt == 0) { 
						nextsection = idle;
					}
                    cnt = cnt - 1;
                }
            } else if (section == unreachable) {
				b_in->read(msg);
				nextsection = idle;
			}
        }
    }
};

#endif //PROJECT_FRAMER_H
