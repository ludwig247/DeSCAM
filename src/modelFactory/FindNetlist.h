#ifndef _NETLIST_GEN_H_
#define _NETLIST_GEN_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include <map>

namespace SCAM {


        /*!
         * \brief Searches within sc_main for binding of ports
         *     port = new port;
         *     module.portA.bind(port)
         *     //TODO: redo traversing of elements -> more visitors instead of dyn_cast
         */
        class FindNetlist : public clang::RecursiveASTVisitor<FindNetlist> {
        public:
            FindNetlist(clang::FunctionDecl *, std::map<std::string, clang::CXXRecordDecl *>);
            //FindNetlistInModule(const FindNetlistInModule &);
            ~FindNetlist();


            //First find Channel and Module Instances
            virtual bool VisitVarDecl(clang::VarDecl *varDecl);
            //Then find connections
            virtual bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce);

            void recursiveTemplateVisitor(clang::QualType qualType);

            //GETTER
            std::map<std::pair<std::string,std::string>, std::string> getInstanceMap();
            std::map<std::string, std::pair<std::string,std::string>> getChannelMap();
            std::map<std::pair<std::string,std::string>, std::string> getchannelConnectionMap();
            std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> gethierchannelConnectionMap();
            void printInstanceMap();
            void printChannelMap();
            void printChannelConnectionMap();
            void printHierChannelConnectionMap();

        private:
            int _pass;
            std::map<std::pair<std::string,std::string>, std::string> _instanceMap; //! <<instance_name, sc_module_name>, parent>
            std::map<std::string, std::pair<std::string,std::string>> _channelMap; //! <channelName<channelType, channelSignalType>>
            std::map<std::pair<std::string,std::string>, std::string> _channelConnectionMap; //! <<instance, port>, channelName>
            std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> _hierchannelConnectionMap; //! <<instance, port>, <channelName,channelparentinstance>>
            std::map<std::string, clang::CXXRecordDecl *> _moduleMap;

            std::vector<std::string> channelTemplates;

            clang::FunctionDecl *_funcDecl;
        };
}
#endif
