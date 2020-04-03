//
// Created by schmitz on 27.03.20.
//

#ifndef DESCAM_FINDNETLISTINMODULE_H
#define DESCAM_FINDNETLISTINMODULE_H

#include "clang/AST/RecursiveASTVisitor.h"
#include <map>

namespace SCAM {

    /*!
     * \brief Searches within sc_main for binding of ports
     *     port = new port;
     *     module.portA.bind(port)
     *     //TODO: redo traversing of elements -> more visitors instead of dyn_cast
     */
    class FindNetlistInModule : public clang::RecursiveASTVisitor<FindNetlistInModule> {
    public:
        FindNetlistInModule(clang::CXXRecordDecl *, std::map<std::string, clang::CXXRecordDecl *>);
        //FindNetlistInModule(const FindNetlistInModule &);
        ~FindNetlistInModule();

        //First find Channelinstances
        virtual bool VisitFieldDecl(clang::FieldDecl *fieldDecl);

        virtual bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce);

        void recursiveTemplateVisitor(clang::QualType qualType);

        //GETTER
        std::map<std::string, std::string> getInstanceMap();
        std::map<std::string, std::pair<std::string,std::string>> getChannelMap();
        std::map<std::pair<std::string,std::string>, std::string> getchannelConnectionMap();
        void printInstanceMap();
        void printChannelMap();
        void printChannelConnectionMap();


    private:
        int _pass;
        std::map<std::string, std::string> _instanceMap; //! <instance_name, sc_module>
        std::map<std::string, std::pair<std::string,std::string>> _channelMap; //! <channelName<channelType, channelSignalType>>
        std::map<std::pair<std::string,std::string>, std::string> _channelConnectionMap; //! <<instance, port>, channelName>
        std::map<std::string, clang::CXXRecordDecl *> _moduleMap;

        std::vector<std::string> channelTemplates;
    };
}

#endif //DESCAM_FINDNETLISTINMODULE_H
