//
// Created by mi-alkoudsi on 19.03.20.
//


#ifndef DESCAM_LOGGERSINK_H
#define DESCAM_LOGGERSINK_H

#include <string>
#include "LoggerFormatter.h"

namespace DESCAM {
/*!
 * \brief The base class for a logger sink to which all log messages are fed after being collected.
 */
    class LoggerSink {
    public:
        virtual void print(std::string formattedOutput) = 0;
        void setFormatOption(LoggerFormatter::FormatOption formatOption){this->formatOption = formatOption;}
        LoggerFormatter::FormatOption getFormatOtion() {return this->formatOption;}
    private:
        LoggerFormatter::FormatOption formatOption = LoggerFormatter::FormatOption::JSON;
    };
}

#endif //DESCAM_LOGGERSINK_H
