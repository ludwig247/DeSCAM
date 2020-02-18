#include "Interfaces.h"
#include "systemc.h"

SC_MODULE(Consumer) {
    shared_in<int> inp;
    shared_in<bool> sync;
    shared_out<bool> notify;
    int value = 0;
    bool got_sync;
    float random;
    float limit = 0.75;
    std::vector<int> data;
    int value_old = 0;
    bool skip = true;

    void check_inp() {
        while (true) {
            //Consumes values from the Output of the FIFO_Shared
            random = ((float) rand()) / (float) RAND_MAX;
            while (random < limit) {
                insert_state();
                random = ((float) rand()) / (float) RAND_MAX;
            }
            notify->set(true);
            insert_state();
            sync->get(got_sync);
            while (!got_sync) {
                insert_state();
                sync->get(got_sync);
            }
            inp->get(value);
            std::cout << "At " << sc_time_stamp() << " Consumer received: " << value << endl;
            data.push_back(value);
            sc_assert(value == value_old + 1);
            value_old = value;
            notify->set(false);
            insert_state();

        }
    }

    SC_CTOR(Consumer) {
        SC_THREAD(check_inp);
    }
};
