//
// Created by ludwig on 06.06.18.
//

#include <ModelGlobal.h>
#include <PrintStmt.h>
#include <ExprVisitor.h>
#include "PrintXML.h"
#include "StmtToXMLVisitor.h"

SCAM::PrintXML::PrintXML(SCAM::Module *module) :
        uniqueId(0),
        module(module) {

    TiXmlDeclaration *decl = new TiXmlDeclaration("1.0", "", "");
    doc.LinkEndChild(decl);
    TiXmlElement *root = new TiXmlElement("SystemCXMLDescription");
    doc.LinkEndChild(root);

    //Module Description
    auto moduleDec = new TiXmlElement("ModuleDescription");
    moduleDec->LinkEndChild(this->createClassID(module));
    moduleDec->LinkEndChild(this->createElement("Name", module->getName()));
    root->LinkEndChild(moduleDec);

    //Datatypes
    for (auto type: SCAM::DataTypes::getDataTypeMap()) {
        moduleDec->LinkEndChild(this->createDataType(type.second));
    }

    //Ports
    for (auto port: module->getPorts()) {
        moduleDec->LinkEndChild(this->createPort(port.second));
    }

    //Variables
    for (auto var: module->getVariableMap()) {
        moduleDec->LinkEndChild(this->createVar(var.second));
        if (var.second->isCompoundType()) {
            for (auto subvar: var.second->getSubVarList()) {
                moduleDec->LinkEndChild(this->createVar(subvar));
            }
        }
    }

    //FSM
    //Creation map with IDs for the sections
    for (auto section: module->getFSM()->getSectionMap()) {
        sectionIdMap.insert(std::make_pair(section.first, uniqueId++));
    }
    for (auto section: module->getFSM()->getSectionMap()) {
        moduleDec->LinkEndChild(this->createSection(section.first, section.second));
    }
}

std::string SCAM::PrintXML::print() {
    // Declare a printer
    TiXmlPrinter printer;

    // attach it to the document you want to convert in to a std::string
    doc.Accept(&printer);

    // Create a std::string and copy your document data in to the string
    std::string str = printer.CStr();

    return str;

}

TiXmlElement *SCAM::PrintXML::createClassID(AbstractNode *abstractNode) {
    return this->createElement("Int_Class_ID", std::to_string(getClassId(abstractNode)));
}

int SCAM::PrintXML::getClassId(AbstractNode *abstractNode) {
    if (this->modelIdMap.find(abstractNode) == this->modelIdMap.end()) {
        this->modelIdMap.insert(std::make_pair(abstractNode, uniqueId));
        return uniqueId++;
    } else return this->modelIdMap.find(abstractNode)->second;

}

TiXmlElement *SCAM::PrintXML::createElement(std::string name, std::string text) {
    auto classId = new TiXmlElement(name.c_str());
    classId->LinkEndChild(new TiXmlText(text.c_str()));
    return classId;
}

TiXmlElement *SCAM::PrintXML::createDataType(SCAM::DataType *dataType) {
    auto type_decl = new TiXmlElement("DataType");
    //Class ID
    type_decl->LinkEndChild(this->createClassID(dataType));

    if (dataType->isCompoundType()) {
        type_decl->SetAttribute("type", "CompoundType");
        type_decl->LinkEndChild(this->createElement("Name", dataType->getName().c_str()));
        for (auto subVar: dataType->getSubVarMap()) {
            auto *subVarElement = new TiXmlElement("CompoundSubVariable");
            subVarElement->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
            subVarElement->LinkEndChild(this->createElement("Name", subVar.first));
            subVarElement->LinkEndChild(this->createElement("DataTypeRef", std::to_string(this->getClassId(subVar.second))));
            type_decl->LinkEndChild(subVarElement);
        }
    } else if (dataType->isEnumType()) {
        type_decl->SetAttribute("type", "EnumType");
        type_decl->LinkEndChild(this->createElement("Name", dataType->getName().c_str()));
        for (auto enumVal: dataType->getEnumValueMap()) {
            auto *enumElement = new TiXmlElement("EnumElement");
            enumElement->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
            enumElement->LinkEndChild(this->createElement("Name", enumVal.first));
            type_decl->LinkEndChild(enumElement);
        }
    } else {
        type_decl->SetAttribute("type", "BuiltInType");
        //Type-name
        type_decl->LinkEndChild(this->createElement("Type", dataType->getName().c_str()));
    }
    return type_decl;
}

TiXmlNode *SCAM::PrintXML::createPort(SCAM::Port *port) {
    auto decl = new TiXmlElement("Port");
    decl->LinkEndChild(this->createClassID(port));
    decl->LinkEndChild(this->createElement("Name", port->getName()));
    decl->LinkEndChild(this->createElement("Interface", port->getInterface()->getName()));
    decl->LinkEndChild(this->createElement("Direction", port->getInterface()->getDirection()));
    decl->LinkEndChild(this->createElement("DataTypeRef", std::to_string(this->getClassId(port->getDataType()))));

    return decl;
}

TiXmlNode *SCAM::PrintXML::createVar(SCAM::Variable *var) {
    auto decl = new TiXmlElement("Variable");
    decl->LinkEndChild(this->createClassID(var));
    decl->LinkEndChild(this->createElement("Name", var->getFullName()));
    if (var->getDataType()->isBuiltInType()) {
        auto init = new TiXmlElement("Init");
        init->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        init->LinkEndChild(this->createElement("Init", var->getInitialValue()->getValueAsString()));
        decl->LinkEndChild(init);
    }
    decl->LinkEndChild(this->createElement("DataTypeRef", std::to_string(this->getClassId(var->getDataType()))));
    return decl;
}

TiXmlNode *SCAM::PrintXML::createSection(const std::string name, std::vector<SCAM::Stmt *> stmts) {
    auto decl = new TiXmlElement("Section");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(sectionIdMap.at(name))));
    decl->LinkEndChild(this->createElement("Name", name));
    for (auto stmt: stmts) {
        stmt->accept(*this);
        decl->LinkEndChild(this->currentElement);
    }
    return decl;
}

void SCAM::PrintXML::visit(SCAM::Assignment &node) {
    //CASE: nextsection assignment
    if (auto sectionOp = dynamic_cast<SectionOperand *>(node.getLhs())) {
        auto decl = new TiXmlElement("Statement");
        decl->SetAttribute("type", "ChangeSection");
        decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        auto sectionValue = dynamic_cast<SectionValue *>(node.getRhs());
        std::string id = std::to_string(this->sectionIdMap.find(sectionValue->getValueAsString())->second);
        decl->LinkEndChild(this->createElement("SectionRef", id));
        this->currentElement = decl;
    } else {
        auto decl = new TiXmlElement("Statement");
        decl->SetAttribute("type", "Assignment");
        decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        decl->LinkEndChild(this->createElement("AssignmentOperator", "="));
        //LHS
        node.getLhs()->accept(*this);
        decl->LinkEndChild(this->currentElement);
        //RHS
        node.getRhs()->accept(*this);
        decl->LinkEndChild(this->currentElement);
        this->currentElement = decl;
    }
}

void SCAM::PrintXML::visit(SCAM::VariableOperand &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "VariableReferenceContainer");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("VariableRef", std::to_string(this->getClassId(node.getVariable()))));
    this->currentElement = decl;
}

void SCAM::PrintXML::visit(SCAM::Read &node) {
    auto decl = new TiXmlElement("Statement");
    decl->SetAttribute("type", "Blocking");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("CommunicationType", "Read"));
    node.getVariableOperand()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    decl->LinkEndChild(this->createElement("PortRef", std::to_string(this->getClassId(node.getPort()))));
    this->currentElement = decl;
}

void SCAM::PrintXML::visit(SCAM::Write &node) {
    auto decl = new TiXmlElement("Statement");
    decl->SetAttribute("type", "Blocking");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("CommunicationType", "Write"));
    node.getValue()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    decl->LinkEndChild(this->createElement("PortRef", std::to_string(this->getClassId(node.getPort()))));
    this->currentElement = decl;
}

void SCAM::PrintXML::visit(SCAM::NBRead &node) {
    if (node.getPort()->getInterface()->isShared()){
        auto decl = new TiXmlElement("Statement");
        decl->SetAttribute("type", "Shared");
        decl->LinkEndChild(this->createElement("CommunicationType", "Get"));
        decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        node.getVariableOperand()->accept(*this);
        decl->LinkEndChild(this->currentElement);
        decl->LinkEndChild(this->createElement("PortRef", std::to_string(this->getClassId(node.getPort()))));
        this->currentElement = decl;
    }else{
        auto decl = new TiXmlElement("Expression");
        decl->SetAttribute("type", "NonBlocking");
        decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        decl->LinkEndChild(this->createElement("CommunicationType", "Read"));
        auto varRefCont = new TiXmlElement("VariableReferenceContainer");
        varRefCont->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        node.getVariableOperand()->accept(*this);
        varRefCont->LinkEndChild(this->currentElement);
        decl->LinkEndChild(varRefCont);

        decl->LinkEndChild(this->createElement("PortRef", std::to_string(this->getClassId(node.getPort()))));
        this->currentElement = decl;
    }

}

void SCAM::PrintXML::visit(SCAM::NBWrite &node) {
    if (node.getPort()->getInterface()->isShared()){
        auto decl = new TiXmlElement("Statement");
        decl->SetAttribute("type", "Shared");
        decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        node.getValue()->accept(*this);
        decl->LinkEndChild(this->currentElement);
        decl->LinkEndChild(this->createElement("CommunicationType", "Set"));
        decl->LinkEndChild(this->createElement("PortRef", std::to_string(this->getClassId(node.getPort()))));
        this->currentElement = decl;
    } else {
        auto decl = new TiXmlElement("Expression");
        decl->SetAttribute("type", "NonBlocking");
        decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
        decl->LinkEndChild(this->createElement("CommunicationType", "Write"));

        node.getValue()->accept(*this);
        decl->LinkEndChild(this->currentElement);

        decl->LinkEndChild(this->createElement("PortRef", std::to_string(this->getClassId(node.getPort()))));
        this->currentElement = decl;
    }
}

void SCAM::PrintXML::visit(SCAM::SectionOperand &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void SCAM::PrintXML::visit(SCAM::SectionValue &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void SCAM::PrintXML::visit(SCAM::ITE &node) {
    auto decl = new TiXmlElement("Statement");
    decl->SetAttribute("type", "ITE");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    //Condition
    node.getConditionStmt()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    //If-part
    auto ifPart = new TiXmlElement("IfPart");
    ifPart->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    for (auto ifStmt: node.getIfList()) {
        ifStmt->accept(*this);
        ifPart->LinkEndChild(this->currentElement);
    }
    decl->LinkEndChild(ifPart);
    //Else-part
    auto elsePart = new TiXmlElement("ElsePart");
    elsePart->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    for (auto elseStmt: node.getElseList()) {
        elseStmt->accept(*this);
        elsePart->LinkEndChild(this->currentElement);
    }
    decl->LinkEndChild(elsePart);

    this->currentElement = decl;
}

std::string SCAM::PrintXML::printModel(SCAM::Module *node, std::string outputDirectory) {

    PrintXML printXML(node);
    return printXML.print();
}

void PrintXML::visit(class SubSelect &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class FunctionOperand &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class CompoundExpr &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class ParamOperand &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class Return &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class IntegerValue &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "Constant");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("Constant", node.getValueAsString()));
    this->currentElement = decl;
}

void PrintXML::visit(class UnsignedValue &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "Constant");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("Constant", node.getValueAsString()));
    this->currentElement = decl;
}

void PrintXML::visit(class BoolValue &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "Constant");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("Constant", node.getValueAsString()));
    this->currentElement = decl;
}

void PrintXML::visit(class EnumValue &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "Constant");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("Constant", node.getValueAsString()));
    this->currentElement = decl;
}

void PrintXML::visit(class CompoundValue &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "Constant");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("Constant", node.getValueAsString()));
    this->currentElement = decl;
}

void PrintXML::visit(class PortOperand &node) {
    this->currentElement = new TiXmlElement("UNKNOWN");
}

void PrintXML::visit(class UnaryExpr &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "UnaryExpression");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("UnaryOperator", node.getOperation()));
    node.getExpr()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    this->currentElement = decl;

}

void PrintXML::visit(class While &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class If &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class Arithmetic &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "BinaryExpression");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("BinaryOperator", node.getOperation()));

    //LHS
    node.getLhs()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    //RHS
    node.getRhs()->accept(*this);
    this->currentElement->SetValue("Expression_2");
    decl->LinkEndChild(this->currentElement);

    this->currentElement = decl;
}

void PrintXML::visit(class Logical &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "BinaryExpression");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("BinaryOperator", node.getOperation()));

    //LHS
    node.getLhs()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    //RHS
    node.getRhs()->accept(*this);
    this->currentElement->SetValue("Expression_2");
    decl->LinkEndChild(this->currentElement);

    this->currentElement = decl;

}

void PrintXML::visit(class Relational &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "BinaryExpression");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("BinaryOperator", node.getOperation()));

    //LHS
    node.getLhs()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    //RHS
    node.getRhs()->accept(*this);
    this->currentElement->SetValue("Expression_2");
    decl->LinkEndChild(this->currentElement);

    this->currentElement = decl;
}

void PrintXML::visit(class Bitwise &node) {
    auto decl = new TiXmlElement("Expression");
    decl->SetAttribute("type", "BinaryExpression");
    decl->LinkEndChild(this->createElement("Int_Class_ID", std::to_string(uniqueId++)));
    decl->LinkEndChild(this->createElement("BinaryOperator", node.getOperation()));

    //LHS
    node.getLhs()->accept(*this);
    decl->LinkEndChild(this->currentElement);
    //RHS
    node.getRhs()->accept(*this);
    this->currentElement->SetValue("Expression_2");
    decl->LinkEndChild(this->currentElement);

    this->currentElement = decl;
}

void PrintXML::visit(class SyncSignal &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class DataSignalOperand &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

void PrintXML::visit(class Cast &node) {
    throw std::runtime_error(" NOT ALLOWED ");
}

std::map<std::string, std::string> PrintXML::printModel(Model *node) {
    if(node->getModules().size() != 1){
        throw std::runtime_error("Please only run single modules.\n");
    }
    auto module = node->getModules().begin()->second;
    PrintXML test(module);
    return {std::make_pair(module->getName()+".xml",test.print())};
}


