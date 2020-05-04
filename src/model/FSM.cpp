//
// Created by ludwig on 20.11.15.
//

#include <Stmts/EnumValue.h>
#include "FSM.h"
#include "Module.h"
#include "FatalError.h"
#include "Logger/Logger.h"



SCAM::FSM::FSM(Module *module) :
        module(module),
        sectionVariable(nullptr),
        nextSectionVariable(nullptr) {


}

void SCAM::FSM::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}


void SCAM::FSM::setSectionMap(std::map<std::string, std::vector<SCAM::Stmt *>> sectionMap) {
    this->sectionMap = sectionMap;
}

const std::map<std::string, std::vector<SCAM::Stmt *>> &SCAM::FSM::getSectionMap() {
    if (sectionVariable == nullptr) TERMINATE("SectionVariable is not set");// {
        //std::map<std::string, std::vector<SCAM::Stmt *>> a = {"init", };
    //}//
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


std::string SCAM::FSM::getInitialSection() {
    if (sectionVariable == nullptr) TERMINATE("sectionVariable is not set");
    return this->sectionVariable->getInitialValue()->getValueAsString();
}


std::vector<std::string> SCAM::FSM::getSectionList() {
    if (sectionVariable == nullptr) TERMINATE("sectionVariable is not set");
    std::vector<std::string> sectionList;
    for (auto section:this->sectionVariable->getDataType()->getEnumValueMap()) {
        sectionList.push_back(section.first);
    }
    return sectionList;
}

void SCAM::FSM::setSections(DataType *sectionType, std::string initialSection) {
    if (!sectionType->isEnumType()) TERMINATE("Section Type is wrong: not an enumType");
    if (sectionType->getName() != this->module->getName() + "_SECTIONS") TERMINATE(this->module->getName() + ": Wrong section type " + sectionType->getName());
    if (sectionType->getEnumValueMap().find(initialSection) == sectionType->getEnumValueMap().end()) TERMINATE("InitalState is not part of sectionMap");

    this->sectionVariable = new Variable("section", sectionType, new SCAM::EnumValue(initialSection, sectionType)); //default init;
    this->nextSectionVariable = new Variable("section", sectionType, new EnumValue(initialSection, sectionType)); //default init;


}

SCAM::FSM::~FSM() {
    for (auto state : stateMap) {
        delete state.second;
    }
}

SCAM::Module *SCAM::FSM::getModule() const {
    return module;
}

SCAM::FSM::FSM() {
    TERMINATE("Unallowed use of constructior SCAM::FSM()");

}

const std::map<SCAM::Operation *, SCAM::Path *> &SCAM::FSM::getOperationPathMap() const {
    return operationPathMap;
}

void SCAM::FSM::setOperationPathMap(const std::map<SCAM::Operation *, SCAM::Path *> &operationPathMap) {
    FSM::operationPathMap = operationPathMap;
}
