//
// Created by anna on 12.07.18.
//

#ifndef PROJECT_RHS_LTL_H
#define PROJECT_RHS_LTL_H

#include <PrintStmt.h>
#include <ModelGlobal.h>

namespace SCAM{

    class RHS_LTL: public PrintStmt{
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize=2, unsigned int indentOffset=0) {
            RHS_LTL printer;
            return printer.createString(stmt, indentSize, indentOffset);
        }

    protected:

        virtual void visit(EnumValue &node){
            this->ss << node.getEnumValue();

        }

        virtual void visit(Logical &node) {
            this->ss << "(";
            node.getLhs()->accept(*this);

            if(node.getOperation() == "and"){
                this->ss << "  &&  ";
            }else this->ss << " " + node.getOperation() << " ";
            node.getRhs()->accept(*this);
            this->ss << ")";
        }


        virtual void visit(UnaryExpr &node){
            if(node.getOperation() == "not") this->ss << "!(";
            else this->ss << node.getOperation() << "(";
            node.getExpr()->accept(*this);
            this->ss << ")";

        }
        virtual void visit(SyncSignal &node){
            if(node.getPort()->getInterface()->isBlockingOut()){
                this->ss << node.getPort()->getName() << "_sync";
            }
            //else {
            //  this->ss << "true";
            //}
        };

        //virtual void visit(DataSignalOperand &node){
        //  auto interface =node.getDataSignal()->getPort()->getInterface();
        //if(interface->isShared()){
        //  auto port = node.getDataSignal()->getPort();
        //this->ss << ModelGlobal::getModel()->getTopInstance()->getChannel(port)->getName();
        //if (node.getDataSignal()->isSubSig()) {
        //  this->ss << "." + node.getDataSignal()->getName();
        //}
        //}else{
        //  this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
        //if (node.getDataSignal()->isSubSig()) {
        //   this->ss << "." + node.getDataSignal()->getName();
        //    }
        //}
        //};

        virtual void visit(DataSignalOperand &node) {
            if (node.getDataSignal()->isSubSig()) {
                this->ss << node.getDataSignal()->getParent()->getName() <<"_"  << node.getDataSignal()->getName() << "_at_sync";
            } else {
                this->ss << node.getDataSignal()->getName() << "_at_sync";
            }

//    this->ss << "()" << node.getOperandName();
//    if(node.getDataSignal()isSubSig())   this->ss <<"_" + node.getSubSigName();
//    this->ss << "_sig";
        }

        virtual void visit(VariableOperand &node) {
            if (node.getVariable()->isSubVar()) {
                this->ss << node.getVariable()->getParent()->getName() <<"_"  << node.getVariable()->getName() << "_at_notify";
            } else {
                this->ss << node.getVariable()->getName() << "_at_notify";
            }
        }

    };
}

#endif //PROJECT_RHS_LTL_H
