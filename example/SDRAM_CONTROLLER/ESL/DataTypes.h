//
// Created by Douae Nouichi on 23/10/2020.
//

#ifndef ESL_DATATYPES_H
#define ESL_DATATYPES_H

//using namespace sc_dt;

enum states{
    IDLE, end_of_burst_read_operation, end_of_read_write_operation , nop, activate, single_read, end_of_read_operation, precharge, single_write, end_of_write_operation, burst_read, burst_write, end_of_burst_write_operation, read_write
};


struct request{

    bool read_req;
    bool write_req;
    bool burst_single;
    int  address_in;



};

struct burst{

    int data_1;
    int data_2;
    int data_3;
    int data_4;

};

struct resp_activ{
    bool sdram_status;
    bool ready;
    int address;
    int last_row;
};


struct resp{
    bool sdram_status;
    bool ready;
    int address;
    int last_row;
    int data_out;


};

struct resp_burst{
    bool sdram_status;
    bool ready;
    int address;
    int last_row;
    int data_1;
    int data_2;
    int data_3;
    int data_4;

};
struct resp_idle{

    int address;
    int last_row;


};
struct data{
    int addr_in;
    int data_in;


};

struct rd_wrt{

    int read_data;
    int write_data;

};

struct resp_rd_wrt{
    bool sdram_status;
    bool ready;
    int address;
    int last_row;
    int rd_data;
    int wrt_data;
};


#endif //ESL_DATATYPES_H