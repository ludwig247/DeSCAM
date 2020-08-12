//
// Created by ludwig on 08.08.18.
//

#ifndef PROJECT_MASTER_H
#define PROJECT_MASTER_H

#include "systemc.h"
#include "Interfaces.h"

enum status_t{none,start,stop};
struct bus_input_t{
    status_t status;
    int addr;
    bool read;
    int data;
};
class Master: public sc_module{
public:
    SC_CTOR(Master):
    nextsection(idle){SC_THREAD(fsm)};
    enum Sections  {setup,idle,write,read, request};
    Sections section,nextsection;

    //Communcation from bus
    blocking_in<bus_input_t> data_from_bus;
    blocking_in<status_t> status_in;
    blocking_in<bool> ack_in;

    //Communication to bus
    blocking_out<int> data_to_bus;
    blocking_out<bool> ack_out;

    //Communication with outside
    shared_out<int> data_out;
    shared_in<int> data_in;
    shared_in<int> device_id_in;

    status_t status;
    bus_input_t bus_input;
    //req_t req;
    int data;
    int device_addr;
    bool ack;

    /* Notes:
     * 1) For now no arbirtration, because we only consider single master systems
     * 2) General call addresses are not implemented
     * 3)
     */
    void fsm() {
        while (true) {
            section = nextsection;
            if (section == setup) {
                //Setting the devide id (init through constructor not possible, yet)
                device_id_in->get(device_addr);
                nextsection = idle;
            } else if (section == idle) {
                //Wait for start condition
                status_in->read(status);
                //Received condition
                if (status == start) nextsection = request;

            } else if (section == request) {
                /*Request phase: 8 bits received
                 * bit 0 to 6 : address send by the master
                 * bit 7: mode -> high:read; low:write
                */
                data_from_bus->read(bus_input);
                nextsection = idle;
                //Target me? read or write?
                if (bus_input.addr == device_addr && bus_input.read) nextsection = read;
                else if (bus_input.addr == device_addr && !bus_input.read) nextsection = write;
                //Acknowledge receiption of addr+mode
                ack_out->write(true);
            } else if (section == write) {
                //Read the data from somewhere, e.g. a buffer
                data_in->get(data);
                //Write the data to the bus
                data_to_bus->write(data);
                //Get ACK from master
                ack_in->read(ack);
                //If master signales NACK change to idle and wait for start condition
                if (!ack) {
                    status_in->read(status);
                    if (status == start) nextsection = request;
                    else if (status == stop) nextsection = idle;
                    nextsection = idle;
                }
                //else continue sending data. //FIXME: what happens if slave is out of data?
            } else if (section == read) {
                //Read data byte from bus
                data_from_bus->read(bus_input);
                /* Case 1: start bit received go back to request
                 * Case 2: stop bit received go back to idle
                 * Case 3: none bit: read next byte
                 */
                //acknowledge transaction ... for now no nack
                ack_out->write(true);
                //Send the received data somewhere, e.g. a buffer
                data_out->set(bus_input.data);
                status_in->read(status);
                if (status == start) nextsection = request;
                else if (status == stop) nextsection = idle;
            }
	}
    }
};

#endif //PROJECT_SLAVE_H
