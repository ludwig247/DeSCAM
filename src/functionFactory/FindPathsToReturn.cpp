//


#include "FindPathsToReturn.h"
#include "FatalError.h"
#include "Logger/Logger.h"


std::map<DESCAM::Stmt *, DESCAM::Stmt *> DESCAM::FindPathsToReturn::trueMap;
std::map<DESCAM::Stmt *, DESCAM::Stmt *> DESCAM::FindPathsToReturn::falseMap;


DESCAM::FindPathsToReturn::FindPathsToReturn(const std::vector<DESCAM::Stmt *> &stmtList){
    //Iterate over eac stmts of te stmtList
    for (auto stmt: stmtList) {
        stmt->accept(*this);
    }
}

void DESCAM::FindPathsToReturn::visit(struct Wait &node) {
    this->appendStmtToPaths(&node);
}


void DESCAM::FindPathsToReturn::visit(struct Peek &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(DESCAM::ArrayExpr &node) {
    this->appendStmtToPaths(&node);;

}

void DESCAM::FindPathsToReturn::visit(struct SectionOperand &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct IntegerValue &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(DESCAM::UnsignedValue &node) {
    this->appendStmtToPaths(&node);
}
void DESCAM::FindPathsToReturn::visit(struct EnumValue &node) {
    this->appendStmtToPaths(&node);
}


void DESCAM::FindPathsToReturn::visit(struct BoolValue &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct CompoundValue &node) {
    this->appendStmtToPaths(&node);
}


void DESCAM::FindPathsToReturn::visit(struct VariableOperand &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct TimePointOperand &node) {
    this->appendStmtToPaths(&node);
}


void DESCAM::FindPathsToReturn::visit(struct PortOperand &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(class DESCAM::Notify &node) {
    TERMINATE("not implemented");

}

void DESCAM::FindPathsToReturn::visit(struct Assignment &node) {
     this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct UnaryExpr &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct While &node) {
    this->appendStmtToPaths(&node);
}


void DESCAM::FindPathsToReturn::visit(struct If &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct SectionValue &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct ITE &node) {
    //Step 0: empty ITE ?
    if(node.getIfList().empty() && node.getElseList().empty()){
        return;
    }

    //Step 1: Find all paths of the true/false branch
    FindPathsToReturn ifVisitor(node.getIfList());
    FindPathsToReturn elseVisitor(node.getElseList());

    //Step2: In case branch is first stmt in section -> pathList is empty an empty path
    if (pathList.empty()) {
        if (!node.getIfList().empty() or !node.getElseList().empty()) {
            this->pathList.push_back(new Path());
        }
    }
    //Step 3: newPathList: all new paths are added to this list
    std::vector<DESCAM::Path *> newPathObjectList;

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
void DESCAM::FindPathsToReturn::visit(struct Arithmetic &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct Cast &node) {
    this->appendStmtToPaths(&node);
}


void DESCAM::FindPathsToReturn::visit(DESCAM::FunctionOperand &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::appendStmtToPaths(DESCAM::Stmt *stmt) {
    //Step 1: If no pathObject exists,yet add an empty one
    if (this->pathList.empty()) this->pathList.push_back(new Path());
    //Step 2: Add stmt to each existing path
    for (int i = 0; i < pathList.size(); i++) {
        pathList.at(i)->addStmt(stmt);
    }
}

std::vector<DESCAM::Path *> DESCAM::FindPathsToReturn::getPathList() {
    //Every nextstate that is empty is a path without nextstate assignment
    //Assign starting state of path as nextstate
    return this->pathList;
}

//! When creating paths, there is always a branch with the condition beeing true or not true
DESCAM::Stmt *DESCAM::FindPathsToReturn::find_or_add_true(Expr *conditionStmt) {
    //Is conditoin already in map?
    if (FindPathsToReturn::trueMap.find(conditionStmt) == FindPathsToReturn::trueMap.end()) {
        //Add variable to map
        FindPathsToReturn::trueMap.insert(std::make_pair(conditionStmt, new If(conditionStmt)));
    }
    return FindPathsToReturn::trueMap[conditionStmt];
}

//! When creating paths, there is always a branch with the condition beeing true or not true
DESCAM::Stmt *DESCAM::FindPathsToReturn::find_or_add_false(Expr *conditionStmt) {
    //Is conditoin already in map?
    if (FindPathsToReturn::falseMap.find(conditionStmt) == FindPathsToReturn::falseMap.end()) {
        //Add variable to map
        FindPathsToReturn::falseMap.insert(std::make_pair(conditionStmt, new If(new UnaryExpr("not", conditionStmt))));
    }
    return FindPathsToReturn::falseMap[conditionStmt];
}

DESCAM::FindPathsToReturn::~FindPathsToReturn() {

}

void DESCAM::FindPathsToReturn::visit(struct Logical &node) {
    this->appendStmtToPaths(&node);
}


void DESCAM::FindPathsToReturn::visit(struct Relational &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct Bitwise &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct Read &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct Write &node) {
    this->appendStmtToPaths(&node);
}

void DESCAM::FindPathsToReturn::visit(struct SyncSignal &node) {
    TERMINATE("FindPathsToReturn: SynchSignal not allowed here");

}

void DESCAM::FindPathsToReturn::visit(struct DataSignalOperand &node) {
    TERMINATE("FindPathsToReturn: DataSignal not allowed here");
}

void DESCAM::FindPathsToReturn::visit(DESCAM::ArrayOperand &node) {
    this->appendStmtToPaths(&node);

}

void DESCAM::FindPathsToReturn::visit(DESCAM::CompoundExpr &node) {
    this->appendStmtToPaths(&node);;

}

void DESCAM::FindPathsToReturn::visit(DESCAM::ParamOperand &node) {
    this->appendStmtToPaths(&node);

}

void DESCAM::FindPathsToReturn::visit(DESCAM::Return &node) {
    this->appendStmtToPaths(&node);

}

void DESCAM::FindPathsToReturn::visit(class DESCAM::Ternary &node) {
    this->appendStmtToPaths(&node);

}


