//
// Created by ludwig on 06.06.18.
//

#include <PrintStmt.h>
#include "StmtToXMLVisitor.h"

TiXmlElement *SCAM::StmtToXMLVisitor::toTiXmlElement(SCAM::Stmt *stmt) {
    StmtToXMLVisitor stmtToXMLVisitor;

    return stmtToXMLVisitor.translate(stmt);
}

TiXmlElement * SCAM::StmtToXMLVisitor::translate(SCAM::Stmt *stmt) {
    //std::cout << PrintStmt::toString(stmt) << std::endl;

    this->current = new TiXmlElement("UNKNOWN");;
    stmt->accept(*this);

    return current;
}

void SCAM::StmtToXMLVisitor::visit(SCAM::VariableOperand &node) {
        this->current = new TiXmlElement("VariableRef");
        if(node.getVariable()->isSubVar()){
            this->current->SetAttribute("variable",node.getVariable()->getParent()->getName().c_str());
            this->current->SetAttribute("subvariable",node.getVariable()->getName().c_str());
        }else{
            this->current->SetAttribute("variable",node.getVariable()->getName().c_str());
        }
}

void SCAM::StmtToXMLVisitor::visit(SCAM::IntegerValue &node) {
    this->current = new TiXmlElement("IntegerValue");
    this->current->SetAttribute("value",node.getValue());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::UnsignedValue &node) {
    this->current = new TiXmlElement("UnsignedValue");
    this->current->SetAttribute("value",node.getValueAsString().c_str());
}

void SCAM::StmtToXMLVisitor::visit(SCAM::BoolValue &node) {
    this->current = new TiXmlElement("BoolValue");
    this->current->SetAttribute("value",node.getValueAsString().c_str());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::EnumValue &node) {
    this->current = new TiXmlElement("BoolValue");
    this->current->SetAttribute("value",node.getValueAsString().c_str());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::CompoundValue &node) {
    throw std::runtime_error("Not allowed");
}

void SCAM::StmtToXMLVisitor::visit(SCAM::PortOperand &node) {

    //throw std::runtime_error("Not allowed");


}

void SCAM::StmtToXMLVisitor::visit(SCAM::Assignment &node) {
    this->current = new TiXmlElement("Assignment");
    //LHS
    auto lhs = new TiXmlElement("Lhs");
    lhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getLhs()));
    this->current->LinkEndChild(lhs);
    //RHS
    auto rhs = new TiXmlElement("Rhs");
    rhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getRhs()));
    this->current->LinkEndChild(rhs);
}

void SCAM::StmtToXMLVisitor::visit(SCAM::UnaryExpr &node) {
    this->current = new TiXmlElement("unary");
    this->current->SetAttribute("operation",node.getOperation().c_str());
    this->current->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getExpr()));

}

void SCAM::StmtToXMLVisitor::visit(SCAM::While &node) {
    throw std::runtime_error("Not allowed");
}

void SCAM::StmtToXMLVisitor::visit(SCAM::If &node) {

    throw std::runtime_error("Not allowed");

}

void SCAM::StmtToXMLVisitor::visit(SCAM::SectionOperand &node) {
    this->current = new TiXmlElement("SectionOperand");
    this->current->SetAttribute("value",node.getName().c_str());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::SectionValue &node) {
    this->current = new TiXmlElement("SectionValue");
    this->current->SetAttribute("value",node.getValueAsString().c_str());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::ITE &node) {
    this->current = new TiXmlElement("ITE");
    //Condition
    auto condition = new TiXmlElement("condition");
    condition->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getConditionStmt()));
    this->current->LinkEndChild(condition);
    //IF
    auto if_part = new TiXmlElement("IF");
    for(auto true_stmt:node.getIfList()){
        if_part->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(true_stmt));
    }
    this->current->LinkEndChild(if_part);
    //ELSE
    if(!node.getElseList().empty()){
        auto else_part = new TiXmlElement("ELSE");
        for(auto false_stmt:node.getIfList()){
            else_part->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(false_stmt));
        }
        this->current->LinkEndChild(else_part);
    }
}

void SCAM::StmtToXMLVisitor::visit(SCAM::Arithmetic &node) {
    this->current = new TiXmlElement("arithmetic");
    this->current->SetAttribute("operation",node.getOperation().c_str());

    auto lhs = new TiXmlElement("lhs");
    lhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getLhs()));
    this->current->LinkEndChild(lhs);
    //RHS
    auto rhs = new TiXmlElement("rhs");
    rhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getRhs()));
    this->current->LinkEndChild(rhs);
}

void SCAM::StmtToXMLVisitor::visit(SCAM::Logical &node) {
    this->current = new TiXmlElement("logical");
    this->current->SetAttribute("operation",node.getOperation().c_str());

    auto lhs = new TiXmlElement("lhs");
    lhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getLhs()));
    this->current->LinkEndChild(lhs);
    //RHS
    auto rhs = new TiXmlElement("rhs");
    rhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getRhs()));
    this->current->LinkEndChild(rhs);

}

void SCAM::StmtToXMLVisitor::visit(SCAM::Relational &node) {
    this->current = new TiXmlElement("relational");
    this->current->SetAttribute("operation",node.getOperation().c_str());

    auto lhs = new TiXmlElement("lhs");
    lhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getLhs()));
    this->current->LinkEndChild(lhs);
    //RHS
    auto rhs = new TiXmlElement("rhs");
    rhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getRhs()));
    this->current->LinkEndChild(rhs);
}

void SCAM::StmtToXMLVisitor::visit(SCAM::Bitwise &node) {
    this->current = new TiXmlElement("bitwise");
    this->current->SetAttribute("operation",node.getOperation().c_str());

    auto lhs = new TiXmlElement("lhs");
    lhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getLhs()));
    this->current->LinkEndChild(lhs);
    //RHS
    auto rhs = new TiXmlElement("rhs");
    rhs->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getRhs()));
    this->current->LinkEndChild(rhs);
}

void SCAM::StmtToXMLVisitor::visit(SCAM::Read &node) {
    this->current = new TiXmlElement("read");
    this->current->SetAttribute("port", node.getPort()->getName().c_str());
    this->current->SetAttribute("variable",node.getVariableOperand()->getVariable()->getName().c_str());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::Write &node) {
    this->current = new TiXmlElement("write");
    this->current->SetAttribute("port", node.getPort()->getName().c_str());
    this->current->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getValue()));
}

void SCAM::StmtToXMLVisitor::visit(SCAM::NBRead &node) {
    this->current = new TiXmlElement("nb_read");
    this->current->SetAttribute("port", node.getPort()->getName().c_str());
    this->current->SetAttribute("variable",node.getVariableOperand()->getVariable()->getName().c_str());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::NBWrite &node) {
    this->current = new TiXmlElement("nb_write");
    this->current->SetAttribute("port", node.getPort()->getName().c_str());
    this->current->LinkEndChild(StmtToXMLVisitor::toTiXmlElement(node.getValue()));

}

void SCAM::StmtToXMLVisitor::visit(SCAM::SyncSignal &node) {
    this->current = new TiXmlElement("syncSignal");
    this->current->SetAttribute("port",node.getPort()->getName().c_str());

}

void SCAM::StmtToXMLVisitor::visit(SCAM::DataSignalOperand &node) {
    this->current = new TiXmlElement("dataSignal");
    this->current->SetAttribute("port",node.getDataSignal()->getPort()->getName().c_str());
    if(node.getDataSignal()->isSubSig()){
        this->current->SetAttribute("subsig",node.getDataSignal()->getName().c_str());
    }
}

void SCAM::StmtToXMLVisitor::visit(SCAM::Cast &node) {
    throw std::runtime_error("Not allowed");
}

void SCAM::StmtToXMLVisitor::visit(SCAM::FunctionOperand &node) {
    throw std::runtime_error("Not allowed");
}

void SCAM::StmtToXMLVisitor::visit(SCAM::SubSelect &node) {
    throw std::runtime_error("Not allowed");
}

void SCAM::StmtToXMLVisitor::visit(SCAM::CompoundExpr &node) {
    throw std::runtime_error(" Not implemented");
}
void SCAM::StmtToXMLVisitor::visit(SCAM::ParamOperand &node) {
    throw std::runtime_error(" Not implemented");
}

void SCAM::StmtToXMLVisitor::visit(SCAM::Return &node) {
    throw std::runtime_error(" Not implemented");
}
