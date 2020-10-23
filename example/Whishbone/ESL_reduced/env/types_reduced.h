#ifndef PROJECT_TYPES_REDUCED_H
#define PROJECT_TYPES_REDUCED_H

enum trans_t {
    SINGLE_READ, SINGLE_WRITE
};
enum ack_t  {
    OK, RTY, ERR
};

enum addr_t {
    SLAVE0, SLAVE1, SLAVE2, SLAVE3
};

struct bus_req_t{
    addr_t addr;
    trans_t trans_type;
    bool data;
};

struct bus_resp_t{
    bool data;
    ack_t ack;
};

struct master_signals{
    addr_t addr;
    bool data;
    bool we;
    bool stb;
    bool cyc;
};

struct slave_signals{
    bool data;
    bool ack;
    bool err;
};

#endif //PROJECT_TYPES_REDUCED_H