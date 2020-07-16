#include "Interfaces.h"
#include "Synchronizer.h"
#include "systemc.h"

SC_MODULE(Producer){
    sc_port<Synchronizer_out_if<int>> out;

    int id;
    int cnt = 1;
    float random;
    float limit = 0.5;

    void drive_out(){
        static int number_of_senders;
        id = number_of_senders;
        number_of_senders++;
        while(true) {
            random = ((float) rand()) / (float) RAND_MAX;
            while (random < limit) {
                insert_state();
                random = ((float) rand()) / (float) RAND_MAX;
            }
            if (cnt > 10) break;
            //Produce Values and write them to the Input of the FIFO
            std::cout << "At " << sc_time_stamp() << " Producer"<< id <<" tries to send" << cnt << endl;
            out->write(cnt++,id);
            std::cout << "At " << sc_time_stamp() << " Producer"<< id <<" sent: " << cnt-1 << endl;
//            insert_state();
        }
    }

    SC_CTOR(Producer){
        SC_THREAD(drive_out);
    }
};
