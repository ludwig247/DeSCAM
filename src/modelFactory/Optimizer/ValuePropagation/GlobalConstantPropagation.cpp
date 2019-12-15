//
// Created by M.I.Alkoudsi on 16.05.19.
//



#include "GlobalConstantPropagation.h"
#include "Optimizer/Debug.h"
/* Idea:
 * Look for variables used in the CFG statements. For each found use:
 * If variable was checked before and has entry in varValMap. get its value from varValMap
 * Otherwise, make all paths to the statement and call propagateConstantValue
 * If propagation is valid, update varValMap and the statement
 * */
namespace SCAM {

    GlobalConstantPropagation::GlobalConstantPropagation(const std::map<int, SCAM::CfgNode *> &CFG,
                                                         const FindCfgPaths &findCfgPaths,
                                                         std::set<std::string> variablesThatHaveReadSet) : CFG(
            CFG), propagationValid(false), variablesThatHaveReadSet(std::move(variablesThatHaveReadSet)) {
        this->newExpr = nullptr;

        this->setPathsMap(findCfgPaths.getPathsMap());
        this->setNodeAndAllPathsReachingItMap(findCfgPaths.getNodeAndAllPathsReachingItMap());
#ifdef DEBUG_GLOBAL_CONSTANT_PROPAGATION
        std::cout << std::endl << "******************* Global constant propagation ******************* " << std::endl;
#endif
        if (!CFG.empty()) {
            for (auto node: CFG) {
                currentNodeID = node.second->getId();
                auto statement = node.second->getStmt();
                if (statement != nullptr) {
#ifdef DEBUG_GLOBAL_CONSTANT_PROPAGATION
                    std::cout << "Checking statement: " << PrintStmt::toString(statement) << std::endl;
#endif
                    statement->accept(*this);
                }
            }
        }
#ifdef DEBUG_GLOBAL_CONSTANT_PROPAGATION
        std::cout << "*******************************************************************" << std::endl;
#endif
    }


    const std::map<int, SCAM::CfgNode *> &GlobalConstantPropagation::getCFG() const {
        return this->CFG;
    }


    void GlobalConstantPropagation::visit(struct VariableOperand &node) {
        this->newExpr = nullptr;
        if (bool VarRead_Or_CheckedBeforeAndPropagationWasNotValid =
                (this->variablesThatHaveReadSet.find(node.getVariable()->getFullName()) !=
                 this->variablesThatHaveReadSet.end()) ||
                (this->varValMap.find(node.getVariable()->getFullName()) == this->varValMap.end() &&
                 this->varAlreadyCheckedSet.find(node.getVariable()->getFullName()) !=
                 this->varAlreadyCheckedSet.end())) {
            return;
        } else if (bool CheckedBeforeAndPropagationWasValid =
                (this->varValMap.find(node.getVariable()->getFullName()) != this->varValMap.end()) &&
                (this->varAlreadyCheckedSet.find(node.getVariable()->getFullName()) !=
                 this->varAlreadyCheckedSet.end())) {
            this->newExpr = this->varValMap.at(node.getVariable()->getFullName());
            this->propagationValid = true;
        } else {
            PropagateConstantValue propagator(this->makeAllPathsToNode(this->currentNodeID),
                                              node.getVariable(),
                                              this->currentNodeID);           //check if propagation is valid on all paths
            this->varAlreadyCheckedSet.insert(node.getVariable()->getFullName());
            if (propagator.getPropagatedValue() != nullptr) {
                this->propagationValid = true;
                this->newExpr = propagator.getPropagatedValue();
                this->varValMap.insert(std::make_pair(node.getVariable()->getFullName(), this->newExpr));
            }
        }
    }

    void GlobalConstantPropagation::visit(class Assignment &node) {
        // if the lhs is a variableoperand check if there is a use of a variable in the rhs
        auto lhs = dynamic_cast<SCAM::VariableOperand *>(node.getLhs());
        if (lhs != nullptr) {
            node.getRhs()->accept(*this);
            if (this->newExpr != nullptr && propagationValid) {
                auto assignment = new Assignment(lhs, this->newExpr);
#ifdef DEBUG_GLOBAL_CONSTANT_PROPAGATION
                const std::string newAssignment = PrintStmt::toString(assignment);
                const std::string oldAssignment = PrintStmt::toString(&node);
                if (oldAssignment != newAssignment) {
                    std::cout << "in Node" << currentNodeID << ": the assignment "
                              << oldAssignment << " is changed to "
                              << newAssignment
                              << std::endl;
                }
#endif
                // set assignment as new node stmt
                this->CFG.at(currentNodeID)->setStmt(assignment);
                this->newExpr = nullptr;
                propagationValid = false;
            }
        }
    }

    void GlobalConstantPropagation::visit(struct UnaryExpr &node) {
        this->newExpr = nullptr;
        node.getExpr()->accept(*this);
        if (this->newExpr != nullptr) {
            if (node.getOperation() == "not") {
                this->newExpr = new UnaryExpr("not", this->newExpr);
            } else if (node.getOperation() == "~") {
                this->newExpr = new UnaryExpr("~", this->newExpr);
            } else if (node.getOperation() == "-") {
                if (node.getExpr()->getDataType()->isUnsigned()) {
                    this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
                } else this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));
            } else throw std::runtime_error("Unknown unary operator " + node.getOperation());
        }
    }

    void GlobalConstantPropagation::visit(struct If &node) {
        if (node.getConditionStmt() != nullptr) {
            node.getConditionStmt()->accept(*this);
            if (this->newExpr != nullptr && propagationValid) {
                assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
                auto ifStmt = new If(this->newExpr);
#ifdef DEBUG_GLOBAL_CONSTANT_PROPAGATION
                const std::string newAssignment = PrintStmt::toString(ifStmt);
                const std::string oldAssignment = PrintStmt::toString(&node);
                if (oldAssignment != newAssignment) {
                    std::cout << "in Node" << currentNodeID << ": the assignment "
                              << oldAssignment << " is changed to "
                              << newAssignment
                              << std::endl;
                }
#endif
                // set assignment as new node stmt
                this->CFG.at(currentNodeID)->setStmt(ifStmt);
                this->newExpr = nullptr;
                propagationValid = false;
            }
        }
    }

    void GlobalConstantPropagation::visit(struct Write &node) {
        node.getValue()->accept(*this);
        if (this->newExpr != nullptr && propagationValid) {
            auto writeStatement = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(),
                                            node.getStatusOperand());
#ifdef DEBUG_GLOBAL_CONSTANT_PROPAGATION
            const std::string newAssignment = PrintStmt::toString(writeStatement);
            const std::string oldAssignment = PrintStmt::toString(&node);
            if (oldAssignment != newAssignment) {
                std::cout << "in Node" << currentNodeID << ": the assignment "
                          << oldAssignment << " is changed to "
                          << newAssignment
                          << std::endl;
            }
#endif
            // set assignment as new node stmt
            this->CFG.at(currentNodeID)->setStmt(writeStatement);
            this->newExpr = nullptr;
            propagationValid = false;
        }
    }

    void GlobalConstantPropagation::visit(struct Arithmetic &node) {
        //LHS
        this->newExpr = nullptr;
        Expr *lhs = node.getLhs();
        node.getLhs()->accept(*this);
        if (this->newExpr != nullptr) { lhs = this->newExpr; }

        //RHS
        this->newExpr = nullptr;
        Expr *rhs = node.getRhs();
        node.getRhs()->accept(*this);
        if (this->newExpr != nullptr) { rhs = this->newExpr; }

        //Create new stmt
        this->newExpr = new Arithmetic(lhs, node.getOperation(), rhs);
    }

    void GlobalConstantPropagation::visit(struct Logical &node) {
        //LHS
        this->newExpr = nullptr;
        Expr *lhs = node.getLhs();
        node.getLhs()->accept(*this);
        if (this->newExpr != nullptr) { lhs = this->newExpr; }


        //RHS
        this->newExpr = nullptr;
        Expr *rhs = node.getRhs();
        node.getRhs()->accept(*this);
        if (this->newExpr != nullptr) { rhs = this->newExpr; }

        //Create new stmt
        this->newExpr = new Logical(lhs, node.getOperation(), rhs);
    }

    void GlobalConstantPropagation::visit(struct Relational &node) {
        //LHS
        this->newExpr = nullptr;
        Expr *lhs = node.getLhs();
        node.getLhs()->accept(*this);
        if (this->newExpr != nullptr) { lhs = this->newExpr; }


        //RHS
        this->newExpr = nullptr;
        Expr *rhs = node.getRhs();
        node.getRhs()->accept(*this);
        if (this->newExpr != nullptr) { rhs = this->newExpr; }

        //Create new stmt
        this->newExpr = new Relational(lhs, node.getOperation(), rhs);
    }

    void GlobalConstantPropagation::visit(struct Bitwise &node) {
        //LHS
        this->newExpr = nullptr;
        Expr *lhs = node.getLhs();
        node.getLhs()->accept(*this);
        if (this->newExpr != nullptr) { lhs = this->newExpr; }


        //RHS
        this->newExpr = nullptr;
        Expr *rhs = node.getRhs();
        node.getRhs()->accept(*this);
        if (this->newExpr != nullptr) { rhs = this->newExpr; }

        //Create new stmt
        this->newExpr = new Bitwise(lhs, node.getOperation(), rhs);
    }


    void GlobalConstantPropagation::visit(struct Cast &node) {
        this->newExpr = nullptr;
        node.getSubExpr()->accept(*this);
        if (this->newExpr != nullptr) {
            this->newExpr = new Cast(this->newExpr, node.getDataType());
        } else { this->newExpr = &node; }
    }

    void GlobalConstantPropagation::visit(struct SCAM::FunctionOperand &node) {
        std::map<std::string, SCAM::Expr *> newParamValueMap;
        for (auto param : node.getParamValueMap()) {
            this->newExpr = nullptr;
            param.second->accept(*this);
            if (this->newExpr != nullptr) {
                newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
            } else {
                newParamValueMap.insert(std::make_pair(param.first, param.second));
            }
        }
        this->newExpr = new SCAM::FunctionOperand(node.getFunction(), newParamValueMap);
    }

    void GlobalConstantPropagation::visit(struct ArrayOperand &node) {
        this->newExpr = nullptr;
        node.getIdx()->accept(*this);
        if (this->newExpr != nullptr && !(*node.getIdx() == *this->newExpr)) {
            this->newExpr = new ArrayOperand(node.getArrayOperand(), this->newExpr);
        }
    }

    void GlobalConstantPropagation::visit(class CompoundExpr &node) {
        std::map<std::string, SCAM::Expr *> valueMap;
        for (auto subVar : node.getValueMap()) {
            this->newExpr = nullptr;
            subVar.second->accept(*this);
            if (this->newExpr != nullptr) {
                valueMap.insert(std::make_pair(subVar.first, this->newExpr));
            } else { valueMap.insert(std::make_pair(subVar.first, subVar.second)); }
        }
        this->newExpr = new CompoundExpr(valueMap, node.getDataType());
    }

    void GlobalConstantPropagation::visit(class ArrayExpr &node) {
        std::map<std::string, SCAM::Expr *> valueMap;
        for (auto subVar : node.getValueMap()) {
            this->newExpr = nullptr;
            subVar.second->accept(*this);
            if (this->newExpr != nullptr) {
                valueMap.insert(std::make_pair(subVar.first, this->newExpr));
            } else { valueMap.insert(std::make_pair(subVar.first, subVar.second)); }
        }
        this->newExpr = new ArrayExpr(valueMap, node.getDataType());
    }


}