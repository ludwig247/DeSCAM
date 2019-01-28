//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_PRINTSTMTFORSYSTEMC_H
#define PROJECT_PRINTSTMTFORSYSTEMC_H


#include "PrintStmt.h"
#include <ModelGlobal.h>


namespace SCAM {

    class PrintStmtForSystemC : public PrintStmt {
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0, bool sourceConstructor = false) {
            PrintStmtForSystemC printer;
            printer.sourceConstructor = sourceConstructor;
            return printer.createString(stmt, indentSize, indentOffset);
        }

    private:
        bool sourceConstructor = false;

    protected:

        virtual void visit(VariableOperand &node) {
            if (node.getVariable()->isSubVar()) {
                if (sourceConstructor) return;
                this->ss << node.getVariable()->getParent()->getName() << "." << node.getVariable()->getName();
            } else {
                this->ss << node.getVariable()->getName();
            }
        }

        virtual void visit(SCAM::Assignment &node) {
            node.getLhs()->accept(*this);
            if (sourceConstructor){
                this->ss << "(";

                node.getRhs()->accept(*this);
                this->ss << ")";
            } else {
                this->ss << " = ";

                node.getRhs()->accept(*this);

            }
        }

        virtual void visit(Read &node) {
            if (sourceConstructor) {
                this->ss << "(";
                return;
            }//"(" indicator for init_section to ignore this statement
            this->ss << node.getPort()->getName();
            auto interface = node.getPort()->getInterface()->getName();
            if (interface == "blocking" || interface == "master" || interface == "slave") {
                this->ss << "->read(";
                node.getVariableOperand()->accept(*this);
            } else if (interface == "synch") {
                this->ss << "->req(";
            } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
            this->ss << ")";
        }

        virtual void visit(Write &node) {
            if (sourceConstructor) {
                this->ss << "(";
                return;
            }//"(" indicator for init_section to ignore this statement
            this->ss << node.getPort()->getName();
            auto interface = node.getPort()->getInterface()->getName();
            if (interface == "blocking" || interface == "master" || interface == "slave") {
                this->ss << "->write(";
                node.getValue()->accept(*this);
            } else if (interface == "synch") {
                this->ss << "->ack(";
            } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
            this->ss << ")";
        }

        virtual void visit(NBRead &node) {
            if (sourceConstructor) {
                this->ss << "(";
                return;
            }//"(" indicator for init_section to ignore this statement
            this->ss << node.getPort()->getName();
            if (node.getPort()->getInterface()->getName() == "shared") {
                this->ss << "->get(";
            } else if (node.getPort()->getInterface()->isBlocking()) {
                this->ss << "->nb_read(";
            } else if (node.getPort()->getInterface()->isSlave()) {
                this->ss << "->nb_read(";
            } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
            node.getVariableOperand()->accept(*this);
            this->ss << ")";
        }

        virtual void visit(NBWrite &node) {
            if (sourceConstructor) {
                this->ss << "(";
                return;
            }//"(" indicator for init_section to ignore this statement
            this->ss << node.getPort()->getName();
            if (node.getPort()->getInterface()->getName() == "shared") {
                this->ss << "->set(";
            } else if (node.getPort()->getInterface()->isBlocking()) {
                this->ss << "->nb_write(";
            } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
            node.getValue()->accept(*this);
            this->ss << ")";
        }

        virtual void visit(ITE &node) {
            /*
             * if (print condition) {
             *   print stmts
             * } else {
             *   print stmts
             * }
             * */

            this->ss << "if (";
            node.getConditionStmt()->accept(*this);
            this->ss << ") {" << std::endl;
            indent += indentSize;
            for (auto stmt: node.getIfList()) {
                for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
                std::string statementstring = PrintStmtForSystemC::toString(stmt, indentSize, indent);
                this->ss << statementstring;
                if (statementstring.find('\n') == std::string::npos) this->ss << ";";
                this->ss << std::endl;
            }
            indent -= indentSize;
            for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
            this->ss << "}";
            if (!node.getElseList().empty()) {
                this->ss << " else {" << std::endl;
                indent += indentSize;
                for (auto stmt: node.getElseList()) {
                    for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
                    std::string statementstring = PrintStmtForSystemC::toString(stmt, indentSize, indent);
                    this->ss << statementstring;
                    if (statementstring.find('\n') == std::string::npos) this->ss << ";";
                    this->ss << std::endl;
                }
                indent -= indentSize;
                for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
                this->ss << "}";
            }
        }

        virtual void visit(Cast &node) {
            this->ss << "static_cast<" << node.getDataType()->getName() << ">(";
            node.getSubExpr()->accept(*this);
            this->ss << ")";
        }
    };
}

#endif //PROJECT_PRINTSTMTFORSYSTEMC_H