//
// Created by M.I.Alkoudsi on 29.08.19.
//

#include "FindUnusedFunctions.h"
#include "NodePeekVisitor.h"

SCAM::FindUnusedFunctions::FindUnusedFunctions(std::map<int, SCAM::CfgBlock *> CFG, SCAM::Module *module)
        : module(module), CFG(std::move(CFG)) {

    for (auto block : this->CFG) {
        auto stmtList = block.second->getStmtList();
        for (auto stmt : stmtList) {
            if (stmt) {
                stmt->accept(*this);
            }
            if(NodePeekVisitor::nodePeekFunctionOperand(stmt)!=nullptr){
                for (const auto &item : stmtList) {
                    std::cout << PrintStmt::toString(item) << std::endl;
                }
                std::cout << "\t\033[1;33mWarning\033[0m: " <<  "wrong use of functions at:\033[1;33m'" << PrintStmt::toString(stmt) << "'\033[0m, function returned value is never used"
                          << std::endl;
            }
        }
        if(block.second->hasIf()){
            block.second->getTerminator()->accept(*this);
        }
    }
    for (const auto& function : this->module->getFunctionMap()) {
        if (this->usedFunctionsSet.find(function.first) == this->usedFunctionsSet.end()) {
            this->unusedFunctionSet.insert(function.first);
        }
    }
    for (const auto& function : this->unusedFunctionSet) {
        std::cout << "\t\033[1;33mWarning\033[0m: " <<  "the function '" << function << "' was never used!, DeSCAM deletes it by default"
                  << std::endl;
        this->module->removeFunction(function);
    }
}

void SCAM::FindUnusedFunctions::visit(struct VariableOperand &node) {

}

void SCAM::FindUnusedFunctions::visit(struct IntegerValue &node) {

}

void SCAM::FindUnusedFunctions::visit(struct UnsignedValue &node) {

}

void SCAM::FindUnusedFunctions::visit(struct BoolValue &node) {

}

void SCAM::FindUnusedFunctions::visit(struct EnumValue &node) {

}

void SCAM::FindUnusedFunctions::visit(struct CompoundValue &node) {

}

void SCAM::FindUnusedFunctions::visit(struct PortOperand &node) {

}

void SCAM::FindUnusedFunctions::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct While &node) {

}

void SCAM::FindUnusedFunctions::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Read &node) {

}

void SCAM::FindUnusedFunctions::visit(struct Write &node) {
    node.getValue()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct SectionOperand &node) {

}

void SCAM::FindUnusedFunctions::visit(struct SectionValue &node) {

}

void SCAM::FindUnusedFunctions::visit(struct ITE &node) {

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

void SCAM::FindUnusedFunctions::visit(struct SyncSignal &node) {

}

void SCAM::FindUnusedFunctions::visit(struct DataSignalOperand &node) {

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

void SCAM::FindUnusedFunctions::visit(struct ParamOperand &node) {

}

void SCAM::FindUnusedFunctions::visit(struct Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::FindUnusedFunctions::visit(struct Notify &node) {

}

void SCAM::FindUnusedFunctions::visit(struct Wait &node) {

}

void SCAM::FindUnusedFunctions::visit(struct Peek &node) {

}



