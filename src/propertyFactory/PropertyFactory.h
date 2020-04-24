//
// Created by ludwig on 13.02.20.
//

#ifndef DESCAM_PROPERTYFACTORY_H
#define DESCAM_PROPERTYFACTORY_H

#include <Module.h>
#include <memory>

namespace SCAM{

class PropertyFactory {
public:
    PropertyFactory() = delete;
    explicit PropertyFactory(const Module *module);
    virtual ~PropertyFactory() = default;

    std::shared_ptr<PropertySuite> getPropertySuite() const;

private:
    std::shared_ptr<PropertySuite> propertySuite;

};


}
#endif //DESCAM_PROPERTYFACTORY_H
