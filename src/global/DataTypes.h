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

        static const std::map<std::string, std::map<std::string, DataType *>> &getLocalDataTypeMap();

        static DataType *getDataType(std::string name);

        static DataType *getLocalDataType(std::string moduleName, std::string typeName);

        static std::map<std::string, DataType *> getLocalDataTypes(std::string moduleName);

        static bool isDataType(const std::string &name);

        static bool isLocalDataType(const std::string &name, const std::string &moduleName);

        static bool hasLocalDataTypes(const std::string &moduleName);

        //SETTER

        static void addDataType(DataType *type);

        static void addLocalDataType(std::string moduleName, DataType *type);

        static void reset();


    private:
        DataTypes() {
            dataTypeMap.insert(std::make_pair("bool", new DataType("bool")));
            dataTypeMap.insert(std::make_pair("int", new DataType("int")));
            dataTypeMap.insert(std::make_pair("unsigned", new DataType("unsigned")));
            localDataTypeMap = {};
        };

        ~ DataTypes() {};
        //! Map containg an entry TypeName,TypePtr for each datatype
        std::map<std::string, DataType *> dataTypeMap;

        //! Map containg the local dataTypes for each module
        std::map<std::string, std::map<std::string, DataType *>> localDataTypeMap;


    };
}
#endif //SCAM_DATATYPES_H
