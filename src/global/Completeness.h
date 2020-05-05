//
// Created by tobias on 11.04.20.
//

#ifndef DESCAM_COMPLETENESS_H
#define DESCAM_COMPLETENESS_H

#include <Behavior/Operation.h>

namespace SCAM{
    class Completeness {
    public:
        static bool checkCaseSplit(const std::vector<SCAM::Operation *> &operations, Module *module);
    };
}



#endif //DESCAM_COMPLETENESS_H
