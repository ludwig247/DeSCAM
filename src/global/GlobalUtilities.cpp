//
// Created by M.I.Alkoudsi on 1.11.19.
//


#include "GlobalUtilities.h"

std::string DESCAM::GlobalUtilities::printCFG(const std::map<int, DESCAM::CfgBlock *> &CFG) {
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

std::string DESCAM::GlobalUtilities::printCFG(const std::map<int, DESCAM::CfgNode *> &CFG) {
    std::stringstream ss;
    for (auto node: CFG) {
        CfgNode *sus = node.second;

        ss << "[ID" << node.first << "]" << "\n";
        if (sus->getStmt() != nullptr) {
            ss << "\t\t" << PrintStmt::toString(sus->getStmt()) << "\n";
        } else { ss << "\t\t" << "nullptr" << "\n"; }

        ss << "\t\tPred:";
        for (auto pred: sus->getPredecessorList()) {
            if(sus->getPredecessorList().back() == pred) {ss << "[ID" << pred->getId() << "]";}
            else{ss << "[ID" << pred->getId() << "], ";}
        }
        ss << "\n";;
        ss << "\t\tSucc:";
        for (auto succ: sus->getSuccessorList()) {
            if(sus->getSuccessorList().back() == succ) {ss << "[ID" << succ->getId() << "]";}
            else{ss << "[ID" << succ->getId() << "], ";}
        }
        ss << "\n";
    }
    return ss.str();
}

int DESCAM::GlobalUtilities::findWhileNodeId(const std::map<int, DESCAM::CfgNode *> &CFG) {
    for (auto node : CFG) {
        if (node.second->getStmt()) {
            if (dynamic_cast<DESCAM::While *>(node.second->getStmt())) {
                return node.second->getId();
            }
        }
    }
    return 0;
}

bool DESCAM::GlobalUtilities::isAbortTranslation(const z3::expr& expr) {
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

int DESCAM::GlobalUtilities::getRequiredBits(int value) {
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

int DESCAM::GlobalUtilities::getRequiredBits(unsigned int value) {
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

std::vector<std::string> DESCAM::GlobalUtilities::stringSplit(const std::string& str, char delimiter) {
    std::vector<std::string> subStrings = {};
    std::string subString = "";
    std::istringstream substringStream(str);
    while (std::getline(substringStream, subString, delimiter)) {
        subStrings.push_back(subString);
    }
    return subStrings;
}

std::string DESCAM::GlobalUtilities::removeIndentation(const std::string &str) {
    std::string noIndentString = "";
    bool firstChrNotSpace = false;
    for (char chr : str) {
        if (chr != ' ') { firstChrNotSpace = true; }
        if (firstChrNotSpace) noIndentString.append(1, chr);
    }
    return noIndentString;
}


