//
// Created by anna on 12.07.18.
//

#include "PrintStmtLTL.h"

namespace SCAM {

    std::string PrintStmtLTL::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
        PrintStmtLTL printer;
        return printer.createString(stmt, indentSize, indentOffset);
    }

    void PrintStmtLTL::visit(EnumValue &node) {
        this->ss << node.getEnumValue();

    }

    void PrintStmtLTL::visit(Logical &node) {
        this->ss << "(";
        node.getLhs()->accept(*this);

        if (node.getOperation() == "and") {
            this->ss << "  &&  ";
        } else this->ss << " " + node.getOperation() << " ";
        node.getRhs()->accept(*this);
        this->ss << ")";
    }


    void PrintStmtLTL::visit(UnaryExpr &node) {
        if (node.getOperation() == "not") this->ss << "!(";
        else this->ss << node.getOperation() << "(";
        node.getExpr()->accept(*this);
        this->ss << ")";

    }

    void PrintStmtLTL::visit(SyncSignal &node) {
        if (node.getPort()->getInterface()->isBlockingOut()) {
            this->ss << node.getPort()->getName() << "_sync";
        }
        else {
          this->ss << "true";
        }
    };

    void PrintStmtLTL::visit(DataSignalOperand &node) {
        //if(!node.getDataSignal()->getPort()->getInterface()->isShared()) {
            if (node.getDataSignal()->isSubSig()) {
                this->ss << node.getDataSignal()->getParent()->getName() << "_" << node.getDataSignal()->getName();
            } else {
                this->ss << node.getDataSignal()->getName();
            }
        //}
        //else {
        //    this->ss << node.getDataSignal()->getPort()->getName();
        //}

//    this->ss << "()" << node.getOperandName();
//    if(node.getDataSignal()isSubSig())   this->ss <<"_" + node.getSubSigName();
//    this->ss << "_sig";
    }

    void PrintStmtLTL::visit(VariableOperand &node) {
        if (node.getVariable()->isSubVar()) {
            this->ss << node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
        } else {
            this->ss << node.getVariable()->getName();
        }
    }

}
