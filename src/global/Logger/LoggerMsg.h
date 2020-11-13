//
// Created by mi-alkoudsi on 19.03.20.
//

#ifndef DESCAM_ERRORMSG_H
#define DESCAM_ERRORMSG_H

#include <string>
#include <LocationInfo.h>

namespace DESCAM {
/*!
 * \brief The base class for a logger message along with its relevant information such file, statement and line numbers
 */
    class LoggerMsg {
    public:
        enum class SeverityLevel {
            Fatal, Error, Warning, Info
        };

        enum class ViolationType {
            Syntax, SystemC_PPA_compliance, NA,
        };

        enum class ProcessedLocation {
            Parsing, GlobalConstants, Behavior, Variables, Functions, Ports
        };

        LoggerMsg() = default;

        LoggerMsg(const std::string &message, const DESCAM::LocationInfo &stmtInfo, SeverityLevel severityLevel,
                  ViolationType violationType, ProcessedLocation violationLocation);

        const std::string &getMessage();

        const DESCAM::LocationInfo &getLocationInfo();

        std::string getSeverityLevel();

        std::string getViolationType();

        ProcessedLocation  getProcessedLocation();

        std::string getProcessedLocationString();

        inline void setMessage(const std::string &message);

        inline void setLocationInfo(const DESCAM::LocationInfo &stmt_info);

        inline void setViolationType(ViolationType violation_type);

        inline void setSeverityLevel(SeverityLevel severity_level);

        inline void setProcessedLocation(ProcessedLocation location);

        bool operator==(const LoggerMsg &other) const;

    protected:
        std::string message_ = "";
        DESCAM::LocationInfo location_info_;
        ViolationType violation_type_ = ViolationType::NA;
        SeverityLevel severity_level_ = SeverityLevel::Info;
        ProcessedLocation processed_location_ = ProcessedLocation::Behavior;

    };
}
#endif //DESCAM_ERRORMSG_H
