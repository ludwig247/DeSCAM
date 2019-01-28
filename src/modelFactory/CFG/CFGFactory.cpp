//
// Created by tobias on 25.11.15.
//

#include <clang/Lex/Lexer.h>
#include <ErrorMsg.h>

#include "CFGFactory.h"
#include "FindDataFlow.h"


namespace SCAM {
    //TODO: isWait call must depenend on the used interface 
    CFGFactory::CFGFactory(clang::CXXMethodDecl *decl, clang::CompilerInstance &ci, Module *module) :
            methodDecl(decl),
            ci(ci),
            module(module){

        //Create Control flow graph(CFG)
        clang::CFG::BuildOptions b = clang::CFG::BuildOptions();
        clangCFG = clang::CFG::buildCFG(llvm::cast<clang::Decl>(methodDecl), methodDecl->getBody(), &ci.getASTContext(), b);
        if (clangCFG == NULL) {
            llvm::errs() << "-E- CFGFactory::translateToScamCFG():  clangCFG is null";
            return;
        }
//        clang::LangOptions lo;
//        clangCFG->dump(lo, false);

        //Generate new CFG
        this->translateToScamCFG();

    }

    CFGFactory::~CFGFactory() {
    }

/*
 * \brief Generates an simple CFG for a given clang::CFG
 *
 * 1)Find entry point in CFG(block w/o predecessors)
 * 2)Traverse every sucessor of current block
 */
    void CFGFactory::translateToScamCFG() {

//        clang::LangOptions LO;
//        LO.CPlusPlus = true;
//        clangCFG->dump(LO, false);
        clang::CFGBlock *entryCFGBlock = &clangCFG->getEntry();
        //Translate entry node of block
        CFGNode *entryNode = this->createCFGNode(entryCFGBlock, nullptr);

        //Walk over each statement of the CFGBlock
        this->traverseBlocks(*entryCFGBlock->succ_begin(), entryNode);
        //Clean up
        this->cleanEmptyBlocks();

    }


//! Iterates over each statement of a block and create SCAM::Stmts*
    CFGNode *CFGFactory::createCFGNode(clang::CFGBlock *block, SCAM::CFGNode *parent) {
        if (entryMap.find(block->getBlockID()) != entryMap.end()) {
            int scamBlockId = entryMap.find(block->getBlockID())->second;
            for (auto succ : parent->getSuccessorList()) {
                if (succ->getBlockID() == scamBlockId) {
                    return this->controlFlowMap.at(entryMap.find(block->getBlockID())->second);
                }
            }
            parent->addSuccessor(this->controlFlowMap.at(scamBlockId));
            return this->controlFlowMap.at(entryMap.find(block->getBlockID())->second);
        }
        //Get clean statementlist -> remove all nested statements
        std::vector<clang::Stmt *> statementList = this->getCleanStmtList(block);

        //Create empty cfgNode
        CFGNode *cfgNode = new CFGNode(-1, block->getBlockID());
        //Translate CLANG::Stms to SCAM:Stmts and add to node
        for (auto clangStmt: statementList) {
            SCAM::Stmt *scamStmt = this->getScamStmt(clangStmt);
            if (scamStmt != nullptr) {
                cfgNode->addStmt(this->getScamStmt(clangStmt));
            }
        }

        //Set terminator for codelbock
        //Check if Terminator is a branch or just a nested  boolean statement
        ////If CFGBlock has a terminator -> assign to last node in nodeList
        if (block->getTerminator().getStmt() != nullptr) {
            if (block->getTerminator()->getStmtClass() == clang::Stmt::StmtClass::IfStmtClass ||
                block->getTerminator()->getStmtClass() == clang::Stmt::StmtClass::WhileStmtClass) {
                //Translate clang::Stmts to SCAM::Stmts
                SCAM::Stmt *terminator = this->getScamStmt(block->getTerminator().getStmt());
                if (terminator != nullptr) {
                    cfgNode->setTerminator(terminator);
                } else {
                    clang::LangOptions LO;
                    LO.CPlusPlus = true;
                    block->dump(clangCFG, LO, false);
                    block->getTerminator().getStmt()->dump();
                    throw std::runtime_error("Can't translate terminator");
                }
            }
        }

        //Assign unique ID for each node

        int blockID = this->controlFlowMap.size();
        cfgNode->setBlockID(blockID);
        //
        //Initial case: do not add parent ->
        if (parent != nullptr) parent->addSuccessor(cfgNode);

        //Defines a pair <CFGBlockID,SuspensionCFBlockID> connectig a cfgBlock to a supensionBlock. Neededv in case cfgBlock is split
        this->entryMap.insert(std::make_pair(block->getBlockID(), cfgNode->getBlockID()));
        this->controlFlowMap.insert(std::make_pair(blockID, cfgNode));

        return cfgNode;
    }

    void CFGFactory::traverseBlocks(clang::CFGBlock *block, CFGNode *parent) {
        assert(block->succ_size() <= 2);
        assert(block != nullptr);

        //Terminalcase: Block already visited over this path
        if (entryMap.find(block->getBlockID()) != entryMap.end()) {
            for (auto succ: parent->getSuccessorList()) {
                if (entryMap.find(block->getBlockID())->second == succ->getBlockID()) {
                    return;
                }
            }
        }
        //Terminal case: no successor
        if (block->succ_size() == 0) return;
        //Case: Regular block -> no terminator
        if (block->succ_size() == 1) {
            //Block not visited iterate statements and add suspensionNodes to graph
            CFGNode *cfgNode = this->createCFGNode(block, parent);
            //First node in List is succesor of parent
            //Visit successorBlock -> no terminal exactly 1 successor
            clang::CFGBlock *successorBlock = *block->succ_begin();
            this->traverseBlocks(*block->succ_begin(), cfgNode);

        }
        //Case: two succesors:
        //1: while(trueSucc, null)
        //2: block.terminator is not an if -> multiple conditions in an IF
        //3. block.terminator is an if
        // Complexity is coming from the way LLVM represent the CFG. An IF(a&&b&&c) is represented with two blocks.
        // The first block will have a terminator with only a&&b and the true succesor of that block
        // is if(a&&b&&c) the false sucessors of that block points to whatever is after the if.
        // This requires finding of the if in the tree.
        if (block->succ_size() == 2) {
            auto succ_it_true = block->succ_begin();
            auto succ_it_false = block->succ_begin();
            succ_it_false++;
            //Case 1: While stmt for initial loop
            if (block->getTerminator().getStmt()->getStmtClass() == clang::Stmt::WhileStmtClass) {
                if (*succ_it_true != nullptr && *succ_it_false == nullptr) {
                    CFGNode *cfgNode = this->createCFGNode(block, parent);
                    traverseBlocks(*succ_it_true, cfgNode);
                } else throw std::runtime_error("Only 1 while(true) for thread-loop allowed! No other while stmts");

            }
                //Case 2: Branching with complex if: e.g. (a&&b) -> terminator that is not an ifStmtClass
                //Is dealt with two blocks, only visit successor that contains the if
            else if (block->getTerminator().getStmt()->getStmtClass() != clang::Stmt::IfStmtClass) {
                //True successor of block:
                if (*succ_it_true != nullptr && *succ_it_false != nullptr) {
                    clang::CFGBlock *trueSucc = *succ_it_true;
                    clang::CFGBlock *falseSucc = *succ_it_false;
                    CFGNode *cfgNode = this->createCFGNode(block, parent);
                    //If both successors are not null, search for the sucessor containing the hole "if" ignore others
                    if (trueSucc->getTerminator().getStmt() != nullptr && falseSucc->getTerminator().getStmt() != nullptr) {
                        clang::Stmt *trueStmt = trueSucc->getTerminator().getStmt();
                        clang::Stmt *falseStmt = falseSucc->getTerminator().getStmt();
                        if (trueStmt->getStmtClass() != clang::Stmt::IfStmtClass && falseStmt->getStmtClass() != clang::Stmt::IfStmtClass) {
                            traverseBlocks(trueSucc, cfgNode);
                        } else if (trueStmt->getStmtClass() == clang::Stmt::IfStmtClass &&
                                   falseStmt->getStmtClass() != clang::Stmt::IfStmtClass) {
                            if (this->exprContainedInIf(block, trueSucc)) traverseBlocks(trueSucc, cfgNode);
                            else traverseBlocks(falseSucc, cfgNode);
                        } else if (trueStmt->getStmtClass() != clang::Stmt::IfStmtClass &&
                                   falseStmt->getStmtClass() == clang::Stmt::IfStmtClass) {
                            if (this->exprContainedInIf(block, falseSucc)) traverseBlocks(falseSucc, cfgNode);
                            else traverseBlocks(trueSucc, cfgNode);
                        } else if (trueStmt->getStmtClass() == clang::Stmt::IfStmtClass &&
                                   falseStmt->getStmtClass() == clang::Stmt::IfStmtClass) {
                            if (this->exprContainedInIf(block, trueSucc)) traverseBlocks(trueSucc, cfgNode);
                            else traverseBlocks(falseSucc, cfgNode);
                        } else throw std::runtime_error("Missed case here");
                    }
                        // If one of the succesors is null visit the otherone
                    else if (trueSucc->getTerminator().getStmt() != nullptr && falseSucc->getTerminator().getStmt() == nullptr) {
                        traverseBlocks(trueSucc, cfgNode);
                    } else if (trueSucc->getTerminator().getStmt() == nullptr && falseSucc->getTerminator().getStmt() != nullptr) {
                        traverseBlocks(falseSucc, cfgNode);
                        //Both succeors have no terminators:
                    } else {
                        std::cout << "-W- Please check AML for correct translation" << std::endl; //TODO: is this acutally valid?
                        traverseBlocks(trueSucc, cfgNode);
                        //throw std::runtime_error(std::to_string(block->getBlockID()) + ": true & fals succesors have no terminator");
                    }

                } else throw std::runtime_error("Succ true or false == null");
            }
                //Case 3: Regular block with terminator if: e.g. (a&&b) -> terminator that is not an ifStmtClass
                //Is dealt with two blocks, only visit successor that contains the if
            else {
                CFGNode *cfgNode = this->createCFGNode(block, parent);
                if (*succ_it_true != nullptr) {
                    traverseBlocks(*succ_it_true, cfgNode);
                }
                if (*succ_it_false != nullptr) {
                    traverseBlocks(*succ_it_false, cfgNode);
                }

            }
        }
    }


    /*!
     * \brief Returns a list without nested stmts
     *
     * * Clean statements from statementlist that are nested in other statements[-> HACKY]
        * Compare SourceLocation of current Stmt with next Stmt in list -> if overlap: delete
        * E.g.:
        * this->set_port[delete]
        * this->set_port->read()[delte]
        * this->reset = this->set_port->read()[keep]
     */
    std::vector<clang::Stmt *> CFGFactory::getCleanStmtList(clang::CFGBlock *block) {
        //Get orignal statement list from block
        std::vector<clang::Stmt *> stmtList;
        for (clang::CFGBlock::const_iterator bit = block->begin(), bite = block->end(); bit != bite; bit++) {
            if (clang::Optional<clang::CFGStmt> cs = bit->getAs<clang::CFGStmt>()) {
                clang::CFGStmt *s = const_cast<clang::CFGStmt *>((clang::CFGStmt const *) &cs);
                clang::Stmt *stmt = const_cast<clang::Stmt *>(s->getStmt());
                stmtList.push_back(stmt);

            }
        }
        //Only add stmts that are not nested to new list
        std::vector<clang::Stmt *> newStatementList;
        for (int i = 0; i < stmtList.size(); i++) {
            clang::Stmt *stmt = stmtList.at(i);
            //Out of bounds?
            if (i < stmtList.size() - 1) {
                clang::Stmt *stmtNext = stmtList.at(i + 1);
                if (stmt->getLocStart().getRawEncoding() == stmt->getLocEnd().getRawEncoding()) {
                    continue;
                }
                if (stmt->getLocStart().getRawEncoding() >= stmtNext->getLocStart().getRawEncoding()) {
                    continue;
                }
            }
            //IF: Terminator in block: Check last element of statementlist -> might belong to terminator
            if (i == stmtList.size() - 1) {
                if (block->getTerminator().getStmt() != nullptr) {
                    if (stmt->getLocStart().getRawEncoding() >= block->getTerminator().getStmt()->getLocStart().getRawEncoding()) {
                        continue;
                    }
                }
            }
            //Incase statement is not a netsted statement add to statementlist
            newStatementList.push_back(stmt);

        }
        return newStatementList;
    };

    //! Methods that translates a Clang::Stmt into a SCAM::Stmt
    SCAM::Stmt *CFGFactory::getScamStmt(clang::Stmt *clangStmt) {
        SCAM::FindDataFlow dataFlow(clangStmt, module, false);
        //Is stmt properly initialized?
        if (dataFlow.getStmt() == nullptr) {
            //Get the source code as string
            std::string msg = clang::Lexer::getSourceText(clang::CharSourceRange::getTokenRange(clangStmt->getSourceRange()),
                                                          ci.getSourceManager(), ci.getLangOpts()).str();
            //Get the ast for the stms as string
            std::string msgAST;
            llvm::raw_string_ostream ss(msgAST);
            clangStmt->dump(ss, ci.getSourceManager());
            //Add error to singleton
            ErrorMsg::addError(msg, msgAST);
            //assert(false);
        }
        return dataFlow.getStmt();

    }

/*!
 * \brief Iterate over each block, if stmts-list && termintor is emtpy -> remove block  and adjust succ&preds
 *
 * This happens in case of a if(a&&b) or if(a||b) which is a block with an terminator that contains a as terminator but no if
 * That creates a block with no stmts, no terminator and 2 successors, which needs to be deleted

    */
    void CFGFactory::cleanEmptyBlocks() {
        for (auto it = this->controlFlowMap.cbegin(); it != this->controlFlowMap.cend();) {
            auto currentBlock = (*it).second;
            bool terminator = currentBlock->hasTerminator();
            bool stmts = currentBlock->getStmtList().empty();
            //Check for successor size, if there are more than one successor and no condition -> remove
            bool succ_size = currentBlock->getSuccessorList().size() > 1;
            if (!terminator && stmts && succ_size) {
                SCAM::CFGNode *succ; //! depending whether it
                //Check whether current block belongs to an AND or an OR
                //AND
                if (currentBlock->getSuccessorList().at(0) != currentBlock->getSuccessorList().at(1)->getSuccessorList().at(0)) {
                    succ = currentBlock->getSuccessorList()[0];
                }
                    //OR
                else if (currentBlock->getSuccessorList().at(0) == currentBlock->getSuccessorList().at(1)->getSuccessorList().at(0)) {
                    succ = currentBlock->getSuccessorList()[1];
                } else {
                    std::cout << currentBlock->print() << std::endl;
                    throw std::runtime_error("Empty block with 2 successors, that can't be deleted");
                }
                //Replace currentBlock as succesor in predecessors with new successor
                for (auto pred: currentBlock->getPredecessorList()) {
                    pred->replaceSuccessor(currentBlock, succ);
                }
                //Follow succ[1] of current block and remove from predecessor_list of succ[1]
                currentBlock->getSuccessorList()[1]->removePredecessor(currentBlock);
                //Follow succ[0] of current block and remove from predecessor_list of succ[0]
                currentBlock->getSuccessorList()[0]->removePredecessor(currentBlock);

                //Follow succ[0] and add all predecessors of currentBlock as predecessors of succ_0
                for (auto pred: currentBlock->getPredecessorList()) {
                    succ->addPredecessor(pred);
                }

                // All connections to currentBlock redirected -> remove from susCFG
                this->controlFlowMap.erase(it++);

            } else ++it;

        }


    }

    const std::map<int, CFGNode *> &CFGFactory::getControlFlowMap() const {
        return controlFlowMap;
    }

    std::string CFGFactory::print() {

        std::stringstream ss;
        for (auto node: this->controlFlowMap) {
            CFGNode *sus = node.second;

            ss << "[ID" << node.first << "] [B" << sus->getClangBlockID() << "]" << "\n";
            ss << "\tStmntList: " << sus->getStmtList().size() << "\n";


            for (auto stmt: sus->getStmtList()) {
                ss << "\t\t" << PrintStmt::toString(stmt) << "\n";
            }

            if (sus->hasTerminator()) {
                ss << "\t";
                ss << "Terminator: ";
                ss << PrintStmt::toString(node.second->getTerminator()) << "\n";
            }

            ss << "\t\tPred: ";
            for (auto pred: sus->getPredecessorList()) {
                ss << "[ID" << pred->getBlockID() << "], ";
            }
            ss << "\n";;
            ss << "\t\tSucc: ";
            for (auto succ: sus->getSuccessorList()) {
                ss << "[ID" << succ->getBlockID() << "], ";
            }
            ss << "\n";
        }
        return ss.str();
    }

    //!Start and End of the inner statemtns must lie within the start end of the outer statements
    bool CFGFactory::exprContainedInIf(clang::CFGBlock *inner, clang::CFGBlock *outer) {

        assert(inner != nullptr);
        assert(outer != nullptr);
        assert(inner->getTerminator().getStmt() != nullptr);
        assert(outer->getTerminator().getStmt() != nullptr);
        auto innerSourceRange = inner->getTerminatorCondition()->getSourceRange();
        auto outerSourceRange = outer->getTerminatorCondition()->getSourceRange();

        if (innerSourceRange.getBegin().getRawEncoding() >= outerSourceRange.getBegin().getRawEncoding() &&
            innerSourceRange.getEnd().getRawEncoding() <= outerSourceRange.getEnd().getRawEncoding()) {
            return true;
        }
        return false;

    }

}