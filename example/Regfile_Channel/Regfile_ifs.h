
class Regfile_in_if : virtual public sc_interface
{
public:
    virtual void read(int & out, int address) = 0;
};


class Regfile_out_if : virtual public sc_interface
{
public:
    virtual void write(const int & val, int address) = 0; //regular blocking write
};
