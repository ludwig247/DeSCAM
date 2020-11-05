#include <iostream>
#include "Logger.h"
#include "LoggerFormatter.h"
#include "FileSink.h"
#include <algorithm>
#include <utility>

bool DESCAM::Logger::terminate = false;

DESCAM::Logger &DESCAM::Logger::getInstance() {
  static Logger instance;
  return instance;
}

bool DESCAM::Logger::hasFeedback() {
  return !Logger::getInstance().msgsVector.empty();
}

void DESCAM::Logger::clear() {
  Logger::getInstance().msgsVector.clear();
  Logger::getInstance().tempMsgsMap.clear();
  Logger::getInstance().tmpMsgsVec.clear();
}

bool DESCAM::Logger::isTerminate() {
  return terminate;
}

void DESCAM::Logger::setTerminate() {
  terminate = true;
}

void DESCAM::Logger::resetTerminate() {
  terminate = false;
}

void DESCAM::Logger::addMsg(const LoggerMsg &msg) {
  if (Logger::getInstance().currentProcessedLocation == LoggerMsg::ProcessedLocation::GlobalConstants) {
    auto tmpVec = Logger::getInstance().tmpMsgsVec;
    if (std::find(tmpVec.begin(), tmpVec.end(), msg) == tmpVec.end())
      Logger::getInstance().tmpMsgsVec.push_back(msg);
  } else {
    auto msgsVec = Logger::getInstance().msgsVector;
    if (std::find(msgsVec.begin(), msgsVec.end(), msg) == msgsVec.end())
      Logger::getInstance().msgsVector.push_back(msg);
  }
}

void DESCAM::Logger::addSink(const std::shared_ptr<DESCAM::LoggerSink> &sink) {
  Logger::getInstance().sinksVector.emplace_back(sink);
}

void DESCAM::Logger::log() {
  addTempMsgsToLogger();
  auto msgsVector = LoggerFilter::applyFilters(Logger::getInstance().msgsVector, Logger::getInstance().filterOptions);
  auto sinkVector = Logger::getInstance().sinksVector;
  if (!sinkVector.empty() && !msgsVector.empty()) {
    for (auto &sinkPtr : sinkVector) {
      if (auto sink = sinkPtr.get()) {
        auto formattedOutput = DESCAM::LoggerFormatter::formatMessages(msgsVector, sink->getFormatOption());
        sink->print(formattedOutput);
      }
    }
  }
}

void DESCAM::Logger::setCurrentProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation currentProcessedLocation) {
  Logger::getInstance().currentProcessedLocation = currentProcessedLocation;
}

DESCAM::LoggerMsg::ProcessedLocation DESCAM::Logger::getCurrentProcessedLocation() {
  return Logger::getInstance().currentProcessedLocation;
}

void DESCAM::Logger::setFilteringOptions(std::set<LoggerFilter::FilterOptions> filterOptions) {
  Logger::getInstance().filterOptions = std::move(filterOptions);
}

void DESCAM::Logger::addTempMsgsToLogger() {
  for (const auto &pair :  Logger::getInstance().tempMsgsMap) {
    for (const auto &msg : pair.second) Logger::addMsg(msg);
  }
  Logger::getInstance().tempMsgsMap.clear();
  for (const auto &msg : Logger::getInstance().tmpMsgsVec)
    Logger::addMsg(msg);
  Logger::getInstance().tmpMsgsVec.clear();
}

void DESCAM::Logger::clearTempVector() {
  Logger::getInstance().tmpMsgsVec.clear();
}

void DESCAM::Logger::tagTempMsgs(const std::string &objName) {
  Logger::getInstance().tempMsgsMap[objName] = Logger::getInstance().tmpMsgsVec;
  Logger::getInstance().tmpMsgsVec.clear();
}

void DESCAM::Logger::removeFromTempMap(const std::string &objName) {
  if (Logger::getInstance().tempMsgsMap.find(objName) != Logger::getInstance().tempMsgsMap.end())
    Logger::getInstance().tempMsgsMap.erase(objName);
}

#ifdef DEBUG_LOGGER

const std::unordered_map<std::string, std::vector<DESCAM::LoggerMsg>> &DESCAM::Logger::getTempMsgsMap() {
  return Logger::getInstance().tempMsgsMap;
}

const std::vector<DESCAM::LoggerMsg> &DESCAM::Logger::getMsgsMap() {
  return Logger::getInstance().msgsVector;
}

void DESCAM::Logger::setPrintDecorativeFrames() {
  Logger::getInstance().printDecorativeFrames = true;
}

#endif