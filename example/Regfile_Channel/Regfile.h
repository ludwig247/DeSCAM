

#include "systemc.h"
#include "Regfile_ifs.h"

class Regfile : public sc_prim_channel,
                     virtual public Regfile_in_if,          //
                     virtual public Regfile_out_if {        //
public:
    Regfile(const char *name);

    void read(int &out, int address);
    void write(const int &val, int address);

private:
    std::array<int,32> regs_array;
    sc_event reader_notify, writer_notify;
};

#include "Regfile.hpp"



