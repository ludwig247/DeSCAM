//
// Created by tobias on 12.06.17.
//

#ifndef PROJECT_PRIMTSTMTFORPROMELA_H
#define PROJECT_PRIMTSTMTFORPROMELA_H



#include <PrintStmt.h>
#include <ModelGlobal.h>


namespace SCAM{

    class PrintStmtForPromela: public PrintStmt{
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize=2, unsigned int indentOffset=0) {
            PrintStmtForPromela printer;
            return printer.createString(stmt, indentSize, indentOffset);
        }

    protected:

        virtual void visit(EnumValue &node){
            this->ss << node.getDataType()->getName() << "_" << node.getEnumValue();

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
            this->ss << node.getPort()->getName() << "_sync";
        };
        virtual void visit(DataSignalOperand &node){
            auto interface =node.getDataSignal()->getPort()->getInterface();
            if(interface->isShared()){
                auto port = node.getDataSignal()->getPort();

                if (node.getDataSignal()->isSubSig()) {
                    this->ss << "." + node.getDataSignal()->getName();
                }
            }else{
            this->ss << node.getDataSignal()->getPort()->getName() << "_data";
            if (node.getDataSignal()->isSubSig()) {
                this->ss << "." + node.getDataSignal()->getName();
            }
            }
        };


    };
}

#endif //PROJECT_PRIMTSTMTFORDOT_H
