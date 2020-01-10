//
// Created by johannes on 28.07.19.
//

#include "NodePeekVisitor.h"
#include "PrintHLS.h"
#include "PrintFunctionStatements.h"
#include "Utilities.h"

PrintHLS::PrintHLS() :
    ss(""),
    propertySuite(nullptr),
    currentModule(nullptr),
    synthesisScript(nullptr),
    opt(nullptr)
{
}

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
    for (auto &module: model->getModules()) {
        this->currentModule = module.second;
        this->propertySuite = module.second->getPropertySuite();
        opt = std::make_unique<OptimizeForHLS>(propertySuite, currentModule);

        dataTypes(model);
        pluginOutput.insert(std::make_pair("Data_Types.h", ss.str()));

        ss.str("");
        functions();
        pluginOutput.insert(std::make_pair("functions.h", ss.str()));

        ss.str("");
        operations();
        pluginOutput.insert(std::make_pair(module.first + ".cpp", ss.str()));
    }

    synthesisScript = std::make_unique<PrintSynthesisScripts>();
    auto scripts = synthesisScript->printModel(model);
    pluginOutput.insert(scripts.begin(), scripts.end());

    return pluginOutput;
}

void PrintHLS::operations() {
    ss << "#include \"ap_int.h\"\n";
    ss << "#include \"functions.h\"\n";
    ss << "#include \"Data_Types.h\"\n\n";

    ss << "void operations(\n";
    interface();
    ss << "{\n";

    ss << "\tswitch (active_operation) {\n";

    // operation properties
    for (auto operationProperty : propertySuite->getOperationProperties()) {
        const std::string &operationName = operationProperty->getName();
        ss << "\tcase " << operationName << ":\n";
        for (auto commitment : operationProperty->getCommitmentList()) {
            if (*(commitment->getRhs()) == *(commitment->getLhs())) {
                continue;
            }
            ss << PrintFunctionStatements::toString(commitment, opt.get(), 2, 2);
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
    ss << "\t}\n"
       << "}";
}

void PrintHLS::interface() {
    // input and output signals
    for (const auto& input : Utilities::getParents(opt->getInputs())) {
//        bool isArrayType = input->isArrayType();
//        if (isArrayType) {
//            ss << "\t"
//               << Utilities::convertDataType(input->getDataType()->getSubVarMap().begin()->second->getName());
//        } else {
//            ss << "\t" << Utilities::convertDataType(input->getDataType()->getName());
//        }
//        ss << " " << input->getName();
//        if (isArrayType) {
//            ss << "[" <<input->getDataType()->getSubVarMap().size() << "]";
//        }
//        ss << ",\n";
        bool isArrayType = input->isArrayType();
        if (!isArrayType) {
            ss << "\t" << Utilities::convertDataType(input->getDataType()->getName())
               << " " << input->getName() << ",\n";
        }
    }
    for (const auto& arrayPort : opt->getArrayPorts()) {
        for (unsigned long i = 0; i < arrayPort.second.size(); ++i) {
            ss << "\t" << Utilities::convertDataType(arrayPort.first->getDataType()->getSubVarMap().begin()->second->getName())
               << " " << arrayPort.first->getDataSignal()->getName() << "_" << i << ",\n";
        }
    }
    for (const auto& output : Utilities::getParents(opt->getOutputs())) {
        bool isArrayType = output->isArrayType();
        if (isArrayType) {
            ss << "\t"
               << Utilities::convertDataType(output->getDataType()->getSubVarMap().begin()->second->getName());
        } else {
            ss << "\t" << Utilities::convertDataType(output->getDataType()->getName());
        }
        ss << " &" << output->getName();
        if (isArrayType) {
            ss << "[" << output->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }
    for (const auto reg : Utilities::getParents(opt->getInternalRegisterIn()))
    {
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
    for (const auto reg : Utilities::getParents(opt->getInternalRegisterOut()))
    {
        bool isArrayType = reg->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName());
        } else {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getName());
        }
        ss << " &out_" << reg->getFullName();
        if (isArrayType) {
            ss << "[" << reg->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tbool &" << notifySignal->getName() << ",\n";
    }
    ss << "\toperation active_operation\n)\n";
}

void PrintHLS::dataTypes(Model *model) {
    ss << "#ifndef DATA_TYPES_H\n";
    ss << "#define DATA_TYPES_H\n\n";
    ss << "#include \"ap_int.h\"\n\n";

    // enum of states
    ss << "// States\n"
       << "enum state {";
    for (auto state = propertySuite->getStates().begin(); state != propertySuite->getStates().end(); ++state) {
        ss << (*state)->getName();
        if (std::next(state) != propertySuite->getStates().end()) {
            ss << ", ";
        }
    }
    ss << "};\n\n";

    // enum of operations
    ss << "// Operations\n"
       << "enum operation {";
    auto operationVector = propertySuite->getOperationProperties();
    for (auto operationProperty = operationVector.begin(); operationProperty != operationVector.end(); ++operationProperty) {
        ss << (*operationProperty)->getName();
        if (std::next(operationProperty) != operationVector.end()) {
            ss << ", ";
        }
    }
    ss << "};\n\n";

    std::set<DataType *> enumTypes;
    std::set<DataType *> compoundTypes;

    auto fillTypeSets = [&enumTypes, &compoundTypes](DataType* dataType) {
        if (dataType->isEnumType()) {
            enumTypes.insert(dataType);
        } else if (dataType->isCompoundType()) {
            compoundTypes.insert(dataType);
        }
    };

    for (const auto& reg : propertySuite->getVisibleRegisters()) {
        fillTypeSets((DataType *)(reg->getDataType()));
    }
    for (const auto& func : propertySuite->getFunctions()) {
        fillTypeSets(func->getReturnType());
    }
    for (const auto& module : model->getModules()) {
        for (auto &port : module.second->getPorts()) {
            if (port.second->isCompoundType()) {
                for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                    fillTypeSets(subVar->getDataType());
                }
            }
            fillTypeSets(port.second->getDataType());
        }
    }
    for (const auto& var : currentModule->getVariableMap()) {
        fillTypeSets(var.second->getDataType());
    }

    ss << "// Enum Types\n";
    for (auto type : enumTypes) {
        type->accept(*this);
    }

    ss << "\n"
       << "// Compound Types\n";
    for (auto type : compoundTypes) {
        type->accept(*this);
    }

    ss << "\n#endif //DATA_TYPES_H";
}

void PrintHLS::visit(DataType &node) {
    // Enums
    if (node.isEnumType()) {
        if (node.getName().find("_SECTIONS") < node.getName().size())
            return;
        ss << "enum " << node.getName() << " {";
        for (auto enumValue = node.getEnumValueMap().begin(); enumValue != node.getEnumValueMap().end(); enumValue++) {
            ss << enumValue->first;
            if (std::next(enumValue) != node.getEnumValueMap().end())
                ss << ", ";
        }
        ss << "};\n\n";
    // Structs
    } else if (node.isCompoundType()) {
        ss << "struct " << node.getName() << " {\n";
        for (auto &subVar : node.getSubVarMap()) {
            ss << "\t" << Utilities::convertDataType(subVar.second->getName()) << " " << subVar.first << ";\n";
        }
        ss << "};\n\n";
    }
}

void PrintHLS::functions() {
    this->ss << "#ifndef FUNCTIONS_H\n";
    this->ss << "#define FUNCTIONS_H\n\n";
    this->ss << "#include \"ap_int.h\"\n";
    this->ss << "#include \"Data_Types.h\"\n\n";

    // Function Prototypes
    auto functionMap = currentModule->getFunctionMap();
    for (auto &function :functionMap) {
        this->ss << Utilities::convertDataType(function.second->getReturnType()->getName()) << " " << function.second->getName() << "(";
        auto parameterMap = function.second->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); ++parameter) {
            this->ss << Utilities::convertDataType(parameter->second->getDataType()->getName()) << " " << parameter->first;
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
    this->ss << Utilities::convertDataType(node.getReturnType()->getName()) << " " << node.getName() << "(";
    auto parameterMap = node.getParamMap();
    for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
        this->ss << Utilities::convertDataType(parameter->second->getDataType()->getName()) << " " << parameter->first;
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
        if (node.getReturnValueConditionList().size() > 1) {
            ss << "\n\t} ";
        }
        --numberOfBranches;
    }
    this->ss << "\n}\n\n";
}