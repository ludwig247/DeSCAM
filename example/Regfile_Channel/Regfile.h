

#include "systemc.h"
#include "Regfile_ifs.h"

class Regfile : public sc_prim_channel,
                     virtual public Regfile_in_if,          //
                     virtual public Regfile_out_if,
                     virtual public Regfile_Dummy_if{        //
public:
    Regfile(const char *name);

    void read(std::array<int,32> &out);
    void write(const int &val, int address);
    void dummyFunc();

private:
    std::array<int,32> regs;
    sc_event write_dummy_notify, dummy_write_notify;
};

#include "Regfile.hpp"



