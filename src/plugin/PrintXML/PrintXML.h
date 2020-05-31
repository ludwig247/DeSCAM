//
// Created by ludwig on 06.06.18.
//

#ifndef PROJECT_PRINTXML_H
#define PROJECT_PRINTXML_H

#include <iostream>
#include <fstream>
#include <Module.h>
#include <Model.h>
#include <PluginFactory.h>

// Boost Serialization headers
#include <boost/archive/xml_oarchive.hpp>
#include <boost/archive/xml_iarchive.hpp>
#include <boost/serialization/map.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/set.hpp>
#include <boost/serialization/access.hpp>
#include <boost/serialization/nvp.hpp>
#include <boost/serialization/base_object.hpp>


namespace SCAM{
    class PrintXML: public PluginFactory {
    public:
        PrintXML() = default;
        ~ PrintXML() = default;

//    explicit PrintXML(SCAM::Module * module);

        virtual std::map<std::string, std::string> printModel(Model *node);

        // Registration of derived classes within boost for use of base class pointers
        /*template <class Archive>
        static void regBaseClassDerivedTypes(Archive& ar);*/

        template <class Archive>
        static void regConstValueDerivedTypes(Archive &ar);

        template <class Archive>
        static void regStmtDerivedTypes(Archive &ar);

        template <class Archive>
        static void regExprDerivedTypes(Archive &ar);

        template <class Archive>
        static void regBranchDerivedTypes(Archive &ar);

        template <class Archive>
        static void regIfDerivedTypes(Archive &ar);

        template <class Archive>
        static void regCommunicationDerivedTypes(Archive &ar);

        template <class Archive>
        static void regOperandDerivedTypes(Archive &ar);
    private:
        SCAM::Module * module = nullptr;
    };
}

#endif //PROJECT_PRINTXML_H
