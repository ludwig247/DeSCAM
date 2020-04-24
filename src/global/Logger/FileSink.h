//
// Created by mi-alkoudsi on 19.03.20.
//

#ifndef DESCAM_FILESINK_H
#define DESCAM_FILESINK_H

#include <string>
#include "LoggerSink.h"
#include <utility>
#include <fstream>
#include <sys/stat.h>
#include <ctime>
#include <Config.h>


namespace SCAM {
/*!
 * \brief A logger sink that outputs log messages to an output file.
 */
    class FileSink : public LoggerSink {
    public:
        FileSink() = default;

        explicit FileSink(std::string outputDirectory);

        void setOutputDirectory(std::string outputDirectory);

        void print(std::string formattedOutput) override;
    private:
        std::string outputDirectory = std::string(SCAM_HOME"/bin/LOGS");
    };
}


#endif //DESCAM_FILESINK_H
