
#include <sstream>
#include <llvm/Support/raw_ostream.h>
#include "LoggerFormatter.h"


const std::string
SCAM::LoggerFormatter::formatMessages(std::vector<SCAM::LoggerMsg> loggerMessages,
                                      SCAM::LoggerFormatter::FormatOptions formatOptions) {
    switch (formatOptions) {
        case FormatOptions::JSON :
            return getMessagesJSON(loggerMessages);
        case FormatOptions::Normal :
            return getMessages(loggerMessages);
    }
}

std::string
SCAM::LoggerFormatter::getMessagesJSON(std::vector<SCAM::LoggerMsg> loggerMessages) {
    std::stringstream json;
    json << "[\n";
    for (auto msgPtr = loggerMessages.begin(); msgPtr != loggerMessages.end(); msgPtr++) {
        auto stmtInfo = msgPtr->getLocationInfo();
        json << "\t{\n";
        if (stmtInfo.getFile() != "")
            json << "\t\t" << R"("file": ")" << stmtInfo.getFile() << "\",\n";
        if (stmtInfo.getStmt() != "")
            json << "\t\t" << R"("statement": ")" << stmtInfo.getStmt() << "\",\n";
        if (!(stmtInfo.getRowStartNumber() == 0 && stmtInfo.getRowEndNumber() == 0 &&
              stmtInfo.getColumnStartNumber() == 0 && stmtInfo.getColumnEndNumber() == 0))
            json << "\t\t" << R"("line": [[)" << stmtInfo.getRowStartNumber() << " , "
                 << (stmtInfo.getRowEndNumber() < stmtInfo.getRowStartNumber() ? stmtInfo.getRowStartNumber()
                                                                               : stmtInfo.getRowEndNumber()) << "], ["
                 << stmtInfo.getColumnStartNumber() << " , " << stmtInfo.getColumnEndNumber() << "]],\n";
        json << "\t\t" << R"("severity": ")" << msgPtr->getSeverityLevel() << "\",\n";
        if (msgPtr->getViolationType() != "NA")
            json << "\t\t" << R"("violation": ")" << msgPtr->getViolationType() << "\",\n";
        if (msgPtr->getProcessedLocationString() != "")
            json << "\t\t" << R"("location": ")" << msgPtr->getProcessedLocationString() << "\",\n";
        json << "\t\t" << R"("message": ")" << msgPtr->getMessage() << "\"\n";
        if (std::next(msgPtr, 1) == loggerMessages.end()) {
            json << "\t}\n";
        } else {
            json << "\t},\n";
        }
    }
    json << "]\n";
    return json.str();
}

std::string SCAM::LoggerFormatter::getMessages(std::vector<SCAM::LoggerMsg> loggerMessages) {
    std::stringstream normal;
    for (auto msgPtr = loggerMessages.begin(); msgPtr != loggerMessages.end(); msgPtr++) {
        auto stmtInfo = msgPtr->getLocationInfo();
        if (stmtInfo.getFile() != "")
            normal << "file: " << stmtInfo.getFile() << '\n';
        if (stmtInfo.getStmt() != "")
            normal << "statement: " << stmtInfo.getStmt() << '\n';
        if (!(stmtInfo.getRowStartNumber() == 0 && stmtInfo.getRowEndNumber() == 0 &&
              stmtInfo.getColumnStartNumber() == 0 && stmtInfo.getColumnEndNumber() == 0))
            normal << "rows: " << stmtInfo.getRowStartNumber() << " -> "
                   << (stmtInfo.getRowEndNumber() < stmtInfo.getRowStartNumber() ? stmtInfo.getRowStartNumber()
                                                                                 : stmtInfo.getRowEndNumber()) << '\n';
        normal << "columns: " << stmtInfo.getColumnStartNumber() << " -> " << stmtInfo.getColumnEndNumber() << '\n';
        normal << "severity: " << msgPtr->getSeverityLevel() << '\n';
        if (msgPtr->getViolationType() != "NA")
            normal << "violation: " << msgPtr->getViolationType() << '\n';
        if (msgPtr->getProcessedLocationString() != "")
            normal << "location: " << msgPtr->getProcessedLocationString() << '\n';
        normal << "message: " << msgPtr->getMessage() << '\n';
        normal << '\n';
    }
    return normal.str();
}
