
#include <sstream>
#include "TextFormatter.h"


const std::string
SCAM::TextFormatter::formatMessages(std::vector<SCAM::LoggerMsg> loggerMessages,
                                    SCAM::TextFormatter::FormatOptions formatOptions) {
    switch (formatOptions){
        case FormatOptions ::JSON : return getMessagesJSON(loggerMessages);
    }
}

std::string
SCAM::TextFormatter::getMessagesJSON(std::vector<SCAM::LoggerMsg> loggerMessages) {
    std::stringstream json;
    json << "[\n";
    for (auto msgPtr = loggerMessages.begin(); msgPtr != loggerMessages.end(); msgPtr++) {
//        if (auto msgPtr = itr->get()) {
            auto stmtInfo = msgPtr->getStmtInfo();
            json << "\t{\n";
            json << "\t\t" << "file: '" << stmtInfo.getFile() << "'\n";
            json << "\t\t" << "statement: '" << stmtInfo.getStmt() << "'\n";
            json << "\t\t" << "line: [[" << stmtInfo.getRowStartNumber() << " , " << stmtInfo.getRowEndNumber() << "], ["
                 << stmtInfo.getColumnStartNumber() << " , " << stmtInfo.getColumnEndNumber() << "]]\n";
            json << "\t\t" << "severity: '" << msgPtr->getSeverityLevel() << "'\n";
            json << "\t\t" << "violation: '" << msgPtr->getViolationType() << "'\n";
            json << "\t\t" << "message: '" << msgPtr->getMessage() << "'\n";
            if (std::next(msgPtr, 1) == loggerMessages.end()) {
                json << "\t}\n";
            } else {
                json << "\t},\n";
            }
//        }
    }
    json << "]\n";
    return json.str();
}
