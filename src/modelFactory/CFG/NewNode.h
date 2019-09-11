//
// Created by tobias on 12.12.18.
//

#ifndef PROJECT_NEWNODE_H
#define PROJECT_NEWNODE_H


#include <Stmts/Stmt.h>
#include <vector>

namespace SCAM{

class NewNode {
public:
    NewNode(SCAM::Stmt * stmt,const NewNode & predecessor);
    explicit NewNode(SCAM::Stmt * stmt);
    virtual ~NewNode() = default;

private:
    NewNode() = default;
    SCAM::Stmt * stmt;
    std::vector<const NewNode &> predecessorList;
    std::vector<const NewNode &> succesorList;

    int id;
    static int node_cnt;
};

int NewNode::node_cnt = 0;
}
#endif //PROJECT_NEWNODE_H
