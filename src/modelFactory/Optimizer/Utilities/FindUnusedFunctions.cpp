//
// Created by M.I.Alkoudsi on 29.08.19.
//

#include <Logger/LoggerMsg.h>
#include <Logger/Logger.h>
#include "FindUnusedFunctions.h"


SCAM::FindUnusedFunctions::FindUnusedFunctions(const std::map<int, SCAM::CfgBlock *> &CFG, SCAM::Module *module)
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
            auto sl = SCAM::LoggerMsg::SeverityLevel::Warning;
            auto vt = SCAM::LoggerMsg::ViolationType::NA;
            auto pl = SCAM::Logger::getCurrentProcessedLocation();
            SCAM::LoggerMsg lmsg(msg, locationInfo,sl,vt,pl);
            SCAM::Logger::addMsg(lmsg);
            this->module->removeFunction(function.first);
        }
    }
}

SCAM::FindUnusedFunctions::FindUnusedFunctions(const std::map<int, SCAM::CfgNode *> &CFG, SCAM::Module *module)
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

void SCAM::FindUnusedFunctions::visit(SCAM::Ternary &node) {
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);
}




