//
// Created by M.I.Alkoudsi on 11.06.19.
//

#include <Optimizer/Utilities/ExpressionSubstitution.h>
#include "ReachabilityAnalysis.h"
#include "Optimizer/Debug.h"


namespace SCAM {

    z3::context RA_z3Context;
    z3::solver RA_solver_t(RA_z3Context);
    z3::solver RA_solver_f(RA_z3Context);
    SCAM::ExprTranslator RA_translator(&RA_z3Context);

    ReachabilityAnalysis::ReachabilityAnalysis(const std::map<int, CfgNode *> &CFG,
                                               std::set<std::string> variablesThatHaveReadSet) : CFG(
            CFG), variablesThatHaveReadSet(std::move(variablesThatHaveReadSet)), RA_hasRead(
            false), z3Expr(RA_z3Context) {

#ifdef DEBUG_REACHABILITY_ANALYSIS
        std::cout << std::endl << "********************** Reachability analysis ********************** " << std::endl;
#endif

        //Finding all variable values
        SCAM::FindVariablesValues valuesFinder(this->CFG, this->variablesThatHaveReadSet);
        this->allVarValuesMap = valuesFinder.getVariableValuesMap();

        //Finding all possible paths from while to the sink node
        whileNodeID = SCAM::GlobalUtilities::findWhileNodeId(this->CFG);
        FindCfgPaths pathsFromWhile(this->CFG, whileNodeID);

        //Analysis of if statements
        for (auto node : CFG) {
            auto statement = node.second->getStmt();
            if (statement != nullptr) {
                if (auto ifStmt = dynamic_cast<SCAM::If *>(statement)) {
#ifdef DEBUG_REACHABILITY_ANALYSIS
//                    std::cout << "Checking statement: " << SCAM::PrintStmt::toString(statement)
//                              << std::endl;
#endif
                    currentNodeID = node.second->getId();
                    if (auto insideIf = ifStmt->getConditionStmt()) {
                        //if section operand don't check for now
                        if (auto relationalstmt = dynamic_cast<SCAM::Relational *>(insideIf)) {
                            if (dynamic_cast<SCAM::SectionOperand *>(relationalstmt->getLhs())) {
                                continue;
                            }
                        }
                        //Finding paths from while to the current if statement
                        pathsToIfMap.clear();
                        pathsToIfMap = pathsFromWhile.makeResetPathsToNode(currentNodeID);

                        RA_solver_f.reset();
                        RA_solver_t.reset();
                        this->assignmentsToIfValuesMap.clear();
                        this->substitutionMap.clear();
                        SCAM::FindVariablesAndFunctionsInStatement findVariablesAndFunctionsInStatement(insideIf,std::set<std::string>{});
                        if (findVariablesAndFunctionsInStatement.hasFunctions()) { continue; }
                        for (auto varOp : findVariablesAndFunctionsInStatement.getVarOpInStmtSet()) {
                            checkAndAddVariableToSubstitutionMap(varOp);
                        }

                        if (RA_hasRead) {
                            RA_hasRead = false;
#ifdef DEBUG_REACHABILITY_ANALYSIS
                            std::cout
                                    << "Expression inside if has a read or one of the variables inside the expression has a read"
                                    << std::endl;
#endif
                            continue;
                        }
                        if (!this->substitutionMap.empty()) {
                            auto firstSubstitutedSet = substituteVariablesInsideIfExpressionWithTheirValues(
                                    insideIf);
                            std::vector<SCAM::Expr *> newSet;
                            for (auto se: firstSubstitutedSet) {
                                SCAM::FindVariablesAndFunctionsInStatement fv(se,std::set<std::string>{});
                                if (fv.hasFunctions() || fv.getVariablesInStmtSet().empty() ||
                                    (*fv.getVarOpInStmtSet().begin())->getDataType()->isEnumType() ||
                                    (*fv.getVarOpInStmtSet().begin())->getDataType()->isBoolean()) {
                                    newSet.push_back(se);
                                    continue;
                                }
                                substitutionMap.clear();
                                for (auto varOp : fv.getVarOpInStmtSet()) {
                                    checkAndAddVariableToSubstitutionMap(varOp);
                                    if (RA_hasRead) {
                                        newSet.push_back(se);
                                        break;
                                    }
                                }
                                if (RA_hasRead) {
                                    RA_hasRead = false;
                                    continue;
                                }
                                auto newExprsSet = substituteVariablesInsideIfExpressionWithTheirValues(
                                        se);
                                for (auto nExpr : newExprsSet) {
                                    newSet.push_back(nExpr);
                                }
                            }

                            std::vector<z3::expr> toBeAssertedExpressions;
                            for(auto scamExpr : newSet){
                                z3::expr newZ3Expr(RA_z3Context);
                                try {
                                    newZ3Expr = RA_translator.translate(scamExpr);
                                    toBeAssertedExpressions.push_back(newZ3Expr);
                                }
                                catch (z3::exception &e) {
                                    toBeAssertedExpressions.clear();
                                    break;
                                }
                                catch (std::runtime_error &e) {
                                    toBeAssertedExpressions.clear();
                                    break;
                                }
                            }

#ifdef DEBUG_REACHABILITY_ANALYSIS
//                            for (auto exp : toBeAssertedExpr) {
//                                std::cout << "exp is: " << exp << std::endl;
//
//                            }
#endif
                            if (!toBeAssertedExpressions.empty()) {//check each stmt in the vector alone
                                bool notfalse = true;
                                bool nottrue = true;
                                for (const auto &expr : toBeAssertedExpressions) {
                                    RA_solver_f.reset();
                                    RA_solver_f.add(!expr);
                                    if (RA_solver_f.check() == z3::sat || RA_solver_f.check() == z3::unknown) {
                                        notfalse = false;
                                        break;
                                    }
                                }
                                if (notfalse) {
                                    printWarning(this->CFG.at(currentNodeID)->getStmt(), false);
                                    unreachableNodes.insert(node.second->getSuccessorList()[1]->getId());
                                    node.second->removeSuccessor(node.second->getSuccessorList()[1]);
                                    this->ifNodesToBeDeleted.insert(node.second->getId());
                                }

                                for (const auto &expr : toBeAssertedExpressions) {
                                    RA_solver_t.reset();
                                    RA_solver_t.add(expr);
                                    if (RA_solver_t.check() == z3::sat || RA_solver_t.check() == z3::unknown) {
                                        nottrue = false;
                                        break;
                                    }
                                }
                                if (nottrue) {
                                    printWarning(this->CFG.at(currentNodeID)->getStmt(), true);
                                    unreachableNodes.insert(node.second->getSuccessorList()[0]->getId());
                                    node.second->removeSuccessor(node.second->getSuccessorList()[0]);
                                    this->ifNodesToBeDeleted.insert(node.second->getId());
                                }
                            }
                        } else {
                            z3::expr z3InsideIf(RA_z3Context);
                            try { z3InsideIf = RA_translator.translate(insideIf); }
                            catch (z3::exception& e) {
                                continue;
                            }
                            catch (std::runtime_error& e){
                                continue;
                            }

                            //check if statement can be false
                            RA_solver_f.add(!z3InsideIf);
                            if (RA_solver_f.check() == z3::sat || RA_solver_f.check() == z3::unknown) {
                            } else {
                                printWarning(this->CFG.at(currentNodeID)->getStmt(), false);
                                unreachableNodes.insert(node.second->getSuccessorList()[1]->getId());
                                node.second->removeSuccessor(node.second->getSuccessorList()[1]);
                                this->ifNodesToBeDeleted.insert(node.second->getId());
                            }
                            //check if statement can be true
                            RA_solver_t.add(z3InsideIf);
                            if (RA_solver_t.check() == z3::sat || RA_solver_t.check() == z3::unknown) {
                            } else {
                                printWarning(this->CFG.at(currentNodeID)->getStmt(), true);
                                unreachableNodes.insert(node.second->getSuccessorList()[0]->getId());
                                node.second->removeSuccessor(node.second->getSuccessorList()[0]);
                                this->ifNodesToBeDeleted.insert(node.second->getId());
                            }
                        }
                    }
                }
            }
        }

        removeDeadIfStatementsAndReplaceItInPredecessorsAndSuccessors();
#ifdef DEBUG_REACHABILITY_ANALYSIS
        for (auto node : this->unreachableNodes) {
            if (node == whileNodeID) { continue; }
            if (this->CFG.find(node) != this->CFG.end()) {

                std::cout << "Following Paths from Node" << node
                          << " are unreachable and will be deleted by default" << std::endl;
                FindCfgPaths unreachablePath(this->CFG, node);
                for (auto path : unreachablePath.getPathsMap()) {
                    std::cout << path.second.print();
                }
            }
        }
#endif

        removeDeadPathsOfDeadIfStatements();

#ifdef DEBUG_REACHABILITY_ANALYSIS
        std::cout << "*******************************************************************" << std::endl;
#endif
    }

    void ReachabilityAnalysis::checkAndAddVariableToSubstitutionMap(SCAM::VariableOperand *varOp) {
        auto varName = varOp->getVariable()->getFullName();
        if (this->variablesThatHaveReadSet.find(varName) ==
            this->variablesThatHaveReadSet.end()) {
            this->substitutionMap.insert(
                    std::make_pair(varName, varOp));
            if (this->assignmentsToIfValuesMap.find(varName) ==
                this->assignmentsToIfValuesMap.end()) { // use only assignment values to the variable that can be used in the If statement
                PropagateConstantValue propagator(this->pathsToIfMap, varOp->getVariable(), this->currentNodeID);
#ifdef DEBUG_REACHABILITY_ANALYSIS
                std::cout << "number of paths to if node " << this->pathsToIfMap.size() << std::endl;
#endif
                if (propagator.getNumLastAssignments() != 0 &&
                    propagator.getNumLastAssignments() == this->pathsToIfMap.size()) {
                    std::set<SCAM::Expr *> values;
                    for (auto assignment : propagator.getLastAssignmentsMap()) {
                        values.insert(assignment.second);
                    }
                    // add initial values from the reset sequence
                    int nodeId = (*this->CFG.begin()).first;
                    while (nodeId != whileNodeID) {
                        auto stmt = this->CFG.at(nodeId)->getStmt();
                        if (stmt != nullptr) {
                            if (auto assignment = dynamic_cast<SCAM::Assignment *>(stmt)) {
                                if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(assignment->getLhs())) {
                                    if (varOp->getVariable()->getFullName() == varName) {
                                        values.insert(assignment->getRhs());
                                    }
                                }
                            }
                        }
                        nodeId = this->CFG.at(nodeId)->getSuccessorList().front()->getId();
                    }
                    this->assignmentsToIfValuesMap.insert(std::make_pair(varName, values));
                } else { // use all assignment values to the variable
                    std::set<SCAM::Expr *> values;
                    this->assignmentsToIfValuesMap.insert(std::make_pair(varName, values));
                }
            }
        } else if (this->variablesThatHaveReadSet.find(varName) !=
                   this->variablesThatHaveReadSet.end()) {
            RA_hasRead = true;
        }
    }


    std::vector<SCAM::Expr *>
    ReachabilityAnalysis::substituteVariablesInsideIfExpressionWithTheirValues(SCAM::Expr *ExpressionInsideIf) {
        int numberOfVariables = this->substitutionMap.size();
        auto pairItr = this->substitutionMap.begin();
        int currentVariableIndicator = 0;
        std::vector<int> currentValueIndex(numberOfVariables, 0);
        std::stack<SCAM::Expr *> expressionStack;
        expressionStack.push(ExpressionInsideIf);
        std::vector<SCAM::Expr *> toBeAssertedExpr;
        while (!expressionStack.empty()) {
            std::string currentVarName = (*pairItr).first;
            if (this->assignmentsToIfValuesMap.find(currentVarName) !=
                this->assignmentsToIfValuesMap.end() &&
                !this->assignmentsToIfValuesMap.at(currentVarName).empty()) {
                auto valptr = this->assignmentsToIfValuesMap.at(currentVarName).begin();
                for (int i = 0; i < currentValueIndex[currentVariableIndicator]; i++) { valptr++; }
                if (this->assignmentsToIfValuesMap.at(currentVarName).end() != valptr) {
                    SCAM::Expr *expression = expressionStack.top();
                    SCAM::Expr *newExpression = SCAM::ExpressionSubstitution::substituteExpr(expression,pairItr->second,*valptr);
                    currentValueIndex[currentVariableIndicator] += 1;
                    if (currentVariableIndicator ==
                        numberOfVariables -
                        1) { //we currently have the last variable in the substitution map
                        toBeAssertedExpr.push_back(newExpression);
                    } else {
                        currentVariableIndicator += 1;
                        pairItr++;
                        expressionStack.push(newExpression);
                    }
                } else {
                    currentValueIndex[currentVariableIndicator] = 0;
                    currentVariableIndicator -= 1;
                    pairItr--;
                    expressionStack.pop();
                }
            } else if (this->allVarValuesMap.find(currentVarName) != this->allVarValuesMap.end()) {
                auto valptr = this->allVarValuesMap.at(currentVarName).begin();
                for (int i = 0; i < currentValueIndex[currentVariableIndicator]; i++) { valptr++; }
                if (this->allVarValuesMap.at(currentVarName).end() != valptr) {
                    SCAM::Expr *expression = expressionStack.top();
                    SCAM::Expr *newExpression = SCAM::ExpressionSubstitution::substituteExpr(expression,pairItr->second,*valptr);
                    currentValueIndex[currentVariableIndicator] += 1;
                    if (currentVariableIndicator ==
                        numberOfVariables -
                        1) { //we currently have the last variable in the substitution map
                        toBeAssertedExpr.push_back(newExpression);
                    } else {
                        currentVariableIndicator += 1;
                        pairItr++;
                        expressionStack.push(newExpression);
                    }
                } else {
                    currentValueIndex[currentVariableIndicator] = 0;
                    currentVariableIndicator -= 1;
                    pairItr--;
                    expressionStack.pop();
                }
            } else {
                expressionStack.pop();
            }
        }
        return toBeAssertedExpr;
    }


    void ReachabilityAnalysis::removeDeadIfStatementsAndReplaceItInPredecessorsAndSuccessors() {
        for (auto node : this->ifNodesToBeDeleted) {
            if (this->CFG.find(node) != this->CFG.end()) {
                std::vector<bool> alreadyReplacedPred(this->CFG.at(node)->getSuccessorList().size(), false);
                std::vector<bool> alreadyReplacedSucc(this->CFG.at(node)->getPredecessorList().size(), false);
                int succIdx = 0, predIdx = 0;
                auto cfgnode = this->CFG.at(node);
                auto predecessorList = this->CFG.at(node)->getPredecessorList();
                auto SuccessorList = this->CFG.at(node)->getSuccessorList();
                for (auto pred : predecessorList) {
                    for (auto succ : SuccessorList) {
                        if (this->unreachableNodes.find(succ->getId()) != this->unreachableNodes.end() &&
                            succ->getPredecessorList().size() > 1) {
                            for (auto predinSuc : succ->getPredecessorList()) {
                                if (predinSuc == cfgnode) {
                                    succ->removePredecessor(this->CFG.at(node));
                                    if (!alreadyReplacedSucc[predIdx]) {
                                        pred->replaceSuccessor(cfgnode, succ);
                                        alreadyReplacedSucc[predIdx] = true;
                                    } else { pred->addSuccessor(succ); }
                                }
                            }
                        } else {
                            if (!alreadyReplacedPred[succIdx]) {
                                bool predAlreadyInSuccPredList = false;
                                for (auto predInSuc : succ->getPredecessorList()) {
                                    if (predInSuc == pred) {
                                        predAlreadyInSuccPredList = true;
                                    }
                                }
                                if (predAlreadyInSuccPredList) {
                                    succ->removePredecessor(cfgnode);
                                } else {
                                    succ->replacePredecessor(cfgnode, pred);
                                }
                                alreadyReplacedPred[succIdx] = true;
                            } else { succ->addPredecessor(pred); }
                            if (!alreadyReplacedSucc[predIdx]) {
                                bool succAlreadyInPredSuccList = false;
                                for (auto succInPred : pred->getSuccessorList()) {
                                    if (succInPred == succ) {
                                        succAlreadyInPredSuccList = true;
                                    }
                                }
                                if (succAlreadyInPredSuccList) {
                                    pred->removeSuccessor(cfgnode);
                                } else {
                                    pred->replaceSuccessor(cfgnode, succ);
                                }
                                alreadyReplacedSucc[predIdx] = true;
                            } else { pred->addSuccessor(succ); }

                        }
                        succIdx++;
                    }
                    succIdx = 0;
                    predIdx++;
                }
#ifdef DEBUG_REACHABILITY_ANALYSIS
                std::cout << "Node" << node << " with statement: " << PrintStmt::toString(this->CFG.at(node)->getStmt())
                          << " has been deleted."
                          << std::endl;
#endif
                this->CFG.erase(node);
            }
        }
    }

    void ReachabilityAnalysis::removeDeadPathsOfDeadIfStatements() {
        std::set<int> unreachableNodesVector;
        FindCfgPaths newPaths(this->CFG, 0);
        for (const auto &node : newPaths.getNodeAndAllPathsReachingItMap()) {
            if (node.second.empty()) {
                unreachableNodesVector.insert(node.first);
            }
        }
        for (auto node : unreachableNodesVector) {
#ifdef DEBUG_REACHABILITY_ANALYSIS
            std::cout << "Node" << node << " is unreachable and has been deleted."
                      << std::endl;
#endif
            for (auto succ : this->CFG.at(node)->getSuccessorList()) {
                if (unreachableNodesVector.find(succ->getId()) ==
                    unreachableNodesVector.end()) {
                    for (auto pred: succ->getPredecessorList()) {
                        if (pred->getId() == node) { this->CFG.at(succ->getId())->removePredecessor(pred); }
                    }
                }
            }
            this->CFG.erase(node);
        }
    }

    const std::map<int, CfgNode *> &ReachabilityAnalysis::getCFG() const {
        return this->CFG;
    }

    void ReachabilityAnalysis::printWarning(SCAM::Stmt *IfStmt, bool cannotBe) {
        std::string trueOrFalse = cannotBe ? "true!" : "false!";
        std::stringstream message;
        message << "The statement: '"
                  << SCAM::PrintStmt::toString(IfStmt)
                  << "' cannot be " << trueOrFalse;
        auto msg = message.str();
        auto locationInfo = IfStmt->getStmtInfo();
        auto sl = SCAM::LoggerMsg::SeverityLevel::Warning;
        auto vt = SCAM::LoggerMsg::ViolationType::NA;
        auto pl = SCAM::Logger::getCurrentProcessedLocation();
        SCAM::LoggerMsg lmsg(msg, locationInfo,sl,vt,pl);
        SCAM::Logger::addMsg(lmsg);
    }

    //ReachabilityAnalysis for functions
    ReachabilityAnalysis::ReachabilityAnalysis(
            std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList,
            std::map<std::string, std::set<SCAM::Expr *>> allVarValuesMap,
            std::set<std::string> variablesThatHaveReadSet) : returnValueConditionList(std::move(
            returnValueConditionList)), z3Expr(RA_z3Context), RA_hasRead(false), variablesThatHaveReadSet(std::move(
            variablesThatHaveReadSet)), allVarValuesMap(std::move(allVarValuesMap)),whileNodeID(0), currentNodeID(0)  {
        if (this->returnValueConditionList.begin().base()->second.empty()) { return; }
        for (auto & returnPairItr : this->returnValueConditionList) {
            for (auto condExpr: returnPairItr.second) {
                if (condExpr) {
                    if (condExpr->getDataType() == DataTypes::getDataType("bool")) {
#ifdef DEBUG_REACHABILITY_ANALYSIS_FUNCTIONS
//                std::cout << "Checking condExpr: " << SCAM::PrintStmt::toString(condExpr)
//                          << std::endl;
#endif
                        RA_solver_t.reset();
                        this->substitutionMap.clear();

                        SCAM::FindVariablesAndFunctionsInStatement findVariablesAndFunctionsInStatement(condExpr,std::set<std::string>{});
                        if (findVariablesAndFunctionsInStatement.hasFunctions()) { continue; }
                        for (const auto& varOp : findVariablesAndFunctionsInStatement.getVarOpInStmtSet()) {
                            auto varName = varOp->getVariable()->getFullName();
                            if (this->variablesThatHaveReadSet.find(varName) ==
                                this->variablesThatHaveReadSet.end()) {
                                this->substitutionMap.insert(std::make_pair(varName,varOp));
                            } else if (this->variablesThatHaveReadSet.find(varName) !=
                                       this->variablesThatHaveReadSet.end()) {
                                RA_hasRead = true;
                            }
                        }

                        if (RA_hasRead) {
                            RA_hasRead = false;
#ifdef DEBUG_REACHABILITY_ANALYSIS_FUNCTIONS
                            std::cout
                                    << "Expression inside if has a read or one of the variables inside the expression has a read"
                                    << std::endl;
#endif
                            continue;
                        }
                        if (!this->substitutionMap.empty()) {
                            auto newSet = substituteVariablesInsideIfExpressionWithTheirValues(
                                    condExpr);
                            std::vector<z3::expr> toBeAssertedExpressions;
                            for(auto scamExpr : newSet){
                                z3::expr newZ3Expr(RA_z3Context);
                                try {
                                    newZ3Expr = RA_translator.translate(scamExpr);
                                    toBeAssertedExpressions.push_back(newZ3Expr);
                                }
                                catch (z3::exception &e) {
                                    toBeAssertedExpressions.clear();
                                    break;
                                }
                                catch (std::runtime_error &e) {
                                    toBeAssertedExpressions.clear();
                                    break;
                                }
                            }

#ifdef DEBUG_REACHABILITY_ANALYSIS_FUNCTIONS
//                            for (auto exp : toBeAssertedExpressions) {
//                                std::cout << "exp is: " << exp << std::endl;
//
//                            }
#endif
                            if (!toBeAssertedExpressions.empty()) {
                                bool nottrue = true;
                                for (const auto& expr : toBeAssertedExpressions) {
                                    RA_solver_t.reset();
                                    RA_solver_t.add(expr);
                                    if (RA_solver_t.check() == z3::sat || RA_solver_t.check() == z3::unknown) {
                                        nottrue = false;
                                        break;
                                    }
                                }
                                if (nottrue) {
#ifdef DEBUG_REACHABILITY_ANALYSIS_FUNCTIONS
                                std::cout << "Statment " << SCAM::PrintStmt::toString(condExpr)
                                          << " cannot be true"
                                          << std::endl;
#endif
                                    this->toBeDeletedPair.insert(returnPairItr);
                                }
                            }
                        } else {
                            RA_solver_t.add(RA_translator.translate(condExpr));
                            if (RA_solver_t.check() == z3::sat || RA_solver_t.check() == z3::unknown) {
                            } else {
#ifdef DEBUG_REACHABILITY_ANALYSIS_FUNCTIONS
                            std::cout << "Statment " << SCAM::PrintStmt::toString(condExpr)
                                      << " cannot be true"
                                      << std::endl;
#endif
                                this->toBeDeletedPair.insert(returnPairItr);

                            }
                        }

                    }
                }
            }
        }
        for (const auto& pair : this->toBeDeletedPair) {
#ifdef DEBUG_REACHABILITY_ANALYSIS_FUNCTIONS
        std::cout << "return value " << PrintStmt::toString(pair.first->getReturnValue())
                  << " and its statement vector has been deleted "
                  << std::endl;
#endif
            this->returnValueConditionList.erase(
                    std::remove(this->returnValueConditionList.begin(), this->returnValueConditionList.end(), pair), this->returnValueConditionList.end());
        }

    }

    std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>>
    ReachabilityAnalysis::getReturnValueConditionList() const {
        return this->returnValueConditionList;
    }

}
