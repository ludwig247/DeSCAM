//
// Created by M.I.Alkoudsi on 5/20/19.
//

#ifndef SCAM_CFGPATH_H
#define SCAM_CFGPATH_H

#include <vector>
#include "Behavior/CfgNode.h"
#include <sstream>

namespace SCAM {
    /***
     * @brief: represents a path of connected CfgNode nodes
     * @author:M.I.Alkoudsi
     *
     */


    class CfgPath {
    public:
        //Constructors and Destructors
        CfgPath();

        CfgPath(const CfgPath &Path, int &ID);

        ~CfgPath() = default;

        //Setters and Getters
        const std::vector<CfgNode *> &getPath() const;

        const int &getPathID() const;

        //Functions to add a node to a path
        void insertatend(CfgNode *node);

        //Function to remove the last node from a path
        void deleteNodeBackward();

        //Function to make a path from the current one up to a specific node
        std::vector<CfgNode *> makePathToNode(int NodeId);

        //Function to print a path
        std::string print();

    private:
        const int PathID;
        std::vector<CfgNode *> path;
    };


}

#endif //SCAM_CFGPATH_H