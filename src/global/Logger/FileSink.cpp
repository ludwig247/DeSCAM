#include <iostream>
#include "FileSink.h"

DESCAM::FileSink::FileSink(const std::string& output_directory, bool use_time_stamping) : use_time_stamping_(use_time_stamping) {
  setOutputDirectory(output_directory);
}

void DESCAM::FileSink::setOutputDirectory(const std::string& output_directory) {
  struct stat st_buf{};
  int status = stat(output_directory.c_str(), &st_buf);
  if (status == 0 && S_ISDIR (st_buf.st_mode) || status != 0) {
    output_directory_ = output_directory;
  }
}

void DESCAM::FileSink::print(std::string formatted_output) {
  generated_file_type_ = DESCAM::LoggerFormatter::getFormatFileType(getFormatOption());

  struct stat st_buf{};
  int status = stat(output_directory_.c_str(), &st_buf);
  //If directory doesn't exist, make it
  if (status != 0) {
    mkdir(output_directory_.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
  }
  std::string timeStamp, slash = "/";
  if (use_time_stamping_) {
    //Getting the current time for naming the logs file
    time_t now = time(nullptr);
    auto lt = localtime(&now);
    timeStamp = "_" +
        std::to_string(1 + lt->tm_hour) + ":" + std::to_string(1 + lt->tm_min) + "_" +
        std::to_string(lt->tm_mday) + "." + std::to_string(1 + lt->tm_mon) + "." +
        std::to_string(1900 + lt->tm_year);
  }
  //write output
  std::ofstream fileStream;
  if (output_directory_[output_directory_.size() - 1] == '/') slash = "";
  std::string outputFileName = output_directory_ + slash + "LOGS" + timeStamp + "." + generated_file_type_;
  fileStream.open(outputFileName);
  fileStream << formatted_output;
  fileStream.close();
  std::cout << "\033[1;31mLogs written to " << outputFileName << "\033[0m" << std::endl;
}

void DESCAM::FileSink::setGeneratedFileType(const std::string &filetype) {
  generated_file_type_ = filetype;
}

