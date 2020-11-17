//
// Created by tobias on 22.10.15.
//

#include "FindVariables.h"

DESCAM::FindVariables::FindVariables(IFindNewDatatype *find_new_datatype,
                                     IFindInitialValues *find_initial_values,
                                     IFindDataFlowFactory *find_data_flow_factory) :
    find_new_datatype_(find_new_datatype),
    find_initial_values_(find_initial_values),
    find_data_flow_factory_(find_data_flow_factory),
    record_decl_(nullptr) {
  assert(find_new_datatype);
  assert(find_initial_values);
  assert(find_data_flow_factory);
}

bool DESCAM::FindVariables::setup(clang::CXXRecordDecl *record_decl,
                                  clang::CompilerInstance *ci,
                                  DESCAM::Module *module) {
  assert(record_decl);
  if (record_decl_ == record_decl) {
    return true;
  } else {
    record_decl_ = record_decl;
    this->variable_map_.clear();
    bool success = true;

    GetClangVariables clang_variables(success, record_decl);

    if (success) {
      //Add members to module
      for (auto &&variable: clang_variables.getVariableTypeMap()) {
        //Add Variable to Module

        const auto kName = variable.first;
        const auto kType = variable.second;

        auto variable_decl = clang_variables.getVariableMap().find(kName)->second;
        auto varLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<clang::FieldDecl>(variable_decl, ci);

        /*
         * Distinguish between local and global DataTypes.
         * If a module declares a type within it's class, then it's a local datatype ... global otherwise
         * This toggle is in place because of some legacy plugins not being aware of local/global types.
         */
        DataType *type;
        std::string typeName = find_new_datatype_->getTypeName(kType);
        //Step 1: Check whether the DataType already exists? Set type accordingly
        bool is_local = DataTypes::isLocalDataType(typeName, module->getName());
        bool is_global = DataTypes::isDataType(typeName);
        if (is_local && is_global) TERMINATE("Variable " + kName + "is local and global at the same time!")
        if (is_global) {
          type = DataTypes::getDataType(typeName);
        } else if (is_local) {
          type = DataTypes::getLocalDataType(module->getName(), typeName);
        } else {
          //Step2 : Add new datatype either as local or global datatype
          type = find_new_datatype_->getDataType(kType);
          if (find_new_datatype_->isGlobal(kType)) {
            DataTypes::addDataType(type);
          } else {
            DataTypes::addLocalDataType(module->getName(), type);
          }
        }
        //Compound: add a new variable compound.subVar as Variable
        if (type->isCompoundType() || type->isArrayType()) {
          //todo maybe throw warning here. C-style arrays don't work in simulation and should be replaced with std::array
          DESCAM_ASSERT(variable_map_.emplace(kName, new Variable(kName, type, nullptr, nullptr, varLocationInfo));)

        } else {
          find_initial_values_->setup(record_decl, variable_decl, module, ci);
          auto *value = find_initial_values_->getInitValue();

          //Variable not initialized -> initialize with default value
          if (value == nullptr) {
            if (type == DataTypes::getDataType("int")) {
              DESCAM_ASSERT(value = new IntegerValue(0))
            } else if (type == DataTypes::getDataType("bool")) {
              value = new BoolValue(false);
            } else if (type == DataTypes::getDataType("unsigned")) {
              DESCAM_ASSERT(value = new UnsignedValue(0))
            } else if (type->isEnumType()) {
              DESCAM_ASSERT(value = new EnumValue(type->getEnumValueMap().begin()->first, type))
            } else TERMINATE("No initialValue for type " + type->getName());
          }
          DESCAM_ASSERT(variable_map_.emplace(kName, new Variable(kName, type, value, nullptr, varLocationInfo));)

        }
      }
    }
    return success;
  }
}

std::map<std::string, DESCAM::Variable *> DESCAM::FindVariables::getVariableMap() {
  return this->variable_map_;
}
