//
// Created by M.I.Alkoudsi on 1.11.19.
//


#ifndef SCAM_OPT_UTILITIES_H
#define SCAM_OPT_UTILITIES_H

#include <map>
#include "z3++.h"
#include <CfgBlock.h>
#include <clang/AST/Stmt.h>
#include <clang/Frontend/CompilerInstance.h>
#include <clang/Lex/Lexer.h>
#include <clang/AST/ASTContext.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include "Behavior/CfgNode.h"
#include "PrintStmt.h"

/***
    * \brief: provides useful functions that can be used globally in the tool
    * \brief: provides useful functions for the optimizer stage library
   * \author: mi-alkoudsi
   */


namespace DESCAM {

    class GlobalUtilities {

        GlobalUtilities() = default;

        ~GlobalUtilities() = default;

    public:

        static std::string printCFG(const std::map<int, DESCAM::CfgBlock *> &CFG);

        static std::string printCFG(const std::map<int, DESCAM::CfgNode *> &CFG);

        static int findWhileNodeId(const std::map<int, DESCAM::CfgNode *> &CFG);

        static bool isAbortTranslation(const z3::expr &expr);

        static int getRequiredBits(int value);

        static int getRequiredBits(unsigned int value);

        static std::vector<std::string> stringSplit(const std::string &str, char delimiter);

        static std::string removeIndentation(const std::string &str);

        template<class T>
        static DESCAM::LocationInfo getLocationInfo(T *clangDataStructure, clang::CompilerInstance *ci) {
            // Getting location information from clang
            std::string statement = clang::Lexer::getSourceText(
                    clang::CharSourceRange::getTokenRange(clangDataStructure->getSourceRange()),
                    ci->getSourceManager(), ci->getLangOpts()).str();
            auto locStartVec = DESCAM::GlobalUtilities::stringSplit(
                    clangDataStructure->getBeginLoc().printToString(ci->getSourceManager()), ':');
            auto locEndVec = DESCAM::GlobalUtilities::stringSplit(
                    clangDataStructure->getEndLoc().printToString(ci->getSourceManager()), ':');
            auto fileDir = locStartVec[0];
            auto rowStartNum = std::stoi(locStartVec[1]);
            auto rowEndNum = std::stoi(locEndVec[1]);
            auto colStartNum = std::stoi(locStartVec[2]);
            auto colEndNum = std::stoi(locEndVec[2]);
            if (colEndNum < colStartNum && rowStartNum == rowEndNum) colEndNum = colStartNum;
            if (rowEndNum < rowStartNum) rowEndNum = rowStartNum;
            DESCAM::LocationInfo stmtInfo(statement, fileDir, rowStartNum, rowEndNum, colStartNum, colEndNum);
            return stmtInfo;
        }
    };
}

#endif //SCAM_OPT_UTILITIES_H
