//
// Created by johannes on 28.07.19.
//

#include "HLS.h"
#include "NodePeekVisitor.h"
#include "PrintFunction.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include <PrintHLS/Common/Utilities.h>


using namespace DESCAM::HLSPlugin::HLS;

HLS::HLS(
        HLSOption hlsOption,
        Module *module,
        const std::string &moduleName,
        std::shared_ptr<PropertySuite> &propertySuite,
        std::shared_ptr<OptimizerHLS> &optimizer
) :
        ss(""),
        moduleName(moduleName),
        propertySuite(propertySuite),
        currentModule(module),
        optimizer(optimizer),
        hlsOption(hlsOption) {
}

/*
 * Main print function
 */
std::map<std::string, std::string> HLS::printModule() {
    std::map<std::string, std::string> pluginOutput;

    pluginOutput.insert(std::make_pair(moduleName + "_data_types.h", dataTypes()));

    if (!currentModule->getFunctionMap().empty()) {
        pluginOutput.insert(std::make_pair(moduleName + "_functions.h", functions()));
    }

    ss.str("");
    operations();
    pluginOutput.insert(std::make_pair(moduleName + ".cpp", ss.str()));

    return pluginOutput;
}

/*
 * Print data type file
 */
std::string HLS::dataTypes() {

    ss.str("");

    ss << "#ifndef DATA_TYPES_H\n";
    ss << "#define DATA_TYPES_H\n\n";
    ss << "#include \"ap_int.h\"\n\n";

    ss << "// States\n"
       << "enum state {";
    for (auto state = propertySuite->getStates().begin(); state != propertySuite->getStates().end(); state++) {
        ss << (*state)->getName();
        if (std::next(state) != propertySuite->getStates().end()) {
            ss << ", ";
        }
    }
    ss << "};\n\n";

    ss << "// Operations\n"
       << "enum operation {";
    const auto &operationProperties = propertySuite->getOperationProperties();
    for (auto property = operationProperties.begin(); property != operationProperties.end(); property++) {
        ss << (*property)->getName();
        if (std::next(property) != operationProperties.end()) {
            ss << ", ";
        }
    }
    if ((hlsOption == HLSOption::SCO) && (!propertySuite->getWaitProperties().empty())) {
        ss << ", state_wait";
    }
    ss << "};\n\n";

    if (!optimizer->getEnumTypes().empty()) {
        ss << "// Enum Types\n";
    }
    for (const auto& type : optimizer->getEnumTypes()) {
        ss << "enum " << type->getName() << " {";
        for (auto enumValue = type->getEnumValueMap().begin(); enumValue != type->getEnumValueMap().end(); enumValue++) {
            ss << enumValue->first;
            if (std::next(enumValue) != type->getEnumValueMap().end()) {
                ss << ", ";
            }
        }
        ss << "};\n\n";
    }

    if (!optimizer->getCompoundTypes().empty()) {
        ss << "// Compound Types\n";
    }
    for (const auto &type : optimizer->getCompoundTypes()) {
        ss << "struct " << type->getName() << " {\n";
        for (const auto &subType : type->getSubVarMap()) {
            ss << "\t" << Utilities::convertDataType(subType.second->getName()) << " " << subType.first << ";\n";
        }
        ss << "};\n\n";
    }

    if (!optimizer->getConstantVariables().empty()) {
        ss << "// Constants\n";
    }
    for (const auto &var : optimizer->getConstantVariables()) {
        ss << "const " << Utilities::convertDataType(var->getDataType()->getName())
           << " " << var->getFullName("_") << " = " << getVariableReset(var) << ";\n";
    }

    ss << "\n#endif //DATA_TYPES_H";

    return ss.str();
}

/*
 * Print function file
 */
std::string HLS::functions() {

    ss.str("");

    ss << "#ifndef FUNCTIONS_H\n";
    ss << "#define FUNCTIONS_H\n\n";
    ss << "#include \"ap_int.h\"\n";
    ss << "#include \"" << moduleName << "_data_types.h\"\n\n";

    // Function Prototypes
    for (const auto &function : currentModule->getFunctionMap()) {
        ss << Utilities::convertDataType(function.second->getReturnType()->getName()) << " "
                 << function.second->getName() << "(";
        auto parameterMap = function.second->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); ++parameter) {
            if (parameter->second->isCompoundType()) {
                auto subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
                    ss << Utilities::convertDataType((*subVar)->getDataType()->getName()) << " "
                             << (*subVar)->getFullName("_");
                    if (std::next(subVar) != subVarList.end()) {
                        ss << ", ";
                    }
                }
                if (std::next(parameter) != parameterMap.end()) {
                    ss << ", ";
                }
            } else {
                ss << Utilities::convertDataType(parameter->second->getDataType()->getName()) << " "
                         << parameter->first;
                if (std::next(parameter) != parameterMap.end()) {
                    ss << ", ";
                }
            }
        }
        ss << ");\n";
    }

    ss << "\n\n";
    for (auto function : currentModule->getFunctionMap()) {
        function.second->accept(*this);
    }

    ss << "#endif //FUNCTIONS_H";

    return ss.str();
}

void HLS::operations() {
    ss << "#include \"ap_int.h\"\n";
    if (!currentModule->getFunctionMap().empty()) {
        ss << "#include \"" << moduleName << "_functions.h\"\n";
    }
    ss << "#include \"" << moduleName << "_data_types.h\"\n\n";

    ss << "void " << moduleName << "_operations(\n";
    interface();
    ss << "{\n";

    if (hlsOption == HLSOption::SCO) {
        registerVariables();
        ss << "\n";
        writeToOutput();
        ss << "\n";
    }

    ss << "\tswitch (active_operation) {\n";

    // operation properties
    for (auto operationProperty : propertySuite->getOperationProperties()) {
        const std::string &operationName = operationProperty->getName();
        ss << "\tcase " << operationName << ":\n";
        for (auto commitment : optimizer->getSimplifiedCommitments().at(operationProperty)) {
            ss << PrintStatement::toString(commitment, optimizer, hlsOption, 2, 2);
        }
        for (const auto &notifyStmt : optimizer->getNotifyStatements(operationProperty)) {
            ss << PrintStatement::toString(notifyStmt, optimizer, hlsOption, 2, 2);
        }
        ss << "\t\tbreak;\n";
    }
    if ((hlsOption == HLSOption::SCO) && (!propertySuite->getWaitProperties().empty())) {
        waitOperation();
    }
    ss << "\t}\n";
    ss << "}";
}

void HLS::interface() {
    // Input
    for (const auto &input : Utilities::getParents(optimizer->getInputs())) {
        bool isArrayType = input->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(input->getDataType()->getSubVarMap().begin()->second->getName())
               << " ";
        } else {
            ss << "\t" << Utilities::convertDataType(input->getDataType()->getName()) << " ";
        }
        ss << input->getName();
        if (isArrayType) {
            ss << "[" << input->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }

    // Output
    for (const auto &output : Utilities::getParents(optimizer->getOutputs())) {
        bool isArrayType = output->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(output->getDataType()->getSubVarMap().begin()->second->getName())
               << " ";
        } else {
            ss << "\t" << Utilities::convertDataType(output->getDataType()->getName()) << " &";
        }
        ss << output->getName();
        if (isArrayType) {
            ss << "[" << output->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }

//    // Array Inputs
//    for (const auto& arrayPort : optimizer->getArrayPorts()) {
//        for (unsigned long i = 0; i<arrayPort.second.size(); ++i) {
//            ss << "\t" << Utilities::convertDataType(
//                    arrayPort.first->getDataType()->getSubVarMap().begin()->second->getName())
//               << " " << arrayPort.first->getDataSignal()->getName() << "_" << i << ",\n";
//        }
//    }

    if (hlsOption == HLSOption::MCO) {
        // Internal Registers Input
        for (const auto reg : Utilities::getParents(optimizer->getInternalRegisterIn())) {
            bool isArrayType = reg->isArrayType();
            if (isArrayType) {
                ss << "\t" << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName());
            } else {
                ss << "\t" << Utilities::convertDataType(reg->getDataType()->getName());
            }
            ss << " in_" << reg->getFullName();
            if (isArrayType) {
                ss << "[" << reg->getDataType()->getSubVarMap().size() << "]";
            }
            ss << ",\n";
        }
    }

    // Internal Register Output
    for (const auto reg : Utilities::getParents(optimizer->getInternalRegisterOut())) {
        bool isArrayType = reg->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName())
               << " ";
        } else {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getName()) << " &";
        }
        if (hlsOption == HLSOption::MCO) {
            ss << "out_";
        }
        ss << reg->getFullName();
        if (isArrayType) {
            ss << "[" << reg->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }

    // Notify Signals
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tbool &" << notifySignal->getName() << ",\n";
    }

    ss << "\toperation active_operation\n)\n";
}

void HLS::writeToOutput() {
    for (const auto &output : Utilities::getParents(optimizer->getOutputs())) {
        ss << "\t" << output->getName() << " = " << output->getName() << "_reg;\n";
    }
    for (const auto reg : Utilities::getParents(optimizer->getInternalRegisterOut())) {
        ss << "\t" << reg->getName() << " = " << reg->getName() << "_reg;\n";
    }
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << " = " << notifySignal->getName() << "_reg;\n";
    }
}

void HLS::registerVariables() {
    for (const auto &output : Utilities::getParents(optimizer->getOutputs())) {
        bool isArrayType = output->isArrayType();
        if (isArrayType) {
            ss << "\tstatic "
               << Utilities::convertDataType(output->getDataType()->getSubVarMap().begin()->second->getName());
        } else {
            ss << "\tstatic " << Utilities::convertDataType(output->getDataType()->getName());
        }
        ss << " " << output->getName() << "_reg";
        if (isArrayType) {
            ss << "[" << output->getDataType()->getSubVarMap().size() << "]";
        }
        ss << " = " << getDataSignalReset(output);
        ss << ";\n";
    }

    for (const auto reg : Utilities::getParents(optimizer->getInternalRegisterOut())) {
        bool isArrayType = reg->isArrayType();
        if (isArrayType) {
            ss << "\tstatic "
               << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName());
        } else {
            ss << "\tstatic " << Utilities::convertDataType(reg->getDataType()->getName());
        }
        ss << " " << reg->getFullName() << "_reg";
        if (isArrayType) {
            ss << "[" << reg->getDataType()->getSubVarMap().size() << "]";
        }
        ss << " = " << getVariableReset(reg) << ";\n";
    }

    for (auto notifySignal : propertySuite->getNotifySignals()) {
        auto resetValue = getResetValue(notifySignal.get());
        ss << "\tstatic bool " << notifySignal->getName() << "_reg = "
           << (resetValue.valid ? resetValue.value : "false") << ";\n";
    }

    ss << "\n";

    for (const auto reg : Utilities::getParents(optimizer->getInternalRegisterOut())) {
        bool isArrayType = reg->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName());
        } else {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getName());
        }
        ss << " " << reg->getFullName() << "_tmp";
        if (isArrayType) {
            ss << "[" << reg->getDataType()->getSubVarMap().size() << "]";
        }

        auto initArray = [this](const std::string &name, const std::size_t &arraySize) {
            ss << "{";
            for (std::size_t i = 0; i < arraySize; ++i) {
                ss << name << "_reg[" << i << "]";
                if (i < arraySize - 1) {
                    ss << ", ";
                }
            }
            ss << "};\n";
        };

        ss << " = ";
        if (isArrayType) {
            initArray(reg->getName(), reg->getSubVarList().size());
        } else {
            ss << reg->getName() << "_reg" << ";\n";
        }
    }
}

void HLS::visit(Function &node) {
    this->ss << Utilities::convertDataType(node.getReturnType()->getName()) << " " << node.getName() << "(";
    auto parameterMap = node.getParamMap();
    for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); ++parameter) {
        if (parameter->second->isCompoundType()) {
            auto subVarList = parameter->second->getSubVarList();
            for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
                this->ss << Utilities::convertDataType((*subVar)->getDataType()->getName()) << " "
                         << (*subVar)->getFullName("_");
                if (std::next(subVar) != subVarList.end()) {
                    this->ss << ", ";
                }
            }
            if (std::next(parameter) != parameterMap.end()) {
                this->ss << ", ";
            }
        } else {
            this->ss << Utilities::convertDataType(parameter->second->getDataType()->getName()) << " "
                     << parameter->first;
            if (std::next(parameter) != parameterMap.end()) {
                this->ss << ", ";
            }
        }
    }
    this->ss << ") {\n";
    if (node.getReturnValueConditionList().empty()) {
        TERMINATE("No return value for function " + node.getName());
    }
    auto numberOfBranches = node.getReturnValueConditionList().size();
    for (auto &returnValue : node.getReturnValueConditionList()) {
        if (!returnValue.second.empty()) {
            if (numberOfBranches > 1) {
                if (numberOfBranches == node.getReturnValueConditionList().size()) {
                    ss << "\tif ((";
                } else {
                    ss << "else if((";
                }
                for (auto condition = returnValue.second.begin();
                     condition != returnValue.second.end();
                     ++condition) {
                    ss << PrintFunction::toString(*condition);
                    if (std::next(condition) != returnValue.second.end()) {
                        ss << ") && (";
                    }
                }
                ss << ")) {\n";
            }
        }
        if (node.getReturnValueConditionList().size() > 1 && numberOfBranches == 1) {
            ss << "else {\n";
        }
        ss << PrintFunction::toString(returnValue.first, 2, 2) << ";";
        if (node.getReturnValueConditionList().size() > 1) {
            ss << "\n\t} ";
        }
        --numberOfBranches;
    }
    this->ss << "\n}\n\n";
}

std::string HLS::getDataSignalReset(DataSignal *dataSignal) {
    auto getDataSignalValue = [this](DataSignal *dataSignal) {
        auto resetValue = getResetValue(dataSignal);
        if (resetValue.valid) {
            return resetValue.value;
        } else {
            if (optimizer->hasOutputReg(dataSignal)) {
                return getValue(optimizer->getCorrespondingRegister(dataSignal));
            } else {
                std::string resetString = dataSignal->getInitialValue()->getValueAsString();
                return resetString.empty() ? "{}" : resetString;
            }
        }
    };

    if (dataSignal->isCompoundType()) {
        std::stringstream resetValueStream;
        resetValueStream << "{";
        auto subVarList = dataSignal->getSubVarList();
        for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
            resetValueStream << getDataSignalValue(*subVar);
            if (std::next(subVar) != subVarList.end()) {
                resetValueStream << ", ";
            }
        }
        resetValueStream << "}";
        return resetValueStream.str();
    } else {
        return getDataSignalValue(dataSignal);
    }
}

std::string HLS::getValue(Variable *variable) {
    auto resetValue = getResetValue(variable);
    if (resetValue.valid) {
        return resetValue.value;
    } else {
        std::string resetString = variable->getInitialValue()->getValueAsString();
        return resetString.empty() ? "{}" : resetString;
    }
}

std::string HLS::getVariableReset(Variable *variable) {
    if (variable->isCompoundType()) {
        std::stringstream resetValueStream;
        resetValueStream << "{";
        auto subVarList = variable->getSubVarList();
        for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
            resetValueStream << getValue(*subVar);
            if (std::next(subVar) != subVarList.end()) {
                resetValueStream << ", ";
            }
        }
        resetValueStream << "}";
        return resetValueStream.str();
    } else {
        return getValue(variable);
    }
}

template<typename T>
optional HLS::getResetValue(T *signal) {
    std::vector<DESCAM::Assignment *> assignmentList;
    auto temporalExprs = propertySuite->getResetProperty()->getCommitmentList();
    for (auto temporalExpr : temporalExprs) {
        if (NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement())) {
            auto statement = dynamic_cast<Assignment *>(temporalExpr->getStatement());
            assignmentList.push_back(statement);
        }
    }

    for (const auto &commitment : assignmentList) {
        auto printResetValue = PrintReset(commitment->getLhs(), signal->getFullName());
        if (printResetValue.hasReset()) {
            return {true, PrintStatement::toString(commitment->getRhs())};
        }
    }
    return {false, ""};
}

void HLS::waitOperation() {
    ss << "\tcase state_wait:\n";
    for (const auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isMasterOut()) {
            ss << "\t\t" << port.second->getName() << "_notify_reg = false;\n";
        }
    }
    ss << "\t\tbreak;\n";
}
