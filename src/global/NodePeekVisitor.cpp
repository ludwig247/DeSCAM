//
// Created by pmorku on 7/15/18.
//

#include "NodePeekVisitor.h"

namespace SCAM {

    NodePeekVisitor::NodePeekVisitor(Stmt *node) {
        node->accept(*this);
    }

    bool NodePeekVisitor::isConstTypeNode() const {
        return isConstTypeNodeFlag;
    }

    bool NodePeekVisitor::isConstTypeNode(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.isConstTypeNode();
    }

    VariableOperand *NodePeekVisitor::nodePeekVariableOperand() const {
        return nodePtrVariableOperand;
    }

    IntegerValue *NodePeekVisitor::nodePeekIntegerValue() const {
        return nodePtrIntegerValue;
    }

    UnsignedValue *NodePeekVisitor::nodePeekUnsignedValue() const {
        return nodePtrUnsignedValue;
    }

    BoolValue *NodePeekVisitor::nodePeekBoolValue() const {
        return nodePtrBoolValue;
    }

    EnumValue *NodePeekVisitor::nodePeekEnumValue() const {
        return nodePtrEnumValue;
    }

    CompoundValue *NodePeekVisitor::nodePeekCompoundValue() const {
        return nodePtrCompoundValue;
    }

    PortOperand *NodePeekVisitor::nodePeekPortOperand() const {
        return nodePtrPortOperand;
    }

    Assignment *NodePeekVisitor::nodePeekAssignment() const {
        return nodePtrAssignment;
    }

    UnaryExpr *NodePeekVisitor::nodePeekUnaryExpr() const {
        return nodePtrUnaryExpr;
    }

    While *NodePeekVisitor::nodePeekWhile() const {
        return nodePtrWhile;
    }

    If *NodePeekVisitor::nodePeekIf() const {
        return nodePtrIf;
    }

    SectionOperand *NodePeekVisitor::nodePeekSectionOperand() const {
        return nodePtrSectionOperand;
    }

    SectionValue *NodePeekVisitor::nodePeekSectionValue() const {
        return nodePtrSectionValue;
    }

    ITE *NodePeekVisitor::nodePeekITE() const {
        return nodePtrITE;
    }

    Arithmetic *NodePeekVisitor::nodePeekArithmetic() const {
        return nodePtrArithmetic;
    }

    Logical *NodePeekVisitor::nodePeekLogical() const {
        return nodePtrLogical;
    }

    Relational *NodePeekVisitor::nodePeekRelational() const {
        return nodePtrRelational;
    }

    Bitwise *NodePeekVisitor::nodePeekBitwise() const {
        return nodePtrBitwise;
    }

    Read *NodePeekVisitor::nodePeekRead() const {
        return nodePtrRead;
    }

    Write *NodePeekVisitor::nodePeekWrite() const {
        return nodePtrWrite;
    }

    SyncSignal *NodePeekVisitor::nodePeekSyncSignal() const {
        return nodePtrSyncSignal;
    }

    DataSignalOperand *NodePeekVisitor::nodePeekDataSignalOperand() const {
        return nodePtrDataSignalOperand;
    }

    Cast *NodePeekVisitor::nodePeekCast() const {
        return nodePtrCast;
    }

    FunctionOperand *NodePeekVisitor::nodePeekFunctionOperand() const {
        return nodePtrFunctionOperand;
    }


    CompoundExpr *NodePeekVisitor::nodePeekCompoundExpr() const {
        return nodePtrCompoundExpr;
    }




    ParamOperand *NodePeekVisitor::nodePeekParamOperand() const {
        return nodePtrParamOperand;
    }

    Return *NodePeekVisitor::nodePeekReturn() const {
        return nodePtrReturn;
    }

    ArrayOperand *NodePeekVisitor::nodePeekArrayOperand() const {
        return nodePtrArrayOperand;
    }

    Notify *NodePeekVisitor::nodePeekNotify() const {
        return nodePtrNotify;
    }

    Wait *NodePeekVisitor::nodePeekWait() const {
        return nodePtrWait;
    }

    Peek *NodePeekVisitor::nodePeekPeek() const {
        return nodePtrPeek;
    }

    ArrayExpr *NodePeekVisitor::nodePeekArrayExpr() const {
        return nodePtrArrayExpr;
    }

    TimePointOperand *NodePeekVisitor::nodePeekTimePointOperand() const {
        return nodePtrTimePointOperand;
    }

    VariableOperand *NodePeekVisitor::nodePeekVariableOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekVariableOperand();
    }

    IntegerValue *NodePeekVisitor::nodePeekIntegerValue(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekIntegerValue();
    }

    UnsignedValue *NodePeekVisitor::nodePeekUnsignedValue(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekUnsignedValue();
    }

    BoolValue *NodePeekVisitor::nodePeekBoolValue(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekBoolValue();
    }

    EnumValue *NodePeekVisitor::nodePeekEnumValue(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekEnumValue();
    }

    CompoundValue *NodePeekVisitor::nodePeekCompoundValue(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekCompoundValue();
    }

    PortOperand *NodePeekVisitor::nodePeekPortOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekPortOperand();
    }

    Assignment *NodePeekVisitor::nodePeekAssignment(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekAssignment();
    }

    UnaryExpr *NodePeekVisitor::nodePeekUnaryExpr(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekUnaryExpr();
    }

    While *NodePeekVisitor::nodePeekWhile(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekWhile();
    }

    If *NodePeekVisitor::nodePeekIf(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekIf();
    }

    SectionOperand *NodePeekVisitor::nodePeekSectionOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekSectionOperand();
    }

    SectionValue *NodePeekVisitor::nodePeekSectionValue(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekSectionValue();
    }

    ITE *NodePeekVisitor::nodePeekITE(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekITE();
    }

    Arithmetic *NodePeekVisitor::nodePeekArithmetic(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekArithmetic();
    }

    Logical *NodePeekVisitor::nodePeekLogical(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekLogical();
    }

    Relational *NodePeekVisitor::nodePeekRelational(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekRelational();
    }

    Bitwise *NodePeekVisitor::nodePeekBitwise(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekBitwise();
    }

    Read *NodePeekVisitor::nodePeekRead(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekRead();
    }

    Write *NodePeekVisitor::nodePeekWrite(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekWrite();
    }

    SyncSignal *NodePeekVisitor::nodePeekSyncSignal(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekSyncSignal();
    }

    DataSignalOperand *NodePeekVisitor::nodePeekDataSignalOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekDataSignalOperand();
    }

    Cast *NodePeekVisitor::nodePeekCast(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekCast();
    }

    Wait *NodePeekVisitor::nodePeekWait(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekWait();
    }

    Peek *NodePeekVisitor::nodePeekPeek(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekPeek();
    }

    FunctionOperand *NodePeekVisitor::nodePeekFunctionOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekFunctionOperand();
    }


    CompoundExpr *NodePeekVisitor::nodePeekCompoundExpr(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekCompoundExpr();
    }



    ParamOperand *NodePeekVisitor::nodePeekParamOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekParamOperand();
    }

    Return *NodePeekVisitor::nodePeekReturn(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekReturn();
    }

    ArrayOperand *NodePeekVisitor::nodePeekArrayOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekArrayOperand();
    }

    Notify *NodePeekVisitor::nodePeekNotify(SCAM::Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekNotify();
    }

    ArrayExpr *NodePeekVisitor::nodePeekArrayExpr(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekArrayExpr();
    }

    TimePointOperand *NodePeekVisitor::nodePeekTimePointOperand(Stmt *node) {
        NodePeekVisitor peekVisitor(node);
        return peekVisitor.nodePeekTimePointOperand();
    }


    void NodePeekVisitor::visit(VariableOperand &node) {
        nodePtrVariableOperand = &node;
    }


    void NodePeekVisitor::visit(IntegerValue &node) {
        nodePtrIntegerValue = &node;
        isConstTypeNodeFlag = true;
    }

    void NodePeekVisitor::visit(UnsignedValue &node) {
        nodePtrUnsignedValue = &node;
        isConstTypeNodeFlag = true;
    }

    void NodePeekVisitor::visit(BoolValue &node) {
        nodePtrBoolValue = &node;
        isConstTypeNodeFlag = true;
    }

    void NodePeekVisitor::visit(EnumValue &node) {
        nodePtrEnumValue = &node;
        isConstTypeNodeFlag = true;
    }

    void NodePeekVisitor::visit(CompoundValue &node) {
        nodePtrCompoundValue = &node;
        isConstTypeNodeFlag = true;
    }

    void NodePeekVisitor::visit(PortOperand &node) {
        nodePtrPortOperand = &node;
    }

    void NodePeekVisitor::visit(Assignment &node) {
        nodePtrAssignment = &node;
    }

    void NodePeekVisitor::visit(UnaryExpr &node) {
        nodePtrUnaryExpr = &node;
    }

    void NodePeekVisitor::visit(While &node) {
        nodePtrWhile = &node;
    }

    void NodePeekVisitor::visit(If &node) {
        nodePtrIf = &node;
    }

    void NodePeekVisitor::visit(SectionOperand &node) {
        nodePtrSectionOperand = &node;
    }

    void NodePeekVisitor::visit(SectionValue &node) {
        nodePtrSectionValue = &node;
        isConstTypeNodeFlag = true;
    }

    void NodePeekVisitor::visit(ITE &node) {
        nodePtrITE = &node;
    }

    void NodePeekVisitor::visit(Arithmetic &node) {
        nodePtrArithmetic = &node;
    }

    void NodePeekVisitor::visit(Logical &node) {
        nodePtrLogical = &node;
    }

    void NodePeekVisitor::visit(Relational &node) {
        nodePtrRelational = &node;
    }

    void NodePeekVisitor::visit(Bitwise &node) {
        nodePtrBitwise = &node;
    }

    void NodePeekVisitor::visit(Read &node) {
        nodePtrRead = &node;
    }

    void NodePeekVisitor::visit(Write &node) {
        nodePtrWrite = &node;
    }

    void NodePeekVisitor::visit(SyncSignal &node) {
        nodePtrSyncSignal = &node;
    }

    void NodePeekVisitor::visit(DataSignalOperand &node) {
        nodePtrDataSignalOperand = &node;
    }

    void NodePeekVisitor::visit(Cast &node) {
        nodePtrCast = &node;
    }

    void NodePeekVisitor::visit(FunctionOperand &node) {
        nodePtrFunctionOperand = &node;
    }

    void NodePeekVisitor::visit(ArrayOperand &node) {
        nodePtrArrayOperand = &node;
    }

    void NodePeekVisitor::visit(CompoundExpr &node) {
        nodePtrCompoundExpr = &node;
    }

    void NodePeekVisitor::visit(ParamOperand &node) {
        nodePtrParamOperand = &node;
    }

    void NodePeekVisitor::visit(Return &node) {
        nodePtrReturn = &node;
    }

    void NodePeekVisitor::visit(class Notify &node) {
        nodePtrNotify = &node;

    }

    void NodePeekVisitor::visit(class Wait &node) {
        nodePtrWait = &node;

    }

    void NodePeekVisitor::visit(class Peek &node) {
        nodePtrPeek = &node;
    }

    void NodePeekVisitor::visit(struct ArrayExpr &node) {
        nodePtrArrayExpr = &node;
    }

    void NodePeekVisitor::visit(struct TimePointOperand &node) {
        nodePtrTimePointOperand = &node;
    }


}




