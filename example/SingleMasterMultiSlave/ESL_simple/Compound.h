//
// Created by ludwig on 18.01.17.
//

#ifndef PROJECT_COMPOUND_H
#define PROJECT_COMPOUND_H
enum err_id_t {
    NO_ERR,ERR_MIX, ERR_TEMP_TOP, ERR_TEMP_BOT, ERR_UNKNOWN
};

struct sensor_t{

    int data;
    bool stable;
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
    bool on;
    int sample_value;
    int setpoint;
    int Kp;
    int Ki;
    int Kd;
    int sample_time;

//    friend std::ostream &operator<<(std::ostream &os, const act_t &setup) {
//        os << "[" << setup.set << "," << setup.reset << "," << setup.intmod << "]";
//        return os;
//    }
};



#endif //PROJECT_COMPOUND_H
