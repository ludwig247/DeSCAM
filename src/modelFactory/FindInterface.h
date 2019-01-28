//
// Created by ludwig on 22.09.15.
//

#ifndef SCAM_FINDINTERFACE_H
#define SCAM_FINDINTERFACE_H

#include <clang/AST/Type.h>

namespace SCAM{


    /*!
     * \brief Class that obtain the interface and direction for a specific sc_port
     *
     */
class FindInterface {
public:
    FindInterface(const std::vector<std::string>& portTemplateList);
    virtual ~FindInterface();

    //GETTER
    std::string getDirection();
    std::string getInterface();

private:
    std::string _interface;
    std::string _direction;
    bool blocking;
};


}

#endif //SCAM_FINDINTERFACE_H
