//
// Created by johannes on 31.03.19.
//

#include <memory>
#include <iomanip>
#include <cmath>
#include "FatalError.h"
#include "Logger/Logger.h"
#include "NodePeekVisitor.h"
#include "PrintFunction.h"
#include "PrintBitOperations.h"
#include "Utilities.h"

using namespace SCAM::HLSPlugin::VHDLWrapper;

PrintFunction::PrintFunction(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintFunction::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintFunction printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

std::string PrintFunction::getString() {
    return this->ss.str();
}

void PrintFunction::visit(Assignment &node) {
    useParenthesesFlag = true;
    for (int i = 0; i < indent; ++i) {
        this->ss << " ";
    } //add indent
    if (*(node.getLhs()) == *(node.getRhs())) this->ss << "--";
    node.getLhs()->accept(*this);
    this->ss << " <= ";
    useParenthesesFlag = false;
    node.getRhs()->accept(*this);
    this->ss << ";\n";
}

void PrintFunction::visit(Bitwise &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;

    std::unique_ptr<PrintBitOperations> printOperations = std::make_unique<PrintBitOperations>(&node);
    if (printOperations->isSlicingOp()) {
        this->ss << printOperations->getOpAsString();
    } else {
        if ((node.getOperation() == Utilities::subTypeBitwiseToString(SubTypeBitwise::LEFT_SHIFT)) ||
                (node.getOperation() == Utilities::subTypeBitwiseToString(SubTypeBitwise::RIGHT_SHIFT))) {
            if (node.getOperation() == Utilities::subTypeBitwiseToString(SubTypeBitwise::LEFT_SHIFT))
                this->ss << "shift_left(";
            else if (node.getOperation() == Utilities::subTypeBitwiseToString(SubTypeBitwise::RIGHT_SHIFT))
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
            } else TERMINATE("Should not get here");
            node.getRhs()->accept(*this);
            if (tempUseParentheses) this->ss << ")";
        }
    }
}

void PrintFunction::visit(ArrayOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(to_integer(unsigned(";
    node.getIdx()->accept(*this);
    this->ss << ")))";
}

void PrintFunction::visit(Cast &node) {
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

void PrintFunction::visit(CompoundExpr &node) {
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

void PrintFunction::visit(FunctionOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getOperandName() << "(";
    auto paramMap = node.getParamValueMap();
    for (auto parameter = paramMap.begin(); parameter != paramMap.end(); ++parameter) {
        parameter->second->accept(*this);
        if (std::next(parameter) != paramMap.end()) {
            this->ss << ", ";
        }
    }
    this->ss << ")";
}

void PrintFunction::visit(VariableOperand& node)
{
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
        } else TERMINATE("Unknown Type for SubVar");
    } else {
        this->ss << node.getVariable()->getName();
    }
    if(arithmeticOp) {
        this->ss << ")";
    }
}

void PrintFunction::visit(BoolValue &node) {
    if (node.getValue()) {
        this->ss << "\'1\'";
    } else {
        this->ss << "\'0\'";
    }
}

void PrintFunction::visit(DataSignalOperand &node) {
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
        } else TERMINATE("Unknown Type for SubVar");
    }
    if(arithmeticOp) {
        this->ss << ")";
    }
}

void PrintFunction::visit(Arithmetic &node) {
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
                    Utilities::isPowerOfTwo(nodePeekLhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << Utilities::bitPosition(nodePeekLhs.nodePeekUnsignedValue()->getValue());
                this->ss << ")";
            } else if (nodePeekLhs.nodePeekIntegerValue() &&
                    (nodePeekLhs.nodePeekIntegerValue()->getValue() > 0) &&
                    Utilities::isPowerOfTwo(nodePeekLhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << Utilities::bitPosition(nodePeekLhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekUnsignedValue() &&
                    Utilities::isPowerOfTwo(nodePeekRhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << Utilities::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekIntegerValue() &&
                    (nodePeekRhs.nodePeekIntegerValue()->getValue() > 0) &&
                    Utilities::isPowerOfTwo(nodePeekRhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << Utilities::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
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

void PrintFunction::visit(Relational &node) {
    std::unique_ptr<PrintBitOperations> sliceOp;
    if (NodePeekVisitor::nodePeekBitwise(node.getRhs())) {
        auto rhs = dynamic_cast<Bitwise *>(node.getRhs());
        sliceOp = std::make_unique<PrintBitOperations>(rhs);
        if (sliceOp->isSlicingOp()) {
            slice = true;
        }
    } else if (NodePeekVisitor::nodePeekBitwise(node.getLhs())) {
        auto lhs = dynamic_cast<Bitwise *>(node.getLhs());
        sliceOp = std::make_unique<PrintBitOperations>(lhs);
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

void PrintFunction::visit(Return &node) {
    useParenthesesFlag = true;
    this->ss << "return ";
    node.getReturnValue()->accept(*this);
}

void PrintFunction::visit(IntegerValue &node) {
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

void PrintFunction::visit(UnsignedValue &node) {
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

void PrintFunction::visit(UnaryExpr &node) {
    if(node.getOperation() == "~") {
        this->ss << "not(";
    } else {
        this->ss << node.getOperation() << "(";
    }
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void PrintFunction::visit(SCAM::SyncSignal& node)
{
    this->ss << node.getPort()->getName() << "_sync";
}

void PrintFunction::visit(SCAM::ParamOperand& node)
{
    if (arithmeticOp) {
        if (node.getDataType()->isInteger()) {
            this->ss << "signed(";
        } else if (node.getDataType()->isUnsigned()) {
            this->ss << "unsigned(";
        }
    }
    this->ss << node.getOperandName();
    if(arithmeticOp) {
        this->ss << ")";
    }
}

void PrintFunction::printBinaryVector(const unsigned int &value) {
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
