//
// Created by johannes on 28.07.19.
//

#include "NodePeekVisitor.h"
#include "PrintFunction.h"
#include "PrintBitOperations.h"
#include "Utilities.h"

using namespace SCAM::HLSPlugin::HLS;

PrintFunction::PrintFunction(
        Stmt *stmt,
        unsigned int indentSize,
        unsigned int indentOffset
) {
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
    printIndent();
    node.getLhs()->accept(*this);
    this->ss << " = ";
    node.getRhs()->accept(*this);
    this->ss << ";\n";
}

void PrintFunction::visit(VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName();
        if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << "[" << node.getVariable()->getName() << "]";
        } else {
            this->ss << "_" << node.getVariable()->getName();
        }
    } else {
        this->ss << node.getVariable()->getName() ;
    }
}

void PrintFunction::visit(UnaryExpr &node) {
    this->ss << "(";
    if (node.getOperation() == "not") {
        this->ss << "!(";
    }
    else {
        this->ss << node.getOperation() << "(";
    }
    node.getExpr()->accept(*this);
    this->ss << "))";
}

void PrintFunction::visit(CompoundExpr &node) {
    for (auto value = node.getValueMap().begin(); value != node.getValueMap().end(); ++value) {
        NodePeekVisitor nodePeekVisitor(value->second);
        if (nodePeekVisitor.nodePeekDataSignalOperand()) {
            this->ss << nodePeekVisitor.nodePeekDataSignalOperand()->getDataSignal()->getParent()->getName();
            value = --node.getValueMap().end();
            break;
        } else {
            value->second->accept(*this);
        }
        if (std::next(value) != node.getValueMap().end()) {
            this->ss << ", ";
        }
    }
}

void PrintFunction::visit(Cast &node) {
    this->ss << Utilities::convertDataType(node.getDataType()->getName()) << "(";
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void PrintFunction::visit(Return &node) {
    printIndent();
    this->ss << "return(";
    node.getReturnValue()->accept(*this);
    this->ss << ")";
}

void PrintFunction::visit(ParamOperand &node) {
    if (node.getParameter()->isSubVar()) {
        this->ss << node.getParameter()->getParent()->getName() << "_" << node.getParameter()->getName();
    }
    else {
        this->ss << node.getOperandName();
    }
}

void PrintFunction::visit(Logical &node) {
    node.getLhs()->accept(*this);
    if (node.getOperation() == "or") {
        this->ss << " || ";
    } else if(node.getOperation() == "and") {
        this->ss << " && ";
    }
    node.getRhs()->accept(*this);
}

void PrintFunction::visit(FunctionOperand &node) {
    this->ss << node.getOperandName() << "(";
    auto functionParameters = node.getFunction()->getParamMap();
    for (auto parameter = node.getParamValueMap().begin(); parameter != node.getParamValueMap().end(); ++parameter) {
        parameter->second->accept(*this);
        if (std::next(parameter) != node.getParamValueMap().end()) {
            this->ss << ", ";
        }
    }
    this->ss << ")";
}

void PrintFunction::visit(ArrayOperand &node) {
    node.getArrayOperand()->accept(*this);
    this->ss << "[";
    node.getIdx()->accept(*this);
    this->ss << "]";
}

void PrintFunction::visit(Bitwise &node) {
    std::shared_ptr<OptimizerHLS> optimizerNullPtr;
    auto bitConcatenation = std::make_unique<BitConcatenation>(&node, HLSOption::MCO, optimizerNullPtr);
    if (bitConcatenation->isBitConcatenationOp()) {
        this->ss << bitConcatenation->getOpAsString();
    } else {
        auto bitSlicing = std::make_unique<PrintBitOperations>(&node, HLSOption::MCO, optimizerNullPtr);
        if (bitSlicing->isSlicingOp()) {
            this->ss << bitSlicing->getOpAsString();
        } else {
            if ((node.getOperation() == "<<") || (node.getOperation() == ">>")) {
                this->ss << "(";
                if (!NodePeekVisitor::nodePeekCast(node.getLhs())) {
                    this->ss << "static_cast<" << node.getDataType()->getName() <<  ">(";
                }
                node.getLhs()->accept(*this);
                if (!NodePeekVisitor::nodePeekCast(node.getLhs())) {
                    this->ss << ")";
                }
                this->ss << " " + node.getOperation() << " ";
                if (!NodePeekVisitor::nodePeekCast(node.getLhs())) {
                    this->ss << "static_cast<" << node.getDataType()->getName() <<  ">(";
                }
                node.getRhs()->accept(*this);
                if (!NodePeekVisitor::nodePeekCast(node.getLhs())) {
                    this->ss << ")";
                }
                this->ss << ")";
            } else {
                this->ss << "(";
                node.getLhs()->accept(*this);
                this->ss << " " << node.getOperation() << " ";
                node.getRhs()->accept(*this);
                this->ss << ")";
            }
        }
    }
}

void PrintFunction::printIndent() {
    for (std::size_t i = 0; i < indent; ++i) {
        this->ss << "\t";
    }
}

void PrintFunction::visit(Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
}
