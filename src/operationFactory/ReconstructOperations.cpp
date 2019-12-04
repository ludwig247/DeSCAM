//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 5/10/19.
//

#include "ReconstructOperations.h"
#include <PrintStmt.h>
#include <NodePeekVisitor.h>
#include "ExprVisitor.h"
#include <regex>

//#define DEBUG_PROCESSOPERATIONS
SCAM::ReconstructOperations::ReconstructOperations(std::vector<SCAM::Stmt *> statementsList, SCAM::Module *module) :
        isStateVar(false),
        newExpr(nullptr),
        module(module) {

    this->assumptionsList.clear();
    this->commitmentsList.clear();
    this->variableAssignmentMap.clear();

    for (auto stmt: statementsList) {
        stmt->accept(*this);
    }
}

SCAM::ReconstructOperations::ReconstructOperations(std::map<std::string, SCAM::State2 *> statesMap, SCAM::Module *module) :
        isStateVar(false),
        newExpr(nullptr),
        module(module),
        statesMap(std::move(statesMap)) {

    /// Collect module DP signals to avoid adding them to the operation commitmentList if not assigned
    // DP SIGNALS
    for (auto port: module->getPorts()) {
        if (port.second->getDataType()->isVoid()) continue;
        if (port.second->getInterface()->isShared()) continue;

        if (port.second->getDataType()->isCompoundType()) {
            for (const auto &subVar: port.second->getDataType()->getSubVarMap()) {
                std::string name = port.first + "_sig." + subVar.first;
                this->dpSignalsList.push_back(name);

            }
        } else if (port.second->getDataType()->isArrayType()) {
            for (const auto &subVar: port.second->getDataType()->getSubVarMap()) {
                std::string name = port.first + "_sig[" + subVar.first + "]";
                this->dpSignalsList.push_back(name);
            }
        } else {
            std::string name = port.first + "_sig";
            this->dpSignalsList.push_back(name);
        }
    }
}

void SCAM::ReconstructOperations::sortOperation(SCAM::Operation2 *operation) {
    this->assumptionsList.clear();
    this->commitmentsList.clear();
    this->variableAssignmentMap.clear();
    this->isWaitOperation = operation->IsWait();
    for (auto stmt: operation->getStatementsList()) {
        stmt->accept(*this);
    }
    this->isWaitOperation=false;
    operation->setAssumptionsList(this->assumptionsList);
    /// Setting operation commitmentList

    for (const auto &var : this->variableMap) {
        if (this->variableAssignmentMap.find(var.first) != this->variableAssignmentMap.end()) {
            operation->addCommitment(new Assignment(var.second, this->variableAssignmentMap.at(var.first)));
        } else {
            if (std::find(this->dpSignalsList.begin(), this->dpSignalsList.end(), var.first) == this->dpSignalsList.end()) /// variable is NOT a port signal
                operation->addCommitment(new Assignment(var.second, var.second));
        }
    }

#ifdef DEBUG_PROCESSOPERATIONS
    std::cout << "==========================" << std::endl;
    std::cout << "==========================" << std::endl;
    std::cout << "********* Operation ID[" << operation->getId() << "] ************\n";
    std::cout << "IsReset: " << operation->IsReset() << " - IsWait: " << operation->IsWait() << "\n";
    std::cout << "Starting State: " << operation->getState()->getName() << " - Ending State: " << operation->getNextState()->getName() << "\n\n";

    std::cout << "********* AssumptionsList ************\n";
    for (auto stmt : operation->getAssumptionsList()) {
        std::cout << PrintStmt::toString(stmt) << "\n";
    }

    std::cout << "********* CommitmentsList ************\n";
    for (auto stmt : operation->getCommitmentsList()) {
        std::cout << PrintStmt::toString(stmt) << "\n";
    }
    std::cout << "\n\n******************************\n\n";
//        throw std::runtime_error(" STOP YOOO ");
#endif

}

std::vector<SCAM::Expr *> SCAM::ReconstructOperations::extractConditions(std::vector<SCAM::Stmt *> statementsList, SCAM::Module *module) {
    ReconstructOperations *pOp = new ReconstructOperations(std::move(statementsList), module);
    return pOp->assumptionsList;
}


SCAM::Return *SCAM::ReconstructOperations::getReturnValue(std::vector<SCAM::Stmt *> statementsList, SCAM::Module *module) {
    ReconstructOperations pOp(std::move(statementsList), module);
    return pOp.returnValue;
}

SCAM::Expr *SCAM::ReconstructOperations::find_or_add_variable(const std::string &varName, SCAM::Expr *expr) {
    //Is variable already in map?
    if (this->variableAssignmentMap.find(varName) == this->variableAssignmentMap.end()) {
        //Add variable to map
        this->variableMap.insert(std::make_pair(varName, expr));
        this->variableAssignmentMap.insert(std::make_pair(varName, expr));
    }
    return this->variableAssignmentMap[varName];
}

void SCAM::ReconstructOperations::reset() {
    this->isStateVar = false;
}

// Visitor functions
namespace SCAM {
    void SCAM::ReconstructOperations::visit(SCAM::VariableOperand &node) {
        if(node.getVariable()->isConstant()){
            this->newExpr = &node;
        }else if (node.getDataType()->isCompoundType()) {
            std::map<std::string, Expr *> selectList;
            for (auto subVar: node.getVariable()->getSubVarList()) {
                auto *subVarOp = new VariableOperand(subVar);
                selectList.insert(std::make_pair(subVar->getName(), this->find_or_add_variable(subVar->getFullName(), subVarOp)));
            }
            this->newExpr = new CompoundExpr(selectList, node.getDataType());

        } else if (node.getDataType()->isArrayType()) {
            std::map<std::string, Expr *> selectList;
            for (auto subVar: node.getVariable()->getSubVarList()) {
                auto *subVarOp = new VariableOperand(subVar);
                selectList.insert(std::make_pair(subVar->getName(), this->find_or_add_variable(subVar->getFullName(), subVarOp)));
            }
            this->newExpr = new ArrayExpr(selectList, node.getDataType());
            //throw std::runtime_error("HELLO");
        } else {
            this->newExpr = find_or_add_variable(node.getOperandName(), &node);
        }
    }

    void SCAM::ReconstructOperations::visit(SCAM::IntegerValue &node) {
        this->newExpr = &node;
    }

    void SCAM::ReconstructOperations::visit(SCAM::UnsignedValue &node) {
        this->newExpr = &node;
    }

    void SCAM::ReconstructOperations::visit(SCAM::BoolValue &node) {
        this->newExpr = &node;
    }

    void SCAM::ReconstructOperations::visit(SCAM::EnumValue &node) {
        this->newExpr = &node;
    }

    void SCAM::ReconstructOperations::visit(SCAM::CompoundValue &node) {
        this->newExpr = &node;
    }

    void SCAM::ReconstructOperations::visit(SCAM::PortOperand &node) {
        throw std::runtime_error("ReconstructOperations::PortOperand: Not allowed ");
    }

    void SCAM::ReconstructOperations::visit(SCAM::Assignment &node) {
        reset();
        //LHS
        //Add both sides to variableMaps
        node.getLhs()->accept(*this);

        if (this->isStateVar) return;

        //LHS name
        const std::string lhs = PrintStmt::toString(node.getLhs());

        if (node.getLhs()->getDataType()->isCompoundType()) {
            for (const auto &sub: node.getLhs()->getDataType()->getSubVarMap()) {
                //sub-var name:
                auto subvar_name = lhs + "." + sub.first;
                if (auto compoundVal = NodePeekVisitor::nodePeekCompoundValue(node.getRhs())) {
                    auto val = compoundVal->getValues().at(sub.first);
                    find_or_add_variable(subvar_name, val);
                    this->variableAssignmentMap.at(subvar_name) = val;
                } else if (auto variableOperand = NodePeekVisitor::nodePeekVariableOperand(node.getRhs())) {
                    auto subVar = new VariableOperand(variableOperand->getVariable()->getSubVar(sub.first));
                    this->variableAssignmentMap.at(subvar_name) = find_or_add_variable(subVar->getOperandName(), subVar);
                } else {
                    throw std::runtime_error("ReconstructOperations::Assignment: Unsure3");
                }
            }
        } else if (node.getLhs()->getDataType()->isArrayType()) {
            for (const auto &sub: node.getLhs()->getDataType()->getSubVarMap()) {
                //e.g. lhs = foo();
                auto subvar_name = lhs + "[" + sub.first + "]";
                if (auto arrayExpr = NodePeekVisitor::nodePeekArrayExpr(node.getRhs())) {
                    auto val = arrayExpr->getValueMap().at(sub.first);
                    this->variableAssignmentMap.at(subvar_name) = find_or_add_variable(subvar_name, val);
                } else if (auto variableOperand = NodePeekVisitor::nodePeekVariableOperand(node.getRhs())) {
                    auto subVar = new VariableOperand(variableOperand->getVariable()->getSubVar(sub.first));
                    auto val = find_or_add_variable(subVar->getOperandName(), subVar);
                    this->variableAssignmentMap.at(subvar_name) = val;
                } else {
                    throw std::runtime_error("ReconstructOperations::Assignment: Unsure2");
                }
            }
        } else {
            node.getRhs()->accept(*this);
            find_or_add_variable(lhs, node.getLhs());
            this->variableAssignmentMap.at(lhs) = this->newExpr;
        }
    }

    void SCAM::ReconstructOperations::visit(SCAM::UnaryExpr &node) {
        node.getExpr()->accept(*this);
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);

        } else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr);

        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
            } else this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));

        } else throw std::runtime_error("ReconstructOperations::UnaryExpr: Unknown unary operator " + node.getOperation());
    }

    void SCAM::ReconstructOperations::visit(SCAM::While &node) {
    }

    void SCAM::ReconstructOperations::visit(SCAM::If &node) {
        node.getConditionStmt()->accept(*this);
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->assumptionsList.push_back(this->newExpr);
    }

    void SCAM::ReconstructOperations::visit(SCAM::Read &node) {
        if (node.getPort()->getDataType()->isVoid()) {
            //Nothing to do: no datasignal0
        } else if (node.getPort()->hasSubVar()) {
            //Compound Type: Assign value of each subSignal du each component of var
            for (auto subVar :  node.getVariableOperand()->getVariable()->getSubVarList()) {
                std::string name = subVar->getFullName();
                this->find_or_add_variable(name, new VariableOperand(subVar));
                this->variableAssignmentMap[name] = new DataSignalOperand(node.getPort()->getDataSignal()->getSubVar(subVar->getName()));
            }
            //Assign dataSignal to variable
        } else {
            std::string varName = node.getVariableOperand()->getVariable()->getFullName();
            find_or_add_variable(varName, node.getVariableOperand());
            this->variableAssignmentMap[varName] = new DataSignalOperand(node.getPort()->getDataSignal());
        }

        /// add flag if used. for non blocking Read only
        if (node.isNonBlockingAccess() && (node.getStatusOperand() != nullptr)) {
            std::string statusName = node.getStatusOperand()->getVariable()->getFullName();
            find_or_add_variable(statusName, node.getStatusOperand());
            this->variableAssignmentMap[statusName] = node.getPort()->getSynchSignal();
        }
    }

    void SCAM::ReconstructOperations::visit(SCAM::Write &node) {

        if(this->isWaitOperation) {
            auto portOp = new DataSignalOperand(node.getPort()->getDataSignal());
            find_or_add_variable(portOp->getOperandName(),portOp);
            return;
        }

        node.getValue()->accept(*this);
        //Case for a write(var)
        if (ExprVisitor::getUsedOperands(this->newExpr).size() == 1) {
            //Compound: Assignment for each subVar
            if (this->newExpr->getDataType()->isCompoundType() || this->newExpr->getDataType()->isArrayType()) {
                if (auto compoundExpr = NodePeekVisitor::nodePeekCompoundExpr(this->newExpr)) {
                    for (auto subSig: node.getPort()->getDataSignal()->getSubVarList()) {
                        //throw std::runtime_error(" asdad ");
                        auto value = compoundExpr->getValueMap().at(subSig->getName());
                        find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        this->variableAssignmentMap[subSig->getFullName()] = value;
                    }
                }else if(auto arrayExpr = NodePeekVisitor::nodePeekArrayExpr(this->newExpr)){
                    for (auto subSig: node.getPort()->getDataSignal()->getSubVarList()) {
                        find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        this->variableAssignmentMap[subSig->getFullName()] = arrayExpr->getValueMap().at(subSig->getName());
                    }
                }else {
                    auto var = this->module->getVariable(ExprVisitor::getOperand(this->newExpr)->getOperandName());
                    for (auto subSig: node.getPort()->getDataSignal()->getSubVarList()) {
                        find_or_add_variable(var->getSubVar(subSig->getName())->getFullName(), new VariableOperand(var->getSubVar(subSig->getName())));
                        find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        this->variableAssignmentMap[subSig->getFullName()] = this->variableAssignmentMap[var->getSubVar(subSig->getName())->getFullName()];
                    }
                }
                //Simple var
            } else {
                find_or_add_variable(node.getPort()->getDataSignal()->getName(), new DataSignalOperand(node.getPort()->getDataSignal()));
                this->variableAssignmentMap[node.getPort()->getDataSignal()->getName()] = this->newExpr;
            }
            //Case for write(value)
        } else {
            if (this->newExpr->getDataType()->isCompoundType()) {
                if (auto *compoundExpr = dynamic_cast<CompoundExpr *>(this->newExpr)) {
                    for (auto subSig: node.getPort()->getDataSignal()->getSubVarList()) {
                        find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        this->variableAssignmentMap[subSig->getFullName()] = compoundExpr->getValueMap().at(subSig->getName());
                    }
                } else if (auto *compoundValue = dynamic_cast<CompoundValue *>(this->newExpr)) {
                    for (auto subSig: node.getPort()->getDataSignal()->getSubVarList()) {
                        find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        this->variableAssignmentMap[subSig->getFullName()] = compoundValue->getValues().at(subSig->getName());
                    }
                } else  throw std::runtime_error("ReconstructOperations::Write: Could not dynamically cast value as CompoundExpr or CompoundValue");
            } else if (this->newExpr->getDataType()->isArrayType()) {
                if (auto arrayExpr = NodePeekVisitor::nodePeekArrayExpr((this->newExpr))) {
                    for (auto subSig: node.getPort()->getDataSignal()->getSubVarList()) {
                        //throw std::runtime_error(" asdad ");
                        auto value = arrayExpr->getValueMap().at(subSig->getName());
                        find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        this->variableAssignmentMap[subSig->getFullName()] = value;
                    }
                }else if (auto *compoundValue = dynamic_cast<CompoundValue *>(this->newExpr)) {
                    for (auto subSig: node.getPort()->getDataSignal()->getSubVarList()) {
                        find_or_add_variable(subSig->getFullName(), new DataSignalOperand(subSig));
                        this->variableAssignmentMap[subSig->getFullName()] = compoundValue->getValues().at(subSig->getName());
                    }
                } else throw std::runtime_error("ReconstructOperations::Write: Could not dynamically cast value as CompoundExpr or CompoundValue");
            } else {
                find_or_add_variable(node.getPort()->getDataSignal()->getName(), new DataSignalOperand(node.getPort()->getDataSignal()));
                this->variableAssignmentMap[node.getPort()->getDataSignal()->getName()] = this->newExpr;// this is the correct assignment, right?
            }
        }

        /// add flag if used // this should not affect anything
        if (node.isNonBlockingAccess() && (node.getStatusOperand() != nullptr)) {
            std::string statusName = node.getStatusOperand()->getVariable()->getFullName();
            find_or_add_variable(statusName, node.getStatusOperand());
            this->variableAssignmentMap[statusName] = node.getPort()->getSynchSignal();
        }
    }

    void SCAM::ReconstructOperations::visit(SCAM::SectionOperand &node) {
        this->isStateVar = true;
    }

    void SCAM::ReconstructOperations::visit(SCAM::SectionValue &node) {
    }

    void SCAM::ReconstructOperations::visit(SCAM::ITE &node) {
        throw std::runtime_error("ReconstructOperations::ITE: ITE not allowed");
    }

    void SCAM::ReconstructOperations::visit(SCAM::Arithmetic &node) {
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

    void SCAM::ReconstructOperations::visit(SCAM::Logical &node) {
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

    void SCAM::ReconstructOperations::visit(SCAM::Relational &node) {
        //LHS
        SCAM::Expr *lhs;
        node.getLhs()->accept(*this);
        lhs = this->newExpr;

        //RHS
        SCAM::Expr *rhs;
        node.getRhs()->accept(*this);
        rhs = this->newExpr;
        this->newExpr = new SCAM::Relational(lhs, node.getOperation(), rhs);
    }

    void SCAM::ReconstructOperations::visit(SCAM::Bitwise &node) {
        //LHS
        SCAM::Expr *lhs;
        node.getLhs()->accept(*this);
        lhs = this->newExpr;

        //RHS
        SCAM::Expr *rhs;
        node.getRhs()->accept(*this);
        rhs = this->newExpr;

        this->newExpr = new SCAM::Bitwise(lhs, node.getOperation(), rhs);
        //    //Reset var&const to false
        reset();
    }

    void SCAM::ReconstructOperations::visit(SCAM::SyncSignal &node) {
        this->newExpr = &node;
    }

    void SCAM::ReconstructOperations::visit(SCAM::DataSignalOperand &node) {
        if (node.getPort()->hasSubVar()) {
            for (auto subSig: node.getDataSignal()->getSubVarList()) {
                auto *subSigOp = new DataSignalOperand(subSig);
                this->find_or_add_variable(subSig->getFullName(), subSigOp);
            }
        } else {
            this->newExpr = find_or_add_variable(node.getOperandName(), &node);
        }
    }

    void SCAM::ReconstructOperations::visit(SCAM::Cast &node) {
        node.getSubExpr()->accept(*this);
        this->newExpr = new Cast(this->newExpr, node.getDataType());
    }

    void SCAM::ReconstructOperations::visit(SCAM::FunctionOperand &node) {
        std::map<std::string, SCAM::Parameter *> newParamMap;
        std::map<std::string, SCAM::Expr *> newParamValueMap;

        for (auto &&param : node.getParamValueMap()) {
            param.second->accept(*this);

            if (param.second->getDataType()->isCompoundType()) {
                if (NodePeekVisitor::nodePeekCompoundExpr(this->newExpr) != nullptr) {
                    auto *comExpr = NodePeekVisitor::nodePeekCompoundExpr(this->newExpr);
                    for (const auto &subVar : comExpr->getValueMap()) {
                        SCAM::Parameter *newParam = new SCAM::Parameter(PrintStmt::toString(subVar.second), (SCAM::DataType *) subVar.second->getDataType());
                        newParamMap.insert(std::make_pair(newParam->getName(), newParam));
                        newParamValueMap.insert(std::make_pair(newParam->getName(), subVar.second));
                    }
                } else throw std::runtime_error("NOT IMPLEMENTED");

            } else if (param.second->getDataType()->isArrayType()) {
                throw std::runtime_error("NOT IMPLEMENTED");
            } else {
                SCAM::Parameter *newParam = new SCAM::Parameter(param.first, (SCAM::DataType *) param.second->getDataType());
                newParamMap.insert(std::make_pair(newParam->getName(), newParam));
                newParamValueMap.insert(std::make_pair(newParam->getName(), this->newExpr));
            }
        }
        //If paramMap = oldParam use old function
        if (newParamMap.size() == node.getFunction()->getParamMap().size()) {
            this->newExpr = new FunctionOperand(node.getFunction(), newParamValueMap);
        } else {
            Function *newFun = new Function(node.getFunction()->getName(), node.getFunction()->getReturnType(), newParamMap);
            newFun->setReturnValueConditionList(node.getFunction()->getReturnValueConditionList());
            this->newExpr = new FunctionOperand(newFun, newParamValueMap);
        }

    }

    void SCAM::ReconstructOperations::visit(SCAM::ArrayOperand &node) {

        //update idx
        node.getIdx()->accept(*this);

        auto sig = reconstructArrayVar(node.getArrayOperand());
        if(sig){
            this->newExpr = new ArrayOperand(new DataSignalOperand(sig), this->newExpr);
            return;
        }

        //Regular case from here
        if (!(*node.getIdx() == *this->newExpr)) {
            this->newExpr = new ArrayOperand(node.getArrayOperand(), this->newExpr);
        } else this->newExpr = &node;
    }

    void SCAM::ReconstructOperations::visit(SCAM::CompoundExpr &node) {
        std::map<std::string, Expr *> valueMap;
        for (auto val: node.getValueMap()) {
            val.second->accept(*this);
            valueMap.insert(std::make_pair(val.first, this->newExpr));
        }
        this->newExpr = new CompoundExpr(valueMap, node.getDataType());
    }

    void SCAM::ReconstructOperations::visit(SCAM::ParamOperand &node) {
        if (node.getDataType()->isCompoundType()) {
            for (auto subVar: node.getParameter()->getSubVarList()) {
                this->find_or_add_variable(node.getOperandName() + "." + subVar->getName(), new ParamOperand(subVar));
            }
        } else {
            this->newExpr = find_or_add_variable(node.getOperandName(), &node);
        }
    }

    void SCAM::ReconstructOperations::visit(SCAM::Return &node) {
        node.getReturnValue()->accept(*this);
        if (this->returnValue != nullptr) throw std::runtime_error("Current path has two return values");
        this->returnValue = new Return(this->newExpr);

    }

    void SCAM::ReconstructOperations::visit(SCAM::Notify &node) {
        throw std::runtime_error("ReconstructOperations::Notify: Not implemented");
    }

    DataSignal *ReconstructOperations::reconstructArrayVar(Operand *operand) {
        /*
       * Special case:
       * m_in->master_read(tmp);
       * b_out->write(tmp[foobar(0)]);
       *
       * Every ArrayOperand is pointing to the same variable m_in_sig and this is why tmp has to be replaced with m_in_sig
      */
        //Step 1: find all entries in the variableAssignmentMap related to this array
        std::map<std::string, SCAM::Expr *> arrayAssignemntMap;
        for(auto element: operand->getDataType()->getSubVarMap()){
            std::string name = operand->getOperandName()+"["+element.first+"]";
            if(this->variableAssignmentMap.find(name) != this->variableAssignmentMap.end()){
                arrayAssignemntMap.insert(*this->variableAssignmentMap.find(name));
            }
        }

        //Step 2: For now we expect the assignment to be a ArrayOperand, if not exit and return original variable
        DataSignal * check = nullptr;
        bool isFirstIteratioin = true;
        for(auto element: arrayAssignemntMap){
            auto signal = NodePeekVisitor::nodePeekDataSignalOperand(element.second);
            if(signal){
                if(isFirstIteratioin){
                    isFirstIteratioin = false;
                    check = signal->getDataSignal()->getParent();
                }else{
                    if(check != signal->getDataSignal()->getParent()){
                        return nullptr;
                    }
                    check = signal->getDataSignal()->getParent();
                }
            }
        }
        return check;
    }

    void ReconstructOperations::visit(ArrayExpr &node) {
        std::map<std::string, Expr *> valueMap;
        for (auto val: node.getValueMap()) {
            val.second->accept(*this);
            valueMap.insert(std::make_pair(val.first, this->newExpr));
        }
        this->newExpr = new ArrayExpr(valueMap, node.getDataType());
    }

    void SCAM::ReconstructOperations::visit(SCAM::Wait &node) {
        //DO nothing
    }

    void SCAM::ReconstructOperations::visit(SCAM::Peek &node) {
        this->newExpr = node.getPort()->getSynchSignal();
    }


}
