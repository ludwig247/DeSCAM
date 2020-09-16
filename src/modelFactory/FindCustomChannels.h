//
// Created by ludwig on 15.09.20.
//

#ifndef SCAM_FINDCUSTOMCHANNELS_H
#define SCAM_FINDCUSTOMCHANNELS_H

#include <clang/AST/RecursiveASTVisitor.h>
#include <map>

namespace DESCAM {

    class FindCustomChannels : public clang::RecursiveASTVisitor<FindCustomChannels> {
    public:

        explicit FindCustomChannels(clang::TranslationUnitDecl *tuDecl);

        virtual bool VisitCXXRecordDecl(clang::CXXRecordDecl *);

        const std::map<std::string, clang::CXXRecordDecl *> &getChannelMap() const;


    private:
        std::map<std::string, clang::CXXRecordDecl *> channel_map;

    };
}


#endif //SCAM_FINDCUSTOMCHANNELS_H
