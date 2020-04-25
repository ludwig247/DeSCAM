//
// Created by schmitz on 27.03.20.
//

#include "FindNetlistInModule.h"
#include "FindNewDatatype.h"
#include <iostream>

namespace SCAM {

//Constructor
    FindNetlistInModule::FindNetlistInModule(clang::CXXRecordDecl *recDecl, std::map<std::string, clang::CXXRecordDecl *> ModuleMap) :
            _pass(1) {
        _moduleMap = ModuleMap;
        TraverseDecl(recDecl);
        _pass = 2;
        TraverseDecl(recDecl);
    }

    FindNetlistInModule::~FindNetlistInModule() {

    }

//Copy Constructor
    /*FindNetlistInModule::FindNetlistInModule(const FindNetlistInModule &f) {
        _pass = f._pass;
    }*/

    bool FindNetlistInModule::VisitFieldDecl(clang::FieldDecl *fieldDecl) {

        if (_pass == 1) {
            //Instances of Modules inside Modules are found as a fieldDecl of a Struct Type
            std::string instanceName;
            std::string moduleName;
            std::string channelName;
            std::string channelType;
            std::string channelSignal;
            //Check if field Decl ist StructureType
            clang::QualType qualType = fieldDecl->getType();
            channelTemplates.clear();


            if (_moduleMap.find(fieldDecl->getType()->getAsCXXRecordDecl()->getName().str()) == _moduleMap.end() ) {
                //StructType is not a Module and can't be a variable because the module is structural
                //So it has to be a channel
                //TODO Catch variables and ports;
                if (qualType->isStructureType()) {
                    return true;
                }
                if (const clang::TemplateSpecializationType *templateClass = llvm::dyn_cast<clang::TemplateSpecializationType>(
                        qualType.getTypePtr())) {

                    //Get name of the template class
                    std::string templateName;
                    llvm::raw_string_ostream templateNameStream(templateName);
                    //Dump name into stream
                    templateClass->getTemplateName().dump(templateNameStream);
                    //Get string from stream and add to vector
                    //TODO beautify
                    if (templateNameStream.str() == "blocking_in" || templateNameStream.str() == "blocking_out" || templateNameStream.str() == "shared_out") {
                        return true;
                    }
                }

                this->recursiveTemplateVisitor(qualType);

                channelName = fieldDecl->getName().str();
                channelType = channelTemplates.at(0);
                channelSignal = channelTemplates.at(1);

                auto innerEntry = std::pair<std::string, std::string>(channelType, channelSignal);
                auto outerEntry = std::pair<std::string, std::pair<std::string, std::string>>(channelName, innerEntry);
                this->_channelMap.insert(outerEntry);
            }
            else {
                instanceName = fieldDecl->getName().str();
                moduleName = fieldDecl->getType()->getAsCXXRecordDecl()->getName().str();
                this->_instanceMap.insert(std::make_pair(instanceName,moduleName));
            }

        }
        return true;
    }

    bool FindNetlistInModule::VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce) {
        if (_pass == 2) {
            std::string channelName;
            std::string instanceName;
            std::string portName;
            std::string hierChannelInstanceName;
            int i = 0;

            for (clang::Stmt::child_iterator it = ce->IgnoreImpCasts()->child_begin(), eit = ce->IgnoreImpCasts()->child_end();
                 it != eit; it++) {

                if(i == 1) {
                    clang::Expr *e = llvm::dyn_cast<clang::Expr>(*it);
                    clang::MemberExpr *me = llvm::dyn_cast<clang::MemberExpr>(e->IgnoreImpCasts());

                    clang::Stmt::child_iterator itz = me->child_begin();
                    clang::Expr *ez = llvm::dyn_cast<clang::Expr>(*itz);
                    clang::MemberExpr *mez = llvm::dyn_cast<clang::MemberExpr>(ez->IgnoreImpCasts());
                    portName = me->getMemberDecl()->getNameAsString();
                    instanceName = mez->getMemberDecl()->getNameAsString();

                } else if(i == 2) {
                    clang::Expr *e = llvm::dyn_cast<clang::Expr>(*it);
                    clang::MemberExpr *me = llvm::dyn_cast<clang::MemberExpr>(e->IgnoreImpCasts());
                    channelName = me->getMemberDecl()->getNameAsString();


                    clang::Stmt::child_iterator hierIt = me->child_begin();
                    clang::Expr *hierExp = llvm::dyn_cast<clang::Expr>(*hierIt);
                    clang::MemberExpr *hierME = llvm::dyn_cast<clang::MemberExpr>(hierExp->IgnoreImpCasts());

                    if (hierME) {
                        hierChannelInstanceName = hierME->getMemberDecl()->getNameAsString();
                        auto leftEntry = std::pair<std::string, std::string>(instanceName, portName);
                        auto rightEntry = std::pair<std::string, std::string>(channelName, hierChannelInstanceName);
                        auto hierouterEntry = std::pair<std::pair<std::string, std::string>, std::pair<std::string, std::string>>(leftEntry,
                                                                                                                                  rightEntry);
                        this->_hierchannelConnectionMap.insert(hierouterEntry);
                    } else {
                        //! <<instance, port>, channelName>
                        auto innerEntry = std::pair<std::string, std::string>(instanceName, portName);
                        auto outerEntry = std::pair<std::pair<std::string, std::string>, std::string>(innerEntry, channelName);
                        this->_channelConnectionMap.insert(outerEntry);
                    }
                }
                i++;
            }
        }
        return true;
    }



    void FindNetlistInModule::recursiveTemplateVisitor(clang::QualType qualType) {
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

    std::map<std::string, std::string> FindNetlistInModule::getInstanceMap() {
        return this->_instanceMap;
    }

    std::map<std::string, std::pair<std::string, std::string>> FindNetlistInModule::getChannelMap() {
        return this->_channelMap;
    }

    std::map<std::pair<std::string,std::string>, std::string> FindNetlistInModule::getchannelConnectionMap() {
        return this->_channelConnectionMap;
    }

    std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> FindNetlistInModule::gethierchannelConnectionMap() {
        return this->_hierchannelConnectionMap;
    }

    //DEBUG
    void FindNetlistInModule::printInstanceMap() {
        for (auto elem : this->getInstanceMap()) {
            std::cout << "Name: " <<  elem.first.c_str() << " Module: " << elem.second.c_str() << " " << "\n";
        }
    }

    void FindNetlistInModule::printChannelMap() {
        for (auto elem : this->getChannelMap()) {
            std::cout << "Name: " << elem.first << " Type: " << elem.second.first << " Signal: " << elem.second.second << std::endl;
        }
    }

    void FindNetlistInModule::printChannelConnectionMap() {
        std::cout <<"===ChannelConnectionMap===" << std::endl;
        for (auto elem : this->getchannelConnectionMap()) {
            //<<instance, port>, channelName>
            std::cout << elem.first.first << "." << elem.first.second << "(" << elem.second << ")"  << std::endl;
        }
    }

    void FindNetlistInModule::printHierChannelConnectionMap() {
        std::cout <<"===HierChannelConnectionMap===" << std::endl;
        for (auto elem : this->gethierchannelConnectionMap()) {
            //<<instance, port>, <channelName, channelparentinstance>>
            std::cout << elem.first.first << "." << elem.first.second << "(" << elem.second.second << "." << elem.second.first << ")" << " Channel declared in: ";
            std::cout << elem.second.second << std::endl;
        }
    }
}




