//
// Created by tobias on 27.04.18.
//

#ifndef PROJECT_PAPER_H
#define PROJECT_PAPER_H
//Enum Datatype
#include "systemc.h"
#include "../../Interfaces/Interfaces.h"


enum status_t{in_frame,oof_frame};
struct msg_t{status_t status;int data;};

struct Example : public sc_module {
	//Constructor
	SC_CTOR(Example) {
	    SC_THREAD(fsm);
	}
	//Sections
	enum Phase{idle,frame_start,frame_data};
	Phase currentPhase, nextPhase;
	//Ports
	blocking_in<msg_t> b_in;
	master_out<int>m_out;
	shared_out<bool> s_out;
	//Variables
	int cnt;bool ready;msg_t msg;
	void fsm(){
		nextPhase = idle;
		while(true) {
			currentPhase = nextPhase;
			if (currentPhase == idle) {
				s_out->set(false);
				b_in->read(msg);
				if (msg.status == in_frame) {
					s_out->set(true);
					nextPhase = frame_start;
					cnt = 3;
				}
			} else if (currentPhase == frame_start) {
				m_out->master_write(cnt);
				cnt=cnt-1;
				if (cnt == 0) {
					cnt = 15;
					nextPhase = frame_data;
				}
			} else if (currentPhase == frame_data) {
                b_in->try_read(msg,ready);
				if (!ready) {
					m_out->master_write(msg.data);
                    cnt = cnt - 1;
                    if (cnt == 0) {
                        nextPhase = idle;
                    }
				}
			}
		}}};

#endif //PROJECT_PAPER_H
