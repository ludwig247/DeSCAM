#include "Interfaces.h"
#include "Regfile.h"
#include "systemc.h"

SC_MODULE(Control){
    sc_port<Regfile_in_if> inp;
    sc_port<Regfile_out_if> out;
    std::array<int,32> x;

    void check_inp(){
        int i=0;
        while(true){
            std::cout << this->name() << " tries to write : " << i*15 << " to Reg: " << i << std::endl;
            out->write(i*15,i);
            std::cout << this->name() << " wrote : " << i*15 << " to Reg: " << i << std::endl;
            inp->read(x);
            assert(x.at(i)==i*15);
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
