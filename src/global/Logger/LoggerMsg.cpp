#include "LoggerMsg.h"


SCAM::LoggerMsg::LoggerMsg(const std::string &message,  const std::string &statement, const SCAM::StmtLocationInfo& stmtLocationInfo, SeverityLevel severityLevel, ViolationType violationType) {
    setMessage(message);
    setStatement(statement);
    setStmtLocationInfo(stmtLocationInfo);
    setSeverityLevel(severityLevel);
    setViolationType(violationType);
}

const std::string &SCAM::LoggerMsg::getMessage() {
    return this->message;
}

const std::string &SCAM::LoggerMsg::getStatement() {
    return this->statement;
}

const SCAM::StmtLocationInfo &SCAM::LoggerMsg::getStmtLocationInfo() {
    return this->stmtLocationInfo;
}

std::string SCAM::LoggerMsg::getSeverityLevel() {
    switch (this->severityLevel) {
        case SeverityLevel::Info :
            return "Info";
        case SeverityLevel::Warning :
            return "Warning";
        case SeverityLevel::Error :
            return "Error";
    }
}

std::string SCAM::LoggerMsg::getViolationType() {
    switch (this->violationType) {
        case ViolationType::Syntax :
            return "Syntax Error";
        case ViolationType::SystemC_PPA_compliance :
            return "SystemC PPA Compliance";
        case ViolationType::NA :
            return "NA";
    }
}


void SCAM::LoggerMsg::setMessage(const std::string &message) {
    this->message = message;
}

void SCAM::LoggerMsg::setStatement(const std::string &statement) {
    this->statement = statement;
}

void SCAM::LoggerMsg::setViolationType(SCAM::LoggerMsg::ViolationType violationType) {
    this->violationType = violationType;
}

void SCAM::LoggerMsg::setSeverityLevel(SCAM::LoggerMsg::SeverityLevel severityLevel) {
    this->severityLevel = severityLevel;
}

void SCAM::LoggerMsg::setStmtLocationInfo(const SCAM::StmtLocationInfo &stmtLocationInfo) {
    this->stmtLocationInfo = stmtLocationInfo;
}

