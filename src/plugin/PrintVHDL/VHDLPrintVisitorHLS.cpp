//
// Created by johannes on 10.09.19.
//

#include <memory>
#include <iomanip>
#include <cmath>

#include "NodePeekVisitor.h"
#include "VHDLPrintVisitorHLS.h"
#include "BitSlicingVHDL.h"
#include "OtherUtils.h"

using namespace SCAM;

VHDLPrintVisitorHLS::VHDLPrintVisitorHLS(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    arithmeticOp = false;
    slice = false;
    this->createString(stmt, indentSize, indentOffset);
}

std::string VHDLPrintVisitorHLS::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    VHDLPrintVisitorHLS printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

std::string VHDLPrintVisitorHLS::getString() {
    return this->ss.str();
}

void VHDLPrintVisitorHLS::visit(SyncSignal &node) {
    this->ss << "(" << node.getPort()->getName() << "_sync = '1')";
}

void VHDLPrintVisitorHLS::visit(Bitwise &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;

    std::unique_ptr<VHDL::BitSlicingVHDL> printOperations = std::make_unique<VHDL::BitSlicingVHDL>(&node);
    if (printOperations->isSlicingOp()) {
        this->ss << printOperations->getOpAsString();
    } else {
        if ((node.getOperation() == VHDL::OtherUtils::subTypeBitwiseToString(VHDL::SubTypeBitwise::LEFT_SHIFT)) ||
            (node.getOperation() == VHDL::OtherUtils::subTypeBitwiseToString(VHDL::SubTypeBitwise::RIGHT_SHIFT))) {
            if (node.getOperation() == VHDL::OtherUtils::subTypeBitwiseToString(VHDL::SubTypeBitwise::LEFT_SHIFT))
                this->ss << "shift_left(";
            else if (node.getOperation() == VHDL::OtherUtils::subTypeBitwiseToString(VHDL::SubTypeBitwise::RIGHT_SHIFT))
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
                this->ss << "to_integer(";
                useParenthesesFlag = false;
                bool tempUseHexFlag = useHexFlag;
                useHexFlag = false;
                node.getRhs()->accept(*this);
                useHexFlag = tempUseHexFlag;
                this->ss << ")";
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

void VHDLPrintVisitorHLS::visit(ArrayOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(to_integer(unsigned(";
    node.getIdx()->accept(*this);
    this->ss << ")))";
}

void VHDLPrintVisitorHLS::visit(VariableOperand& node)
{
    bool isBoolean = node.getDataType()->isBoolean();
    if(isBoolean) {
        this->ss << "(";
    }
    if (arithmeticOp) {
        if (node.getDataType()->isInteger()) {
            this->ss << "signed(";
        } else if (node.getDataType()->isUnsigned()) {
            this->ss << "unsigned(";
        }
    }
    if (node.getVariable()->isSubVar()) {
        if (node.getVariable()->getParent()->isCompoundType()) {
            this->ss << node.getVariable()->getParent()->getName() << "." << node.getVariable()->getName();
        } else if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << node.getVariable()->getParent()->getName() << "(" << node.getVariable()->getName() << ")";
        } else throw std::runtime_error("Unknown Type for SubVar");
    } else {
        this->ss << node.getVariable()->getName();
    }
    if(arithmeticOp) {
        this->ss << ")";
    }
    if (isBoolean) {
        this->ss << " = '1')";
    }
}

void VHDLPrintVisitorHLS::visit(BoolValue &node) {
    if (node.getValue()) {
        this->ss << "\'1\'";
    } else {
        this->ss << "\'0\'";
    }
}

void VHDLPrintVisitorHLS::visit(DataSignalOperand &node) {
    bool isBoolean = node.getDataType()->isBoolean();
    if (isBoolean) {
        this->ss << "(";
    }
    if (arithmeticOp) {
        if (node.getDataType()->isInteger()) {
            this->ss << "signed(";
        } else if (node.getDataType()->isUnsigned()) {
            this->ss << "unsigned(";
        }
    }
    this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isCompoundType()) {
            this->ss << "." << node.getDataSignal()->getName();
        } else if (node.getDataSignal()->getParent()->isArrayType()) {
            this->ss << "(" << node.getDataSignal()->getName() << ")";
        } else throw std::runtime_error("Unknown Type for SubVar");
    }
    if(arithmeticOp) {
        this->ss << ")";
    }
    if (isBoolean) {
        this->ss << " = '1')";
    }
}

void VHDLPrintVisitorHLS::visit(Arithmetic &node) {
    bool subArithmeticOp = false;
    if (arithmeticOp) {
        subArithmeticOp = true;
    } else {
        arithmeticOp = true;
    }
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if (tempUseParentheses) this->ss << "(";
    if (node.getOperation() == "*") {
        NodePeekVisitor nodePeekLhs(node.getLhs());
        NodePeekVisitor nodePeekRhs(node.getRhs());
        if (nodePeekLhs.isConstTypeNode() || nodePeekRhs.isConstTypeNode()) {
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
            if (nodePeekLhs.nodePeekUnsignedValue() &&
                    VHDL::OtherUtils::isPowerOfTwo(nodePeekLhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << VHDL::OtherUtils::bitPosition(nodePeekLhs.nodePeekUnsignedValue()->getValue());
                this->ss << ")";
            } else if (nodePeekLhs.nodePeekIntegerValue() &&
                    (nodePeekLhs.nodePeekIntegerValue()->getValue() > 0) &&
                    VHDL::OtherUtils::isPowerOfTwo(nodePeekLhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << VHDL::OtherUtils::bitPosition(nodePeekLhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekUnsignedValue() &&
                    VHDL::OtherUtils::isPowerOfTwo(nodePeekRhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << VHDL::OtherUtils::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekIntegerValue() &&
                    (nodePeekRhs.nodePeekIntegerValue()->getValue() > 0) &&
                    VHDL::OtherUtils::isPowerOfTwo(nodePeekRhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << VHDL::OtherUtils::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
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
    if (!subArithmeticOp) {
        arithmeticOp = false;
    }
}

void VHDLPrintVisitorHLS::visit(Relational &node) {
    std::unique_ptr<VHDL::BitSlicingVHDL> sliceOp;
    if (NodePeekVisitor::nodePeekBitwise(node.getRhs())) {
        auto rhs = dynamic_cast<Bitwise *>(node.getRhs());
        sliceOp = std::make_unique<VHDL::BitSlicingVHDL>(rhs);
        if (sliceOp->isSlicingOp()) {
            slice = true;
        }
    } else if (NodePeekVisitor::nodePeekBitwise(node.getLhs())) {
        auto lhs = dynamic_cast<Bitwise *>(node.getLhs());
        sliceOp = std::make_unique<VHDL::BitSlicingVHDL>(lhs);
        if (sliceOp->isSlicingOp()) {
            slice = true;
        }
    }
    if (slice) {
        firstBit = sliceOp->getFirstBit();
        lastBit = sliceOp->getLastBit();
    }
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
    slice = false;
}

void VHDLPrintVisitorHLS::visit(IntegerValue &node) {
    useParenthesesFlag = true;
    if (slice) {
        printBinaryVector(node.getValue());
    } else if (useHexFlag)
        this->ss << "x\"" << std::setfill ('0') << std::setw(8) << std::hex << node.getValue() << std::dec << "\"";
    else {
        this->ss << "to_signed(";
        this->ss << node.getValue();
        this->ss << ", 32)";
    }
}

void VHDLPrintVisitorHLS::visit(UnsignedValue &node) {
    useParenthesesFlag = true;
    if (slice) {
        printBinaryVector(node.getValue());
    } else if (useHexFlag)
        this->ss << "x\"" << std::setfill ('0') << std::setw(8) << std::hex << node.getValue() << std::dec << "\"";
    else {
        this->ss << "to_unsigned(";
        this->ss << node.getValue();
        this->ss << ", 32)";
    }
}

void VHDLPrintVisitorHLS::printBinaryVector(const unsigned int &value) {
    unsigned int tmpLastBit = lastBit;
    this->ss << "\"";
    while (tmpLastBit >= firstBit) {
        if (static_cast<unsigned int>(pow(2, tmpLastBit)) & value) {
            this->ss << "1";
        } else {
            this->ss << "0";
        }
        if (tmpLastBit == 0) {
            break;
        } else {
            tmpLastBit--;
        }
    }
    this->ss << "\"";
}
