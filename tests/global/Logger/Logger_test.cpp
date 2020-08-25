#include "Logger_test.h"
#include "Stmts_all.h"
#include "DescamException.h"

TEST_F(Logger_test, LoggerMsg_SettersGetters) {
    std::string fileDir = "fileDir/file.txt",
            message = "message",
            statement = "statement";
    DESCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
    auto sl = DESCAM::LoggerMsg::SeverityLevel::Info;
    auto vt = DESCAM::LoggerMsg::ViolationType::NA;
    auto pl = DESCAM::LoggerMsg::ProcessedLocation::Behavior;
    DESCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
    auto locationInfo = msg.getLocationInfo();
    ASSERT_EQ(msg.getMessage(), message) << "LoggerMsg.getMessage() failed\n";
    ASSERT_EQ(locationInfo.getFile(), fileDir) << "LoggerMsg.getLocationInfo().getFile() failed\n";
    ASSERT_EQ(locationInfo.getObject(), statement) << "LoggerMsg.getLocationInfo().getObject() failed\n";
    ASSERT_EQ(locationInfo.getRowStartNumber(), 1) << "LoggerMsg.getLocationInfo().getRowStartNumber() failed\n";
    ASSERT_EQ(locationInfo.getRowEndNumber(), 2) << "LoggerMsg.getLocationInfo().getRowEndNumber() failed\n";
    ASSERT_EQ(locationInfo.getColumnStartNumber(), 3) << "LoggerMsg.getLocationInfo().getColumnStartNumber() failed\n";
    ASSERT_EQ(locationInfo.getColumnEndNumber(), 4) << "LoggerMsg.getLocationInfo().getColumnEndNumber() failed\n";
}

TEST_F(Logger_test, Logger_add_clear_msgs) {
    for (auto msg : msgsVector) {
        DESCAM::Logger::addMsg(msg);
        ASSERT_NE(DESCAM::Logger::hasFeedback(), false) << "Adding msg to the logger failed\n";
        DESCAM::Logger::clear();
        ASSERT_NE(DESCAM::Logger::hasFeedback(), true) << "Clearing the logger failed\n";
    }
}

TEST_F(Logger_test, Logger_text_format_JSON) {
    auto formatedString = DESCAM::LoggerFormatter::formatMessages(msgsVector, DESCAM::LoggerFormatter::FormatOption::JSON);
    std::string refContent;
    GET_CONTENT_FROM_FILE("TextFormater.JSON", refContent)
    ASSERT_EQ(refContent, formatedString) << "Text formatter with option JSON failed\n";
}

TEST_F(Logger_test, Logger_text_format_Normal) {
    auto formatedString = DESCAM::LoggerFormatter::formatMessages(msgsVector, DESCAM::LoggerFormatter::FormatOption::TEXT);
    std::string refContent;
    GET_CONTENT_FROM_FILE("TextFormater.txt", refContent)
    ASSERT_EQ(refContent, formatedString) << "Text formatter with option JSON failed\n";
}

TEST_F(Logger_test, Logger_file_sink) {
    std::string dirPath = SCAM_HOME"/tests/global/Logger/ref_files/";
    DESCAM::FileSink fileSink(dirPath, false);
    std::string test = "This is a fileSink test\n", content;
    fileSink.print(test);
    GET_CONTENT_FROM_FILE("LOGS.txt", content)
    ASSERT_EQ(content, test) << "Logger's FileSink failed\n";
}

TEST_F(Logger_test, Logger_msg_filter) {
    std::set<DESCAM::LoggerFilter::FilterOptions> filterOptions;
    // Syntax errors only
    {
        filterOptions = {DESCAM::LoggerFilter::FilterOptions::showSyntaxMsgs};
        auto messages = DESCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
        ASSERT_EQ(messages.size(), 1)
                                    << "Expected 1 LoggerMsg after filtering, logging filter with option showSyntaxMsgs failed\n";
        ASSERT_EQ(messages[0].getProcessedLocationString(), msgsVector[1].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
    }
    {
        filterOptions = {DESCAM::LoggerFilter::FilterOptions::showFunctionMsgs,
                         DESCAM::LoggerFilter::FilterOptions::showGlobalConstantMsgs};
        auto messages = DESCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
        ASSERT_EQ(messages.size(), 2)
                                    << "Expected 2 LoggerMsg after filtering, logging filter with options (showFunctionMsgs,showGlobalConstantMsgs) failed\n";
        ASSERT_EQ(messages[0].getProcessedLocationString(), msgsVector[0].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
        ASSERT_EQ(messages[1].getProcessedLocationString(), msgsVector[3].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
    }
    {
        filterOptions = {DESCAM::LoggerFilter::FilterOptions::showBehaviorMsgs};
        auto messages = DESCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
        ASSERT_EQ(messages.size(), 1)
                                    << "Expected 2 LoggerMsg after filtering, logging filter with option showBehaviorMsgs failed\n";
        ASSERT_EQ(messages[0].getProcessedLocationString(), msgsVector[2].getProcessedLocationString())
                                    << "logging filter with option showSyntaxMsgs failed\n";
    }
    {
        filterOptions = {
                DESCAM::LoggerFilter::FilterOptions::showCompilanceMsgs}; // this covers all types except syntax errors
        auto messages = DESCAM::LoggerFilter::applyFilters(msgsVector, filterOptions);
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
    auto fileSink = std::make_shared<DESCAM::FileSink>(logDir, false);
    fileSink->setFormatOption(DESCAM::LoggerFormatter::FormatOption::JSON);
    DESCAM::Logger::addSink(fileSink);
    DESCAM::Logger::setFilteringOptions(
            std::set<DESCAM::LoggerFilter::FilterOptions>{DESCAM::LoggerFilter::FilterOptions::showAllMsgs});
    for (auto msg : msgsVector) {
        DESCAM::Logger::setCurrentProcessedLocation(msg.getProcessedLocation());
        DESCAM::Logger::addMsg(msg);
    }
    // remove loggerMsgs of global constant if deemed unrelated or error during parsing a global function occured
    DESCAM::Logger::clearTempVector();
    DESCAM::Logger::log();
    // checking the output
    FilterOptionsSet_NoGlobalConstants(filterOptionsSet)
    auto filteredMessagesVector = DESCAM::LoggerFilter::applyFilters(msgsVector, filterOptionsSet);
    std::string formatedOutput = DESCAM::LoggerFormatter::formatMessages(filteredMessagesVector,
                                                                       DESCAM::LoggerFormatter::FormatOption::JSON), logsFileContent;
    GET_CONTENT_FROM_FILE("LOGS.JSON", logsFileContent)
    ASSERT_EQ(logsFileContent, formatedOutput);
    DESCAM::Logger::clear();
}


TEST_F(Logger_test, Logger_log_filter_out_global_2) {
    std::string logDir = SCAM_HOME"/tests/global/Logger/ref_files/";
    auto fileSink = std::make_shared<DESCAM::FileSink>(logDir, false);
    fileSink->setFormatOption(DESCAM::LoggerFormatter::FormatOption::JSON);
    DESCAM::Logger::addSink(fileSink);
    DESCAM::Logger::setFilteringOptions(
            std::set<DESCAM::LoggerFilter::FilterOptions>{DESCAM::LoggerFilter::FilterOptions::showAllMsgs});
    for (auto msg : msgsVector) {
        DESCAM::Logger::setCurrentProcessedLocation(msg.getProcessedLocation());
        DESCAM::Logger::addMsg(msg);
    }
    auto logerMsgs = DESCAM::Logger::getMsgsMap();
    //Tag collected global constant messages to a variable or function name
    DESCAM::Logger::tagTempMsgs("FuncName");
    //
    //
    // Now we can remove messages related to a specific function or variable if deemed unrelated
    DESCAM::Logger::removeFromTempMap("FuncName");
    logerMsgs = DESCAM::Logger::getMsgsMap();
    DESCAM::Logger::log();
    // checking the output
    FilterOptionsSet_NoGlobalConstants(filterOptionsSet)
    auto filteredMessagesVector = DESCAM::LoggerFilter::applyFilters(msgsVector, filterOptionsSet);
    std::string formatedOutput = DESCAM::LoggerFormatter::formatMessages(filteredMessagesVector,
                                                                       DESCAM::LoggerFormatter::FormatOption::JSON), logsFileContent;
    GET_CONTENT_FROM_FILE("LOGS.JSON", logsFileContent)
    ASSERT_EQ(logsFileContent, formatedOutput);
    DESCAM::Logger::clear();
}


TEST_F(Logger_test, Logger_terminate_flag) {
    ASSERT_EQ(DESCAM::Logger::isTerminate(), false) << "terminate flag was set initially\n";
    DESCAM::Logger::setTerminate();
    ASSERT_EQ(DESCAM::Logger::isTerminate(), true) << "failed to set terminate flag\n";
    DESCAM::Logger::resetTerminate();
    ASSERT_EQ(DESCAM::Logger::isTerminate(), false) << "failed to reset terminate flag\n";
}

TEST_F(Logger_test, logger_descam_exception) {
    auto integerVal = new DESCAM::IntegerValue(2);
    auto unsignedVal = new DESCAM::UnsignedValue(2);
    ASSERT_THROW(new DESCAM::Arithmetic(integerVal,"+",unsignedVal),DESCAM::DescamException);
    {
        DESCAM::Logger::setCurrentProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation::Behavior);
        ASSERT_NO_THROW(DESCAM_ASSERT(new DESCAM::Arithmetic(integerVal, "+", unsignedVal)));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true)
                                    << "Logger Terminate flag should be set after a stmt exception in behavior occurs\n";
        ASSERT_EQ(DESCAM::Logger::getMsgsMap().size(), 1)
                                    << "Error message was not added to MsgsMap after DescamException and processedLocation is Behavior";
        DESCAM::Logger::resetTerminate();
        DESCAM::Logger::clear();
    }
    {
        DESCAM::Logger::setCurrentProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation::Functions);
        ASSERT_NO_THROW(DESCAM_ASSERT(new DESCAM::Arithmetic(integerVal, "+", unsignedVal)));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true)
                                    << "Logger Terminate flag should be set after a stmt exception in behavior occurs\n";
        ASSERT_EQ(DESCAM::Logger::getMsgsMap().size(), 1)
                                    << "Error message was not added to MsgsMap after DescamException and processedLocation is Behavior";
        DESCAM::Logger::resetTerminate();
        DESCAM::Logger::clear();
    }
    {
        // we don't expect to terminate during the processing of global constants because errors here might originate from another unrelated file
        DESCAM::Logger::setCurrentProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation::GlobalConstants);
        ASSERT_NO_THROW(DESCAM_ASSERT(new DESCAM::Arithmetic(integerVal, "+", unsignedVal)));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), false) << "terminate flag was set during the processing of global constants\n";
        // the error message now is added to TempVector of the logger, we tag it with a variable or function name
        DESCAM::Logger::tagTempMsgs("globalConstantVarOrFunc");
        ASSERT_EQ(DESCAM::Logger::getTempMsgsMap().at("globalConstantVarOrFunc").size(),1) << "Error message was not added to TempMsgsMap after DescamException and processedLocation is GlobalConstants";
        DESCAM::Logger::clear();
        DESCAM::Logger::resetTerminate();
    }
}

TEST_F(Logger_test, logger_descam_exception_ports) {
    DESCAM::Logger::setCurrentProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation::Ports);
    DESCAM::Interface* interface1 = nullptr, *interface2 = nullptr;
    {
        ASSERT_THROW(new DESCAM::Interface("blocking", "inout"), DESCAM::DescamException);
        ASSERT_NO_THROW(DESCAM_ASSERT(interface1 = new DESCAM::Interface("blocking", "inout")));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true);
        ASSERT_TRUE(DESCAM::Logger::hasFeedback());
        DESCAM::Logger::clear();
        DESCAM::Logger::resetTerminate();
    }
    {
        ASSERT_THROW(new DESCAM::Interface("unkowntype", "in"), DESCAM::DescamException);
        ASSERT_NO_THROW(DESCAM_ASSERT(interface2 = new DESCAM::Interface("unkowntype", "in")));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true);
        ASSERT_TRUE(DESCAM::Logger::hasFeedback());
        DESCAM::Logger::clear();
        DESCAM::Logger::resetTerminate();
    }
    DESCAM::Port *inPort = nullptr;
    {
        ASSERT_THROW(new DESCAM::Port("port_no_interface",interface1,DESCAM::DataTypes::getDataType("int")), DESCAM::DescamException);
        ASSERT_NO_THROW(DESCAM_ASSERT(inPort = new DESCAM::Port("port_no_interface",interface1,DESCAM::DataTypes::getDataType("int"))));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true);
        ASSERT_TRUE(DESCAM::Logger::hasFeedback());
        DESCAM::Logger::clear();
        DESCAM::Logger::resetTerminate();
    }
    {
        ASSERT_THROW(new DESCAM::Port("port_no_interface",interface1,DESCAM::DataTypes::getDataType("int")), DESCAM::DescamException);
        ASSERT_NO_THROW(DESCAM_ASSERT(interface1 = new DESCAM::Interface("blocking", "in")));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), false);
        ASSERT_NO_THROW(DESCAM_ASSERT(inPort = new DESCAM::Port("port_no_datatype",interface1,nullptr)));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true);
        ASSERT_TRUE(DESCAM::Logger::hasFeedback());
        DESCAM::Logger::clear();
        DESCAM::Logger::resetTerminate();
    }
}

TEST_F(Logger_test, logger_descam_exception_variables) {
    DESCAM::Logger::setCurrentProcessedLocation(DESCAM::LoggerMsg::ProcessedLocation::Variables);
    DESCAM::Variable* var = nullptr;
    ASSERT_THROW(new DESCAM::Variable("var_no_type",nullptr), DESCAM::DescamException);
    { // var with no datatype
        ASSERT_NO_THROW(DESCAM_ASSERT(var = new DESCAM::Variable("var_no_type",nullptr)));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true);
        ASSERT_TRUE(DESCAM::Logger::hasFeedback());
        DESCAM::Logger::clear();
        DESCAM::Logger::resetTerminate();
    }
    { //complex subvar
        DESCAM::Variable* subvar = nullptr ,*subsubvar = nullptr;
        ASSERT_NO_THROW(
                auto complex = new DESCAM::DataType("complex");
                complex->addSubVar("subvar",DESCAM::DataTypes::getDataType("int"));
                DESCAM::DataTypes::addDataType(complex);
                var = new DESCAM::Variable("var",DESCAM::DataTypes::getDataType("int"));
        );
        ASSERT_THROW(new DESCAM::Variable("subvar",DESCAM::DataTypes::getDataType("complex"),nullptr,var),DESCAM::DescamException);
        ASSERT_NO_THROW(DESCAM_ASSERT(new DESCAM::Variable("subvar",DESCAM::DataTypes::getDataType("complex"),nullptr,var)));
        ASSERT_EQ(DESCAM::Logger::isTerminate(), true);
        ASSERT_TRUE(DESCAM::Logger::hasFeedback());
        DESCAM::Logger::clear();
        DESCAM::Logger::resetTerminate();
    }
}

Logger_test::Logger_test() {
    {
        std::string fileDir = "fileDir/file1.h", message = "message1", statement = "statement1";
        DESCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = DESCAM::LoggerMsg::SeverityLevel::Info;
        auto vt = DESCAM::LoggerMsg::ViolationType::NA;
        auto pl = DESCAM::LoggerMsg::ProcessedLocation::Functions;
        DESCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
    {
        std::string fileDir = "fileDir/file2.h", message = "message2", statement = "statement2";
        DESCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = DESCAM::LoggerMsg::SeverityLevel::Error;
        auto vt = DESCAM::LoggerMsg::ViolationType::Syntax;
        auto pl = DESCAM::LoggerMsg::ProcessedLocation::Parsing;
        DESCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
    {
        std::string fileDir = "fileDir/file3.h", message = "message3", statement = "statement3";
        DESCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = DESCAM::LoggerMsg::SeverityLevel::Warning;
        auto vt = DESCAM::LoggerMsg::ViolationType::SystemC_PPA_compliance;
        auto pl = DESCAM::LoggerMsg::ProcessedLocation::Behavior;
        DESCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
    {
        std::string fileDir = "fileDir/file4.h", message = "message4", statement = "statement4";
        DESCAM::LocationInfo stmtLocationInfo(statement, fileDir, 1, 2, 3, 4);
        auto sl = DESCAM::LoggerMsg::SeverityLevel::Error;
        auto vt = DESCAM::LoggerMsg::ViolationType::SystemC_PPA_compliance;
        auto pl = DESCAM::LoggerMsg::ProcessedLocation::GlobalConstants;
        DESCAM::LoggerMsg msg(message, stmtLocationInfo, sl, vt, pl);
        msgsVector.push_back(msg);
    }
}
