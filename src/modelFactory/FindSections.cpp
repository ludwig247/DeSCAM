//
// Created by tobias on 19.11.15.
//

#include <iostream>
#include "FindSections.h"


SCAM::FindSections::FindSections(clang::CXXRecordDecl *recordDecl):
        pass(0),
        hasSectionEnum(false),
        hasSectionVar(false),
        hasNextSectionVar(false),
        initialSection(""){
    TraverseDecl(recordDecl);
}

bool SCAM::FindSections::VisitEnumDecl(clang::EnumDecl *enumDecl) {
    //Check wheter Enum State-Enum: If not throw error -> not other Enums are allowed
    if(enumDecl->getNameAsString() == "Sections"){

        this->hasSectionEnum = true;
        //Iterate over each enum value and store name and integer value in map
        for(auto bit = enumDecl->enumerator_begin();bit!=enumDecl->enumerator_end();bit++){
            clang::EnumConstantDecl* enumConstantDecl = *bit;
            std::string name = enumConstantDecl->getNameAsString();
            if(name == "init"){
                throw std::runtime_error("Init is a reserved Keyword, please use a differnt name for this section");
            }
            this->sectionList.push_back(name);
        }
    }
    return true;
}


bool SCAM::FindSections::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
    //If field is builtin-> add else make sure its tracked such that we don't miss any values
    //States enum
    if(fieldDecl->getType()->isEnumeralType()){
        std::string name = fieldDecl->getNameAsString();
        std::string type = fieldDecl->getType().getAsString();
        //States state; Only state and nextstate as enum names and States as Type are allowed
        if(name == "section" && SCAM::containsSubstring(type,"Sections")){
            this->hasSectionVar = true;
            this->sectionVar = std::pair<std::string,clang::FieldDecl*>(name,fieldDecl);
            //llvm::errs() << "\n StateVar found\n";
        }
        if(name == "nextsection" && SCAM::containsSubstring(type,"Sections")){
            this->hasNextSectionVar = true;
            //llvm::errs() << "\n nextSectionVar found\n";
            this->nextSectionVar = std::pair<std::string,clang::FieldDecl*>(name,fieldDecl);
        }
    }
    return true;

}


std::vector<std::string> SCAM::FindSections::getSectionList() {
    return this->sectionList;
}

bool SCAM::FindSections::hasSections() {

    //No sections defined
    if(!this->hasSectionEnum && !this->hasSectionVar && !this->hasNextSectionVar){
        return false;
    }
    //Sections well defined
    if(this->hasSectionEnum && this->hasSectionVar && this->hasNextSectionVar){
        return true;
    }
    //Something is not well defined
    if(this->hasSectionEnum == false){
        llvm::errs() << "\n-E- FindStates - StateEnum variable is missing\n";
    }
    if(this->hasSectionVar == false){
        llvm::errs() << "\n-E- FindStates - StateVar variable is missing\n";
    }
    if(this->hasNextSectionVar == false){
        llvm::errs() << "\n-E- FindStates - nextState variable is missing\n";
    }
    return  false;
}

std::pair<std::string, clang::FieldDecl *> SCAM::FindSections::getStateVar() {
    return this->sectionVar;
}

std::pair<std::string, clang::FieldDecl *> SCAM::FindSections::getNextStateVar() {
    return this->nextSectionVar;
}

bool SCAM::FindSections::VisitCXXConstructorDecl(clang::CXXConstructorDecl *constructorDecl) {

    //Only one Constructor allowed
    if(pass==0){
        //Increase pass
        pass=1;
        //Iterate over each initializer of initializerlist
        for(clang::CXXConstructorDecl::init_iterator initList = constructorDecl->init_begin();initList != constructorDecl->init_end(); initList++){
            clang::CXXCtorInitializer * initializer = *initList;
            //Check whether initializer intializes a member: other possibilites are base classes ...
            if(initializer->isMemberInitializer()){
                //Find Variable in Variable(not ports) and assign initial value
                //Name of member
                std::string memberName = initializer->getMember()->getNameAsString();
                if(memberName == "nextsection" || memberName == "section"){
                    //Find value and store in this->value
                    TraverseStmt(initializer->getInit());
                }
            }
        }
        pass = 2;

    }
    return true;
}

bool SCAM::FindSections::VisitDeclRefExpr(clang::DeclRefExpr *declRefExpr) {
    if(pass==1){
        std::string value = declRefExpr->getDecl()->getNameAsString();
        this->initialSection = value;
        if(initialSection != "" && value != this->initialSection){
            llvm::errs() << "\n-I- SCAM::FindStates::VisitDeclRefExpr: section and nextsection are not initialized with the same value\n";
        }
        return false;
    }
    return true;

}

std::string SCAM::FindSections::getInitialState() {
    return this->initialSection;
}


