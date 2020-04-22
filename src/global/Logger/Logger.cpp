#include <iostream>
#include "Logger.h"
#include "TextFormatter.h"

bool SCAM::Logger::terminate = false;


SCAM::Logger &SCAM::Logger::getInstance() {
    static Logger instance;
    return instance;
}


bool SCAM::Logger::hasError() {
    return !Logger::getInstance().msgsVector.empty();
}


void SCAM::Logger::clear() {
    Logger::getInstance().msgsVector.clear();
}

bool SCAM::Logger::isTerminate() {
    return terminate;
}

void SCAM::Logger::setTerminate() {
    terminate = true;
}

void SCAM::Logger::addMsg(LoggerMsg msg) {
    Logger::getInstance().msgsVector.emplace_back(msg);
}


void SCAM::Logger::addSink(std::shared_ptr<SCAM::LoggerSink> sink) {
    Logger::getInstance().sinksVector.emplace_back(sink);
}

void SCAM::Logger::setTextFormatOptions(SCAM::TextFormatter::FormatOptions formatOptions) {
    Logger::getInstance().formatOptions = formatOptions;
}


void SCAM::Logger::log() {
    auto msgsVector = LoggingFilter::applyFilters(Logger::getInstance().msgsVector, Logger::getInstance().filterOptions);
    auto sinkVector = Logger::getInstance().sinksVector;
    if (!sinkVector.empty() && !msgsVector.empty()) {
        auto formattedOutput = SCAM::TextFormatter::formatMessages(msgsVector, Logger::getInstance().formatOptions);
        for (auto sinkPtr = sinkVector.begin(); sinkPtr != sinkVector.end(); sinkPtr++) {
            if (auto sink = sinkPtr->get()) sink->print(formattedOutput);
        }
    }
}

void SCAM::Logger::setCurrentProcessedLocation(SCAM::LoggerMsg::ProcessedLocation currentProcessedLocation) {
    Logger::getInstance().currentProcessedLocation = currentProcessedLocation;
}

SCAM::LoggerMsg::ProcessedLocation SCAM::Logger::getCurrentProcessedLocation() {
    return Logger::getInstance().currentProcessedLocation;
}

void SCAM::Logger::setFilteringOptions(std::set<LoggingFilter::FilterOptions> filterOptions) {
    Logger::getInstance().filterOptions = filterOptions;
}
