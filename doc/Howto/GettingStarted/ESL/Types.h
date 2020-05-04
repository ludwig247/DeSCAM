//
// Created by ludwig on 18.01.17.
//

#ifndef PROJECT_TYPES_H
#define PROJECT_TYPES_H

enum err_id_t {
    NO_ERR,ERR_MIX, ERR_TEMP, ERR_TEMP_TOP, ERR_TEMP_BOT, ERR_UNKNOWN
};

enum trans_t {
    SINGLE_READ, SINGLE_WRITE
};
enum ack_t  {
    OK, RTY, ERR
};

struct bus_req_t{
    int addr;
    trans_t trans_type;
    int data;
};

struct bus_resp_t{
    int data;
    ack_t ack;
};




#endif //PROJECT_COMPOUND_H
