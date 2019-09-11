//
// Created by tobias on 13.06.17.
//

//TODO){ fix ports){ master_done, wait_cnt_end ... was sollen die genau tun?


#ifndef PROJECT_FPI_MASTER_H
#define PROJECT_FPI_MASTER_H

#include "systemc.h"

#include "Types.h"
#include "../../Interfaces/Interfaces.h"
//#include "../../SingleMasterMultiSlave/ESL/Compound.h"

#define is_BTR(opc) (opc==BTR2_OPC || opc==BTR4_OPC || opc==BTR8_OPC)

struct FPI_Master : public sc_module {

    enum Sections {
        IDLE, ADDR, DATA, DATA_ADDR, BTR_CONT, WAIT_BEFORE_RETRY
    };

    Sections section;
    Sections nextsection;

    //Constructor
    FPI_Master(sc_module_name name):
                section(IDLE),
                nextsection(IDLE),
                ready_i("ready_i"),
                gnt_i("gnt_i"),
                ack_i("ack_i"),
                data_i("data_i"),
                addr_en_o("addr_en_o"),
                opc_o("opc_o"),
                addr_o("addr_o"),
                abort_en_o("abort_en_o"),
                abort_o("abort_o"),
                data_en_o("data_en_o"),
                data_o("data_o"),
                updateQ_o("updateQ_o"),
                buffer1("buffer1"),
                buffer2("buffer2"),
                buffer3("buffer3"),
                status1("status1"),
                status2("status2"),
                status3("status3"),
                master_result_o("master_result_o"),
                master_done("master_done"){
                    SC_THREAD(fsm);
                }
        SC_HAS_PROCESS(FPI_Master);


            //Ports
        synch_in ready_i;
        shared_in<bool> gnt_i;
        shared_in<ack_t> ack_i;
        shared_in<int> data_i;

        shared_out<bool> addr_en_o;
        shared_out<opc_t> opc_o;
        shared_out<int> addr_o;
        shared_out<bool> abort_en_o;
        shared_out<bool> abort_o;
        shared_out<bool> data_en_o;
        shared_out<int> data_o;

        blocking_out<update_t> updateQ_o; // (1-cycle never blocks)
        shared_in<req_t> buffer1;
        shared_in<req_t> buffer2;
        shared_in<req_t> buffer3;
        shared_in<req_status_t> status1;
        shared_in<req_status_t> status2;
        shared_in<req_status_t> status3;

        //TODO: master_done was missing?
        blocking_out<result_t> master_done;
        synch_out master_result_o; // (1-cycle never blocks)
        shared_in<bool> wait_cnt_end;

        //Vars
        int btrCnt;
        bool nop ;
        bool gnt ;
        //dump vars
        bool tmp_bool;
        result_t result_tmp;
        //req_t nxtActive_tmp;
        ack_t ack;

        bool updateQ_cycle_tmp;
        update_t updateQ_msg_tmp;

        req_t buffer1_tmp;
        req_t buffer2_tmp;
        req_t buffer3_tmp;
        req_status_t status1_tmp;
        req_status_t status2_tmp;
        req_status_t status3_tmp;

        int temp_var;

        void fsm() {
            while (true) {
                section = nextsection;
                if (section == IDLE) {
                    ready_i->req(); //block until ready
                    updateQ_cycle_tmp = false;
                    buffer1->get(buffer1_tmp);
                    buffer2->get(buffer2_tmp);
                    buffer3->get(buffer3_tmp);
                    status1->get(status1_tmp);
                    status2->get(status2_tmp);
                    status3->get(status3_tmp);


                    //drive dataphase with nop, if last was a nop address phase
                    if (nop) {
                        abort_en_o->set(true);
                        abort_o->set(false);
                        data_en_o->set(true);
                        data_o->set(0);
                    } else {
                        abort_en_o->set(false);
                        data_en_o->set(false);
                    }

                    //address phase
                    if (gnt) {
                        if (status1_tmp == REQ_STATUS) { //pending req
                            updateQ_cycle_tmp = true;
                            updateQ_msg_tmp = NXT_GRANT_Q;
                            addr_en_o->set(true);
                            addr_o->set(buffer1_tmp.addr);
                            opc_o->set(buffer1_tmp.opc);
                            nop = false;
                            nextsection = ADDR;
                        } else {
                            addr_en_o->set(true);
                            addr_o->set(0);
                            opc_o->set(NOP_OPC);
                            nop = true;
                        }
                    } else {
                        addr_en_o->set(false);
                        nop = false;
                    }

                    if (updateQ_cycle_tmp) { updateQ_o->write(updateQ_msg_tmp); }


                }
                else if (section == ADDR) { //buffer1 is the active one
                    ready_i->req(); //block until ready
                    updateQ_cycle_tmp = false;
                    buffer1->get(buffer1_tmp);
                    buffer2->get(buffer2_tmp);
                    buffer3->get(buffer3_tmp);
                    status1->get(status1_tmp);
                    status2->get(status2_tmp);
                    status3->get(status3_tmp);

                    //drive dataphase according to active1
                    abort_en_o->set(true);
                    abort_o->set(buffer1_tmp.abort);
                    if (buffer1_tmp.opc == WRITE_OPC) {
                        data_en_o->set(true);
                        data_o->set(buffer1_tmp.data);
                    } else {
                        data_en_o->set(false);
                    }

                    //address phase
                    if (gnt) {
                        if (is_BTR(buffer1_tmp.opc)) { //the current is BTR, so cannot grant a new
                            updateQ_cycle_tmp = true;
                            updateQ_msg_tmp = NXT_BTR_Q;
                            addr_en_o->set(true);
                            addr_o->set(buffer1_tmp.addr + 1);
                            opc_o->set(buffer1_tmp.opc);
                            nextsection = BTR_CONT;
                            btrCnt = 0;
                        } else {
                            if (status2_tmp == REQ_STATUS) {
                                updateQ_cycle_tmp = true;
                                updateQ_msg_tmp = NXT_GRANT_Q;
                                addr_en_o->set(true);
                                addr_o->set(buffer2_tmp.addr);
                                opc_o->set(buffer2_tmp.opc);
                                nop = false;
                                nextsection = DATA_ADDR;
                            } else {
                                updateQ_cycle_tmp = true;
                                updateQ_msg_tmp = NXT_PHASE_Q;
                                addr_en_o->set(true);
                                addr_o->set(0);
                                opc_o->set(NOP_OPC);
                                nop = true;
                                nextsection = DATA;
                            }
                        }
                    } else {
                        updateQ_cycle_tmp = true;
                        updateQ_msg_tmp = NXT_PHASE_Q;
                        addr_en_o->set(false);
                        nop = false;
                        nextsection = DATA;
                    }

                    if (updateQ_cycle_tmp) { updateQ_o->write(updateQ_msg_tmp); }


                }
                else if (section == DATA) {
                    ready_i->req(); //block until ready
                    updateQ_cycle_tmp = false;
                    buffer1->get(buffer1_tmp);
                    buffer2->get(buffer2_tmp);
                    buffer3->get(buffer3_tmp);
                    status1->get(status1_tmp);
                    status2->get(status2_tmp);
                    status3->get(status3_tmp);

                    //drive dataphase with nop, if last was a nop address phase
                    if (nop) {
                        abort_en_o->set(true);
                        abort_o->set(false);
                        data_en_o->set(true);
                        data_o->set(0);
                    } else {
                        abort_en_o->set(false);
                        data_en_o->set(false);
                    }

                    //unless retry, fwd result to peripheral
                    if (ack == RTY && !(is_BTR(buffer1_tmp.opc) || buffer1_tmp.opc != RMW_OPC)) {
                        updateQ_cycle_tmp = true;
                        updateQ_msg_tmp = RTY_Q;
                        nextsection = WAIT_BEFORE_RETRY;
                        nop = gnt;
                    } else {
                        result_tmp.err = (ack != OK);
                        data_i->get(result_tmp.data);
                        master_done->nb_write(result_tmp);

                        if (gnt) {
                            if (status2_tmp == REQ_STATUS) {
                                updateQ_cycle_tmp = true;
                                updateQ_msg_tmp = NXT_GRANT_Q;
                                addr_en_o->set(true);
                                addr_o->set(buffer2_tmp.addr);
                                opc_o->set(buffer2_tmp.opc);
                                nop = false;
                                nextsection = ADDR;
                            } else {
                                updateQ_cycle_tmp = true;
                                updateQ_msg_tmp = NXT_PHASE_Q;
                                addr_en_o->set(true);
                                addr_o->set(0);
                                opc_o->set(NOP_OPC);
                                nop = true;
                                nextsection = IDLE;
                            }
                        } else {
                            updateQ_cycle_tmp = true;
                            updateQ_msg_tmp = NXT_PHASE_Q;
                            addr_en_o->set(false);
                            nop = false;
                            nextsection = IDLE;
                        }

                    }
                    if (updateQ_cycle_tmp) { updateQ_o->write(updateQ_msg_tmp); }


                }
                else if (section == DATA_ADDR) {
                    ready_i->req(); //block until ready
                    updateQ_cycle_tmp = false;
                    buffer1->get(buffer1_tmp);
                    buffer2->get(buffer2_tmp);
                    buffer3->get(buffer3_tmp);
                    status1->get(status1_tmp);
                    status2->get(status2_tmp);
                    status3->get(status3_tmp);

                    if (ack == RTY && !(is_BTR(buffer1_tmp.opc) || buffer1_tmp.opc != RMW_OPC)) {
                        abort_en_o->set(true);
                        abort_o->set(true);
                        if (buffer2_tmp.opc == WRITE_OPC) {
                            data_en_o->set(true);
                            data_o->set(0);
                        } else {
                            data_en_o->set(false);
                        }
                    } else {
                        abort_en_o->set(true);
                        abort_o->set(buffer2_tmp.abort);
                        if (buffer2_tmp.opc == WRITE_OPC) {
                            data_en_o->set(true);
                            data_o->set(buffer2_tmp.data);
                        } else {
                            data_en_o->set(false);
                        }
                    }

                    //unless retry, fwd result to peripheral
                    if (ack == RTY && !(is_BTR(buffer1_tmp.opc) || buffer1_tmp.opc != RMW_OPC)) {
                        updateQ_cycle_tmp = true;
                        updateQ_msg_tmp = RTY_Q;
                        nextsection = WAIT_BEFORE_RETRY;
                        if (gnt) {
                            nop = true;
                            addr_en_o->set(true);
                            addr_o->set(0);
                            opc_o->set(NOP_OPC);
                        } else {
                            addr_en_o->set(false);
                            nop = false;
                        }
                    } else {
                        result_tmp.err = (ack != OK);
                        data_i->get(result_tmp.data);

                        master_done->nb_write(result_tmp);

                        if (gnt) {
                            if (is_BTR(buffer2_tmp.opc)) {
                                updateQ_cycle_tmp = true;
                                updateQ_msg_tmp = NXT_BTR_Q;
                                addr_en_o->set(true);
                                addr_o->set(buffer2_tmp.addr + 1);
                                opc_o->set(buffer2_tmp.opc);
                                nextsection = BTR_CONT;
                                btrCnt = 0;
                            } else {
                                if (status3_tmp == REQ_STATUS) {
                                    updateQ_cycle_tmp = true;
                                    updateQ_msg_tmp = NXT_GRANT_Q;
                                    addr_en_o->set(true);
                                    addr_o->set(buffer3_tmp.addr);
                                    opc_o->set(buffer3_tmp.opc);
                                    nop = false;
                                    nextsection = DATA_ADDR;
                                } else {
                                    updateQ_cycle_tmp = true;
                                    updateQ_msg_tmp = NXT_PHASE_Q;
                                    addr_en_o->set(true);
                                    addr_o->set(0);
                                    opc_o->set(NOP_OPC);
                                    nop = true;
                                    nextsection = DATA;
                                }
                            }
                        } else {
                            addr_en_o->set(false);
                            nop = false;
                            nextsection = DATA;
                        }

                    }
                    if (updateQ_cycle_tmp) { updateQ_o->write(updateQ_msg_tmp); }


                }
                else if (section == BTR_CONT) {
                    ready_i->req(); //block until ready
                    updateQ_cycle_tmp = false;
                    buffer1->get(buffer1_tmp);
                    buffer2->get(buffer2_tmp);
                    buffer3->get(buffer3_tmp);
                    status1->get(status1_tmp);
                    status2->get(status2_tmp);
                    status3->get(status3_tmp);

                    if (btrCnt == 0 && ack == RTY) {
                        abort_en_o->set(true);
                        abort_o->set(true);
                        data_en_o->set(false);
                    } else {
                        //drive dataphase
                        abort_en_o->set(true);
                        abort_o->set(false);
                        data_en_o->set(false);
                    }

                    //unless retry in first, fwd result to peripheral and continue
                    if (btrCnt == 0 && ack == RTY) {
                        updateQ_cycle_tmp = true;
                        updateQ_msg_tmp = RTY_Q;
                        nextsection = WAIT_BEFORE_RETRY;
                        if (gnt) {
                            addr_en_o->set(true);
                            addr_o->set(0);
                            opc_o->set(NOP_OPC);
                            nop = true;
                        } else {
                            addr_en_o->set(false);
                            nop = false;
                        }
                    } else {
                        result_tmp.err = (ack != OK);
                        data_i->get(result_tmp.data);
                        master_done->nb_write(result_tmp);
                        btrCnt = btrCnt + 1;

                        if ((buffer1_tmp.opc == BTR2_OPC && btrCnt == 1) || (buffer1_tmp.opc == BTR4_OPC && btrCnt == 3) || (buffer1_tmp.opc == BTR8_OPC && btrCnt == 7)) {
                            if (gnt) {
                                if (status2_tmp == REQ_STATUS) {
                                    updateQ_cycle_tmp = true;
                                    updateQ_msg_tmp = NXT_GRANT_Q;
                                    addr_en_o->set(true);
                                    addr_o->set(buffer2_tmp.addr);
                                    opc_o->set(buffer2_tmp.opc);
                                    nop = false;
                                    nextsection = DATA_ADDR;
                                } else {
                                    updateQ_cycle_tmp = true;
                                    updateQ_msg_tmp = NXT_PHASE_Q;
                                    addr_en_o->set(true);
                                    addr_o->set(0);
                                    opc_o->set(NOP_OPC);
                                    nop = true;
                                    nextsection = DATA;
                                }
                            } else {
                                updateQ_cycle_tmp = true;
                                updateQ_msg_tmp = NXT_PHASE_Q;
                                addr_en_o->set(false);
                                nop = false;
                                nextsection = DATA;
                            }

                        } else {
                            if (gnt) {
                                addr_en_o->set(true);

                                addr_o->set(buffer1_tmp.addr + btrCnt + 1);
                                opc_o->set(buffer1_tmp.opc);
                            } else {
                                //assert(false);// "BCU should have granted within a block transfer"); //should not be reachable, BCU lock should ensure a grant
                            }
                        }


                    }
                    if (updateQ_cycle_tmp) { updateQ_o->write(updateQ_msg_tmp); }

                }
                else if (section == WAIT_BEFORE_RETRY) {
                    ready_i->req(); //block until ready

                    //drive dataphase with nop, if last was a nop address phase
                    if (nop) {
                        abort_en_o->set(true);
                        abort_o->set(false);
                        data_en_o->set(true);
                        data_o->set(0);
                    } else {
                        abort_en_o->set(false);
                        data_en_o->set(false);
                    }

                    if (gnt) {
                        addr_en_o->set(true);
                        addr_o->set(0);
                        opc_o->set(NOP_OPC);
                        nop = true;
                    } else {
                        addr_en_o->set(false);
                        nop = false;
                    }
                    wait_cnt_end->get(tmp_bool);
                    if (tmp_bool) {
                        nextsection = IDLE;
                    }
                }
                wait(SC_ZERO_TIME);
            }
        }


    };


#endif //PROJECT_FPI_MASTER_H
