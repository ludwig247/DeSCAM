//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_ABSTRACTNODE_H
#define SCAM_ABSTRACTNODE_H


#include <string>
#include <vector>
#include <map>
#include "AbstractVisitor.h"
#include "LocationInfo.h"


namespace SCAM {

    class AbstractNode {

    public:
        AbstractNode();

        explicit AbstractNode(std::string name,LocationInfo locationInfo = LocationInfo());

        virtual ~AbstractNode() = default;

        //Accept for visitor
        virtual void accept(AbstractVisitor &visitor) = 0;

        //Name
        std::string getName() const;
        void setName(std::string newName);

        //Location information
        const LocationInfo& getLocationInfo() {return this->locationInfo;};
        void setLocationInfo(LocationInfo info){ this->locationInfo = info;};

    private:
        std::string name;
        LocationInfo locationInfo;


    };

}


#endif //SCAM_ABSTRACTNODE_H
