//
// Created by ludwig on 20.11.15.
//

#include <Stmts/EnumValue.h>
#include "FSM.h"
#include "Module.h"



SCAM::FSM::FSM(Module * module):
    module(module),
    sectionVariable(nullptr),
    nextSectionVariable(nullptr){


}

void SCAM::FSM::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}


void SCAM::FSM::setSectionMap(std::map<std::string, std::vector<SCAM::Stmt *>> sectionMap) {
    this->sectionMap = sectionMap;
}

const std::map<std::string, std::vector<SCAM::Stmt *>> &SCAM::FSM::getSectionMap() {
    if(sectionVariable == nullptr) throw std::runtime_error("SectionVariable is not set");
    return this->sectionMap;
}

const std::map<int, SCAM::State *> &SCAM::FSM::getStateMap() const {
    return stateMap;
}

void SCAM::FSM::setStateMap(const std::map<int, SCAM::State *> &stateMap) {
    FSM::stateMap.clear();
    FSM::stateMap = stateMap;
}

SCAM::Variable *SCAM::FSM::getSectionVariable() const {
    return sectionVariable;
}

SCAM::Variable *SCAM::FSM::getNextSectionVariable() const {
    return nextSectionVariable;
}


std::string SCAM::FSM::getInitialSection(){
    if(sectionVariable == nullptr) throw std::runtime_error("sectionVariable is not set");
    return this->sectionVariable->getInitialValue()->getValueAsString();
}


std::vector<std::string> SCAM::FSM::getSectionList() {
    if(sectionVariable == nullptr) throw std::runtime_error("sectionVariable is not set");
    std::vector<std::string> sectionList;
    for(auto section:this->sectionVariable->getDataType()->getEnumValueMap() ){
        sectionList.push_back(section.first);
    }
    return sectionList;
}

void SCAM::FSM::setSections(DataType *sectionType, std::string initialSection) {
    if(!sectionType->isEnumType()) throw std::runtime_error("Section Type is wrong: not an enumType");
    if(sectionType->getName() != this->module->getName()+"_SECTIONS") throw std::runtime_error(this->module->getName() +": Wrong section type " + sectionType->getName());
    if(sectionType->getEnumValueMap().find(initialSection) == sectionType->getEnumValueMap().end()) throw std::runtime_error("InitalState is not part of sectionMap");

    this->sectionVariable = new Variable("section",sectionType); //default init;
    this->sectionVariable->setInitialValue(new SCAM::EnumValue(initialSection, sectionType));
    this->nextSectionVariable = new Variable("section",sectionType); //default init;
    this->nextSectionVariable->setInitialValue(new EnumValue(initialSection, sectionType));

}

SCAM::FSM::~FSM() {
    for (auto state : stateMap) {
        delete  state.second;
    }
}

SCAM::Module *SCAM::FSM::getModule() const {
    return module;
}

SCAM::FSM::FSM() {
   throw std::runtime_error("Unallowed use of constructior SCAM::FSM()");

}

const std::map<SCAM::Operation *, SCAM::Path *> &SCAM::FSM::getOperationPathMap() const {
    return operationPathMap;
}

void SCAM::FSM::setOperationPathMap(const std::map<SCAM::Operation *, SCAM::Path *> &operationPathMap) {
    FSM::operationPathMap = operationPathMap;
}
