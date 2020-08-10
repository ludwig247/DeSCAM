//
// Created by ludwig on 20.11.15.
//

#include <Stmts/EnumValue.h>
#include "FSM.h"
#include "Module.h"
#include "FatalError.h"
#include "Logger/Logger.h"



DESCAM::FSM::FSM(Module *module) :
        module(module),
        sectionVariable(nullptr),
        nextSectionVariable(nullptr) {


}

void DESCAM::FSM::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}


void DESCAM::FSM::setSectionMap(std::map<std::string, std::vector<DESCAM::Stmt *>> sectionMap) {
    this->sectionMap = sectionMap;
}

const std::map<std::string, std::vector<DESCAM::Stmt *>> &DESCAM::FSM::getSectionMap() {
    if (sectionVariable == nullptr) TERMINATE("SectionVariable is not set");// {
        //std::map<std::string, std::vector<DESCAM::Stmt *>> a = {"init", };
    //}//
    return this->sectionMap;
}

const std::map<int, DESCAM::State *> &DESCAM::FSM::getStateMap() const {
    return stateMap;
}

void DESCAM::FSM::setStateMap(const std::map<int, DESCAM::State *> &stateMap) {
    FSM::stateMap.clear();
    FSM::stateMap = stateMap;
}

DESCAM::Variable *DESCAM::FSM::getSectionVariable() const {
    return sectionVariable;
}

DESCAM::Variable *DESCAM::FSM::getNextSectionVariable() const {
    return nextSectionVariable;
}


std::string DESCAM::FSM::getInitialSection() {
    if (sectionVariable == nullptr) TERMINATE("sectionVariable is not set");
    return this->sectionVariable->getInitialValue()->getValueAsString();
}


std::vector<std::string> DESCAM::FSM::getSectionList() {
    if (sectionVariable == nullptr) TERMINATE("sectionVariable is not set");
    std::vector<std::string> sectionList;
    for (auto section:this->sectionVariable->getDataType()->getEnumValueMap()) {
        sectionList.push_back(section.first);
    }
    return sectionList;
}

void DESCAM::FSM::setSections(DataType *sectionType, std::string initialSection) {
    if (!sectionType->isEnumType()) TERMINATE("Section Type is wrong: not an enumType");
    if (sectionType->getName() != this->module->getName() + "_SECTIONS") TERMINATE(this->module->getName() + ": Wrong section type " + sectionType->getName());
    if (sectionType->getEnumValueMap().find(initialSection) == sectionType->getEnumValueMap().end()) TERMINATE("InitalState is not part of sectionMap");

    this->sectionVariable = new Variable("section", sectionType, new DESCAM::EnumValue(initialSection, sectionType)); //default init;
    this->nextSectionVariable = new Variable("section", sectionType, new EnumValue(initialSection, sectionType)); //default init;


}

DESCAM::FSM::~FSM() {
    for (auto state : stateMap) {
        delete state.second;
    }
}

DESCAM::Module *DESCAM::FSM::getModule() const {
    return module;
}

DESCAM::FSM::FSM() {
    TERMINATE("Unallowed use of constructior DESCAM::FSM()");

}

const std::map<DESCAM::Operation *, DESCAM::Path *> &DESCAM::FSM::getOperationPathMap() const {
    return operationPathMap;
}

void DESCAM::FSM::setOperationPathMap(const std::map<DESCAM::Operation *, DESCAM::Path *> &operationPathMap) {
    FSM::operationPathMap = operationPathMap;
}
