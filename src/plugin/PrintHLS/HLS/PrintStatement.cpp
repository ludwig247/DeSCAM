//
// Created by johannes on 28.07.19.
//

#include "PrintStatement.h"
#include "NodePeekVisitor.h"

using namespace SCAM::HLSPlugin::HLS;

PrintStatement::PrintStatement(
        Stmt *stmt,
        std::shared_ptr<OptimizerHLS>& opt,
        HLSOption hlsOption,
        unsigned int indentSize,
        unsigned int indentOffset
) {
    this->side = Side::UNKNOWN;
    this->optimizer = opt;
    this->hlsOption = hlsOption;
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintStatement::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    std::shared_ptr<OptimizerHLS> optimizerNullPtr;
    PrintStatement printer(stmt, optimizerNullPtr, HLSOption::MCCO, indentSize, indentOffset);
    return printer.getString();
}

std::string PrintStatement::toString(Stmt *stmt, std::shared_ptr<OptimizerHLS>& optimizer, HLSOption hlsOption, unsigned int indentSize, unsigned int indentOffset) {
    PrintStatement printer(stmt, optimizer, hlsOption, indentSize, indentOffset);
    return printer.getString();
}

std::string PrintStatement::getString() {
    return this->ss.str();
}

void PrintStatement::visit(Assignment &node) {
    if (*node.getLhs() == *node.getRhs()) {
        return;
    }
    printIndent();
    side = Side::LHS;
    node.getLhs()->accept(*this);
    this->ss << " = ";
    side = Side::RHS;
    node.getRhs()->accept(*this);
    this->ss << ";\n";
}

void PrintStatement::visit(VariableOperand &node) {
    bool isConstant = false;
    if (optimizer) {
        isConstant = optimizer->isConstant(node.getVariable());
    }

    std::string suffix;
    if (!isConstant && hlsOption == HLSOption::OCCO) {
         suffix = (side == Side::LHS ? "_reg" : "_tmp");
    }

    if (!isConstant && hlsOption == HLSOption::MCCO) {
        if (optimizer) {
            if(side == Side::LHS) {
                this->ss << "out_";
            } else if (side == Side::RHS) {
                this->ss << "in_";
            }
        }
    }

    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() << suffix;
        if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << "[" << node.getVariable()->getName() << "]";
        } else {
            this->ss << "." << node.getVariable()->getName();
        }
    } else {
        this->ss << node.getVariable()->getName() << suffix;
    }
}

void PrintStatement::visit(DataSignalOperand &node) {
    std::string suffix;
    if (hlsOption == HLSOption::OCCO) {
        if (node.getDataSignal()->getPort()->getInterface()->getDirection() == "out") {
            suffix = "_reg";
        }
    }

    if (node.getDataSignal()->isSubVar()) {
        this->ss << node.getDataSignal()->getParent()->getName() << suffix;
        if (node.getDataSignal()->getParent()->isArrayType()) {
            if (optimizer) {
                const auto arrayPorts = optimizer->getArrayPorts();
                for (const auto &arrayPort : arrayPorts) {
                    if (arrayPort.first->getDataSignal()->getName() == node.getDataSignal()->getParent()->getName()) {
                        uint32_t pos = 0;
                        for (const auto &expr : arrayPort.second) {
                            if (NodePeekVisitor::nodePeekDataSignalOperand(expr)) {
                                if (dynamic_cast<DataSignalOperand* >(expr) == &node) {
                                    this->ss << "_" << pos;
                                    return;
                                }
                            }
                            pos++;
                        }
                    }
                }
            }
        } else {
            this->ss << "." << node.getDataSignal()->getName();
        }
    } else {
        this->ss << node.getDataSignal()->getName() << suffix;
    }
}

void PrintStatement::visit(SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
}

void PrintStatement::visit(UnaryExpr &node) {
    useParenthesesFlag = true;
    this->ss << "(";
    if (node.getOperation() == "not") {
        this->ss << "!(";
        node.getExpr()->accept(*this);
        this->ss << ")";
    }
    else {
        this->ss << node.getOperation() << "(";
        node.getExpr()->accept(*this);
        this->ss << ")";
    }
    this->ss << ")";
}

void PrintStatement::visit(CompoundExpr &node) {
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

void PrintStatement::visit(Cast &node) {
    this->ss << Utilities::convertDataType(node.getDataType()->getName()) << "(";
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void PrintStatement::visit(ITE &node) {
    for (std::size_t i = 0; i < indent; i++) {
        this->ss << " ";
    }
    this->ss << "if (";
    node.getConditionStmt()->accept(*this);
    this->ss << ") {" << std::endl;
    indent += indentSize;
    for (auto stmt: node.getIfList()) {
        for (std::size_t i = 0; i < indent; ++i) {
            this->ss << " ";    //add indent
        }
        stmt->accept(*this);
        this->ss << ";\n";
    }
    indent -= indentSize;
    for (std::size_t i = 0; i < indent; ++i) {
        this->ss << " "; //add indent
    }
    this->ss << "}";
    if (!node.getElseList().empty()) {
        this->ss << " else {" << std::endl;
        indent += indentSize;
        for (auto stmt: node.getElseList()) {
            for (std::size_t i = 0; i < indent; ++i) {
                this->ss << " ";    //add indent
            }
            if (NodePeekVisitor::nodePeekITE(stmt) != nullptr)
                indent -= indentSize;
            stmt->accept(*this);
            this->ss << ";\n";
        }
        indent -= indentSize;
        for (std::size_t i = 0; i < indent; ++i) {
            this->ss << " ";    //add indent
        }
        this->ss << "}";
    }
}

void PrintStatement::visit(Return &node) {
    printIndent();
    this->ss << "return(";
    node.getReturnValue()->accept(*this);
    this->ss << ")";
}

void PrintStatement::visit(ParamOperand &node) {
    if (node.getParameter()->isSubVar()) {
        this->ss << node.getParameter()->getParent()->getName() << "."
            << node.getParameter()->getName();
    }
    else {
        this->ss << node.getOperandName();
    }
}

void PrintStatement::visit(Logical &node) {
    node.getLhs()->accept(*this);
    if (node.getOperation() == "or") {
        this->ss << " || ";
    } else if(node.getOperation() == "and") {
        this->ss << " && ";
    }
    node.getRhs()->accept(*this);
}

void PrintStatement::visit(FunctionOperand &node) {
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

void PrintStatement::visit(ArrayOperand &node) {
    if (optimizer) {
        const auto arrayPorts = optimizer->getArrayPorts();
        for (const auto &arrayPort : arrayPorts) {
            if (arrayPort.first->getDataSignal()->getName() == node.getArrayOperand()->getOperandName()) {
                uint32_t pos = 0;
                for (const auto &expr : arrayPort.second) {
                    if (*expr == *node.getIdx()) {
                        this->ss << arrayPort.first->getDataSignal()->getName() << "_" << pos;
                        return;
                    }
                    pos++;
                }
            }
        }
    }

    node.getArrayOperand()->accept(*this);
    this->ss << "[";
    node.getIdx()->accept(*this);
    this->ss << "]";
}

void PrintStatement::visit(Bitwise &node) {
    auto bitConcatenation = std::make_unique<BitConcatenation>(&node, hlsOption, optimizer);
    if (bitConcatenation->isBitConcatenationOp()) {
        this->ss << bitConcatenation->getOpAsString();
    } else {
        auto bitSlicing = std::make_unique<PrintBitOperations>(&node, hlsOption, optimizer);
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

void PrintStatement::printIndent() {
    for (std::size_t i = 0; i < indent; ++i) {
        this->ss << "\t";
    }
}
