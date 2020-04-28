#include "LoggerMsg.h"


SCAM::LoggerMsg::LoggerMsg(const std::string &message, const SCAM::StmtLocationInfo &stmtInfo,
                           SeverityLevel severityLevel, ViolationType violationType,
                           ProcessedLocation violationLocation) {
    setMessage(message);
    setStmtInfo(stmtInfo);
    setSeverityLevel(severityLevel);
    setViolationType(violationType);
    setProcessedLocation(violationLocation);
}

const std::string &SCAM::LoggerMsg::getMessage() {
    return this->message;
}

const SCAM::StmtLocationInfo &SCAM::LoggerMsg::getStmtInfo() {
    return this->stmtInfo;
}

std::string SCAM::LoggerMsg::getSeverityLevel() {
    switch (this->severityLevel) {
        case SeverityLevel::Info :
            return "Info";
        case SeverityLevel::Warning :
            return "Warning";
        case SeverityLevel::Error :
            return "Error";
        case SeverityLevel::Fatal :
            return "Fatal Error";
    }
}

std::string SCAM::LoggerMsg::getViolationType() {
    switch (this->violationType) {
        case ViolationType::Syntax :
            return "Syntax";
        case ViolationType::SystemC_PPA_compliance :
            return "SystemC PPA Compliance";
        case ViolationType::NA :
            return "NA";
    }
}

SCAM::LoggerMsg::ProcessedLocation SCAM::LoggerMsg::getProcessedLocation() {
    return this->processedLocation;
}


void SCAM::LoggerMsg::setMessage(const std::string &message) {
    this->message = message;
}

void SCAM::LoggerMsg::setViolationType(SCAM::LoggerMsg::ViolationType violationType) {
    this->violationType = violationType;
}

void SCAM::LoggerMsg::setSeverityLevel(SCAM::LoggerMsg::SeverityLevel severityLevel) {
    this->severityLevel = severityLevel;
}

void SCAM::LoggerMsg::setStmtInfo(const SCAM::StmtLocationInfo &stmtInfo) {
    this->stmtInfo = stmtInfo;
}

void SCAM::LoggerMsg::setProcessedLocation(SCAM::LoggerMsg::ProcessedLocation location) {
    this->processedLocation = location;
}

