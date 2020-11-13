//
// Created by mi-alkoudsi on 11.5.20
//

#ifndef DESCAM_LOGGER_TEST_H
#define DESCAM_LOGGER_TEST_H

#include <gtest/gtest.h>
#include <fstream>
#include "Config.h"
#include "LocationInfo.h"
#include "Stmts/Expr.h"
#include "Logger/Logger.h"
#include "Logger/FileSink.h"




class Logger_test: public ::testing::Test {
public:
    Logger_test();

    void SetUp() override{};
    void TearDown() override{};
protected:
    std::vector<DESCAM::LoggerMsg> msgsVector;

};

#define GET_CONTENT_FROM_FILE(fileName, contentString) \
std::string refFilePath = SCAM_HOME"/tests/global/Logger/ref_files/" fileName; \
std::ifstream refFile(refFilePath); \
ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath; \
contentString.assign((std::istreambuf_iterator<char>(refFile)), \
                    (std::istreambuf_iterator<char>())); \
refFile.close();


#define FilterOptionsSet_NoGlobalConstants(filterOptionsSet) \
 std::set<DESCAM::LoggerFilter::FilterOptions> filterOptionsSet{ \
DESCAM::LoggerFilter::FilterOptions::showBehaviorMsgs,\
DESCAM::LoggerFilter::FilterOptions::showFunctionMsgs,\
DESCAM::LoggerFilter::FilterOptions::showSyntaxMsgs,\
DESCAM::LoggerFilter::FilterOptions::showPortsMsgs,\
DESCAM::LoggerFilter::FilterOptions::showVariableMsgs\
};


#endif //DESCAM_LOGGER_TEST_H
