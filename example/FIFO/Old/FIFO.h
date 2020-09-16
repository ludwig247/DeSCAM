#include "../../Interfaces/Interfaces.h"

#include "systemc.h"

#define N 3
struct FIFO : public sc_module {

    //Blocking interface
    blocking_in<int> producer;
    blocking_out<int> consumer;

    SC_HAS_PROCESS(FIFO);

    FIFO(sc_module_name name) :
            producer("producer"),
            consumer("consumer"),
            head(0),
            tail(0),
            from_reset(false),
            is_empty(true),
            is_full(false)
    {SC_THREAD(fsm); }

    //Variables
    //Data Array
    int buffer [N];
    //Temporary Variables for reading and writing
    int value_in;
    int value_out;
    //Head: Indicates the element in the Data Array, which should be read next
    unsigned int head;
    //Tail: Indicates the index of the Data Array, where the next element should be written
    unsigned int tail;
    //Boolean is_empty: Signals that the FIFO is empty
    bool is_empty;
    //Boolean is_full: Signals that the FIFO is full
    bool is_full;
    //Booleans to check if reading/writing is possible
    bool can_read;
    bool can_write;

    bool from_reset;
    //Behaviour of FIFO
    void fsm() {
        while (true) {
            if(from_reset == false){
                wait(WAIT_TIME, SC_PS);
                from_reset = true;
                consumer->try_write(0);
                std::cout << "At " << sc_time_stamp() << " Reset: buffer: "<< buffer[0] << " " << buffer[1] << " "  << buffer[2] << " value_in: "<< value_in << " value_out: "<< value_out << endl;
            }
            can_read = producer->peek();
            can_write = consumer->poke();

            //Write Value into Buffer and read Value from Buffer, if buffer is not full and not empty
            if (can_read && can_write && !is_full && !is_empty){
                producer->read(value_in);
                if (tail == 0){
                    buffer[0] = value_in;
                }
                else if (tail == 1){
                    buffer[1] = value_in;
                }
                else{// if (tail == 2){
                    buffer[2] = value_in;
                }
                tail = (tail + 1) % N;

                if (head == 0 ){
                    value_out = buffer[0];
                }
                else if (head == 1){
                    value_out = buffer[1];
                }
                else{ // if (head == 2){
                    value_out = buffer[2];
                }
                head = (head + 1) % N;
                consumer->write(value_out);
            }
            else if (can_read && can_write && is_full && !is_empty){
                if (head == 0 ){
                    value_out = buffer[0];
                }
                else if (head == 1){
                    value_out = buffer[1];
                }
                else{ // if (head == 2){
                    value_out = buffer[2];
                }
                head = (head + 1) % N;
                consumer->try_write(value_out);

                producer->read(value_in);
                if (tail == 0){
                    buffer[0] = value_in;
                }
                else if (tail == 1){
                    buffer[1] = value_in;
                }
                else{// if (tail == 2){
                    buffer[2] = value_in;
                }
                tail = (tail + 1) % N;
            }
            else if (can_read && can_write && !is_full && is_empty){
                producer->read(value_in);
                value_out = value_in;
                consumer->try_write(value_out);
            }
                //Write Value into Buffer, if Buffer is not full
            else if(can_read && !is_full){
                producer->read(value_in);
                if (tail == 0){
                    buffer[0] = value_in;
                }
                else if (tail == 1){
                    buffer[1] = value_in;
                }
                else{ // if (tail == 2){
                    buffer[2] = value_in;
                }
                std::cout << "At " << sc_time_stamp() << " Prod: buffer: "<< buffer[0] << " " << buffer[1] << " " << buffer[2]<< " value_in: "<< value_in << " value_out: "<< value_out << endl;
                tail = (tail + 1) % N;
                //Check if Buffer is full and set is_full accordingly
                if(tail == head){
                    is_full = true;
                }
                is_empty = false;
            }
            //Read Value from Buffer, if Buffer is not empty
            else if (can_write && !is_empty){
                if (head == 0 ){
                    value_out = buffer[0];
                }
                else if (head == 1){
                    value_out = buffer[1];
                }
                else{ //if (head == 2){
                    value_out = buffer[2];
                }
                head = (head + 1) % N;
                //Check if Buffer is empty and set is_empty accordingly
                if(tail == head){
                    is_empty = true;
                }
                is_full = false;
                consumer->write(value_out);
                std::cout << "At " << sc_time_stamp() << " Cons: buffer: "<< buffer[0] << " " << buffer[1] << " " << buffer[2]<< " value_in: "<< value_in << " value_out: "<< value_out << endl;

            }
            else {
                wait(WAIT_TIME, SC_PS);
            }
        }
    };
};

