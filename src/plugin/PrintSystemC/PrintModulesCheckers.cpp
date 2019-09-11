//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include "PrintModulesCheckers.h"

std::map<std::string, std::string> PrintModulesCheckers::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        std::string Mname = module.second->getName();
        pluginOutput.insert(std::make_pair(Mname + "_checker/CMakeLists.txt", Create_CMake(Mname)));
        pluginOutput.insert(std::make_pair(Mname + "_checker/DataTypes_ext.h", Text_DataTypesEXT()));

        this->ss.str("");
        Text_Checker(module.second);
        pluginOutput.insert(std::make_pair(Mname + "_checker/" + Mname + "_checker.h", this->ss.str()));

        this->ss.str("");
        Text_SCMain(module.second);
        pluginOutput.insert(std::make_pair(Mname + "_checker/" + "sc_main.cpp", this->ss.str()));

        this->ss.str("");
        this->ss << "#ifndef SYSTEMC_" << Mname << "_H" << std::endl;
        this->ss << "#define SYSTEMC_" << Mname << "_H" << std::endl << std::endl;
        module.second->accept(*this);
        this->ss << std::endl;
        this->ss << std::endl << "#endif //SYSTEMC_" << Mname << "_H" << std::endl;
        pluginOutput.insert(std::make_pair(Mname + "_checker/" + Mname + "_generated.h", this->ss.str()));
    }
    return pluginOutput;
}

    ////////////////
std::string PrintModulesCheckers::Create_CMake(std::string nodeName) {
    std::stringstream result;
    result << "cmake_minimum_required(VERSION 2.8)" << std::endl
           << "project(" << nodeName << "_checker CXX C)" << std::endl
           << std::endl
           << "set(CMAKE_CXX_FLAGS  \"${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} \")" << std::endl
           << "set (CMAKE_MODULE_LINKER_FLAGS \"-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z\")"
           << std::endl
           << std::endl
           << "include_directories(" << SCAM_HOME << "/include)" << std::endl
           << "link_directories(" << SCAM_HOME << "/lib)" << std::endl
           << "include_directories(" << SCAM_HOME << "/example/Interfaces/)" << std::endl
           << std::endl
           << "add_executable(" << nodeName << "_checker sc_main.cpp)" << std::endl
           << "target_link_libraries(" << nodeName << "_checker systemc)" << std::endl
           << "target_link_libraries(" << nodeName << "_checker scv)" << std::endl;
    return result.str();
}

std::string PrintModulesCheckers::Text_DataTypesEXT() {
    /*
 * class scv_extensions<enum_t> : public scv_enum_base<enum_t> {
 * public:
 *      SCV_ENUM_CTOR(enum_t) {
 *          SCV_ENUM(subENUM);
 *      }
 * };
 *
 * class scv_extensions<Compound_t> : public scv_extensions_base<Compound_t> {
 * public:
 *      scv_extensions<subCompound_t> subCompound;
 *
 *      SCV_EXTENSIONS_CTOR(Compound_t) {
 *          SCV_FIELD(subCompound);
 *      }
 * };
 * */
    std::stringstream result;
    result << "#ifndef SYSTEMCMODEL_DATATYPES_EXT_H\n"
           << "#define SYSTEMCMODEL_DATATYPES_EXT_H\n\n"
           << "#include \"scv.h\"\n"
           << "#include \"YOUR ORIGINAL MODULE\"\n\n";

    // enum should show before the compound type because it might be used there
    for (auto &type: DataTypes::getDataTypeMap()) {
        if (type.second->isEnumType()) {
            if (type.second->getName().find("_SECTIONS") < type.second->getName().size()) {}
            else {
                /////class scv_extensions<type> : public scv_enum_base<type>
                result << "template<>\n"
                       << "class scv_extensions<" << type.second->getName()
                       << "> : public scv_enum_base<"
                       << type.second->getName() << "> {\n"
                       << "public:\n"
                       << "\n\tSCV_ENUM_CTOR(" << type.second->getName() << ") {\n";
                auto subenum = type.second->getEnumValueMap().begin();
                while (subenum != type.second->getEnumValueMap().end()) {
                    /////SCV_ENUM(SubENUM);;
                    result << "\t\tSCV_ENUM(" << subenum->first << ");\n";
                    ++subenum;
                }
                result << "\t}\n"
                       << "};\n\n";
            }
        }
    }
    for (auto &type: DataTypes::getDataTypeMap()) {
        if (type.second->isCompoundType()) {
            /////class scv_extensions<type> : public scv_extensions_base<type>
            result << "template<>\n"
                   << "class scv_extensions<" << type.second->getName()
                   << "> : public scv_extensions_base<"
                   << type.second->getName() << "> {\n"
                   << "public:\n";
            auto subvar = type.second->getSubVarMap().begin();
            while (subvar != type.second->getSubVarMap().end()) {
                /////scv_extensions<type> SubVar;
                result << "\tscv_extensions<" << subvar->second->getName() << "> " << subvar->first << ";\n";
                ++subvar;
            }
            result << "\n\tSCV_EXTENSIONS_CTOR(" << type.second->getName() << ") {\n";
            subvar = type.second->getSubVarMap().begin();
            while (subvar != type.second->getSubVarMap().end()) {
                /////SCV_FIELD(SubVar);
                result << "\t\tSCV_FIELD(" << subvar->first << ");\n";
                ++subvar;
            }
            result << "\t}\n"
                   << "};\n\n";
        }
    }

    result << std::endl << "#endif //SYSTEMCMODEL_DATATYPES_EXT_H" << std::endl;
    return result.str();
}

void PrintModulesCheckers::Text_SCMain(SCAM::Module *node) {
    /*
 * Connecting the checker to original and generated modules
 * int sc_main(int, char **) {
 *      Module_checker m_checker();
 *      Module m_o();
 *      Module_generated m_g();
 *
 *      Channel<type> ch_checker_original();
 *      Channel<type> ch_checker_generated();
 *      m_checker.port_o(ch_checker_original);
 *      m_o.port(ch_checker_original);
 *      m_checker.port_g(ch_checker_generated);
 *      m_g.port(ch_checker_generated);
 *
 *      sc_start();
 * }
 */
    std::string Mname = node->getName();//Module name
    std::string Pname;//Port name
    std::string Tname;//Port type name

    this->ss << "#include \"systemc.h\"\n"
             << "#include \"Interfaces.h\"\n"
             << "#include \"DataTypes_ext.h\"\n"
             << "#include \"" << Mname << "_generated.h\"\n"
             << "#include \"" << Mname << "_checker.h\"\n\n"
             << "int sc_main(int, char **) {\n\n";

    /////Module_checker Module_checkerM("Module_checker_name");
    /////Module Module_o("Module_o_name");
    /////Module_generated Module_g("Module_g_name");
    this->ss << "\t" << Mname << "_checker " << Mname << "_checkerM(\"" << Mname << "_checker_name\");\n"
             << "\t" << Mname << " " << Mname << "_o(\"" << Mname << "_o_name\");\n"
             << "\t" << Mname << "_generated " << Mname << "_g(\"" << Mname << "_g_name\");\n\n";

    for (auto &&port: node->getPorts()) {
        Pname = port.second->getName();
        Tname = port.second->getDataType()->getName();
        /////MasterSlave<type> Port_o("Port_o_name");
        /////MasterSlave<type> Port_g("Port_g_name");
        if ((port.second->getInterface()->getName() == "master") ||
            (port.second->getInterface()->getName() == "slave")) {
            this->ss << "\tMasterSlave<" << Tname << "> " << Pname << "_o(\"" << Pname << "_o_name\");\n";
            this->ss << "\tMasterSlave<" << Tname << "> " << Pname << "_g(\"" << Pname << "_g_name\");\n";
        }
            /////Blocking<type> Port_o("Port_o_name");
            /////Blocking<type> Port_g("Port_g_name");
        else if (port.second->getInterface()->getName() == "blocking") {
            this->ss << "\tBlocking<" << Tname << "> " << Pname << "_o(\"" << Pname << "_o_name\");\n";
            this->ss << "\tBlocking<" << Tname << "> " << Pname << "_g(\"" << Pname << "_g_name\");\n";
        }
            /////Shared<type> Port_o("Port_o_name");
            /////Shared<type> Port_g("Port_g_name");
        else { /////if(port.second->getInterface()->getName() == "shared")
            this->ss << "\tShared<" << Tname << "> " << Pname << "_o(\"" << Pname << "_o_name\");\n";
            this->ss << "\tShared<" << Tname << "> " << Pname << "_g(\"" << Pname << "_g_name\");\n";
        }
        /////Module_checkerM.Port_o(Port_o);
        /////Module_o.Port(Port_o);
        /////Module_checkerM.Port_g(Port_g);
        /////Module_g.Port(Port_g);
        this->ss << "\t" << Mname << "_checkerM." << Pname << "_o(" << Pname << "_o);\n"
                 << "\t" << Mname << "_o." << Pname << "(" << Pname << "_o);\n"
                 << "\t" << Mname << "_checkerM." << Pname << "_g(" << Pname << "_g);\n"
                 << "\t" << Mname << "_g." << Pname << "(" << Pname << "_g);\n\n";
    }

    this->ss << "\tsc_start();\n\n"
             << "}//end of sc_main";
}

void PrintModulesCheckers::Text_Checker(SCAM::Module *node) {
    /*
 * struct Module_checker : public sc_module {
 *      //OUTPUT PORTs to original and generated modules
 *          blocking_out <int> in_port_o;
 *          blocking_out <int> in_port_g;
 *          std::vector<int> in_port_data;      // same data should be sent to BOTH original and generated modules
 *          std::vector<bool> in_port_NBwrite_o;// successful write in case of a nonblocking channel
 *          std::vector<bool> in_port_NBwrite_g;// successful write in case of a nonblocking channel
 *      //INPUT PORTs from original and generated modules
 *          blocking_in <int> out_port_o;
 *          blocking_in <int> out_port_g;
 *          std::vector<int> out_port_NBread_o; // successful read in case of a nonblocking channel
 *          std::vector<int> out_port_NBread_g; // successful read in case of a nonblocking channel
 *          std::vector<int> out_port_data_o;
 *          std::vector<int> out_port_data_g;
 *
 *      Module_checker(sc_module_name name) {
 *          //Generate random data to send to both original and generated modules
 *              scv_smart_ptr<int> data_temp("data_temp");
 *              while (cnt < Test_cnt) {
 *                  data_temp->next();
 *                  in_port_data.push_back(*data_temp);
 *              }
 *          SC_THREAD(run_original);
 *          SC_THREAD(run_generated);
 *          SC_THREAD(run_assertion);
 *      }
 *
 *      void run_original() {
 *          while (cnt < Test_cnt) {
 *              //Sending data to original modules and recording communication status
 *                  in_port_NBwrite_temp = in_port_o->nb_write(in_port_data[cnt]);
 *                  in_port_NBwrite_o.push_back(out_port_NBwrite_temp);
 *              //Receiving data from original modules and recording communication status and data
 *                  out_port_NBread_temp = out_port_o->nb_read(out_port_data_temp);
 *                  out_port_NBread_o.push_back(out_port_NBread_temp);
 *                  out_port_data_o.push_back(out_port_data_temp);
 *          }
 *      }
 *
 *      void run_generated() {//the same implementation as run_original}
 *
 *      run_assertion(){
 *          while (cnt < Test_cnt) {
 *              //assert equivalency between original and generated data and transaction status
 *              sc_assert(in_port_NBwrite_o == in_port_NBwrite_g);
 *              sc_assert(out_port_NBread_o == out_port_NBread_g);
 *              sc_assert(out_port_data_o == out_port_data_g);
 *          }
 *      }
 * };
 */

    std::string Mname = node->getName();//Module name
    std::string Pname;
    std::string Pinterface;
    std::string Pdirection;
    std::string Ptype;
    std::string temp;
    std::vector<std::string> assertion_variables;
    this->ss << "#ifndef SYSTEMCMODEL_" << Mname << "_CHECKER_H\n"
             << "#define SYSTEMCMODEL_" << Mname << "_CHECKER_H\n\n"
             << "struct " << Mname << "_checker : public sc_module {\n\n"
             << "\t//Constructor\n"
             << "\tSC_HAS_PROCESS(" << Mname << "_checker);\n\n"
             << "\t" << Mname << "_checker(sc_module_name name) {" << std::endl;
    for (auto &&port :node->getPorts()) {
        if (port.second->getInterface()->getDirection() == "in") {
            Pname = port.second->getName();
            Ptype = port.second->getDataType()->getName();
            /////scv_smart_ptr<type> name_data_temp("name_data_temp");
            this->ss << "\t\tscv_smart_ptr<" << Ptype << "> " << Pname << "_data_temp(\"" << Pname
                     << "_data_temp\");\n";
        }
    }
    this->ss << "\t\tint cnt = 0;\n"
             << "\t\twhile (cnt < Test_cnt) {\n";
    for (auto &&port :node->getPorts()) {
        if (port.second->getInterface()->getDirection() == "in") {
            Pname = port.second->getName();
            /////name_data_temp->next();
            /////name_data.push_back(*name_data_temp);
            this->ss << "\t\t\t" << Pname << "_data_temp->next();\n"
                     << "\t\t\t" << Pname << "_data.push_back(*" << Pname << "_data_temp);\n";
        }
    }
    this->ss << "\t\t\tcnt++;\n\t\t}\n"
             << "\t\tSC_THREAD(run_original);\n"
             << "\t\tSC_THREAD(run_generated);\n"
             << "\t\tSC_THREAD(run_assertion);\n"
             << "\t}\n\n\tint Test_cnt=10000;\n\t//Channels" << std::endl;

    for (auto &&port :node->getPorts()) {
        Pname = port.second->getName();
        Pinterface = port.second->getInterface()->getName();
        Pdirection = port.second->getInterface()->getDirection();
        Ptype = port.second->getDataType()->getName();
        temp = "\t";
        /////master_out<type> name_o;   //master_out<type> name_g;
        /////blocking_in<type> name_o;  //blocking_in<type> name_g;
        /////slave_out<type> name_o;    //slave_out<type> name_g;
        /////shared_in<type> name_o;    //shared_in<type> name_g;
        if (Pinterface == "master")
            temp += "slave";
        else if (Pinterface == "slave")
            temp += "master";
        else
            temp += Pinterface;

        if (Pdirection == "out")
            temp += "_in <";
        else
            temp += "_out <";

        temp += Ptype + "> " + Pname;
        this->ss << temp << "_g;\n";
        this->ss << temp << "_o;\n";

        /////std::vector<type> name_data;
        if (Pdirection == "in")
            this->ss << "\tstd::vector<" << Ptype << "> " << Pname << "_data;\n";

        /////std::vector<bool> name_NBread_o;
        if ((Pinterface == "master" || Pinterface == "blocking") && (Pdirection == "out")) {
            temp = "\tstd::vector<bool> " + Pname + "_NBread";
            this->ss << temp << "_g;\n";
            this->ss << temp << "_o;\n";
            assertion_variables.push_back(Pname + "_NBread");
        }
        /////std::vector<bool> name_NBwrite_o;  //bool name_nb_write_g;
        if ((Pinterface == "blocking") && (Pdirection == "in")) {
            temp = "\tstd::vector<bool> " + Pname + "_NBwrite";
            this->ss << temp << "_g;\n";
            this->ss << temp << "_o;\n";
            assertion_variables.push_back(Pname + "_NBwrite");
        }

        /////std::vector<type> name_data_o;  //type name_data_g;
        if (Pdirection == "out") {
            temp = "\tstd::vector<" + Ptype + "> " + Pname + "_data";
            this->ss << temp << "_g;\n";
            this->ss << temp << "_o;\n";
            //deciding on data type (compound or not) happens in the run_assertion section
            assertion_variables.push_back(Pname);
        }
    }
    this->ss << "\n\tbool finish_original = false;\n"
             << "\tbool finish_generated = false;\n\n";

/////////////////////run_original()
    this->ss << "\tvoid run_original() {\n"
             << "\t\tint cnt = 0;\n"
             << "\t\twhile (cnt < Test_cnt){\n";

    this->ss << "\t\t\t//writing data to inputs of the module\n";
    for (auto &&port :node->getPorts()) {
        if (port.second->getInterface()->getDirection() == "in") {
            Pname = port.second->getName();
            Pinterface = port.second->getInterface()->getName();
            /////name_o->write(name_data[cnt]);
            if (Pinterface == "slave")
                this->ss << "\t\t\t" << Pname << "_o->write(" << Pname << "_data[cnt]);\n";
                /////name_o->nb_write(name_data[cnt]);
            else if (Pinterface == "master")
                this->ss << "\t\t\t" << Pname << "_o->nb_write(" << Pname << "_data[cnt]);\n";
                /////bool name_NBwrite_temp;
                /////name_NBwrite_temp = name_o->nb_write(name_data[cnt]);
                /////name_NBwrite_o.push_back(name_NBwrite_temp);
            else if (Pinterface == "blocking") {
                this->ss << "\t\t\tbool " << Pname << "_NBwrite_temp;\n";
                this->ss << "\t\t\t" << Pname << "_NBwrite_temp = " << Pname << "_o->nb_write(" << Pname
                         << "_data[cnt]);\n";
                this->ss << "\t\t\t" << Pname << "_NBwrite_o.push_back(" << Pname << "_NBwrite_temp);\n";
            }
                /////name_o->set(name_data[cnt]);
            else //////(port.second->getInterface()->getName() == "shared")
                this->ss << "\t\t\t" << Pname << "_o->set(" << Pname << "_data[cnt]);\n";
        }
    }

    this->ss << "\n\t\t\t//reading outputs of the module\n";
    for (auto &&port :node->getPorts()) {
        if (port.second->getInterface()->getDirection() == "out") {
            Pname = port.second->getName();
            Pinterface = port.second->getInterface()->getName();
            Ptype = port.second->getDataType()->getName();
            /////bool name_NBread_temp;
            /////type name_data_temp;
            /////name_NBread_temp = name_o->nb_read(name_data_temp);
            /////name_NBread_o.push_back(name_NBread_temp);
            /////name_data_o.push_back(name_data_temp);
            if ((Pinterface == "master") || (Pinterface == "blocking")) {
                this->ss << "\t\t\tbool " << Pname << "_NBread_temp;\n";
                this->ss << "\t\t\t" << Ptype << " " << Pname << "_data_temp;\n";
                this->ss << "\t\t\t" << Pname << "_NBread_temp = " << Pname << "_o->nb_read(" << Pname
                         << "_data_temp);\n";
                this->ss << "\t\t\t" << Pname << "_NBread_o.push_back(" << Pname << "_NBread_temp);\n";
                this->ss << "\t\t\t" << Pname << "_data_o.push_back(" << Pname << "_data_temp);\n";
            }
                /////type name_data_temp;
                /////name_o->read(name_data_temp);
                /////name_data_o.push_back(name_data_temp);
            else if (Pinterface == "slave") {
                this->ss << "\t\t\t" << Ptype << " " << Pname << "_data_temp;\n";
                this->ss << "\t\t\t" << Pname << "_o->read(" << Pname << "_data_temp);\n";
                this->ss << "\t\t\t" << Pname << "_data_o.push_back(" << Pname << "_data_temp);\n";
            }
                /////type name_data_temp;
                /////name_o->get(name_data_temp);
                /////name_data_o.push_back(name_data_temp);
            else {/////(port.second->getInterface()->getName() == "shared")
                this->ss << "\t\t\t" << Ptype << " " << Pname << "_data_temp;\n";
                this->ss << "\t\t\t" << Pname << "_o->get(" << Pname << "_data_temp);\n";
                this->ss << "\t\t\t" << Pname << "_data_o.push_back(" << Pname << "_data_temp);\n";
            }
        }
    }

    this->ss << "\n\t\t\twait(SC_ZERO_TIME);\n"
             << "\t\t\tcnt++;\n"
             << "\t\t}\n\t\tfinish_original = true;\n"
             << "\t}\n\n";

/////////////////////run_generated()
    this->ss << "\tvoid run_generated() {\n"
             << "\t\tint cnt = 0;\n"
             << "\t\twhile (cnt < Test_cnt){\n";

    this->ss << "\t\t\t//writing data to inputs of the module\n";
    for (auto &&port :node->getPorts()) {
        if (port.second->getInterface()->getDirection() == "in") {
            Pname = port.second->getName();
            Pinterface = port.second->getInterface()->getName();
            if (Pinterface == "slave")
                this->ss << "\t\t\t" << Pname << "_g->write(" << Pname << "_data[cnt]);\n";
            else if (Pinterface == "master")
                this->ss << "\t\t\t" << Pname << "_g->nb_write(" << Pname << "_data[cnt]);\n";
            else if (Pinterface == "blocking") {
                this->ss << "\t\t\tbool " << Pname << "_NBwrite_temp;\n";
                this->ss << "\t\t\t" << Pname << "_NBwrite_temp = " << Pname << "_g->nb_write(" << Pname
                         << "_data[cnt]);\n";
                this->ss << "\t\t\t" << Pname << "_NBwrite_g.push_back(" << Pname << "_NBwrite_temp);\n";
            } else //////(port.second->getInterface()->getName() == "shared")
                this->ss << "\t\t\t" << Pname << "_g->set(" << Pname << "_data[cnt]);\n";
        }
    }

    this->ss << "\n\t\t\t//reading outputs of the module\n";
    for (auto &&port :node->getPorts()) {
        if (port.second->getInterface()->getDirection() == "out") {
            Pname = port.second->getName();
            Pinterface = port.second->getInterface()->getName();
            Ptype = port.second->getDataType()->getName();
            if ((Pinterface == "master") || (Pinterface == "blocking")) {
                this->ss << "\t\t\tbool " << Pname << "_NBread_temp;\n";
                this->ss << "\t\t\t" << Ptype << " " << Pname << "_data_temp;\n";
                this->ss << "\t\t\t" << Pname << "_NBread_temp = " << Pname << "_g->nb_read(" << Pname
                         << "_data_temp);\n";
                this->ss << "\t\t\t" << Pname << "_NBread_g.push_back(" << Pname << "_NBread_temp);\n";
                this->ss << "\t\t\t" << Pname << "_data_g.push_back(" << Pname << "_data_temp);\n\n";
            } else if (Pinterface == "slave") {
                this->ss << "\t\t\t" << Ptype << " " << Pname << "_data_temp;\n";
                this->ss << "\t\t\t" << Pname << "_g->read(" << Pname << "_data_temp);\n";
                this->ss << "\t\t\t" << Pname << "_data_g.push_back(" << Pname << "_data_temp);\n";
            } else {/////(port.second->getInterface()->getName() == "shared")
                this->ss << "\t\t\t" << Ptype << " " << Pname << "_data_temp;\n";
                this->ss << "\t\t\t" << Pname << "_g->get(" << Pname << "_data_temp);\n";
                this->ss << "\t\t\t" << Pname << "_data_g.push_back(" << Pname << "_data_temp);\n";
            }
        }
    }

    this->ss << "\n\t\t\twait(SC_ZERO_TIME);\n"
             << "\t\t\tcnt++;\n"
             << "\t\t}\n\t\tfinish_generated = true;\n"
             << "\t}\n\n";


/////////////////////run_assertion()
    this->ss << "\tvoid run_assertion() {\n"
             << "\t\twhile (!finish_original || !finish_generated ) {\n"
             << "\t\t\twait(SC_ZERO_TIME);\n\t\t}\n"
             << "\t\tint cnt = 0;\n"
             << "\t\tstd::cout << \"Start Testing.....\" << std::endl;\n"
             << "\t\twhile (cnt < Test_cnt) {\n";
    for (const auto &assertion_variable : assertion_variables) {
        if (node->isPort(assertion_variable)) {
            if (node->getPort(assertion_variable)->getDataType()->isCompoundType()) {
                /////sc_assert(name_data_o.at(cnt).subVar == name_data_g.at(cnt).subVar);
                auto subVar = node->getPort(assertion_variable)->getDataType()->getSubVarMap().begin();
                while (subVar != node->getPort(assertion_variable)->getDataType()->getSubVarMap().end()) {
                    this->ss << "\t\t\tsc_assert(" << assertion_variable << "_data_o.at(cnt)."
                             << (*subVar).first
                             << " == " << assertion_variable << "_data_g.at(cnt)." << (*subVar).first
                             << ");\n";
                    subVar++;
                }
            } else {
                /////sc_assert(name_data_o.at(cnt) == name_data_g.at(cnt));
                this->ss << "\t\t\tsc_assert(" << assertion_variable << "_data_o.at(cnt) == "
                         << assertion_variable << "_data_g.at(cnt));\n";
            }
        } else {
            /////sc_assert(name_extra_o.at(cnt) == name_extra_g.at(cnt));
            this->ss << "\t\t\tsc_assert(" << assertion_variable << "_o.at(cnt) == "
                     << assertion_variable << "_g.at(cnt));\n";
        }
    }
    this->ss << "\t\t\tcnt++;\n\t\t}\n"
             << "\t\tstd::cout << \"Test was successful!!!!\" << std::endl;\n"
             << "\t\tsc_stop();\n\t}\n};\n\n";

    this->ss << "#endif //SYSTEMCMODEL_" << Mname << "_CHECKER_H";
}

void PrintModulesCheckers::printSpace(unsigned int size) {
    for (int i = 0; i < size; ++i) {
        ss << " ";
    }
}

void PrintModulesCheckers::visit(SCAM::Module &node) {
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

void PrintModulesCheckers::visit(Port &node) {
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

void PrintModulesCheckers::visit(Variable &node) {
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

void PrintModulesCheckers::visit(FSM &node) {
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