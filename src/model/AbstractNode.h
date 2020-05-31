//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_ABSTRACTNODE_H
#define SCAM_ABSTRACTNODE_H


#include <string>
#include <vector>
#include <map>
#include "AbstractVisitor.h"


namespace SCAM {

    class AbstractNode {

    public:
        AbstractNode();

        explicit AbstractNode(std::string name);

        virtual ~AbstractNode() = default;

        //Accept for visitor
        virtual void accept(AbstractVisitor &visitor) = 0;

        //Name
        std::string getName() const;

        void setName(std::string newName);

        // Serialization
        friend class Serializer;

    private:
        std::string name;

    };

}


#endif //SCAM_ABSTRACTNODE_H
