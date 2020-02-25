#ifndef _SC_CHANNELS_H_
#define _SC_CHANNELS_H_

#include <map>
#include <string>
#include "clang/AST/RecursiveASTVisitor.h"

namespace SCAM {

    class FindChannels : public clang::RecursiveASTVisitor<FindChannels> {
    public:

        FindChannels(clang::TranslationUnitDecl *);

        virtual bool VisitCXXRecordDecl(clang::CXXRecordDecl *);
        //virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *);

        const std::map<std::string, clang::CXXRecordDecl *> & getChannelMap();

    private:
        std::map<std::string, clang::CXXRecordDecl *> _ChannelMap;

    };
}
#endif
