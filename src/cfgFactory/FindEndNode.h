//
// Created by tobias on 18.02.16.
//

#ifndef SCAM_IFBRANCHMERGE_H
#define SCAM_IFBRANCHMERGE_H

#include "CfgBlock.h"
#include <While.h>
#include "EnumartePathsVisitor.h"
#include <map>

namespace DESCAM {
    /*!
     * \brief Class finds the endNode of the if-block
     *
     * The endNode is the node, where the true and false path of the if point to.
     * it's not part of the ite block
     *
     * 1:if(x<2){
     * 2: x++
     * 3: }else{
     * 4: x--;
     * 5: }
     * 6: j++;
     *
     * (1) is the startNode true path: 1-2-6 false path 1-4-6
     * (6) is the endNode
     */
    class FindEndNode {
    public:
        FindEndNode(DESCAM::CfgBlock *startNode);


        DESCAM::CfgBlock *getEndNode();

        void recursion(DESCAM::CfgBlock *node); //! Finds the endNode for a while.

    private:
        DESCAM::CfgBlock *startNode; //! startNode of the if block
        DESCAM::CfgBlock *endNode; //! Merge nod eof the true and false path
        std::set<int> pathNodes; //! Set of all nodes among the path
    };

}

#endif //SCAM_IFBRANCHMERGE_H
