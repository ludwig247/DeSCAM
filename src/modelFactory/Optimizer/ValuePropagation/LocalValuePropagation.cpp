//
// Created by M.I.Alkoudsi on 14.08.19.
//

#include "LocalValuePropagation.h"
#include "Optimizer/Debug.h"
/* Idea:
 * Look for variables used in the CFG statements. For each found use:
 * If variable in the same statement was checked before and has entry in varValMap. get its value from varValMap
 * Otherwise, make paths from while(true) to the statement and call propagateConstantValue
 * If propagation is valid and numLastAssignments on all paths is equal to the number of paths, update varValMap and the statement
 * after each statement clear varValMap
 * */

SCAM::LocalValuePropagation::LocalValuePropagation(const std::map<int, SCAM::CfgNode *> &CFG) : CFG(CFG),
                                                                                                propagationValid(false),
                                                                                                newExpr(nullptr) {
    //Finding all possible paths from while to the sink node
    whileNodeID = SCAM::GlobalUtilities::findWhileNodeId(this->CFG);
    FindCfgPaths pathsFromWhile(this->CFG, whileNodeID);
    this->setPathsMap(pathsFromWhile.getPathsMap());
    this->setNodeAndAllPathsReachingItMap(pathsFromWhile.getNodeAndAllPathsReachingItMap());

#ifdef DEBUG_LOCAL_VARIABLE_PROPAGATION
    std::cout << std::endl << "******************* Local Variable propagation ******************** " << std::endl;
#endif
    if (!CFG.empty()) {
        for (auto node: CFG) {
            currentNodeID = node.second->getId();
            auto statement = node.second->getStmt();
            if (statement) {
#ifdef DEBUG_LOCAL_VARIABLE_PROPAGATION
                //                std::cout << "Checking statement: " << PrintStmt::toString(statement) << std::endl;
#endif


                this->newExpr = nullptr;
                this->varAlreadyCheckedSet.clear();
                this->varValMap.clear();
                this->pathsToStmtMap.clear();
                this->pathsToStmtMap = this->makeResetPathsToNode(currentNodeID);
                statement->accept(*this);
            }
        }
    }
#ifdef DEBUG_LOCAL_VARIABLE_PROPAGATION
    std::cout << "******************************************************************* " << std::endl;
#endif
}


const std::map<int, SCAM::CfgNode *> &SCAM::LocalValuePropagation::getCFG() const {
    return this->CFG;
}


void SCAM::LocalValuePropagation::visit(struct VariableOperand &node) {

    this->newExpr = nullptr;
#ifdef DONT_PROPAGATE_COMPOUND_VARIABLE_VALUES_TO_WRITE_STATEMENTS
    if(node.getVariable()->isCompoundType() || node.getVariable()->isArrayType()){
        if(dynamic_cast<SCAM::Write*>(this->CFG.at(this->currentNodeID)->getStmt())){
            return;
        }
    }
#endif
    if (this->varAlreadyCheckedSet.find(node.getVariable()->getFullName()) != this->varAlreadyCheckedSet.end()) {
        if (this->varValMap.find(node.getVariable()->getFullName()) != this->varValMap.end()) {
            this->newExpr = this->varValMap.at(node.getVariable()->getFullName());
        } else {
            return;
        }
    } else {
        PropagateConstantValue propagator(this->pathsToStmtMap,
                                          node.getVariable(),
                                          this->currentNodeID);           //check if propagation is valid on all paths
        this->varAlreadyCheckedSet.insert(node.getVariable()->getFullName());
        if (propagator.getNumLastAssignments() != 0 &&
            propagator.getNumLastAssignments() == this->pathsToStmtMap.size() &&
            propagator.getPropagatedValue() != nullptr) {
            propagationValid = true;
            this->newExpr = propagator.getPropagatedValue();
            this->varValMap.insert(std::make_pair(node.getVariable()->getFullName(), this->newExpr));
        } else {
            propagationValid = false;
        }
    }
}

void SCAM::LocalValuePropagation::visit(struct Assignment &node) {
    //if the lhs of it is a variableoperand check if there is a use of a variable in the rhs
    if (dynamic_cast<SCAM::VariableOperand *>(node.getLhs())) {
        node.getRhs()->accept(*this);
        if (this->newExpr != nullptr && propagationValid) {
            auto assignment = new Assignment(node.getLhs(), this->newExpr);
#ifdef DEBUG_LOCAL_VARIABLE_PROPAGATION
            const std::string newAssignment = PrintStmt::toString(assignment);
            const std::string oldAssignment = PrintStmt::toString(&node);
            if (oldAssignment != newAssignment) {
                std::cout << "in Node" << currentNodeID << ": the assignment "
                          << oldAssignment << " is changed to "
                          << newAssignment
                          << std::endl;
            }
#endif
            // set assignment as new node stmt
            this->CFG.at(currentNodeID)->setStmt(assignment);
            this->newExpr = nullptr;
            propagationValid = false;
        }
    }
}

void SCAM::LocalValuePropagation::visit(struct UnaryExpr &node) {
    this->newExpr = nullptr;
    node.getExpr()->accept(*this);
    if (this->newExpr != nullptr) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);
        } else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr);
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
            } else this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));
        } else throw std::runtime_error("Unknown unary operator " + node.getOperation());
    }
}

void SCAM::LocalValuePropagation::visit(struct If &node) {
    // check if there is a use of a variable inside if
    if (node.getConditionStmt() != nullptr) {
        node.getConditionStmt()->accept(*this);
        if (this->newExpr != nullptr && propagationValid) {
            assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
            auto ifStmt = new If(this->newExpr);
#ifdef DEBUG_LOCAL_VARIABLE_PROPAGATION
            const std::string newAssignment = PrintStmt::toString(ifStmt);
            const std::string oldAssignment = PrintStmt::toString(&node);
            if (oldAssignment != newAssignment) {
                std::cout << "in Node" << currentNodeID << ": the assignment "
                          << oldAssignment << " is changed to "
                          << newAssignment
                          << std::endl;
            }
#endif
            // set assignment as new node stmt
            this->CFG.at(currentNodeID)->setStmt(ifStmt);
            this->newExpr = nullptr;
            propagationValid = false;
        }
    }
}

void SCAM::LocalValuePropagation::visit(struct Write &node) {
    // check if there is a use of a variable inside write
    node.getValue()->accept(*this);
    if (this->newExpr != nullptr && propagationValid) {
        auto writeStatement = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(),
                                        node.getStatusOperand());
#ifdef DEBUG_LOCAL_VARIABLE_PROPAGATION
        const std::string newAssignment = PrintStmt::toString(writeStatement);
        const std::string oldAssignment = PrintStmt::toString(&node);
        if (oldAssignment != newAssignment) {
            std::cout << "in Node" << currentNodeID << ": the assignment "
                      << oldAssignment << " is changed to "
                      << newAssignment
                      << std::endl;
        }
#endif
        // set assignment as new node stmt
        this->CFG.at(currentNodeID)->setStmt(writeStatement);
        this->newExpr = nullptr;
        propagationValid = false;
    }
}

void SCAM::LocalValuePropagation::visit(struct Arithmetic &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    this->newExpr = new Arithmetic(lhs, node.getOperation(), rhs);
}

void SCAM::LocalValuePropagation::visit(struct Logical &node) {
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    this->newExpr = new Logical(lhs, node.getOperation(), rhs);
}

void SCAM::LocalValuePropagation::visit(struct Relational &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    this->newExpr = new Relational(lhs, node.getOperation(), rhs);
}

void SCAM::LocalValuePropagation::visit(struct Bitwise &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    this->newExpr = new Bitwise(lhs, node.getOperation(), rhs);
}

void SCAM::LocalValuePropagation::visit(struct Cast &node) {
    this->newExpr = nullptr;
    node.getSubExpr()->accept(*this);
    if (this->newExpr != nullptr) {
        this->newExpr = new Cast(this->newExpr, node.getDataType());
    }
}

void SCAM::LocalValuePropagation::visit(struct FunctionOperand &node) {
    std::map<std::string, SCAM::Expr *> newParamValueMap;
    for (auto param : node.getParamValueMap()) {
        this->newExpr = nullptr;
        param.second->accept(*this);
        if (this->newExpr != nullptr) {
            newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
        } else { newParamValueMap.insert(std::make_pair(param.first, param.second)); }
    }
    this->newExpr = new SCAM::FunctionOperand(node.getFunction(), newParamValueMap);
}


void SCAM::LocalValuePropagation::visit(struct ArrayOperand &node) {
    this->newExpr = nullptr;
    node.getIdx()->accept(*this);
    if (this->newExpr != nullptr && !(*node.getIdx() == *this->newExpr)) {
        this->newExpr = new ArrayOperand(node.getArrayOperand(), this->newExpr);
    }
}

void SCAM::LocalValuePropagation::visit(struct CompoundExpr &node) {
    std::map<std::string, SCAM::Expr *> valueMap;
    for (auto subVar : node.getValueMap()) {
        this->newExpr = nullptr;
        subVar.second->accept(*this);
        if (this->newExpr != nullptr) {
            valueMap.insert(std::make_pair(subVar.first, this->newExpr));
        } else { valueMap.insert(std::make_pair(subVar.first, subVar.second)); }
    }
    this->newExpr = new CompoundExpr(valueMap, node.getDataType());
}

void SCAM::LocalValuePropagation::visit(SCAM::ArrayExpr &node) {
    std::map<std::string, SCAM::Expr *> valueMap;
    for (auto subVar : node.getValueMap()) {
        this->newExpr = nullptr;
        subVar.second->accept(*this);
        if (this->newExpr != nullptr) {
            valueMap.insert(std::make_pair(subVar.first, this->newExpr));
        } else { valueMap.insert(std::make_pair(subVar.first, subVar.second)); }
    }
    this->newExpr = new ArrayExpr(valueMap, node.getDataType());
}

