#ifndef DESCAM_CLANGDIAGNOSTICPRINTER_H
#define DESCAM_CLANGDIAGNOSTICPRINTER_H

#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/LLVM.h"
#include "llvm/ADT/IntrusiveRefCntPtr.h"
#include <memory>

namespace clang {
    class DiagnosticOptions;
    class LangOptions;
    class TextDiagnostic;

    class ClangDiagnosticPrinter : public DiagnosticConsumer {

        raw_ostream &OS;
        IntrusiveRefCntPtr<DiagnosticOptions> DiagOpts;

        /// Handle to the currently active text diagnostic emitter.
        std::unique_ptr<TextDiagnostic> TextDiag;

        /// A string to prefix to error messages.Remark
        std::string Prefix;

        unsigned OwnsOutputStream : 1;

    public:
        ClangDiagnosticPrinter(raw_ostream &os, DiagnosticOptions *diags,
                              bool OwnsOutputStream = false);
        ~ClangDiagnosticPrinter() override;

        /// setPrefix - Set the diagnostic printer prefix string, which will be
        /// printed at the start of any diagnostics. If empty, no prefix string is
        /// used.
        void setPrefix(std::string Value) { Prefix = std::move(Value); }

        void BeginSourceFile(const LangOptions &LO, const Preprocessor *PP) override;
        void EndSourceFile() override;
        void HandleDiagnostic(DiagnosticsEngine::Level Level,
                              const Diagnostic &Info) override;

        void addDiagnosticsToLogger(std::string string);
    };

}

#endif //DESCAM_CLANGDIAGNOSTICPRINTER_H
