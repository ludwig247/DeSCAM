//
// Created by johannes on 28.07.19.
//

#include "PrintFunctionStatements.h"
#include "NodePeekVisitor.h"

using namespace SCAM;

PrintFunctionStatements::PrintFunctionStatements(Stmt *stmt, OptimizeForHLS *opt, unsigned int indentSize, unsigned int indentOffset) {
    side = Side::UNKNOWN;
    this->opt = opt;
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintFunctionStatements::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintFunctionStatements printer(stmt, nullptr, indentSize, indentOffset);
    return printer.getString();
}

std::string PrintFunctionStatements::toString(Stmt *stmt, OptimizeForHLS *opt, unsigned int indentSize, unsigned int indentOffset) {
    PrintFunctionStatements printer(stmt, opt, indentSize, indentOffset);
    return printer.getString();
}

std::string PrintFunctionStatements::getString() {
    return this->ss.str();
}

void PrintFunctionStatements::visit(Assignment &node) {
    printIndent();
    side = Side::LHS;
    node.getLhs()->accept(*this);
    this->ss << " = ";
    side = Side::RHS;
    node.getRhs()->accept(*this);
    this->ss << ";\n";
}

void PrintFunctionStatements::visit(VariableOperand &node) {
    if (opt) {
        if(side == Side::LHS) {
            this->ss << "out_";
        } else if (side == Side::RHS) {
            this->ss << "in_";
        }
    }
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName();
        if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << "[" << node.getVariable()->getName() << "]";
        } else {
            this->ss << "." << node.getVariable()->getName();
        }
    } else {
        this->ss << node.getVariable()->getName();
    }
}

void PrintFunctionStatements::visit(DataSignalOperand &node) {
    if (node.getDataSignal()->isSubVar()) {
        this->ss << node.getDataSignal()->getParent()->getName();
        if (node.getDataSignal()->getParent()->isArrayType()) {
            this->ss << "[" << node.getDataSignal()->getName() << "]";
        } else {
            this->ss << "." << node.getDataSignal()->getName();
        }
    } else {
        this->ss << node.getDataSignal()->getName();
    }
}

void PrintFunctionStatements::visit(SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
}

void PrintFunctionStatements::visit(UnaryExpr &node) {
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

void PrintFunctionStatements::visit(CompoundExpr &node) {
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

void PrintFunctionStatements::visit(Cast &node) {
//    this->ss << "static_cast<" << node.getDataType()->getName() << ">(";
    this->ss << Utilities::convertDataType(node.getDataType()->getName()) << "(";
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void PrintFunctionStatements::visit(ITE &node) {
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
        std::string statementString = PrintFunctionStatements::toString(stmt, indentSize, indent);
        this->ss << statementString;
        if (statementString.find('\n') == std::string::npos)
            this->ss << ";";
        this->ss << std::endl;
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
            std::string statementString = PrintFunctionStatements::toString(stmt, indentSize, indent);
            this->ss << statementString;
            if (statementString.find('\n') == std::string::npos)
                this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (std::size_t i = 0; i < indent; ++i) {
            this->ss << " ";    //add indent
        }
        this->ss << "}";
    }
}

void PrintFunctionStatements::visit(Return &node) {
    printIndent();
    this->ss << "return(";
    node.getReturnValue()->accept(*this);
    this->ss << ")";
}

void PrintFunctionStatements::visit(ParamOperand &node) {
    if (node.getParameter()->isSubVar()) {
        this->ss << node.getParameter()->getParent()->getName() << "."
            << node.getParameter()->getName();
    }
    else {
        this->ss << node.getOperandName();
    }
}

void PrintFunctionStatements::visit(Logical &node) {
    node.getLhs()->accept(*this);
    if (node.getOperation() == "or") {
        this->ss << " || ";
    } else if(node.getOperation() == "and") {
        this->ss << " && ";
    }
    node.getRhs()->accept(*this);
}

void PrintFunctionStatements::visit(FunctionOperand &node) {
    this->ss << node.getOperandName() << "(";
    for (auto parameter = node.getParamValueMap().begin(); parameter != node.getParamValueMap().end(); ++parameter) {
        parameter->second->accept(*this);
        if (std::next(parameter) != node.getParamValueMap().end()) {
            this->ss << ", ";
        }
    }
    this->ss << ")";
}

void PrintFunctionStatements::visit(ArrayOperand &node) {
    if (opt) {
        const auto arrayPorts = opt->getArrayPorts();
        for (const auto &arrayPort : arrayPorts) {
            if (arrayPort.first->getDataSignal()->getName() == node.getArrayOperand()->getOperandName()) {
                uint32_t pos = 0;
                for (const auto &expr : arrayPort.second) {
                    if (*expr == *node.getIdx()) {
                        this->ss << arrayPort.first->getDataSignal()->getName() << "_" << pos;
                        break;
                    }
                    pos++;
                }
            }
        }
    } else {
        this->ss << node.getArrayOperand()->getOperandName();
        this->ss << "[";
        node.getIdx()->accept(*this);
        this->ss << "]";
    }
}

void PrintFunctionStatements::visit(Bitwise &node) {
    bool bitConcatenation = isBitConcatenationOp(&node);
    if (bitConcatenation) {
        auto bitSlicingOps = getBitConcatenationOp(&node);
        for (auto&& bitSlicingOp : bitSlicingOps) {
            std::cout << bitSlicingOp->getOpAsString() << "\t";
        }
        std::cout << std::endl;
    } else {
        auto bitSlicing = std::make_unique<BitSlicingHLS>(&node);
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

bool PrintFunctionStatements::isBitConcatenationOp(Bitwise* node) {
    if (Utilities::getSubTypeBitwise(node->getOperation()) != SubTypeBitwise::BITWISE_OR) {
        return false;
    }

    bool bitConcatenation = true;
    uint32_t constValue = 0;
    if (NodePeekVisitor::nodePeekBitwise(node->getRhs())) {
        auto bitSlicingRHS = std::make_unique<BitSlicingHLS>(node->getRhs());
        if (!bitSlicingRHS->isSlicingOp()) {
            bitConcatenation = isBitConcatenationOp(dynamic_cast<Bitwise* >(node->getRhs()));
        }
    } else {
        if (!isConsValue(node->getRhs())) {
            return false;
        } else {
            constValue |= getConstValue(node->getRhs());
        }
    }
    if (NodePeekVisitor::nodePeekBitwise(node->getLhs())) {
        auto bitSlicingLHS = std::make_unique<BitSlicingHLS>(node->getLhs());
        if (!bitSlicingLHS->isSlicingOp()) {
            bitConcatenation &= isBitConcatenationOp(dynamic_cast<Bitwise* >(node->getLhs()));
        }
    } else if (!isConsValue(node->getLhs())) {
        if (!isConsValue(node->getLhs())) {
            return false;
        } else {
            constValue |= getConstValue(node->getLhs());
        }
    }

    std::cout << "Const Value: " << constValue << std::endl;

    return bitConcatenation;
}

bool PrintFunctionStatements::isConsValue(Expr *node) {
    if (NodePeekVisitor::nodePeekIntegerValue(node)) {
        return true;
    }
    if (NodePeekVisitor::nodePeekUnsignedValue(node)) {
        return true;
    }
    if (NodePeekVisitor::nodePeekCast(node)) {
        auto castNode = dynamic_cast<Cast* >(node);
        return isConsValue(castNode->getSubExpr());
    }
    return false;
}

uint32_t PrintFunctionStatements::getConstValue(Expr *node) {
    if (NodePeekVisitor::nodePeekIntegerValue(node)) {
        return (dynamic_cast<IntegerValue* >(node)->getValue());
    }
    if (NodePeekVisitor::nodePeekUnsignedValue(node)) {
        return (dynamic_cast<UnsignedValue* >(node)->getValue());
    }
    auto castNode = dynamic_cast<Cast* >(node);
    return isConsValue(castNode->getSubExpr());
}

std::vector<std::unique_ptr<BitSlicingHLS>> PrintFunctionStatements::getBitConcatenationOp(Bitwise* node) {
    std::vector<std::unique_ptr<BitSlicingHLS>> bitSlicingOps;

    if (NodePeekVisitor::nodePeekBitwise(node->getRhs())) {
        auto bitSlicingRHS = std::make_unique<BitSlicingHLS>(node->getRhs());
        if (!bitSlicingRHS->isSlicingOp()) {
            auto ops = getBitConcatenationOp(dynamic_cast<Bitwise * >(node->getRhs()));
            for (auto &&op : ops) {
                bitSlicingOps.emplace_back(std::move(op));
            }
        } else {
            bitSlicingOps.emplace_back(std::move(bitSlicingRHS));
        }
    }
    if (NodePeekVisitor::nodePeekBitwise(node->getLhs())) {
        auto bitSlicingLHS = std::make_unique<BitSlicingHLS>(node->getLhs());
        if (!bitSlicingLHS->isSlicingOp()) {
            auto ops = getBitConcatenationOp(dynamic_cast<Bitwise* >(node->getLhs()));
            for (auto&& op : ops) {
                bitSlicingOps.emplace_back(std::move(op));
            }
        } else {
            bitSlicingOps.emplace_back(std::move(bitSlicingLHS));
        }
    }

    return bitSlicingOps;
}

void PrintFunctionStatements::printIndent() {
    for (std::size_t i = 0; i < indent; ++i) {
        this->ss << "\t";
    }
}
