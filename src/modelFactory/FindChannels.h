//
// Created by schmitz on 26.03.20.
//

#ifndef DESCAM_FINDCHANNELS_H
#define DESCAM_FINDCHANNELS_H

#include <map>
#include <clang/AST/ASTContext.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include "enums.h"

namespace SCAM {

    /**
     * \brief: Finds all channels
     *
     */
    class FindChannels : public clang::RecursiveASTVisitor<FindChannels> {
    public:
        FindChannels(clang::CXXRecordDecl *recordDecl,const clang::ASTContext& context);
        ~FindChannels();
        //Visitor
        virtual bool VisitFieldDecl(clang::FieldDecl* fieldDecl);

        //GETTER
        const std::map<std::string, std::string> &getBlockingChannelMap() const;
        const std::map<std::string, std::string> &getSharedChannelMap() const;


    private:
        const clang::ASTContext& context;
        std::map<std::string,std::string > BlockingChannelMap; //! Map containing an entry for every rendezVouz in-port,type
        std::map<std::string,std::string > SharedChannelMap; //! Map containing an entry for every rendezVouz in-port,type
        int pass;

        //Helper
        std::vector<std::string> portTemplates; //! sc_port<sc_fifo_in_if<_Bool> > Contains an entry for each Template used {sc_port,sc_fifo_in,_Bool}
        void recursiveTemplateVisitor(clang::QualType qualType);
    };



}

#endif //DESCAM_FINDCHANNELS_H
