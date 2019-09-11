//
// Created by lukas on 19.02.19.
//

#include "ChiselConditionVisitor.h"

std::string SCAM::ChiselConditionVisitor::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ChiselConditionVisitor printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::ChiselConditionVisitor::visit(SCAM::VariableOperand &node) {

    if (node.getVariable()->isSubVar() ) {
        if(node.getVariable()->getParent()->isCompoundType()){
            this->ss << node.getVariable()->getParent()->getName() <<"_signal_r."  << node.getVariable()->getName();
        }else if(node.getVariable()->getParent()->isArrayType()){
            this->ss << node.getVariable()->getParent()->getName() <<"("  << node.getVariable()->getName() << ")";
        }else throw std::runtime_error(" Unknown ");

    } else {
        this->ss << node.getVariable()->getName() << "_signal_r";
    }
}

void SCAM::ChiselConditionVisitor::visit(SCAM::SyncSignal &node) {
    this->ss << "io." << node.getPort()->getName() << "_sync";
}

void SCAM::ChiselConditionVisitor::visit(SCAM::UnaryExpr &node) {
    if (node.getOperation() == "not") {
        ss << "!";
    }

    node.getExpr()->accept(*this);
}

void SCAM::ChiselConditionVisitor::visit(SCAM::Logical &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "and") {
        ss << " && ";
    } else if (node.getOperation() == "or") {
        ss << " || ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselConditionVisitor::visit(SCAM::DataSignalOperand &node) {
    if (node.getDataSignal()->isSubVar()) {
        if (node.getPort()->getInterface()->getDirection() == "in") {
            this->ss << "io." << node.getPort()->getName() << "." << node.getDataSignal()->getName();
        } else {
            this->ss << node.getPort()->getName() << "_r." << node.getDataSignal()->getName();
        }
    } else {
        this->ss << node.getDataSignal()->getName();
    }
}

void SCAM::ChiselConditionVisitor::visit(SCAM::Relational &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if(node.getOperation() == "=="){
        this->ss << " === ";
    }else if(node.getOperation() == "!="){
        this->ss << " =/= ";
    }else{
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselConditionVisitor::visit(SCAM::EnumValue &node) {
    std::string str = node.getEnumValue();
    std::string::size_type i = str.find("_");

    /*while (i != std::string::npos)
    {
        str.erase(i, 1);
        i = str.find("_");
    }*/
    std::transform(str.begin(), str.end(), str.begin(), ::tolower);
    this->ss << str;
}


void SCAM::ChiselConditionVisitor::visit(SCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if(node.getOperation() == "%"){
        this->ss << " mod ";
    }else if(node.getOperation() == "/"){
        this->ss << " div ";
    } else this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";

}


void SCAM::ChiselConditionVisitor::visit(SCAM::Bitwise &node) {
    if (node.getOperation() == "<<") {
        this->resize_flag = true;
        this->ss << "(";
        node.getLhs()->accept(*this);
        this->resize_flag = false;
        this->ss << " << ";
        if (node.getRhs()->getDataType()->isUnsigned() || node.getRhs()->getDataType()->isInteger()) {
            shiftLeftAmountFlag = true;
        }
        node.getRhs()->accept(*this);
        this->ss << ")(31, 0)";
    } else if (node.getOperation() == ">>") {
        this->ss << "(";
        node.getLhs()->accept(*this);
        this->ss << " >> ";
        shiftAmountIntFlag = true;
        node.getRhs()->accept(*this);
        shiftAmountIntFlag = false;
        this->ss << ")(31, 0)";
    } else {
        this->ss << "(";
        node.getLhs()->accept(*this);
        if (node.getOperation() == "&") {
            this->ss << " & ";
        } else if (node.getOperation() == "|") {
            this->ss << " | ";
        } else if (node.getOperation() == "^") {
            this->ss << " ^ ";
        } else throw std::runtime_error("Should not get here");
        node.getRhs()->accept(*this);
        this->ss << ")";
        shiftLeftAmountFlag = false;
    }
}

void SCAM::ChiselConditionVisitor::visit(SCAM::UnsignedValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << node.getValueAsString();
    if (node.getValue() > 2147483647) {
        ss << "L";
    }
    if (!shiftLeftAmountFlag) {
        this->ss << ".U(32.W)";
    } else {
        this->ss << ".U(19.W)";
    }
    shiftLeftAmountFlag = false;
    //}else this->ss << node.getValue();
}

void SCAM::ChiselConditionVisitor::visit(SCAM::IntegerValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << node.getValueAsString();
    if (!shiftLeftAmountFlag) {
        this->ss << ".S(32.W)";
    } else {
        this->ss << ".S(19.W)";
    }
    shiftLeftAmountFlag = false;
    //}else this->ss << node.getValue();
}

void SCAM::ChiselConditionVisitor::visit(SCAM::BoolValue &node) {
    if (node.getValue()) {
        this->ss << "true.B";
    } else {
        this->ss << "false.B";
    }
}

void SCAM::ChiselConditionVisitor::visit(SCAM::Cast &node) {
    this->ss << "(";
    node.getSubExpr()->accept(*this);
    if(node.getDataType()->isUnsigned()){
        //this->ss << "unsigned(";
        this->ss << ".asUInt";
    }else if(node.getDataType()->isInteger()){
        //this->ss << "signed(";
        if (!shiftAmountIntFlag) {
            this->ss << ".asSInt";
        }
        shiftAmountIntFlag = false;
    }else throw std::runtime_error("Unsupported type for cast");
    this->ss << ")";
    //node.getSubExpr()->accept(*this);
    //this->ss << ")";
}

void SCAM::ChiselConditionVisitor::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::ChiselConditionVisitor::visit(SCAM::ITE &node) {
    /*
     * if (print condition) {
     *   print stmts
     * } else {
     *   print stmts
     * }
     *
     */

    this->ss << "if (";
    node.getConditionStmt()->accept(*this);
    this->ss << ") then" << std::endl;
    indent += indentSize;
    for (auto stmt: node.getIfList()) {
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        std::string statementstring = ChiselConditionVisitor::toString(stmt, indentSize, indent);
        this->ss << statementstring;
        if (statementstring.find('\n') == std::string::npos) this->ss << ";";
        this->ss << std::endl;
    }
    indent -= indentSize;
    for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
    this->ss << "";
    if (!node.getElseList().empty()) {
        this->ss << " else " << std::endl;
        indent += indentSize;
        for (auto stmt: node.getElseList()) {
            for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
            std::string statementstring = ChiselConditionVisitor::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "end if;";
    }

}

void SCAM::ChiselConditionVisitor::visit(SCAM::Assignment &node) {
    PrintStmt::visit(node);
    this->ss <<";\n";
}

void SCAM::ChiselConditionVisitor::visit(SCAM::ArrayOperand &node) {
    this->ss << node.getArrayVar()->getName();
    this->ss << "[";
    node.getIdx()->accept(*this);
    this->ss << "]";
}

void SCAM::ChiselConditionVisitor::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if(begin != --valueMap.end()) this->ss << ",";
    }
}

void SCAM::ChiselConditionVisitor::visit(SCAM::ParamOperand &node) {
    auto param = node.getParameter();
    if(param->isSubVar()){
        this->ss << param->getParent()->getName() << "_" << param->getName();
    }else this->ss << param->getName();

    if (shiftLeftAmountFlag) {
        this->ss << "(18,0)";
    }
}

void SCAM::ChiselConditionVisitor::visit(SCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify_r";
}
