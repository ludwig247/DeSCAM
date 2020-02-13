//
// Created by ludwig on 10.09.15.
//

#include "AbstractNode.h"

namespace SCAM {

    AbstractNode::AbstractNode() : name("undefined") {

    }

    AbstractNode::AbstractNode(std::string name) : name(name) {

    }


    std::string AbstractNode::getName() const {
        return this->name;
    }

    void AbstractNode::setName(std::string newName) {
        this->name = newName;
    }


}