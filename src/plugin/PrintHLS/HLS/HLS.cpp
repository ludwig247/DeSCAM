//
// Created by johannes on 28.07.19.
//

#include "HLS.h"
#include "NodePeekVisitor.h"
#include "PrintFunction.h"
#include "FatalError.h"
#include "Logger/Logger.h"


using namespace DESCAM::HLSPlugin::HLS;

HLS::HLS(
        HLSOption hlsOption,
        Module* module,
        const std::string &moduleName,
        std::shared_ptr<PropertySuiteHelper>& propertySuiteHelper,
        std::shared_ptr<OptimizerHLS>& optimizer
) :
        ss(""),
        moduleName(moduleName),
        propertySuiteHelper(propertySuiteHelper),
        currentModule(module),
        optimizer(optimizer),
        hlsOption(hlsOption)
{
}

std::map<std::string, std::string> HLS::printModule() {
    std::map<std::string, std::string> pluginOutput;

    ss.str("");
    dataTypes();
    pluginOutput.insert(std::make_pair(moduleName + "_data_Types.h", ss.str()));

    if (!currentModule->getFunctionMap().empty()) {
        ss.str("");
        functions();
        pluginOutput.insert(std::make_pair(moduleName + "_functions.h", ss.str()));
    }

    ss.str("");
    operations();
    pluginOutput.insert(std::make_pair(moduleName + ".cpp", ss.str()));

    return pluginOutput;
}

void HLS::operations()
{
    ss << "#include \"ap_int.h\"\n";
    if (!currentModule->getFunctionMap().empty()) {
        ss << "#include \"" << moduleName << "_functions.h\"\n";
    }
    ss << "#include \"" << moduleName << "_data_Types.h\"\n\n";

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
    for (auto operationProperty : propertySuiteHelper->getOperationProperties()) {
        const std::string& operationName = operationProperty->getName();
        ss << "\tcase " << operationName << ":\n";
        for (auto commitment : operationProperty->getModifiedCommitmentList()) {
            ss << PrintStatement::toString(commitment, optimizer, hlsOption, 2, 2);
        }
        for (const auto& notifyStmt : propertySuiteHelper->getNotifyStatements(operationProperty)) {
            ss << PrintStatement::toString(notifyStmt, optimizer, hlsOption, 2, 2);
        }
        ss << "\t\tbreak;\n";
    }
    if (hlsOption == HLSOption::SCO) {
        waitOperation();
    }
    ss << "\t}\n";
    ss << "}";
}

void HLS::interface()
{
    // Input
    for (const auto& input : Utilities::getParents(optimizer->getInputs())) {
        bool isArrayType = input->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(input->getDataType()->getSubVarMap().begin()->second->getName()) << " ";
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
    for (const auto& output : Utilities::getParents(optimizer->getOutputs())) {
        bool isArrayType = output->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(output->getDataType()->getSubVarMap().begin()->second->getName()) << " ";
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
            }
            else {
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
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName()) << " ";
        }
        else {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getName()) << " &";
        }
        ss << "out_" << reg->getFullName();
        if (isArrayType) {
            ss << "[" << reg->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }

    // Notify Signals
    for (auto notifySignal : propertySuiteHelper->getNotifySignals()) {
        ss << "\tbool &" << notifySignal->getName() << ",\n";
    }

    ss << "\toperation active_operation\n)\n";
}

void HLS::writeToOutput()
{
    for (const auto& output : Utilities::getParents(optimizer->getOutputs())) {
        ss << "\t" << output->getName() << " = " << output->getName() << "_reg;\n";
    }
    for (const auto reg : Utilities::getParents(optimizer->getInternalRegisterOut())) {
        ss << "\tout_" << reg->getName() << " = " << reg->getName() << "_reg;\n";
    }
    for (auto notifySignal : propertySuiteHelper->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << " = " << notifySignal->getName() << "_reg;\n";
    }
}

void HLS::registerVariables()
{
    for (const auto& output : Utilities::getParents(optimizer->getOutputs())) {
        bool isArrayType = output->isArrayType();
        if (isArrayType) {
            ss << "\tstatic "
               << Utilities::convertDataType(output->getDataType()->getSubVarMap().begin()->second->getName());
        }
        else {
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
        }
        else {
            ss << "\tstatic " << Utilities::convertDataType(reg->getDataType()->getName());
        }
        ss << " " << reg->getFullName() << "_reg";
        if (isArrayType) {
            ss << "[" << reg->getDataType()->getSubVarMap().size() << "]";
        }
        ss << " = " << getVariableReset(reg) << ";\n";
    }

    for (auto notifySignal : propertySuiteHelper->getNotifySignals()) {
        auto resetValue = getResetValue(notifySignal.get());
        ss << "\tstatic bool " << notifySignal->getName() << "_reg = "
           << (resetValue.valid ? resetValue.value : "false") << ";\n";
    }

    ss << "\n";

    for (const auto reg : Utilities::getParents(optimizer->getInternalRegisterOut())) {
        bool isArrayType = reg->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName());
        }
        else {
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

void HLS::dataTypes()
{
    ss << "#ifndef DATA_TYPES_H\n";
    ss << "#define DATA_TYPES_H\n\n";
    ss << "#include \"ap_int.h\"\n\n";

    // enum of states
    ss << "// States\n"
       << "enum state {";
    for (auto state = propertySuiteHelper->getStates().begin(); state!=propertySuiteHelper->getStates().end(); ++state) {
        ss << (*state)->getName();
        if (std::next(state)!=propertySuiteHelper->getStates().end()) {
            ss << ", ";
        }
    }
    ss << "};\n\n";

    // enum of operations
    ss << "// Operations\n"
       << "enum operation {";
    const auto& operationProperties = propertySuiteHelper->getOperationProperties();
    for (auto property = operationProperties.begin(); property != operationProperties.end(); ++property) {
        ss << (*property)->getName();
        if (std::next(property) != operationProperties.end()) {
            ss << ", ";
        }
    }
    if (hlsOption == HLSOption::SCO) {
        ss << ", state_wait";
    }
    ss << "};\n\n";

    std::set<const DataType*> enumTypes;
    std::set<const DataType*> compoundTypes;

    auto addDataType = [&enumTypes, &compoundTypes](const DataType* dataType) {
        if (dataType->isEnumType()) {
            enumTypes.insert(dataType);
        }
        else if (dataType->isCompoundType()) {
            compoundTypes.insert(dataType);
        }
    };

    for (const auto& reg : propertySuiteHelper->getVisibleRegisters()) {
        addDataType((DataType*) (reg->getDataType()));
    }
    for (const auto& func : propertySuiteHelper->getFunctions()) {
        addDataType(func->getReturnType());
    }
    for (auto& port : currentModule->getPorts()) {
        if (port.second->isCompoundType()) {
            for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                addDataType(subVar->getDataType());
            }
        }
        addDataType(port.second->getDataType());
    }
    for (const auto& var : currentModule->getVariableMap()) {
        addDataType(var.second->getDataType());
    }

    ss << "// Enum Types\n";
    for (auto type : enumTypes) {
        printDataType(type);
    }

    ss << "\n"
       << "// Compound Types\n";
    for (auto type : compoundTypes) {
        printDataType(type);
    }

    ss << "\n// Constants\n";
    for (const auto& var : optimizer->getConstantVariables()) {
        ss << "const " << Utilities::convertDataType(var->getDataType()->getName())
           << " " << Utilities::getFullName(var, "_") << " = " << getVariableReset(var) << ";\n";
    }

    ss << "\n#endif //DATA_TYPES_H";
}

void HLS::printDataType(const DataType *node)
{
    // Enums
    if (node->isEnumType()) {
        if (node->getName().find("_SECTIONS") < node->getName().size())
            return;
        ss << "enum " << node->getName() << " {";
        for (auto enumValue = node->getEnumValueMap().begin(); enumValue != node->getEnumValueMap().end(); ++enumValue) {
            ss << enumValue->first;
            if (std::next(enumValue) != node->getEnumValueMap().end())
                ss << ", ";
        }
        ss << "};\n\n";
    }
    // Structs
    else if (node->isCompoundType()) {
        ss << "struct " << node->getName() << " {\n";
        for (auto& subVar : node->getSubVarMap()) {
            ss << "\t" << Utilities::convertDataType(subVar.second->getName()) << " " << subVar.first << ";\n";
        }
        ss << "};\n\n";
    }
}

void HLS::functions()
{
    this->ss << "#ifndef FUNCTIONS_H\n";
    this->ss << "#define FUNCTIONS_H\n\n";
    this->ss << "#include \"ap_int.h\"\n";
    this->ss << "#include \"" << moduleName << "_data_Types.h\"\n\n";

    // Function Prototypes
    auto functionMap = currentModule->getFunctionMap();
    for (auto& function :functionMap) {
        this->ss << Utilities::convertDataType(function.second->getReturnType()->getName()) << " "
                 << function.second->getName() << "(";
        auto parameterMap = function.second->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); ++parameter) {
            if (parameter->second->isCompoundType()) {
                auto subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
                    this->ss << Utilities::convertDataType((*subVar)->getDataType()->getName()) << " "
                             << Utilities::getFullName(*subVar, "_");
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
                if (std::next(parameter)!=parameterMap.end()) {
                    this->ss << ", ";
                }
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

void HLS::visit(Function& node)
{
    this->ss << Utilities::convertDataType(node.getReturnType()->getName()) << " " << node.getName() << "(";
    auto parameterMap = node.getParamMap();
    for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); ++parameter) {
        if (parameter->second->isCompoundType()) {
            auto subVarList = parameter->second->getSubVarList();
            for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
                this->ss << Utilities::convertDataType((*subVar)->getDataType()->getName()) << " " << Utilities::getFullName(*subVar, "_");
                if (std::next(subVar) != subVarList.end()) {
                    this->ss << ", ";
                }
            }
            if (std::next(parameter)!=parameterMap.end()) {
                this->ss << ", ";
            }
        } else {
            this->ss << Utilities::convertDataType(parameter->second->getDataType()->getName()) << " " << parameter->first;
            if (std::next(parameter) != parameterMap.end()) {
                this->ss << ", ";
            }
        }
    }
    this->ss << ") {\n";
    if (node.getReturnValueConditionList().empty()) {
        TERMINATE("No return value for function "+node.getName());
    }
    auto numberOfBranches = node.getReturnValueConditionList().size();
    for (auto& returnValue : node.getReturnValueConditionList()) {
        if (!returnValue.second.empty()) {
            if (numberOfBranches > 1) {
                if (numberOfBranches == node.getReturnValueConditionList().size()) {
                    ss << "\tif ((";
                }
                else {
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
        if (node.getReturnValueConditionList().size() > 1 && numberOfBranches==1) {
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

std::string HLS::getDataSignalReset(DataSignal* dataSignal)
{
    auto getDataSignalValue = [this](DataSignal* dataSignal) {
        auto resetValue = getResetValue(dataSignal);
        if (resetValue.valid) {
            return resetValue.value;
        }
        else {
            if (optimizer->hasOutputReg(dataSignal)) {
                return getValue(optimizer->getCorrespondingRegister(dataSignal));
            }
            else {
                std::string resetString = dataSignal->getInitialValue()->getValueAsString();
                return resetString.empty() ? "{}" : resetString;
            }
        }
    };

    if (dataSignal->isCompoundType()) {
        std::stringstream resetValueStream;
        resetValueStream << "{";
        auto subVarList = dataSignal->getSubVarList();
        for (auto subVar = subVarList.begin(); subVar!=subVarList.end(); ++subVar) {
            resetValueStream << getDataSignalValue(*subVar);
            if (std::next(subVar) != subVarList.end()) {
                resetValueStream << ", ";
            }
        }
        resetValueStream << "}";
        return resetValueStream.str();
    }
    else {
        return getDataSignalValue(dataSignal);
    }
}

std::string HLS::getValue(Variable* variable)
{
    auto resetValue = getResetValue(variable);
    if (resetValue.valid) {
        return resetValue.value;
    }
    else {
        std::string resetString = variable->getInitialValue()->getValueAsString();
        return resetString.empty() ? "{}" : resetString;
    }
}

std::string HLS::getVariableReset(Variable* variable)
{
    if (variable->isCompoundType()) {
        std::stringstream resetValueStream;
        resetValueStream << "{";
        auto subVarList = variable->getSubVarList();
        for (auto subVar = subVarList.begin(); subVar!=subVarList.end(); ++subVar) {
            resetValueStream << getValue(*subVar);
            if (std::next(subVar) != subVarList.end()) {
                resetValueStream << ", ";
            }
        }
        resetValueStream << "}";
        return resetValueStream.str();
    }
    else {
        return getValue(variable);
    }
}

template<typename T>
optional HLS::getResetValue(T* signal)
{
    for (const auto& commitment : propertySuiteHelper->getResetStatements()) {
        auto printResetValue = PrintReset(commitment->getLhs(), signal->getFullName());
        if (printResetValue.hasReset()) {
            return {true, PrintStatement::toString(commitment->getRhs())};
        }
    }
    return {false, ""};
}

void HLS::waitOperation()
{
    ss << "\tcase state_wait:\n";
    for (const auto& port : currentModule->getPorts()) {
        if (port.second->getInterface()->isMasterOut()) {
            ss << "\t\t" << port.second->getName() << "_notify_reg = false;\n";
        }
    }
    ss << "\t\tbreak;\n";
}
