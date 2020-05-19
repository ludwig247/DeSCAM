#include "DescamException.h"

bool DESCAM::DescamException::exceptionHappened = false;

DESCAM::DescamException::DescamException(std::string message, DESCAM::LocationInfo stmtLocationInfo) noexcept : message(message) , stmtLocationInfo(stmtLocationInfo)  {
    DescamException::exceptionHappened = true;
}

const char *DESCAM::DescamException::what() const noexcept {
    return message.c_str();
}

DESCAM::LocationInfo DESCAM::DescamException::getStmtLocationInfo() {
    return this->stmtLocationInfo;
}

bool DESCAM::DescamException::isExceptionHappened() {
    bool tmp = DescamException::exceptionHappened;
    DescamException::exceptionHappened = false;
    return tmp;
}
