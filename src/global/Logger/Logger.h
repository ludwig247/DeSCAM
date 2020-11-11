//
// Created by mi-alkoudsi 19.03.2020.
//

#ifndef SCAM_ERRORMSG_H
#define SCAM_ERRORMSG_H

#define DEBUG_LOGGER

#include <string>
#include <vector>
#include <set>
#include <unordered_set>
#include <unordered_map>
#include <memory>
#include "LoggerMsg.h"
#include "LoggerSink.h"
#include "LoggerFormatter.h"
#include "LoggerFilter.h"
#include "Expr.h"

namespace DESCAM {

/*!
 * \brief A singelton that stores and reports logging messages during the creation of the SystemC PPA model
 */
class Logger {
 public:

  static Logger &getInstance();

  static void setTerminate();
  static void resetTerminate();
  static bool isTerminate();

  static void addMsg(const LoggerMsg &);

  static bool hasFeedback();

  static void clear();

  static void addSink(const std::shared_ptr<DESCAM::LoggerSink> &sink);

  static void setFilteringOptions(std::set<LoggerFilter::FilterOptions> filterOptions);

  static void setCurrentProcessedLocation(LoggerMsg::ProcessedLocation currentProcessedLocation);

  static LoggerMsg::ProcessedLocation getCurrentProcessedLocation();

  static void setPrintDecorativeFrames();

  static void log();

  static void clearTempVector();
  static void tagTempMsgs(const std::string &objName);
  static void removeFromTempMap(const std::string &objName);

#ifdef DEBUG_LOGGER
  static const std::unordered_map<std::string, std::vector<LoggerMsg>> &getTempMsgsMap();
  static const std::vector<DESCAM::LoggerMsg> &getMsgsMap();
#endif
  //DELETED
  Logger(Logger const &) = delete;             // copy constructor is private
  Logger &operator=(Logger const &) = delete; // assignment operator is private
 private:
  //CONSTRUCTOR
  Logger() = default;

  //Destructor
  ~Logger() = default;

  static void addTempMsgsToLogger();

  // a vector containing the logger messages
  std::vector<LoggerMsg> msgsVector{};
  // containing messages collected during the processing of global constants, of which only model relevant ones will be added to msgsVector before logging.
  std::vector<LoggerMsg> tmpMsgsVec;
  std::unordered_map<std::string, std::vector<LoggerMsg>> tempMsgsMap{};
  // a vector holding the lsetogger sinks
  std::vector<std::shared_ptr<LoggerSink>> sinksVector{};
  //a flag indicating whether termination is necessary due to errors
  static bool terminate;
  //logging options set
  std::set<LoggerFilter::FilterOptions> filterOptions;
  // a variable to track the violation location while processing a module
  LoggerMsg::ProcessedLocation currentProcessedLocation = LoggerMsg::ProcessedLocation::Parsing;
  // if set, the logger prints decorative frames around console messages
  bool printDecorativeFrames = false;

  // friend classes accesses field printDecorativeFrames.
  // FIXME Provide getter or adapt the interface of the friend classes so they no longer need to be friends.
  friend class ConsoleSink;
  friend class FileSink;
};
}

#endif //SCAM_ERRORMSG_H
