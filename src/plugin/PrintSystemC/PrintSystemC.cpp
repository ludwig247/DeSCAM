//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include "PrintSystemC.h"

std::map<std::string, std::string> PrintSystemC::printModel(Model *node) {
    pluginOutput.insert(std::make_pair("CMakeLists.txt", Text_CMake()));

    this->ss.str("");
    Text_DataTypes();
    pluginOutput.insert(std::make_pair("Data_Types.h", ss.str()));

    this->ss.str("");
    node->accept(*this);
    this->ss << std::endl;
    pluginOutput.insert(std::make_pair("sc_main.cpp", ss.str()));

    for (auto &module: node->getModules()) {
        std::string Mname = module.second->getName();
        this->ss.str("");
        this->ss << "#ifndef SYSTEMC_" << Mname << "_H" << std::endl;
        this->ss << "#define SYSTEMC_" << Mname << "_H" << std::endl << std::endl;
        module.second->accept(*this);
        this->ss << std::endl;
        this->ss << std::endl << "#endif //SYSTEMC_" << Mname << "_H" << std::endl;
        pluginOutput.insert(std::make_pair(Mname + "_generated.h", this->ss.str()));
    }
    return pluginOutput;
}

////////////////

std::string PrintSystemC::Text_CMake() {
    std::stringstream result;
    result << "cmake_minimum_required(VERSION 2.8)" << std::endl
           << "project(SCAM_SYSTEMC CXX C)" << std::endl
           << std::endl
           << "set(CMAKE_CXX_FLAGS  \"${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} \")" << std::endl
           << "set (CMAKE_MODULE_LINKER_FLAGS \"-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z\")"
           << std::endl
           << std::endl
           << "include_directories(" << SCAM_HOME << "/include)" << std::endl
           << "link_directories(" << SCAM_HOME << "/lib)" << std::endl
           << "include_directories(" << SCAM_HOME << "/example/Interfaces/)" << std::endl
           << std::endl
           << "add_executable(SCAM_SYSTEMC sc_main.cpp)" << std::endl
           << "target_link_libraries(SCAM_SYSTEMC systemc)" << std::endl;
    return result.str();
}

void PrintSystemC::Text_DataTypes() {
    this->ss << "#ifndef DATA_TYPES_H" << std::endl;
    this->ss << "#define DATA_TYPES_H" << std::endl << std::endl;
    // enum should show before the compound type because it might be used there
    for (auto &type: DataTypes::getDataTypeMap()) {
        if (type.second->isEnumType())
            type.second->accept(*this);
    }
    for (auto &type: DataTypes::getDataTypeMap()) {
        if (type.second->isCompoundType())
            type.second->accept(*this);
    }
    this->ss << std::endl;
    this->ss << std::endl << "#endif //DATA_TYPES_H" << std::endl;
}

void PrintSystemC::printSpace(unsigned int size) {
    for (int i = 0; i < size; ++i) {
        ss << " ";
    }
}

void PrintSystemC::visit(Model &node) {
    this->ss << "#include \"systemc.h\"" << std::endl;
    this->ss << "#include \"Interfaces.h\"" << std::endl;
    this->ss << "#include \"Data_Types.h\"" << std::endl;
    for (auto &module: node.getModules()) {
        this->ss << "#include \"" << module.second->getName() << "_generated.h\"" << std::endl;
    }
    this->ss << "using namespace std;" << std::endl;
    this->ss << std::endl;

    this->ss << "int sc_main(int, char **) {" << std::endl << std::endl;
    this->indent += this->indentSize;
    for (auto &&item : node.getTopInstance()->getModuleInstances()) {
        item.second->accept(*this);
    }
    this->ss << std::endl;
    for (auto channel: node.getTopInstance()->getChannelMap()) {
        channel.second->accept(*this);
    }
    printSpace(this->indent);

    this->ss << "sc_start();" << std::endl;
    this->indent -= this->indentSize;
    this->ss << "}//end of sc_main" << std::endl;
}

void PrintSystemC::visit(SCAM::Module &node) {
    this->ss << std::endl;

    printSpace(this->indent);
    this->ss << "struct " << node.getName() << "_generated : public sc_module {" << std::endl;
    this->indent += this->indentSize;
    this->ss << std::endl;

    //SECTIONS
    printSpace(this->indent);
    this->ss << "enum Sections {";
    auto sections_vector = node.getFSM()->getSectionList();
    this->ss << sections_vector[0];
    sections_vector.erase(sections_vector.begin());
    for (auto &i:sections_vector)
        this->ss << ", " << i;
    this->ss << "};" << std::endl;
    printSpace(this->indent);
    this->ss << "Sections section;" << std::endl << std::endl;

    //PORTS
    for (auto &&port :node.getPorts()) {
        port.second->accept(*this);
    }
    this->ss << std::endl;

    //Functions
    printSpace(this->indent);
    this->ss << "//functions" << std::endl;
    for (auto function: node.getFunctionMap()) {
        function.second->accept(*this);
        this->ss << std::endl;
    }
    this->ss << std::endl;

    //VARIABLES
    for (auto &&varitem :node.getVariableMap()) {
        varitem.second->accept(*this);
    }
    this->ss << std::endl;

    //CONSTRUCTOR
    printSpace(this->indent);
    this->ss << "SC_HAS_PROCESS(" << node.getName() << "_generated);" << std::endl << std::endl;
    printSpace(this->indent);
    this->ss << node.getName() << "_generated(sc_module_name name)";

    //initial part first
    for (auto &&section :node.getFSM()->getSectionMap()) {
        if (section.first.find("init") >= section.first.size()) continue;
        this->ss << " :" << std::endl;
        this->indent += this->indentSize;
        for (auto &&stmt :section.second) {
            std::string statementstring = PrintStmtForSystemC::toString(stmt, indentSize, indent, true);
            if (statementstring[0] !=
                '(')//statements starting like this "(something)" are returned when the assignment is not constructor compatible
            {
                printSpace(this->indent);
                this->ss << statementstring;
                if (statementstring.find('\n') == std::string::npos) this->ss << "," << std::endl;
            }
        }
        this->ss.seekp(-2, std::ios_base::end);
        this->indent -= this->indentSize;
    }
    printSpace(this->indent);
    this->ss << "{" << std::endl;
    printSpace(this->indent);
    printSpace(this->indent);
    this->ss << "SC_THREAD(FSM);" << std::endl;
    printSpace(this->indent);
    this->ss << "}" << std::endl;

    /////////////////////FSM BODY (SECTIONS)
    // FSM DECL START
    this->ss << std::endl;
    printSpace(this->indent);
    this->ss << "void FSM(){" << std::endl;
    this->indent += this->indentSize;
    this->indent += this->indentSize;

    //FSM BODY (SECTIONS)
    printSpace(this->indent);
    this->ss << "while(true) {" << std::endl;
    this->indent += this->indentSize;
    node.getFSM()->accept(*this);
    this->ss << "wait(SC_ZERO_TIME);" << std::endl;
    this->indent -= this->indentSize;
    printSpace(this->indent);
    this->ss << "}//end of while" << std::endl;

    // FSM DECL END
    this->indent -= this->indentSize;
    this->indent -= this->indentSize;
    printSpace(this->indent);
    this->ss << "}//end of FSM" << std::endl;

    // MODULE DECL END
    this->indent -= this->indentSize;
    printSpace(this->indent);
    this->ss << "};//end of module" << std::endl;
}

void PrintSystemC::visit(ModuleInstance &node) {
    /*
     *   ModuleName module("module_name");
     * */
    printSpace(this->indent);
    this->ss << node.getStructure()->getName() << "_generated "
             << node.getName() << "(\"" << node.getName() << "_name\");" << std::endl;
}

void PrintSystemC::visit(Port &node) {
    /*
     *   blocking_out<bool> outport;
     * */
    printSpace(this->indent);
    this->ss << node.getInterface()->getName() << "_"
             << node.getInterface()->getDirection();
    if (node.getDataType() != nullptr) {
        this->ss << "<" << node.getDataType()->getName() << "> ";
    }
    this->ss << node.getName() << ";" << std::endl;
}

void PrintSystemC::visit(Channel &node) {
    /*
     * MasterSlave<int> channel("channel");
     * ModuleF.portF(channel);
     * ModuleT.portT(channel);
     * */
    printSpace(this->indent);
    if (node.getFromPort()->getInterface()->isMaster() || node.getFromPort()->getInterface()->isSlave())
        this->ss << "MasterSlave";
    else if (node.getFromPort()->getInterface()->isBlocking())
        this->ss << "Blocking";
    else if (node.getFromPort()->getInterface()->isShared())
        this->ss << "Shared";
    else
        throw std::runtime_error("UNKNOWN CHANNEL TYPE");

    this->ss << "<"
             << node.getFromPort()->getDataType()->getName() // should I check if (FromPort<datatype> == ToPort<datatype>) ??
             << "> " << node.getName() << "(\"" << node.getName() << "\");" << std::endl;

    printSpace(this->indent);
    this->ss << node.getFromInstance()->getName() << "."
             << node.getFromPort()->getName() << "(" << node.getName() << ");" << std::endl;
    printSpace(this->indent);
    this->ss << node.getToInstance()->getName() << "."
             << node.getToPort()->getName() << "(" << node.getName() << ");" << std::endl;
    this->ss << std::endl;
}

void PrintSystemC::visit(Variable &node) {
    /*
     *   bool boolvar;
     *   CompoundType compoundType;
     *
     *   ///////bool boolvar = false;
     *   ///////mydata_t acomplexvar = {1 , symbolic4, true};
     * */

    if (!node.isCompoundType() && node.getInitialValue() == nullptr)
        throw std::runtime_error("Variable " + node.getName() + " does not have an initial value");

    printSpace(this->indent);
    this->ss << node.getDataType()->getName() << " " << node.getName();
//    if (! node.isCompoundType()) { //regular value
//        this->ss << " = " <<PrintStmt::toString(node.getInitialValue(), indentSize, indent);
//    }
//    else {
//        this->ss << " = {";
//        std::vector<Variable*>::const_iterator subvar = node.getSubVarList().begin();
//        this->ss << (*subvar)->getName() << " = ";
//        this->ss << PrintStmt::toString((*subvar)->getInitialValue(), indentSize, indent);
//        ++subvar;
//        while (subvar != node.getSubVarList().end()) {
//            this->ss << ", " << (*subvar)->getName() << " = ";
//            this->ss << PrintStmt::toString((*subvar)->getInitialValue(), indentSize, indent);
//            ++subvar;
//        }
//        this->ss << "}";
//    }
    this->ss << ";" << std::endl;
}

void PrintSystemC::visit(FSM &node) {
    /*
     * if ( section == section1) {
     *   stmts;
     * }
     * else if (section == section2) {
     *   stmts;
     * }
     * */

    printSpace(this->indent);
    for (auto &&section :node.getSectionMap()) {
        if (section.first.find("init") < section.first.size()) continue;
        //printSpace(this->indent);
        this->ss << "if (section==" << section.first << ") {" << std::endl;
        indent += indentSize;
        for (auto &&stmt :section.second) {
            printSpace(this->indent);
            std::string statementstring = PrintStmtForSystemC::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        printSpace(this->indent);
        this->ss << "}" << std::endl;
        printSpace(this->indent);
        this->ss << "else ";
    }
    this->ss.seekp(-5, std::ios_base::end);//remove last "else "
}

void PrintSystemC::visit(DataType &node) {
/*
* /////built ins: shown as comments
* enum should show before the compound type because it might be used there
* enum myenum_t {symbolic1, symbolic2, symbolic3, symbolic4};
* compound mydata_t = {int a; myenum_t b; bool c;};
* */
    printSpace(this->indent);

    if (node.isEnumType()) {
        //IF section enum -> not needed
        if (node.getName().find("_SECTIONS") < node.getName().size()) return; //enum (ModuleName)_SECTIONS
        this->ss << "enum " << node.getName() << " {";
        auto it = node.getEnumValueMap().begin();
        this->ss << it->first;
        ++it;
        while (it != node.getEnumValueMap().end()) {
            this->ss << ", " << it->first;
            ++it;
        }
        this->ss << "};" << std::endl;
    } else if (node.isCompoundType()) {
        this->ss << "struct " << node.getName() << " { ";
        auto it = node.getSubVarMap().begin();
        //this->ss << "\t" << it->second->getName() <<" " << it->first;
        //++it;
        while (it != node.getSubVarMap().end()) {
            this->ss << it->second->getName() << " " << it->first << "; ";
            ++it;
        }
        this->ss << "};" << std::endl;
    }
//    else { //built-in type, show as comment since it is implicit and never declared in AML
//        this->ss << "// Datatype : " << node.getName() << std::endl;
//    }
}

void PrintSystemC::visit(SCAM::DataSignal &node) {
    throw std::runtime_error("NEVER GO HERE");
}

void PrintSystemC::visit(Interface &node) {
    this->ss << "print of Interface is not supported: " << node.getName() << std::endl;
}

void PrintSystemC::visit(Function &node) {
    printSpace(this->indent);
    this->ss << node.getReturnType()->getName() << " " << node.getName() << "(";
    auto paramMap = node.getParamMap();
    for (auto begin = paramMap.begin(); begin != paramMap.end(); ++begin) {
        this->ss << begin->second->getDataType()->getName() << " ";
        this->ss << begin->first;
        if (begin != --paramMap.end()) this->ss << ", ";
    }
    this->ss << ") const {" << std::endl;
    indent += indentSize;
    for (auto &&stmt :node.getStmtList()) {
        printSpace(this->indent);
        std::string statementstring = PrintStmtForSystemC::toString(stmt, indentSize, indent);
        this->ss << statementstring;
        if (statementstring.find('\n') == std::string::npos) this->ss << ";";
        this->ss << std::endl;
    }
    indent -= indentSize;
    printSpace(this->indent);
    this->ss << "}\n";
}

void PrintSystemC::visit(Parameter &node) {
    this->ss << node.getName();
}