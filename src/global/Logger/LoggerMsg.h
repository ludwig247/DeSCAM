//
// Created by mi-alkoudsi on 19.03.20.
//

#ifndef DESCAM_ERRORMSG_H
#define DESCAM_ERRORMSG_H

#include <string>
#include <Stmts/StmtLocationInfo.h>

namespace SCAM {
/*!
 * \brief The base class for a logger message along with its relevant information such file, statement and line numbers
 */
    class LoggerMsg {
    public:
        enum class SeverityLevel {
            Error, Warning, Info
        };

        enum class ViolationType {
            Syntax, SystemC_PPA_compliance, NA,
        };

        LoggerMsg() = default;

        LoggerMsg(const std::string &message, const SCAM::StmtLocationInfo& stmtInfo, SeverityLevel severityLevel, ViolationType violationType);

        const std::string &getMessage();

        const SCAM::StmtLocationInfo& getStmtInfo();

        std::string getSeverityLevel();

        std::string getViolationType();

        inline void setMessage(const std::string &message);

        inline void setStmtInfo(const SCAM::StmtLocationInfo& stmtInfo);

        inline void setViolationType(ViolationType violationType);

        inline void setSeverityLevel(SeverityLevel severityLevel);

    protected:
        std::string message = "",  statement = "";
        SCAM::StmtLocationInfo stmtInfo;
        ViolationType violationType = ViolationType::NA;
        SeverityLevel severityLevel = SeverityLevel::Info;
    };
}
#endif //DESCAM_ERRORMSG_H
