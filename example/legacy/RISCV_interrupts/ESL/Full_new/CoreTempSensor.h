//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

/*
 * Processor tempreture sensor
 * Used to generate a Local Interrupts in case of overheat
 * - Contains Tcur, Tthreshold memory mapped registers.
 */

#ifndef PROJECT_CORE_TEMP_SENSOR_H
#define PROJECT_CORE_TEMP_SENSOR_H

#include "systemc.h"
#include "Interfaces.h"
#include "Memory_Interfaces.h"
#include "Defines.h"
#include <stdint.h>
#include <scv.h>


class CoreTempSensor : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(CoreTempSensor);

    CoreTempSensor(sc_module_name name) :
            ML12I_port("ML12I_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            rec(false),
            randTemp("randTemp"),
            Tcur(0),
            Tthreshold(100)
    {
        scv_bag< int > field_dist;
        field_dist.add(49, 600000);
        field_dist.add(55, 1);
        randTemp->set_mode(field_dist);
        SC_THREAD(manage_memory);
        SC_THREAD(run);
    }

    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    slave_out<bool> ML12I_port;
    scv_smart_ptr<int> randTemp;
    signed int Tcur;
    signed int Tthreshold;
    bool rec;

    void readTempreture(signed int & Temp);
    void run(); // thread
    void manage_memory();
};

void CoreTempSensor::readTempreture(signed int & Temp){
    randTemp->next();
    Temp = *randTemp;
}

void CoreTempSensor::run() {
    while (true) {
        readTempreture(Tcur);
        // set local interrupt status
        if (Tcur > Tthreshold) {
            ML12I_port->nb_write(true);
        } else {
            ML12I_port->nb_write(false);
        }
    }
}

void CoreTempSensor::manage_memory() {
    while (true) {
        MEtoCP_data.loadedData = 0;

        COtoME_port->read(CPtoME_data); //Wait for next request

        if (CPtoME_data.addrIn < CORETEMPSENSOR_START_ADDR && CPtoME_data.addrIn > CORETEMPSENSOR_END_ADDR) {
            cout << "@CORETEMPSENSOR: Accessing out of bound. Terminating!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }

        if (CPtoME_data.req == ME_RD) { // LOAD
            if (CPtoME_data.addrIn == CORETEMPSENSOR_Tthreshold_ADDR) {
                MEtoCP_data.loadedData = static_cast<unsigned int>(Tthreshold);
                MEtoCO_port->write(MEtoCP_data);
            }
            else if (CPtoME_data.addrIn == CORETEMPSENSOR_Tcur_ADDR) {
                MEtoCP_data.loadedData = static_cast<unsigned int>(Tcur);
                MEtoCO_port->write(MEtoCP_data);
            } else {
#if SCAM == 0
                cout << "@CORETEMPSENSOR: Unauthorized read. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }
        } else if (CPtoME_data.req == ME_WR) {
            if (CPtoME_data.addrIn == CORETEMPSENSOR_Tthreshold_ADDR)
                Tthreshold = CPtoME_data.dataIn;
            else {
#if SCAM == 0
                cout << "@CORETEMPSENSOR: Unauthorized write. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }
        } else {
#if SCAM == 0
            throw std::logic_error(std::string("@CORETEMPSENSOR: Undefined memory's req value."));
#endif
        }
    }
}

#endif  // PROJECT_CORE_TEMP_SENSOR_H