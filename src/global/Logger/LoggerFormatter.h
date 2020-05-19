//
// Created by mi-alkoudsi on 19.03.20.
//


#ifndef DESCAM_LOGGERFORMATTER_H
#define DESCAM_LOGGERFORMATTER_H

#include <string>
#include <vector>
#include <memory>
#include "LoggerMsg.h"


namespace SCAM {
/*!
 * \brief The base class for a logger sink to which all log messages are fed after being collected.
 */
    class LoggerFormatter {
    public:
        enum class FormatOption{
            TEXT, JSON,
        };
        LoggerFormatter() = default;
        static const std::string formatMessages(std::vector<SCAM::LoggerMsg> loggerMessages, FormatOption formatOption = FormatOption::JSON);
        static std::string getFormatFileType(FormatOption formatOption);
    private:
        static std::string getMessages(std::vector<SCAM::LoggerMsg> loggerMessages);
        static std::string getMessagesJSON(std::vector<SCAM::LoggerMsg> loggerMessages);
    };
}


#endif //DESCAM_LOGGERFORMATTER_H
