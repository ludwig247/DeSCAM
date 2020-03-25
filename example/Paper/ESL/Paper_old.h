//
// Created by tobias on 27.04.18.
//

#ifndef PROJECT_PAPER_H
#define PROJECT_PAPER_H
//Enum Datatype
#include "systemc.h"
#include "Interfaces.h"


enum status_t{in_frame,oof_frame};
struct msg_t{status_t status;int data;};

struct Example : public sc_module {
	//Constructor
	SC_CTOR(Example):
			nextsection(idle){SC_THREAD(fsm)};
	//Sections
	enum Sections  {idle,frame_start,frame_data};
	Sections section,nextsection;
	//Ports
	blocking_in<msg_t> b_in;
	master_out<int>m_out;
	shared_out<bool> s_out;
	//Variables
	int cnt;bool ready;msg_t msg;
	void fsm(){
		while(true) {
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
				cnt=cnt-1;
				if (cnt == 0) {
					cnt = 15;
					nextsection = frame_data;
				}
			} else if (section == frame_data) {
				ready = b_in->nb_read(msg);
				if (!ready) {
					m_out->write(msg.data);
					if (cnt == 0) { nextsection = idle; }
					cnt = cnt - 1;
				}
			}
		}}};

#endif //PROJECT_PAPER_H
