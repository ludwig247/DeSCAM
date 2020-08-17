
class Regfile_in_if : virtual public sc_interface
{
public:
    virtual void read(std::array<int,32> & out) = 0;
};


class Regfile_out_if : virtual public sc_interface
{
public:
    virtual void write(const int & val, int address) = 0;
};

class Regfile_Dummy_if : virtual public sc_interface
{
public:
    virtual void dummyFunc() = 0;
};