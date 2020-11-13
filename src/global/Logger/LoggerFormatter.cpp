

#include "LoggerFormatter.h"

std::string
DESCAM::LoggerFormatter::formatMessages(const std::vector<DESCAM::LoggerMsg>& loggerMessages,
                                        DESCAM::LoggerFormatter::FormatOption formatOptions) {
  switch (formatOptions) {
    case FormatOption::JSON :return getMessagesJSON(loggerMessages);
    case FormatOption::TEXT :return getMessages(loggerMessages);
    default: return "DESCAM::LoggerFormatter::formatMessages - Unknown format option";
  }
}

std::string
DESCAM::LoggerFormatter::getMessagesJSON(std::vector<DESCAM::LoggerMsg> loggerMessages) {
  std::stringstream json;
  json << "[\n";
  for (auto msgPtr = loggerMessages.begin(); msgPtr != loggerMessages.end(); msgPtr++) {
    auto stmtInfo = msgPtr->getLocationInfo();
    json << "\t{\n";
    if (!stmtInfo.getFile().empty())
      json << "\t\t" << R"("file": ")" << stmtInfo.getFile() << "\",\n";
    if (!stmtInfo.getObject().empty()) {
      auto object = stmtInfo.getObject();
      std::replace(object.begin(), object.end(), '\"', '\'');
      json << "\t\t" << R"("object": ")" << object << "\",\n";
    }
    if (!(stmtInfo.getRowStartNumber() == 0 && stmtInfo.getRowEndNumber() == 0 &&
        stmtInfo.getColumnStartNumber() == 0 && stmtInfo.getColumnEndNumber() == 0))
      json << "\t\t" << R"("line": [[)" << stmtInfo.getRowStartNumber() << " , "
           << (stmtInfo.getRowEndNumber() < stmtInfo.getRowStartNumber() ? stmtInfo.getRowStartNumber()
                                                                         : stmtInfo.getRowEndNumber()) << "], ["
           << stmtInfo.getColumnStartNumber() << " , " << stmtInfo.getColumnEndNumber() << "]],\n";
    json << "\t\t" << R"("severity": ")" << msgPtr->getSeverityLevel() << "\",\n";
    if (msgPtr->getViolationType() != "NA")
      json << "\t\t" << R"("violation": ")" << msgPtr->getViolationType() << "\",\n";
    if (!msgPtr->getProcessedLocationString().empty())
      json << "\t\t" << R"("location": ")" << msgPtr->getProcessedLocationString() << "\",\n";
    if (!msgPtr->getMessage().empty()) {
      auto msg = msgPtr->getMessage();
      std::replace(msg.begin(), msg.end(), '\"', '\'');
      json << "\t\t" << R"("message": ")" << msgPtr->getMessage() << "\"\n";
    }
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
    if (!stmtInfo.getFile().empty())
      normal << "file: " << stmtInfo.getFile() << '\n';
    if (!stmtInfo.getObject().empty())
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
    if (!msgPtr->getProcessedLocationString().empty())
      normal << "location: " << msgPtr->getProcessedLocationString() << '\n';
    normal << "message: " << msgPtr->getMessage() << '\n';
    if (std::next(msgPtr, 1) != loggerMessages.end()) normal << '\n';
  }
  return normal.str();
}

std::string DESCAM::LoggerFormatter::getFormatFileType(DESCAM::LoggerFormatter::FormatOption formatOption) {
  switch (formatOption) {
    case FormatOption::TEXT : return "txt";
    case FormatOption::JSON : return "JSON";
    default: return "DESCAM::LoggerFormatter::getFormatFileType - Unknown format option";
  }
}
