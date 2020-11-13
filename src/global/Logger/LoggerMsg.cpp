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
  return message_;
}

const DESCAM::LocationInfo &DESCAM::LoggerMsg::getLocationInfo() {
  return location_info_;
}

std::string DESCAM::LoggerMsg::getSeverityLevel() {
  switch (severity_level_) {
    case SeverityLevel::Info :return "Info";
    case SeverityLevel::Warning :return "Warning";
    case SeverityLevel::Error :return "Error";
    case SeverityLevel::Fatal :return "Fatal Error";
    default:return "DESCAM::LoggerMsg::getSeverityLevel() - unknown severity level";
  }
}

std::string DESCAM::LoggerMsg::getViolationType() {
  switch (violation_type_) {
    case ViolationType::Syntax :return "Syntax";
    case ViolationType::SystemC_PPA_compliance :return "SystemC PPA Compliance";
    case ViolationType::NA :return "NA";
    default:return "DESCAM::LoggerMsg::getViolationType() - unknown violation type";
  }
}

DESCAM::LoggerMsg::ProcessedLocation DESCAM::LoggerMsg::getProcessedLocation() {
  return processed_location_;
}

void DESCAM::LoggerMsg::setMessage(const std::string &message) {
  message_ = message;
}

void DESCAM::LoggerMsg::setViolationType(DESCAM::LoggerMsg::ViolationType violation_type) {
  violation_type_ = violation_type;
}

void DESCAM::LoggerMsg::setSeverityLevel(DESCAM::LoggerMsg::SeverityLevel severity_level) {
  severity_level_ = severity_level;
}

void DESCAM::LoggerMsg::setLocationInfo(const DESCAM::LocationInfo &stmt_info) {
  location_info_ = stmt_info;
}

void DESCAM::LoggerMsg::setProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation location) {
  processed_location_ = location;
}

std::string DESCAM::LoggerMsg::getProcessedLocationString() {
  switch (processed_location_) {
    case ProcessedLocation::GlobalConstants :return "while adding global constants";
    case ProcessedLocation::Ports :return "while adding module ports";
    case ProcessedLocation::Variables :return "while adding module variables";
    case ProcessedLocation::Behavior :return "while extracting module behavior";
    case ProcessedLocation::Functions :return "while adding module functions";
    case ProcessedLocation::Parsing :return "while parsing";
    default: return "in unknown location";
  }
}

bool DESCAM::LoggerMsg::operator==(const DESCAM::LoggerMsg &other) const {
  if (this == &other) return true;
  return message_ == other.message_ &&
      processed_location_ == other.processed_location_ &&
      severity_level_ == other.severity_level_ &&
      violation_type_ == other.violation_type_ &&
      location_info_ == other.location_info_;
}

