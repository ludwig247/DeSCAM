//
// Created by M.I.Alkoudsi on 17.09.19.
//
#include "RangeAndBitwidthAnalysis.h"

SCAM::RangeAndBitWidthAnalysis::RangeAndBitWidthAnalysis(SCAM::Module *module,
                                                         std::set<std::string> variablesThatHaveReadSet)
        : module(module), CFG(
        module->getCFG()), variablesThatHaveReadSet(std::move(variablesThatHaveReadSet)) {

    //Finding all variable values
    SCAM::FindVariablesValues valuesFinder(this->CFG, this->variablesThatHaveReadSet);
    this->variablesValuesMap = valuesFinder.getVariableValuesMap();

    //Filling initial Bitwidths of variables according to their data types
    initializeBitWidthMap();


    SCAM::BitWidthInference bwi(this->CFG, this->variablesThatHaveReadSet);
    auto deducedBitwidthMapFromBitWidthInference = bwi.getVariableBitWidthMap();
    for (auto variable : deducedBitwidthMapFromBitWidthInference) {
        if (this->variableBitWidthMap.at(variable.first) > variable.second) {
            this->variableBitWidthMap.at(variable.first) = variable.second;
        }
    }

    SCAM::VariablesRangeAnalysis vra(this->CFG, this->variablesValuesMap, this->variablesThatHaveReadSet);
    auto deducedBitwidthMapFromVariableRangeAnalysis = vra.getVariableBitWidthMap();
    for (auto variable : deducedBitwidthMapFromVariableRangeAnalysis) {
        if (this->variableBitWidthMap.at(variable.first) > variable.second) {
            this->variableBitWidthMap.at(variable.first) = variable.second;
        }
    }

    //add ranges for compound and array type variables
    for (auto variable : module->getVariableMap()) {
        if (variable.second->isCompoundType()) {
            int bitwidth = 0;
            for (auto subVar : variable.second->getSubVarList()) {
                bitwidth += this->variableBitWidthMap.at(subVar->getFullName());
            }
            this->variableBitWidthMap.insert(std::make_pair(variable.first, bitwidth));
        } else if (variable.second->isArrayType()) {
            int bitwidth = 0;
            for (auto subVar : variable.second->getSubVarList()) {
                if (this->variableBitWidthMap.at(subVar->getFullName()) > bitwidth) {
                    bitwidth = this->variableBitWidthMap.at(subVar->getFullName());
                }
            }
            bitwidth = bitwidth * variable.second->getSubVarList().size();
            this->variableBitWidthMap.insert(std::make_pair(variable.first, bitwidth));
        }
    }
    std::set<std::string> deletedVariables;
    for(const auto& pair : this->variableBitWidthMap){
        if(pair.second ==0){
            deletedVariables.insert(pair.first);
        }
    }

    //now check the write ports
    for (auto node : this->CFG) {
        auto stmt = node.second->getStmt();
        if (stmt) {
            if (dynamic_cast<SCAM::Write *>(stmt)) {
                this->propagatedBitWidth = 0;
                stmt->accept(*this);
            }
        }
    }
    std::cout << "---------RangeAndBitWidthAnalysis---------" << std::endl;
    for (auto variable: this->variableBitWidthMap) {
        std::cout << "Bitwidith for  " << variable.first << " is " << variable.second << std::endl;
    }
    for (auto port: this->writePortBitWidthMap) {
        std::cout << "Bitwidith for port " << port.first->getName() << " is " << port.second << std::endl;
    }
    std::cout << "------------------------------------------" << std::endl;

}

const std::map<std::string, int> &SCAM::RangeAndBitWidthAnalysis::getVariableBitWidthMap() const {
    this->variableBitWidthMap;
}


const std::map<SCAM::Port *, int> &SCAM::RangeAndBitWidthAnalysis::getPortsBitWidthMap() const {
    return this->writePortBitWidthMap;
}


void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::VariableOperand &node) {
    this->propagatedBitWidth = this->variableBitWidthMap.at(node.getVariable()->getFullName());
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::IntegerValue &node) {
    int signBit = 1;
    int value = node.getValue();
    if (value == 0) {
        this->propagatedBitWidth = 1 + signBit;
        return;
    }
    if (value < 0) {
        value = -value;
    }
    std::vector<int> binaryVal;
    for (int i = 0; value > 0; i++) {
        binaryVal.push_back(value % 2);
        value = value / 2;
    }
    this->propagatedBitWidth = binaryVal.size() + signBit;
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::UnsignedValue &node) {
    if (node.getValue() == 0) {
        this->propagatedBitWidth = 1;
        return;
    }
    std::vector<int> binaryVal;
    int value = node.getValue();
    for (int i = 0; value > 0; i++) {
        binaryVal.push_back(value % 2);
        value = value / 2;
    }
    this->propagatedBitWidth = binaryVal.size();
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::BoolValue &node) {
    this->propagatedBitWidth = 1;
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::CompoundValue &node) {
    int bitwidth = 0;
    for (auto val : node.getValues()) {
        bitwidth += this->variableBitWidthMap.at(this->nameFullNameMap.at(val.first));
    }
    this->propagatedBitWidth = bitwidth;
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::UnaryExpr &node) {
    node.getExpr()->accept(*this);
}


void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::Write &node) {
//    std::cout<< PrintStmt::toString(&node) << std::endl;
    node.getValue()->accept(*this);
    auto port = node.getPort();
    if (this->writePortBitWidthMap.find(port) != this->writePortBitWidthMap.end()) {
        if (this->writePortBitWidthMap.at(port) < this->propagatedBitWidth) {
            if ((node.getPort()->getDataType()->isUnsigned() ||
                 node.getPort()->getDataType()->isInteger()) && this->propagatedBitWidth > 32) {
                this->writePortBitWidthMap.at(port) = 32;
                return;
            }
            this->writePortBitWidthMap.at(port) = this->propagatedBitWidth;
        }
    } else {
        if ((node.getPort()->getDataType()->isUnsigned() ||
             node.getPort()->getDataType()->isInteger()) && this->propagatedBitWidth > 32) {
            this->writePortBitWidthMap.insert(std::make_pair(port, 32));
            return;
        }
        this->writePortBitWidthMap.insert(std::make_pair(port, this->propagatedBitWidth));
    }


}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::Arithmetic &node) {
    node.getLhs()->accept(*this);
    int lhsPropagatedValue = this->propagatedBitWidth;
    node.getRhs()->accept(*this);
    int rhsPropagatedValue = this->propagatedBitWidth;
    if (node.getOperation() == "+" || node.getOperation() == "-") {
        this->propagatedBitWidth =
                lhsPropagatedValue > rhsPropagatedValue ? lhsPropagatedValue + 1 : rhsPropagatedValue + 1;
    } else if (node.getOperation() == "*") {
        this->propagatedBitWidth = lhsPropagatedValue + rhsPropagatedValue;
    } else if (node.getOperation() == "/") {
        this->propagatedBitWidth = lhsPropagatedValue - rhsPropagatedValue;
        if (this->propagatedBitWidth <= 0 && node.getDataType()->getName() == "unsigned") {
            this->propagatedBitWidth = 1;
        } else if (this->propagatedBitWidth < 0 && node.getDataType()->getName() == "int") {
            this->propagatedBitWidth = -this->propagatedBitWidth;
        }
    } else if (node.getOperation() == "%") { // rem = lhsMax - rhsMax(floor(lhsMax/rhsMax))
        if (node.getDataType()->getName() == "int") {
            int lhsMaxVal = pow(lhsPropagatedValue - 1, 2) - 1;
            int rhsMaxVal = pow(rhsPropagatedValue - 1, 2) - 1;
            int rem = lhsMaxVal - (rhsMaxVal * (floor(lhsMaxVal / rhsMaxVal)));
            int remWidth = SCAM::OptUtilities::getRequiredBits(rem);
            this->propagatedBitWidth = remWidth;
        } else if (node.getDataType()->getName() == "unsigned") {
            unsigned int lhsMaxVal = pow(lhsPropagatedValue, 2) - 1;
            unsigned int rhsMaxVal = pow(rhsPropagatedValue, 2) - 1;
            unsigned int rem = lhsMaxVal - (rhsMaxVal * (floor(lhsMaxVal / rhsMaxVal)));
            int remWidth = SCAM::OptUtilities::getRequiredBits(rem);
            this->propagatedBitWidth = remWidth;
        }
    }
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::Logical &node) {
    this->propagatedBitWidth = 1;
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::Relational &node) {
    this->propagatedBitWidth = 1;
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::Bitwise &node) {
    node.getLhs()->accept(*this);
    int lhsPropagatedValue = this->propagatedBitWidth;
    node.getRhs()->accept(*this);
    int rhsPropagatedValue = this->propagatedBitWidth;
    if (node.getOperation() == "&") {
        if (lhsPropagatedValue > rhsPropagatedValue) {
            this->propagatedBitWidth = rhsPropagatedValue;
        } else {
            this->propagatedBitWidth = lhsPropagatedValue;
        }
    } else if (node.getOperation() == "|" || node.getOperation() == "^") {
        if (lhsPropagatedValue > rhsPropagatedValue) {
            this->propagatedBitWidth = lhsPropagatedValue;
        } else {
            this->propagatedBitWidth = rhsPropagatedValue;
        }

    } else if (node.getOperation() == ">>") {
        if (node.getDataType()->getName() == "unsigned") {
            this->propagatedBitWidth = lhsPropagatedValue - rhsPropagatedValue;
        }
    } else if (node.getOperation() == "<<") {
        this->propagatedBitWidth = lhsPropagatedValue + rhsPropagatedValue;
    }
}


void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::Cast &node) {
    node.getSubExpr()->accept(*this);
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::FunctionOperand &node) {
    this->propagatedBitWidth = 0;
    for (auto returnval : node.getFunction()->getReturnValueConditionList()) {
        int returnBitWidth = this->propagatedBitWidth;
        returnval.first->getReturnValue()->accept(*this);
        if (this->propagatedBitWidth < returnBitWidth) {
            this->propagatedBitWidth = returnBitWidth;
        }
    }
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::CompoundExpr &node) {
    int bitwidth = 0;
    for (auto val : node.getValueMap()) {
        bitwidth += this->variableBitWidthMap.at(this->nameFullNameMap.at(val.first));
    }
    this->propagatedBitWidth = bitwidth;
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::ArrayExpr &node) {
    int bitwidth = 0;
    for (auto val : node.getValueMap()) {
        bitwidth += this->variableBitWidthMap.at(this->nameFullNameMap.at(val.first));
    }
    this->propagatedBitWidth = bitwidth;
}

void SCAM::RangeAndBitWidthAnalysis::initializeBitWidthMap() {

    for (auto variable : module->getVariableMap()) {
        this->nameFullNameMap.insert(std::make_pair(variable.second->getName(), variable.second->getFullName()));
        if (variable.second->getDataType()->isBoolean()) {
            this->variableBitWidthMap.insert(std::make_pair(variable.second->getFullName(), 1));
        } else if (variable.second->isEnumType()) {
            unsigned int enumSizeMap = variable.second->getDataType()->getEnumValueMap().size() - 1;
            this->variableBitWidthMap.insert(
                    std::make_pair(variable.second->getFullName(), SCAM::OptUtilities::getRequiredBits(enumSizeMap)));
        } else if (variable.second->getDataType()->isInteger() ||
                   variable.second->getDataType()->isUnsigned()) {
            if (this->variablesThatHaveReadSet.find(variable.first) == this->variablesThatHaveReadSet.end() &&
                this->variablesValuesMap.find(variable.first) == this->variablesValuesMap.end()) {
//                this->variableBitWidthMap.insert(
//                        std::make_pair(variable.second->getFullName(), 0)); //variable removed by other optimizations
                    if(variable.second->isCompoundType() || variable.second->isArrayType()){
                        for(auto subvar : variable.second->getSubVarList()){
                            if(this->variableBitWidthMap.find(subvar->getFullName())!=this->variableBitWidthMap.end()){
                                this->variableBitWidthMap.erase(subvar->getFullName());
                            }
                        }
                    }
            } else {
                this->variableBitWidthMap.insert(std::make_pair(variable.second->getFullName(), 32));
            }
        } else if (variable.second->isCompoundType() || variable.second->isArrayType()) {
            for (auto subVar : variable.second->getSubVarList()) {
                this->nameFullNameMap.insert(std::make_pair(subVar->getName(), subVar->getFullName()));
                if (subVar->getDataType()->isBoolean()) {
                    this->variableBitWidthMap.insert(std::make_pair(subVar->getFullName(), 1));
                } else if (subVar->isEnumType()) {
                    unsigned int enumSizeMap = subVar->getDataType()->getEnumValueMap().size() - 1;
                    this->variableBitWidthMap.insert(
                            std::make_pair(subVar->getFullName(), SCAM::OptUtilities::getRequiredBits(enumSizeMap)));
                } else if (subVar->getDataType()->isInteger() ||
                           subVar->getDataType()->isUnsigned()) {
                    if (this->variablesThatHaveReadSet.find(variable.first) == this->variablesThatHaveReadSet.end() &&
                        this->variablesValuesMap.find(variable.first) == this->variablesValuesMap.end()) {
                        this->variableBitWidthMap.insert(std::make_pair(subVar->getFullName(), 0));
                    } else {
                        this->variableBitWidthMap.insert(std::make_pair(subVar->getFullName(), 32));
                    }
                }
            }
        }
    }
}


