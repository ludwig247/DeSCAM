//
// Created by mi-alkoudsi on 31.03.20.
//

#ifndef DESCAM_DESCAMEXCEPTION_H
#define DESCAM_DESCAMEXCEPTION_H

#include <exception>
#include <string>
#include "LocationInfo.h"

namespace DESCAM {

    class DescamException : public std::exception {
    public:

        /** Creates the exception with a default message */
        DescamException(std::string message, LocationInfo stmtLocationInfo) noexcept;

        /** Destructs the exception */
        ~DescamException() noexcept override = default;;

        /** Returns the message describing the cause of the exception */
        const char *what() const noexcept override;

        /** Returns the location where the exception occurred */
        LocationInfo getStmtLocationInfo();

        /** Returns and resets a flag indicating whether exception has happened*/
        static bool isExceptionHappened();

    private:
        std::string message;
        LocationInfo stmtLocationInfo;
        static bool exceptionHappened;
    };

/** A macro wrapping try catch blocks for handling StmtExceptions */
#define DESCAM_ASSERT(x)                                          \
    try {                                                          \
    x;                                                              \
    }                                                                \
    CATCH_DESCAM_EXCEPTION()

#define CATCH_DESCAM_EXCEPTION()                                       \
   catch (DESCAM::DescamException& err) {                               \
    auto msg = std::string(err.what());                                  \
    auto sl = DESCAM::LoggerMsg::SeverityLevel::Error;                    \
    auto vt = DESCAM::LoggerMsg::ViolationType::SystemC_PPA_compliance;    \
    auto pl = DESCAM::Logger::getCurrentProcessedLocation();                \
    DESCAM::LoggerMsg lmsg(msg,err.getStmtLocationInfo(),sl,vt,pl);          \
    DESCAM::Logger::addMsg(lmsg);                                             \
    if(pl != DESCAM::LoggerMsg::ProcessedLocation::GlobalConstants)            \
    DESCAM::Logger::setTerminate();                                             \
    }
}
#endif //DESCAM_DESCAMEXCEPTION_H
