#include <iostream>
#include "FileSink.h"
#include "FatalError.h"
#include "Logger/Logger.h"


DESCAM::FileSink::FileSink(std::string outputDirectory, bool useTimeStamping) : useTimeStamping(useTimeStamping) {
    setOutputDirectory(outputDirectory);
}

void DESCAM::FileSink::setOutputDirectory(std::string outputDirectory) {
    struct stat st_buf{};
    int status = stat(outputDirectory.c_str(), &st_buf);
    if(status == 0 && S_ISDIR (st_buf.st_mode)) this->outputDirectory = outputDirectory;
}


void DESCAM::FileSink::print(std::string formattedOutput) {
    struct stat st_buf{};
    int status = stat(this->outputDirectory.c_str(), &st_buf);
    //If directory doesn't exist, make it
    if (status != 0) {
        mkdir(this->outputDirectory.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    std::string timeStamp = "",slash = "/";
    if(useTimeStamping) {
        //Getting the current time for naming the logs file
        time_t now = time(0);
        auto lt = localtime(&now);
        timeStamp = "_" +
                std::to_string(1 + lt->tm_hour) + ":" + std::to_string(1 + lt->tm_min) + "_" +
                std::to_string(lt->tm_mday) + "." + std::to_string(1 + lt->tm_mon) + "." +
                std::to_string(1900 + lt->tm_year);
    }
    //write output
    std::ofstream fileStream;
    if(outputDirectory[outputDirectory.size()-1] == '/') slash = "";
    std::string outputFileName = this->outputDirectory + slash + "LOGS" + timeStamp + "." + generatedFileType;
    fileStream.open(outputFileName);
    fileStream << formattedOutput;
    fileStream.close();
    std::cout << "\033[1;31mLogs written to " << outputFileName << "\033[0m" <<  std::endl;
}

void DESCAM::FileSink::setGeneratedFileType(const std::string &filetype) {
    this->generatedFileType = filetype;
}

