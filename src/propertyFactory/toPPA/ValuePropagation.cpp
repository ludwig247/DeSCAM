//

#include <PrintStmt.h>
#include <assert.h>
#include "ValuePropagation.h"
#include "ExprVisitor.h"

namespace SCAM {

    SCAM::ValuePropagation::ValuePropagation(SCAM::Module *module) :
            newExpr(nullptr),
            isStateVar(false),
            module(module) {

    }

    ValuePropagation::ValuePropagation(const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap, SCAM::Module *module) :
            sectionPathMap(sectionPathMap),
            newExpr(nullptr),
            isStateVar(false),
            module(module) {
        for (auto section: this->sectionPathMap) {
            //Constant propagation for each path
            for (auto path: section.second) {
                this->propagatePath(path);
            }
        }
    }

    SCAM::ValuePropagation::ValuePropagation(const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap, SCAM::Function *function):
        sectionPathMap(sectionPathMap){

        for(auto path: sectionPathMap.at("run")){
            //Reset return value
            this->returnValue = nullptr;

            this->path = path;
            //Iterate over each stmt of the path: every datapath value is added to the variableValueMap
            for (auto stmt: path->getStmtList()) {
                reset();
                stmt->accept(*this);
            }

            //Add Everything to the dataPathList
            std::vector<SCAM::Assignment *> dataPathList;
            for (auto var: this->variableValueMap) {
                dataPathList.push_back(new Assignment(this->variableMap.at(var.first), var.second));
            }

            //Cleanup datapaths
            this->variableMap.clear();
            this->variableValueMap.clear();
            //Set datapath
            path->setDataPathList(dataPathList);

            //Set Return value;
            if(returnValue != nullptr){
                this->path->setReturnValue(returnValue);
            }else{throw std::runtime_error(" Return value is nullptr ");}
        }
        }


    void SCAM::ValuePropagation::propagatePath(SCAM::Path *path) {

        this->path = path;
        //Iterate over each stmt of the path: every datapath value is added to the variableValueMap
        for (auto stmt: path->getStmtList()) {
            reset();
            stmt->accept(*this);
        }
        //Create assignments for each variable with its value at the end of the path

        for (auto var: module->getVariableMap()) {
            if (var.second->isCompoundType()) {
                for (auto subVar: var.second->getSubVarList()) {
                    find_or_add_variable(var.first + "." + subVar->getName(), new VariableOperand(subVar));
                }
            } else {
                find_or_add_variable(var.first, new VariableOperand(var.second));
            }
        }

        //Add shared out to dataPath, they shouldn't change
        if (path->getSection() != "init") {
            for (auto port: module->getPorts()) {
                auto interface = port.second->getInterface();
                if (interface->isShared() && interface->isOutput()) {
                    if (port.second->getDataType()->isCompoundType()) {
                        for (auto subSig: port.second->getDataSignal()->getSubSigList()) {
                            find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        }
                    } else {
                        find_or_add_variable(port.second->getDataSignal()->getName(), new DataSignalOperand(port.second->getDataSignal()));
                    }
                }
            }
        }



        //Add Everything to the dataPathList
        std::vector<SCAM::Assignment *> dataPathList;
        for (auto var: this->variableValueMap) {
            dataPathList.push_back(new Assignment(this->variableMap.at(var.first), var.second));
        }

        //Cleanup datapaths
        this->variableMap.clear();
        this->variableValueMap.clear();
        //Set datapath
        path->setDataPathList(dataPathList);


    }


    void ValuePropagation::visit(SCAM::VariableOperand &node) {
        if (node.getDataType()->isCompoundType()) {
            std::map<std::string,Expr*> selectList;
            for (auto subVar: node.getVariable()->getSubVarList()) {
                VariableOperand *subVarOp = new VariableOperand(subVar);
                selectList.insert(std::make_pair(subVar->getName(), this->find_or_add_variable(subVar->getFullName(), subVarOp)));
                //this->find_or_add_variable(subVar->getFullName(), subVarOp);
            }
            auto test = new CompoundExpr(selectList,node.getDataType());
            this->newExpr = test;

        } else {
            this->newExpr = find_or_add_variable(node.getOperandName(), &node);
        }
    }

    void ValuePropagation::visit(SCAM::IntegerValue &node) {
        this->newExpr = &node;
    }
    void ValuePropagation::visit(SCAM::UnsignedValue &node) {
        this->newExpr = &node;
    }

    void ValuePropagation::visit(SCAM::EnumValue &node) {
        this->newExpr = &node;

    }

    void SCAM::ValuePropagation::visit(SCAM::CompoundValue &node) {
        this->newExpr = &node;

    }

    void ValuePropagation::visit(SCAM::BoolValue &node) {
        this->newExpr = &node;
    }

    void ValuePropagation::visit(SCAM::PortOperand &node) {
        throw std::runtime_error(" Not allowed ");
    }


    void ValuePropagation::visit(SCAM::Assignment &node) {
        //LHS
        reset();
        node.getLhs()->accept(*this);
        if (this->isStateVar) return;
        try {
                //Operand *lhs = ExprVisitor::getOperand(node.getLhs());
                std::string lhs = PrintStmt::toString(node.getLhs());
                node.getRhs()->accept(*this);
                if(node.getLhs()->getDataType()->isCompoundType()){

                    Operand * rhs = ExprVisitor::getOperand(node.getRhs());
                    for(auto sub: node.getLhs()->getDataType()->getSubVarMap()){
                        //e.g. lhs = foo();
                        if(ExprVisitor::isConstVal(node.getRhs())){
                            auto newVal = find_or_add_variable(lhs+"."+sub.first,new SubSelect(rhs,sub.first));
                            this->variableValueMap.at(lhs+"."+sub.first) = new SubSelect(rhs,sub.first);
                        }else{
                            this->variableValueMap.at(lhs+"."+sub.first) = this->variableValueMap.at(rhs->getOperandName() + "." + sub.first);
                        }
                    }
                }else{
                    this->variableValueMap.at(lhs) = this->newExpr;
                }
        } catch (std::runtime_error error) {
            std::cout << PrintStmt::toString(&node) << std::endl;
            std::cout << error.what() << std::endl;
            throw std::runtime_error("Value Propagation went wrong!");
        }
    }

    void ValuePropagation::visit(SCAM::UnaryExpr &node) {
        node.getExpr()->accept(*this);
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);

        } else if (node.getOperation() == "-") {
            if(node.getExpr()->getDataType()->isUnsigned()){
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
            }else this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));

        } else throw std::runtime_error("Unknown unary operator " + node.getOperation());
    }


    void ValuePropagation::visit(SCAM::While &node) {
        throw std::runtime_error("WHILE not allowed");

    }

    void ValuePropagation::visit(SCAM::If &node) {
        node.getConditionStmt()->accept(*this);
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->path->addCondition(this->newExpr);


    }

    void ValuePropagation::visit(SCAM::SectionOperand &node) {
        this->isStateVar = true;
    }

    void ValuePropagation::visit(SCAM::SectionValue &node) {

    }

    void ValuePropagation::visit(SCAM::ITE &node) {
        throw std::runtime_error("ITE not allowed");

    }

    void ValuePropagation::visit(SCAM::Arithmetic &node) {
        //LHS
        SCAM::Expr *lhs;
        node.getLhs()->accept(*this);
        lhs = this->newExpr;

        //RHS
        SCAM::Expr *rhs;
        node.getRhs()->accept(*this);
        rhs = this->newExpr;

        //Create new stmt
        this->newExpr = new SCAM::Arithmetic(lhs, node.getOperation(), rhs);

    }

    void ValuePropagation::reset() {
        isStateVar = false;
    }

    SCAM::Expr *ValuePropagation::find_or_add_variable(std::string varName, SCAM::Expr *expr) {
        //Is variable already in map?
        if (this->variableValueMap.find(varName) == this->variableValueMap.end()) {
            //Add variable to map
            this->variableMap.insert(std::make_pair(varName, expr));
            this->variableValueMap.insert(std::make_pair(varName, expr));
        }
        return this->variableValueMap[varName];
    }
}

void SCAM::ValuePropagation::visit(struct Logical &node) {

    //LHS
    SCAM::Expr *lhs;
    node.getLhs()->accept(*this);
    lhs = this->newExpr;

    //RHS
    SCAM::Expr *rhs;
    node.getRhs()->accept(*this);
    rhs = this->newExpr;

    this->newExpr = new SCAM::Logical(lhs, node.getOperation(), rhs);

}

void SCAM::ValuePropagation::visit(struct Relational &node) {
    //LHS
    SCAM::Expr *lhs;
    node.getLhs()->accept(*this);
    lhs = this->newExpr;

    //RHS
    SCAM::Expr *rhs;
    node.getRhs()->accept(*this);
    rhs = this->newExpr;

    //Create new expr
    this->newExpr = new SCAM::Relational(lhs, node.getOperation(), rhs);


}

void SCAM::ValuePropagation::visit(struct Bitwise &node) {
    //LHS
    SCAM::Expr *lhs;
    node.getLhs()->accept(*this);
    lhs = this->newExpr;

    //RHS
    SCAM::Expr *rhs;
    node.getRhs()->accept(*this);
    rhs = this->newExpr;

    this->newExpr = new SCAM::Bitwise(lhs, node.getOperation(), rhs);
    //Reset var&const to false
    reset();

}

void SCAM::ValuePropagation::visit(struct Read &node) {

    if (node.getPort()->getDataType()->isVoid()) {
        //Nothing to do: no datasignal0
    }
        //this->newExpr = &node;
        //Compound Type: Assign value of each subSignal du each component of var
    else if (node.getPort()->getDataType()->isCompoundType()) {
        for (auto subVar :  node.getVariableOperand()->getVariable()->getSubVarList()) {
            std::string name = subVar->getParent()->getName() + "." + subVar->getName();
            this->find_or_add_variable(name, new VariableOperand(subVar));
            this->variableValueMap[name] = new DataSignalOperand(node.getPort()->getDataSignal()->getSubSig(subVar->getName()));
        }
        //Assign dataSignal to variable
    } else {
        std::string varName = node.getVariableOperand()->getVariable()->getFullName();
        find_or_add_variable(varName, node.getVariableOperand());
        this->variableValueMap[varName] = new DataSignalOperand(node.getPort()->getDataSignal());
    }
}

void SCAM::ValuePropagation::visit(struct Write &node) {

}

void SCAM::ValuePropagation::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
    this->newExpr = new Cast(this->newExpr,node.getDataType());

}

void SCAM::ValuePropagation::visit(struct NBRead &node) {

    //Return value of method
    this->newExpr = node.getPort()->getSynchSignal();
    if (node.getDataType()->isVoid()) {
        //Nothing happens -> no value
    } else if (node.getPort()->getDataType()->isCompoundType()) {
        for (auto subVar :  node.getVariableOperand()->getVariable()->getSubVarList()) {
            std::string name = subVar->getParent()->getName() + "." + subVar->getName();
            this->find_or_add_variable(name, new VariableOperand(subVar));
            this->variableValueMap[name] = new DataSignalOperand(node.getPort()->getDataSignal()->getSubSig(subVar->getName()));
        }
        //Assign dataSignal to variable
    } else {
        std::string varName = node.getVariableOperand()->getOperandName();
        find_or_add_variable(varName, node.getVariableOperand());
        this->variableValueMap[varName] = new DataSignalOperand(node.getPort()->getDataSignal());
    }
}

void SCAM::ValuePropagation::visit(struct NBWrite &node) {

    if (node.getPort()->getInterface()->isShared()) {
        node.getValue()->accept(*this);
        //Case for a write(var)
        if (ExprVisitor::getUsedOperands(node.getValue()).size() == 1) {
            //Compound: Assignment for each subVar
            if (node.getValue()->getDataType()->isCompoundType()) {
                auto var = this->module->getVariable(ExprVisitor::getOperand(node.getValue())->getOperandName());
                for (auto subSig: node.getPort()->getDataSignal()->getSubSigList()) {
                    find_or_add_variable(var->getSubVar(subSig->getName())->getFullName(), new VariableOperand(var->getSubVar(subSig->getName())));
                    find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                    this->variableValueMap[subSig->getFullName()] = this->variableValueMap[var->getSubVar(subSig->getName())->getFullName()];
                }
                //Simple var
            } else {
                find_or_add_variable(node.getPort()->getDataSignal()->getName(), new DataSignalOperand(node.getPort()->getDataSignal()));
                this->variableValueMap[node.getPort()->getDataSignal()->getName()] = this->newExpr;
            }
        //Case for write(value)
        } else {
            if (node.getValue()->getDataType()->isCompoundType()) {
                CompoundValue *compoundValue = dynamic_cast<CompoundValue *>(node.getValue());
                for (auto subSig: node.getPort()->getDataSignal()->getSubSigList()) {
                    find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                    this->variableValueMap[subSig->getFullName()] = compoundValue->getValues().at(subSig->getName());
                }
            } else {
                find_or_add_variable(node.getPort()->getDataSignal()->getName(), new DataSignalOperand(node.getPort()->getDataSignal()));
                this->variableValueMap[node.getPort()->getDataSignal()->getName()] = node.getValue();
            }

        }
    }
    this->newExpr = node.getPort()->getSynchSignal();

}

void SCAM::ValuePropagation::visit(struct SyncSignal &node) {

    throw std::runtime_error("Synchsignal is not allowed for datapath");
}

void SCAM::ValuePropagation::visit(struct DataSignalOperand &node) {
    if (node.getDataType()->isCompoundType()) {
        for (auto subSig: node.getDataSignal()->getSubSigList()) {
            DataSignalOperand * subSigOp = new DataSignalOperand(subSig);
            this->find_or_add_variable(subSig->getFullName(), subSigOp);
        }

    } else {
        this->newExpr = find_or_add_variable(node.getOperandName(), &node);
    }
    //throw std::runtime_error("DataSignal is not allowed for datapath");
}

std::map<std::string, std::vector<SCAM::Path *>> SCAM::ValuePropagation::getNewSectionPathMap() {
    return this->sectionPathMap;
}

void SCAM::ValuePropagation::visit(SCAM::FunctionOperand &node) {
    std::map<std::string,SCAM::Expr*> newParamValueMap;
    for (auto &&param : node.getParamValueMap()) {
        param.second->accept(*this);
        SCAM::Expr * newParam = this->newExpr;
        newParamValueMap.insert(std::make_pair(param.first,newParam));
    }
    this->newExpr = new SCAM::FunctionOperand(node.getFunction(), newParamValueMap);
    reset();
}

void SCAM::ValuePropagation::visit(SCAM::SubSelect &node) {
    this->newExpr = find_or_add_variable(node.getOperand()->getOperandName()+"."+node.getSub(),&node);
}

void SCAM::ValuePropagation::visit(SCAM::CompoundExpr &node) {
    throw std::runtime_error(" not implemented ");

}

void SCAM::ValuePropagation::visit(SCAM::ParamOperand &node) {
    if (node.getDataType()->isCompoundType()) {
//        throw std::runtime_error(" Not implemented ");
//        std::map<std::string,Expr*> selectList;
        for (auto subVar: node.getDataType()->getSubVarMap()) {
            this->find_or_add_variable(node.getOperandName()+"."+subVar.first, new SubSelect(&node,subVar.first));
        }
//        auto test = new CompoundExpr(selectList,node.getDataType());
//        this->newExpr = test;
    } else {
        this->newExpr = find_or_add_variable(node.getOperandName(), &node);
    }
}

void SCAM::ValuePropagation::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
    this->returnValue = new Return(this->newExpr);

}


