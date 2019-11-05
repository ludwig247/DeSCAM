//
// Created by M.I.Alkoudsi on 1.11.19.
//


#include "OptUtilities.h"

std::string SCAM::OptUtilities::printCFG(const std::map<int, SCAM::CfgBlock *> &CFG) {
    std::stringstream ss;
    for (auto node: CFG) {
        CfgBlock *sus = node.second;

        ss << "[ID" << node.first << "] [B" << sus->getClangBlockID() << "]" << "\n";
        ss << "\tStmntList: " << sus->getStmtList().size() << "\n";


        for (auto stmt: sus->getStmtList()) {
            ss << "\t\t" << PrintStmt::toString(stmt) << "\n";
        }

        if (sus->hasTerminator()) {
            ss << "\t";
            ss << "Terminator: ";
            ss << PrintStmt::toString(node.second->getTerminator()) << "\n";
        }

        ss << "\t\tPred: ";
        for (auto pred: sus->getPredecessorList()) {
            ss << "[ID" << pred->getBlockID() << "], ";
        }
        ss << "\n";
        ss << "\t\tSucc: ";
        for (auto succ: sus->getSuccessorList()) {
            ss << "[ID" << succ->getBlockID() << "], ";
        }
        ss << "\n";
    }
    return ss.str();
}

std::string SCAM::OptUtilities::printCFG(const std::map<int, SCAM::CfgNode *> &CFG) {
    std::stringstream ss;
    for (auto node: CFG) {
        CfgNode *sus = node.second;

        ss << "[ID" << node.first << "]" << "\n";
        if (sus->getStmt() != nullptr) {
            ss << "\t\t" << PrintStmt::toString(sus->getStmt()) << "\n";
        } else { ss << "\t\t" << "nullptr" << "\n"; }

        ss << "\t\tPred: ";
        for (auto pred: sus->getPredecessorList()) {
            ss << "[ID" << pred->getId() << "], ";
        }
        ss << "\n";;
        ss << "\t\tSucc: ";
        for (auto succ: sus->getSuccessorList()) {
            ss << "[ID" << succ->getId() << "], ";
        }
        ss << "\n";
    }
    return ss.str();
}

int SCAM::OptUtilities::findWhileNodeId(const std::map<int, SCAM::CfgNode *> &CFG) {
    for (auto node : CFG) {
        if (node.second->getStmt()) {
            if (dynamic_cast<SCAM::While *>(node.second->getStmt())) {
                return node.second->getId();
            }
        }
    }
    return 0;
}

bool SCAM::OptUtilities::isAbortTranslation(const z3::expr& expr) {
    if (expr.is_const()) {
        return false;
    }
    std::stringstream ss;
    ss << expr;
    std::string stringExpr = ss.str();
    return (stringExpr.find("extract") != std::string::npos || stringExpr.find("concat") != std::string::npos);
    /* std::string oper = expr.decl().name().str();
     if(oper == "concat" || oper == "extract"){return true;}
     for(int i=0; i==expr.num_args(); i++){
         if(expr.arg(i).is_const()){continue;}
         else{
             std::string innerOper = expr.arg(i).decl().name().str();
             if(innerOper == "concat" || innerOper == "extract"){return true;}
            // bool abort = isAbortTranslation(expr.arg(i));
             //if(abort){return true;}
         }
     }*/
}

int SCAM::OptUtilities::getRequiredBits(int value) {
    if (value == 0) {
        return 1;
    }
    if (value == -2147483648) {
        return 32;
    }
    if (value < 0) {
        value = -value;
    }
    int width = 0;
    for (int i = 0; value > 0; i++) {
        width++;
        value = value / 2;
    }
    return width;
}

int SCAM::OptUtilities::getRequiredBits(unsigned int value) {
    if (value == 0) {
        return 1;
    }
    int width = 0;
    for (int i = 0; value > 0; i++) {
        width++;
        value = value / 2;
    }
    return width;
}

