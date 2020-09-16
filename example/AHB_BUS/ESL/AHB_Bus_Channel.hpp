//
// Created by wezel on 2/18/20.
//

#ifndef DESCAM_AHB_BUS_CHANNEL_HPP
#define DESCAM_AHB_BUS_CHANNEL_HPP


AHB_Bus_Channel::AHB_Bus_Channel (const char *name) :
        sc_prim_channel(name),
        state(MASTER_REQ),
        master_id(10),
        slave_id(10),
        req({0,0}),
        resp({0,0}),
        fromReset(true)
        {
        }

void AHB_Bus_Channel::access_bus(const bus_req_t &val, bus_resp_t &out, unsigned int id){
    if(fromReset){
        wait(dummy_master);
    }
    if(state != MASTER_REQ){
        wait(master_read_notify);
    }
    while(true){
        if(master_id > id){
            master_id = id;
            if (val.haddr >= SLAVE0_START && val.haddr < SLAVE0_END) {
                slave_id = 0;
            } else {//if (val.haddr >= SLAVE1_START && val.haddr < SLAVE1_END) {
                slave_id = 1;
            }

            req.hwdata = val.hwdata;
            req.haddr = val.haddr;
            master_dummy.notify();
            wait(dummy_master);
            if(master_id != id) continue;
            state = SLAVE_REQ;
            master_write_notify.notify();
            wait(slave_write_notify);

            out.hrdata = resp.hrdata;
            out.hresp = resp.hresp;
            state = MASTER_REQ;
            master_id = 10;
            slave_id = 10;
            master_read_notify.notify();
            return;
        }
        else{
            wait(master_read_notify);
        }
    }
}
//void AHB_Bus_Channel::write_master(const bus_req_t &val, int id) {
//    if(fromReset){
//        wait(dummy_master);
//    }
//    if(state != MASTER_REQ){
//        wait(master_read_notify);
//    }
//    while(true) {
//        if (master_id > id) {
//            master_id = id;
//            if (val.haddr >= SLAVE0_START && val.haddr < SLAVE0_END) {
//                slave_id = 0;
//            } else if (val.haddr >= SLAVE1_START && val.haddr < SLAVE1_END) {
//                slave_id = 1;
//            } else if (val.haddr >= SLAVE2_START && val.haddr < SLAVE2_END) {
//                slave_id = 2;
//            } else if (val.haddr >= SLAVE3_START && val.haddr < SLAVE3_END) {
//                slave_id = 3;
//            }
//            req.hwdata = val.hwdata;
//            req.haddr = val.haddr;
//            master_dummy.notify();
//            wait(dummy_master);
//            if(master_id != id) continue;
//            state = SLAVE_REQ;
//            master_write_notify.notify();
//            return;
//        }
//        else{
//            wait(master_read_notify);
//        }
//    }
//}

void AHB_Bus_Channel::handle_request(bus_req_t &out, const bus_resp_t &val, int id){
    if(state != SLAVE_REQ){
        wait(master_write_notify);
    }
    while(true) {
        if (slave_id == id) {
            //Request
            out.hwdata = req.hwdata;
            out.haddr = req.haddr;
            //Response
            resp.hrdata = val.hrdata;
            resp.hresp = val.hresp;
            state = MASTER_RESP;
            slave_write_notify.notify();
            return;
        }
        else{
            wait(master_write_notify);
        }
    }
}

void AHB_Bus_Channel::read_slave(bus_req_t &out, int id) {
    if(state != SLAVE_REQ){
        wait(master_write_notify);
    }
    while(true) {
        if (slave_id == id) {
            out.hwdata = req.hwdata;
            out.haddr = req.haddr;
            state = SLAVE_RESP;
            slave_read_notify.notify();
            return;
        }
        else{
            wait(master_write_notify);
        }
    }
}

void AHB_Bus_Channel::write_slave(const bus_resp_t &val, int id) {
    if(state != SLAVE_RESP){
        wait(slave_read_notify);
    }
    while(true) {
        if (slave_id == id) {
            resp.hrdata = val.hrdata;
            resp.hresp = val.hresp;
            state = MASTER_RESP;
            slave_write_notify.notify();
            return;
        }
        else{
            wait(slave_read_notify);
        }
    }
}

//void AHB_Bus_Channel::read_master(bus_resp_t &out, int id) {
//    if(state != MASTER_RESP){
//        wait(slave_write_notify);
//    }
//    while(true){
//        if(master_id == id){
//            out.hrdata = resp.hrdata;
//            out.hresp = resp.hresp;
//            state = MASTER_REQ;
//            master_id = 10;
//            slave_id = 10;
//            master_read_notify.notify();
//            return;
//        }
//        else{
//            wait(slave_write_notify);
//        }
//    }
//}

void AHB_Bus_Channel::dummyFunc(){
    fromReset = false;
    while(true){
        dummy_master.notify();
        wait(master_dummy);
    }
}

#endif //#DESCAM_AHB_BUS_CHANNEL_HPP
