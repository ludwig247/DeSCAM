#include "LoggerMsg.h"


SCAM::LoggerMsg::LoggerMsg(const std::string &message, const SCAM::LocationInfo &stmtInfo,
                           SeverityLevel severityLevel, ViolationType violationType,
                           ProcessedLocation violationLocation) {
    setMessage(message);
    setLocationInfo(stmtInfo);
    setSeverityLevel(severityLevel);
    setViolationType(violationType);
    setProcessedLocation(violationLocation);
}

const std::string &SCAM::LoggerMsg::getMessage() {
    return this->message;
}

const SCAM::LocationInfo &SCAM::LoggerMsg::getLocationInfo() {
    return this->locationInfo;
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

void SCAM::LoggerMsg::setLocationInfo(const SCAM::LocationInfo &stmtInfo) {
    this->locationInfo = stmtInfo;
}

void SCAM::LoggerMsg::setProcessedLocation(SCAM::LoggerMsg::ProcessedLocation location) {
    this->processedLocation = location;
}

std::string SCAM::LoggerMsg::getProcessedLocationString() {
    switch (this->processedLocation) {
        case ProcessedLocation::GlobalConstants :
            return "while adding global constants";
        case ProcessedLocation::Ports :
            return "while adding module ports";
        case ProcessedLocation::Variables :
            return "while adding module variables";
        case ProcessedLocation::Behavior :
            return "while extracting module behavior";
        case ProcessedLocation::Functions :
            return "while adding module functions";
        case ProcessedLocation::Parsing :
            return "while parsing";
    }
}

bool SCAM::LoggerMsg::operator==(const SCAM::LoggerMsg &other) const {
    if (this == &other) return true;
    return this->message == other.message &&
           this->processedLocation == other.processedLocation &&
           this->severityLevel == other.severityLevel &&
           this->violationType == other.violationType &&
           this->locationInfo == other.locationInfo;
}

