//
// Created by M.I.Alkoudsi on 14.07.19.
//

#include "FunctionOptimizer.h"

#include <utility>
#include "Optimizer/Debug.h"

/* Idea:
 * Iterates over all statements of the CFG looking for use of functions.
 * Each found function is optimized along with the nested functions inside its body.
 * The optimized function replaces the old one in the statement that uses it.
 * The optimized function is also added to the module
 */

SCAM::FunctionsOptimizer::FunctionsOptimizer(std::map<int, CfgNode *> CFG, SCAM::Module *module,
                                             SCAM::Model *model,
                                             std::set<std::string> variablesThatHaveReadSet) : CFG(std::move(
        CFG)), module(module), model(model), globalVariableMap(model->getGlobalVariableMap()), hasFunction(false), newStmt(nullptr),
                                                                                               newExpr(nullptr),
                                                                                               variablesThatHaveReadSet(
                                                                                                       std::move(
                                                                                                               variablesThatHaveReadSet)) {

#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl << "********************** Functions Optimizer *********************** " << std::endl;
#endif

    if (module->getFunctionMap().empty() && model->getGlobalFunctionMap().empty()) return;

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
    if (lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    //Create new stmt
    if (hasFunction) {
        this->newStmt = new SCAM::Assignment(lhs, rhs);
    }
}

void SCAM::FunctionsOptimizer::visit(class UnaryExpr &node) {
    node.getExpr()->accept(*this);
    if (this->newExpr && hasFunction) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);
        } else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr);
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
            } else {
                this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));
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
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand());
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
    if (lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    //Create new stmt
    if (hasFunction) {
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
    if (lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    //Create new stmt
    if (hasFunction) {
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
    if (lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    //Create new stmt
    if (hasFunction) {
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
    if (lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    //Create new stmt
    if (hasFunction) {
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
    if (node.getFunction()->getName().find("_opt") != std::string::npos) return;
    hasFunction = true;
    //check if already optimized a function with the same paramterslist
    if (auto optFunc = isAlreadyOptimizedFunction(node.getOperandName(), node.getParamValueMap())) {
        this->newExpr = optFunc;
        if (&node == this->newExpr) { this->newExpr = nullptr; }
        return;
    }
    //optimize argument list
    std::map<std::string, SCAM::Expr *> newParamValueMap;
    for (const auto &param : node.getParamValueMap()) {
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
    function->setReturnValueConditionList(node.getFunction()->getReturnValueConditionList());
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout<< function->getName() << std::endl;
    std::cout << "return value condition list size is " << function->getReturnValueConditionList().size() << std::endl;
    for (auto pair :function->getReturnValueConditionList()) {
        std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
                  << std::endl;
        std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
        for (auto stmt : pair.second) {
            std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
        }
    }

    std::cout << "---Parameters Value propagation---" << std::endl;
#endif
    /// Param value propagation
    ParamValuePropagation pvp(newParamValueMap, this->globalVariableMap, function->getReturnValueConditionList());
    function->setReturnValueConditionList(pvp.getReturnValueConditionList());
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl;
       std::cout << "return value condition list size is " << function->getReturnValueConditionList().size() << std::endl;
       for (auto pair :function->getReturnValueConditionList()) {
           std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
                     << std::endl;
           std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
           for (auto stmt : pair.second) {
               std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
           }
       }

       std::cout << "---Reachability analysis---" << std::endl;
#endif
    /// Function reachability analysis
    ReachabilityAnalysis fra(function->getReturnValueConditionList(), this->allVarValuesMap,
                             this->variablesThatHaveReadSet);
    function->setReturnValueConditionList(fra.getReturnValueConditionList());
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl;
    std::cout << "return value condition list size is " << function->getReturnValueConditionList().size() << std::endl;
    for (auto pair :function->getReturnValueConditionList()) {
        std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
                  << std::endl;
        std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
        for (auto stmt : pair.second) {
            std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
        }
    }

    std::cout << "---Simplify expressions---" << std::endl;
#endif
    /// Simplify expressions
    SimplifyExpressions se(function->getReturnValueConditionList(), this->module);
    function->setReturnValueConditionList(se.getReturnValueConditionList());

#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl;
        std::cout << "return value condition list size is " << function->getReturnValueConditionList().size() << std::endl;
        for (auto pair :function->getReturnValueConditionList()) {
            std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
                      << std::endl;
            std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
            for (auto stmt : pair.second) {
                std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
            }
        }

    std::cout << "---Operator Strength Reduction---" << std::endl;
#endif
    /// Operator Strength Reduction
    OperatorStrengthReduction osr(function->getReturnValueConditionList());
    function->setReturnValueConditionList(osr.getReturnValueConditionList());
#ifdef DEBUG_FUNCTIONS_OPTIMIZER
    std::cout << std::endl;
        std::cout << "return value condition list size is " << function->getReturnValueConditionList().size() << std::endl;
        for (auto pair :function->getReturnValueConditionList()) {
            std::cout << "return value for this path " << SCAM::PrintStmt::toString(pair.first->getReturnValue())
                      << std::endl;
            std::cout << "return type of return is " << pair.first->getReturnValue()->getDataType()->getName() << std::endl;
            for (auto stmt : pair.second) {
                std::cout << SCAM::PrintStmt::toString(stmt) << std::endl;
            }
        }

    std::cout << std::endl;
#endif

    //optimize return value condition list
    std::vector<std::pair<Return *, std::vector<Expr *>>> newReturnValueConditionList;
    for (const auto &pair: function->getReturnValueConditionList()) {
        std::vector<Expr *> newConditionVector;
        for (auto expr : pair.second) {
            this->newExpr = nullptr;
            expr->accept(*this);
            if (this->newExpr) {
                newConditionVector.push_back(this->newExpr);
            } else { newConditionVector.push_back(expr); }
        }
        if (pair.first->getReturnValue()) {
            this->newExpr = nullptr;
            pair.first->getReturnValue()->accept(*this);
            if (this->newExpr) {
                auto newReturn = new Return(this->newExpr);
                newReturnValueConditionList.emplace_back(newReturn, newConditionVector);
            } else { newReturnValueConditionList.emplace_back(pair.first, newConditionVector); }
        } else {
            newReturnValueConditionList.emplace_back(pair.first, newConditionVector);
        }
    }
    function->setReturnValueConditionList(newReturnValueConditionList);
    //if no optimizations achieved save the name of the function and its parameter list and return
    if (noOptimizationAchieved(pvp.getReturnValueConditionList(), newReturnValueConditionList)) {
        this->newExpr = nullptr;
        this->oldFuncOpOptimizedFuncPairsMap.insert(std::make_pair(&node, &node));
    }
    //inline function if it has one return value
    if (function->getReturnValueConditionList().size() == 1) {
        this->newExpr = (*function->getReturnValueConditionList().begin()).first->getReturnValue();
        this->oldFuncOpOptimizedFuncPairsMap.insert(std::make_pair(&node, this->newExpr));
    } else if (noOptimizationAchieved(pvp.getReturnValueConditionList(), newReturnValueConditionList)) {
        //if no optimizations achieved save the name of the function and its parameter list and return
        this->newExpr = nullptr;
        this->oldFuncOpOptimizedFuncPairsMap.insert(std::make_pair(&node, &node));

    } else {//create new function and add it to the module
        function->setName(createFuncName(node.getOperandName()));
        this->newExpr = new SCAM::FunctionOperand(function, newParamValueMap);
        auto moduleFunctionMap = this->module->getFunctionMap();
        if(moduleFunctionMap.find(node.getOperandName())!=moduleFunctionMap.end()) {
            this->module->addFunction(function);
        }else{
            this->model->addGlobalFunction(function);
        }
        this->oldFuncOpOptimizedFuncPairsMap.insert(std::make_pair(&node, this->newExpr));
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
    } else {
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
    } else {
        this->newExpr = nullptr;
    }
}


const std::map<int, SCAM::CfgNode *> &SCAM::FunctionsOptimizer::getCFG() const {
    return this->CFG;
}

std::string SCAM::FunctionsOptimizer::createFuncName(std::string funcOpName) {
    std::string newName;
    if (this->functionUseMap.find(funcOpName) == this->functionUseMap.end()) {
        this->functionUseMap.insert(std::make_pair(funcOpName, 1));
        newName = funcOpName + "_opt" + std::to_string(this->functionUseMap.at(funcOpName));
        this->functionUseMap.at(funcOpName)++;
    } else {
        newName = funcOpName + "_opt" + std::to_string(this->functionUseMap.at(funcOpName));
        this->functionUseMap.at(funcOpName)++;
    }
    return newName;
}

SCAM::Expr *
SCAM::FunctionsOptimizer::isAlreadyOptimizedFunction(std::string operandName,
                                                     const std::map<std::string, SCAM::Expr *> &paramValueMap) {
    for (const auto &pair  : oldFuncOpOptimizedFuncPairsMap) {
        if (pair.first->getOperandName() == operandName) {
            bool foundOptFunction = true;
            for (const auto &param : pair.first->getParamValueMap()) {
                if (!(*param.second == *paramValueMap.at(param.first))) {
                    foundOptFunction = false;
                    break;
                }
            }
            if (foundOptFunction) {
                return pair.second;
            }
        }
    }
    return nullptr;
}

bool SCAM::FunctionsOptimizer::noOptimizationAchieved(
        const std::vector<std::pair<Return *, std::vector<Expr *>>> &returnValConditionListPairVector1,
        std::vector<std::pair<Return *, std::vector<Expr *>>> &returnValConditionListPairVector2) {
    if (returnValConditionListPairVector1.size() != returnValConditionListPairVector2.size()) return false;
    auto pairItr = returnValConditionListPairVector2.begin();
    for (auto pair : returnValConditionListPairVector1) {
        if (!((*pair.first) == (*pairItr->first))) {
            return false;
        }
        auto exprItr = pairItr->second.begin();
        for (auto expr : pair.second) {
            if (!((*expr) == (**exprItr))) {
                return false;
            }
            exprItr++;
        }
        pairItr++;
    }
    return true;
}

void SCAM::FunctionsOptimizer::visit(SCAM::Ternary &node) {
    throw std::runtime_error("Combining -Optmize and Compare Operator ? is not allowed");
}





