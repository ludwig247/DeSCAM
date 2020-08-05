#include "LoggerMsg.h"


DESCAM::LoggerMsg::LoggerMsg(const std::string &message, const DESCAM::LocationInfo &stmtInfo,
                           SeverityLevel severityLevel, ViolationType violationType,
                           ProcessedLocation violationLocation) {
    setMessage(message);
    setLocationInfo(stmtInfo);
    setSeverityLevel(severityLevel);
    setViolationType(violationType);
    setProcessedLocation(violationLocation);
}

const std::string &DESCAM::LoggerMsg::getMessage() {
    return this->message;
}

const DESCAM::LocationInfo &DESCAM::LoggerMsg::getLocationInfo() {
    return this->locationInfo;
}

std::string DESCAM::LoggerMsg::getSeverityLevel() {
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

std::string DESCAM::LoggerMsg::getViolationType() {
    switch (this->violationType) {
        case ViolationType::Syntax :
            return "Syntax";
        case ViolationType::SystemC_PPA_compliance :
            return "SystemC PPA Compliance";
        case ViolationType::NA :
            return "NA";
    }
}

DESCAM::LoggerMsg::ProcessedLocation DESCAM::LoggerMsg::getProcessedLocation() {
    return this->processedLocation;
}


void DESCAM::LoggerMsg::setMessage(const std::string &message) {
    this->message = message;
}

void DESCAM::LoggerMsg::setViolationType(DESCAM::LoggerMsg::ViolationType violationType) {
    this->violationType = violationType;
}

void DESCAM::LoggerMsg::setSeverityLevel(DESCAM::LoggerMsg::SeverityLevel severityLevel) {
    this->severityLevel = severityLevel;
}

void DESCAM::LoggerMsg::setLocationInfo(const DESCAM::LocationInfo &stmtInfo) {
    this->locationInfo = stmtInfo;
}

void DESCAM::LoggerMsg::setProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation location) {
    this->processedLocation = location;
}

std::string DESCAM::LoggerMsg::getProcessedLocationString() {
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

bool DESCAM::LoggerMsg::operator==(const DESCAM::LoggerMsg &other) const {
    if (this == &other) return true;
    return this->message == other.message &&
           this->processedLocation == other.processedLocation &&
           this->severityLevel == other.severityLevel &&
           this->violationType == other.violationType &&
           this->locationInfo == other.locationInfo;
}

