#include "Logger_test.h"

TEST_F(Logger_test, LoggerMsg_SettersGetters) {
    std::string fileDir = "fileDir/file.txt",
            message = "message",
            statement = "statement";
    SCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
    auto sl = SCAM::LoggerMsg::SeverityLevel::Info;
    auto vt = SCAM::LoggerMsg::ViolationType::NA;
    auto pl = SCAM::LoggerMsg::ProcessedLocation::Behavior;
    SCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
    auto locationInfo = msg.getLocationInfo();
    ASSERT_EQ(msg.getMessage(), message) << "LoggerMsg.getMessage() failed\n";
    ASSERT_EQ(locationInfo.getFile(), fileDir) << "LoggerMsg.getLocationInfo().getFile() failed\n";
    ASSERT_EQ(locationInfo.getStmt(), statement) << "LoggerMsg.getLocationInfo().getStatement() failed\n";
    ASSERT_EQ(locationInfo.getRowStartNumber(), 1) << "LoggerMsg.getLocationInfo().getRowStartNumber() failed\n";
    ASSERT_EQ(locationInfo.getRowEndNumber(), 2) << "LoggerMsg.getLocationInfo().getRowEndNumber() failed\n";
    ASSERT_EQ(locationInfo.getColumnStartNumber(), 3) << "LoggerMsg.getLocationInfo().getColumnStartNumber() failed\n";
    ASSERT_EQ(locationInfo.getColumnEndNumber(), 4) << "LoggerMsg.getLocationInfo().getColumnEndNumber() failed\n";
}

TEST_F(Logger_test, Logger_add_clear_msgs) {
    for (auto msg : msgsVector) {
        SCAM::Logger::addMsg(msg);
        ASSERT_NE(SCAM::Logger::hasFeedback(), false) << "Adding msg to the logger failed\n";
        SCAM::Logger::clear();
        ASSERT_NE(SCAM::Logger::hasFeedback(), true) << "Clearing the logger failed\n";
    }
}

TEST_F(Logger_test, Logger_text_format_JSON) {
    auto formatedString = SCAM::LoggerFormatter::formatMessages(msgsVector, SCAM::LoggerFormatter::FormatOptions::JSON);
    std::string refContent;
    GET_CONTENT_FROM_FILE("TextFormater.txt", refContent)
    ASSERT_EQ(refContent, formatedString) << "Text formatter with option JSON failed\n";
}

TEST_F(Logger_test, Logger_file_sink) {
    std::string dirPath = SCAM_HOME"/tests/global/Logger/ref_files/";
    SCAM::FileSink fileSink(dirPath, false);
    std::string test = "This is a fileSink test\n", content;
    fileSink.print(test);
    GET_CONTENT_FROM_FILE("LOGS.txt", content)
    ASSERT_EQ(content, test) << "Logger's FileSink failed\n";
}

TEST_F(Logger_test, Logger_msg_filter) {
    std::set<SCAM::LoggerFilter::FilterOptions> filterOptions;
    // Syntax errors only
    {
        filterOptions = {SCAM::LoggerFilter::FilterOptions::showSyntaxMsgs};
        auto messages = SCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
        ASSERT_EQ(messages.size(), 1)
                                    << "Expected 1 LoggerMsg after filtering, logging filter with option showSyntaxMsgs failed\n";
        ASSERT_EQ(messages[0].getProcessedLocationString(), msgsVector[1].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
    }
    {
        filterOptions = {SCAM::LoggerFilter::FilterOptions::showFunctionMsgs,
                         SCAM::LoggerFilter::FilterOptions::showGlobalConstantMsgs};
        auto messages = SCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
        ASSERT_EQ(messages.size(), 2)
                                    << "Expected 2 LoggerMsg after filtering, logging filter with options (showFunctionMsgs,showGlobalConstantMsgs) failed\n";
        ASSERT_EQ(messages[0].getProcessedLocationString(), msgsVector[0].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
        ASSERT_EQ(messages[1].getProcessedLocationString(), msgsVector[3].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
    }
    {
        filterOptions = {SCAM::LoggerFilter::FilterOptions::showBehaviorMsgs};
        auto messages = SCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
        ASSERT_EQ(messages.size(), 1)
                                    << "Expected 2 LoggerMsg after filtering, logging filter with option showBehaviorMsgs failed\n";
        ASSERT_EQ(messages[0].getProcessedLocationString(), msgsVector[2].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
    }
    {
        filterOptions = {
                SCAM::LoggerFilter::FilterOptions::showCompilanceMsgs}; // this covers all types except syntax errors
        auto messages = SCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
        ASSERT_EQ(messages.size(), 3)
                                    << "Expected 2 LoggerMsg after filtering, logging filter with option showCompilanceMsgs failed\n";
        ASSERT_EQ(messages[0].getProcessedLocationString(), msgsVector[0].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
        ASSERT_EQ(messages[1].getProcessedLocationString(), msgsVector[2].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
        ASSERT_EQ(messages[2].getProcessedLocationString(), msgsVector[3].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
    }
}

TEST_F(Logger_test, Logger_log_filter_out_global) {
    std::string logDir = SCAM_HOME"/tests/global/Logger/ref_files/";
    SCAM::Logger::addSink(std::make_shared<SCAM::FileSink>(logDir, false));
    SCAM::Logger::setTextFormatOptions(SCAM::LoggerFormatter::FormatOptions::JSON);
    SCAM::Logger::setFilteringOptions(
            std::set<SCAM::LoggerFilter::FilterOptions>{SCAM::LoggerFilter::FilterOptions::showAllMsgs});
    for (auto msg : msgsVector) {
        SCAM::Logger::setCurrentProcessedLocation(msg.getProcessedLocation());
        SCAM::Logger::addMsg(msg);
    }
    // remove loggerMsgs of global constant if deemed unrelated or error during parsing a global function occured
    SCAM::Logger::clearTempVector();
    SCAM::Logger::log();
    // checking the output
    FilterOptionsSet_NoGlobalConstants(filterOptionsSet)
    auto filteredMessagesVector = SCAM::LoggerFilter::applyFilters(msgsVector, filterOptionsSet);
    std::string formatedOutput = SCAM::LoggerFormatter::formatMessages(filteredMessagesVector,
                                                                       SCAM::LoggerFormatter::FormatOptions::JSON), logsFileContent;
    GET_CONTENT_FROM_FILE("LOGS.JSON", logsFileContent)
    ASSERT_EQ(logsFileContent, formatedOutput);
}


TEST_F(Logger_test, Logger_log_filter_out_global_2) {
    std::string logDir = SCAM_HOME"/tests/global/Logger/ref_files/";
    SCAM::Logger::addSink(std::make_shared<SCAM::FileSink>(logDir, false));
    SCAM::Logger::setTextFormatOptions(SCAM::LoggerFormatter::FormatOptions::JSON);
    SCAM::Logger::setFilteringOptions(
            std::set<SCAM::LoggerFilter::FilterOptions>{SCAM::LoggerFilter::FilterOptions::showAllMsgs});
    for (auto msg : msgsVector) {
        SCAM::Logger::setCurrentProcessedLocation(msg.getProcessedLocation());
        SCAM::Logger::addMsg(msg);
    }
    auto logerMsgs = SCAM::Logger::getMsgsMap();
    //Tag collected global constant messages to a variable or function name
    SCAM::Logger::tagTempMsgs("FuncName");
    //
    //
    // Now we can remove messages related to a specific function or variable if deemed unrelated
    SCAM::Logger::removeFromTempMap("FuncName");
    logerMsgs = SCAM::Logger::getMsgsMap();
    SCAM::Logger::log();
    // checking the output
    FilterOptionsSet_NoGlobalConstants(filterOptionsSet)
    auto filteredMessagesVector = SCAM::LoggerFilter::applyFilters(msgsVector, filterOptionsSet);
    std::string formatedOutput = SCAM::LoggerFormatter::formatMessages(filteredMessagesVector,
                                                                       SCAM::LoggerFormatter::FormatOptions::JSON), logsFileContent;
    GET_CONTENT_FROM_FILE("LOGS.JSON", logsFileContent)
    ASSERT_EQ(logsFileContent, formatedOutput);
}


Logger_test::Logger_test() {
    {
        std::string fileDir = "fileDir/file1.h", message = "message1", statement = "statement1";
        SCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = SCAM::LoggerMsg::SeverityLevel::Info;
        auto vt = SCAM::LoggerMsg::ViolationType::NA;
        auto pl = SCAM::LoggerMsg::ProcessedLocation::Functions;
        SCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
    {
        std::string fileDir = "fileDir/file2.h", message = "message2", statement = "statement2";
        SCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = SCAM::LoggerMsg::SeverityLevel::Error;
        auto vt = SCAM::LoggerMsg::ViolationType::Syntax;
        auto pl = SCAM::LoggerMsg::ProcessedLocation::Parsing;
        SCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
    {
        std::string fileDir = "fileDir/file3.h", message = "message3", statement = "statement3";
        SCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = SCAM::LoggerMsg::SeverityLevel::Warning;
        auto vt = SCAM::LoggerMsg::ViolationType::SystemC_PPA_compliance;
        auto pl = SCAM::LoggerMsg::ProcessedLocation::Behavior;
        SCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
    {
        std::string fileDir = "fileDir/file4.h", message = "message4", statement = "statement4";
        SCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = SCAM::LoggerMsg::SeverityLevel::Error;
        auto vt = SCAM::LoggerMsg::ViolationType::SystemC_PPA_compliance;
        auto pl = SCAM::LoggerMsg::ProcessedLocation::GlobalConstants;
        SCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
}
