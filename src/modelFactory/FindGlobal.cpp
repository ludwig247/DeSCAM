//
// Created by tobias on 13.11.19.
//

#include <iostream>
#include <CFGFactory.h>
#include <FunctionFactory.h>
#include "FindGlobal.h"
#include "FindDataFlow.h"
#include "FindNewDatatype.h"


SCAM::FindGlobal::FindGlobal(clang::TranslationUnitDecl *decl,clang::CompilerInstance &ci, SCAM::Module *module) :
        ci(ci),
        decl(decl),
        module(module) {
    assert(!(decl == NULL));
    TraverseDecl(decl);



}

bool SCAM::FindGlobal::VisitVarDecl(const clang::VarDecl *varDecl) {
    auto type = varDecl->getType();
    auto isConst = type.isConstant(decl->getASTContext());
    auto isBuiltIn = type->isBuiltinType();

    if (isConst && isBuiltIn) {
        if (varDecl->getAnyInitializer(varDecl) != nullptr) {

            auto init = varDecl->getAnyInitializer(varDecl)->IgnoreImpCasts();
            if (init->getType()->isBuiltinType()) {
                auto isUnsigned = varDecl->getType()->isUnsignedIntegerType();
                try {
                    FindDataFlow checkForExpr(const_cast<clang::Expr *>(init), module, isUnsigned);
                    ErrorMsg::clear();
                    if (checkForExpr.getExpr()) {
                        std::string typeName = init->getType().getAsString();
                        if (typeName == "_Bool") typeName = "bool";
                        else if (varDecl->getType()->isUnsignedIntegerType()) {
                            typeName = "unsigned";
                        } else if (varDecl->getType()->isIntegerType()) {
                            typeName = "int";
                        } else throw std::runtime_error("unsupported type");

                        std::string name = varDecl->getName().str();
                        std::string value = PrintStmt::toString(checkForExpr.getExpr());

                        //Determine type
                        auto type = varDecl->getType();
                        DataType *descam_type;
                        if (type.isConstant(decl->getASTContext())) {
                            if (type->isBooleanType()) descam_type = DataTypes::getDataType("bool");
                            else if (type->isUnsignedIntegerType()) descam_type = DataTypes::getDataType("unsigned");
                            else if (type->isIntegerType()) descam_type = DataTypes::getDataType("int");
                            else throw std::runtime_error("Type: " + type.getAsString() + " for var " + name + " is not allowed");
                        }

                        //Types have to be equivalent
                        if(checkForExpr.getExpr()->getDataType() == descam_type){
                            //set initval && create new global constant variable
                            if (auto initVal = dynamic_cast<ConstValue *>(checkForExpr.getExpr())) {
                                auto var = new Variable(name, descam_type, initVal);
                                var->setConstant(true);
                                this->variableMap.insert(std::make_pair(name, var));
                            }else {
                                //std::cout << "Global variable: " << name << " with value " << PrintStmt::toString(checkForExpr.getExpr()) << " is not added as global var." << std::endl;
                                //std::cout << "The reason is that the initialvalue has to be of constant and simple type without expressions of any kind" << std::endl;
                                //FIXME move back to exception
                                //throw std::runtime_error("Init value has to be const");
                            }
                        }
                    }
                } catch (std::runtime_error e) {
                    //std::cout << e.what() << std::endl;

                }

            }
        }
    }
    return true;
}

const std::map<std::string, SCAM::Variable *> &SCAM::FindGlobal::getVariableMap() const {
    return variableMap;
}

/***
 * Find all relevant functions within an AST
 * Return types are only allowed to be bool or (unisgned) int as well as the parameters
 * Furthermore, the parametrs have to be a call by value
 *
 * @param funDecl
 * @return
 */

bool SCAM::FindGlobal::VisitFunctionDecl(const clang::FunctionDecl *funDecl) {
     //Define lambdas for checking the function
    auto valid_result_type = [=](){
        auto res = funDecl->getResultType();
        return((res->isIntegerType()||res->isBooleanType()) && !res->isReferenceType() && !res->isAnyPointerType() && !res->isEnumeralType());
    };

    auto valid_function_type = [=](){
        return funDecl->isGlobal() && funDecl->isUsed() && !funDecl->isCXXClassMember();
    };

    auto valid_parameters = [=](){
        for(int i=0;i<funDecl->getNumParams();i++) {
            auto type = funDecl->getParamDecl((i))->getType().getCanonicalType();
            if (!type->isIntegerType() && !type->isBooleanType() && !type->isEnumeralType()) {
                return false;
            }
        }
        return true;
    };


    //Ensure, that all conditions are correct
    if(valid_result_type() && valid_function_type() && valid_parameters()){
        std::map<std::string,Parameter*> parameterMap;
        for(int i=0;i<funDecl->getNumParams();i++){
            auto param = funDecl->getParamDecl(i);
            std::string paraName = param->getNameAsString();
            auto newParam = new Parameter(paraName,getDataType(param->getType()));
            parameterMap.insert(std::make_pair(paraName,newParam));
        }
        std::string name = funDecl->getNameAsString();
        auto function = new Function(name,getDataType(funDecl->getResultType()),parameterMap);
        this->functionMap.insert(std::make_pair(name,function));

        try {
        //Create blockCFG for this process
        //Active searching only for functions
        //If fails ... function is not SystemC-PPA compliant
        FindDataFlow::functionName = name;
        FindDataFlow::isFunction = true;
        SCAM::CFGFactory cfgFactory(funDecl, ci,  module);
        FindDataFlow::functionName = "";
        FindDataFlow::isFunction = false;

        //Transfor blockCFG back to code
        FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), function, nullptr);
        function->setStmtList(functionFactory.getStmtList());
        }catch(std::runtime_error e){
        }

    }
    return true;
}

SCAM::DataType * SCAM::FindGlobal::getDataType(const clang::QualType& type) const {
    SCAM::DataType * dataType;
    if(type->isUnsignedIntegerType()){
        dataType = SCAM::DataTypes::getDataType("unsigned");
    }else if(type->isIntegerType()){
        dataType = SCAM::DataTypes::getDataType("int");
    }else if(type->isBooleanType()){
        dataType = SCAM::DataTypes::getDataType("bool");
    }else throw std::runtime_error("Type: "+type.getAsString() + "not allowed");
    return dataType;
}

const std::map<std::string, SCAM::Function *> &SCAM::FindGlobal::getFunctionMap() const {
    return functionMap;
}



