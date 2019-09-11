//
// Created by tobias on 12.12.18.
//

#include <assert.h>
#include "NewNode.h"


SCAM::NewNode::NewNode(SCAM::Stmt *stmt):id(node_cnt++) {
    assert(node_cnt==1 && "Only entry node is allowed to have no predecessor");
}

SCAM::NewNode::NewNode(SCAM::Stmt *stmt, const NewNode &predecessor):id(node_cnt++){


}
