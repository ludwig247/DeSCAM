//
// Created by ludwig on 01.08.16.
//


#include <set>
#include "CleanUpPaths.h"


SCAM::CleanUpPaths::CleanUpPaths() {

}

/** \brief Remove all duplicated paths
 *
 *   During construction of the paths it is possible that paths are created multiple times
 *   If all parameters of the paths are equal. In this case remove all execpt one from the sectionPathMap
 */

const SCAM::SectionPathMap SCAM::CleanUpPaths::deleteDuplicatedPaths(const SCAM::SectionPathMap &sectionPathMap) {

    SectionPathMap newSectionPathMap;
    int cnt = 0;

    for (auto &&section : sectionPathMap) {
        std::set<Path *> keepPath;
        std::set<Path *> removePath;
        for (auto path1 : section.second) {
            if (removePath.find(path1) != removePath.end()) continue;
            for (auto path2 : section.second) {
                if (removePath.find(path2) != removePath.end()) continue;
                if (keepPath.find(path2) != keepPath.end()) continue;
                if (path1->getPathId() == path2->getPathId()) continue;

                bool isEqual = true;
                // State transitions are the same?
                bool states = path1->getSection() == path2->getSection();
                bool substates = path1->getSubState() == path2->getSubState();
                bool nextStates = path1->getNextSection() == path2->getNextSection();
                bool nextSub = path1->getSubNext() == path2->getSubNext();

                if (!(states && substates && nextStates && nextSub)) isEqual = false;
                if ((path1->getStmtList().size() != path2->getStmtList().size()) && isEqual) isEqual = false;
                // Stmts equal
                for (int k = 0; k < path1->getStmtList().size() && isEqual; k++) {
                    //Compare pointers
                    if (path1->getStmtList().at(k) != path2->getStmtList().at(k)) {
                        //In case pointers are not equal compare objects:
                        isEqual = *path1->getStmtList().at(k) == *path2->getStmtList().at(k);
                        if(isEqual && path1->getStmtList().at(k) == path2->getStmtList().at(k)) throw std::runtime_error(" test ");
                        //isEqual = path1->getStmtList().at(k) == path2->getStmtList().at(k);
                    }
                }
                // Erase the element if they are equal
                if (isEqual) {

                    removePath.insert(path2);
                    keepPath.insert(path1);
                    cnt++;
                }

            }
        }
        std::vector<Path *> newPathList;
        for (auto path : section.second) {
            if (removePath.find(path) == removePath.end()) {
                newPathList.push_back(path);
            } else delete path;
        }
        newSectionPathMap.insert(std::make_pair(section.first, newPathList));
    }


    std::cout << "Deleted " << cnt << " duplicated paths" << std::endl;
    return newSectionPathMap;
}


/**
 * \brief Detect unreachable paths by using a SMT solver
 *
 * Creates a boolean formula as a conjunction of all conditions use SMT to prove satisfiability
 * If unsat, remove path from list
 *
 *
 */

const SCAM::SectionPathMap SCAM::CleanUpPaths::deleteUnreachablePaths(const SCAM::SectionPathMap &sectionPathMap) {

    SectionPathMap newSectionPathMap;
    int cnt = 0;
    //Each path with unsatisfiable conditions can be removed, since it can never be reached
    for (auto section: sectionPathMap) {
        //Reference of the pathList of the section
        std::vector<Path *> newPathList;
        std::set<Path *> removePathSet;
        for (auto path: section.second) {
            if (isPathUnreachable(path)) {
                removePathSet.insert(path);
            } else newPathList.push_back(path);
        }
        //Create new sectionPathMap
        newSectionPathMap.insert(std::make_pair(section.first, newPathList));
        //Delete old paths
        for (auto path: removePathSet) {
            cnt++;
            delete path;
        }
    }

    std::cout << "Deleted " << cnt << " unreachable paths" << std::endl;
    return newSectionPathMap;

}

const bool SCAM::CleanUpPaths::isPathUnreachable( SCAM::Path *  p) {
    z3::context  context;
    z3::solver solver(context);
    ExprTranslator translator(&context);
    //Translate each expression with the ExprtTranslator and add to solver
    for (auto condition: p->getConditionList()) {
        solver.add(translator.translate(condition));
    }
    //
    for (auto condition: p->getCommunicationConditionList()) {
        solver.add(translator.translate(condition));
    }
    //Delete context
    // Check for SAT if unsat -> erase path
    if (solver.check() == z3::unsat) {
        //std::cout << solver << std::endl;
        return true;
    }
    return false;
}


