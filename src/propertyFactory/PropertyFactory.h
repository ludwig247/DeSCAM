//
// Created by ludwig on 13.02.20.
//

#ifndef DESCAM_PROPERTYFACTORY_H
#define DESCAM_PROPERTYFACTORY_H

#include <Module.h>

namespace SCAM{

class PropertyFactory {
public:
    PropertyFactory() = delete;
    explicit PropertyFactory(Module *module);
    explicit PropertyFactory(Module *module, Model* model);
    virtual ~PropertyFactory() = default;

    PropertySuite *getPropertySuite() const;

private:
    PropertySuite * propertySuite;

};


}
#endif //DESCAM_PROPERTYFACTORY_H
