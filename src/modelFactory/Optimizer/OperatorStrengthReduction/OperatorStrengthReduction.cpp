//
// Created by M.I.Alkoudsi on 04.09.19.
//

#include "OperatorStrengthReduction.h"
#include "Optimizer/Debug.h"


SCAM::OperatorStrengthReduction::OperatorStrengthReduction(std::map<int, CfgNode *> CFG) : isCFGOptimizer(true),
                                                                                           CFG(std::move(CFG)),
                                                                                           hasReduction(false) {

    for (auto node : this->CFG) {
        auto stmt = node.second->getStmt();
        if (stmt) {
            this->newStmt = nullptr;
            this->newExpr = nullptr;
            stmt->accept(*this);
            if (this->newStmt != nullptr && hasReduction) {
                this->CFG.at(node.first)->setStmt(this->newStmt);
                hasReduction = false;
#ifdef DEBUG_OPERATOR_STRENGTH_REDUCTION
                std::cout << "changed to " << PrintStmt::toString(this->newStmt) << std::endl;
#endif
            }
        }
    }
}

SCAM::OperatorStrengthReduction::OperatorStrengthReduction(
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList) : isCFGOptimizer(
        false), returnValueConditionList(std::move(returnValueConditionList)), hasReduction(false), newStmt(nullptr) {

    for (const auto &pair : this->returnValueConditionList) {
        std::vector<Expr *> newExprVector;
        for (auto expr : pair.second) {
            expr->accept(*this);
            if (this->newExpr != nullptr && hasReduction) {
#ifdef DEBUG_OPERATOR_STRENGTH_REDUCTION_FUNCTIONS
                std::cout << PrintStmt::toString(expr) << " changed to " << PrintStmt::toString(this->newExpr)
                          << std::endl;
#endif
                newExprVector.push_back(this->newExpr);
                this->newExpr = nullptr;
                hasReduction = false;
            } else {
                newExprVector.push_back(expr);
            }
        }
        if (pair.first->getReturnValue() != nullptr) {
            pair.first->getReturnValue()->accept(*this);
        }
        if (this->newExpr != nullptr && hasReduction) {
            auto newReturn = new Return(this->newExpr);
#ifdef DEBUG_OPERATOR_STRENGTH_REDUCTION_FUNCTIONS
            std::cout << PrintStmt::toString(pair.first) << " changed to " << PrintStmt::toString(newReturn)
                      << std::endl;
#endif
            this->tempList.emplace_back(newReturn, newExprVector);
            this->newExpr = nullptr;
            hasReduction = false;
        } else {
            this->tempList.emplace_back(pair.first, newExprVector);
        }
    }
    this->returnValueConditionList = this->tempList;
    this->tempList.clear();
}

const std::map<int, SCAM::CfgNode *> &SCAM::OperatorStrengthReduction::getCFG() const {
    return this->CFG;
}

const std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> &
SCAM::OperatorStrengthReduction::getReturnValueConditionList() const {
    return this->returnValueConditionList;
}

template<class T>
bool SCAM::OperatorStrengthReduction::isPowerOfTwo(T num) {
    return ((num != 0) && ((num & num - 1) == 0));
}


void SCAM::OperatorStrengthReduction::visit(SCAM::Assignment &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    if (hasReduction) {
        this->newStmt = new SCAM::Assignment(lhs, rhs);
    }
}

void SCAM::OperatorStrengthReduction::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);
            this->newStmt = this->newExpr;
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
                this->newStmt = this->newExpr;
            } else {
                this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));
                this->newStmt = this->newExpr;
            }

        } else throw std::runtime_error("Unknown unary operator " + node.getOperation());
    }
}

void SCAM::OperatorStrengthReduction::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new If(this->newExpr);
    }
}


void SCAM::OperatorStrengthReduction::visit(struct Write &node) {
    node.getValue()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand());
    }
}

void SCAM::OperatorStrengthReduction::visit(struct Arithmetic &node) {

    this->newExpr = nullptr;
    Expr *nodeLhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { nodeLhs = this->newExpr; }


    //RHS
    this->newExpr = nullptr;
    Expr *nodeRhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { nodeRhs = this->newExpr; }

    if (hasReduction) {
        this->newExpr = new SCAM::Arithmetic(nodeLhs, node.getOperation(), nodeRhs);
    } else {
        this->newExpr = &node;
    }
    auto arithNode = dynamic_cast<SCAM::Arithmetic *> (this->newExpr);
    if (arithNode == nullptr) { throw std::runtime_error("not arithmetic expression not expected!"); }


    if (arithNode->getOperation() == "*") {
        if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs()) &&
            NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //rhs&lhs are const
            hasReduction = true;
            if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                int result = lhsVal * rhsVal;
                this->newExpr = new IntegerValue(result);

            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    arithNode->getLhs())) {
                unsigned int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                unsigned int result = lhsVal * rhsVal;
                this->newExpr = new UnsignedValue(result);
            }

        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs())) {
            //only lhs is const
            if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getLhs())) {
                unsigned int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result);
                } else if (lhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getRhs();
                } else if (isPowerOfTwo<unsigned int>(lhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getRhs(), "<<", new UnsignedValue(log2(lhsVal)));
                } else if (isPowerOfTwo<unsigned int>(lhsVal - 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getRhs(), "<<", new UnsignedValue(log2(lhsVal))), "+",
                            arithNode->getRhs());
                } else if (isPowerOfTwo<unsigned int>(lhsVal + 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getRhs(), "<<", new UnsignedValue(log2(lhsVal))), "-",
                            arithNode->getRhs());
                }
            } else if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    int result = 0;
                    this->newExpr = new IntegerValue(result);
                } else if (lhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getRhs();
                } else if (lhsVal > 0) {
                    if (isPowerOfTwo<int>(lhsVal)) {
                        hasReduction = true;
                        this->newExpr = new Bitwise(arithNode->getRhs(), "<<", new IntegerValue(log2(lhsVal)));
                    } else if (isPowerOfTwo<int>(lhsVal - 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getRhs(), "<<", new IntegerValue(log2(lhsVal))), "+",
                                arithNode->getRhs());
                    } else if (isPowerOfTwo<int>(lhsVal + 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getRhs(), "<<", new IntegerValue(log2(lhsVal))), "-",
                                arithNode->getRhs());
                    }
                }
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //only rhs is const
            if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs())) {
                unsigned int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result);
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (isPowerOfTwo<unsigned int>(rhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), "<<", new UnsignedValue(log2(rhsVal)));
                } else if (isPowerOfTwo<unsigned int>(rhsVal - 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getLhs(), "<<", new UnsignedValue(log2(rhsVal))), "+",
                            arithNode->getLhs());
                } else if (isPowerOfTwo<unsigned int>(rhsVal + 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getLhs(), "<<", new UnsignedValue(log2(rhsVal))), "-",
                            arithNode->getLhs());
                }
            } else if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs())) {
                int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    hasReduction = true;
                    int result = 0;
                    this->newExpr = new IntegerValue(result);
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (rhsVal > 0) {
                    if (isPowerOfTwo<int>(rhsVal)) {
                        hasReduction = true;
                        this->newExpr = new Bitwise(arithNode->getLhs(), "<<", new IntegerValue(log2(rhsVal)));
                    } else if (isPowerOfTwo<int>(rhsVal - 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getLhs(), "<<", new IntegerValue(log2(rhsVal))), "+",
                                arithNode->getLhs());
                    } else if (isPowerOfTwo<int>(rhsVal + 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getLhs(), "<<", new IntegerValue(log2(rhsVal))), "-",
                                arithNode->getLhs());
                    }
                }
            }
        }
    } else if (arithNode->getOperation() == "/") {
        if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs()) &&
            NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //rhs&lhs are const
            hasReduction = true;
            if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                if (rhsVal == 0) { throw std::runtime_error("division by zero detected"); }
                int result = lhsVal / rhsVal;
                this->newExpr = new IntegerValue(result);

            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    arithNode->getLhs())) {
                unsigned int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                if (rhsVal == 0) { throw std::runtime_error("division by zero detected"); }
                unsigned int result = lhsVal / rhsVal;
                this->newExpr = new UnsignedValue(result);
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs())) {
            //only lhs is const
            if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getLhs())) {
                unsigned int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result);
                }
            } else if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    int result = 0;
                    this->newExpr = new IntegerValue(result);
                }
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //only rhs is const
            if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs())) {
                unsigned int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    throw std::runtime_error("division by zero detected");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (isPowerOfTwo<unsigned int>(rhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), ">>", new UnsignedValue(log2(rhsVal)));
                }
            } else if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs())) {
                int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    throw std::runtime_error("division by zero detected");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (rhsVal > 0 && (isPowerOfTwo<int>(rhsVal))) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), ">>", new IntegerValue(log2(rhsVal)));
                }
            }
        }
    } else if (arithNode->getOperation() == "%") {
        if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs()) &&
            NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //rhs&lhs are const
            hasReduction = true;
            if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                if (rhsVal == 0) { throw std::runtime_error("modulo by zero not allowed"); }
                int result = lhsVal % rhsVal;
                this->newExpr = new IntegerValue(result);

            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    arithNode->getLhs())) {
                unsigned int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                if (rhsVal == 0) { throw std::runtime_error("modulo by zero not allowed"); }
                unsigned int result = lhsVal % rhsVal;
                this->newExpr = new UnsignedValue(result);
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs())) {
            //only lhs is const
            if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getLhs())) {
                unsigned int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result);
                }
            } else if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    int result = 0;
                    this->newExpr = new IntegerValue(result);
                }
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //only rhs is const
            if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs())) {
                unsigned int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    throw std::runtime_error("modulo by zero not allowed");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result);
                } else if (isPowerOfTwo<unsigned int>(rhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), "&", new UnsignedValue(rhsVal - 1));
                }
            } else if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs())) {
                int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    throw std::runtime_error("modulo by zero not allowed");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new IntegerValue(result);
                } else if (rhsVal > 0 && (isPowerOfTwo<int>(rhsVal))) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), "&", new IntegerValue(rhsVal - 1));
                }
            }
        }
    }
}

void SCAM::OperatorStrengthReduction::visit(SCAM::Logical &node) {
//LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    if (hasReduction) {
        this->newExpr = new SCAM::Logical(lhs, node.getOperation(), rhs);
    } else { this->newExpr = &node; }
}

void SCAM::OperatorStrengthReduction::visit(SCAM::Relational &node) {
//LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    if (hasReduction) {
        this->newExpr = new SCAM::Relational(lhs, node.getOperation(), rhs);
    } else { this->newExpr = &node; }
}

void SCAM::OperatorStrengthReduction::visit(SCAM::Bitwise &node) {
//LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    if (hasReduction) {
        this->newExpr = new SCAM::Bitwise(lhs, node.getOperation(), rhs);
    } else { this->newExpr = &node; }
}

void SCAM::OperatorStrengthReduction::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        this->newExpr = new Cast(this->newExpr, node.getDataType());
    } else { this->newExpr = &node; }
}


void SCAM::OperatorStrengthReduction::visit(SCAM::FunctionOperand &node) {
    std::map<std::string, SCAM::Expr *> newParamValueMap;
    for (auto param : node.getParamValueMap()) {
        this->newExpr = nullptr;
        param.second->accept(*this);
        if (this->newExpr != nullptr) {
            newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
        } else {
            newParamValueMap.insert(std::make_pair(param.first, param.second));
        }
    }
    if (hasReduction) {
        this->newExpr = new SCAM::FunctionOperand(node.getFunction(), newParamValueMap);
    } else { this->newExpr = &node; }
}

void SCAM::OperatorStrengthReduction::visit(SCAM::ArrayOperand &node) {
    this->newExpr = nullptr;
    node.getIdx()->accept(*this);
    if (this->newExpr) {
        this->newExpr = new ArrayOperand(node.getArrayVar(), this->newExpr);
    }
}


void SCAM::OperatorStrengthReduction::visit(SCAM::CompoundExpr &node) {
    std::map<std::string, SCAM::Expr *> valueMap;
    for (auto subVar : node.getValueMap()) {
        this->newExpr = nullptr;
        subVar.second->accept(*this);
        if (this->newExpr != nullptr) {
            valueMap.insert(std::make_pair(subVar.first, this->newExpr));
        } else { valueMap.insert(std::make_pair(subVar.first, subVar.second)); }
    }
    if (hasReduction) {
        this->newExpr = new CompoundExpr(valueMap, node.getDataType());
    } else { this->newExpr = &node; }
}


void SCAM::OperatorStrengthReduction::visit(SCAM::ArrayExpr &node) {
    std::map<std::string, SCAM::Expr *> valueMap;
    for (auto subVar : node.getValueMap()) {
        this->newExpr = nullptr;
        subVar.second->accept(*this);
        if (this->newExpr != nullptr) {
            valueMap.insert(std::make_pair(subVar.first, this->newExpr));
        } else { valueMap.insert(std::make_pair(subVar.first, subVar.second)); }
    }
    if (hasReduction) {
        this->newExpr = new ArrayExpr(valueMap, node.getDataType());
    } else { this->newExpr = &node; }
}


