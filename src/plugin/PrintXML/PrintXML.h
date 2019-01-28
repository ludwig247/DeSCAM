//
// Created by ludwig on 06.06.18.
//

#ifndef PROJECT_PRINTXML_H
#define PROJECT_PRINTXML_H

#include <tinyxml/tinyxml.h>
#include <iostream>
#include <Module.h>
#include "StmtToXMLVisitor.h"
#include <PluginFactory.h>

namespace SCAM{
class PrintXML: public StmtAbstractVisitor, public PluginFactory {
public:
    PrintXML() = default;
    ~ PrintXML() = default;

    virtual std::map<std::string, std::string> printModel(Model *node);

    explicit PrintXML(SCAM::Module * module);

    std::string print();

    std::string printModel(SCAM::Module *node, std::string outputDirectory);

    virtual void visit(class Assignment &node);
    virtual void visit(class VariableOperand &node);
    virtual void visit(class Read &node);
    virtual void visit(class Write &node);
    virtual void visit(class NBRead &node);
    virtual void visit(class NBWrite &node);
    virtual void visit(class SectionOperand &node);
    virtual void visit(class SectionValue &node);
    virtual void visit(class ITE &node);
    virtual void visit(class IntegerValue &node);
    virtual void visit(class UnsignedValue &node);
    virtual void visit(class BoolValue &node);
    virtual void visit(class EnumValue &node);
    virtual void visit(class CompoundValue &node);
    virtual void visit(class PortOperand &node);
    virtual void visit(class UnaryExpr &node);
    virtual void visit(class While &node);
    virtual void visit(class If &node);
    virtual void visit(class Arithmetic &node);
    virtual void visit(class Logical &node);
    virtual void visit(class Relational &node);
    virtual void visit(class Bitwise &node);
    virtual void visit(class SyncSignal &node);
    virtual void visit(class DataSignalOperand &node);
    virtual void visit(class Cast &node);
    virtual void visit(class FunctionOperand &node);
    virtual void visit(class SubSelect &node);
    virtual void visit(class CompoundExpr &node);
    virtual void visit(class ParamOperand &node);
    virtual void visit(class Return &node);

private:
    TiXmlElement * createClassID(AbstractNode *abstractNode);
    TiXmlElement * createElement(std::string text, std::string name);
    TiXmlElement *createDataType(DataType *dataType);
    TiXmlNode *createPort(Port *port);
    TiXmlNode *createVar(Variable *var);
    TiXmlNode *createSection(const std::string name, std::vector<Stmt *> stmts);
    int getClassId(AbstractNode *abstractNode) ;



    TiXmlDocument doc;
    SCAM::Module * module = nullptr;
    int uniqueId = 0;

    std::map<AbstractNode*,int> modelIdMap;
    std::map<std::string,int> sectionIdMap;
    TiXmlElement *currentElement = nullptr;
};
}

#endif //PROJECT_PRINTXML_H
