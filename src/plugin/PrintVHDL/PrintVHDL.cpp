
//
// Created by schmitz on 20.06.20.
//
#include <utility>
#include <PrintStmt.h>
#include <math.h>
#include <ModelGlobal.h>
#include "PrintVHDL.h"

std::map<std::string, std::string> PrintVHDL::printModel(Model *node) {

    model = node;
    globalPackageName = node->getName();
    setBitwidth();
    pluginOutput.insert(std::make_pair("globalTypes" + getFilenameExtention(), generateGlobalTypes()));
    if (!node->getGlobalVariableMap().empty()) {
        pluginOutput.insert(std::make_pair("globalDefines" + getFilenameExtention(), generateGlobalDefs()));
    }


    for (auto &module: node->getModules()) {
        this->module = module.second;
        localPackageName = module.first;
        pluginOutput.insert(std::make_pair(module.first + "_types" + getFilenameExtention(), generateLocalTypes()));
        std::stringstream result;
        try {
            result << generateHDLSkeleton();
            pluginOutput.insert(std::make_pair(module.first + getFilenameExtention(), result.str()));
        } catch (std::runtime_error &err) {
            std::cout << "Problem with module: " << module.first << "\n";
            std::cout << err.what() << std::endl;
        }
    }
    return pluginOutput;
}

std::pair<std::string, std::string> PrintVHDL::printModule(SCAM::Module *module) {


    globalPackageName = ModelGlobal::getModel()->getName();

    this->module = module;
    localPackageName = module->getName();

    std::stringstream result;
    try {
        result << generateHDLSkeleton();
    } catch (std::runtime_error &err) {
        std::cout << "Problem with module: " << module->getName() << "\n";
        std::cout << err.what() << std::endl;
    }
    return std::make_pair(module->getName() + getFilenameExtention(), result.str());
}

std::pair<std::string, std::string> PrintVHDL::printLocalTypes(SCAM::Module *module) {

    globalPackageName = ModelGlobal::getModel()->getName();
    this->module = module;
    localPackageName = module->getName();


    return std::make_pair(localPackageName + "_types" + getFilenameExtention(), generateLocalTypes());
}

std::pair<std::string, std::string> PrintVHDL::printGlobalTypes(SCAM::Model *model) {

    globalPackageName = model->getName();

    return std::make_pair("globalTypes" + getFilenameExtention(), generateGlobalTypes());
}

std::string PrintVHDL::generateLocalTypes() {

    std::stringstream typeStream;

    printPackageHeader(typeStream, localPackageName);
    // Local enums
    auto dataTypeMap = DataTypes::getLocalDataTypeMap();
    if (dataTypeMap.empty()) {
        typeStream << "-- No local datatypes implemented!\n\n\n";
    } else {
        if (DataTypes::hasLocalDataTypes(module->getName())) {
            // There is a map for this module
            if (!DataTypes::getLocalDataTypes(module->getName()).empty()) {
                for (auto type: DataTypes::getLocalDataTypes(module->getName())) {
                    if (type.second->isEnumType()) {
                        printEnumType(typeStream, type.second);
                    }
                }
                // Local composite types
                for (auto type: DataTypes::getLocalDataTypes(module->getName())) {
                    if (type.second->isCompoundType()) {
                        printCompoundType(typeStream, type.second);
                    }
                    if (type.second->isArrayType()) {
                        printArrayType(typeStream, type.second);
                    }
                }
            }
        }
    }
    printPackageFooter(typeStream, localPackageName);
    return typeStream.str();
}

void PrintVHDL::setBitwidth() {
    //TODO: Fix command line param int
    if (getOptionMap()["b1"]) {
        bitwidth = 1;
    } else if (getOptionMap()["b4"]) {
        bitwidth = 4;
    } else if (getOptionMap()["b8"]) {
        bitwidth = 8;
    } else if (getOptionMap()["b16"]) {
        bitwidth = 16;
    } else {
        bitwidth = 32;
    }
}


std::string PrintVHDL::generateGlobalTypes() {
    std::stringstream typeStream;

    if (globalPackageName.empty()) {
        return "";
    } else {
        printPackageHeader(typeStream, globalPackageName);
        // Testcases
        typeStream << "subtype bool is Boolean;\n";
        typeStream << "subtype int is signed(31 downto 0);\n";


        // Global enums
        for (auto type: DataTypes::getDataTypeMap()) {
            if (type.second->isEnumType()) {
                printEnumType(typeStream, type.second);
            }
        }
        // Global composite types
        for (auto type: DataTypes::getDataTypeMap()) {
            if (type.second->isCompoundType()) {
                printCompoundType(typeStream, type.second);
            }
            if (type.second->isArrayType()) {
                printArrayType(typeStream, type.second);
            }
        }
        printPackageFooter(typeStream, globalPackageName);
        return typeStream.str();
    }
}

std::string PrintVHDL::generateHDLSkeleton() {

    std::stringstream skeletonStream;
    header(skeletonStream);
    ports(skeletonStream);
    registers(skeletonStream);
    if(module->isStructural()) {
        channels(skeletonStream);
        components(skeletonStream);
        instances(skeletonStream);
    }
    resetLogic(skeletonStream);
    footer(skeletonStream);
    return skeletonStream.str();

}

void PrintVHDL::printEnumType(std::stringstream &ss, const SCAM::DataType *enumType) {
    ss << "type " + enumType->getName() << " is (";
    for (auto iterator = enumType->getEnumValueMap().begin();
         iterator != enumType->getEnumValueMap().end(); ++iterator) {
        ss << iterator->first;
        if (iterator != --enumType->getEnumValueMap().end()) {
            ss << ", ";
        }
    }
    ss << ");\n";

}

void PrintVHDL::printCompoundType(std::stringstream &ss, const SCAM::DataType *compoundType) {

    ss << "type " + compoundType->getName() << " is record\n";
    for (auto subVar: compoundType->getSubVarMap()) {
        ss << "\t" + subVar.first << ": " << getDataTypeWrapper(subVar.second) << ";\n";
    }
    ss << "end record;\n";

}

void PrintVHDL::printArrayType(std::stringstream &ss, const SCAM::DataType *arrayType) {
    ss << "type " + arrayType->getName() << " is array(" << arrayType->getArraySize() - 1 << " downto 0) of ";
    ss << arrayType->getArrayType()->getName() << ";\n";

}

void PrintVHDL::printPackageHeader(std::stringstream &ss, const std::string &packageName) {
        ss << "library ieee;\n";
        ss << "use IEEE.numeric_std.all;\n";
        ss << "use work." << globalPackageName << "_types.all;\n\n";
        ss << "package " + packageName << "_types is\n";
}

void PrintVHDL::printPackageFooter(std::stringstream &ss, const std::string &packageName) {
    ss << "end package " + packageName + "_types;";
}


void PrintVHDL::header(std::stringstream &ss) {

    ss << "library ieee;\n";
    ss << "use ieee.std_logic_1164.all;\n";
    ss << "use IEEE.numeric_std.all; \n";

    if (!globalPackageName.empty()) {
        insertImport(ss, globalPackageName + "_types");
    }
    insertImport(ss, localPackageName + "_types");
    ss << "\n";
}


void PrintVHDL::ports(std::stringstream &ss) {
    std::string syncNotifyType;
    std::string clockResetType;

    syncNotifyType = "bool";
    clockResetType = "std_logic";


    ss << "entity " + module->getName() + " is\n";
    ss << "port(\t\n";


    insertPortVariable(ss, "clk", getDirectionWrapper("in"), clockResetType);
    insertPortVariable(ss, "rst", getDirectionWrapper("in"), clockResetType);

    for (auto port = module->getPorts().begin(); port != module->getPorts().end(); ++port) {
        std::string name = port->first;
        auto interface = port->second->getInterface();
        std::string type = getDataTypeWrapper(port->second->getDataType());
        std::string direction = getDirectionWrapper(interface->getDirection());

        //Data signal
        bool last = (port == --module->getPorts().end());

        if( port->second->getDataType()->isCompoundType() && bitwidth != 32) {
            for (const auto &subvar: port->second->getDataType()->getSubVarMap()) {

                name = port->first + "_" + subvar.first;
                type = getDataTypeWrapper_Port(subvar.second);
                insertPortVariable(ss, name, direction, type);
            }
        } else {
            insertPortVariable(ss, name, direction, type);

        }
        name = port->first;
        //Synch signals
        if (interface->isBlocking()) {
            insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType);
            insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType);
        } else if (interface->isSlaveIn()) {
            insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType);
        } else if (interface->isMasterOut()) {
            insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType);
        }
    }
    if (module->isStructural()) {


        auto channelmap = module->getModuleInstanceMap().begin()->second->getParentInstance()->getChannelMap();

        for (auto channelit = channelmap.begin(); channelit != channelmap.end(); ++channelit) {

            auto channel = channelit->second;
            //Data signal
            Port *port;
            std::string direction;
            bool last = (channelit == --channelmap.end());

            //If the channel is not complete a new port has to be added
            if (channel->getFromPort() == nullptr) {
                port = channel->getToPort();
                direction = getDirectionWrapper(channel->getToPort()->getInterface()->getDirection());

            } else if (channel->getToPort() == nullptr) {
                port = channel->getFromPort();
                direction = getDirectionWrapper(channel->getFromPort()->getInterface()->getDirection());
            }
                //If the channel is connected to an Instance higher than its parent it has to be added as port
            else if (channel->getFromInstance()->getLevel() <=
                     module->getModuleInstanceMap().begin()->second->getParentInstance()->getLevel()) {
                port = channel->getFromPort();
                direction = getDirectionWrapper(channel->getToPort()->getInterface()->getDirection());

            } else if (channel->getToInstance()->getLevel() <=
                       module->getModuleInstanceMap().begin()->second->getParentInstance()->getLevel()) {
                port = channel->getToPort();
                direction = getDirectionWrapper(channel->getFromPort()->getInterface()->getDirection());
            } else {
                continue;
            }
            std::string name = channelit->first + "_port";
            auto interface = port->getInterface();
            std::string type = getDataTypeWrapper(port->getDataType());

            if (port->getDataType()->isCompoundType() && bitwidth != 32) {
                for (const auto &subvar: port->getDataType()->getSubVarMap()) {

                    name = name + "_" + port->getName() + "_" + subvar.first;
                    type = getDataTypeWrapper_Port(subvar.second);
                    insertPortVariable(ss, name, direction, type);
                }
            } else {
                insertPortVariable(ss, name, direction, type);

            }
            name = channelit->first + "_port";
            //Synch signals
            if (interface->isBlocking()) {
                insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType);
                insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType);
            } else if (interface->isSlaveIn()) {
                insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType);
            } else if (interface->isMasterOut()) {
                insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType);
            }
        }
    }
    std::string str = ss.str();
    str.pop_back();
    str.pop_back();
    ss.str(std::string());
    ss << str;
    ss << "\n);\n";
    ss << "end " + module->getName() << ";\n\n";

}


void PrintVHDL::registers(std::stringstream &ss) {

    ss << "architecture " + module->getName() << "_arch of " + module->getName() + " is\n";

    std::set<Variable *> usedParents;
    for (const auto &variable: module->getVariableMap()) {
        //Don't print all sub-array elemtns ... only print parent once
        if (variable.second->isArrayElement()) {
            if (usedParents.insert(variable.second->getParent()).second) {
                insertRegister(ss, variable.second->getParent()->getName() + "_signal", getDataTypeWrapper(variable.second->getParent()->getDataType()));
            }
        } else if (variable.second->isSubVar() && variable.second->getParent()->isCompoundType()) {
            //Only consider first element
            if (usedParents.insert(variable.second->getParent()).second) {
                insertRegister(ss, variable.second->getParent()->getName() + "_signal", getDataTypeWrapper(variable.second->getParent()->getDataType()));
            }

        } else insertRegister(ss, variable.first + "_signal", getDataTypeWrapper(variable.second->getDataType()));
    }
}

void PrintVHDL::resetLogic(std::stringstream &ss) {


    if(!module->isStructural()) {
        ss << "\nbegin\n";
    }
    ss << "\tprocess(clk)\n";
    ss << "\tbegin\n";
    ss << "\tif(clk='1' and clk'event) then\n";
    ss << "\t\tif rst = '1' then\n";


    int nonblockingIndentationLevel = 3;

    for (auto variable: module->getVariableMap()) {
        if (variable.second->isArrayElement() && variable.second->getName() != "0") continue; //Skip all other array elements
        if (variable.second->getDataType()->isCompoundType()) {
            for (auto subVar: variable.second->getSubVarList()) {
                std::string resetValue;
                if (subVar->getDataType()->getName() == "signed") {
                    resetValue = "(others <= " + PrintStmt::toString(subVar->getInitialValue()) + ")";
                } else if (subVar->getDataType()->isUnsigned()) {
                    resetValue = "to_unsigned(" + PrintStmt::toString(subVar->getInitialValue()) + ", 32)";
                } else if (subVar->getDataType()->isInteger()) {
                    resetValue = "to_signed(" + PrintStmt::toString(subVar->getInitialValue()) + ", 32)";
                } else if (subVar->isArrayType()) {
                    resetValue = "(others => to_signed(0, 32)";
                } else {
                    resetValue = PrintStmt::toString(subVar->getInitialValue());
                }

                //insertNonblockingAssignment(ss,
                //                            variable.first + "_signal." + subVar->getName(),
                //                            PrintStmt::toString(subVar->getInitialValue()),
                //                            nonblockingIndentationLevel);
                insertNonblockingAssignment(ss, variable.first + "_signal." + subVar->getName(), resetValue,
                                            nonblockingIndentationLevel);
            }

        } else if (variable.second->isArrayType()) {

            if (variable.second->getDataType()->getArrayType()->isInteger()) {
                std::string arrayDefaultValue;

                arrayDefaultValue = "(others => to_signed(0, 32))";

                insertNonblockingAssignment(ss,
                                            variable.first + "_signal",
                                            arrayDefaultValue,
                                            nonblockingIndentationLevel);
            } else throw std::runtime_error("not implemented");

        } else if (variable.second->isArrayElement() && variable.second->getName() == "0") {

            if (variable.second->getParent()->getDataType()->getArrayType()->isInteger()) {
                std::string arrayDefaultValue;

                arrayDefaultValue = "(others => to_signed(0, 32))";

                insertNonblockingAssignment(ss,
                                            variable.second->getParent()->getFullName() + "_signal",
                                            arrayDefaultValue,
                                            nonblockingIndentationLevel);
            } else throw std::runtime_error("not implemented");

        } else {
            std::string name = variable.first + "_signal";
            if(variable.second->isSubVar() && !variable.second->isArrayElement()){
                name = variable.second->getParent()->getName() +"_signal." + variable.second->getName();
            }
            std::string resetValue;

            if (variable.second->getDataType()->getName() == "signed") {
                resetValue = "(others => " + PrintStmt::toString(variable.second->getInitialValue()) + ")";
            } else if (variable.second->getDataType()->isUnsigned()) {
                resetValue = "to_unsigned(" + PrintStmt::toString(variable.second->getInitialValue()) + ", 32)";
            } else if (variable.second->getDataType()->isInteger()) {
                resetValue = "to_signed(" + PrintStmt::toString(variable.second->getInitialValue()) + ", 32)";
            } else {
                resetValue = PrintStmt::toString(variable.second->getInitialValue());
            }

            insertNonblockingAssignment(ss, name, resetValue, nonblockingIndentationLevel);
        }

    }
    //Notify signals for ports
    if (! module->isStructural()) {
        auto opList = module->getFSM()->getStateMap().at(0)->getOutgoingOperationsList();
        assert(opList.size() == 1);
        for (auto port: module->getPorts()) {
            // interfaces without notify signals
            if (port.second->getInterface()->isShared()) continue;
            if (port.second->getInterface()->isMasterIn()) continue;
            if (port.second->getInterface()->isSlaveIn()) continue;
            if (port.second->getInterface()->isSlaveOut()) continue;
            // interfaces with notify signals
            if (opList.at(0)->getNextState()->getCommunicationPort() == port.second) {
                insertNonblockingAssignment(ss, port.first + "_notify", booleanWrapper(true), nonblockingIndentationLevel);
            } else {
                insertNonblockingAssignment(ss, port.first + "_notify", booleanWrapper(false), nonblockingIndentationLevel);
            }
        }
    }

    ss << "\t\telse\n";



    ss << "\t\t\t -- FILL OUT HERE;\n";


    ss << "\t\tend if;\n";
    ss << "\tend if;\n";
    ss << "\tend process;\n";


}

void PrintVHDL::footer(std::stringstream &ss) {
    ss << "end " + module->getName() << "_arch;";
}

void PrintVHDL::insertImport(std::stringstream &ss, const std::string &name) {
    ss << "use work." + name + ".all;\n";
}

void PrintVHDL::insertPortVariable(std::stringstream &ss,
                                       const std::string &name,
                                       const std::string &direction,
                                       const std::string &type) {
    ss << "\t";
    ss << name + ":\t\t" + direction + " " + type << ";\n";

}

void PrintVHDL::insertRegister(std::stringstream &ss, const std::string &name, const std::string &type) {

    ss << "\tsignal " + name + ": " + type + ";\n";

}

void PrintVHDL::insertNonblockingAssignment(std::stringstream &ss, const std::string &name,
                                                const std::string &defaultValue, int indentation) {
    for (int i = 0; i < indentation; i++) {
        ss << "\t";
    }
    ss << name + " <= ";
    ss << defaultValue;
    ss << ";\n";
}


std::string PrintVHDL::getFilenameExtention() {

    return ".vhdl";

}

std::string PrintVHDL::convertToLower(const std::string &in_string) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : in_string)
        ret << std::tolower(i, loc);
    return ret.str();
}

int PrintVHDL::getLog2(int arraySize) {
    if (arraySize > 2) {
        return (int) ceil(log2(arraySize) - 1.0);
    }
    return 0;
}

std::string PrintVHDL::getDirectionWrapper(const std::string &in) {

    return in;

}

std::string PrintVHDL::getDataTypeWrapper_Port(const SCAM::DataType *dataType) {
    std::stringstream ss;
    if (dataType->isInteger()) {
        //if (variable.second->getDataType()->getName() == "unsigned" || variable.second->getDataType()->getName() == "signed") {
        //return "signed (31 downto 0)";

        ss << "signed";
        if(bitwidth > 1){
           ss << "(" << bitwidth-1 << " downto 0)";
        }
        return ss.str();
    } else if (dataType->isUnsigned()) {
        ss << "unsigned";
        if(bitwidth > 1){
            ss << "(" << bitwidth-1 << " downto 0)";
        }
        return ss.str();
    }
    return dataType->getName();

}

std::string PrintVHDL::getDataTypeWrapper(const SCAM::DataType *dataType) {
    std::stringstream ss;
    if (dataType->isInteger()) {
        //if (variable.second->getDataType()->getName() == "unsigned" || variable.second->getDataType()->getName() == "signed") {
        //return "signed (31 downto 0)";
        ss << "signed(31 downto 0)";
        return ss.str();
    } else if (dataType->isUnsigned()) {
        ss << "unsigned(31 downto 0)";
        return ss.str();
    }
    return dataType->getName();

}

std::string PrintVHDL::booleanWrapper(bool value) {

    if (value) return "true";
    else return "false";

}

std::string PrintVHDL::generateGlobalDefs() {
    std::stringstream ss;
    for (auto var :  ModelGlobal::getModel()->getGlobalVariableMap()) {
        ss << "constant " << var.first << " ";
        ss << var.second->getDataType()->getName();
        ss << " := " << PrintStmt::toString(var.second->getInitialValue()) << ";\n";
    }
    return ss.str();
}


void PrintVHDL::components(std::stringstream &ss) {

    if (!module->isStructural()) {
        return;
    }
    std::map<std::string, bool> added;
    for (auto inst: module->getModuleInstanceMap()) {
        SCAM::Module* child = inst.second->getStructure();
        if(added.find(child->getName()) == added.end()) {

            ss << "\tcomponent " + child->getName() + "\n";
            ports(ss, child);
            ss << "\tend component;\n\n";

        }

        added.insert(std::make_pair(child->getName(), true));
    }
}

void PrintVHDL::ports(std::stringstream &ss, SCAM::Module* child) {

    std::string syncNotifyType;
    std::string clockResetType;
    syncNotifyType = "bool";
    clockResetType = "std_logic";


    ss << "\tport(\t\n";

    ss << "\t";
    insertPortVariable(ss, "clk", getDirectionWrapper("in"), clockResetType);
    ss << "\t";
    insertPortVariable(ss, "rst", getDirectionWrapper("in"), clockResetType);

    for (auto port = child->getPorts().begin(); port != child->getPorts().end(); ++port) {

        std::string name = port->first;
        auto interface = port->second->getInterface();
        std::string type = getDataTypeWrapper(port->second->getDataType());
        std::string direction = getDirectionWrapper(interface->getDirection());
        bool last = (port == --child->getPorts().end());
        if( port->second->getDataType()->isCompoundType() && bitwidth != 32) {
            for (const auto &subvar: port->second->getDataType()->getSubVarMap()) {
                ss << "\t";
                name = port->first + "_" + subvar.first;
                type = getDataTypeWrapper_Port(subvar.second);
                insertPortVariable(ss, name, direction, type);
            }
            auto datatype = port->second->getDataType();


        } else {
            ss << "\t";
            insertPortVariable(ss, name, direction, type);

        }
        name = port->first;
        //Data signal


        //Synch signals
        if (interface->isBlocking()) {
            ss << "\t";
            insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType);
            ss << "\t";
            insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType);
        } else if (interface->isSlaveIn()) {
            ss << "\t";
            insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType);
        } else if (interface->isMasterOut()) {
            ss << "\t";
            insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType);
        }
    }
    ss << "\t);\n";


}

void PrintVHDL::channels(std::stringstream &ss) {
    int currentLevel = model->getMaxLevel();
    while(currentLevel >= 0) {
        std::vector<ModuleInstance*> queue = model->getInstancesAtLevel(currentLevel);
        while (!queue.empty()) {
            auto mod = queue.front()->getStructure();
            auto inst = queue.front();
            if (mod->getName() == module->getName()) {
                for (auto channels: inst->getChannelMap()) {
                    std::string datatype;
                    SCAM::Port* port;
                    //If one of the channel targets has a higher or equal level than the instance it must be a port
                    if (channels.second->getToPort() == nullptr || channels.second->getFromPort() == nullptr) {
                        continue;
                    }
                    else if(channels.second->getFromInstance()->getLevel()  <= inst->getLevel() ) {
                        continue;
                    } else if(channels.second->getToInstance()->getLevel()  <= inst->getLevel()) {
                        continue;
                    }

                    if(channels.second->getToPort() == nullptr) {
                        port = channels.second->getFromPort();

                    } else {
                        port = channels.second->getToPort();
                    }
                    if( port->getDataType()->isCompoundType() && bitwidth != 32) {
                        for (const auto &subvar: port->getDataType()->getSubVarMap()) {

                            std::string name = channels.first + "_" + subvar.first;
                            std::string type = getDataTypeWrapper_Port(subvar.second);
                            ss << "\tsignal " + name + ": " + type + ";\n";
                        }
                    } else {
                        ss << "\tsignal " + channels.first+ ": " + getDataTypeWrapper(port->getDataType()) + ";\n";

                    }
                    std::string name = channels.first;
                    std::string to_inst = channels.second->getToInstance()->getName();
                    std::string from_inst = channels.second->getFromInstance()->getName();

                    auto interface = port->getInterface();
                    if (interface->isBlocking()) {
                        ss<<"\tsignal " << name + "_" + from_inst + "_notify" <<": " << "bool" << ";\n";
                        ss<<"\tsignal " << name + "_" + to_inst + "_notify" <<": " <<  "bool" << ";\n";

                    } else if (interface->isSlaveIn()) {
                        ss<<"\tsignal " << name + "_" + from_inst + "_notify" <<": " << "bool" << ";\n";
                    } else if (interface->isMasterOut()) {
                        ss<<"\tsignal " << name + "_" + from_inst + "_notify" <<": " << "bool" << ";\n";
                    }
                }
            }
            queue.erase(queue.begin());
        }
        currentLevel--;
    }
    ss << "\n";
}

void PrintVHDL::instances(std::stringstream &ss) {
    //At the moment VHDL only
    ss << "begin\n";
    for (auto inst: module->getModuleInstanceMap()) {
        std::string syncNotifyType = "bool";
        std::string clockResetType = "std_logic";

        SCAM::Module *child = inst.second->getStructure();
        ss << "\t" + inst.second->getName() + "_inst" + ": " + inst.second->getStructure()->getName() + "\n";
        ss << "\tport map(\n";
        ss << "\t\tclk\t=>\tclk,\n";
        ss << "\t\trst\t=>\trst,\n";


        for (auto port = child->getPorts().begin(); port != child->getPorts().end(); ++port) {
            SCAM::Channel *channel = nullptr;
            SCAM::PortMapChannel *portMapChannel = nullptr;
            std::string channelname;
            for (const auto &chan: inst.second->getParentInstance()->getChannelMap()) {
                //Compare instances and ports to make sure
                if (chan.second->getFromPort() == port->second || chan.second->getToPort() == port->second) {
                    if (chan.second->getFromInstance() == inst.second || chan.second->getToInstance() == inst.second) {
                        channel = chan.second;
                        channelname = chan.first;
                        break;
                    }
                }
            }
            //If the channel has not been found in the parent module it has to be declared in another scope
            if (channel == nullptr) {
                for (const auto &subinst: inst.second->getParentInstance()->getSubmoduleInstances()) {
                    for (const auto &chan: subinst.second->getChannelMap()) {
                        if (chan.second->getFromPort() == port->second || chan.second->getToPort() == port->second) {
                            if (chan.second->getFromInstance() == inst.second ||
                                chan.second->getToInstance() == inst.second) {
                                channel = chan.second;
                                channelname = chan.first;
                                break;
                            }
                        }
                    }
                }
            }
            //If there is still no channel it has to be a PortMap
            if (channel == nullptr) {
                for (const auto &chan: inst.second->getParentInstance()->getPortMapChannelMap()) {

                    if (chan.second->getHigherPort() == port->second || chan.second->getLowerPort() == port->second) {
                        if (chan.second->getHigherInstance() == inst.second ||
                            chan.second->getLowerInstance() == inst.second) {
                            channelname = chan.first;
                            portMapChannel = chan.second;
                            break;
                        }
                    }
                }
            }

            if (channel != nullptr) {
                bool portmap = false;
                if (channel->getFromPort() == nullptr || channel->getToPort() == nullptr) {
                    portmap = true;
                    channelname = channel->getName() + "_port";
                }
                else if (channel->getToInstance()->getLevel() <= channel->getParentInstance()->getLevel()) {
                    channelname = channel->getName() + "_port";
                    portmap = true;
                } else if (channel->getFromInstance()->getLevel() <= channel->getParentInstance()->getLevel()) {
                    channelname = channel->getName() + "_port";
                    portmap = true;
                }
                if (port->second->getDataType()->isCompoundType() && bitwidth != 32) {
                    for (auto subvar = port->second->getDataType()->getSubVarMap().begin();
                         subvar != port->second->getDataType()->getSubVarMap().end(); ++subvar) {
                        //for(const auto &subvar: port->second->getDataType()->getSubVarMap()) {
                        bool last = (subvar == --port->second->getDataType()->getSubVarMap().end());

                        ss << "\t\t" << port->first << "_" << subvar->first << "\t=>\t" << channelname << "_"
                           << subvar->first;
                        if (!last) ss << ",\n";
                    }
                } else {
                    ss << "\t\t" << port->first << "\t=>\t" << channelname;
                }
                std::string name = port->first;
                auto interface = port->second->getInterface();
                //Data signal
                ss << ",\n";

                if (interface->isBlocking()) {
                    if (port->second == channel->getToPort()) {
                        if (!portmap) {
                            ss << "\t\t" << name + "_sync" << "\t=>\t"
                               << channelname + "_" + channel->getFromInstance()->getName() + "_notify" << ",\n";
                            ss << "\t\t" << name + "_notify" << "\t=>\t"
                               << channelname + "_" + channel->getToInstance()->getName() + "_notify" << ",\n";
                        } else {
                            ss << "\t\t" << name + "_sync" << "\t=>\t" << channelname + "_sync" << ",\n";
                            ss << "\t\t" << name + "_notify" << "\t=>\t" << channelname + "_notify" << ",\n";
                        }
                    } else {
                        if (!portmap) {
                            ss << "\t\t" << name + "_sync" << "\t=>\t"
                               << channelname + "_" + channel->getToInstance()->getName() + "_notify" << ",\n";
                            ss << "\t\t" << name + "_notify" << "\t=>\t"
                               << channelname + "_" + channel->getFromInstance()->getName() + "_notify" << ",\n";
                        } else {
                            ss << "\t\t" << name + "_sync" << "\t=>\t" << channelname + "_sync" << ",\n";
                            ss << "\t\t" << name + "_notify" << "\t=>\t" << channelname + "_notify" << ",\n";
                        }
                    }

                } else if (interface->isSlaveIn()) {
                    if (port->second == channel->getToPort()) {
                        if (!portmap) {
                            ss << "\t\t" << name + "_sync" << "\t=>\t"
                               << channelname + "_" + channel->getFromInstance()->getName() + "_notify" << ",\n";
                        } else {
                            ss << "\t\t" << name + "_sync" << "\t=>\t" << channelname + "_sync" << ",\n";
                        }
                    } else {
                        if (!portmap) {
                            ss << "\t\t" << name + "_sync" << "\t=>\t"
                               << channelname + "_" + channel->getToInstance()->getName() + "_notify" << ",\n";
                        } else {
                            ss << "\t\t" << name + "_sync" << "\t=>\t" << channelname + "_sync" << ",\n";
                        }
                    }
                } else if (interface->isMasterOut()) {
                    if (port->second == channel->getToPort()) {
                        if (!portmap) {
                            ss << "\t\t" << name + "_notify" << "\t=>\t"
                               << channelname + "_" + channel->getFromInstance()->getName() + "_notify" << ",\n";
                        } else {
                            ss << "\t\t" << name + "_notify" << "\t=>\t" << channelname + "_notify" << ",\n";
                        }
                    } else {
                        if (!portmap) {
                            ss << "\t\t" << name + "_notify" << "\t=>\t"
                               << channelname + "_" + channel->getToInstance()->getName() + "_notify" << ",\n";
                        } else {
                            ss << "\t\t" << name + "_notify" << "\t=>\t" << channelname + "_notify" << ",\n";
                        }
                    }
                }
            } else if (portMapChannel != nullptr) {

                if (port->second->getDataType()->isCompoundType() && bitwidth != 32) {
                    for (auto subvar = port->second->getDataType()->getSubVarMap().begin();
                         subvar != port->second->getDataType()->getSubVarMap().end(); ++subvar) {
                        bool last = (subvar == --port->second->getDataType()->getSubVarMap().end());

                        ss << "\t\t" << port->first << "_" << subvar->first << "\t=>\t"
                           << portMapChannel->getHigherPort()->getName() << "_" << subvar->first;
                        if (!last) ss << ",\n";
                    }
                } else {
                    ss << "\t\t" << port->first << "\t=>\t" << portMapChannel->getHigherPort()->getName();
                }
                std::string name = port->first;
                auto interface = port->second->getInterface();
                //Data signal


                //Synch signals
                ss << ",\n";

                if (interface->isBlocking()) {

                    ss << "\t\t" << name + "_sync" << "\t=>\t" << portMapChannel->getHigherPort()->getName() + "_sync"
                       << ",\n";
                    ss << "\t\t" << name + "_notify" << "\t=>\t"
                       << portMapChannel->getHigherPort()->getName() + "_notify" << ",\n";


                } else if (interface->isSlaveIn()) {
                    ss << "\t\t" << name + "_sync" << "\t=>\t" << portMapChannel->getHigherPort()->getName() + "_sync"
                       << ",\n";

                } else if (interface->isMasterOut()) {

                    ss << "\t\t" << name + "_notify" << "\t=>\t"
                       << portMapChannel->getHigherPort()->getName() + "_notify" << ",\n";

                }

            }

        }
        std::string str = ss.str();
        str.pop_back();
        str.pop_back();
        ss.str(std::string());
        ss << str;
        ss << "\n\t);\n\n";
    }
}
