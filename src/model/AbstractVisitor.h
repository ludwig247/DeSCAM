//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_ABSTRACTVISITOR_H
#define SCAM_ABSTRACTVISITOR_H


namespace SCAM{

class AbstractVisitor {
public:
    AbstractVisitor(){};
    virtual ~AbstractVisitor(){};

    virtual void visit(class Model& node) = 0;
    virtual void visit(class Module& node) = 0;
    virtual void visit(class ModuleInstance& node) = 0;
    virtual void visit(class Port& node) = 0;
    virtual void visit(class DataSignal& node) = 0;
    virtual void visit(class Channel& node) = 0;
    virtual void visit(class Interface& node) = 0;
    virtual void visit(class Variable& node) = 0;
    virtual void visit(class FSM& node) = 0;
    virtual void visit(class DataType& node) = 0;
    virtual void visit(class Function& node) = 0;
    virtual void visit(class Parameter& node) = 0;
};
}


#endif //SCAM_ABSTRACTVISITOR_H
