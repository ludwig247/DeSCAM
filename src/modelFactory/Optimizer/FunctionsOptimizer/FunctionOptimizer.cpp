//
// Created by M.I.Alkoudsi on 14.07.19.
//

#include "FunctionOptimizer.h"

#include <utility>
#include "Optimizer/Debug.h"


SCAM::FunctionsOptimizer::FunctionsOptimizer(std::map<int, CfgNode *> CFG, SCAM::Module *module, std::set<std::string> variablesThatHaveReadSet) : CFG(std::move(
        CFG)), module(module), hasFunction(false), newStmt(nullptr), newExpr(nullptr), variablesThatHaveReadSet(std::move(variablesThatHaveReadSet)) {

#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl << "********************** Functions Optimizer *********************** " << std::endl;
#endif
    //Finding all variable values
    SCAM::FindVariablesValues valuesFinder(this->CFG, this->variablesThatHaveReadSet);
    this->allVarValuesMap = valuesFinder.getVariableValuesMap();

    for (auto node : this->CFG) {
        auto stmt = node.second->getStmt();
        if (stmt != nullptr) {
            this->newStmt = nullptr;
            this->newExpr = nullptr;
            stmt->accept(*this);
            if (this->newStmt && hasFunction) {
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
                std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
                std::cout << SCAM::PrintStmt::toString(this->newStmt) << std::endl;
#endif
                this->CFG.at(node.first)->setStmt(this->newStmt);
                hasFunction = false;
            }
        }
    }
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl << "****************************************************************** " << std::endl;
#endif
}


void SCAM::FunctionsOptimizer::visit(SCAM::Assignment &node) {
    //LHS
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }


    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    if(hasFunction) {
        this->newStmt = new SCAM::Assignment(lhs, rhs);
    }
}

void SCAM::FunctionsOptimizer::visit(class UnaryExpr &node) {
    node.getExpr()->accept(*this);
    if (this->newExpr && hasFunction) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);
            this->newStmt = this->newExpr;
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
                this->newStmt = this->newExpr;
            } else {
                this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));
                this->newStmt = this->newExpr;
            }

        } else throw std::runtime_error("Unknown unary operator " + node.getOperation());
    }
}

void SCAM::FunctionsOptimizer::visit(SCAM::If &node) {
    node.getConditionStmt()->accept(*this);
    if (this->newExpr && hasFunction) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new If(this->newExpr);
    }
}

void SCAM::FunctionsOptimizer::visit(class Write &node) {
    node.getValue()->accept(*this);
    if (this->newExpr && hasFunction) {
        this->newStmt = new Write(node.getPort(), this->newExpr , node.isNonBlockingAccess() , node.getStatusOperand());
    }
}

void SCAM::FunctionsOptimizer::visit(class Arithmetic &node) {
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
    if(hasFunction) {
        this->newExpr = new SCAM::Arithmetic(lhs, node.getOperation(), rhs);
    }
}

void SCAM::FunctionsOptimizer::visit(class Logical &node) {
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
    if(hasFunction){
    this->newExpr = new SCAM::Logical(lhs, node.getOperation(), rhs);
    }
}

void SCAM::FunctionsOptimizer::visit(class Relational &node) {
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
    if(hasFunction) {
        this->newExpr = new SCAM::Relational(lhs, node.getOperation(), rhs);
    }
}

void SCAM::FunctionsOptimizer::visit(class Bitwise &node) {
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
    if(hasFunction) {
        this->newExpr = new SCAM::Bitwise(lhs, node.getOperation(), rhs);
    }
}

void SCAM::FunctionsOptimizer::visit(class Cast &node) {
    node.getSubExpr()->accept(*this);
    if (this->newExpr && hasFunction) {
        this->newExpr = new Cast(this->newExpr, node.getDataType());
    }
}

void SCAM::FunctionsOptimizer::visit(class FunctionOperand &node) {

    hasFunction = true;
    std::map<std::string, SCAM::Expr *> newParamValueMap;
    for (const auto& param : node.getParamValueMap()) {
        if (auto funOp = SCAM::NodePeekVisitor::nodePeekFunctionOperand(param.second)) {
            this->newExpr = nullptr;
            funOp->accept(*this);
            if (this->newExpr) {
                newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
            } else { newParamValueMap.insert(std::make_pair(param.first, param.second)); }
        } else {
            newParamValueMap.insert(std::make_pair(param.first, param.second));
        }
    }

    auto function = new Function(*node.getFunction());
    std::string newName;
    if (this->functionUseMap.find(node.getOperandName()) == this->functionUseMap.end()) {
        this->functionUseMap.insert(std::make_pair(node.getOperandName(), 1));
        newName = node.getOperandName() + "_opt" + std::to_string(this->functionUseMap.at(node.getOperandName()));
        this->functionUseMap.at(node.getOperandName())++;
    } else {
        newName = node.getOperandName() + "_opt" + std::to_string(this->functionUseMap.at(node.getOperandName()));
        this->functionUseMap.at(node.getOperandName())++;
    }

    function->setName(newName);
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
//    std::cout << newName << std::endl;
//    std::cout << "function " << function->getName() << std::endl;
//    std::cout << "operand new name is " << newName << std::endl;
//    std::cout << "return map before param value propagation " << function->getReturnValueConditionList().size() << std::endl;
//    for (auto pair :function->getReturnValueConditionList()) {
//        std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
//                  << std::endl;
//    std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
//        for (auto stmt : pair.second) {
//
//            std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
//        }
//
//    }

//    std::cout << "---Value propagation---" << std::endl;
#endif
    /// Param value propagation
    ParamValuePropagation pvp(node.getParamValueMap(), function->getReturnValueConditionList());
    function->setReturnValueConditionList(pvp.getReturnValueConditionList());
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
//    std::cout << std::endl;
//    std::cout << "return map after param value propagation " << function->getReturnValueConditionList().size() << std::endl;

//    std::cout << std::endl << "after propagation " << function->getName() << std::endl;
//    std::cout << "From function return value condition list is  " << std::endl;
//    for (auto pair :function->getReturnValueConditionList()) {
//        std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
//                  << std::endl;
//        std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
//        for (auto stmt : pair.second) {
//
//            std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
//        }
//    }

//    std::cout << "---Reachability analysis---" << std::endl;
#endif
    /// Function reachability analysis
    ReachabilityAnalysis fra(function->getReturnValueConditionList(), this->allVarValuesMap,
                                     this->variablesThatHaveReadSet);
    function->setReturnValueConditionList(fra.getReturnValueConditionList());
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
//    std::cout << std::endl;
//    std::cout << "return map after reachability analysis " << function->getReturnValueConditionList().size() << std::endl;
//
    /*std::cout << std::endl << "after function reachability analysis " << function->getName() << std::endl;
    std::cout << "From function return value condition list is  " << std::endl;
    for (auto pair :function->getReturnValueConditionList()) {
        std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
                  << std::endl;
        std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
        for (auto stmt : pair.second) {

            std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
        }
    }*/

//    std::cout << "---Simplify expressions---" << std::endl;
#endif
    /// Simplify expressions
    SimplifyExpressions se(function->getReturnValueConditionList(), this->module);
    function->setReturnValueConditionList(se.getReturnValueConditionList());

#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << "---Operator Strength Reduction---" << std::endl;
#endif
    /// Operator Strength Reduction
    OperatorStrengthReduction osr(function->getReturnValueConditionList());
    function->setReturnValueConditionList(osr.getReturnValueConditionList());
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl;
#endif
    //making functionOperand point to the new function
    if (function->getReturnValueConditionList().size() == 1) {
        this->newExpr = (*function->getReturnValueConditionList().begin()).first->getReturnValue();
        this->newStmt = this->newExpr;
    } else {
        this->newExpr = new SCAM::FunctionOperand(function, newParamValueMap);
        this->newStmt = this->newExpr;

        //add function to the module
        this->module->addFunction(function);
    }

}

void SCAM::FunctionsOptimizer::visit(SCAM::ArrayOperand &node) {
node.getIdx()->accept(*this);
}

void SCAM::FunctionsOptimizer::visit(SCAM::CompoundExpr &node) {
    std::map<std::string, SCAM::Expr *> newValMap;
    bool valueMapChanged = false;
    for (auto val : node.getValueMap()) {
        this->newExpr = nullptr;
        val.second->accept(*this);
        if (this->newExpr) {
            valueMapChanged = true;
            newValMap.insert(std::make_pair(val.first, this->newExpr));
        } else { newValMap.insert(val); }
    }
    if (valueMapChanged) {
        this->newExpr = new SCAM::CompoundExpr(newValMap, node.getDataType());
    }else{
        this->newExpr = nullptr;
    }
}

void SCAM::FunctionsOptimizer::visit(SCAM::ArrayExpr &node) {
    std::map<std::string, SCAM::Expr *> newValMap;
    bool valueMapChanged = false;
    for (auto val : node.getValueMap()) {
        this->newExpr = nullptr;
        val.second->accept(*this);
        if (this->newExpr) {
            valueMapChanged = true;
            newValMap.insert(std::make_pair(val.first, this->newExpr));
        } else { newValMap.insert(val); }
    }
    if (valueMapChanged) {
        this->newExpr = new SCAM::ArrayExpr(newValMap, node.getDataType());
    }else{
        this->newExpr = nullptr;
    }
}


const std::map<int, SCAM::CfgNode *> &SCAM::FunctionsOptimizer::getCFG() const {
    return this->CFG;
}





