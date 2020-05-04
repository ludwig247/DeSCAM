#include "StmtException.h"

bool SCAM::StmtException::exceptionHappened = false;

SCAM::StmtException::StmtException(std::string message, SCAM::LocationInfo stmtLocationInfo) noexcept : message(message) , stmtLocationInfo(stmtLocationInfo)  {
    StmtException::exceptionHappened = true;
}

const char *SCAM::StmtException::what() const noexcept {
    return message.c_str();
}

SCAM::LocationInfo SCAM::StmtException::getStmtLocationInfo() {
    return this->stmtLocationInfo;
}

bool SCAM::StmtException::isExceptionHappened() {
    bool tmp = StmtException::exceptionHappened;
    StmtException::exceptionHappened = false;
    return tmp;
}
