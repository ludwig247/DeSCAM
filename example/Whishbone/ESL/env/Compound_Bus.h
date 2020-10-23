//
// Created by ludwig on 18.01.17.
//

#ifndef PROJECT_COMPOUND_BUS_H
#define PROJECT_COMPOUND_BUS_H


struct master_signals{
    int addr;
    int data;
    bool we;
    bool stb;
    bool cyc;
};

struct slave_signals{
    int data;
    bool ack;
    bool err;
};



#endif //PROJECT_COMPOUND_H
