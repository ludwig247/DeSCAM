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

namespace DESCAM {
/*!
 * \brief A logger sink that outputs log messages to an output file.
 */
class FileSink : public LoggerSink {
 public:
  explicit FileSink(const std::string& output_directory = std::string(SCAM_HOME"/bin/LOGS"), bool use_time_stamping = true);

  void setOutputDirectory(const std::string& output_directory);

  void setGeneratedFileType(const std::string &filetype);

  void print(std::string formatted_output) override;

 private:
  std::string output_directory_, generated_file_type_ = "txt";
  bool use_time_stamping_;
};
}

#endif //DESCAM_FILESINK_H
