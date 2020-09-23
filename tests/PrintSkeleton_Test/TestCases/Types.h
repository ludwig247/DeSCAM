//
// Created by ludwig on 23.09.20.
//

#ifndef SCAM_TYPES_H
#define SCAM_TYPES_H


enum Mode {
    READ, WRITE
};

struct CompoundType {
    int x;
    bool y;
    Mode mode;
};



struct record_t{int x; unsigned int y;};

struct global_compound_type {
    unsigned w;
    bool b;
};

enum global_enum{A,B};
enum class global_enum_class{M,N};



#endif //SCAM_TYPES_H
