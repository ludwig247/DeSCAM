//
// Created by M.I.Alkoudsi on 29.08.19.
//

#include "FindUnusedFunctions.h"


SCAM::FindUnusedFunctions::FindUnusedFunctions(const std::map<int, SCAM::CfgBlock *> &CFG, SCAM::Module *module)
        : module(module), blockCFG(CFG) {
    cnt = 0;
    for (auto block : this->blockCFG) {
        auto stmtList = block.second->getStmtList();
        for (auto stmt : stmtList) {
            if (stmt) {
                stmt->accept(*this);
            }
        }
        if(block.second->hasIf()){
            block.second->getTerminator()->accept(*this);
        }
    }
    if(this->usedFunctionsSet.size()!=this->module->getFunctionMap().size()) {
        for (const auto &function : this->module->getFunctionMap()) {
            if (this->usedFunctionsSet.find(function.first) == this->usedFunctionsSet.end()) {
                this->unusedFunctionSet.insert(function.first);
            }
        }
        for (const auto &function : this->unusedFunctionSet) {
            std::cout << "\t\033[1;33mWarning\033[0m: " << "the function '" << function
                      << "' was never used!, DeSCAM deletes it by default"
                      << std::endl;
            this->module->removeFunction(function);
        }
    }
    std::cout << "the number of times functionoperand was accessed " << cnt << std::endl;
}
SCAM::FindUnusedFunctions::FindUnusedFunctions(const std::map<int, SCAM::CfgNode *> &CFG, SCAM::Module *module): module(module), nodeCFG(CFG)  {
    cnt = 0;
    for (auto node : this->nodeCFG) {
            if (auto stmt = node.second->getStmt()) {
                stmt->accept(*this);
        }
    }
    if(this->usedFunctionsSet.size()!=this->module->getFunctionMap().size()) {
        for (const auto &function : this->module->getFunctionMap()) {
            if (this->usedFunctionsSet.find(function.first) == this->usedFunctionsSet.end()) {
                this->unusedFunctionSet.insert(function.first);
            }
        }
        for (const auto &function : this->unusedFunctionSet) {
            this->module->removeFunction(function);
        }
    }
std::cout << "the number of times functionoperand was accessed " << cnt << std::endl;
}


void SCAM::FindUnusedFunctions::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Write &node) {
    node.getValue()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(SCAM::FunctionOperand &node) {
    cnt++;
    this->usedFunctionsSet.insert(node.getFunction()->getName());
    for (auto param : node.getParamValueMap()) {
        param.second->accept(*this);
    }
    for (auto returnVal : node.getFunction()->getReturnValueConditionList()) {
        returnVal.first->accept(*this);
    }
}

void SCAM::FindUnusedFunctions::visit(struct ArrayOperand &node) {
    node.getIdx()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct CompoundExpr &node) {
    for (auto subVar : node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

void SCAM::FindUnusedFunctions::visit(SCAM::ArrayExpr &node) {
    for (auto subVar : node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

void SCAM::FindUnusedFunctions::visit(struct Return &node) {
    node.getReturnValue()->accept(*this);
}




