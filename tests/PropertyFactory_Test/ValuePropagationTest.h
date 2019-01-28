//
// Created by tobias on 24.01.18.
//

#ifndef PROJECT_VALUEPROPAGATIONTEST_H
#define PROJECT_VALUEPROPAGATIONTEST_H

#include <gtest/gtest.h>
#include "gmock/gmock.h"
#include <Module.h>
#include "Model.h"
#include <toPPA/CreateInitSection.h>
#include <Stmts_all.h>
#include <toPPA/ValuePropagation.h>
#include <toPPA/SectionToPaths.h>
#include <toPPA/OnlyBlockingComm.h>
#include <toPPA/CommToCommNew.h>


using namespace SCAM;

class TestModule2: public ::testing::Test{
public:
    TestModule2():module(new Module("TestModule")){
    }

    virtual void SetUp() {
        //Ports
        Interface * anInterface = new Interface("blocking","out");
        Port * port = new Port("output",anInterface,DataTypes::getDataType("int"));
        module->addPort(port);
        //Variable
        SCAM::Variable * variable= new Variable("unsigned_var",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100));
        module->addVariable(variable);
        //Sections
        DataType *sections = new DataType(module->getName() + "_SECTIONS");
        DataTypes::addDataType(sections);
        sections->addEnumValue("run");
        module->getFSM()->setSections(sections, "run");
        //operationGraph

        std::vector<Stmt*> stmtlist;
        //Comm: port->write(13)
        SCAM::Write  * write = new Write(port,new IntegerValue(13));
        stmtlist.push_back(write);
        //Assignment: unsigned_var = -3 + 10;
        VariableOperand * variableOperand = new VariableOperand(variable);
        Arithmetic * arithmetic = new Arithmetic(new UnaryExpr("-",new UnsignedValue(-3)),"+",new UnsignedValue(10));
        stmtlist.push_back(arithmetic);
        sectionMap.insert(std::make_pair("run",stmtlist));

        //Property Factory
        sectionMap.insert(std::make_pair("init",CreateInitSection::createInitSection(*module)));

        SectionToPaths sectionToPaths(sectionMap);
        this->sectionPathMap = sectionToPaths.getNewSectionPathMap();


        OnlyBlockingComm onlyBlockingComm(this->sectionPathMap);
        //Update the sectionPathMap
        this->sectionPathMap = onlyBlockingComm.getNewSectionPathMap();
        //Each communication stmt will represent a state in the PPA
        this->stateMap = onlyBlockingComm.getStateMap();

        CommToCommNew commToComm(this->sectionPathMap, module);
        this->sectionPathMap = commToComm.getNewSectionPathMap();




    }

    virtual void TearDown() {}
    SCAM::Module * module;
    std::map<std::string,std::vector<Stmt*> > sectionMap;
    std::map<std::string,std::vector<Path*> > sectionPathMap;
    std::map<int, State *> stateMap;
};

TEST_F(TestModule2,TestValuePropagation){
    //test = -3 +2
    //ASSERT_THROW(ValuePropagation valuePropagation(sectionPathMap,module),std::runtime_error);


}


#endif //PROJECT_VALUEPROPAGATIONTEST_H
