//
// Created by tobias on 04.01.17.
//

#include <cassert>
#include "PrintPromela.h"


//TODO: modeling random inputs for environments ... ?

bool containsSubstring(std::string fullString, std::string subString) {
    if (fullString.size() == 0) {
        return false;
    }
    if (fullString.find(subString) < fullString.size()) {
        return true;
    }
    return false;
}

SCAM::PrintPromela::PrintPromela(SCAM::Model *model) :
        model(model),
        topInstance(model->getTopInstance()) {
    assert(model->getTopInstance() != nullptr);
    this->model->accept(*this);
}

void SCAM::PrintPromela::visit(SCAM::Model &node) {
    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Datatype definitions\n";
    this->ss << "///////////////////////////////////////////////\n";
    //ENUMS
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isEnumType()) {
            //IF section enum -> not needed
            if (containsSubstring(type.first, "_SECTIONS")) continue;
            //ENUM: Print out each value of the enum as integer
            this->ss << "//Enum Type: " << type.first << "\n";
            this->ss << "#define " << type.first << " int" << "\n";
            for (auto enumVal: type.second->getEnumValueMap()) {
                this->ss << "#define " << type.first << "_" << enumVal.first << " " << enumVal.second << "\n";
            }
        }
    }
    //COMPOUNDS
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isCompoundType()) {
            this->ss << "//Compound Type: " << type.first << "\n";
            this->ss << "typedef " << type.first << "{\n";
            for (auto subtype: type.second->getSubVarMap()) {
                this->ss << "\t" << subtype.second->getName() << " " << subtype.first << ";\n";
            }
            this->ss << "};\n";
        }
    }

    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Communication channels & global variables\n";
    this->ss << "///////////////////////////////////////////////\n";
    for (auto channel: node.getTopInstance()->getChannelMap()) {
        channel.second->accept(*this);
    }
    for (auto &&item : topInstance->getModuleInstances()) {
        item.second->accept(*this);
    }
}


std::string SCAM::PrintPromela::createCommStmtHandshake(SCAM::State *state) {
    std::stringstream css;
    auto comm = state->getCommStmt();

    css << "\t\t\t" << "atomic{\n";
    if (comm->isBlocking() || comm->isMaster()) {

        css << "\t\t\t\t" << topInstance->getChannel(state->getCommPort())->getName() << "_ready = true;\n";
        if (comm->isRead()) {
            css << "\t\t\t\t" << topInstance->getChannel(state->getCommPort())->getName() << "?" << comm->getPort()->getName() << "_data;\n";
        } else {
            css << "\t\t\t\t" << topInstance->getChannel(state->getCommPort())->getName() << "!"
                << PrintStmtForPromela::toString(state->getWriteValue()) << ";\n";
        }
        css << "\t\t\t\t" << topInstance->getChannel(state->getCommPort())->getName() << "_ready=false;\n";
        css << "\t\t\t\t" << comm->getPort()->getName() << "_sync = true;\n";

    } else if (comm->isNonBlockingAccess() && !comm->isShared() || comm->isSlave()) {
        if (comm->isRead()) {
            css << "\t\t\t\tif\n";
            css << "\t\t\t\t ::" << topInstance->getChannel(state->getCommPort())->getName() << "_ready == true ->\n";
            css << "\t\t\t\t\t " << topInstance->getChannel(state->getCommPort())->getName() << "?" << comm->getPort()->getName() << "_data;\n";
            css << "\t\t\t\t\t" << comm->getPort()->getName() << "_sync = true;\n";
            css << "\t\t\t\t :: else -> " << comm->getPort()->getName() << "_sync = false;\n";
            css << "\t\t\t\tfi;\n";

        } else {
            css << "\t\t\t\tif\n";
            css << "\t\t\t\t ::" << topInstance->getChannel(state->getCommPort())->getName() << "_ready == true ->\n";
            css << "\t\t\t\t\t " << topInstance->getChannel(state->getCommPort())->getName() << "!" << PrintStmtForPromela::toString(state->getWriteValue()) << ";\n";
            css << "\t\t\t\t\t " << comm->getPort()->getName() << "_sync = true;\n";
            css << "\t\t\t\t ::else -> " << comm->getPort()->getName() << "_sync = false;\n";
            css << "\t\t\t\tfi;\n";
        }
    }
    css << "\t\t\t " << "};\n";
    return css.str();
}


std::string SCAM::PrintPromela::createCommStmtUnless(SCAM::State *state) {
    std::stringstream css;
    auto comm = state->getCommStmt();


    if (comm->isBlocking() || comm->isMaster()) {
        if (comm->isRead()) {
            css << "\t\t\t" << topInstance->getChannel(state->getCommPort())->getName() << "?" << comm->getPort()->getName() << "_data;\n";
            css << "\t\t\t" << comm->getPort()->getName() << "_sync = true;";
        } else {
            css << "\t\t\t" << topInstance->getChannel(state->getCommPort())->getName() << "!"
                << PrintStmtForPromela::toString(state->getWriteValue()) << ";\n";
            css << "\t\t\t" << comm->getPort()->getName() << "_sync = true;";
        }
    } else if (comm->isNonBlockingAccess() && !comm->isShared() || comm->isSlave()) {
        if (comm->isRead()) {
            css << "\t\t\t{" << comm->getPort()->getName() << "_sync = false;}";
            css << " unless ";
            css << "{" << topInstance->getChannel(state->getCommPort())->getName() << "?" << comm->getPort()->getName() << "_data;";
            css << comm->getPort()->getName() << "_sync = true;}\n";
        } else {
            css << "\t\t\t{" << comm->getPort()->getName() << "_sync = false;}";
            css << " unless ";
            css << "{" << topInstance->getChannel(state->getCommPort())->getName() << "!" << PrintStmtForPromela::toString(state->getWriteValue()) << ";";
            css << comm->getPort()->getName() << "_sync = true;}\n";
        }
    }

    return css.str();
}


void SCAM::PrintPromela::visit(SCAM::Module &node) {

    this->ss << "\n";
    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Module:" << node.getName() << "\n";
    this->ss << "///////////////////////////////////////////////\n";

    for (auto state: node.getFSM()->getStateMap()) {
        this->ss << "#define " << node.getName() << "_" << state.second->getName() << " " << state.first << "\n";
    }

}

void SCAM::PrintPromela::visit(SCAM::ModuleInstance &node) {
    //Create everything that is globally used for each module
    node.getStructure()->accept(*this);

    //Create specific instance
    Module *current_module = node.getStructure();
    this->ss << "\n";
    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Instance:" << node.getName() << " Module:" << node.getStructure()->getName() << "\n";
    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "\nactive proctype " << node.getName() << "_" << current_module->getName() << "(){\n";

    this->ss << "int state = " << current_module->getName() << "_init;\n";

    for (auto var: current_module->getVariableMap()) {
        this->ss << var.second->getDataType()->getName() << " " << var.first << ";\n";
    }

    for (auto port: current_module->getPorts()) {
        this->ss << port.second->getDataType()->getName() << " " << port.first << "_data;\n";
        this->ss << "bool " << port.first << "_sync;\n";
    }

    this->ss << " \tend: do\n";
    current_module->getFSM()->accept(*this);
    this->ss << "\tod;\n}\n ";

}

void SCAM::PrintPromela::visit(SCAM::Port &node) {

}

void SCAM::PrintPromela::visit(SCAM::Channel &node) {
    //chan s_in = [0] of { int }
    if (node.getFromPort()->getInterface()->isShared()) {
        this->ss << node.getFromPort()->getDataType()->getName() << " " << node.getName() << ";\n";
    } else {
        this->ss << "chan " << node.getName() << " = [0] of {" << node.getFromPort()->getDataType()->getName() << "};\n";
        this->ss << "bool " << node.getName() << "_ready = false;\n";
    }
}

void SCAM::PrintPromela::visit(SCAM::Interface &node) {

}

void SCAM::PrintPromela::visit(SCAM::Variable &node) {
    this->ss << node.getDataType()->getName() << " " << node.getName() << "=";
    if (!node.isCompoundType()) {
        this->ss << PrintStmtForPromela::toString(const_cast<ConstValue *>(node.getInitialValue()));
    }
    this->ss << ";\n";
}

void SCAM::PrintPromela::visit(SCAM::FSM &node) {

    for (auto &&state : node.getStateMap()) {
        this->ss << "\t\t:: state ==  " << node.getModule()->getName() << "_" << state.second->getName() << "->\n";
        this->ss << "\t\t\t//Communication \n";
        if (!state.second->isInit()) this->ss << createCommStmtHandshake(state.second) << "\n";
        this->ss << "\t\t\t//Dpath operations \n";
        this->ss << "\t\t\td_step{\n";
        this->ss << "\t\t\tif \n  ";
        for (auto operation: state.second->getOutgoingOperationList()) {
            //if (operation->isWait()) continue;
            this->ss << "\t\t\t:: ";
            auto i = operation->getAssumptionList().size() - 1;
            for (auto assumption: operation->getAssumptionList()) {
                this->ss << PrintStmtForPromela::toString(assumption);
                if (i > 0) {
                    this->ss << "&&";
                    i--;
                } else if (i == 0) this->ss << "-> \n";
            }
            if (operation->getAssumptionList().empty()) this->ss << "true ->  \n";
            for (auto commitment: operation->getCommitmentList()) {
                this->ss << "\t\t\t\t" << PrintStmtForPromela::toString(commitment) << ";" << std::endl;
            }
            this->ss << "\t\t\t\tstate = " << node.getModule()->getName() << "_" << operation->getNextState()->getSection() << "_"
                     << operation->getNextState()->getStateId() << ";\n";
        }
        this->ss << "\t\t\tfi;\n";
        this->ss << "\t\t\t};\n";
    }
}

void SCAM::PrintPromela::visit(SCAM::DataType &node) {

}

std::string SCAM::PrintPromela::print() {
    return this->ss.str();
}

void SCAM::PrintPromela::visit(SCAM::DataSignal &node) {
    throw std::runtime_error("NOT IMPLEMENTED");

}

void SCAM::PrintPromela::visit(SCAM::Function &node) {
    throw std::runtime_error("not implemented");


}

void SCAM::PrintPromela::visit(SCAM::Parameter &node) {
    throw std::runtime_error("not implemented");

}

