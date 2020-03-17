//
// Created by M.I.Alkoudsi on 17.09.19.
//
#include <Optimizer/Utilities/FindReadVariables.h>
#include "RangeAndBitwidthAnalysis.h"
/*   Idea:
 *   After initializing the bitwidthMap with their default values, e.g., (bool 1, int 32)
 *   The variableValuesMap is searched to detect counter variables and add them to the counterVariablesSet.
 *   Values that represent the counter behaviour, e.g., x = x + 1 are also removed from the variableValuesMap,
 *   This prevent such values from hindering the values substitution process.
 *   The findVariablesValuesInRelationalExpressions procedure searches the control flow graph and functions for
 *   relational expressions such as $x == 9$ or $x > getValue(v)$ and add them to the $variableValuesMap$.
 *   These values serve as margins for a variable range in given paths in the CFG.
 *   The SubstituteFunctionsWithTheirReturnValues procedure is used to replace every function inside values of
 *   the variablesValuesMap with their returned values.If any of a function' x return values rx uses a function y,
 *   y is also substituted with its return values in rx. This creates a number of return values that replace rx in function x.
 *   The analyzeCounterVariables procedure looks for the conditional statement that checks the range of the counter variable and
 *   analyzes it along with the assignment to the counter variable in its true branch.
 *   every non constant value in the $variableValuesMap$ is substituted with its possible values.
 *   For example, the value y in the assignment x = 2 + y is replaced with all its possible values.
 *   Say the values of y are {0 and 5}, then we have x = 2 + 0 and x = 2 + 5. After the substitution,
 *   all the values are simplified using the . The resulting values for x are {2 and 7}.
 *   Now that we have all the possible values of the module variables. The bitwidth for each variable is equal to
 *   the number of bits needed to represent the largest or smallest value(the one that requires more bits)
 *   in the variableValuesMap plus the sign bit for signed integer variables.
 *   The bitwidthMap is updated with the newly deduced variables bitwidths
 *   Output ports bitwidths are deduced by analyzing write statements in the CFG
 */

SCAM::RangeAndBitWidthAnalysis::RangeAndBitWidthAnalysis(SCAM::Module *module)
        : module(module), CFG(
        module->getCFG()) {

    //Finding all variable values
    SCAM::FindReadVariables readVariablesFinder(this->CFG);
    this->variablesThatHaveReadSet = readVariablesFinder.getReadVariablesSet();
    SCAM::FindVariablesValues valuesFinder(this->CFG, this->variablesThatHaveReadSet);
    this->variablesValuesMap = valuesFinder.getVariableValuesMap();

    //Filling initial Bitwidths of variables according to their data types
    initializeBitWidthMap();
#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "variable bitwidth map after initialization" << std::endl;
    for (const auto& var : this->variableBitWidthMap) {
        std::cout << "variable " << var.first << " : " << var.second << std::endl;
    }
#endif
    SCAM::VariablesRangeAnalysis vra(this->CFG, this->variablesValuesMap, this->variablesThatHaveReadSet);
    auto deducedBitwidthMapFromVariableRangeAnalysis = vra.getVariableBitWidthMap();
    for (const auto& variable : deducedBitwidthMapFromVariableRangeAnalysis) {
        if (this->variableBitWidthMap.at(variable.first) > variable.second) {
            this->variableBitWidthMap.at(variable.first) = variable.second;
        }
    }

    //add ranges for compound and array type variables
    for (const auto& variable : module->getVariableMap()) {
        if (variable.second->isCompoundType()) {
            int bitwidth = 0;
            for (auto subVar : variable.second->getSubVarList()) {
                bitwidth += this->variableBitWidthMap.at(subVar->getFullName());
            }
            if(this->variableBitWidthMap.find(variable.first)==this->variableBitWidthMap.end()) {
                this->variableBitWidthMap.insert(std::make_pair(variable.first, bitwidth));
            }else{
                this->variableBitWidthMap.at(variable.first) = bitwidth;
            }
        } else if (variable.second->isArrayType()) {
            int bitwidth = 0;
            for (auto subVar : variable.second->getSubVarList()) {
                if (this->variableBitWidthMap.at(subVar->getFullName()) > bitwidth) {
                    bitwidth = this->variableBitWidthMap.at(subVar->getFullName());
                }
            }
            bitwidth = bitwidth * variable.second->getSubVarList().size();
            if(this->variableBitWidthMap.find(variable.first)==this->variableBitWidthMap.end()) {
                this->variableBitWidthMap.insert(std::make_pair(variable.first, bitwidth));
            }else{
                this->variableBitWidthMap.at(variable.first) = bitwidth;
            }
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

    //remove deleted variables from the bitwidth map
    std::map<std::string, int> newVariableBitWidthMap;
    for(auto variable : this->variableBitWidthMap){
        bool foundSubVar = false;
        bool foundVar = this->variablesValuesMap.find(variable.first) != this->variablesValuesMap.end() || this->variablesThatHaveReadSet.find(variable.first)!=this->variablesThatHaveReadSet.end();
        auto varMap = this->module->getVariableMap();
        if(varMap.find(variable.first)!=varMap.end()) {
            auto var = this->module->getVariable(variable.first);
            if(var->isCompoundType() || var->isArrayType()) {
                for (auto subVari: var->getSubVarList()) {
                    if (this->variablesValuesMap.find(subVari->getFullName()) != this->variablesValuesMap.end() ||
                        this->variablesThatHaveReadSet.find(subVari->getFullName()) !=
                        this->variablesThatHaveReadSet.end()) {
                        foundSubVar = true;
                        break;
                    }
                }
                if (foundVar || foundSubVar) {
                    newVariableBitWidthMap.insert(variable);
                    for (auto subVari: var->getSubVarList()) {
                    if(this->variableBitWidthMap.find(subVari->getFullName())!=this->variableBitWidthMap.end()){
                        newVariableBitWidthMap.insert(std::make_pair(subVari->getFullName(),this->variableBitWidthMap.at(subVari->getFullName())));
                    }
                    }
                }
            }else{
                if(foundVar){
                    newVariableBitWidthMap.insert(variable);
                }
            }
        }
    }
    this->variableBitWidthMap = newVariableBitWidthMap;

#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "---------RangeAndBitWidthAnalysis---------" << std::endl;
    for (auto variable: this->variableBitWidthMap) {
        std::cout << "Bitwidith for  " << variable.first << " is " << variable.second << std::endl;
    }
    for (auto port: this->writePortBitWidthMap) {
        std::cout << "Bitwidith for port " << port.first->getName() << " is " << port.second << std::endl;
    }
    std::cout << "------------------------------------------" << std::endl;
#endif
}

const std::map<std::string, int> &SCAM::RangeAndBitWidthAnalysis::getVariableBitWidthMap() const {
    return this->variableBitWidthMap;
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
        this->propagatedBitWidth = 1;
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

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::EnumValue &node) {
this->propagatedBitWidth = ceil(log2(node.getDataType()->getEnumValueMap().size()));
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
    if(this->propagatedBitWidth == 0) this->propagatedBitWidth = 1;
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
        }else{
            this->propagatedBitWidth = 32;
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
    for (const auto& returnval : node.getFunction()->getReturnValueConditionList()) {
        int returnBitWidth = this->propagatedBitWidth;
        returnval.first->getReturnValue()->accept(*this);
        if (this->propagatedBitWidth < returnBitWidth) {
            this->propagatedBitWidth = returnBitWidth;
        }
    }
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::ArrayOperand &node) {
    this->propagatedBitWidth = this->variableBitWidthMap.at(node.getArrayOperand()->getOperandName());
    if(this->propagatedBitWidth != 0){
        this->propagatedBitWidth = this->propagatedBitWidth / node.getArrayOperand()->getDataType()->getArraySize();
    }
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::CompoundExpr &node) {
    int bitwidth = 0;
    for (const auto& val : node.getValueMap()) {
        val.second->accept(*this);
        if(val.second->getDataType()->isInteger() || val.second->getDataType()->isUnsigned()){
        if(this->propagatedBitWidth > 32){
            this->propagatedBitWidth = 32;
        }
        }
        bitwidth += this->propagatedBitWidth;
    }
    this->propagatedBitWidth = bitwidth;
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::ArrayExpr &node) {
    int bitwidth = 0;
    for (const auto& val : node.getValueMap()) {
        val.second->accept(*this);
        if(val.second->getDataType()->isInteger() || val.second->getDataType()->isUnsigned()){
            if(this->propagatedBitWidth > 32){
                this->propagatedBitWidth = 32;
            }
        }
        if(this->propagatedBitWidth > bitwidth) {
            bitwidth = this->propagatedBitWidth;
        }
    }
    this->propagatedBitWidth = bitwidth * node.getValueMap().size();
}

void SCAM::RangeAndBitWidthAnalysis::initializeBitWidthMap() {

    for (const auto& variable : module->getVariableMap()) {
        this->nameFullNameMap.insert(std::make_pair(variable.second->getName(), variable.second->getFullName()));
        if (variable.second->getDataType()->isBoolean()) {
            this->variableBitWidthMap.insert(std::make_pair(variable.second->getFullName(), 1));
        } else if (variable.second->isEnumType()) {
            unsigned int enumBitwidth = ceil(log2(variable.second->getDataType()->getEnumValueMap().size()));
            this->variableBitWidthMap.insert(
                    std::make_pair(variable.second->getFullName(), enumBitwidth));
        } else if (variable.second->getDataType()->isInteger() ||
                   variable.second->getDataType()->isUnsigned()) {
            if (this->variablesThatHaveReadSet.find(variable.first) == this->variablesThatHaveReadSet.end() &&
                this->variablesValuesMap.find(variable.first) == this->variablesValuesMap.end()) {
                this->variableBitWidthMap.insert(
                        std::make_pair(variable.second->getFullName(), 1)); //variable removed by other optimizations
            } else {
                this->variableBitWidthMap.insert(std::make_pair(variable.second->getFullName(), 32));
            }
        } else if (variable.second->isCompoundType() || variable.second->isArrayType()) {
            int compoundBitwidth =0;
            for (auto subVar : variable.second->getSubVarList()) {
                this->nameFullNameMap.insert(std::make_pair(subVar->getName(), subVar->getFullName()));
                if (subVar->getDataType()->isBoolean()) {
                    this->variableBitWidthMap.insert(std::make_pair(subVar->getFullName(), 1));
                    compoundBitwidth+=1;
                } else if (subVar->isEnumType()) {
                    unsigned int enumBitwidth = ceil(log2(subVar->getDataType()->getEnumValueMap().size()));
                    this->variableBitWidthMap.insert(
                            std::make_pair(subVar->getFullName(), enumBitwidth));
                    compoundBitwidth+=enumBitwidth;
                } else if (subVar->getDataType()->isInteger() ||
                           subVar->getDataType()->isUnsigned()) {
                    if (this->variablesThatHaveReadSet.find(variable.first) == this->variablesThatHaveReadSet.end() &&
                        this->variablesValuesMap.find(variable.first) == this->variablesValuesMap.end()) {
                        bool foundSubVar = false;
                        for(auto subVari: variable.second->getSubVarList()){
                            if(this->variablesValuesMap.find(subVari->getFullName())!=this->variablesValuesMap.end()){
                            foundSubVar = true;
                            break;
                            }
                        }
                        if(foundSubVar) {
                            this->variableBitWidthMap.insert(std::make_pair(subVar->getFullName(), 32));
                            compoundBitwidth+=32;
                        }else {
                            this->variableBitWidthMap.insert(std::make_pair(subVar->getFullName(), 1));
                            compoundBitwidth+=1;
                        }
                    } else {
                        this->variableBitWidthMap.insert(std::make_pair(subVar->getFullName(), 32));
                        compoundBitwidth+=32;
                    }
                }
            }
            this->variableBitWidthMap.insert(std::make_pair(variable.second->getFullName(),compoundBitwidth));
        }
    }
}

void SCAM::RangeAndBitWidthAnalysis::visit(SCAM::Ternary &node) {
    throw std::runtime_error("Combining -Optmize and Compare Operator ? is not allowed");

}




