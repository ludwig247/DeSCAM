#include "Interfaces.h"
#include "Buffer_Channel.h"
#include "systemc.h"

SC_MODULE(Producer){
    sc_port<Buffer_Channel_out_if<int>> out;

    int id;
    float random;
    float limit = 0.25;

    void drive_out(){
        static int number_of_producers;
        id = number_of_producers++;
        int cnt = 1+10*id;
        while(true) {
            random = ((float) rand()) / (float) RAND_MAX;
            while (random < limit) {
                insert_state();
                random = ((float) rand()) / (float) RAND_MAX;
            }
            if (cnt > 10*(id+1)) break;
            //Produce Values and write them to the Input of the Buffer_Channel
            if(id == 0) {
                out->write0(cnt++);
            } else if (id == 1){
                out->write1(cnt++);
            } else{
                out->write2(cnt++);
            }
            std::cout << "At " << sc_time_stamp() << " Producer " << id << " sent: " << cnt-1 << endl;
            insert_state();
        }
    }

    SC_CTOR(Producer){
        SC_THREAD(drive_out);
    }
};
