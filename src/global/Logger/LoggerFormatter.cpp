
#include <sstream>
#include <llvm/Support/raw_ostream.h>
#include "LoggerFormatter.h"


const std::string
DESCAM::LoggerFormatter::formatMessages(std::vector<DESCAM::LoggerMsg> loggerMessages,
                                      DESCAM::LoggerFormatter::FormatOption formatOptions) {
    switch (formatOptions) {
        case FormatOption::JSON :
            return getMessagesJSON(loggerMessages);
        case FormatOption::TEXT :
            return getMessages(loggerMessages);
    }
}

std::string
DESCAM::LoggerFormatter::getMessagesJSON(std::vector<DESCAM::LoggerMsg> loggerMessages) {
    std::stringstream json;
    json << "[\n";
    for (auto msgPtr = loggerMessages.begin(); msgPtr != loggerMessages.end(); msgPtr++) {
        auto stmtInfo = msgPtr->getLocationInfo();
        json << "\t{\n";
        if (stmtInfo.getFile() != "")
            json << "\t\t" << R"("file": ")" << stmtInfo.getFile() << "\",\n";
        if (stmtInfo.getObject() != "")
            json << "\t\t" << R"("object": ")" << stmtInfo.getObject() << "\",\n";
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

std::string DESCAM::LoggerFormatter::getMessages(std::vector<DESCAM::LoggerMsg> loggerMessages) {
    std::stringstream normal;
    for (auto msgPtr = loggerMessages.begin(); msgPtr != loggerMessages.end(); msgPtr++) {
        auto stmtInfo = msgPtr->getLocationInfo();
        if (stmtInfo.getFile() != "")
            normal << "file: " << stmtInfo.getFile() << '\n';
        if (stmtInfo.getObject() != "")
            normal << "object: " << stmtInfo.getObject() << '\n';
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
        if(std::next(msgPtr, 1)!=loggerMessages.end()) normal << '\n';
    }
    return normal.str();
}

std::string DESCAM::LoggerFormatter::getFormatFileType(DESCAM::LoggerFormatter::FormatOption formatOption) {
    switch (formatOption) {
        case FormatOption::TEXT : return "txt";
        case FormatOption::JSON : return "JSON";
    }
}
