//
// Created by ludwig on 01.08.16.
//

#ifndef SCAM_MERGEPATHS_H
#define SCAM_MERGEPATHS_H

#include "Path.h"
#include "ExprTranslator.h"
#include "z3++.h"
#include <PrintStmt.h>

namespace SCAM {
    /**
     * \brief Contains methods for removing paths
     */
    typedef  std::map<std::string, std::vector<SCAM::Path *>> SectionPathMap;
    class CleanUpPaths {
    public:
        CleanUpPaths();
        static const SectionPathMap deleteDuplicatedPaths(const SCAM::SectionPathMap& sectionPathMap);
        static const SectionPathMap deleteUnreachablePaths(const SectionPathMap& sectionPathMap) ;
        static const bool isPathUnreachable(Path * p);

    };


}

#endif //SCAM_MERGEPATHS_H
