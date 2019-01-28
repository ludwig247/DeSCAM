//
// Created by ludwig on 12.10.16.
//

#include "ReplaceStmt.h"

#include "Stmts_all.h"




SCAM::ReplaceStmt::ReplaceStmt(SCAM::Stmt *toReplace, SCAM::Stmt *replaceWith) :
    toReplace(toReplace),
    replaceWith(replaceWith),
    newStmt(nullptr){

}

SCAM::Stmt *SCAM::ReplaceStmt::getNewStmt() const {
    if(newStmt == nullptr) throw std::runtime_error("Somethin went wrong during stmt replacement");
    return newStmt;
}

void SCAM::ReplaceStmt::visit(struct VariableOperand &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(SCAM::SubSelect &node) {
    throw std::runtime_error("Not implemented");
}


void SCAM::ReplaceStmt::visit(struct IntegerValue &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;
}
void SCAM::ReplaceStmt::visit(struct UnsignedValue &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;
}


void SCAM::ReplaceStmt::visit(struct EnumValue &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct BoolValue &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;
}


void SCAM::ReplaceStmt::visit(struct CompoundValue &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct PortOperand &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct Assignment &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else{

        node.getLhs()->accept(*this);
        SCAM::Stmt * lhs = newStmt;
        node.getRhs()->accept(*this);
        SCAM::Stmt * rhs = newStmt;
        //Any changes? Creat new Assignment
        if(lhs != node.getLhs() || rhs != node.getRhs()){
            this->newStmt = new Assignment((Expr*)lhs,(Expr*)rhs);
        } else this->newStmt = &node;
    }
}


void SCAM::ReplaceStmt::visit(struct UnaryExpr &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;
}
void SCAM::ReplaceStmt::visit(struct Cast &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}
void SCAM::ReplaceStmt::visit(struct FunctionOperand &node) {
    throw std::runtime_error("Not implemented");
}
void SCAM::ReplaceStmt::visit(struct CompoundExpr &node) {
    throw std::runtime_error("Not implemented");
}


void SCAM::ReplaceStmt::visit(struct While &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct If &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}


void SCAM::ReplaceStmt::visit(struct SectionOperand &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct SectionValue &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct ITE &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct Arithmetic &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct Logical &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct Relational &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct Bitwise &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct Read &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct Write &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;
}

void SCAM::ReplaceStmt::visit(struct NBRead &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct NBWrite &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct SyncSignal &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}
void SCAM::ReplaceStmt::visit(struct DataSignalOperand &node) {
    if(&node == toReplace) this->newStmt = replaceWith ;
    else this->newStmt = &node;

}

void SCAM::ReplaceStmt::visit(struct ParamOperand &node) {
    throw std::runtime_error("Only occurs in functions!");
}

void SCAM::ReplaceStmt::visit(struct Return &node) {
    throw std::runtime_error("Only occurs in functions!");

}



