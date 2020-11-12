//
// Created by tom on 03.11.20.
//


#include <gtest/gtest.h>
#include "PrintSVA_Test.h"


int main(int argc, char **argv) {
    std::shared_ptr<LoggerSink> consoleSink = std::make_shared<DESCAM::ConsoleSink>();
    consoleSink->setFormatOption(LoggerFormatter::FormatOption::TEXT);
    DESCAM::Logger::addSink(consoleSink);

    std::shared_ptr<LoggerSink> fileSink = std::make_shared<DESCAM::FileSink>(std::string(SCAM_HOME"/bin/LOGS"), true);
    fileSink->setFormatOption(LoggerFormatter::FormatOption::JSON);
    DESCAM::Logger::addSink(fileSink);

    DESCAM::Logger::setFilteringOptions(std::set<LoggerFilter::FilterOptions>{LoggerFilter::FilterOptions::showAllMsgs});
    DESCAM::Logger::setPrintDecorativeFrames();

    testing::InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();
}
