//
// Created by ludwig on 31.08.16.
//

#include <iomanip>
#include <PrintHLS/BitSlicingHLS.h>
#include "VHDLPrintVisitor.h"
#include "NodePeekVisitor.h"
#include "OtherUtils.h"
#include "BitSlicingVHDL.h"

#define USE_ADDER_FOR_2xVAR 1

using namespace SCAM;
using namespace SCAM::VHDL;

VHDLPrintVisitor::VHDLPrintVisitor(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string VHDLPrintVisitor::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    VHDLPrintVisitor printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

std::string VHDLPrintVisitor::getString() {
    return this->ss.str();
}

void VHDLPrintVisitor::visit(VariableOperand &node) {
    useParenthesesFlag = true;
//    this->ss << node.getVariable()->getFullName();
    if (node.getVariable()->isSubVar()) {
        if (node.getVariable()->getParent()->isCompoundType()) {
            this->ss << node.getVariable()->getParent()->getName() << "." << node.getVariable()->getName();
        } else if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << node.getVariable()->getParent()->getName() << "(" << node.getVariable()->getName() << ")";
        } else throw std::runtime_error("Unknown Type for SubVar");
    } else {
        this->ss << node.getVariable()->getName();
    }
//    if (node.getVariable()->isSubVar()) {
//        this->ss << node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
//    } else {
//        this->ss << node.getVariable()->getName();
//    }
}

void VHDLPrintVisitor::visit(SyncSignal &node) {
    useParenthesesFlag = true;
    this->ss <<node.getPort()->getName() << "_sync";
}

void VHDLPrintVisitor::visit(DataSignalOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isCompoundType()) {
            this->ss << "." << node.getDataSignal()->getName();
        } else if (node.getDataSignal()->getParent()->isArrayType()) {
            this->ss << "(" << node.getDataSignal()->getName() << ")";
        } else throw std::runtime_error("Unknown Type for SubVar");
    }
}

void VHDLPrintVisitor::visit(Relational &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if (tempUseParentheses) this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "==") {
        this->ss << " = ";
    } else if (node.getOperation() == "!=") {
        this->ss << " /= ";
    } else {
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    if (tempUseParentheses) this->ss << ")";
}


void VHDLPrintVisitor::visit(Arithmetic &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if (tempUseParentheses) this->ss << "(";
    if (node.getOperation() == "*") {
        NodePeekVisitor nodePeekLhs(node.getLhs());
        NodePeekVisitor nodePeekRhs(node.getRhs());
        if (nodePeekLhs.isConstTypeNode() || nodePeekRhs.isConstTypeNode()) {
#if USE_ADDER_FOR_2xVAR
            if (nodePeekLhs.nodePeekUnsignedValue() && (nodePeekLhs.nodePeekUnsignedValue()->getValue() == 2)) {
                node.getRhs()->accept(*this);
                this->ss << " + ";
                node.getRhs()->accept(*this);
            } else if (nodePeekRhs.nodePeekUnsignedValue() &&
                       (nodePeekRhs.nodePeekUnsignedValue()->getValue() == 2)) {
                node.getLhs()->accept(*this);
                this->ss << " + ";
                node.getLhs()->accept(*this);
            } else
#endif
            if (nodePeekLhs.nodePeekUnsignedValue() &&
                OtherUtils::isPowerOfTwo(nodePeekLhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekLhs.nodePeekUnsignedValue()->getValue());
                this->ss << ")";
            } else if (nodePeekLhs.nodePeekIntegerValue() &&
                       (nodePeekLhs.nodePeekIntegerValue()->getValue() > 0) &&
                       OtherUtils::isPowerOfTwo(nodePeekLhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekLhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekUnsignedValue() &&
                       OtherUtils::isPowerOfTwo(nodePeekRhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekIntegerValue() &&
                       (nodePeekRhs.nodePeekIntegerValue()->getValue() > 0) &&
                       OtherUtils::isPowerOfTwo(nodePeekRhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else {
                node.getLhs()->accept(*this);
                this->ss << " * ";
                node.getRhs()->accept(*this);
            }
        } else {
            node.getLhs()->accept(*this);
            this->ss << " * ";
            node.getRhs()->accept(*this);
        }
    } else {
        node.getLhs()->accept(*this);
        if (node.getOperation() == "%") {
            this->ss << " rem ";
        } else {
            this->ss << " " << node.getOperation() << " ";
        }
        node.getRhs()->accept(*this);
    }
    if (tempUseParentheses) this->ss << ")";
}

void VHDLPrintVisitor::visit(Bitwise &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;

    auto printOperations = std::make_unique<BitSlicingVHDL>(&node);
    if (printOperations->isSlicingOp()) {
        this->ss << printOperations->getOpAsString();
    } else {
        if ((node.getOperation() == "<<") || (node.getOperation() == ">>")) {
            if (node.getOperation() == "<<")
                this->ss << "shift_left(";
            else if (node.getOperation() == ">>")
                this->ss << "shift_right(";
            useParenthesesFlag = false;
            node.getLhs()->accept(*this);
            NodePeekVisitor nodePeek(node.getRhs());
            this->ss << ", ";
            if (nodePeek.nodePeekIntegerValue()) {
                this->ss << nodePeek.nodePeekIntegerValue()->getValue();
            } else if (nodePeek.nodePeekUnsignedValue()) {
                this->ss << nodePeek.nodePeekUnsignedValue()->getValue();
            } else {
                useParenthesesFlag = false;
                bool tempUseHexFlag = useHexFlag;
                useHexFlag = false;
                this->ss << "to_integer(";
                node.getRhs()->accept(*this);
                this->ss << ")";
                useHexFlag = tempUseHexFlag;
            }
            this->ss << ")";
        } else {
            if (tempUseParentheses) this->ss << "(";
            node.getLhs()->accept(*this);
            if (node.getOperation() == "&") {
                this->ss << " and ";
            } else if (node.getOperation() == "|") {
                this->ss << " or ";
            } else if (node.getOperation() == "^") {
                this->ss << " xor ";
            } else throw std::runtime_error("Should not get here");
            node.getRhs()->accept(*this);
            if (tempUseParentheses) this->ss << ")";
        }
    }
}

void VHDLPrintVisitor::visit(Assignment &node) {
    useParenthesesFlag = true;
    for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
    if (*(node.getLhs()) == *(node.getRhs())) this->ss << "--";
    node.getLhs()->accept(*this);
    this->ss << " <= ";
    useParenthesesFlag = false;
    node.getRhs()->accept(*this);
    this->ss << ";\n";
}

void VHDLPrintVisitor::visit(IntegerValue &node) {
    useParenthesesFlag = true;
    if (useHexFlag)
        this->ss << "x\"" << std::setfill ('0') << std::setw(8) << std::hex << node.getValue() << std::dec << "\"";
    else {
        this->ss << "to_signed(";
        this->ss << node.getValue();
        this->ss << ", 32)";
    }
}

void VHDLPrintVisitor::visit(UnsignedValue &node) {
    useParenthesesFlag = true;
    if (useHexFlag)
        this->ss << "x\"" << std::setfill ('0') << std::setw(8) << std::hex << node.getValue() << std::dec << "\"";
    else {
        this->ss << "to_unsigned(";
        this->ss << node.getValue();
        this->ss << ", 32)";
    }
}

void VHDLPrintVisitor::visit(UnaryExpr &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if ((node.getOperation() == "-") && (node.getDataType()->getName() == "unsigned")) {
        if (tempUseParentheses) this->ss << "(";
        this->ss << "not(";
        useParenthesesFlag = false;
        node.getExpr()->accept(*this);
        this->ss << ") + 1";
        if (tempUseParentheses) this->ss << ")";
    } else {
        this->ss << node.getOperation() << "(";
        useParenthesesFlag = false;
        node.getExpr()->accept(*this);
        this->ss << ")";
    }
}

void VHDLPrintVisitor::visit(Cast &node) {
    useParenthesesFlag = false;
    if (node.getDataType()->getName() == "unsigned") {
        NodePeekVisitor nodePeek(node.getSubExpr());
        if (nodePeek.nodePeekIntegerValue()) {
            node.getSubExpr()->accept(*this);
        } else {
            this->ss << "unsigned(";
            node.getSubExpr()->accept(*this);
            this->ss << ")";
        }
    } else if (node.getDataType()->getName() == "int") {
        NodePeekVisitor nodePeek(node.getSubExpr());
        if (nodePeek.nodePeekUnsignedValue()) {
            node.getSubExpr()->accept(*this);
        } else {
            this->ss << "signed(";
            node.getSubExpr()->accept(*this);
            this->ss << ")";
        }
    } else if (node.getDataType()->getName() == "bool") {
        this->ss << "boolean(";
        node.getSubExpr()->accept(*this);
        this->ss << ")";
    } else {
        this->ss << node.getDataType()->getName() << "(";
        node.getSubExpr()->accept(*this);
        this->ss << ")";
    }
    useParenthesesFlag = true;
}

void VHDLPrintVisitor::visit(CompoundExpr &node) {
    useParenthesesFlag = true;
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        NodePeekVisitor nodePeek(begin->second);
        if (nodePeek.nodePeekDataSignalOperand()) {
            // Print only parent, no need to enlist all the members (using record types)
            this->ss << nodePeek.nodePeekDataSignalOperand()->getDataSignal()->getParent()->getName();
            begin = --valueMap.end();
            break;
        } else {
            begin->second->accept(*this);
        }
        if(begin != --valueMap.end()) this->ss << ", ";
    }
}

void VHDLPrintVisitor::visit(FunctionOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getOperandName() << "(";
    auto paramMap = node.getParamValueMap();
    for (auto begin = paramMap.begin(); begin != paramMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --paramMap.end()) this->ss << ", ";
    }
    this->ss << ")";
}

void VHDLPrintVisitor::visit(Return &node) {
    useParenthesesFlag = true;
    this->ss << "return ";
    node.getReturnValue()->accept(*this);
}

void VHDLPrintVisitor::visit(ArrayOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getArrayVar()->getName();
    this->ss << "(to_integer(unsigned(";
    node.getIdx()->accept(*this);
    this->ss << ")))";
}
