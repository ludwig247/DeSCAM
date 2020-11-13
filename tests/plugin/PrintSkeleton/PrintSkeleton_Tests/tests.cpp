//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>

#include "PrintSkeleton_Test.h"

int main(int argc, char **argv) {
    /* Initialize logger */
    //setting sinks
    std::shared_ptr<LoggerSink> consoleSink = std::make_shared<DESCAM::ConsoleSink>();
    consoleSink->setFormatOption(LoggerFormatter::FormatOption::TEXT);
    DESCAM::Logger::addSink(consoleSink);
    std::shared_ptr<LoggerSink> fileSink = std::make_shared<DESCAM::FileSink>(std::string(SCAM_HOME"/bin/LOGS"),true);
    fileSink->setFormatOption(LoggerFormatter::FormatOption::JSON);
    DESCAM::Logger::addSink(fileSink);
    //setting filtering options
    DESCAM::Logger::setFilteringOptions(std::set<LoggerFilter::FilterOptions>{LoggerFilter::FilterOptions::showAllMsgs});
    DESCAM::Logger::setPrintDecorativeFrames();

    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
