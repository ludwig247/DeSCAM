#include <iostream>
#include "Logger.h"
#include "LoggerFormatter.h"
#include "FileSink.h"
#include <algorithm>

bool SCAM::Logger::terminate = false;

SCAM::Logger &SCAM::Logger::getInstance() {
    static Logger instance;
    return instance;
}

bool SCAM::Logger::hasFeedback() {
    return !Logger::getInstance().msgsVector.empty();
}

void SCAM::Logger::clear() {
    Logger::getInstance().msgsVector.clear();
    Logger::getInstance().tempMsgsMap.clear();
    Logger::getInstance().tmpMsgsVec.clear();
}

bool SCAM::Logger::isTerminate() {
    return terminate;
}

void SCAM::Logger::setTerminate() {
    terminate = true;
}

void SCAM::Logger::resetTerminate() {
    terminate = false;
}

void SCAM::Logger::addMsg(LoggerMsg msg) {
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


void SCAM::Logger::addSink(std::shared_ptr<SCAM::LoggerSink> sink) {
    Logger::getInstance().sinksVector.emplace_back(sink);
}

void SCAM::Logger::log() {
    addTempMsgsToLogger();
    auto msgsVector = LoggerFilter::applyFilters(Logger::getInstance().msgsVector,
                                                 Logger::getInstance().filterOptions);
    auto sinkVector = Logger::getInstance().sinksVector;
    if (!sinkVector.empty() && !msgsVector.empty()) {
        for (auto sinkPtr = sinkVector.begin(); sinkPtr != sinkVector.end(); sinkPtr++) {
            if (auto sink = sinkPtr->get()) {
                auto formattedOutput = SCAM::LoggerFormatter::formatMessages(msgsVector, sink->getFormatOtion());
                if (auto fileSink = dynamic_cast<SCAM::FileSink *>(sink)) {
                    fileSink->setGeneratedFileType(SCAM::LoggerFormatter::getFormatFileType(sink->getFormatOtion()));
                        fileSink->print(formattedOutput);
                } else {
                    //console sink
                    if (Logger::getInstance().printDecorativeFrames)
                        std::cout
                                << "\033[1;31m<---------------------------- Logger ------------------------------->\033[0m"
                                << std::endl;
                    sink->print(formattedOutput);
                    if (Logger::getInstance().printDecorativeFrames)
                        std::cout
                                << "\033[1;31m---------------------------------------------------------------------\033[0m"
                                << std::endl;
                }
            }
        }
    }
}

void SCAM::Logger::setCurrentProcessedLocation(SCAM::LoggerMsg::ProcessedLocation currentProcessedLocation) {
    Logger::getInstance().currentProcessedLocation = currentProcessedLocation;
}

SCAM::LoggerMsg::ProcessedLocation SCAM::Logger::getCurrentProcessedLocation() {
    return Logger::getInstance().currentProcessedLocation;
}

void SCAM::Logger::setFilteringOptions(std::set<LoggerFilter::FilterOptions> filterOptions) {
    Logger::getInstance().filterOptions = filterOptions;
}

void SCAM::Logger::addTempMsgsToLogger() {
    for (const auto &pair :  Logger::getInstance().tempMsgsMap) {
        for (const auto &msg : pair.second) Logger::addMsg(msg);
    }
    Logger::getInstance().tempMsgsMap.clear();
    for (const auto &msg : Logger::getInstance().tmpMsgsVec)
        Logger::addMsg(msg);
    Logger::getInstance().tmpMsgsVec.clear();
}

void SCAM::Logger::clearTempVector() {
    Logger::getInstance().tmpMsgsVec.clear();
}

void SCAM::Logger::tagTempMsgs(std::string objName) {
    Logger::getInstance().tempMsgsMap[objName] = Logger::getInstance().tmpMsgsVec;
    Logger::getInstance().tmpMsgsVec.clear();
}

void SCAM::Logger::removeFromTempMap(std::string objName) {
    if (Logger::getInstance().tempMsgsMap.find(objName) != Logger::getInstance().tempMsgsMap.end())
        Logger::getInstance().tempMsgsMap.erase(objName);
}

#ifdef DEBUG_LOGGER

const std::unordered_map<std::string, std::vector<SCAM::LoggerMsg>> &SCAM::Logger::getTempMsgsMap() {
    return Logger::getInstance().tempMsgsMap;
}

const std::vector<SCAM::LoggerMsg> &SCAM::Logger::getMsgsMap() {
    return Logger::getInstance().msgsVector;
}

void SCAM::Logger::setPrintDecorativeFrames() {
    Logger::getInstance().printDecorativeFrames = true;
}
#endif