#include "ClangDiagnosticPrinter.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Frontend/TextDiagnostic.h"
#include "clang/Lex/Lexer.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include <Logger/Logger.h>
#include <GlobalUtilities.h>

using namespace clang;

ClangDiagnosticPrinter::ClangDiagnosticPrinter(raw_ostream &os, DiagnosticOptions *diagnostic_options,
                                               bool OwnsOutputStream)
    : OS(os), DiagOpts(diagnostic_options),
      OwnsOutputStream(OwnsOutputStream) {
}

ClangDiagnosticPrinter::~ClangDiagnosticPrinter() {
  if (OwnsOutputStream)
    delete &OS;
}

void ClangDiagnosticPrinter::BeginSourceFile(const LangOptions &LO,
                                             const Preprocessor *PP) {
  // Build the TextDiagnostic utility.
  TextDiag = std::make_unique<TextDiagnostic>(OS, LO, &*DiagOpts);
}

void ClangDiagnosticPrinter::EndSourceFile() {
  TextDiag.reset();
}

void ClangDiagnosticPrinter::HandleDiagnostic(DiagnosticsEngine::Level Level,
                                              const Diagnostic &Info) {

  if (Level >= DiagnosticsEngine::Error) DESCAM::Logger::setTerminate();

  SmallString<100> outStr;
  Info.FormatDiagnostic(outStr);
  llvm::raw_svector_ostream DiagMessageStream(outStr);

  // Assert that the rest of our infrastructure is setup properly.
  assert(DiagOpts && "Unexpected diagnostic without options set");
  assert(Info.hasSourceManager() && "Unexpected diagnostic with no source manager");
  assert(TextDiag && "Unexpected diagnostic outside source file processing");

  TextDiag->emitDiagnostic(
      FullSourceLoc(Info.getLocation(), Info.getSourceManager()),
      Level,
      DiagMessageStream.str(),
      Info.getRanges(),
      Info.getFixItHints());
  OS.flush();
}

void ClangDiagnosticPrinter::addDiagnosticsToLogger(const std::string &diagnostics) {
  /*  diagnostic formats
   *  1. file dir: rowStartNum:ColumnStartNum: Severity: Message
   *               statement
   *                       ^
   *  2. file dir: rowStartNum:ColumnStartNum:{rowStartNum:ColumnStartNum-rowEndNum:ColumnEndNum}: Severity: Message
   *               statement
   *                       ^
  */
  auto diagnosticsVec = DESCAM::GlobalUtilities::stringSplit(diagnostics, '\n');
  for (auto line = diagnosticsVec.begin(); line != diagnosticsVec.end(); line++) {
    auto errorLineVec = DESCAM::GlobalUtilities::stringSplit(*line, ':');
    if (errorLineVec.size() > 4) {
      int parsableSourceRangesOffset = 0;  // initially format 1, "without parsable source ranges"
      auto stmtPtr = std::next(line, 1);
      std::string stmt;
      if (stmtPtr != diagnosticsVec.end()) stmt = DESCAM::GlobalUtilities::removeIndentation(*stmtPtr);
      std::string fileDir = errorLineVec[0];
      int rowStartNum = stoi(errorLineVec[1]), colStartNum = stoi(
          errorLineVec[2]), rowEndNum = rowStartNum, colEndNum = colStartNum;
      auto severityLevel = DESCAM::LoggerMsg::SeverityLevel::Warning;
      auto violationType = DESCAM::LoggerMsg::ViolationType::Syntax;
      // TODO use abseil after building
      if (errorLineVec.size() == 8 && !(errorLineVec[3].find("error") != std::string::npos ||
          errorLineVec[3].find("note") != std::string::npos ||
          errorLineVec[3].find("warning") !=
              std::string::npos)) { //  we currently have format 2,
        parsableSourceRangesOffset = 3;
        if (errorLineVec[5].size() < 4) colEndNum = stoi(errorLineVec[5]);
        auto dashPosition = errorLineVec[4].find('-');
        if (dashPosition != std::string::npos)
          rowEndNum = stoi(errorLineVec[4].substr(dashPosition + 1));
      } else if (errorLineVec.size() > 9) parsableSourceRangesOffset = 5;
      if (errorLineVec[3 + parsableSourceRangesOffset].find("error") != std::string::npos)
        severityLevel = DESCAM::LoggerMsg::SeverityLevel::Error;
      else if (errorLineVec[3 + parsableSourceRangesOffset].find("note") != std::string::npos)
        severityLevel = DESCAM::LoggerMsg::SeverityLevel::Info;

      std::string message;
      for (int i = 4 + parsableSourceRangesOffset; i < errorLineVec.size(); i++)
        message += errorLineVec[i];

      DESCAM::LocationInfo stmtInfo(stmt, fileDir, rowStartNum, rowEndNum, colStartNum, colEndNum);
      //Add loggerMsg to the logger
      DESCAM::LoggerMsg loggerMsg(message, stmtInfo, severityLevel, violationType,
                                  DESCAM::Logger::getCurrentProcessedLocation());
      DESCAM::Logger::addMsg(loggerMsg);
    }
  }
}

