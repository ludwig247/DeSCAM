//
// Created by tobias on 11.12.19.
//

#ifndef DESCAM_IMPORTANTSTATE_H
#define DESCAM_IMPORTANTSTATE_H

#include "systemc.h"

//#define WAIT_TIME std::rand()%5
//#define WAIT_TIME std::rand()%5
#define WAIT_TIME 0
#define important_state  wait(WAIT_TIME, SC_PS);

void insert_state(std::string stateName){
    important_state;
}

void insert_state(){
    important_state;
}
#endif //DESCAM_IMPORTANTSTATE_H
