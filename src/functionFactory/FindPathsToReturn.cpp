//


#include "FindPathsToReturn.h"


std::map<SCAM::Stmt *, SCAM::Stmt *> SCAM::FindPathsToReturn::trueMap;
std::map<SCAM::Stmt *, SCAM::Stmt *> SCAM::FindPathsToReturn::falseMap;


SCAM::FindPathsToReturn::FindPathsToReturn(const std::vector<SCAM::Stmt *> &stmtList){
    //Iterate over eac stmts of te stmtList
    for (auto stmt: stmtList) {
        stmt->accept(*this);
    }
}

void SCAM::FindPathsToReturn::visit(struct Wait &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::FindPathsToReturn::visit(struct Peek &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(SCAM::ArrayExpr &node) {
    this->appendStmtToPaths(&node);;

}

void SCAM::FindPathsToReturn::visit(struct SectionOperand &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct IntegerValue &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(SCAM::UnsignedValue &node) {
    this->appendStmtToPaths(&node);
}
void SCAM::FindPathsToReturn::visit(struct EnumValue &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::FindPathsToReturn::visit(struct BoolValue &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct CompoundValue &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::FindPathsToReturn::visit(struct VariableOperand &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct TimePointOperand &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::FindPathsToReturn::visit(struct PortOperand &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(class SCAM::Notify &node) {
    throw std::runtime_error("not implemented");

}

void SCAM::FindPathsToReturn::visit(struct Assignment &node) {
     this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct UnaryExpr &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct While &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::FindPathsToReturn::visit(struct If &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct SectionValue &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct ITE &node) {
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
void SCAM::FindPathsToReturn::visit(struct Arithmetic &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct Cast &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::FindPathsToReturn::visit(SCAM::FunctionOperand &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::appendStmtToPaths(SCAM::Stmt *stmt) {
    //Step 1: If no pathObject exists,yet add an empty one
    if (this->pathList.empty()) this->pathList.push_back(new Path());
    //Step 2: Add stmt to each existing path
    for (int i = 0; i < pathList.size(); i++) {
        pathList.at(i)->addStmt(stmt);
    }
}

std::vector<SCAM::Path *> SCAM::FindPathsToReturn::getPathList() {
    //Every nextstate that is empty is a path without nextstate assignment
    //Assign starting state of path as nextstate
    return this->pathList;
}

//! When creating paths, there is always a branch with the condition beeing true or not true
SCAM::Stmt *SCAM::FindPathsToReturn::find_or_add_true(Expr *conditionStmt) {
    //Is conditoin already in map?
    if (FindPathsToReturn::trueMap.find(conditionStmt) == FindPathsToReturn::trueMap.end()) {
        //Add variable to map
        FindPathsToReturn::trueMap.insert(std::make_pair(conditionStmt, new If(conditionStmt)));
    }
    return FindPathsToReturn::trueMap[conditionStmt];
}

//! When creating paths, there is always a branch with the condition beeing true or not true
SCAM::Stmt *SCAM::FindPathsToReturn::find_or_add_false(Expr *conditionStmt) {
    //Is conditoin already in map?
    if (FindPathsToReturn::falseMap.find(conditionStmt) == FindPathsToReturn::falseMap.end()) {
        //Add variable to map
        FindPathsToReturn::falseMap.insert(std::make_pair(conditionStmt, new If(new UnaryExpr("not", conditionStmt))));
    }
    return FindPathsToReturn::falseMap[conditionStmt];
}

SCAM::FindPathsToReturn::~FindPathsToReturn() {

}

void SCAM::FindPathsToReturn::visit(struct Logical &node) {
    this->appendStmtToPaths(&node);
}


void SCAM::FindPathsToReturn::visit(struct Relational &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct Bitwise &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct Read &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct Write &node) {
    this->appendStmtToPaths(&node);
}

void SCAM::FindPathsToReturn::visit(struct SyncSignal &node) {
    throw std::runtime_error("FindPathsToReturn: SynchSignal not allowed here");

}

void SCAM::FindPathsToReturn::visit(struct DataSignalOperand &node) {
    throw std::runtime_error("FindPathsToReturn: DataSignal not allowed here");
}

void SCAM::FindPathsToReturn::visit(SCAM::ArrayOperand &node) {
    this->appendStmtToPaths(&node);

}

void SCAM::FindPathsToReturn::visit(SCAM::CompoundExpr &node) {
    this->appendStmtToPaths(&node);;

}

void SCAM::FindPathsToReturn::visit(SCAM::ParamOperand &node) {
    this->appendStmtToPaths(&node);

}

void SCAM::FindPathsToReturn::visit(SCAM::Return &node) {
    this->appendStmtToPaths(&node);

}

void SCAM::FindPathsToReturn::visit(class SCAM::Ternary &node) {
    this->appendStmtToPaths(&node);

}


