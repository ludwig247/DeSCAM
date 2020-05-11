//
// Created by mi-alkoudsi on 31.03.20.
//

#ifndef DESCAM_FATALERROR_H
#define DESCAM_FATALERROR_H


#include <exception>
#include <string>
#include "LocationInfo.h"

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
    try {                                                            \
    x;                                                                \
        if(SCAM::Logger::isTerminate()) {                              \
        SCAM::Logger::log();                                            \
        return -1;                                                       \
        }                                                                 \
    }                                                                      \
    CATCH_FATAL
#define CATCH_FATAL                                                    \
   catch (SCAM::FatalError& err) {                                      \
        SCAM::Logger::log();                                             \
    return -1;                                                            \
    }

/** A macro that throws a FatalError in case termination is necessary */
#define TERMINATE_IF_ERROR                                              \
    if(Logger::isTerminate()) {                                          \
        throw SCAM::FatalError();                                         \
    }

/** A macro that breaks execution at this point and adds a message to the logger */
    #define TERMINATE(msg)                                           \
    {                                                                 \
    SCAM::LocationInfo stmtLocationInfo("in function: " +           \
    std::string(__FUNCTION__),std::string(__FILE__),__LINE__,__LINE__,0,0);                           \
    auto sl = SCAM::LoggerMsg::SeverityLevel::Fatal;                     \
    auto vt = SCAM::LoggerMsg::ViolationType::NA;                         \
    auto pl = SCAM::Logger::getCurrentProcessedLocation();                 \
    SCAM::LoggerMsg lmsg(msg,stmtLocationInfo,sl,vt,pl);                    \
    SCAM::Logger::addMsg(lmsg);                                              \
    throw std::runtime_error(msg);                                                 \
    }
}
#endif //DESCAM_FATALERROR_H__func__


