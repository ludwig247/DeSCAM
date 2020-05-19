#include "DescamException.h"

bool SCAM::DescamException::exceptionHappened = false;

SCAM::DescamException::DescamException(std::string message, SCAM::LocationInfo stmtLocationInfo) noexcept : message(message) , stmtLocationInfo(stmtLocationInfo)  {
    DescamException::exceptionHappened = true;
}

const char *SCAM::DescamException::what() const noexcept {
    return message.c_str();
}

SCAM::LocationInfo SCAM::DescamException::getStmtLocationInfo() {
    return this->stmtLocationInfo;
}

bool SCAM::DescamException::isExceptionHappened() {
    bool tmp = DescamException::exceptionHappened;
    DescamException::exceptionHappened = false;
    return tmp;
}
