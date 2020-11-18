//
// Created by Douae Nouichi on 23.10.2020
//
#include "/home/douae/DeSCAM/example/Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"




using namespace std;


struct SDRAM_Controller : public sc_module {

    //Variables
    states state, next_state;
    request data_in_req;
    resp_activ response_activate;
    resp response_single_read;
    resp_idle response_idle;

    int sdram_input_data;
    int CPU_input_data;
    int last_row;
    bool acc_rw='0';
    int CPU_input_read_write_data;

    // Burst read / write
    burst sdram_input_data_burst;
    resp_burst response_burst_read;
    burst CPU_input_data_burst;
    resp_burst response_burst_write;


    blocking_in<request> data_in;
    master_out<resp_activ> data_int;
    master_out<resp> data_out_single_read;
    master_in<int> sdram_data_in;
    master_in<request> data_in_end_read_op;
    // SINGLE WRITE INTERFACES
    master_in<int> CPU_data_in;
    master_out<resp> data_out_single_write;
    master_in<request> data_in_end_write_op;
    master_out<resp_idle> data_out_idle;

    //PRECHARGE
    master_in<request>precharge_read;
    // BURST READ INTERFACES
    master_in<burst>sdram_data_in_burst;
    master_out<resp_burst>data_out_burst_read;
    master_in<request>data_in_end_burst_read_op;
    //BURST WRITE INTERFACES
    master_in<burst>CPU_data_in_burst; // data written to the sdram controller by the CPU
    master_out<resp_burst>data_out_burst_write;
    master_in<request>data_in_end_burst_write_op;

    //READ_WRITE
    master_in<int>CPU_data_read_write;







    SC_HAS_PROCESS(SDRAM_Controller);

    SDRAM_Controller(sc_module_name name) :
            data_in("data_in_req"),
            data_out_idle("data_out_idle"),
            data_int("data_int"),
            sdram_data_in("data_in"),
            data_out_single_read("data_out_single_read"),
            data_in_end_read_op ("data_in_end_read_op"),
            CPU_data_in("CPU_data_in"),
            data_out_single_write("data_out_single_write"),
            data_in_end_write_op("data_in_end_write_op"),
            precharge_read("precharge_read"),
            sdram_data_in_burst("sdram_data_in_burst"),
            data_out_burst_read("data_out_burst_read"),
            data_in_end_burst_read_op("data_in_end_burst_read_op"),
            CPU_data_in_burst("CPU_data_in_burst"),
            data_out_burst_write("data_out_burst_write"),
            data_in_end_burst_write_op("data_in_end_burst_write_op"),
            CPU_data_read_write("CPU_data_read_write")


    {
        SC_THREAD(fsm);
    }

    void fsm() {

        next_state = IDLE;
        response_idle.last_row =0;
        acc_rw=false;

        while (true) {
            state = next_state;
            if (state == IDLE) {
                data_in->read(data_in_req,"idle");
                response_idle.address = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                if (data_in_req.read_req or data_in_req.write_req) {
                    response_idle.last_row = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                    data_out_idle->master_write(response_idle,"idle");
                    next_state = activate;
                } else
                {
                    next_state = IDLE;

                }

            } else if (state == activate) {
                response_activate.sdram_status = true;
                response_activate.ready = false;
                response_activate.last_row = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                if ((response_activate.last_row != response_idle.last_row) or
                    (data_in_req.read_req == false and data_in_req.write_req == false)){
                    precharge_read -> master_read(data_in_req,"precharge");
                    next_state = precharge;

                }else {
                    response_activate.address = (data_in_req.address_in & 0x00000FFF);
                    data_int->master_write(response_activate,"activate");
                    response_activate.last_row = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                    if ((data_in_req.read_req == true) and (acc_rw == false) and (data_in_req.burst_single == false) and (response_activate.last_row == response_idle.last_row)) { // check fow address equal last row again here
                        sdram_data_in->master_read(sdram_input_data,"single_read");
                        CPU_data_read_write->master_read(CPU_input_read_write_data,"single_write");
                        acc_rw=data_in_req.write_req; //detect if a write has been issued at the same time
                        next_state = single_read;
                    } else if((data_in_req.write_req== true and data_in_req.burst_single == false and response_activate.last_row == response_idle.last_row) or (acc_rw ==true))// single write now or previously issued write
                    {
                        CPU_data_in->master_read(CPU_input_data,"single_write"); // data written by the CPU
                        next_state = single_write;
                    }else if(data_in_req.read_req == true and data_in_req.write_req == false and data_in_req.burst_single == true and response_activate.last_row == response_idle.last_row){
                        sdram_data_in_burst-> master_read(sdram_input_data_burst,"burst_read");
                        next_state = burst_read;
                    }else if(data_in_req.read_req == false and data_in_req.write_req == true and data_in_req.burst_single == true and response_activate.last_row == response_idle.last_row) {
                        CPU_data_in_burst->master_read(CPU_input_data_burst,"burst_write"); // Data to be written
                        next_state = burst_write;

                    }else
                        next_state = nop;
                }

            } else if(state == single_read) {
                response_single_read.sdram_status = true;
                response_single_read.ready = false;
                response_single_read.address = (data_in_req.address_in & 0x00000FFF);
                response_single_read.last_row = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                response_single_read.data_out = sdram_input_data;
                data_out_single_read -> master_write(response_single_read,"single_read");
                if(acc_rw == true) //do not take another request if an ongoing read-write is taking place
                    next_state = activate;
                else
                    next_state = end_of_read_operation;

            }  else if(state == end_of_read_operation){
                data_in_end_read_op->master_read(data_in_req,"single_read");
                next_state = activate;

            } else if (state == single_write) {
                response_single_read.sdram_status = true; // USED THE SAME VARIABLE
                response_single_read.ready = false;
                response_single_read.address = (data_in_req.address_in & 0x00000FFF);
                response_single_read.last_row = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                if(acc_rw==true)
                    response_single_read.data_out = CPU_input_read_write_data;
                else
                    response_single_read.data_out = CPU_input_data;
                data_out_single_write -> master_write(response_single_read,"single_write");
                next_state = end_of_write_operation;



            }else if(state == end_of_write_operation){
                data_in_end_write_op->master_read(data_in_req,"single_write");
                acc_rw = false;
                next_state = activate;

            }else if(state == burst_read){
                response_burst_read.sdram_status = true;
                response_burst_read.ready = false;
                response_burst_read.address = (data_in_req.address_in & 0x00000FFF);
                response_burst_read.last_row = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                response_burst_read.data_1 = sdram_input_data_burst.data_1; // could not use a struct in a compount type (DESCAM: "only built in and enum are allowed for compound")
                response_burst_read.data_2 = sdram_input_data_burst.data_2;
                response_burst_read.data_3 = sdram_input_data_burst.data_3;
                response_burst_read.data_4= sdram_input_data_burst.data_4;
                data_out_burst_read -> master_write(response_burst_read,"burst_read");
                next_state = end_of_burst_read_operation;


            }else if(state == end_of_burst_read_operation){
                data_in_end_burst_read_op->master_read(data_in_req,"burst_read");
                next_state = activate;

            }else if(state == burst_write){
                response_burst_write.sdram_status = true;
                response_burst_write.ready = false;
                response_burst_write.address = (data_in_req.address_in & 0x00000FFF);
                response_burst_write.last_row = (data_in_req.address_in & 0x00FFFFFF) >> 12;
                response_burst_write.data_1 = CPU_input_data_burst.data_1; // could not use a struct in a compount type (DESCAM: "only built in and enum are allowed for compound")
                response_burst_write.data_2 = CPU_input_data_burst.data_2;
                response_burst_write.data_3 = CPU_input_data_burst.data_3;
                response_burst_write.data_4=  CPU_input_data_burst.data_4;
                data_out_burst_write -> master_write(response_burst_write,"burst_write");
                next_state = end_of_burst_write_operation;

            }else if(state == end_of_burst_write_operation){
                data_in_end_burst_write_op->master_read(data_in_req,"burst_write");
                next_state = activate;


            }else {
                insert_state("PRECHARGE");
                next_state = IDLE;
                precharge_read -> master_read(data_in_req,"precharge"); // not sure where t place this


            }//precharge






        }


    }


    };