//
// Created by M.I.Alkoudsi on 22.08.19.
//

#ifndef SCAM_FINDREADVARIABLES_H
#define SCAM_FINDREADVARIABLES_H

#include <Stmts/StmtAbstractVisitor.h>
#include <Stmts/Stmts_all.h>
#include "Behavior/CfgNode.h"
#include <set>

namespace SCAM {
/***
   * @brief: Finds variables assigned by read and write(statusOperand) statements
   * @author:M.I.Alkoudsi
   */
    class FindReadVariables {
    public:
        FindReadVariables() = delete;

        explicit FindReadVariables(const std::map<int, CfgNode *> &CFG);

        ~FindReadVariables() = default;

        const std::set<std::string> &getReadVariablesSet() const;

    private:
        std::map<int, CfgNode *> CFG;
        std::set<std::string> readVariablesSet;                  //All variables that can't be optimized due to interprocedural behaviour
    };

}

#endif //SCAM_FINDREADVARIABLES_H
