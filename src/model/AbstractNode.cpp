//
// Created by ludwig on 10.09.15.
//

#include "AbstractNode.h"

namespace DESCAM {

    AbstractNode::AbstractNode() : name("undefined") {

    }

    AbstractNode::AbstractNode(std::string name,LocationInfo locationInfo) : name(name), locationInfo(locationInfo) {
    }

    std::string AbstractNode::getName() const {
        return this->name;
    }

    void AbstractNode::setName(std::string newName) {
        this->name = newName;
    }


}