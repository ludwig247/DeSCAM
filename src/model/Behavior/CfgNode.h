//
// Created by tobias on 13.10.15.
//

#ifndef SCAM_SUSPENSIONNODE2_H
#define SCAM_SUSPENSIONNODE2_H

#include <vector>
#include <Stmt.h>
#include <string>
#include <sstream>

namespace SCAM {


    class CfgNode {
    public:

        CfgNode();

        CfgNode(Stmt *stmt);

        ~CfgNode();


        //Successor
        void addSuccessor(CfgNode *node);

        void replaceSuccessor(CfgNode *oldValue, CfgNode *newValue) const;

        void removeSuccessor(CfgNode *node) const;

        std::vector<CfgNode *> getSuccessorList() const;

        void setSuccessorList(std::vector<CfgNode *>);

        //Predecessor
        void addPredecessor(CfgNode *node) const;

        void replacePredecessor(CfgNode *oldValue, CfgNode *newValue) const;

        void removePredecessor(CfgNode *node) const;

        std::vector<CfgNode *> getPredecessorList() const;

        void setPredecessorList(std::vector<CfgNode *>);

        //IDs
        static int getNode_cnt();

        int getId() const;

        void replaceId(int id_arg);

        const std::string getName();

        //Statements
        void setStmt(Stmt *stmt);

        Stmt *getStmt() const;

        const std::string print();

        const std::string printShort();

        static int node_cnt; //! CFG ID
    private:
        int id;
        mutable std::vector<CfgNode *> successorList;
        mutable std::vector<CfgNode *> predecessorList;

        SCAM::Stmt *stmt;

    };
}
#endif //SCAM_SUSPENSIONNODE_H
