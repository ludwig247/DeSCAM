//
// Created by mi-alkoudsi on 19.03.20.
//


#ifndef DESCAM_TEXTFORMATTER_H
#define DESCAM_TEXTFORMATTER_H

#include <string>
#include <vector>
#include <memory>
#include "LoggerMsg.h"


namespace SCAM {
/*!
 * \brief The base class for a logger sink to which all log messages are fed after being collected.
 */
    class TextFormatter {
    public:
        enum class FormatOptions{
            JSON,
        };
        TextFormatter() = default;
        static const std::string formatMessages(std::vector<SCAM::LoggerMsg> loggerMessages, FormatOptions formatOptions = FormatOptions::JSON);

    private:
        static std::string getMessagesJSON(std::vector<SCAM::LoggerMsg> loggerMessages);
    };
}


#endif //DESCAM_TEXTFORMATTER_H
