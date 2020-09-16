//
// Created by tobias on 11.04.20.
//

#ifndef DESCAM_COMPLETENESS_H
#define DESCAM_COMPLETENESS_H

#include <Behavior/Operation.h>

namespace DESCAM{
    class Completeness {
    public:
        static bool checkCaseSplit(const std::vector<DESCAM::Operation *> &operations, Module *module);
    };
}



#endif //DESCAM_COMPLETENESS_H
