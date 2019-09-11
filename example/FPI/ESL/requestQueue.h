//
// Created by ludwig on 05.07.17.
//

#ifndef PROJECT_REQUESTQUEUE_H
#define PROJECT_REQUESTQUEUE_H

#include "systemc.h"
#include "Types.h"
#include "../../Interfaces/Interfaces.h"

struct requesteQ : public sc_module {
    enum Sections {
        STARTUP, EMPTY, NON_EMPTY
    };

    Sections section;
    Sections nextsection;

    requesteQ(sc_module_name name) :
            section(STARTUP),
            nextsection(STARTUP),
            status1_var(EMPTY_STATUS),
            status2_var(EMPTY_STATUS),
            status3_var(EMPTY_STATUS) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(requesteQ);

    master_in<req_t> peripheral_request_i; //a new request from peripheral //FIXME: in .vhi it says a new value in each clock cycle
    shared_out<bool> req_o; //the request signal for the master agent

    slave_in<update_t> updateQ_i; //(one-cycle)
    //messages of this port should be read in every cycle
    /*To allow the updateQ_o never to be blocked, it must be ensured that when it writes this side will deal with the message in one cycle.
    All operations should take 1 cycle.
    In all states generated it should read a message (unless it can be shown for the system that a message doesnt come in a state)
    */
    shared_out<req_t> buffer1;
    shared_out<req_t> buffer2;
    shared_out<req_t> buffer3;
    shared_out<req_status_t> status1;
    shared_out<req_status_t> status2;
    shared_out<req_status_t> status3;
    bool tmp_bool_update;
    bool value;
    req_t tmp_buffer;
    update_t tmp_update;
    //shared outs for internal use//
    req_t buffer1_var;
    req_t buffer2_var;
    req_t buffer3_var;
    req_status_t status1_var;
    req_status_t status2_var;
    req_status_t status3_var;

    void fsm() {
        while (true) {
            if (section == STARTUP) {
                status1->set(EMPTY_STATUS);
                status2->set(EMPTY_STATUS);
                status3->set(EMPTY_STATUS);
                req_o->set(false);
                nextsection = EMPTY;
            } else if (section == EMPTY) {
                tmp_bool_update = updateQ_i->nb_read(tmp_update);
                //assert(tmp_bool_update == false); // "Wrong use of updateQ, no requests to update");
                peripheral_request_i->read(buffer1_var);
                status1->set(REQ_STATUS);
                req_o->set(true);
                nextsection = NON_EMPTY;


            } else if (section == NON_EMPTY) {
                tmp_bool_update = updateQ_i->nb_read(tmp_update);
                //assert(tmp_bool_update == false); // "Wrong use of updateQ, no requests to update");
                if (tmp_bool_update) {
                    if (tmp_update == NXT_GRANT_Q) {
                        //assert(status1_var == REQ_STATUS || status2_var == REQ_STATUS || status3_var == REQ_STATUS);// "Wrong use of updateQ NXT_GRANT_Q"
                        //FIXME: what happens if all 3 of them are true?
                        if (status1_var == REQ_STATUS) {
                            status1_var = ADDR_STATUS;
                        } else if (status2_var == REQ_STATUS) {
                            if (status1_var == DATA_STAUS) { //move the Q
                                status1_var = ADDR_STATUS;
                                buffer1_var = buffer2_var;
                                status2_var = status3_var;
                                buffer2_var = buffer3_var;
                                status3_var = EMPTY_STATUS;
                            } else {
                                status1_var = DATA_STAUS;
                                status2_var = ADDR_STATUS;
                            }
                        } else { //status3_var == REQ_STATUS (DATA ADDR REQ)
                            buffer1_var = buffer2_var;
                            buffer2_var = buffer3_var;
                            status3_var = EMPTY_STATUS;
                        }

                    } else if (tmp_update == NXT_PHASE_Q) {
                        //assert(status1_var == ADDR_STATUS || status1_var == DATA_STAUS);//"Wrong use of updateQ NXT_PHASE_Q");
                        if (status1_var == DATA_STAUS) {
                            buffer1_var = buffer2_var;
                            buffer2_var = buffer3_var;
                            //FIXME: What is this good for? status1_var is DATA_STAUS anyways ...
                            if (status2_var == ADDR_STATUS) {
                                status1_var = DATA_STAUS;
                            } else {
                                status1_var = status2_var; //req or empty
                            }
                            status3_var = EMPTY_STATUS;
                        } else if (status1_var == ADDR_STATUS) {
                            status1_var = DATA_STAUS;
                        }

                    } else if (tmp_update == NXT_BTR_Q) {
                        //assert(status1_var == ADDR_STATUS || status2_var == ADDR_STATUS);// "Wrong use of updateQ NXT_BTR_Q");
                        //if a non BTR is ahead, then this is removed, but the BTR itself remains in ADDR (which it does until its last stage)
                        if (status1_var == DATA_STAUS) {
                            buffer1_var = buffer2_var;
                            buffer2_var = buffer3_var;
                            status1_var = ADDR_STATUS;
                            status2_var = status3_var;
                            status3_var = EMPTY_STATUS;
                        }

                    } else { //tmp_update_val==RTY_Q
                        //assert(status1_var == DATA_STAUS);//"Wrong use of updateQ RTY_Q")

                        status1_var = REQ_STATUS;
                        if (status2_var == ADDR_STATUS) {
                            status2_var = REQ_STATUS;
                        }
                    }
                }

                if (status3_var == EMPTY_STATUS) {
                    /*
                     * FIXME: What if status3_var != empty_status?  in this case the port is not read ... I think this case is possible ... because not all paths from update_Q end here
                     * FIXME: Either remove the branch for tmp_bool_update and tmp_bool_req or use an assertion ...
                     * FIXME: I guess that would be a nice example for master_always_ready ... in the meaning of the counterpart is requested to always provide a new value
                     * FIXME: In this case evaluation of the sync is not neccessary ... exactly opposite to the always read out ... this would impose on the counterpart design that all properties are one cycle long
                     * FIXME: Here it's not completly necessary to have all properties to be one cycle long because the other side is required to provide a new value each cycle ...
                     * FIXME:
                    */
                    peripheral_request_i->read(tmp_buffer);
                }

                //FIXME: missing assertion? what if  status1_var != EMPTY_STATUS && status2_var != EMPTY_STATUS ... status3_var doesn't matter then?
                //FIXME: missing assertion tmp_bool_req == true
                //Changed
                if (status1_var == EMPTY_STATUS) {
                    buffer1_var = tmp_buffer;
                    status1_var = REQ_STATUS;
                } else if (status2_var == EMPTY_STATUS) {
                    buffer2_var = tmp_buffer;
                    status2_var = REQ_STATUS;
                } else { // (status3_var==EMPTY_STATUS)
                    buffer3_var = tmp_buffer;
                    status3_var = REQ_STATUS;
                }
            } else {
                if (status1_var == EMPTY_STATUS) {
                    nextsection = EMPTY;
                }
                value = status1_var == REQ_STATUS || status2_var == REQ_STATUS || status3_var == REQ_STATUS;
                req_o->set(value);
                buffer1->set(buffer1_var);
                buffer2->set(buffer2_var);
                buffer3->set(buffer3_var);
                status1->set(status1_var);
                status2->set(status2_var);
                status3->set(status3_var);
            }
        }
    }

};

#endif //PROJECT_REQUESTQUEUE_H
