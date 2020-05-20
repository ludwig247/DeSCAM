#include "Interfaces.h"
#include "systemc.h"

SC_MODULE(Producer) {
    shared_out<int> out;
    shared_out<bool> notify;
    shared_in<bool> sync;

    int cnt = 1;
    bool got_sync;
    float random;
    float limit = 0.3;
    bool skip = true;

    void drive_out() {
        out->set(-1);
        notify->set(false);
        insert_state();
        while (true) {
            //Produce Values and write them to the Input of the FIFO_Shared
            random = ((float) rand()) / (float) RAND_MAX;
            while (random < limit) {
                insert_state();
                random = ((float) rand()) / (float) RAND_MAX;
            }
            out->set(cnt);
            cnt = cnt + 1;
            notify->set(true);
            insert_state();
            sync->get(got_sync);
            while (!got_sync) {
                insert_state();
                sync->get(got_sync);
            }
            std::cout << "At " << sc_time_stamp() << " Producer sent: " << cnt - 1 << endl;
            notify->set(false);
            insert_state();
        }

    }

    SC_CTOR(Producer) {
        SC_THREAD(drive_out);
    }
};
