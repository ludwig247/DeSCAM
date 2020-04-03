#include "FindNetlist.h"
#include "FindNewDatatype.h"
#include <iostream>

namespace SCAM {

//Constructor
    FindNetlist::FindNetlist(clang::FunctionDecl *funcDecl, std::map<std::string, clang::CXXRecordDecl *> ModuleMap) :
            _pass(1) {
        _funcDecl = funcDecl;
        _moduleMap = ModuleMap;
        TraverseDecl(funcDecl);
        _pass = 2;
        TraverseDecl(funcDecl);
    }

    FindNetlist::~FindNetlist() {

    }

//Copy Constructor
    /*FindNetlistInModule::FindNetlistInModule(const FindNetlistInModule &f) {
        _pass = f._pass;
    }*/
    bool FindNetlist::VisitVarDecl(clang::VarDecl *varDecl) {
        if (_pass == 1) {

            std::string instanceName;
            std::string moduleName;
            std::string parentName;
            std::string channelName;
            std::string channelType;
            std::string channelSignal;
            clang::QualType qualType = varDecl->getType();

            channelTemplates.clear();

            if (qualType->isStructureType()) {
                if (_moduleMap.find(varDecl->getType()->getAsCXXRecordDecl()->getName().str()) == _moduleMap.end() ) {
                    throw std::runtime_error("Structuretype other than a Module initialized");
                } else {
                    instanceName = varDecl->getName().str();
                    moduleName = varDecl->getType()->getAsCXXRecordDecl()->getNameAsString();
                    parentName = _funcDecl->getNameAsString();
                    auto innerEntry = std::pair<std::string, std::string>(instanceName, moduleName);
                    auto outerEntry = std::pair<std::pair<std::string, std::string>, std::string>(innerEntry,
                                                                                                  parentName);
                    this->_instanceMap.insert(outerEntry);
                }
            } else if (qualType->isClassType()) {
                recursiveTemplateVisitor(qualType);

                if(channelTemplates.size() != 2) {
                    throw std::runtime_error("Couldn't analyze Channeldeclaration");
                }
                channelName = varDecl->getName().str();
                channelType = channelTemplates.at(0);
                channelSignal = channelTemplates.at(1);

                auto innerEntry = std::pair<std::string, std::string>(channelType, channelSignal);
                auto outerEntry = std::pair<std::string, std::pair<std::string, std::string>>(channelName, innerEntry);
                this->_channelMap.insert(outerEntry);
            }
        }
        return true;
    }

    bool FindNetlist::VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce) {

        if (_pass == 2) {


            bool foundME = false;
            bool foundHier = false;
            std::string moduleName;
            std::string instanceName;
            std::string portName;
            std::string channelName;
            std::string hierinstanceName;
            std::string hierportName;
            std::string hierchannelName;
            std::string hierchannelParentName;
            int i = 0;

            for (clang::Stmt::child_iterator it = ce->IgnoreImpCasts()->child_begin(), eit = ce->IgnoreImpCasts()->child_end();
                 it != eit; it++) {
                // find channels declared in this scope
                if (clang::Expr *e = llvm::dyn_cast<clang::Expr>(*it)) {
                    if (clang::MemberExpr *me = llvm::dyn_cast<clang::MemberExpr>(e->IgnoreImpCasts())) {
                        if (clang::DeclRefExpr *de = llvm::dyn_cast<clang::DeclRefExpr>(me->getBase()->IgnoreImpCasts())) {
                            moduleName = de->getDecl()->getType().getBaseTypeIdentifier()->getName();
                            instanceName = de->getFoundDecl()->getNameAsString();
                        }
                        portName = me->getMemberDecl()->getNameAsString();
                        foundME = true;
                    }
                    if (clang::DeclRefExpr *channelDecl = llvm::dyn_cast<clang::DeclRefExpr>(e->IgnoreImpCasts())) {
                        if (foundME) {
                            //Instance Map: containing an entry for each instance of an module
                            //this->_instanceMap.insert(std::make_pair(instanceName,moduleName));
                            //Channel Map: containing an entry <<Instance, port>,channelDecl >
                            //! <<instance, port>, channelName>
                            channelName = channelDecl->getNameInfo().getAsString();
                            //channelName = channelDecl->
                            auto innerEntry = std::pair<std::string, std::string>(instanceName, portName);
                            auto outerEntry = std::pair<std::pair<std::string, std::string>, std::string>(innerEntry,
                                                                                                          channelName);
                            this->_channelConnectionMap.insert(outerEntry);
                            foundME = false;
                        }
                    }
                }
                //Find channels declared in another scope
                if (clang::Expr *e = llvm::dyn_cast<clang::Expr>(*it)) {
                    if (clang::MemberExpr *me = llvm::dyn_cast<clang::MemberExpr>(e->IgnoreImpCasts())) {
                        if (clang::DeclRefExpr *de = llvm::dyn_cast<clang::DeclRefExpr>(me->getBase()->IgnoreImpCasts())) {
                            if (i == 1) {
                                hierinstanceName = de->getFoundDecl()->getNameAsString();
                            } else if (i == 2) {
                                hierchannelParentName = de->getFoundDecl()->getNameAsString();
                            }
                        }
                        if (i == 1) {
                            hierportName = me->getMemberDecl()->getNameAsString();
                        } else if (i == 2) {
                            hierchannelName = me->getMemberDecl()->getNameAsString();
                            foundHier = true;
                        }
                        if (foundHier) {
                            //! <<instance, port>, <channelName, channelParent>>
                            auto leftEntry = std::pair<std::string, std::string>(hierinstanceName, hierportName);
                            auto rightEntry = std::pair<std::string, std::string>(hierchannelName, hierchannelParentName);
                            auto outerEntry = std::pair<std::pair<std::string, std::string>, std::pair<std::string, std::string>>(leftEntry,
                                                                                                          rightEntry);
                            this->_hierchannelConnectionMap.insert(outerEntry);
                            foundHier = false;
                        }
                    }
                }
                i++;
            }
        }
        return true;
    }



    void FindNetlist::recursiveTemplateVisitor(clang::QualType qualType) {
        //Is there another template class?
        if (const clang::TemplateSpecializationType *templateClass = llvm::dyn_cast<clang::TemplateSpecializationType>(
                qualType.getTypePtr())) {

            //Get name of the template class
            std::string templateName;
            llvm::raw_string_ostream templateNameStream(templateName);
            //Dump name into stream
            templateClass->getTemplateName().dump(templateNameStream);
            //Get string from stream and add to vector
            this->channelTemplates.push_back(templateNameStream.str());
            for (int i = 0; i < templateClass->getNumArgs(); i++) {
                clang::TemplateArgument templateArgument = templateClass->getArg(i);
                if(templateArgument.getKind() ==  clang::TemplateArgument::ArgKind::Expression){
                    clang::Expr * expr = templateArgument.getAsExpr();
                    if (const clang::IntegerLiteral * value = llvm::dyn_cast<clang::IntegerLiteral>(expr)) {
                        //if(this->portTemplates.at(0) != "sc_uint") throw std::runtime_error("Type: " + this->portTemplates.at(0) + " is not allowed");
                        this->channelTemplates.push_back(std::to_string(value->getValue().getSExtValue()));
                    }else throw std::runtime_error("Expr is not an integer");
                }else{
                    this->recursiveTemplateVisitor(templateArgument.getAsType());
                }
            }
        }
        //Type of port int, bool, struct ...
        if (qualType.isCanonical()) {
            this->channelTemplates.push_back(FindNewDatatype::getTypeName(qualType));
        }
        return;


    }

    std::map<std::pair<std::string,std::string>, std::string> FindNetlist::getInstanceMap() {
        return this->_instanceMap;
    }

    std::map<std::string, std::pair<std::string, std::string>> FindNetlist::getChannelMap() {
        return this->_channelMap;
    }

    std::map<std::pair<std::string,std::string>, std::string> FindNetlist::getchannelConnectionMap() {
        return this->_channelConnectionMap;
    }

    std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> FindNetlist::gethierchannelConnectionMap() {
        return this->_hierchannelConnectionMap;
    }

    //DEBUG
    void FindNetlist::printInstanceMap() {
        std::cout <<"===InstanceMap===" << std::endl;
        for (auto elem : this->getInstanceMap()) {
            std::cout << "Name: " <<  elem.first.first << " Module: " << elem.first.second << " Parent: " << "main" << "\n";
        }
    }

    void FindNetlist::printChannelMap() {
        std::cout <<"===ChannelMap===" << std::endl;
        for (auto elem : this->getChannelMap()) {
            std::cout << "Name: " << elem.first << " Type: " << elem.second.first << " Signal: " << elem.second.second << std::endl;
        }
    }

    void FindNetlist::printChannelConnectionMap() {
        std::cout <<"===ChannelConnectionMap===" << std::endl;
        for (auto elem : this->getchannelConnectionMap()) {
            //<<instance, port>, channelName>
            std::cout << elem.first.first << "." << elem.first.second << "<" << elem.second << ">"  << std::endl;
        }
    }

    void FindNetlist::printHierChannelConnectionMap() {
        std::cout <<"===HierChannelConnectionMap===" << std::endl;
        for (auto elem : this->gethierchannelConnectionMap()) {
            //<<instance, port>, <channelName, channelparentinstance>>
            std::cout << elem.first.first << "." << elem.first.second << "<" << elem.second.first << ">" << " Channel declared in: ";
            std::cout << elem.second.second << std::endl;
        }
    }

}