//
// Created by tobias on 13.10.15.
//

#ifndef SCAM_SUSPENSIONNODE_H
#define SCAM_SUSPENSIONNODE_H

#include <vector>
#include <Stmt.h>
#include <string>
#include <sstream>

namespace SCAM {
    class CfgBlock {
    public:

        CfgBlock();

        CfgBlock(int blockID, int cfgBlockID);

        //Visitor
        //virtual void accept(SuspensionVisitor& visitor) = 0;

        //Successor
        void addSuccessor(CfgBlock *);

        void replaceSuccessor(CfgBlock *oldValue, CfgBlock *newValue);

        std::vector<CfgBlock *> getSuccessorList();

        //Predecessor
        void addPredecessor(CfgBlock *);

        void replacePredecessor(CfgBlock *oldValue, CfgBlock *newValue);

        void removePredecessor(CfgBlock *node);

        std::vector<CfgBlock *> getPredecessorList();

        //IDs
        int getBlockID() const;

        void setBlockID(int id);

        int getClangBlockID();

        //Statements
        void addStmt(SCAM::Stmt *);

        std::vector<SCAM::Stmt *> getStmtList(); //! Returns the list of SCAM Stmts
        //Terminators: are conditional statements: if,while,for
        void setTerminator(SCAM::Stmt *terminator);

        SCAM::Stmt *getTerminator(); //! suspension AST terminator
        bool hasTerminator();

        bool hasIf();


        const std::string print();

        void removeSuccessor(CfgBlock *pBlock);

    private:


        int blockID; //! Unique block ID in SuspensionCFG
        int cfgBlockID; //! Block ID in the clang::CFG
        SCAM::Stmt *terminator; //! Terminator with SuspensionAST representation
        std::vector<CfgBlock *> successorList;
        std::vector<CfgBlock *> predecessorList;
        std::vector<SCAM::Stmt *> stmtList;

    };
}
#endif //SCAM_SUSPENSIONNODE_H
