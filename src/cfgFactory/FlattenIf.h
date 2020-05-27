//
// Created by ludwig on 21.01.16.
//

#ifndef SCAM_ELSEVISITOR_H
#define SCAM_ELSEVISITOR_H

#include "CfgBlock.h"
#include <iostream>
#include <map>
#include <ITE.h>
#include <set>


namespace DESCAM {

/**
 * \brief Creates a new ITE-object
 *
 * The CFG generated by clang consists of blocks
 * If the code contains a IF. Everything before the IF is included in the stmtlist of the block.
 * The block furthermore contains a terminator. A terminator consists of the type(if,while,for ...) and the condition.
 * In our case we focus on IF only. In presens of an IF a block has two successor blocks.
 * The true successor is the first block of the true-block of the code, the false successors for the else-block.
 * In order to determine what is contained within the true block and what is contained within the else-block,
 * we need to find the block that merges the true and else path.
 * This block contains the statements that are executed after the if-then-else.
 *
 * E.g.: In order to know that Block_1 and Block_2 are the paths we need to find Block_3 which is the endNode of the branch started by Block_0
 *
 * int before = someFunctionThatReturnsAnInteger();
 * int after = 0;
 * int ifBlock = 0;
 * int elseBlock = 0;
 * before++;
 * if(before == 20){
 *      ifBlock++;
 * }else{
 *      elseBlock++;
 * }
 * after++;
 *
 * Block_0:
 * Stmts:
 *      int before = someFunctionThatReturnsAnInteger();
 *      int after = 0;
 *      int ifBlock = 0;
 *      int elseBlock = 0;
 *      before++;
 * Terminator:
 *      if(before == 20)
 * Predecessor: None[START]
 * Successor:
 *      Block_1,Block_2
 *
 * Block_1:
 * Stmts:
 *      ifBlock++
 * Terminator: none
 * Predecessor: Block_0
 * Successor:
 *      Block_3
 *
 * Block_2:
 * Stmts:
 *      elseBlock++
 * Terminator: none
 * Predecessor: Block_0
 * Successor:
 *      Block_3
 *
 * Block_3:
 * Stmts:
 *      after++
 * Terminator: none
 * Predecessor: Block_1,Block_2
 * Successor: none[EXIT]
 *
 *
 *
 */
    class FlattenIf {

    public:
        FlattenIf(DESCAM::CfgBlock *startNode, DESCAM::CfgBlock *endNode, std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> &startEndMap,
                  std::map<DESCAM::CfgBlock *, std::set<int>> &pathNodeMap);

        DESCAM::ITE *getITE();

        void core(DESCAM::CfgBlock *node);

    private:
        DESCAM::CfgBlock *startNode;
        DESCAM::CfgBlock *endNode;
        DESCAM::ITE *ite; //! if-then-else as single DESCAM::stmt
        int pass; //! True path: pass == 0 , Else path pass == 1
        std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> &startEndMap; //! Map containg the exit node for each ite block
        std::map<DESCAM::CfgBlock *, std::set<int>> &pathNodeMap; //! Map containg an entry for each node between start and end

    };

}

#endif //SCAM_ELSEVISITOR_H
