#include "systemc.h"
#include "Consumer.h"
#include "Producer.h"
#include "FIFO_Shared.h"

int sc_main(int argc, char *argv[]) {
    FIFO_Shared F1("FIF");
    Consumer C1("Cons");
    Producer P1("Prod");

    Shared<bool> p_notify("p_notify");
    Shared<bool> p_sync("p_sync");
    Shared<bool> c_notify("c_notify");
    Shared<bool> c_sync("c_sync");
    Shared<int> p_sig("p_sig");
    Shared<int> c_sig("c_sig");

    P1.out.bind(p_sig);
    P1.sync.bind(p_sync);
    P1.notify.bind(p_notify);

    C1.inp.bind(c_sig);
    C1.sync.bind(c_sync);
    C1.notify.bind(c_notify);

    F1.producer_sig.bind(p_sig);
    F1.consumer_sig.bind(c_sig);
    F1.producer_sync.bind(p_notify);
    F1.consumer_sync.bind(c_notify);
    F1.producer_notify.bind(p_sync);
    F1.consumer_notify.bind(c_sync);

    sc_start(100, SC_PS);

    return 0;
}
