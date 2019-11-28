//
// Created by johannes on 28.07.19.
//

#include "NodePeekVisitor.h"
#include "PrintHLS.h"
#include "PrintFunctionStatements.h"

PrintHLS::PrintHLS() :
    ss(""),
    propertySuite(nullptr),
    currentModule(nullptr),
    synthesisScript(nullptr),
    utils(nullptr)
{
}

std::map<std::string, std::string> PrintHLS::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        this->currentModule = module.second;
        this->propertySuite = module.second->getPropertySuite();
        utils = std::make_unique<OptimizeForHLS>(propertySuite, currentModule);

        dataTypes();
        pluginOutput.insert(std::make_pair("Data_Types.h", ss.str()));

        ss.str("");
        functions();
        pluginOutput.insert(std::make_pair("functions.h", ss.str()));

        ss.str("");
        operations();
        pluginOutput.insert(std::make_pair(module.first + ".cpp", ss.str()));
    }

    synthesisScript = std::make_unique<PrintSynthesisScripts>();
    auto scripts = synthesisScript->printModel(node);
    pluginOutput.insert(scripts.begin(), scripts.end());

    return pluginOutput;
}

void PrintHLS::operations() {
    ss << "#include \"ap_int.h\"\n";
    ss << "#include \"functions.h\"\n";
    ss << "#include \"Data_Types.h\"\n\n";

    ss << "void operations(\n";
    functionParameters();
    ss << "{\n";

    for (auto visibleRegister : propertySuite->getVisibleRegisters()) {
        auto regs = utils->getVariables();
        if (regs.find(visibleRegister->getVariable()) != regs.end()) {
            std::string type = OptimizeForHLS::convertDataType(visibleRegister->getDataType()->getName());
            std::string name = visibleRegister->getName();
            if (visibleRegister->isCompoundType()) {
                name += ("_" + visibleRegister->getSubVarName());
            }
            ss << "\tstatic " << type << " " << name << ";\n";
            ss << "\t" << type << " " << "next_" << name << ";\n";
        }
    }
    ss << "\n";
    ss << "\tswitch (active_operation) {\n";
    // operation properties
    for (auto operationProperty : propertySuite->getOperationProperties()) {
        const std::string &operationName = operationProperty->getName();
        ss << "\tcase " << operationName << ":\n";
        for (auto commitment : operationProperty->getCommitmentList()) {
            if (*(commitment->getRhs()) == *(commitment->getLhs())) {
                continue;
            }
            ss << PrintFunctionStatements::toString(commitment, utils.get(), 2, 2);
        }
        for (auto notifySignal : propertySuite->getNotifySignals()) {
            switch (operationProperty->getTiming(notifySignal->getPort())) {
                case TT_1:
                case FT_e: {
                    ss << "\t\t" << notifySignal->getName() << " = true;\n";
                    break;
                }
                case FF_1:
                case FF_e: {
                    ss << "\t\t" << notifySignal->getName() << " = false;\n";
                    break;
                }
            }
        }
        ss << "\t\tbreak;\n";
    }
    ss << "\t}\n\n";

    for (auto visibleRegister : propertySuite->getVisibleRegisters()) {
        auto regs = utils->getVariables();
        if (regs.find(visibleRegister->getVariable()) != regs.end()) {
            ss << "\t" << visibleRegister->getName();
            if (visibleRegister->isCompoundType()) {
                ss << "_" << visibleRegister->getSubVarName();
            }
            ss << " = next_" << visibleRegister->getName();
            if (visibleRegister->isCompoundType()) {
                ss << "_" << visibleRegister->getSubVarName();
            }
            ss << ";\n";
        }
    }
    ss << "\n}";
}

void PrintHLS::functionParameters() {
    // input and output signals
    for (const auto& port : currentModule->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            bool isArrayType = port.second->isArrayType();
            if (isArrayType) {
                ss << "\t"
                   << OptimizeForHLS::convertDataType(port.second->getDataType()->getSubVarMap().begin()->second->getName());
            } else {
                ss << "\t" << OptimizeForHLS::convertDataType(port.second->getDataType()->getName());
            }
            if (port.second->getInterface()->isInput()) {
                ss << " ";
            } else {
                ss << " &";
            }
            ss << port.second->getName() << "_sig";
            if (isArrayType) {
                ss << "[" << port.second->getDataType()->getSubVarMap().size() << "]";
            }
            ss << ",\n";
        }
    }
    for (const auto& output : utils->getModuleOutputs()) {
        bool isArrayType = output->isArrayType();
        if (isArrayType) {
            ss << "\t"
               << OptimizeForHLS::convertDataType(output->getDataType()->getSubVarMap().begin()->second->getName());
        } else {
            ss << "\t" << OptimizeForHLS::convertDataType(output->getDataType()->getName());
        }
        ss << " &" << output->getName();
        if (isArrayType) {
            ss << "[" <<output->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }
    // sync signals
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tbool &" << notifySignal->getName() << ",\n";
    }
    ss << "\toperation active_operation\n)\n";
}

void PrintHLS::assumptions(AbstractProperty* successorProperty) {
    const auto& assumptionList = successorProperty->getAssumptionList();
    for (auto assumption = assumptionList.begin(); assumption != assumptionList.end(); ++assumption) {
        ss << PrintFunctionStatements::toString(*assumption);
        if (std::next(assumption) != successorProperty->getAssumptionList().end()) {
            ss << ") && (";
        }
    }
}

void PrintHLS::dataTypes() {
    ss << "#ifndef DATA_TYPES_H\n";
    ss << "#define DATA_TYPES_H\n\n";
    ss << "#include \"ap_int.h\"\n";

    for (auto &dataType : DataTypes::getDataTypeMap()) {
        if (dataType.second->isEnumType())
            dataType.second->accept(*this);
    }
    for (auto &dataType : DataTypes::getDataTypeMap()) {
        if (dataType.second->isCompoundType())
            dataType.second->accept(*this);
    }

    // enum of states
    ss << "enum state {\n";
    for (auto state = propertySuite->getStates().begin(); state != propertySuite->getStates().end(); ++state) {
        ss << "\t" << (*state)->getName();
        if (std::next(state) != propertySuite->getStates().end())
            ss << ", \n";
    }
    ss << "\n};\n\n";

    // enum of operations
    ss << "enum operation {\n";
    auto operationVector = propertySuite->getOperationProperties();
    for (auto operationProperty = operationVector.begin(); operationProperty != operationVector.end(); ++operationProperty) {
        ss << "\t" << (*operationProperty)->getName();
        if (std::next(operationProperty) != operationVector.end()) {
            ss << ",\n";
        }
    }
    ss << "\n};";

    ss << "\n\n#endif //DATA_TYPES_H";
}

void PrintHLS::visit(DataType &node) {
    // Enums
    if (node.isEnumType()) {
        if (node.getName().find("_SECTIONS") < node.getName().size())
            return;
        ss << "enum " << node.getName() << " {\n";
        for (auto enumValue = node.getEnumValueMap().begin(); enumValue != node.getEnumValueMap().end(); enumValue++) {
            ss << "\t" << enumValue->first;
            if (enumValue == --node.getEnumValueMap().end())
                ss << "\n";
            else
                ss << ",\n";
        }
        ss << "};\n\n";
    // Structs
    } else if (node.isCompoundType()) {
        ss << "struct " << node.getName() << " {\n";
        for (auto &subVar : node.getSubVarMap()) {
            ss << "\t" << OptimizeForHLS::convertDataType(subVar.second->getName()) << " " << subVar.first << ";\n";
        }
        ss << "};\n\n";
    }
}

void PrintHLS::functions() {
    this->ss << "#ifndef FUNCTIONS_H\n";
    this->ss << "#define FUNCTIONS_H\n\n";
    this->ss << "#include \"ap_int.h\"\n";
    this->ss << "#include \"Data_Types.h\"\n\n";

    auto functionMap = currentModule->getFunctionMap();
    for (auto &function :functionMap) {
        this->ss << OptimizeForHLS::convertDataType(function.second->getReturnType()->getName()) << " " << function.second->getName() << "(";
        auto parameterMap = function.second->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); ++parameter) {
            this->ss << OptimizeForHLS::convertDataType(parameter->second->getDataType()->getName()) << " " << parameter->first;
            if (std::next(parameter) != parameterMap.end()) {
                this->ss << ", ";
            }
        }
        this->ss << ");\n";
    }

    this->ss << "\n\n";
    for (auto function : functionMap) {
        function.second->accept(*this);
    }

    this->ss << "#endif //FUNCTIONS_H";
}

void PrintHLS::visit(Function &node) {
    this->ss << OptimizeForHLS::convertDataType(node.getReturnType()->getName()) << " " << node.getName() << "(";
    auto parameterMap = node.getParamMap();
    for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
        this->ss << OptimizeForHLS::convertDataType(parameter->second->getDataType()->getName()) << " " << parameter->first;
        if (parameter != --parameterMap.end())
            this->ss << ", ";
    }
    this->ss << ") {\n";
    if (node.getReturnValueConditionList().empty()) {
        throw std::runtime_error("No return value for function " + node.getName());
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
                for (auto condition = returnValue.second.begin(); condition != returnValue.second.end(); ++condition) {
                    ss << PrintFunctionStatements::toString(*condition);
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
        ss <<  PrintFunctionStatements::toString(returnValue.first, 2, 2) << ";";
        ss << "\n\t} ";
        --numberOfBranches;
    }
    this->ss << "\n}\n\n";
}