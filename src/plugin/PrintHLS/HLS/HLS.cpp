//
// Created by johannes on 28.07.19.
//

#include "NodePeekVisitor.h"
#include "HLS.h"

using namespace SCAM::HLSPlugin::HLS;

HLS::HLS(HLSOption hlsOption) :
    ss(""),
    moduleName(""),
    propertySuite(nullptr),
    currentModule(nullptr),
    opt(nullptr),
    hlsOption(hlsOption)
{
}

std::map<std::string, std::string> HLS::printModel(Model* model)
{
    for (auto& module: model->getModules()) {
        this->currentModule = module.second;
        this->propertySuite = module.second->getPropertySuite();
        opt = std::make_unique<Optimizer>(propertySuite, currentModule);

        dataTypes(model);
        pluginOutput.insert(std::make_pair(module.first + "_data_Types.h", ss.str()));

        ss.str("");
        functions();
        pluginOutput.insert(std::make_pair(module.first + "_functions.h", ss.str()));

        ss.str("");
        operations();
        pluginOutput.insert(std::make_pair(module.first + ".cpp", ss.str()));
    }
    return pluginOutput;
}

void HLS::operations()
{
    ss << "#include \"ap_int.h\"\n";
    ss << "#include \"functions.h\"\n";
    ss << "#include \"Data_Types.h\"\n\n";

    ss << "void " << moduleName << "_operations(\n";
    interface();
    ss << "{\n";

    if (hlsOption == HLSOption::OCCO) {
        registerVariables();
        ss << "\n";
        writeToOutput();
        ss << "\n";
    }

    ss << "\tswitch (active_operation) {\n";

    // operation properties
    for (auto operationProperty : propertySuite->getOperationProperties()) {
        const std::string& operationName = operationProperty->getName();
        ss << "\tcase " << operationName << ":\n";
        for (auto commitment : operationProperty->getCommitmentList()) {
            if (*(commitment->getRhs())==*(commitment->getLhs())) {
                continue;
            }
            ss << PrintStatement::toString(commitment, opt.get(), hlsOption, 2, 2);
        }
        for (auto notifySignal : propertySuite->getNotifySignals()) {
            std::string suffix = (hlsOption == HLSOption::OCCO ? "_reg" : "");
            switch (operationProperty->getTiming(notifySignal->getPort())) {
            case TT_1:
            case FT_e: {
                ss << "\t\t" << notifySignal->getName() << suffix << " = true;\n";
                break;
            }
            case FF_1:
            case FF_e: {
                ss << "\t\t" << notifySignal->getName() << suffix << " = false;\n";
                break;
            }
            }
        }
        ss << "\t\tbreak;\n";
    }
    if (hlsOption == HLSOption::OCCO) {
        waitOperation();
    }
    ss << "\t}\n";
    ss << "}";
}

void HLS::interface()
{
    // Input
    for (const auto& input : Utilities::getParents(opt->getInputs())) {
        bool isArrayType = input->isArrayType();
        if (!isArrayType) {
            ss << "\t" << Utilities::convertDataType(input->getDataType()->getName())
               << " " << input->getName() << ",\n";
        }
    }

    // Output
    for (const auto& output : Utilities::getParents(opt->getOutputs())) {
        bool isArrayType = output->isArrayType();
        if (isArrayType) {
            ss << "\t"
               << Utilities::convertDataType(output->getDataType()->getSubVarMap().begin()->second->getName());
        }
        else {
            ss << "\t" << Utilities::convertDataType(output->getDataType()->getName());
        }
        ss << " &" << output->getName();
        if (isArrayType) {
            ss << "[" << output->getDataType()->getSubVarMap().size() << "]";
        }
        ss << ",\n";
    }

    // Optimized Array Inputs
    for (const auto& arrayPort : opt->getArrayPorts()) {
        for (unsigned long i = 0; i<arrayPort.second.size(); ++i) {
            ss << "\t" << Utilities::convertDataType(
                    arrayPort.first->getDataType()->getSubVarMap().begin()->second->getName())
               << " " << arrayPort.first->getDataSignal()->getName() << "_" << i << ",\n";
        }
    }

    if (hlsOption == HLSOption::MCCO) {
        // Internal Registers Input
        for (const auto reg : Utilities::getParents(opt->getInternalRegisterIn())) {
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
    for (const auto reg : Utilities::getParents(opt->getInternalRegisterOut())) {
        bool isArrayType = reg->isArrayType();
        if (isArrayType) {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getSubVarMap().begin()->second->getName());
        }
        else {
            ss << "\t" << Utilities::convertDataType(reg->getDataType()->getName());
        }
        ss << " &out_" << reg->getFullName();
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

void HLS::writeToOutput()
{
    for (const auto& output : Utilities::getParents(opt->getOutputs())) {
        ss << "\t" << output->getName() << " = " << output->getName() << "_reg;\n";
    }
    for (const auto reg : Utilities::getParents(opt->getInternalRegisterOut())) {
        ss << "\tout_" << reg->getName() << " = " << reg->getName() << "_reg;\n";
    }
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << " = " << notifySignal->getName() << "_reg;\n";
    }
}

void HLS::registerVariables()
{
    for (const auto& output : Utilities::getParents(opt->getOutputs())) {
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

    for (const auto reg : Utilities::getParents(opt->getInternalRegisterOut())) {
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

    for (auto notifySignal : propertySuite->getNotifySignals()) {
        auto resetValue = getResetValue(notifySignal);
        ss << "\tstatic bool " << notifySignal->getName() << "_reg = "
           << (resetValue ? resetValue.get() : "'0'") << ";\n";
    }

    ss << "\n";

    for (const auto reg : Utilities::getParents(opt->getInternalRegisterOut())) {
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
        ss << " = " << reg->getName() << "_reg" << ";\n";
    }
}

void HLS::dataTypes(Model* model)
{
    ss << "#ifndef DATA_TYPES_H\n";
    ss << "#define DATA_TYPES_H\n\n";
    ss << "#include \"ap_int.h\"\n\n";

    // enum of states
    ss << "// States\n"
       << "enum state {";
    for (auto state = propertySuite->getStates().begin(); state!=propertySuite->getStates().end(); ++state) {
        ss << (*state)->getName();
        if (std::next(state)!=propertySuite->getStates().end()) {
            ss << ", ";
        }
    }
    ss << "};\n\n";

    // enum of operations
    ss << "// Operations\n"
       << "enum operation {";
    auto operations = propertySuite->getOperationProperties();
    for (auto operation = operations.begin(); operation != operations.end(); ++operation) {
        ss << (*operation)->getName();
        if (std::next(operation) != operations.end()) {
            ss << ", ";
        }
    }
    if (hlsOption == HLSOption::OCCO) {
        ss << ", state_wait";
    }
    ss << "};\n\n";

    std::set<DataType*> enumTypes;
    std::set<DataType*> compoundTypes;

    auto addDataType = [&enumTypes, &compoundTypes](DataType* dataType) {
        if (dataType->isEnumType()) {
            enumTypes.insert(dataType);
        }
        else if (dataType->isCompoundType()) {
            compoundTypes.insert(dataType);
        }
    };

    for (const auto& reg : propertySuite->getVisibleRegisters()) {
        addDataType((DataType*) (reg->getDataType()));
    }
    for (const auto& func : propertySuite->getFunctions()) {
        addDataType(func->getReturnType());
    }
    for (const auto& module : model->getModules()) {
        for (auto& port : module.second->getPorts()) {
            if (port.second->isCompoundType()) {
                for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                    addDataType(subVar->getDataType());
                }
            }
            addDataType(port.second->getDataType());
        }
    }
    for (const auto& var : currentModule->getVariableMap()) {
        addDataType(var.second->getDataType());
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

    ss << "\n// Constants\n";
    for (const auto& var : opt->getVariables()) {
        if (opt->isConstant(var)) {
            ss << "const " << Utilities::convertDataType(var->getDataType()->getName())
               << " " << var->getName() << " = " << getVariableReset(var) << ";\n";
        }
    }

    ss << "\n#endif //DATA_TYPES_H";
}

void HLS::visit(DataType& node)
{
    // Enums
    if (node.isEnumType()) {
        if (node.getName().find("_SECTIONS")<node.getName().size())
            return;
        ss << "enum " << node.getName() << " {";
        for (auto enumValue = node.getEnumValueMap().begin();
             enumValue!=node.getEnumValueMap().end();
             enumValue++) {
            ss << enumValue->first;
            if (std::next(enumValue)!=node.getEnumValueMap().end())
                ss << ", ";
        }
        ss << "};\n\n";
    }
    // Structs
    else if (node.isCompoundType()) {
        ss << "struct " << node.getName() << " {\n";
        for (auto& subVar : node.getSubVarMap()) {
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
    this->ss << "#include \"Data_Types.h\"\n\n";

    // Function Prototypes
    auto functionMap = currentModule->getFunctionMap();
    for (auto& function :functionMap) {
        this->ss << Utilities::convertDataType(function.second->getReturnType()->getName()) << " "
                 << function.second->getName() << "(";
        auto parameterMap = function.second->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter!=parameterMap.end(); ++parameter) {
            this->ss << Utilities::convertDataType(parameter->second->getDataType()->getName()) << " "
                     << parameter->first;
            if (std::next(parameter)!=parameterMap.end()) {
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

void HLS::visit(Function& node)
{
    this->ss << Utilities::convertDataType(node.getReturnType()->getName()) << " " << node.getName() << "(";
    auto parameterMap = node.getParamMap();
    for (auto parameter = parameterMap.begin(); parameter!=parameterMap.end(); parameter++) {
        this->ss << Utilities::convertDataType(parameter->second->getDataType()->getName()) << " "
                 << parameter->first;
        if (parameter!=--parameterMap.end())
            this->ss << ", ";
    }
    this->ss << ") {\n";
    if (node.getReturnValueConditionList().empty()) {
        throw std::runtime_error("No return value for function "+node.getName());
    }
    auto numberOfBranches = node.getReturnValueConditionList().size();
    for (auto& returnValue : node.getReturnValueConditionList()) {
        if (!returnValue.second.empty()) {
            if (numberOfBranches>1) {
                if (numberOfBranches==node.getReturnValueConditionList().size()) {
                    ss << "\tif ((";
                }
                else {
                    ss << "else if((";
                }
                for (auto condition = returnValue.second.begin();
                     condition!=returnValue.second.end();
                     ++condition) {
                    ss << PrintStatement::toString(*condition);
                    if (std::next(condition)!=returnValue.second.end()) {
                        ss << ") && (";
                    }
                }
                ss << ")) {\n";
            }
        }
        if (node.getReturnValueConditionList().size()>1 && numberOfBranches==1) {
            ss << "else {\n";
        }
        ss << PrintStatement::toString(returnValue.first, 2, 2) << ";";
        if (node.getReturnValueConditionList().size()>1) {
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
        if (resetValue) {
            return resetValue.get();
        }
        else {
            if (opt->hasOutputReg(dataSignal)) {
                return getValue(opt->getCorrespondingRegister(dataSignal));
            }
            else {
                return dataSignal->getInitialValue()->getValueAsString();
            }
        }
    };

    if (dataSignal->isCompoundType()) {
        std::stringstream resetValueStream;
        resetValueStream << "{";
        auto subVarList = dataSignal->getSubVarList();
        for (auto subVar = subVarList.begin(); subVar!=subVarList.end(); ++subVar) {
            resetValueStream << getDataSignalValue(*subVar);
            if (std::next(subVar)!=subVarList.end()) {
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
    if (resetValue) {
        return resetValue.get();
    }
    else {
        return variable->getInitialValue()->getValueAsString();
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
            if (std::next(subVar)!=subVarList.end()) {
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
