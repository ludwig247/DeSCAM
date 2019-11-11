#include <utility>

//
// Created by tobias on 13.02.17.
//

#include <PrintStmt.h>
#include <math.h>
#include <ModelGlobal.h>
#include "PrintSkeleton.h"

std::map<std::string, std::string> PrintSkeleton::printModel(Model *node) {

    setLanguage();
    globalPackageName = node->getName();

    pluginOutput.insert(std::make_pair("globalTypes" + getFilenameExtention(), generateGlobalTypes()));

    for (auto &module: node->getModules()) {
        this->module = module.second;
        localPackageName = module.first;

        pluginOutput.insert(std::make_pair(module.first + "_types" + getFilenameExtention(), generateLocalTypes()));
        std::stringstream result;
        try {
            result << generateHDLSkeleton();
        } catch (std::runtime_error &err) {
            std::cout << "Problem with module: " << module.first << "\n";
            std::cout << err.what() << std::endl;
        }
        pluginOutput.insert(std::make_pair(module.first + getFilenameExtention(), result.str()));
    }


    return pluginOutput;
}

std::pair<std::string, std::string> PrintSkeleton::printModule(SCAM::Module *module) {
    setLanguage();

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

std::pair<std::string, std::string> PrintSkeleton::printLocalTypes(SCAM::Module *module) {
    setLanguage();

    this->module = module;
    localPackageName = module->getName();

    return std::make_pair(localPackageName + "_types" + getFilenameExtention(), generateLocalTypes());
}

std::pair<std::string, std::string> PrintSkeleton::printGlobalTypes(SCAM::Model *model) {
    setLanguage();
    globalPackageName = model->getName();

    return std::make_pair("globalTypes" + getFilenameExtention(), generateGlobalTypes());
}

////////////////
void PrintSkeleton::setLanguage() {
    if (getOptionMap()["vhdl"]) {
        language = VHDL;
    } else if (getOptionMap()["sv"]) {
        language = SV;
    } else if (getOptionMap()["sv"] && getOptionMap()["vhdl"]) {
        std::cout << "More than one language chosen. Default (VHDL) selected." << std::endl;
        language = VHDL;
    } else {
        language = VHDL;
    }

}

std::string PrintSkeleton::generateLocalTypes() {

    std::stringstream typeStream;

    printPackageHeader(typeStream, localPackageName);
    // Local enums
    auto dataTypeMap = DataTypes::getLocalDataTypeMap();
    if (dataTypeMap.empty()) {
        if (language == VHDL) {
            typeStream << "-- ";
        } else if (language == SV) {
            typeStream << "// ";
        }
        typeStream << "No local datatypes implemented!\n\n\n";
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

std::string PrintSkeleton::generateGlobalTypes() {
    std::stringstream typeStream;

    if (globalPackageName.empty()) {
        return "";
    } else {
        printPackageHeader(typeStream, globalPackageName);
        // Testcases
        if (language == VHDL) {
            typeStream << "subtype bool is Boolean;\n";
            typeStream << "subtype int is signed(31 downto 0);\n";
        }

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

std::string PrintSkeleton::generateHDLSkeleton() {


    std::stringstream skeletonStream;

    header(skeletonStream);

    ports(skeletonStream);

    registers(skeletonStream);

    resetLogic(skeletonStream);

    footer(skeletonStream);

    return skeletonStream.str();

}

void PrintSkeleton::printEnumType(std::stringstream &ss, const SCAM::DataType *enumType) {
    if (language == VHDL) {
        ss << "type " + enumType->getName() << " is (";
        for (auto iterator = enumType->getEnumValueMap().begin();
             iterator != enumType->getEnumValueMap().end(); ++iterator) {
            ss << iterator->first;
            if (iterator != --enumType->getEnumValueMap().end()) {
                ss << ", ";
            }
        }
        ss << ");\n";
    } else if (language == SV) {
        ss << "\ttypedef enum logic ";

        // SystemVerilog enum default type is integer, find a more suitable size
        int enumSize = getLog2(enumType->getEnumValueMap().size());
        if (enumSize > 0) {
            ss << "[" << enumSize << ":0] ";
        }
        ss << "{\n";
        for (auto iterator = enumType->getEnumValueMap().begin();
             iterator != enumType->getEnumValueMap().end(); ++iterator) {
            ss << "\t\t" + convertToLower(iterator->first);
            if (iterator != --enumType->getEnumValueMap().end()) {
                ss << ",\n";
            } else {
                ss << "\n";
            }
        }
        ss << "\t} " + enumType->getName() << ";\n\n";
    }
}

void PrintSkeleton::printCompoundType(std::stringstream &ss, const SCAM::DataType *compoundType) {
    if (language == VHDL) {
        ss << "type " + compoundType->getName() << " is record\n";
        for (auto subVar: compoundType->getSubVarMap()) {
            ss << "\t" + subVar.first << ": " << getDataTypeWrapper(subVar.second) << ";\n";
        }
        ss << "end record;\n";
    } else if (language == SV) {
        ss << "\ttypedef struct {\n";
        for (auto subVar: compoundType->getSubVarMap()) {
            ss << "\t\t" << getDataTypeWrapper(subVar.second) << " " << convertToLower(subVar.first) << ";\n";
        }
        ss << "\t} " << compoundType->getName() << ";\n\n";
    }
}

void PrintSkeleton::printArrayType(std::stringstream &ss, const SCAM::DataType *arrayType) {
    if (language == VHDL) {
        ss << "type " + arrayType->getName() << " is array(" << arrayType->getArraySize() - 1 << " downto 0) of ";
        ss << arrayType->getArrayType()->getName() << ";\n";
    } else if (language == SV) {
        ss << "\ttypedef " << getDataTypeWrapper(arrayType->getArrayType()) << " " << arrayType->getName();
        ss << " [0:" << arrayType->getArraySize() - 1 << "];\n\n";
    }
}

void PrintSkeleton::printPackageHeader(std::stringstream &ss, const std::string &packageName) {

    if (language == VHDL) {
        ss << "library ieee;\n";
        ss << "use IEEE.numeric_std.all;\n";
        ss << "use work.SCAM_Model_types.all;\n\n";
        ss << "package " + packageName << "_types is\n";
    } else if (language == SV) {
        ss << "package " + convertToLower(packageName) << "_types;\n\n";
        ss << "\timport scam_model_types::*;\n";

    }
}

void PrintSkeleton::printPackageFooter(std::stringstream &ss, const std::string &packageName) {
    if (language == VHDL) {
        ss << "end package " + packageName + "_types;";
    } else {
        ss << "endpackage";
    }
}


void PrintSkeleton::header(std::stringstream &ss) {
    if (language == VHDL) {
        ss << "library ieee;\n";
        ss << "use ieee.std_logic_1164.all;\n";
        ss << "use IEEE.numeric_std.all; \n";
    }
    if (!globalPackageName.empty()) {
        insertImport(ss, globalPackageName + "_types");
    }
    insertImport(ss, localPackageName + "_types");
    ss << "\n";
}


void PrintSkeleton::ports(std::stringstream &ss) {
    std::string syncNotifyType;
    std::string clockResetType;
    if (language == VHDL) {
        syncNotifyType = "bool";
        clockResetType = "std_logic";
    } else if (language == SV) {
        syncNotifyType = "logic";
        clockResetType = "logic";
    }

    if (language == VHDL) {
        ss << "entity " + module->getName() + " is\n";
        ss << "port(\t\n";
    } else if (language == SV) {
        ss << "module " + module->getName() + " (\n";
    }

    insertPortVariable(ss, "clk", getDirectionWrapper("in"), clockResetType, false);
    insertPortVariable(ss, "rst", getDirectionWrapper("in"), clockResetType, false);

    for (auto port = module->getPorts().begin(); port != module->getPorts().end(); ++port) {
        std::string name = port->first;
        auto interface = port->second->getInterface();
        std::string type = getDataTypeWrapper(port->second->getDataType());
        std::string direction = getDirectionWrapper(interface->getDirection());

        //Data signal
        bool last = (port == --module->getPorts().end());

        insertPortVariable(ss, name, direction, type,
                           last && (interface->isShared() || interface->isSlaveOut() || interface->isMasterIn()));

        //Synch signals
        if (interface->isBlocking()) {
            insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType, false);
            insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType, last);
        } else if (interface->isSlaveIn()) {
            insertPortVariable(ss, name + "_sync", getDirectionWrapper("in"), syncNotifyType, last);
        } else if (interface->isMasterOut()) {
            insertPortVariable(ss, name + "_notify", getDirectionWrapper("out"), syncNotifyType, last);
        }
    }
    if (language == VHDL) {
        ss << ");\n";
        ss << "end " + module->getName() << ";\n\n";
    } else if (language == SV) {
        ss << "\t);\n\n";
    }
}


void PrintSkeleton::registers(std::stringstream &ss) {

    if (language == VHDL) {
        ss << "architecture " + module->getName() << "_arch of " + module->getName() + " is\n";
    }
    for (auto variable: module->getVariableMap()) {
        insertRegister(ss, variable.first + "_signal", getDataTypeWrapper(variable.second->getDataType()));
    }
}

void PrintSkeleton::resetLogic(std::stringstream &ss) {

    if (language == VHDL) {
        ss << "\nbegin\n";
        ss << "\tprocess(clk)\n";
        ss << "\tbegin\n";
        ss << "\tif(clk='1' and clk'event) then\n";
        ss << "\t\tif rst = '1' then\n";
    } else if (language == SV) {
        ss << "\n\n\talways_ff @(posedge clk, posedge rst) begin\n";
        ss << "\t\tif (rst) begin\n";
    }

    int nonblockingIndentationLevel = 3;


    for (auto variable: module->getVariableMap()) {
        if (variable.second->getDataType()->isCompoundType()) {
            for (auto subVar: variable.second->getSubVarList()) {
                std::string resetValue;
                if (language == SV) {
                    if (subVar->getDataType()->getName() == "bool") {
                        resetValue = booleanWrapper(PrintStmt::toString(subVar->getInitialValue()) == "true");
                    } else {
                        resetValue = convertToLower(PrintStmt::toString(subVar->getInitialValue()));
                    }
                } else if (language == VHDL) {
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
                if (language == VHDL) {
                    arrayDefaultValue = "(others => to_signed(0, 32))";
                } else if (language == SV) {
                    arrayDefaultValue = "'{default:0}";
                }
                insertNonblockingAssignment(ss,
                                            variable.first + "_signal",
                                            arrayDefaultValue,
                                            nonblockingIndentationLevel);
            } else throw std::runtime_error("not implemented");

        } else {
            std::string name = variable.first + "_signal";
            std::string resetValue;
            if (language == SV) {
                if (variable.second->getDataType()->getName() == "bool") {
                    resetValue = booleanWrapper(PrintStmt::toString(variable.second->getInitialValue()) == "true");
                } else {
                    resetValue = convertToLower(PrintStmt::toString(variable.second->getInitialValue()));
                }
            } else if (language == VHDL) {
                if (variable.second->getDataType()->getName() == "signed") {
                    resetValue = "(others => " + PrintStmt::toString(variable.second->getInitialValue()) + ")";
                } else if (variable.second->getDataType()->isUnsigned()) {
                    resetValue = "to_unsigned(" + PrintStmt::toString(variable.second->getInitialValue()) + ", 32)";
                } else if (variable.second->getDataType()->isInteger()) {
                    resetValue = "to_signed(" + PrintStmt::toString(variable.second->getInitialValue()) + ", 32)";
                } else {
                    resetValue = PrintStmt::toString(variable.second->getInitialValue());
                }
            }
            insertNonblockingAssignment(ss, name, resetValue, nonblockingIndentationLevel);
        }

    }
    //Notify signals for ports
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
    if (language == VHDL) {
        ss << "\t\telse\n";
    } else if (language == SV) {
        ss << "\t\tend else begin\n";
    }

    if (language == VHDL) {
        ss << "\t\t\t -- FILL OUT HERE;\n";
    } else if (language == SV) {
        ss << "\t\t\t\t// FILL OUT HERE\n";
    }

    if (language == VHDL) {
        ss << "\t\tend if;\n";
        ss << "\tend if;\n";
        ss << "\tend process;\n";
    } else if (language == SV) {
        ss << "\t\tend\n";
        ss << "\tend\n";
    }

}

void PrintSkeleton::footer(std::stringstream &ss) {
    if (language == VHDL) {
        ss << "end " + module->getName() << "_arch;";
    } else if (language == SV) {
        ss << "endmodule";
    }
}

void PrintSkeleton::insertImport(std::stringstream &ss, const std::string &name) {
    if (language == VHDL) {
        ss << "use work." + name + ".all;\n";
    } else if (language == SV) {
        ss << "import " + convertToLower(name) + "::*;\n";
    }
}

void PrintSkeleton::insertPortVariable(std::stringstream &ss,
                                       const std::string &name,
                                       const std::string &direction,
                                       const std::string &type,
                                       bool last) {
    ss << "\t";

    if (language == VHDL) {
        ss << name + ":\t\t" + direction + " " + type;
        if (!last) {
            ss << ";";
        }
    } else if (language == SV) {
        ss << direction + " " + type + " " + name;
        if (!last) {
            ss << ",";
        }
    }
    ss << "\n";
}

void PrintSkeleton::insertRegister(std::stringstream &ss, const std::string &name, const std::string &type) {

    if (language == VHDL) {
        ss << "\tsignal " + name + ": " + type + ";\n";
    } else if (language == SV) {
        ss << "\t" + type + " " + name + ";\n";
    }
}

void PrintSkeleton::insertNonblockingAssignment(std::stringstream &ss, const std::string &name,
                                                const std::string &defaultValue, int indentation) {
    for (int i = 0; i < indentation; i++) {
        ss << "\t";
    }
    ss << name + " <= ";
    if (language == SV) {
        ss << convertToLower(defaultValue);
    } else {
        ss << defaultValue;
    }
    ss << ";\n";
}


std::string PrintSkeleton::getFilenameExtention() {
    switch (language) {
        case VHDL:
            return ".vhdl";
        case SV:
            return ".sv";
    }
}

std::string PrintSkeleton::convertToLower(const std::string &in_string) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : in_string)
        ret << std::tolower(i, loc);
    return ret.str();
}

int PrintSkeleton::getLog2(int arraySize) {
    if (arraySize > 2) {
        return (int) ceil(log2(arraySize) - 1.0);
    }
    return 0;
}

std::string PrintSkeleton::getDirectionWrapper(const std::string &in) {
    if (language == SV) {
        if (in == "in") return "input";
        return "output";
    } else if (language == VHDL) {
        return in;
    }
}

std::string PrintSkeleton::getDataTypeWrapper(const SCAM::DataType *dataType) {
    if (language == SV) {
        if (dataType->isInteger()) {
            return "integer";
        } else if (dataType->isUnsigned()) {
            return "bit[31:0]";
        } else if (dataType->getName() == "bool") {
            return "bit";
        } else {
            return dataType->getName();
        }
    } else {
        if (dataType->isInteger()) {
            //if (variable.second->getDataType()->getName() == "unsigned" || variable.second->getDataType()->getName() == "signed") {
            //return "signed (31 downto 0)";
            return "int";
        } else if (dataType->isUnsigned()) {
            return "unsigned (31 downto 0)";
        }
        return dataType->getName();
    }
}

std::string PrintSkeleton::booleanWrapper(bool value) {
    if (language == SV) {
        if (value) return "1'b1";
        else return "1'b0";
    } else if (language == VHDL) {
        if (value) return "true";
        else return "false";
    }
}
