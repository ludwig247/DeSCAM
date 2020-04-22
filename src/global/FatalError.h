//
// Created by mi-alkoudsi on 31.03.20.
//

#ifndef DESCAM_FATALERROR_H
#define DESCAM_FATALERROR_H


#include <exception>
#include <string>
#include "StmtLocationInfo.h"

namespace SCAM {
    /**
     *  @brief A simple exception class thrown when the termination of DeSCAM is necessary.
     *
     *  When this an object of this class is thrown, it is only caught in the main,
     *  this guarantees that stack unwinding happens correctly and all destructors are called
     */
    class FatalError {
    public:
        FatalError() noexcept = default;;

        ~FatalError() noexcept = default;;
    };

/** A macro wrapping try catch blocks for handling FatalError */
#define ASSERT_MODEL_CREATION(x)                                    \
    try {                                                          \
    x;                                                              \
    }                                                                \
    CATCH_FATAL
#define CATCH_FATAL                                                    \
   catch (FatalError& err) {                                            \
   SCAM::Logger::log();                                                  \
    return -1;                                                            \
    }

/** A macro that throws a FatalError in case termination is necessary */
#define TERMINATE_IF_FATAL                                              \
    if(Logger::isTerminate()) {                                          \
        throw SCAM::FatalError();                                         \
    }
}
#endif //DESCAM_FATALERROR_H


