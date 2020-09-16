//
// Created by M.I.Alkoudsi on 29.08.19.
//

#include <Logger/LoggerMsg.h>
#include <Logger/Logger.h>
#include "FindUnusedFunctions.h"


DESCAM::FindUnusedFunctions::FindUnusedFunctions(const std::map<int, DESCAM::CfgBlock *> &CFG, DESCAM::Module *module)
        : module(module), blockCFG(CFG) {

    for (auto block : this->blockCFG) {
        auto stmtList = block.second->getStmtList();
        for (auto stmt : stmtList) {
            if (stmt) {
                stmt->accept(*this);
            }
        }
        if (block.second->hasIf()) {
            block.second->getTerminator()->accept(*this);
        }
    }
    if (this->usedFunctionsSet.size() != this->module->getFunctionMap().size()) {
        for (const auto &function : this->module->getFunctionMap()) {
            if (this->usedFunctionsSet.find(function.first) == this->usedFunctionsSet.end()) {
                this->unusedFunctionSet.insert(function);
            }
        }
        for (const auto &function : this->unusedFunctionSet) {
            std::string msg = "the function '" + function.first + "' was never used!";
            LocationInfo locationInfo = function.second->getLocationInfo();
            auto sl = DESCAM::LoggerMsg::SeverityLevel::Warning;
            auto vt = DESCAM::LoggerMsg::ViolationType::NA;
            auto pl = DESCAM::Logger::getCurrentProcessedLocation();
            DESCAM::LoggerMsg lmsg(msg, locationInfo,sl,vt,pl);
            DESCAM::Logger::addMsg(lmsg);
            this->module->removeFunction(function.first);
        }
    }
}

DESCAM::FindUnusedFunctions::FindUnusedFunctions(const std::map<int, DESCAM::CfgNode *> &CFG, DESCAM::Module *module)
        : module(module), nodeCFG(CFG) {

    for (auto node : this->nodeCFG) {
        if (auto stmt = node.second->getStmt()) {
            stmt->accept(*this);
        }
    }
    if (this->usedFunctionsSet.size() != this->module->getFunctionMap().size()) {
        for (const auto &function : this->module->getFunctionMap()) {
            if (this->usedFunctionsSet.find(function.first) == this->usedFunctionsSet.end()) {
                this->unusedFunctionSet.insert(function);
            }
        }
        for (const auto &function : this->unusedFunctionSet) {
            this->module->removeFunction(function.first);
        }
    }
}


void DESCAM::FindUnusedFunctions::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct Write &node) {
    node.getValue()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(DESCAM::FunctionOperand &node) {
    this->usedFunctionsSet.insert(node.getFunction()->getName());
    for (auto param : node.getParamValueMap()) {
        param.second->accept(*this);
    }
    for (auto returnVal : node.getFunction()->getReturnValueConditionList()) {
        returnVal.first->accept(*this);
    }
}

void DESCAM::FindUnusedFunctions::visit(struct ArrayOperand &node) {
    node.getIdx()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(struct CompoundExpr &node) {
    for (auto subVar : node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

void DESCAM::FindUnusedFunctions::visit(DESCAM::ArrayExpr &node) {
    for (auto subVar : node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

void DESCAM::FindUnusedFunctions::visit(struct Return &node) {
    node.getReturnValue()->accept(*this);
}

void DESCAM::FindUnusedFunctions::visit(DESCAM::Ternary &node) {
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);
}




