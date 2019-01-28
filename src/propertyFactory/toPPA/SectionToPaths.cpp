//

#include <PrintStmt.h>
#include "SectionToPaths.h"

#include "IntegerValue.h"
#include "VariableOperand.h"
#include "Assignment.h"
#include "PortOperand.h"
#include "UnaryExpr.h"
#include "While.h"
#include "If.h"
#include "SectionOperand.h"
#include "BoolValue.h"
#include "SectionValue.h"
#include "ITE.h"
#include "Branch.h"
#include "Arithmetic.h"
#include "Logical.h"
#include "Relational.h"
#include "EnumValue.h"
#include "Read.h"
#include "Write.h"
#include "NBRead.h"
#include "NBWrite.h"
#include "SyncSignal.h"
#include "DataSignal.h"

std::map<SCAM::Stmt *, SCAM::Stmt *> SCAM::SectionToPaths::trueMap;
std::map<SCAM::Stmt *, SCAM::Stmt *> SCAM::SectionToPaths::falseMap;


SCAM::SectionToPaths::SectionToPaths(std::string section, std::vector<Stmt *> stmtList) :
        section(section),
        nextSection(section) {

    //Iterate over eac stmts of te stmtList
    for (auto stmt: stmtList) {
        stmt->accept(*this);
    }

}


SCAM::SectionToPaths::SectionToPaths(const std::map<std::string, std::vector<Stmt *>> &sectionMap) {
   for(auto section: sectionMap){
       SectionToPaths sectionToPaths(section.first,section.second);
       this->sectionPathMap.insert(std::make_pair(section.first,sectionToPaths.getPathList()));
   }
    for (auto &&section : sectionPathMap) {
        for (auto &&path : section.second) {
            Stmt * lastStmt = path->getStmtList().back();
            std::string next_state = path->getStmtNextstateMap().at(lastStmt);
            path->setNextSection(next_state);
        }
    }
}


void SCAM::SectionToPaths::visit(struct SectionOperand &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct IntegerValue &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(SCAM::UnsignedValue &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct EnumValue &node) {
    this->appendStmtToPaths(&node);
}
void SCAM::SectionToPaths::visit(struct BoolValue &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::SectionToPaths::visit(struct CompoundValue &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct VariableOperand &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::SectionToPaths::visit(struct PortOperand &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::SectionToPaths::visit(struct Assignment &node) {

    if (SectionValue * nextState = dynamic_cast<SectionValue *>(node.getRhs())) {
        if (this->pathList.empty()) this->pathList.push_back(new Path(this->section));
        for (auto path: this->pathList) {
            this->nextSection = nextState->getValue();
            path->setNextSection(nextState->getValue());
        }
        this->appendStmtToPaths(&node);
    } else this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct UnaryExpr &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct While &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct If &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::SectionToPaths::visit(struct SectionValue &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct ITE &node) {
    //Step 0: empty ITE ?
    if(node.getIfList().empty() && node.getElseList().empty()){
        return;
    }

    //Step 1: Find all paths of the true/false branch
    SectionToPaths ifVisitor(this->section, node.getIfList());
    SectionToPaths elseVisitor(this->section, node.getElseList());

    //Step2: In case branch is first stmt in section -> pathList is empty an empty path
    if (pathList.empty()) {
        if (!node.getIfList().empty() or !node.getElseList().empty()) {
            this->pathList.push_back(new Path(this->section));
        }
    }
    //Step 3: newPathList: all new paths are added to this list
    std::vector<SCAM::Path *> newPathObjectList;

    //Step 4: Create X new paths for each old path
    //  X = #paths of true branch + #paths of false branch

    for (auto oldPath: this->getPathList()) {
        //TRUE BRANCH
        //If body empty -> Add empty path with condition
        if (ifVisitor.getPathList().empty()) {
            //Create new path as old path
            Path newPath(*oldPath);
            //Add the condition if(condition) to the end of the list of the old path
            newPath.addStmt(find_or_add_true(node.getConditionStmt()));
            newPathObjectList.push_back(new Path(newPath));
        }
        //If body not empty
        for (auto ifPath: ifVisitor.getPathList()) {
            //Add the condition if(condition) to the end of the list of the old path
            auto oldStmtList = oldPath->getStmtList();
            oldStmtList.push_back(find_or_add_true(node.getConditionStmt()));
            //Create a new path object by extending the old one with new stmts;
            Path newPath = Path(*oldPath, oldStmtList) + Path(*ifPath);
            newPathObjectList.push_back(new Path(newPath));
        }
        //FALSE BRANCH
        //Else body empty -> Add empty path with negated condition
        if (elseVisitor.getPathList().empty()) {
            Path newPath(*oldPath);
            //Add the condition if(!condition) to the end of the list of the old path
            newPath.addStmt(find_or_add_false(node.getConditionStmt()));
            newPathObjectList.push_back(new Path(newPath));
        }
        //Else body not empty
        for (auto elsePath: elseVisitor.getPathList()) {
            //Add the condition if(!condition) to the end of the list of the old path
            auto oldStmtList = oldPath->getStmtList();
            oldStmtList.push_back(find_or_add_false(node.getConditionStmt()));
            //Create a new path object by extending the old one with new stmts;
            Path newPath = Path(*oldPath, oldStmtList) + Path(*elsePath);
            newPathObjectList.push_back(new Path(newPath));
        }
    }

    //Step 5: Overwrite old pathList with the new pathList
    if (!newPathObjectList.empty()) {
        this->pathList.clear();
        this->pathList.insert(this->pathList.begin(), newPathObjectList.begin(), newPathObjectList.end());
    }
    //Continue recursion
}

void SCAM::SectionToPaths::visit(struct Arithmetic &node) {
    this->appendStmtToPaths(&node);
}
void SCAM::SectionToPaths::visit(struct Cast &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(SCAM::FunctionOperand &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::SectionToPaths::appendStmtToPaths(SCAM::Stmt *stmt) {
    //Step 1: If no pathObject exists,yet add an empty one
    if (this->pathList.empty()) this->pathList.push_back(new Path(section));
    //Step 2: Add stmt to each existing path
    for (int i = 0; i < pathList.size(); i++) {
        pathList.at(i)->addStmt(stmt);

    }
}

std::vector<SCAM::Path *> SCAM::SectionToPaths::getPathList() {
    //Every nextstate that is empty is a path without nextstate assignment
    //Assign starting state of path as nextstate
    //TODO: Change SectioToPaths such that this is not necessary anymore
    for (auto path: this->pathList) {
        if (path->getNextSection() == "") {
            path->setNextSection(path->getSection());
        }
    }
    return this->pathList;
}

//! When creating paths, there is always a branch with the condition beeing true or not true
SCAM::Stmt *SCAM::SectionToPaths::find_or_add_true(Expr *conditionStmt) {
    //Is conditoin already in map?
    if (SectionToPaths::trueMap.find(conditionStmt) == SectionToPaths::trueMap.end()) {
        //Add variable to map
        SectionToPaths::trueMap.insert(std::make_pair(conditionStmt, new If(conditionStmt)));
    }
    return SectionToPaths::trueMap[conditionStmt];
}

//! When creating paths, there is always a branch with the condition beeing true or not true
SCAM::Stmt *SCAM::SectionToPaths::find_or_add_false(Expr *conditionStmt) {
    //Is conditoin already in map?
    if (SectionToPaths::falseMap.find(conditionStmt) == SectionToPaths::falseMap.end()) {
        //Add variable to map
        SectionToPaths::falseMap.insert(std::make_pair(conditionStmt, new If(new UnaryExpr("not", conditionStmt))));
    }
    return SectionToPaths::falseMap[conditionStmt];
}

SCAM::SectionToPaths::~SectionToPaths() {

}

void SCAM::SectionToPaths::visit(struct Logical &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct Relational &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::SectionToPaths::visit(struct Bitwise &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct Read &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct Write &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::SectionToPaths::visit(struct NBRead &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct NBWrite &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::SectionToPaths::visit(struct SyncSignal &node) {
    throw std::runtime_error("SectionToPaths: SynchSignal not allowed here");

}

void SCAM::SectionToPaths::visit(struct DataSignalOperand &node) {
    throw std::runtime_error("SectionToPaths: DataSignal not allowed here");
}

const std::map<std::string, std::vector<SCAM::Path *>> &SCAM::SectionToPaths::getNewSectionPathMap() const {
    return sectionPathMap;
}

void SCAM::SectionToPaths::visit(SCAM::SubSelect &node) {
    this->appendStmtToPaths(&node);

}

void SCAM::SectionToPaths::visit(SCAM::CompoundExpr &node) {
    this->appendStmtToPaths(&node);;

}

void SCAM::SectionToPaths::visit(SCAM::ParamOperand &node) {
    this->appendStmtToPaths(&node);

}

void SCAM::SectionToPaths::visit(SCAM::Return &node) {
    this->appendStmtToPaths(&node);

}

