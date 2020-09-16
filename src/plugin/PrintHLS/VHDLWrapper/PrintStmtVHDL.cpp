//
// Created by Deutschmann on 09.09.20.
//

#include <iomanip>
#include <PrintHLS/Common/OptimizerHLS.h>
#include "PrintStmtVHDL.h"
#include "FatalError.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

PrintStmtVHDL::PrintStmtVHDL(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintStmtVHDL::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintStmtVHDL printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

void PrintStmtVHDL::visit(DESCAM::Arithmetic &node) {
    // TODO: Consider replacing multiplication by a power of two with shifting

    // Temporary variable for nested arithmetic operations
    bool subArithmeticOperation = arithmeticOperation;
    arithmeticOperation = true;

    ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "%") {
        ss << " rem ";
    } else {
        ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    ss << ")";

    arithmeticOperation = arithmeticOperation && subArithmeticOperation;
}

void PrintStmtVHDL::visit(DESCAM::ArrayOperand &node) {

    ss << node.getArrayOperand()->getOperandName();
    ss << "(to_integer(unsigned(";
    node.getIdx()->accept(*this);
    ss << ")))";
}

void PrintStmtVHDL::visit(DESCAM::Assignment &node) {
    node.getLhs()->accept(*this);
    ss << " <= ";
    node.getRhs()->accept(*this);
}

void PrintStmtVHDL::visit(DESCAM::Bitwise &node) {

    //TODO: Fix slicing

    // Check if bitwise operation can be expressed as a slicing expression
    /*const auto slicedOperation = DESCAM::HLSPlugin::OptimizerHLS::sliceBitwise(node);
    if (!slicedOperation.empty()) {
        ss << slicedOperation;
    } else */if (node.getOperation() == "<<" || node.getOperation() == ">>") {
        ss << "std_logic_vector(";
        ss << ((node.getOperation() == "<<") ? "shift_left(" : "shift_right(");
        arithmeticOperation = true;
        node.getLhs()->accept(*this);
        arithmeticOperation = false;
        ss << ", ";
        asNumber = true;
        node.getRhs()->accept(*this);
        asNumber = false;
        ss << "))";
    } else {
        ss << "(";
        node.getLhs()->accept(*this);
        if (node.getOperation() == "&") {
            ss << " and ";
        } else if (node.getOperation() == "|") {
            ss << " or ";
        } else if (node.getOperation() == "^") {
            ss << " xor ";
        } else {
            throw std::runtime_error("Unknown bitwise operator in PrintStmtVHDL::visit(DESCAM::Bitwise &node)");
        }
        node.getRhs()->accept(*this);
        ss << ")";
    }
}

void PrintStmtVHDL::visit(DESCAM::BoolValue &node) {
    ss << "\'" << node.getValue() << "\'";
}

void PrintStmtVHDL::visit(DESCAM::Cast &node) {

    if ((node.getDataType()->isUnsigned() && NodePeekVisitor::nodePeekIntegerValue(node.getSubExpr()))
        || (node.getDataType()->isInteger() && NodePeekVisitor::nodePeekUnsignedValue(node.getSubExpr()))) {
        node.getSubExpr()->accept(*this);
    } else {
        if (node.getDataType()->isUnsigned()) {
            ss << "unsigned";
        } else if (node.getDataType()->isInteger()) {
            ss << "signed";
        } else if (node.getDataType()->isBoolean()) {
            ss << "boolean";
        }
        ss << "(";
        node.getSubExpr()->accept(*this);
        ss << ")";
    }
}

//void PrintStmtVHDL::visit(DESCAM::CompoundExpr &node) {
//TODO
//}

void PrintStmtVHDL::visit(DESCAM::DataSignalOperand &node) {

    if (arithmeticOperation && node.getDataType()->isInteger()) {
        ss << "signed(";
    } else if (arithmeticOperation && node.getDataType()->isUnsigned()) {
        ss << "unsigned(";
    }

    ss << node.getDataSignal()->getPort()->getName() << "_sig";

    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isCompoundType()) {
            ss << "." << node.getDataSignal()->getName();
        } else if (node.getDataSignal()->getParent()->isArrayType()) {
            ss << "(" << node.getDataSignal()->getName() << ")";
        } else {
            throw std::runtime_error(
                    "Unknown type for SubVar in PrintStmtVHDL::visit(DESCAM::DataSignalOperand &node)");
        }
    }

    if (arithmeticOperation) {
        ss << ")";
    }
}

void PrintStmtVHDL::visit(DESCAM::FunctionOperand &node) {

    ss << node.getOperandName() << "(";
    for (auto parameter = node.getParamValueMap().begin(); parameter != node.getParamValueMap().end(); parameter++) {
        parameter->second->accept(*this);
        if (std::next(parameter) != node.getParamValueMap().end()) {
            ss << ", ";
        }
    }
    ss << ")";
}

void PrintStmtVHDL::visit(DESCAM::IntegerValue &node) {
    //TODO: Slicing
    if (asNumber) {
        ss << node.getValue();
    } else {
        ss << "x\"" << std::setfill ('0') << std::setw(8) << std::hex << node.getValue() << std::dec << "\"";
    }
}

void PrintStmtVHDL::visit(DESCAM::Notify &node) {
    ss << node.getPort()->getName() << "_notify";
}

void PrintStmtVHDL::visit(DESCAM::ParamOperand &node) {

    if (arithmeticOperation && node.getDataType()->isInteger()) {
        ss << "signed(";
    } else if (arithmeticOperation && node.getDataType()->isUnsigned()) {
        ss << "unsigned(";
    }

    ss << node.getOperandName();

    if (arithmeticOperation) {
        ss << ")";
    }
}

void PrintStmtVHDL::visit(DESCAM::Relational &node) {

    if (!((node.getOperation() == "!=") && node.getDataType()->isBoolean())) {
        ss << "bool_to_sl";
    }

    ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "==") {
        ss << " = ";
    } else if (node.getOperation() == "!=") {
        ss << (node.getDataType()->isBoolean() ? " xor " : " /= ");
    } else {
        ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    ss << ")";
}

void PrintStmtVHDL::visit(DESCAM::Return &node) {
    ss << "return ";
    node.getReturnValue()->accept(*this);
}

void PrintStmtVHDL::visit(DESCAM::SyncSignal &node) {
    ss << node.getPort()->getName() << "_sync";
}

void PrintStmtVHDL::visit(DESCAM::UnaryExpr &node) {
    if (node.getOperation() == "~") {
        ss << "not";
    } else {
        ss << node.getOperation();
    }
    ss << "(";
    node.getExpr()->accept(*this);
    ss << ")";
}

void PrintStmtVHDL::visit(DESCAM::UnsignedValue &node) {
    //TODO: Slicing
    if (asNumber) {
        ss << node.getValue();
    } else {
        ss << "x\"" << std::setfill ('0') << std::setw(8) << std::hex << node.getValue() << std::dec << "\"";
    }
}

void PrintStmtVHDL::visit(DESCAM::VariableOperand &node) {

    if (arithmeticOperation && node.getDataType()->isInteger()) {
        ss << "signed(";
    } else if (arithmeticOperation && node.getDataType()->isUnsigned()) {
        ss << "unsigned(";
    }

    if (node.getVariable()->isSubVar()) {
        ss << node.getVariable()->getParent()->getName();
        if (node.getVariable()->getParent()->isCompoundType()) {
            ss << "." << node.getVariable()->getName();
        } else if (node.getVariable()->getParent()->isArrayType()) {
            ss << "(" << node.getVariable()->getName() << ")";
        } else {
            throw std::runtime_error("Unknown type for SubVar in PrintStmtVHDL::visit(DESCAM::VariableOperand &node)");
        }
    } else {
        ss << node.getVariable()->getName();
    }

   if (arithmeticOperation) {
        ss << ")";
    }
}

std::string PrintStmtVHDL::getString() {
    return ss.str();
}