#include "PropertyFactory.h"
#include "CreatePropertySuite.h"

SCAM::PropertyFactory::PropertyFactory(const Module *module) {

    assert(module != nullptr);
    // Generate PropertySuite
    this->propertySuite = new PropertySuite(module->getName());

    //Ports
    SCAM::CreatePropertySuite::addNotifySignals(module, propertySuite);
    SCAM::CreatePropertySuite::addSyncSignals(module, propertySuite);
    SCAM::CreatePropertySuite::addDataSignals(module, propertySuite);

    //Vars
    SCAM::CreatePropertySuite::addVisibleRegisters(module, propertySuite);

    //States
    SCAM::CreatePropertySuite::addStates(module, propertySuite);

    //Functions
    SCAM::CreatePropertySuite::addFunctions(module, propertySuite);

    // RESET PROPERTY
    SCAM::CreatePropertySuite::addReset(module, propertySuite);

    //OPERATION PROPERTIES

    SCAM::CreatePropertySuite::addOperations(module, propertySuite);
    //SCAM::CreatePropertySuite::addTrueOperations(module, propertySuite);

//    SCAM::CreatePropertySuite::addOperations(module, propertySuite);
//    SCAM::CreatePropertySuite::addTrueOperations(module, propertySuite);


    // WAIT PROPERTIES
    SCAM::CreatePropertySuite::addWait(module, propertySuite);


}


SCAM::PropertyFactory::PropertyFactory(Channel *channel) {

    assert(channel != nullptr);
    // Generate PropertySuite
    this->propertySuite = new PropertySuite("");
    //FIXME: at the moment only blocking is supported
    // if new interfaces are added implement distinction in addConnections

    //only take complete channels
    if((channel->getToPort() != nullptr && channel->getFromPort() != nullptr )) {
        if (channel->getType() == "Blocking") {
            this->propertySuite->setName(channel->getName());
            SCAM::CreatePropertySuite::addReset(channel, propertySuite);
            SCAM::CreatePropertySuite::addNotifySignals(channel, propertySuite);
            SCAM::CreatePropertySuite::addSyncSignals(channel, propertySuite);
            SCAM::CreatePropertySuite::addDataSignals(channel, propertySuite);
            SCAM::CreatePropertySuite::addStates(channel, propertySuite);
            SCAM::CreatePropertySuite::addConnections(channel, propertySuite);
        }
    }
}

SCAM::PropertySuite *SCAM::PropertyFactory::getPropertySuite() const {
    return propertySuite;
}