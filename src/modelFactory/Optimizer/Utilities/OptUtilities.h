//
// Created by M.I.Alkoudsi on 1.11.19.
//


#ifndef SCAM_OPTUTILITIES_H
#define SCAM_OPTUTILITIES_H

#include "Behavior/CfgNode.h"
#include <CfgBlock.h>
#include "PrintStmt.h"
#include "z3++.h"
#include <map>


namespace SCAM {

    class OptUtilities {

    public:
        OptUtilities() = default;

        ~OptUtilities() = default;

        static std::string printCFG(const std::map<int, SCAM::CfgBlock *> &CFG);

        static std::string printCFG(const std::map<int, SCAM::CfgNode *> &CFG);

        static int findWhileNodeId(const std::map<int, SCAM::CfgNode *> &CFG);

        static bool isAbortTranslation(const z3::expr &expr);

        static int getRequiredBits(int value);

        static int getRequiredBits(unsigned int value);

    };
}

#endif //SCAM_OPTUTILITIES_H
