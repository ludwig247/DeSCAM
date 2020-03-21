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
        int foundME = 0;
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
                        std::cout << "#1 Module: " << moduleName << " Instance: " << instanceName << std::endl;
                    }
                    portName = me->getMemberDecl()->getNameAsString();
                    foundME++;
                }
                //if (clang::DeclRefExpr * channelDecl = llvm::dyn_cast<clang::DeclRefExpr>(e->IgnoreImpCasts())) {
                    if (foundME == 1) {
                        clang::DeclRefExpr * channelDecl = llvm::dyn_cast<clang::DeclRefExpr>(e->IgnoreImpCasts());
                        std::cout << "#3 Module: " << moduleName << " Instance: " << instanceName << std::endl;

                        //Instance Map: containing an entry for each instance of an module
                        //Instance Map: containing an entry <<Instance, Module>, parent >
                        auto inst_innerEntry = std::pair<std::string, std::string>(instanceName, moduleName);
                        auto inst_outerEntry = std::pair<std::pair<std::string, std::string>, std::string>(
                                inst_innerEntry, "top");
                        this->_instanceMap.insert(inst_outerEntry);

                        //Channel Map: containing an entry <<Instance, port>,channelDecl >
                        auto innerEntry = std::pair<std::string, std::string>(instanceName, portName);
                        auto outerEntry = std::pair<std::pair<std::string, std::string>, clang::DeclRefExpr *>(innerEntry, channelDecl);
                        this->_channelMap.insert(outerEntry);
                        foundME = 0;
                    }
                //}
            }
        }

        return true;
    }
/*
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

                        std::cout << instanceName << " " << moduleName << " "  << "\n";


                    }

                    portName = me->getMemberDecl()->getNameAsString();

                    //std::cout << "============================================" << std::endl;
                    //std::cout << instanceName << " == " << portName << " == " << moduleName << " == " << std::endl;
                    //std::cout << "============================================" << std::endl;

                    //std::cout << "============================================" << std::endl;
                    //

                    foundME = true;
                }
                if (clang::DeclRefExpr *channelDecl = llvm::dyn_cast<clang::DeclRefExpr>(e->IgnoreImpCasts())) {
                    if (foundME) {


                        std::cout << "====================IF========================" << std::endl;


                        //Instance Map: containing an entry <<Instance, Module>, parent >
                        auto inst_innerEntry = std::pair<std::string, std::string>(instanceName, moduleName);
                        auto inst_outerEntry = std::pair<std::pair<std::string, std::string>, std::string>(
                                inst_innerEntry, "top");
                        this->_instanceMap.insert(inst_outerEntry);

                        //Channel Map: containing an entry <<Instance, port>,channelDecl >
                        auto ch_innerEntry = std::pair<std::string, std::string>(instanceName, portName);
                        auto ch_outerEntry = std::pair<std::pair<std::string, std::string>, clang::DeclRefExpr *>(
                                ch_innerEntry, channelDecl);
                        this->_channelMap.insert(ch_outerEntry);
                        foundME = false;
                    }
                }
            }
        }

        return true;
    }
*/
    std::map<std::pair<std::string, std::string>, std::string> FindNetlist::getInstanceMap() {
        return this->_instanceMap;
    }

    std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> FindNetlist::getChannelMap() {
        return this->_channelMap;
    }

    //DEBUG
    void FindNetlist::printInstanceMap() {
        for (auto elem : this->getInstanceMap()) {
            std::cout << elem.first.first.c_str() << " " << elem.first.second.c_str() << " " << elem.second.c_str() << "\n";
        }
    }

    void FindNetlist::printChannelMap() {
        for (auto elem : this->getChannelMap()) {
            std::cout << "####" << "\n";
            std::cout << elem.first.first.c_str() << " " << elem.first.second.c_str() << " " << "\n";
            std::cout << "####" << "\n";
        }
    }
}




