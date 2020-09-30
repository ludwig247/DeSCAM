//
// Created by ludwig on 05.07.17.
//

#ifndef PROJECT_TYPES_H
#define PROJECT_TYPES_H

const unsigned number = 0x111;
const unsigned int number2 = 0x111;
const int number3 = 20;
const bool number4 = true;
const int intern = 3;
const int intern2 = 3;

enum Mode {
    READ, WRITE
};

struct CompoundType {
    int x;
    bool y;
    Mode mode;
};

struct test_compound {
    int x;
    unsigned int y;
//    int y;
};

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


struct sensor_t{
    int data;
    bool data_stable;
};

struct config_t {
    int sample_time;
    int target_temp;
    int max_temp_diff;
    int Kp_Heat;
    int Ki_Heat;
    int Kd_Heat;
    int Kp_Mix;
    int Ki_Mix;
    int Kd_Mix;
};

struct act_t {
    bool power_on;
    int sample_value;
    int setpoint;
    int Kp;
    int Ki;
    int Kd;
    int sample_time;
};

#define Ki_low 0
#define Ki_up 10
#define Kp_low 0
#define Kp_up 10
#define Kd_low 0
#define Kd_up 10
#define setpoint_low 0
#define setpoint_up 100
#define sample_time_low 1
#define sample_time_up 1000
#define max_diff 10
#define max_temp 50
#define min_temp 0


enum opc_t  {NOP_OPC, READ_OPC, WRITE_OPC, RMW_OPC, BTR2_OPC, BTR4_OPC, BTR8_OPC};
//enum ack_t  {OK, RTY, ERR};
struct req_t  {int addr; opc_t opc; int data; bool abort;};
enum update_t  {NXT_GRANT_Q, NXT_PHASE_Q, RTY_Q, NXT_BTR_Q}; //grant sent when a req should be moved to grant, phase when only a phase increment, rty when retry, btr when the address should remain in address but the data phase is moved out
enum req_status_t  {EMPTY_STATUS, REQ_STATUS, ADDR_STATUS, DATA_STAUS};
//enum trans_t { SINGLE_READ, SINGLE_WRITE};
struct result_t {int data; bool err; };

#endif //PROJECT_TYPES_H
