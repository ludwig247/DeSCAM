//
// Created by mi-alkoudsi on 31.03.20.
//

#ifndef DESCAM_STMTEXCEPTION_H
#define DESCAM_STMTEXCEPTION_H

#include <exception>
#include <string>
#include "StmtLocationInfo.h"

namespace SCAM {

    class StmtException : public std::exception {
    public:

        /** Creates the exception with a default message */
        StmtException(std::string message, StmtLocationInfo stmtLocationInfo) noexcept;

        /** Destructs the exception */
        ~StmtException() noexcept override = default;;

        /** Returns the message describing the cause of the exception */
        const char *what() const noexcept override;

        /** Returns the location where the exception occurred */
        StmtLocationInfo getStmtLocationInfo();

        /** Returns and resets a flag indicating whether exception has happened*/
        static bool isExceptionHappened();

    private:
        std::string message;
        StmtLocationInfo stmtLocationInfo;
        static bool exceptionHappened;
    };

/** A macro wrapping try catch blocks for handling StmtExceptions */
#define ASSERT_STMT(x)                                            \
    try {                                                          \
    x;                                                              \
    }                                                                \
    CATCH_STMT_EXCEPTION(err.getStmtLocationInfo())

#define CATCH_STMT_EXCEPTION(stmtLocationInfo)                      \
   catch (StmtException& err) {                                      \
    auto msg = std::string(err.what());                               \
    auto sl = SCAM::LoggerMsg::SeverityLevel::Error;                    \
    auto vt = SCAM::LoggerMsg::ViolationType::SystemC_PPA_compliance;    \
    SCAM::LoggerMsg lmsg(msg,stmtLocationInfo,sl,vt);                     \
    SCAM::Logger::addMsg(lmsg);                                            \
    }


/** A macro that breaks execution at this point */
#define TERMINATE(msg)                                         \
        SCAM::StmtLocationInfo stmtLocationInfo("in function " + PRINT_FUNC,__FILE__,__LINE__,__LINE__,0,0) \
    throw StmtException(msg,stmtLocationInfo);
}
#endif //DESCAM_STMTEXCEPTION_H
