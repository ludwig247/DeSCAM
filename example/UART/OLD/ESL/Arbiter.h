//
// Created by ovsthus on 2/1/19.
//

#ifndef UART_ARBITER_H
#define UART_ARBITER_H

#include "systemc.h"
#include "Interfaces.h"


#define MSB 128
#define LSB 1





class Arbiter : public sc_module {
public:

    SC_HAS_PROCESS(Arbiter);

    enum Sections {SCAN, SELECT,PARITY_SKIP ,TRANSFER, END};


    Sections section, nextsection;


    master_in<bool> trigg1;
    master_in<bool> trigg2;
    master_in<bool> fake1;
    master_in<bool> fake2;


    shared_in<bool> Uart1_Tx;
    shared_in<bool> Uart2_Tx;
    shared_in<bool> Uart3_Tx;
    shared_in<bool> Uart4_Tx;
    shared_in<bool> Uart5_Tx;

    shared_out<bool> Uart1_Rx;
    shared_out<bool> Uart2_Rx;
    shared_out<bool> Uart3_Rx;
    shared_out<bool> Uart4_Rx;
    shared_out<bool> Uart5_Rx;

    bool uart1_tx_pin = true;
    bool uart2_tx_pin = true;
    bool uart3_tx_pin = true;
    bool uart4_tx_pin = true;
    bool uart5_tx_pin = true;



    bool bitdatain;

    bool bitdataout1 = true;
    bool bitdataout2 = true;
    bool bitdataout3 = true;
    bool bitdataout4 = true;
    bool bitdataout5 = true;

    bool fake;
    bool trigger1 = false;
    bool trigger2 = false;

    unsigned int shiftcounter = 0;
    unsigned int datareg = 0;
    unsigned int endreg = 0;

    bool startbit = false;
    bool paritybit = false;
    bool stopbit = false;

    bool valid1 = false;
    bool valid2 = false;
    bool valid3 = false;
    bool valid4 = false;
    bool valid5 = false;


    Arbiter(sc_module_name name) :
    trigg1("trigg1"),
    trigg2("trigg2"),
    fake1("fake1"),
    fake2("fake2"),
    Uart1_Tx("Uart1_Tx"),
    Uart2_Tx("Uart2_Tx"),
    Uart3_Tx("Uart3_Tx"),
    Uart4_Tx("Uart4_Tx"),
    Uart5_Tx("Uart5_Tx"),
    Uart1_Rx("Uart1_Rx"),
    Uart2_Rx("Uart2_Rx"),
    Uart3_Rx("Uart3_Rx"),
    Uart4_Rx("Uart4_Rx"),
    Uart5_Rx("Uart5_Rx")
    {
        SC_THREAD(fsm);

    }

    void fsm();

};

void Arbiter::fsm() {
    while (true) {

        Uart1_Tx->get(uart1_tx_pin);
        Uart2_Tx->get(uart2_tx_pin);
        Uart3_Tx->get(uart3_tx_pin);
        Uart4_Tx->get(uart4_tx_pin);
        Uart5_Tx->get(uart5_tx_pin);

        if (valid1) {
            bitdatain = uart1_tx_pin;
        } else if (valid2) {
            bitdatain = uart2_tx_pin;
        } else if (valid3) {
            bitdatain = uart3_tx_pin;
        } else if (valid4) {
            bitdatain = uart4_tx_pin;
        } else if (valid5) {
            bitdatain = uart5_tx_pin;
        }



        if(section == Sections::SCAN){
            trigg1->read(trigger1);

            if(trigger1) {
                if (!uart1_tx_pin) {
                    valid1 = true;
                }else if (!uart2_tx_pin) {
                    valid2 = true;
                }else if (!uart3_tx_pin) {
                    valid3 = true;
                }else if (!uart4_tx_pin) {
                    valid4 = true;
                }else if (!uart5_tx_pin) {
                    valid5 = true;
                }


                if (valid1 || valid2 || valid3 || valid4 || valid5) {
                    nextsection = Sections::SELECT;
                }

            }
        }else if(section == Sections::SELECT) {
            trigg1->read(trigger1);

            if(trigger1) {


                datareg = datareg >> 1;

                if(bitdatain) datareg |= MSB;

                if(++shiftcounter == 8){
                    nextsection = Sections::PARITY_SKIP;
                    shiftcounter = 0;
                }else nextsection = Sections::SELECT;


            }



        }else if(section == Sections::PARITY_SKIP){
            trigg1->read(trigger1);

            if(trigger1) nextsection = Sections::TRANSFER;

        }else if(section == Sections::TRANSFER) {
            trigg1->read(trigger1);

            if(trigger1){
                if(datareg == 1){
                    bitdataout1 = bitdatain;
                }else if(datareg == 2){
                    bitdataout2 = bitdatain;
                }else if(datareg == 3){
                    bitdataout3 = bitdatain;
                }else if(datareg == 4){
                    bitdataout4 = bitdatain;
                }else if(datareg == 5){
                    bitdataout5 = bitdatain;
                }else{
                    nextsection = Sections::SCAN;
                    datareg = 0;
                    valid1 = false;
                    valid2 = false;
                    valid3 = false;
                    valid4 = false;
                    valid5 = false;
                }

                if(startbit){

                    if(!paritybit && !stopbit) {
                        endreg = endreg >> 1;
                        if (bitdatain) endreg |= MSB;
                    }
                    if(stopbit){
                        startbit = false;
                        stopbit = false;
                        endreg = 0;
                    }
                    if(paritybit){
                        if(endreg == 255) nextsection = Sections::END;
                        paritybit = false;
                        stopbit = true;
                    }
                    if(++shiftcounter == 8) {
                        paritybit = true;
                        shiftcounter = 0;
                    }
                }
                if(!startbit && !bitdatain){
                    startbit = true;
                    shiftcounter = 0;
                }



            }







        }else if(section == Sections::END) {
            trigg1->read(trigger1);

            datareg = 0;
            endreg = 0;
            valid1 = false;
            valid2 = false;
            valid3 = false;
            valid4 = false;
            valid5 = false;
            shiftcounter = 0;
            bitdataout1 = true;
            bitdataout2 = true;
            bitdataout3 = true;
            bitdataout4 = true;
            bitdataout5 = true;
            stopbit = false;
            startbit = false;

            nextsection = Sections::SCAN;
        }

        Uart1_Rx->set(bitdataout1);
        Uart2_Rx->set(bitdataout2);
        Uart3_Rx->set(bitdataout3);
        Uart4_Rx->set(bitdataout4);
        Uart5_Rx->set(bitdataout5);




        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}






#endif //UART_ARBITER_H
