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

        LoggerMsg(const std::string &message,  const std::string &statement, const SCAM::StmtLocationInfo& stmtLocationInfo, SeverityLevel severityLevel, ViolationType violationType);

        const std::string &getMessage();

        const std::string &getStatement();

        const SCAM::StmtLocationInfo& getStmtLocationInfo();

        std::string getSeverityLevel();

        std::string getViolationType();

        inline void setMessage(const std::string &message);

        inline void setStatement(const std::string &statement);

        inline void setStmtLocationInfo(const SCAM::StmtLocationInfo& stmtLocationInfo);

        inline void setViolationType(ViolationType violationType);

        inline void setSeverityLevel(SeverityLevel severityLevel);

    protected:
        std::string message = "",  statement = "";
        SCAM::StmtLocationInfo stmtLocationInfo;
        ViolationType violationType = ViolationType::NA;
        SeverityLevel severityLevel = SeverityLevel::Info;
    };
}
#endif //DESCAM_ERRORMSG_H
