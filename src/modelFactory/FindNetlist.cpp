#include "FindNetlist.h"
#include <iostream>

namespace SCAM {

//Constructor
    FindNetlist::FindNetlist(clang::FunctionDecl *fnDecl) :
            _pass(1) {
        TraverseDecl(fnDecl);
        _pass = 2;
    }

    FindNetlist::~FindNetlist() {

    }

//Copy Constructor
    FindNetlist::FindNetlist(const FindNetlist &f) {
        _pass = f._pass;
    }


    bool FindNetlist::VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce) {
        bool foundME = false;
        std::string moduleName;
        std::string instanceName;
        std::string portName;


        for (clang::Stmt::child_iterator it = ce->IgnoreImpCasts()->child_begin(), eit = ce->IgnoreImpCasts()->child_end();
             it != eit; it++) {
            if (clang::Expr *e = llvm::dyn_cast<clang::Expr>(*it)) {
                if (clang::MemberExpr *me = llvm::dyn_cast<clang::MemberExpr>(e->IgnoreImpCasts())) {
                    if (clang::DeclRefExpr *de = llvm::dyn_cast<clang::DeclRefExpr>(me->getBase()->IgnoreImpCasts())) {
                        moduleName = de->getDecl()->getType().getBaseTypeIdentifier()->getName();
                        instanceName = de->getFoundDecl()->getNameAsString();
                    }
                    portName = me->getMemberDecl()->getNameAsString();
                    foundME = true;
                }
                if (clang::DeclRefExpr * channelDecl = llvm::dyn_cast<clang::DeclRefExpr>(e->IgnoreImpCasts())) {
                    if (foundME) {
                        //Instance Map: containing an entry for each instance of an module
                        this->_instanceMap.insert(std::make_pair(instanceName,moduleName));
                        //Channel Map: containing an entry <<Instance, port>,channelDecl >
                        auto innerEntry = std::pair<std::string, std::string>(instanceName, portName);
                        auto outerEntry = std::pair<std::pair<std::string, std::string>, clang::DeclRefExpr *>(innerEntry, channelDecl);
                        this->_channelMap.insert(outerEntry);
                        foundME = false;
                    }
                }
            }
        }

        return true;
    }

    std::map<std::string, std::string> FindNetlist::getInstanceMap() {
        return this->_instanceMap;
    }

    std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> FindNetlist::getChannelMap() {
        return this->_channelMap;
    }
}