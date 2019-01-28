//
// Created by ludwig on 09.11.16.
//

#ifndef SCAM_DATATYPES_H
#define SCAM_DATATYPES_H

#include <DataType.h>
#include <string>
#include <map>

namespace SCAM {

/**
 * \brief: Stores all datatypes for a model
 */
    class DataType;

    class DataTypes {
    public:
        //GETTER
        static DataTypes &getInstance();
        static const std::map<std::string, DataType *> &getDataTypeMap();
        static DataType *getDataType(std::string name);
        static bool isDataType(const std::string &name);
        //SETTER
        static void addDataType(DataType *);
        static void reset();


    private:
        DataTypes() {
            dataTypeMap.insert(std::make_pair("bool", new DataType("bool")));
            dataTypeMap.insert(std::make_pair("int", new DataType("int")));
            dataTypeMap.insert(std::make_pair("unsigned", new DataType("unsigned")));
        };

        ~ DataTypes() {};
        //! Map containg an entry TypeName,TypePtr for each datatype
        std::map<std::string, DataType *> dataTypeMap;


    };
}
#endif //SCAM_DATATYPES_H
