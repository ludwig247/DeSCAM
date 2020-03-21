//
// Created by johannes on 12.08.19.
//

#include "PrintBitOperations.h"

#include <set>

#include "NodePeekVisitor.h"

using namespace SCAM::HLSPlugin::HLS;

PrintBitOperations::PrintBitOperations(Stmt *stmt, HLSOption hlsOption, std::shared_ptr<OptimizerHLS>& optimizer)
{
    this->actualNode = std::make_shared<Node>();
    this->hlsOption = hlsOption;
    this->optimizer = optimizer;

    stmt->accept(*this);
}

bool PrintBitOperations::isSlicingOp() {
    return slicing(actualNode.get());
}

std::string PrintBitOperations::getOpAsString() {
    return getString(actualNode.get());
}

void PrintBitOperations::visit(Arithmetic &node) {
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

void PrintBitOperations::visit(Relational &node) {
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

void PrintBitOperations::visit(UnaryExpr &node) {
    actualNode->type = StmtType::UNARY_EXPR;
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getExpr()->accept(*this);
    actualNode = tmpNode;
}

void PrintBitOperations::visit(Assignment &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void PrintBitOperations::visit(Bitwise &node) {
    actualNode->type = StmtType::BITWISE;
    actualNode->subType = Utilities::getSubTypeBitwise(node.getOperation());
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getLhs()->accept(*this);
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getRhs()->accept(*this);
    actualNode = tmpNode;
}

void PrintBitOperations::visit(ArrayOperand &node) {
    actualNode->type = StmtType::ARRAY_OPERAND;
    auto tmpNode = actualNode;
    actualNode = std::make_shared<Node>();
    tmpNode->child.push_back(actualNode);
    node.getIdx()->accept(*this);
    actualNode = tmpNode;
}

void PrintBitOperations::visit(ParamOperand &node) {
    actualNode->type = StmtType::PARAM_OPERAND;
    actualNode->name = node.getOperandName();
}

void PrintBitOperations::visit(Logical &node) {
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

void PrintBitOperations::visit(UnsignedValue &node) {
    actualNode->type = StmtType::UNSIGNED_VALUE;
    actualNode->value = node.getValue();
}

void PrintBitOperations::visit(IntegerValue &node) {
    actualNode->type = StmtType::INTEGER_VALUE;
    actualNode->value = node.getValue();
}

void PrintBitOperations::visit(DataSignalOperand &node) {
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

void PrintBitOperations::visit(VariableOperand &node) {
    std::string prefix;
    std::string suffix;

    bool isConstant = false;
    if (optimizer) {
        isConstant = optimizer->isConstant(node.getVariable());
    }

    if (!isConstant && hlsOption == HLSOption::SCO) {
        suffix = "_tmp";
    }
    if (!isConstant && hlsOption == HLSOption::MCO) {
        prefix = "out_";
    }

    actualNode->type = StmtType::VARIABLE_OPERAND;
    actualNode->name = prefix + node.getOperandName() + suffix;
}

bool PrintBitOperations::slicing(Node *node) {
    return sliceWithShift(node) || sliceWithoutShift(node) || shiftWithConstant(node);
}

uint32_t PrintBitOperations::getRangeAsValue() {
    return rangeValue;
}

bool PrintBitOperations::sliceWithShift(Node *node) {
    if (node->subType == SubTypeBitwise::BITWISE_AND) {
        for (auto &child : node->child) {
            if (child->type == StmtType::BITWISE) {
                if (child->subType != SubTypeBitwise::RIGHT_SHIFT && child->subType != SubTypeBitwise::LEFT_SHIFT) {
                    return false;
                }
                auto subChild = child->child;
                for (auto &sub : subChild) {
                    if (sub->type != StmtType::UNSIGNED_VALUE && sub->type != StmtType::VARIABLE_OPERAND && sub->type != StmtType::PARAM_OPERAND && sub->type != StmtType::DATA_SIGNAL_OPERAND) {
                        return false;
                    }
                }
            } else if(child->type != StmtType::UNSIGNED_VALUE) {
                return false;
            }
            if (child->type == StmtType::UNSIGNED_VALUE) {
                uint32_t firstBit;
                uint32_t lastBit;
                rangeValue = child->value;
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

bool PrintBitOperations::sliceWithoutShift(Node *node) {
    if (node->subType == SubTypeBitwise::BITWISE_AND) {
        std::set<StmtType > types;
        for (auto &child : node->child) {
            if (child->type == StmtType::UNSIGNED_VALUE) {
                uint32_t firstBit;
                uint32_t lastBit;
                rangeValue = child->value;
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

bool PrintBitOperations::shiftWithConstant(Node *node) {
    if (node->type == StmtType::BITWISE) {
        if (node->subType == SubTypeBitwise::RIGHT_SHIFT || node->subType == SubTypeBitwise::LEFT_SHIFT) {
            std::set<StmtType > types;
            for (auto &child : node->child) {
                if (child->type == StmtType::UNSIGNED_VALUE) {
                    if (node->subType == SubTypeBitwise::RIGHT_SHIFT) {
                        rangeValue = UINT32_MAX >> child->value;
                    } else {
                        rangeValue = UINT32_MAX << child->value;
                    }
                }
                types.insert(child->type);
            }
            if (types.find(StmtType::UNSIGNED_VALUE) == types.end()) {
                return false;
            }
            if (types.find(StmtType::VARIABLE_OPERAND) == types.end() && types.find(StmtType::PARAM_OPERAND) == types.end() && types.find(StmtType::DATA_SIGNAL_OPERAND) == types.end())
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

std::string PrintBitOperations::getString(Node *node) {
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
            if (child->type == StmtType::VARIABLE_OPERAND || child->type == StmtType::PARAM_OPERAND || child->type == StmtType::DATA_SIGNAL_OPERAND) {
                ss << child->name << ".range(31, " << offset << ")";
            }
        }
    } else {
        for (auto &child : node->child) {
            if (child->type == StmtType::BITWISE) {
                for (auto &childChild : child->child) {
                    if (childChild->type == StmtType::VARIABLE_OPERAND || childChild->type == StmtType::PARAM_OPERAND || childChild->type == StmtType::DATA_SIGNAL_OPERAND) {
                        ss << childChild->name << ".range(";
                    }
                }
                for (auto &childChild : child->child) {
                    if (childChild->type == StmtType::UNSIGNED_VALUE) {
                        offset = (child->subType == SubTypeBitwise::RIGHT_SHIFT) ?
                                 static_cast<int>(childChild->value) :
                                 -static_cast<int>(childChild->value);
                    }
                }
            } else if (child->type == StmtType::VARIABLE_OPERAND || child->type == StmtType::PARAM_OPERAND || child->type == StmtType::DATA_SIGNAL_OPERAND) {
                ss << child->name << ".range(";
            }
        }
        for (auto &child : node->child) {
            if (child->type == StmtType::UNSIGNED_VALUE) {
                ss << (offset + node->lastBit) << ", " << (node->firstBit + offset) << ")";
            }
        }
    }

    return ss.str();
}

bool PrintBitOperations::getRange(uint32_t number, uint32_t &firstBit, uint32_t &lastBit) {
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

BitConcatenation::BitConcatenation(Bitwise* node, HLSOption hlsOption, std::shared_ptr<OptimizerHLS>& optimizer) :
    bitwiseNode(node),
    constValue(0),
    hlsOption(hlsOption),
    optimizer(optimizer)
{
}

bool BitConcatenation::isBitConcatenationOp() {
    bool eval = evaluateOps(bitwiseNode);
    if (!eval) {
        return false;
    }
    getBitConcatenationOp(bitwiseNode);
    setOpAsString();
    return true;
}

bool BitConcatenation::evaluateOps(Bitwise* node) {
    if (Utilities::getSubTypeBitwise(node->getOperation()) != SubTypeBitwise::BITWISE_OR) {
        return false;
    }

    bool bitConcatenation = true;
    if (NodePeekVisitor::nodePeekBitwise(node->getRhs())) {
        auto bitSlicingRHS = std::make_unique<PrintBitOperations>(node->getRhs(), hlsOption, optimizer);
        if (!bitSlicingRHS->isSlicingOp()) {
            bitConcatenation = evaluateOps(dynamic_cast<Bitwise* >(node->getRhs()));
        }
    } else if (!isConstValue(node->getRhs())) {
        return false;
    }
    if (NodePeekVisitor::nodePeekBitwise(node->getLhs())) {
        auto bitSlicingLHS = std::make_unique<PrintBitOperations>(node->getLhs(), hlsOption, optimizer);
        if (!bitSlicingLHS->isSlicingOp()) {
            bitConcatenation &= evaluateOps(dynamic_cast<Bitwise* >(node->getLhs()));
        }
    } else if (!isConstValue(node->getLhs())) {
        return false;
    }

    return bitConcatenation;
}

bool BitConcatenation::isConstValue(Expr *node) {
    if (NodePeekVisitor::nodePeekIntegerValue(node)) {
        return true;
    }
    if (NodePeekVisitor::nodePeekUnsignedValue(node)) {
        return true;
    }
    if (NodePeekVisitor::nodePeekCast(node)) {
        auto castNode = dynamic_cast<Cast* >(node);
        return isConstValue(castNode->getSubExpr());
    }
    return false;
}

void BitConcatenation::getBitConcatenationOp(Bitwise* node) {
    if (NodePeekVisitor::nodePeekBitwise(node->getRhs())) {
        auto bitSlicingRHS = std::make_unique<PrintBitOperations>(node->getRhs(), hlsOption, optimizer);
        if (!bitSlicingRHS->isSlicingOp()) {
            getBitConcatenationOp(dynamic_cast<Bitwise * >(node->getRhs()));
        } else {
            bitSlicingOps.emplace_back(std::move(bitSlicingRHS));
        }
    } else if (isConstValue(node->getRhs())) {
        constValue = constValue | getConstValue(node->getRhs());
    }
    if (NodePeekVisitor::nodePeekBitwise(node->getLhs())) {
        auto bitSlicingLHS = std::make_unique<PrintBitOperations>(node->getLhs(), hlsOption, optimizer);
        if (!bitSlicingLHS->isSlicingOp()) {
            getBitConcatenationOp(dynamic_cast<Bitwise* >(node->getLhs()));
        } else {
            bitSlicingOps.emplace_back(std::move(bitSlicingLHS));
        }
    } else if (isConstValue(node->getLhs())) {
        constValue = constValue | getConstValue(node->getLhs());
    }
}

uint32_t BitConcatenation::getConstValue(Expr *node) {
    if (NodePeekVisitor::nodePeekIntegerValue(node)) {
        return (dynamic_cast<IntegerValue* >(node)->getValue());
    }
    if (NodePeekVisitor::nodePeekUnsignedValue(node)) {
        return (dynamic_cast<UnsignedValue* >(node)->getValue());
    }
    auto castNode = dynamic_cast<Cast* >(node);
    return getConstValue(castNode->getSubExpr());
}

void BitConcatenation::setOpAsString() {
    std::stringstream ss;
    ss << "(";
    uint32_t i = 32;
    uint32_t value = 0;
    uint32_t bitCounter = 0;
    PrintBitOperations* slicingOp = nullptr;
    PrintBitOperations* lastSlicingOp = nullptr;
    do {
        i--;
        slicingOp = nullptr;
        bool bitSet;
        for (auto&& op : bitSlicingOps) {
            bitSet = (1 << i) & op->getRangeAsValue();
            if (bitSet) {
                slicingOp = op.get();
            }
        }

        bitSet = (1 << i) & constValue;
        if (bitSet) {
            value = (value << 1) + 1;
            bitCounter++;
        } else if (slicingOp == nullptr) {
            value = (value << 1);
            bitCounter++;
        }

        if (slicingOp != nullptr && bitCounter > 0) {
            ss << "ap_uint<" << bitCounter << ">(" << value << ")" << ", ";
            value = 0;
            bitCounter = 0;
        }

        if (slicingOp != lastSlicingOp && lastSlicingOp != nullptr) {
            ss << lastSlicingOp->getOpAsString() << ", ";
        }
        lastSlicingOp = slicingOp;
    } while (i != 0);
    if (bitCounter != 0) {
        ss << "ap_uint<" << bitCounter << ">(" << value << ")";
    }
    if (lastSlicingOp != nullptr) {
        ss << lastSlicingOp->getOpAsString();
    }
    ss << ")";

    opAsString = ss.str();
}

std::string BitConcatenation::getOpAsString() {
    return opAsString;
}
