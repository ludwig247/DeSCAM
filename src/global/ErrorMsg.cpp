//
// Created by tobias on 10.06.16.
//

#include "ErrorMsg.h"

SCAM::ErrorMsg &SCAM::ErrorMsg::getInstance() {
    static ErrorMsg instance;
    return instance;
}

std::vector<SCAM::ErrorMsg::Error> SCAM::ErrorMsg::getErrorList() {
    return ErrorMsg::getInstance().errorList;
}

void SCAM::ErrorMsg::addError(std::string msg, std::string astMsg) {
    //Add new error to errorLog
    ErrorMsg::getInstance().errorList.push_back(Error(msg,astMsg,"","",ErrorMsg::getInstance().errorLog));
    //Remove old errorMsg from the log
    ErrorMsg::getInstance().errorLog.clear();
}

bool SCAM::ErrorMsg::hasError() {
    return !ErrorMsg::getInstance().errorList.empty();
}

void SCAM::ErrorMsg::addErrorLog(std::string msg) {
    ErrorMsg::getInstance().errorLog.push_back(msg);
}

void SCAM::ErrorMsg::clear() {
    ErrorMsg::getInstance().errorLog.clear();
    ErrorMsg::getInstance().errorList.clear();
}

