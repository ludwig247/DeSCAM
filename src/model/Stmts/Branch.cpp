//
// Created by tobias on 19.04.16.
//

#include <PrintStmt.h>
#include "Branch.h"

std::ostream &DESCAM::Branch::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}
