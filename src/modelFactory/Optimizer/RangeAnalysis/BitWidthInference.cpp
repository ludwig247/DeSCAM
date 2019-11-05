//
// Created by M.I.Alkoudsi on 08.08.19.
//

#include "BitWidthInference.h"


SCAM::BitWidthInference::BitWidthInference(std::map<int, SCAM::CfgNode *> CFG,
                                           std::set<std::string> variablesThatHaveReadSet) : CFG(std::move(CFG)),
                                                                                                    variablesThatHaveReadSet(std::move(
                                                                                                            variablesThatHaveReadSet)) {
    if (!this->CFG.empty()) {
        for (auto node: this->CFG) {
            currentNodeID = node.first;
            this->newBitWidth = 32;
            auto statement = node.second->getStmt();
            if (statement != nullptr) {
                std::cout << "Node" << node.first << " with statement: " << SCAM::PrintStmt::toString(statement) << std::endl;
                statement->accept(*this);
            }
        }
    }
    std::map<std::string, int> deducedVariableBitWidthMap;
    for (auto var : this->variableBitWidthMap) {
        if (this->variablesThatHaveReadSet.find(var.first) != this->variablesThatHaveReadSet.end()) { var.second = 32; }
        if (var.second != 32) {
//            std::cout << "deduced bit width for variable " << var.first << " is " << var.second << "\n";
            deducedVariableBitWidthMap.insert(var);
        }
    }
    this->variableBitWidthMap = deducedVariableBitWidthMap;
}

const std::map<std::string, int> &SCAM::BitWidthInference::getVariableBitWidthMap() const {
    return this->variableBitWidthMap;
}

void SCAM::BitWidthInference::visit(SCAM::IntegerValue &node) {
    int signBit = 1;
    int value = node.getValue();
    if (value == 0) {
        this->newBitWidth = 1 + signBit;
        return;
    }
    if(value == -2147483648){
        this->newBitWidth = 32;
    }
    if (value < 0) {
        value = -value;
    }
    std::vector<int> binaryVal;
    for (int i = 0; value > 0; i++) {
        binaryVal.push_back(value % 2);
        value = value / 2;
    }
    this->newBitWidth = binaryVal.size() + signBit;

}

void SCAM::BitWidthInference::visit(SCAM::UnsignedValue &node) {
    if (node.getValue() == 0) {
        this->newBitWidth = 1;
        return;
    }
    std::vector<int> binaryVal;
    int value = node.getValue();
    for (int i = 0; value > 0; i++) {
        binaryVal.push_back(value % 2);
        value = value / 2;
    }
    this->newBitWidth = binaryVal.size();
}

void SCAM::BitWidthInference::visit(SCAM::BoolValue &node) {
    this->newBitWidth = 1;
}

void SCAM::BitWidthInference::visit(SCAM::CompoundValue &node) {
    for (auto val : node.getValues()) {
        this->newBitWidth = 32;
        val.second->accept(*this);
        if (this->variableBitWidthMap.find(val.first) ==
            this->variableBitWidthMap.end()) {
            this->variableBitWidthMap.insert(
                    std::make_pair(val.first, this->newBitWidth));
        } else {
            if (this->variableBitWidthMap.at(val.first) <
                this->newBitWidth) {
                this->variableBitWidthMap.at(
                        val.first) = this->newBitWidth;
            }
        }
    }
}

void SCAM::BitWidthInference::visit(SCAM::Assignment &node) {
    auto varOp = NodePeekVisitor::nodePeekVariableOperand(node.getLhs());
    if (varOp != nullptr) {
//           std::cout << "Checking statement: " << PrintStmt::toString(&node) << std::endl;
        node.getRhs()->accept(*this);
        if (this->variableBitWidthMap.find(varOp->getVariable()->getFullName()) ==
            this->variableBitWidthMap.end()) {
            this->variableBitWidthMap.insert(
                    std::make_pair(varOp->getVariable()->getFullName(), this->newBitWidth));
        } else {
            if (this->variableBitWidthMap.at(varOp->getVariable()->getFullName()) <
                this->newBitWidth) {
                this->variableBitWidthMap.at(
                        varOp->getVariable()->getFullName()) = this->newBitWidth;
            }
        }
    }
}

void SCAM::BitWidthInference::visit(SCAM::UnaryExpr &node) {

    if (node.getOperation() == "not") {
        this->newBitWidth = 1;
    } else if (node.getOperation() == "-") {
        this->newBitWidth = 32;
        node.accept(*this);
    }
}

void SCAM::BitWidthInference::visit(SCAM::Read &node) {
    std::make_pair(node.getVariableOperand()->getVariable()->getFullName(), 32);
    if (node.getStatusOperand() != nullptr) {
        std::make_pair(node.getStatusOperand()->getVariable()->getFullName(), 1);
    }
}

void SCAM::BitWidthInference::visit(SCAM::Write &node) {
    if (node.getStatusOperand() != nullptr) {
        std::make_pair(node.getStatusOperand()->getVariable()->getFullName(), 1);
    }
}

void SCAM::BitWidthInference::visit(SCAM::Arithmetic &node) {

    this->newBitWidth = 32;
    int lhsWidth = 32;
    node.getLhs()->accept(*this);
    if (this->newBitWidth != 32)(lhsWidth = this->newBitWidth);

    this->newBitWidth = 32;
    int rhsWidth = 32;
    node.getRhs()->accept(*this);
    if (this->newBitWidth != 32)(rhsWidth = this->newBitWidth);

    if (lhsWidth == 32 || rhsWidth == 32) { this->newBitWidth = 32; }
    else if (lhsWidth > rhsWidth) { this->newBitWidth = lhsWidth; }
    else { this->newBitWidth = rhsWidth; }


}

void SCAM::BitWidthInference::visit(SCAM::Logical &node) {
    this->newBitWidth = 1;
}

void SCAM::BitWidthInference::visit(SCAM::Bitwise &node) {
    if (node.getOperation() == "&") {
        if (NodePeekVisitor::isConstTypeNode(node.getLhs()) && NodePeekVisitor::isConstTypeNode(node.getRhs())) {
            //rhs&lhs are const
            int lhsVal, rhsVal;
            if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(node.getLhs())) {
                lhsVal = lhs->getValue();
            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    node.getLhs())) {
                lhsVal = lhs->getValue();
            } else {
                std::__throw_runtime_error(
                        "lhs of bitwise should be either integer or unsigned!");
            }
            if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(node.getRhs())) {
                rhsVal = rhs->getValue();
            } else if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(
                    node.getRhs())) {
                rhsVal = rhs->getValue();
            } else {
                std::__throw_runtime_error(
                        "rhs of bitwise should be either integer or unsigned!");
            }
            if (rhsVal == 0 || lhsVal == 0) {
                this->newBitWidth == 1;
                return;
            }
            std::bitset<32> lhsBitVector(lhsVal);
            std::bitset<32> rhsBitVector(rhsVal);
            //find first one from left to right
            for (int i = 31; i > 0; i--) {
                if (lhsBitVector.test(i) && rhsBitVector.test(i)) {
                    //find first one from right to left
                    this->newBitWidth = i + 1;
                    /*for (int j = 0; j < 32; j++) {
                        if (lhsBitVector.test(j) && rhsBitVector.test(j)) {
                            this->newBitWidth = i - j + 1;
                            break;
                        }
                    }*/
                    break;
                }
            }
        } else if (NodePeekVisitor::isConstTypeNode(node.getLhs())) {//only lhs is const
            this->newBitWidth = 32;
            node.getRhs()->accept(*this);
            int lhsVal;
            if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(node.getLhs())) {
                lhsVal = lhs->getValue();
            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    node.getLhs())) {
                lhsVal = lhs->getValue();
            } else {
                std::__throw_runtime_error(
                        "lhs of bitwise should be either integer or unsigned!");
            }
            if (lhsVal == 0) {
                this->newBitWidth == 1;
                return;
            }
            std::bitset<32> lhsBitVector(lhsVal);
            int bitWidth = 32;
            //find first one from left to right
            for (int i = 31; i > 0; i--) {
                if (lhsBitVector.test(i)) {
                    this->newBitWidth = i + 1;
                    //find first one from right to left
                    /*for (int j = 0; j < 32; j++) {
                        if (lhsBitVector.test(j)) {
                            bitWidth = i - j + 1;
                            break;
                        }
                    }*/
                    break;
                }
            }
            if (bitWidth < this->newBitWidth) { this->newBitWidth = bitWidth; }
        } else if (NodePeekVisitor::isConstTypeNode(node.getRhs())) {//only rhs is const
            this->newBitWidth = 32;
            node.getLhs()->accept(*this);
            int rhsVal;
            if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(node.getRhs())) {
                rhsVal = rhs->getValue();
            } else if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(
                    node.getRhs())) {
                rhsVal = rhs->getValue();
            } else {
                std::__throw_runtime_error(
                        "rhs of bitwise should be either integer or unsigned!");
            }
            if (rhsVal == 0) {
                this->newBitWidth == 1;
                return;
            }
            std::bitset<32> rhsBitVector(rhsVal);
            int bitWidth = 32;
            //find first one from left to right
            for (int i = 31; i > 0; i--) {
                if (rhsBitVector.test(i)) {
                    this->newBitWidth = i + 1;
                    //find first one from right to left
                    /* for (int j = 0; j < 32; j++) {
                         if (rhsBitVector.test(j)) {
                             bitWidth = i - j + 1;
                             break;
                         }
                     }*/
                    break;
                }
            }
            if (bitWidth < this->newBitWidth) { this->newBitWidth = bitWidth; }
        } else { //visit both: lhs and rhs
            int lhsWidth, rhsWidth;
            this->newBitWidth = 32;
            node.getLhs()->accept(*this);
            lhsWidth = this->newBitWidth;
            this->newBitWidth = 32;
            node.getRhs()->accept(*this);
            rhsWidth = this->newBitWidth;
            if (lhsWidth < rhsWidth) { this->newBitWidth = lhsWidth; }
        }
    } else if (node.getOperation() == "|") {
        if (NodePeekVisitor::isConstTypeNode(node.getLhs()) && NodePeekVisitor::isConstTypeNode(node.getRhs())) {
            //rhs&lhs are const
            int lhsVal, rhsVal;
            if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(node.getLhs())) {
                lhsVal = lhs->getValue();
            } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(
                    node.getLhs())) {
                lhsVal = lhs->getValue();
            } else {
                std::__throw_runtime_error(
                        "lhs of bitwise should be either integer or unsigned!");
            }
            if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(node.getRhs())) {
                rhsVal = rhs->getValue();
            } else if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(
                    node.getRhs())) {
                rhsVal = rhs->getValue();
            } else {
                std::__throw_runtime_error(
                        "rhs of bitwise should be either integer or unsigned!");
            }
            if (rhsVal == 0 && lhsVal == 0) {
                this->newBitWidth == 1;
                return;
            }
            std::bitset<32> lhsBitVector(lhsVal);
            std::bitset<32> rhsBitVector(rhsVal);
            int signBit = 0;
            if (!node.getDataType()->isUnsigned()) { signBit = 1; }
            //find first one from left to right
            for (int i = 31; i > 0; i--) {
                if (lhsBitVector.test(i) || rhsBitVector.test(i)) {
                    this->newBitWidth = i + 1 + signBit;

                    break;
                }
            }
        } else { //visit both: lhs and rhs
            int lhsWidth, rhsWidth;
            this->newBitWidth = 32;
            node.getLhs()->accept(*this);
            lhsWidth = this->newBitWidth;
            this->newBitWidth = 32;
            node.getRhs()->accept(*this);
            rhsWidth = this->newBitWidth;
            if (lhsWidth > rhsWidth) { this->newBitWidth = lhsWidth; }
        }
    } else if (node.getOperation() == "^") {
        int lhsWidth, rhsWidth;
        this->newBitWidth = 32;
        node.getLhs()->accept(*this);
        lhsWidth = this->newBitWidth;
        this->newBitWidth = 32;
        node.getRhs()->accept(*this);
        rhsWidth = this->newBitWidth;
        if (lhsWidth > rhsWidth) { this->newBitWidth = lhsWidth; }
    } else if (node.getOperation() == ">>") {
        this->newBitWidth = 32;
        if (node.getDataType()->isUnsigned()) {
            node.getLhs()->accept(*this);
            if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(
                    node.getRhs())) {
                this->newBitWidth = this->newBitWidth - rhs->getValue();
            }
        }
    }
}

void SCAM::BitWidthInference::visit(SCAM::FunctionOperand &node) {

    std::vector<int> returnWidthsVector;
    for (auto ret : node.getFunction()->getReturnValueConditionList()) {
        this->newBitWidth = 32;
        ret.first->getReturnValue()->accept(*this);
        returnWidthsVector.push_back(this->newBitWidth);
    }
//    std::sort(returnWidthsVector.begin(), returnWidthsVector.end());
//    this->newBitWidth = returnWidthsVector.back();
    this->newBitWidth = *std::max_element(returnWidthsVector.begin(), returnWidthsVector.end());
}

void SCAM::BitWidthInference::visit(SCAM::ArrayOperand &node) {
    if (node.getDataType()->isBoolean()) { this->newBitWidth = 1; }
    else { node.getIdx()->accept(*this); }
}

void SCAM::BitWidthInference::visit(SCAM::CompoundExpr &node) {
    for (auto val : node.getValueMap()) {
        this->newBitWidth = 32;
        val.second->accept(*this);
        if (this->variableBitWidthMap.find(val.first) ==
            this->variableBitWidthMap.end()) {
            this->variableBitWidthMap.insert(
                    std::make_pair(val.first, this->newBitWidth));
        } else {
            if (this->variableBitWidthMap.at(val.first) <
                this->newBitWidth) {
                this->variableBitWidthMap.at(
                        val.first) = this->newBitWidth;
            }
        }
    }
}

void SCAM::BitWidthInference::visit(SCAM::ArrayExpr &node) {
    for (auto val : node.getValueMap()) {
        this->newBitWidth = 32;
        val.second->accept(*this);
        if (this->variableBitWidthMap.find(val.first) ==
            this->variableBitWidthMap.end()) {
            this->variableBitWidthMap.insert(
                    std::make_pair(val.first, this->newBitWidth));
        } else {
            if (this->variableBitWidthMap.at(val.first) <
                this->newBitWidth) {
                this->variableBitWidthMap.at(
                        val.first) = this->newBitWidth;
            }
        }
    }
}
