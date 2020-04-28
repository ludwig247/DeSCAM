#include <iostream>
#include "FileSink.h"
#include "FatalError.h"
#include "Logger/Logger.h"


SCAM::FileSink::FileSink(std::string outputDirectory) : outputDirectory(std::move(outputDirectory)) {}

void SCAM::FileSink::setOutputDirectory(std::string outputDirectory) {
    this->outputDirectory = outputDirectory;
}

void SCAM::FileSink::print(std::string formattedOutput) {
    struct stat st_buf{};
    int status = stat(this->outputDirectory.c_str(), &st_buf);
    // if outputDirectory is not valid, abort
    if (status == 0 && !S_ISDIR (st_buf.st_mode)) {
        TERMINATE("The given output directory to the logger sink is not valid");
    }
    //If directory doesn't exist, make it
    if (status != 0) {
        mkdir(this->outputDirectory.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    //Getting the current time for naming the logs file
    time_t now = time(0);
    auto lt = localtime(&now);
    std::string timeStamp =
            std::to_string(1 + lt->tm_hour) + ":" + std::to_string(1 + lt->tm_min) + "_" +
            std::to_string(lt->tm_mday) + "." + std::to_string(1 + lt->tm_mon) + "." +
            std::to_string(1900 + lt->tm_year);
    //write output
    std::ofstream fileStream;
    std::string outputFileName = this->outputDirectory + "/" + "LOGS_" + timeStamp + ".txt";
    fileStream.open(outputFileName);
    fileStream << formattedOutput;
    fileStream.close();
    std::cout << "\033[1;31mLogs written to " << outputFileName << "\033[0m" <<  std::endl;
};

