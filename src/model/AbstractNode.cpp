//
// Created by ludwig on 10.09.15.
//

#include "AbstractNode.h"

namespace SCAM{

    AbstractNode::AbstractNode():name("undefined") {

    }

    AbstractNode::AbstractNode(std::string name):name(name) {

    }

    AbstractNode::~AbstractNode() {

    }

    std::string AbstractNode::getName() const {
        return this->name;
    }



}