//
// Created by jauch on 05.05.20.
//

#ifndef ESL_DATATYPES_H
#define ESL_DATATYPES_H

#include "sc_fix.h"

using namespace sc_dt;

enum phases{
    IDLE, DATA_IN, PREP, RUN, DATA_OUT
};

sc_fxtype_params parameters (8,4,SC_RND_ZERO,SC_SAT_ZERO);
sc_fxtype_context context(parameters);


#endif //ESL_DATATYPES_H
