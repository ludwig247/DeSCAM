//
// Created by mi-alkoudsi on 19.03.20.
//

#ifndef DESCAM_CONSOLESINK_H
#define DESCAM_CONSOLESINK_H

#include <string>
#include "LoggerSink.h"
#include <iostream>

namespace SCAM {
/*!
 * \brief A logger sink that outputs log messages to the console.
 */
    class ConsoleSink : public LoggerSink {
    public:
        void print(std::string formattedOutput) override;
    };
}


#endif //DESCAM_CONSOLESINK_H

