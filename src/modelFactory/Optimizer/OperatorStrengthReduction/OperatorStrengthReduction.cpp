//
// Created by M.I.Alkoudsi on 04.09.19.
//

#include "OperatorStrengthReduction.h"
#include "Optimizer/Debug.h"
#include "FatalError.h"
#include "Logger/Logger.h"


/* The algorithm iterates over statements of the CFG looking for expensive arithmetic operations,
 * If found, the algorithm checks whether the lhs and/or rhs of the expression is ^2 number.
 * If true, the arithmetic expensive operation is converted into cheaper operation/s
 * e.g., x * 65 => ((x << 6) + x)
 */

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
            auto newReturn = new Return(this->newExpr, pair.first->getStmtInfo());
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
        this->newStmt = new SCAM::Assignment(lhs, rhs, node.getStmtInfo());
    }
}

void SCAM::OperatorStrengthReduction::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr, node.getStmtInfo());
        } else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr, node.getStmtInfo());
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1), node.getStmtInfo());
            } else {
                this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1), node.getStmtInfo());
            }
        } else TERMINATE("Unknown unary operator " + node.getOperation());
    }
}

void SCAM::OperatorStrengthReduction::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new If(this->newExpr, node.getStmtInfo());
    }
}


void SCAM::OperatorStrengthReduction::visit(struct Write &node) {
    node.getValue()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand(),
                                  node.getStmtInfo());
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
        this->newExpr = new SCAM::Arithmetic(nodeLhs, node.getOperation(), nodeRhs, node.getStmtInfo());
    } else {
        this->newExpr = &node;
    }
    auto arithNode = dynamic_cast<SCAM::Arithmetic *> (this->newExpr);
    if (arithNode == nullptr) { TERMINATE("not arithmetic expression not expected!"); }


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
                this->newExpr = new IntegerValue(result, node.getStmtInfo());

            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    arithNode->getLhs())) {
                unsigned int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                unsigned int result = lhsVal * rhsVal;
                this->newExpr = new UnsignedValue(result, node.getStmtInfo());
            }

        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs())) {
            //only lhs is const
            if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getLhs())) {
                unsigned int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result, node.getStmtInfo());
                } else if (lhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getRhs();
                } else if (isPowerOfTwo<unsigned int>(lhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getRhs(), "<<", new UnsignedValue(log2(lhsVal)),
                                                node.getStmtInfo());
                } else if (isPowerOfTwo<unsigned int>(lhsVal - 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getRhs(), "<<", new UnsignedValue(log2(lhsVal - 1))), "+",
                            arithNode->getRhs(), node.getStmtInfo());
                } else if (isPowerOfTwo<unsigned int>(lhsVal + 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getRhs(), "<<", new UnsignedValue(log2(lhsVal + 1))), "-",
                            arithNode->getRhs(), node.getStmtInfo());
                }
            } else if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    int result = 0;
                    this->newExpr = new IntegerValue(result, node.getStmtInfo());
                } else if (lhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getRhs();
                } else if (lhsVal > 0) {
                    if (isPowerOfTwo<int>(lhsVal)) {
                        hasReduction = true;
                        this->newExpr = new Bitwise(arithNode->getRhs(), "<<", new IntegerValue(log2(lhsVal)),
                                                    node.getStmtInfo());
                    } else if (isPowerOfTwo<int>(lhsVal - 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getRhs(), "<<", new IntegerValue(log2(lhsVal - 1))), "+",
                                arithNode->getRhs(), node.getStmtInfo());
                    } else if (isPowerOfTwo<int>(lhsVal + 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getRhs(), "<<", new IntegerValue(log2(lhsVal + 1))), "-",
                                arithNode->getRhs(), node.getStmtInfo());
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
                    this->newExpr = new UnsignedValue(result, node.getStmtInfo());
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (isPowerOfTwo<unsigned int>(rhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), "<<", new UnsignedValue(log2(rhsVal)),
                                                node.getStmtInfo());
                } else if (isPowerOfTwo<unsigned int>(rhsVal - 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getLhs(), "<<", new UnsignedValue(log2(rhsVal - 1))), "+",
                            arithNode->getLhs(), node.getStmtInfo());
                } else if (isPowerOfTwo<unsigned int>(rhsVal + 1)) {
                    hasReduction = true;
                    this->newExpr = new Arithmetic(
                            new Bitwise(arithNode->getLhs(), "<<", new UnsignedValue(log2(rhsVal + 1))), "-",
                            arithNode->getLhs(), node.getStmtInfo());
                }
            } else if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs())) {
                int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    hasReduction = true;
                    int result = 0;
                    this->newExpr = new IntegerValue(result, node.getStmtInfo());
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (rhsVal > 0) {
                    if (isPowerOfTwo<int>(rhsVal)) {
                        hasReduction = true;
                        this->newExpr = new Bitwise(arithNode->getLhs(), "<<", new IntegerValue(log2(rhsVal)),
                                                    node.getStmtInfo());
                    } else if (isPowerOfTwo<int>(rhsVal - 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getLhs(), "<<", new IntegerValue(log2(rhsVal - 1))), "+",
                                arithNode->getLhs(), node.getStmtInfo());
                    } else if (isPowerOfTwo<int>(rhsVal + 1)) {
                        hasReduction = true;
                        this->newExpr = new Arithmetic(
                                new Bitwise(arithNode->getLhs(), "<<", new IntegerValue(log2(rhsVal + 1))), "-",
                                arithNode->getLhs(), node.getStmtInfo());
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
                if (rhsVal == 0) { TERMINATE("division by zero detected"); }
                int result = lhsVal / rhsVal;
                this->newExpr = new IntegerValue(result, node.getStmtInfo());

            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    arithNode->getLhs())) {
                unsigned int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                if (rhsVal == 0) { TERMINATE("division by zero detected"); }
                unsigned int result = lhsVal / rhsVal;
                this->newExpr = new UnsignedValue(result, node.getStmtInfo());
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
                    this->newExpr = new IntegerValue(result, node.getStmtInfo());
                }
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //only rhs is const
            if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs())) {
                unsigned int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    TERMINATE("division by zero detected");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (isPowerOfTwo<unsigned int>(rhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), ">>", new UnsignedValue(log2(rhsVal)),
                                                node.getStmtInfo());
                }
            } else if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs())) {
                int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    TERMINATE("division by zero detected");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    this->newExpr = arithNode->getLhs();
                } else if (rhsVal > 0 && (isPowerOfTwo<int>(rhsVal))) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), ">>", new IntegerValue(log2(rhsVal)),
                                                node.getStmtInfo());
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
                if (rhsVal == 0) { TERMINATE("modulo by zero not allowed"); }
                int result = lhsVal % rhsVal;
                this->newExpr = new IntegerValue(result, node.getStmtInfo());

            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    arithNode->getLhs())) {
                unsigned int lhsVal, rhsVal;
                lhsVal = lhs->getValue();
                auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs());
                rhsVal = rhs->getValue();
                if (rhsVal == 0) { TERMINATE("modulo by zero not allowed"); }
                unsigned int result = lhsVal % rhsVal;
                this->newExpr = new UnsignedValue(result, node.getStmtInfo());
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getLhs())) {
            //only lhs is const
            if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getLhs())) {
                unsigned int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result, node.getStmtInfo());
                }
            } else if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getLhs())) {
                int lhsVal;
                lhsVal = lhs->getValue();
                if (lhsVal == 0) {
                    hasReduction = true;
                    int result = 0;
                    this->newExpr = new IntegerValue(result, node.getStmtInfo());
                }
            }
        } else if (NodePeekVisitor::isConstTypeNode(arithNode->getRhs())) {
            //only rhs is const
            if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(arithNode->getRhs())) {
                unsigned int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    TERMINATE("modulo by zero not allowed");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new UnsignedValue(result);
                } else if (isPowerOfTwo<unsigned int>(rhsVal)) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), "&", new UnsignedValue(rhsVal - 1),
                                                node.getStmtInfo());
                }
            } else if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(arithNode->getRhs())) {
                int rhsVal;
                rhsVal = rhs->getValue();
                if (rhsVal == 0) {
                    TERMINATE("modulo by zero not allowed");
                } else if (rhsVal == 1) {
                    hasReduction = true;
                    unsigned int result = 0;
                    this->newExpr = new IntegerValue(result);
                } else if (rhsVal > 0 && (isPowerOfTwo<int>(rhsVal))) {
                    hasReduction = true;
                    this->newExpr = new Bitwise(arithNode->getLhs(), "&", new IntegerValue(rhsVal - 1),
                                                node.getStmtInfo());
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
        this->newExpr = new SCAM::Logical(lhs, node.getOperation(), rhs, node.getStmtInfo());
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
        this->newExpr = new SCAM::Relational(lhs, node.getOperation(), rhs, node.getStmtInfo());
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
        this->newExpr = new SCAM::Bitwise(lhs, node.getOperation(), rhs, node.getStmtInfo());
    } else { this->newExpr = &node; }
}

void SCAM::OperatorStrengthReduction::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
    if (this->newExpr != nullptr && hasReduction) {
        this->newExpr = new Cast(this->newExpr, node.getDataType(), node.getStmtInfo());
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
        this->newExpr = new ArrayOperand(node.getArrayOperand(), this->newExpr, node.getStmtInfo());
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
        this->newExpr = new CompoundExpr(valueMap, node.getDataType(), node.getStmtInfo()
        );
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
        this->newExpr = new ArrayExpr(valueMap, node.getDataType(), node.getStmtInfo());
    } else { this->newExpr = &node; }
}

/*  A ternary operation can be simplified depending on the values of the trueExpr and falseExpr as follows
 *   x >= y ? z : false <=>  x>=y && z
 *   x >= y ? false : z <=>  !x>=y && z
 */
void SCAM::OperatorStrengthReduction::visit(SCAM::Ternary &node) {
    if (auto falseExpr = dynamic_cast<BoolValue *>(node.getFalseExpr())) {
        if (!falseExpr->getValue()) {
            this->newExpr = new Logical(node.getCondition(), "and", node.getTrueExpr(), node.getStmtInfo());
            hasReduction = true;
        }
    } else if (auto trueExpr = dynamic_cast<BoolValue *>(node.getFalseExpr())) {
        if (!trueExpr->getValue()) {
            this->newExpr = new Logical(new UnaryExpr("not", node.getCondition(), node.getStmtInfo()), "and",
                                        node.getTrueExpr(), node.getStmtInfo());
            hasReduction = true;
        }
    }
}


