#include "Interfaces.h"
#include "Regfile.h"
#include "systemc.h"

SC_MODULE(Control){
    sc_port<Regfile_in_if> inp;
    sc_port<Regfile_out_if> out;

    void check_inp(){
        int i=0;
        while(true){
            out->write(i*15,i);
            int x;
            inp->read(x,i);
            assert(x==i*15);
            i++;
            if(i==32){
                break;
            }
        }
    }

    SC_CTOR(Control){
        SC_THREAD(check_inp);
    }
};
