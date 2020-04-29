#include "ClangDiagnosticPrinter.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Frontend/TextDiagnostic.h"
#include "clang/Lex/Lexer.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include <Logger/Logger.h>
#include <iostream>
#include <GlobalUtilities.h>


using namespace clang;

ClangDiagnosticPrinter::ClangDiagnosticPrinter(raw_ostream &os, DiagnosticOptions *diags,
                                               bool OwnsOutputStream)
        : OS(os), DiagOpts(diags),
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

    if(Level >= DiagnosticsEngine::Error) SCAM::Logger::setTerminate();

    SmallString<100> outStr;
    Info.FormatDiagnostic(outStr);
    llvm::raw_svector_ostream DiagMessageStream(outStr);

    // Assert that the rest of our infrastructure is setup properly.
    assert(DiagOpts && "Unexpected diagnostic without options set");
    assert(Info.hasSourceManager() && "Unexpected diagnostic with no source manager");
    assert(TextDiag && "Unexpected diagnostic outside source file processing");

    TextDiag->emitDiagnostic(
            FullSourceLoc(Info.getLocation(), Info.getSourceManager()), Level,
            DiagMessageStream.str(), Info.getRanges(),
            llvm::makeArrayRef(Info.getFixItHints(), Info.getNumFixItHints()), &Info.getSourceManager());
    OS.flush();
}

void ClangDiagnosticPrinter::addDiagnosticsToLogger(std::string diagnostics) {
    /*  diagnostic formats
     *  1. filedir:rowStartNum:ColumnStartNum: Severity: Message
     *               statement
     *                       ^
     *  2. filedir:rowStartNum:ColumnStartNum:{rowStartNum:ColumnStartNum-rowEndNum:ColumnEndNum}: Severity: Message
     *               statement
     *                       ^
    */
    auto diagnosticsVec = SCAM::GlobalUtilities::stringSplit(diagnostics, '\n');
    for (auto line = diagnosticsVec.begin(); line != diagnosticsVec.end(); line++) {
        auto errorLineVec = SCAM::GlobalUtilities::stringSplit(*line, ':');
        if (errorLineVec.size() > 4) {
            int parsableSourceRangesOffset = 0;  // initially format 1, "without parsable source ranges"
            auto stmtPtr = std::next(line, 1);
            std::string stmt = "";
            if (stmtPtr != diagnosticsVec.end()) stmt = SCAM::GlobalUtilities::removeIndentation(*stmtPtr);
            std::string fileDir = errorLineVec[0];
            int rowStartNum = stoi(errorLineVec[1]), colStartNum = stoi(
                    errorLineVec[2]), rowEndNum = rowStartNum, colEndNum = colStartNum;
            auto severityLevel = SCAM::LoggerMsg::SeverityLevel::Warning;
            auto violationType = SCAM::LoggerMsg::ViolationType::Syntax;
            if (errorLineVec.size() == 8) { //  we currently have format 2,
                parsableSourceRangesOffset = 3;
                colEndNum = stoi(errorLineVec[5]);
                auto dashPosition = errorLineVec[4].find('-');
                if (dashPosition != std::string::npos)
                    rowEndNum = stoi(errorLineVec[4].substr(dashPosition + 1));
            }
            if (errorLineVec[3 + parsableSourceRangesOffset].find("error") != std::string::npos)
                severityLevel = SCAM::LoggerMsg::SeverityLevel::Error;

            std::string message = SCAM::GlobalUtilities::removeIndentation(
                    errorLineVec[4 + parsableSourceRangesOffset]);

            SCAM::LocationInfo stmtInfo(stmt, fileDir, rowStartNum, rowEndNum, colStartNum, colEndNum);
            //Add loggerMsg to the logger
            SCAM::LoggerMsg loggerMsg(message, stmtInfo, severityLevel, violationType,SCAM::Logger::getCurrentProcessedLocation());
            SCAM::Logger::addMsg(loggerMsg);
        }
    }
}

