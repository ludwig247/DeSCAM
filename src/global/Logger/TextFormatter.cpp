
#include <sstream>
#include <llvm/Support/raw_ostream.h>
#include "TextFormatter.h"


const std::string
SCAM::TextFormatter::formatMessages(std::vector<SCAM::LoggerMsg> loggerMessages,
                                    SCAM::TextFormatter::FormatOptions formatOptions) {
    switch (formatOptions) {
        case FormatOptions::JSON :
            return getMessagesJSON(loggerMessages);
    }
}

std::string
SCAM::TextFormatter::getMessagesJSON(std::vector<SCAM::LoggerMsg> loggerMessages) {
    std::stringstream json;
    json << "[\n";
    for (auto msgPtr = loggerMessages.begin(); msgPtr != loggerMessages.end(); msgPtr++) {
        auto stmtInfo = msgPtr->getStmtInfo();
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
