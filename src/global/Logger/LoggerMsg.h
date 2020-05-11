//
// Created by mi-alkoudsi on 19.03.20.
//

#ifndef DESCAM_ERRORMSG_H
#define DESCAM_ERRORMSG_H

#include <string>
#include <LocationInfo.h>

namespace SCAM {
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

        LoggerMsg(const std::string &message, const SCAM::LocationInfo &stmtInfo, SeverityLevel severityLevel,
                  ViolationType violationType, ProcessedLocation violationLocation);

        const std::string &getMessage();

        const SCAM::LocationInfo &getLocationInfo();

        std::string getSeverityLevel();

        std::string getViolationType();

        ProcessedLocation  getProcessedLocation();

        std::string getProcessedLocationString();

        inline void setMessage(const std::string &message);

        inline void setLocationInfo(const SCAM::LocationInfo &stmtInfo);

        inline void setViolationType(ViolationType violationType);

        inline void setSeverityLevel(SeverityLevel severityLevel);

        inline void setProcessedLocation(ProcessedLocation location);

        bool operator==(const LoggerMsg &other) const;

    protected:
        std::string message = "";
        SCAM::LocationInfo locationInfo;
        ViolationType violationType = ViolationType::NA;
        SeverityLevel severityLevel = SeverityLevel::Info;
        ProcessedLocation processedLocation = ProcessedLocation::Behavior;

    };
}
#endif //DESCAM_ERRORMSG_H
