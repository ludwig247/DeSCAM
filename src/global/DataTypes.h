//
// Created by ludwig on 09.11.16.
//

#ifndef SCAM_DATATYPES_H
#define SCAM_DATATYPES_H

#include <DataType.h>
#include <string>
#include <map>

namespace DESCAM {

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
            dataTypeMap.emplace("bool",  new DataType("bool"));
            dataTypeMap.emplace("int", new DataType("int"));
            dataTypeMap.emplace("unsigned", new DataType("unsigned"));
            localDataTypeMap = {};
        };

        ~ DataTypes() = default;;
        //! Map containing an entry TypeName,TypePtr for each datatype
        std::map<std::string, DataType *> dataTypeMap;

        //! Map containing the local dataTypes for each module
        std::map<std::string, std::map<std::string, DataType *>> localDataTypeMap;


    };
}
#endif //SCAM_DATATYPES_H
