//
// Created by wezel on 10/24/19.
//

#include "../Interfaces/Interfaces.h"

#include "systemc.h"

#define N 3

class FIFO_Shared : public sc_module {

public:
    shared_in<int> producer_sig;
    shared_out<int> consumer_sig;

    shared_in<bool> producer_sync;
    shared_in<bool> consumer_sync;

    shared_out<bool> producer_notify;
    shared_out<bool> consumer_notify;


    SC_HAS_PROCESS(FIFO_Shared);

    FIFO_Shared(sc_module_name name) :
            producer_sig("producer"),
            consumer_sig("consumer"),
            producer_notify("prod_notify"),
            consumer_notify("cons_notify"),
            producer_sync("prod_sync"),
            consumer_sync("cons_sync") {SC_THREAD(fsm); }

private:
    //Data Array
    int buffer[N];
    //Head: Indicates the index of the Data Array, where the next element should be written
    int head;
    //Tail: Indicates the element in the Data Array, which should be read next
    int tail;
    //Enum for STATES
    enum states {
        EMPTY, FILLED, FULL
    };
    enum states state;
    //Booleans to check if reading/writing is possible
    bool p_sync;
    bool c_sync;
    //Data signals
    int p_data;
    int c_data;

    //Behaviour of FIFO_Shared
    void fsm() {
        //Reset behaviour
        state = EMPTY;
        head = 0;
        tail = 0;
        consumer_notify->set(false);
        producer_notify->set(false);
        consumer_sig->set(0);
        buffer[0] = 0;
        buffer[1] = 0;
        buffer[2] = 0;
        //"State Machine"
        while (true) {
//            sc_assert(buffer[0] != -1);
//            sc_assert(buffer[1] != -1);
//            sc_assert(buffer[2] != -1);
            if (state == EMPTY) {
                insert_state("empty");
            } else if (state == FILLED) {
                insert_state("filled");
            } else {
                insert_state("full");
            }

            producer_sync->get(p_sync);
            consumer_sync->get(c_sync);

            producer_notify->set(false);
            consumer_notify->set(false);

            if ((state == EMPTY) && (head < N) && (tail < N)) {
                if (p_sync && !c_sync) {
                    producer_sig->get(p_data);
                    if (head == 0) {
                        buffer[0] = p_data;
                        head = 1;
                    } else if (head == 1) {
                        buffer[1] = p_data;
                        head = 2;
                    } else { // if (head == 2){
                        buffer[2] = p_data;
                        head = 0;
                    }
                    //Check if Buffer is full and set state accordingly
                    state = FILLED;
                    if (tail == head) {
                        state = FULL;
                    }
                    producer_notify->set(true);
                } else if (p_sync && c_sync) {
                    producer_sig->get(p_data);
                    consumer_sig->set(p_data);
                    producer_notify->set(true);
                    consumer_notify->set(true);
                }
            } else if ((state == FILLED) && (head < N) && (tail < N) && (head != tail)) {
                if (p_sync && !c_sync) {
                    producer_sig->get(p_data);
                    if (head == 0) {
                        buffer[0] = p_data;
                        head = 1;
                    } else if (head == 1) {
                        buffer[1] = p_data;
                        head = 2;
                    } else { // if (head == 2){
                        buffer[2] = p_data;
                        head = 0;
                    }
                    //Check if Buffer is full and set state accordingly
                    state = FILLED;
                    if (tail == head) {
                        state = FULL;
                    }
                    producer_notify->set(true);
                } else if (!p_sync && c_sync) {
                    if (tail == 0) {
                        c_data = buffer[0];
                        tail = 1;
                    } else if (tail == 1) {
                        c_data = buffer[1];
                        tail = 2;
                    } else { // if (tail == 2){
                        c_data = buffer[2];
                        tail = 0;
                    }
                    consumer_sig->set(c_data);
                    state = FILLED;
                    if (tail == head) {
                        state = EMPTY;
                    }
                    consumer_notify->set(true);
                } else if (p_sync and c_sync) {
                    if (tail == 0) {
                        c_data = buffer[0];
                        tail = 1;
                    } else if (tail == 1) {
                        c_data = buffer[1];
                        tail = 2;
                    } else { // if (tail == 2){
                        c_data = buffer[2];
                        tail = 0;
                    }
                    consumer_sig->set(c_data);
                    consumer_notify->set(true);

                    producer_sig->get(p_data);
                    if (head == 0) {
                        buffer[0] = p_data;
                        head = 1;
                    } else if (head == 1) {
                        buffer[1] = p_data;
                        head = 2;
                    } else { // if (head == 2){
                        buffer[2] = p_data;
                        head = 0;
                    }
                    producer_notify->set(true);
                }
            } else if ((state == FULL) && (head < N) && (tail < N)) {
                if (!p_sync && c_sync) {
                    if (tail == 0) {
                        c_data = buffer[0];
                        tail = 1;
                    } else if (tail == 1) {
                        c_data = buffer[1];
                        tail = 2;
                    } else { // if (tail == 2){
                        c_data = buffer[2];
                        tail = 0;
                    }
                    consumer_sig->set(c_data);
                    state = FILLED;
                    if (tail == head) {
                        state = EMPTY;
                    }
                    consumer_notify->set(true);
                } else if (p_sync && c_sync) {
                    if (tail == 0) {
                        c_data = buffer[0];
                        tail = 1;
                    } else if (tail == 1) {
                        c_data = buffer[1];
                        tail = 2;
                    } else { // if (tail == 2){
                        c_data = buffer[2];
                        tail = 0;
                    }
                    consumer_sig->set(c_data);
                    consumer_notify->set(true);

                    producer_sig->get(p_data);
                    if (head == 0) {
                        buffer[0] = p_data;
                        head = 1;
                    } else if (head == 1) {
                        buffer[1] = p_data;
                        head = 2;
                    } else { // if (head == 2){
                        buffer[2] = p_data;
                        head = 0;
                    }
                    producer_notify->set(true);
                }
            }
        }
    };
};