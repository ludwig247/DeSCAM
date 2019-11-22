//
// Created by johannes on 12.08.19.
//

#include <set>
#include "PrintOperations.h"

using namespace SCAM;

PrintOperations::PrintOperations(Stmt *stmt)
{
    actualNode = std::make_shared<Node>();
    stmt->accept(*this);
}

bool PrintOperations::isSlicingOp() {
    return slicing(actualNode.get());
}

std::string PrintOperations::getOpAsString(PrintStyle style) {
    return getString(actualNode.get(), style);
}

void PrintOperations::visit(Arithmetic &node) {
    actualNode->type = StmtType::ARITHMETIC;
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getLhs()->accept(*this);
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getRhs()->accept(*this);
    actualNode = tmpNode;
}

void PrintOperations::visit(Relational &node) {
    actualNode->type = StmtType::RELATIONAL;
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getLhs()->accept(*this);
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getRhs()->accept(*this);
    actualNode = tmpNode;
}

void PrintOperations::visit(UnaryExpr &node) {
    actualNode->type = StmtType::UNARY_EXPR;
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getExpr()->accept(*this);
    actualNode = tmpNode;
}

void PrintOperations::visit(Assignment &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void PrintOperations::visit(Bitwise &node) {
    actualNode->type = StmtType::BITWISE;
    actualNode->subType = getSubTypeBitwise(node.getOperation());
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getLhs()->accept(*this);
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getRhs()->accept(*this);
    actualNode = tmpNode;

//    if (slicing(actualNode.get())) {
//        std::cout << getString(actualNode.get()) << std::endl;
//    }
}

void PrintOperations::visit(ArrayOperand &node) {
    actualNode->type = StmtType::ARRAY_OPERAND;
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getIdx()->accept(*this);
    actualNode = tmpNode;
}

void PrintOperations::visit(ParamOperand &node) {
    actualNode->type = StmtType::PARAM_OPERAND;
    actualNode->name = node.getOperandName();
}

void PrintOperations::visit(Logical &node) {
    actualNode->type = StmtType::LOGICAL;
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getLhs()->accept(*this);
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getRhs()->accept(*this);
    actualNode = tmpNode;
}

void PrintOperations::visit(UnsignedValue &node) {
    actualNode->type = StmtType::UNSIGNED_VALUE;
    actualNode->value = node.getValue();
}

void PrintOperations::visit(IntegerValue &node) {
    actualNode->type = StmtType::INTEGER_VALUE;
    actualNode->value = node.getValue();
}

void PrintOperations::visit(DataSignalOperand &node) {
    actualNode->type = StmtType::DATA_SIGNAL_OPERAND;
    std::string name = node.getDataSignal()->getPort()->getName() + "_sig";
    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isCompoundType()) {
            name += ("." + node.getDataSignal()->getName());
        } else if (node.getDataSignal()->getParent()->isArrayType()) {
            name += ("[" + node.getDataSignal()->getName() + "]");
        }
    }
    actualNode->name = name;
}

void PrintOperations::visit(VariableOperand &node) {
    actualNode->type = StmtType::VARIABLE_OPERAND;
    actualNode->name = node.getOperandName();
}

bool PrintOperations::slicing(Node *node) {
    return sliceWithShift(node) || sliceWithoutShift(node) || shiftWithConstant(node);
}

bool PrintOperations::sliceWithShift(Node *node) {
    if (node->subType == SubTypeBitwise::BITWISE_AND) {
        for (auto &child : node->child) {
            if (child->type == StmtType::BITWISE) {
                if (child->subType != SubTypeBitwise::RIGHT_SHIFT && child->subType != SubTypeBitwise::LEFT_SHIFT) {
                    return false;
                }
                auto subChild = child->child;
                for (auto &sub : subChild) {
                    if (sub->type != StmtType::UNSIGNED_VALUE && sub->type != StmtType::VARIABLE_OPERAND
                        && sub->type != StmtType::PARAM_OPERAND && sub->type != StmtType::DATA_SIGNAL_OPERAND) {
                        return false;
                    }
                }
            } else if(child->type != StmtType::UNSIGNED_VALUE) {
                return false;
            }
            if (child->type == StmtType::UNSIGNED_VALUE) {
                unsigned int firstBit;
                unsigned int lastBit;
                if (!getRange(child->value, firstBit, lastBit)) {
                    return false;
                } else {
                    node->firstBit = firstBit;
                    node->lastBit = lastBit;
                }
            }
        }
    } else {
        return false;
    }
    return true;
}

bool PrintOperations::sliceWithoutShift(Node *node) {
    if (node->subType == SubTypeBitwise::BITWISE_AND) {
        std::set<StmtType > types;
        for (auto &child : node->child) {
            if (child->type == StmtType::UNSIGNED_VALUE) {
                unsigned int firstBit;
                unsigned int lastBit;
                if (!getRange(child->value, firstBit, lastBit)) {
                    return false;
                } else {
                    node->firstBit = firstBit;
                    node->lastBit = lastBit;
                }
            }
            types.insert(child->type);
        }
        if (types.find(StmtType::UNSIGNED_VALUE) == types.end()) {
            return false;
        }
        if (types.find(StmtType::VARIABLE_OPERAND) == types.end()
            && types.find(StmtType::PARAM_OPERAND) == types.end()
            && types.find(StmtType::DATA_SIGNAL_OPERAND) == types.end())
        {
            return false;
        }
    } else {
        return false;
    }
    return true;
}

bool PrintOperations::shiftWithConstant(Node *node) {
    if (node->type == StmtType::BITWISE) {
        if (node->subType == SubTypeBitwise::RIGHT_SHIFT || node->subType == SubTypeBitwise::LEFT_SHIFT) {
            std::set<StmtType > types;
            for (auto &child : node->child) {
                types.insert(child->type);
            }
            if (types.find(StmtType::UNSIGNED_VALUE) == types.end()) {
                return false;
            }
            if (types.find(StmtType::VARIABLE_OPERAND) == types.end()
                && types.find(StmtType::PARAM_OPERAND) == types.end()
                && types.find(StmtType::DATA_SIGNAL_OPERAND) == types.end())
            {
                return false;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
    return true;
}

std::string PrintOperations::getString(Node *node, PrintStyle style) {
    std::stringstream ss;

    int offset = 0;
    if (node->subType == SubTypeBitwise::RIGHT_SHIFT || node->subType == SubTypeBitwise::LEFT_SHIFT) {
        for (auto &child : node->child) {
            if (child->type == StmtType::UNSIGNED_VALUE) {
                offset = (node->subType == SubTypeBitwise::RIGHT_SHIFT) ?
                         static_cast<int>(child->value) :
                         -static_cast<int>(child->value);
            }
        }
        for (auto &child : node->child) {
            if (child->type == StmtType::VARIABLE_OPERAND || child->type == StmtType::PARAM_OPERAND
                || child->type == StmtType::DATA_SIGNAL_OPERAND) {
                if (style == PrintStyle::HLS) {
                    ss << child->name << ".range(31, " << offset << ")";
                } else if (style == PrintStyle::VHDL) {
                    ss << child->name << "(31 downto " << offset << ")";
                }
            }
        }
    } else {
        for (auto &child : node->child) {
            if (child->type == StmtType::BITWISE) {
                for (auto &childChild : child->child) {
                    if (childChild->type == StmtType::VARIABLE_OPERAND || childChild->type == StmtType::PARAM_OPERAND
                        || childChild->type == StmtType::DATA_SIGNAL_OPERAND) {
                        if (style == PrintStyle::HLS) {
                            ss << childChild->name << ".range(";
                        } else if (style == PrintStyle::VHDL) {
                            ss << childChild->name << "(";
                        }
                    }
                }
                for (auto &childChild : child->child) {
                    if (childChild->type == StmtType::UNSIGNED_VALUE) {
                        offset = (child->subType == SubTypeBitwise::RIGHT_SHIFT) ?
                                 static_cast<int>(childChild->value) :
                                 -static_cast<int>(childChild->value);
                    }
                }
            } else if (child->type == StmtType::VARIABLE_OPERAND || child->type == StmtType::PARAM_OPERAND
                       || child->type == StmtType::DATA_SIGNAL_OPERAND) {
                if (style == PrintStyle::HLS) {
                    ss << child->name << ".range(";
                } else if (style == PrintStyle::VHDL) {
                    ss << child->name << "(";
                }
            }
        }
        for (auto &child : node->child) {
            if (child->type == StmtType::UNSIGNED_VALUE) {
                if (style == PrintStyle::HLS) {
                    ss << (offset + node->lastBit) << ", " << (node->firstBit + offset) << ")";
                } else if (style == PrintStyle::VHDL) {
                    ss << (offset + node->lastBit) << " downto " << (node->firstBit + offset) << ")";
                }
//
//                unsigned int first;
//                unsigned int last;
//                bool success = getRange(child->value, first, last);
//                std::cout << child->value << (success ? " is sliceable" : "is not sliceable") << std::endl;
//                if (success) {
//                    std::cout << "First Bit: " << first << " , Last Bit: " << last << std::endl;
//                }
//                std::cout << std::endl;
            }
        }
    }

    return ss.str();
}

bool PrintOperations::getRange(unsigned int number, unsigned int &firstBit, unsigned int &lastBit) {
    firstBit = -1;
    lastBit = -1;
    bool firstBitSet = false;
    bool lastBitSet = false;
    while (number > 0) {
        if (!firstBitSet) {
            firstBit++;
        }
        if (!lastBitSet) {
            lastBit++;
        }
        if (number % 2) {
            if (!firstBitSet) {
                firstBitSet = true;
            }
            if (lastBitSet) {
                return false;
            }
        } else {
            if (firstBitSet) {
                lastBitSet = true;
            }
        }
        number /= 2;
    }
    return !((firstBit == -1) || (lastBit == -1));
}

SubTypeBitwise PrintOperations::getSubTypeBitwise(const std::string &name) {
    if (name == "&") {
        return SubTypeBitwise::BITWISE_AND;
    } else if (name == "|") {
        return SubTypeBitwise::BITWISE_OR;
    } else if (name == "^") {
        return SubTypeBitwise::BITWISE_XOR;
    } else if (name == "<<") {
        return SubTypeBitwise::LEFT_SHIFT;
    } else if (name == ">>") {
        return SubTypeBitwise::RIGHT_SHIFT;
    } else {
        return SubTypeBitwise::UNKNOWN;
    }
}
