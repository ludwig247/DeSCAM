//
// Created by ludwig on 18.01.17.
//

#ifndef PROJECT_COMPOUND_H
#define PROJECT_COMPOUND_H
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


#endif //PROJECT_COMPOUND_H
