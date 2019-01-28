//
// Created by tobias on 25.01.17.
//

#include <assert.h>
#include "CommToCommNew.h"
#include "ValuePropagation.h"
#include "CleanUpPaths.h"

const std::map<std::string, std::vector<SCAM::Path *>> &SCAM::CommToCommNew::getNewSectionPathMap() const {

    return newSectionPathMap;
}

SCAM::CommToCommNew::CommToCommNew(const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap, SCAM::Module *module) :
        recursionCnt(0),
        module(module),
        sectionPathMap(sectionPathMap) {
    assert(module !=nullptr);
    //Set up the new SectionPathMap
    for (auto section: sectionPathMap) {
        this->newSectionPathMap.insert(std::make_pair(section.first, std::vector<SCAM::Path *>()));
    }
    //Find path from reset to first communication
    Path *pathToFirstCommunication = this->findInitialPath();

    //Find each successor of the first communication after reset
    //Call the recursion for each of those
    for (auto path: sectionPathMap.at(pathToFirstCommunication->getNextSection())) {
        if (path->getSubState() == pathToFirstCommunication->getSubNext()) {
            std::set<SCAM::Path*> visitedPaths;
            visitedPaths.insert({path});
            recursion(path, visitedPaths);
        }
    }
    //Add all paths from the newPathSet to the sectionPathMap
    for (auto &path: this->newPathSet) {
        this->newSectionPathMap.at(path.getSection()).push_back(new Path(path));
    }

}

void SCAM::CommToCommNew::recursion(SCAM::Path *path,std::set<SCAM::Path *>& visitedPaths) {
    //For the recursion to work it is required, that each path starts with a communicaton
    if (!isCommToSection(*path) && !isCommToComm(*path)) throw std::runtime_error("Path has to start wit a communication!");
    //Interfaces to communication
    // Comm_start -> Comm_End("Terminal case")
    if (this->isCommToComm(*path)) {
        //Fix-point reached? set.insert.second will return false in that case
        if (!this->newPathSet.insert(*path).second) {
            return;
        }
        // Find each edge leavin Comm_End to either a section or a communication
        for (auto pathNext:  sectionPathMap.at(path->getNextSection())) {
            if (pathNext->getSubState() == path->getSubNext()) {
                //Call recursion on Comm_End -> "section or communication"s
                if (visitedPaths.insert(pathNext).second) {
                    recursion(pathNext, visitedPaths);
                } else continue;
            }
        }
        //Interfaces to section:
        //Now we are interested in all path starting from this section
        //For each such path pathNext we extend path to the end of pathNext
        // e.g. path: A_1 -> B interesting next paths: B->B_2(Case 1), B->C(Case 2)
        //Case 1: Section Start -> Interfaces
        //Case 2: Section Start to NextSectionStart
    } else if (this->isCommToSection(*path)) {
        for (auto pathNext: sectionPathMap.at(path->getNextSection())) {
            if (isSectionToComm(*pathNext) || isSectionToSection(*pathNext)) {
                //Check for loop without communication
                if(isSectionToSection(*pathNext) && pathNext->getSection() == pathNext->getNextSection()){
                    throw std::runtime_error("Infinite loop without communication, can't translate this FSM into a complete set of proprties");
                }
                //Extend path stmtList by pathNext stmtList
                std::vector<SCAM::Stmt *> stmtList = path->getStmtList();
                stmtList.insert(stmtList.end(), pathNext->getStmtList().begin(), pathNext->getStmtList().end());
                SCAM::Path *extendedPath = new Path(*path, stmtList);
                //NextState is the nextstate of pathNext
                extendedPath->setNextSection(pathNext->getNextSection());
                extendedPath->setSubNext(pathNext->getSubNext());

                //Call recursion with updated visitedNodes set
                recursion(extendedPath, visitedPaths);
            }
        }
    }

}

bool SCAM::CommToCommNew::isCommToComm(SCAM::Path p) {
    if (p.getSubState() != "" && p.getSubNext() != "") return true;
    return false;
}

bool SCAM::CommToCommNew::isCommToSection(SCAM::Path p) {
    if (p.getSubState() != "" && p.getSubNext() == "") return true;
    return false;
}

bool SCAM::CommToCommNew::isSectionToComm(SCAM::Path p) {
    if (p.getSubState() == "" && p.getSubNext() != "") return true;
    return false;
}

bool SCAM::CommToCommNew::isSectionToSection(SCAM::Path p) {
    if (p.getSubState() == "" && p.getSubNext() == "") return true;
    return false;
}


SCAM::Path * SCAM::CommToCommNew::findFirstComm(SCAM::Path *path, std::set<SCAM::Path *> visitedPaths) {
    if(isSectionToComm(*path)){
        return path;
    }else if(isSectionToSection(*path)){
        for (auto nextPath : sectionPathMap.at(path->getNextSection())) {
            if(!visitedPaths.insert(nextPath).second) throw std::runtime_error("LOOP from INIT possible");
            //Extend path stmtList by pathNext stmtList
            std::vector<SCAM::Stmt *> stmtList = path->getStmtList();
            stmtList.insert(stmtList.end(), nextPath->getStmtList().begin(), nextPath->getStmtList().end());
            SCAM::Path *extendedPath = new Path(*path, stmtList);
            //NextState is the nextstate of pathNext
            extendedPath->setNextSection(nextPath->getNextSection());
            extendedPath->setSubNext(nextPath->getSubNext());
            return findFirstComm(extendedPath,visitedPaths);
        }
    }else{
        return nullptr;
    }

}



/* Find the path leading to the first communication from all possible paths from reset */

SCAM::Path *SCAM::CommToCommNew::findInitialPath() {
    //Find Init
    auto initSection = sectionPathMap.at("init");
    if (initSection.size() != 1) throw std::runtime_error("InitSection is supposed to contain 1 path");

    auto initPath = initSection.at(0);

    //Path from Init will always point to a section
    //find possible communications after reset
    //By definition only one communication is possible(otherwise something was not set after reset)
    std::vector<Path *> pathsToFirstCommunication;
    //Path * pathToFirstCommunication;
    for (auto path : sectionPathMap.at(initPath->getNextSection())) {
        if(findFirstComm(path,{}) != nullptr){
            pathsToFirstCommunication.push_back(findFirstComm(path,{}));
        }
    }


    for (auto pathToFirstCommunication: pathsToFirstCommunication) {
        //Add the InitalPath to sectionPathMap -> it is not part of the newPathSet
        auto stmtList = initPath->getStmtList();
        stmtList.insert(stmtList.end(), pathToFirstCommunication->getStmtList().begin(), pathToFirstCommunication->getStmtList().end());
        Path *newInitPath = new Path(*initPath, stmtList);
        newInitPath->setNextSection(pathToFirstCommunication->getNextSection());
        newInitPath->setSubNext(pathToFirstCommunication->getSubNext());

        //Add all possible paths from init to first communication to section
        this->newSectionPathMap.at("init").push_back(newInitPath);
    }

    //Propagate values
    SCAM::ValuePropagation valuePropagation(this->newSectionPathMap, module);
    this->newSectionPathMap = valuePropagation.getNewSectionPathMap();
    //Delete unreachable Paths
    this->newSectionPathMap = SCAM::CleanUpPaths::deleteUnreachablePaths(this->newSectionPathMap);
    //
    if (this->newSectionPathMap.at("init").size() != 1){
        throw std::runtime_error(std::to_string(this->newSectionPathMap.at("init").size()) + " reachable path(s) from init");
    }
    return this->newSectionPathMap.at("init").at(0);
}


