//
// Created by tobias on 25.01.17.
//

#ifndef PROJECT_COMMTOCOMMNEW_H
#define PROJECT_COMMTOCOMMNEW_H

#include <string>
#include <set>
#include "Path.h"

namespace SCAM {
/*!
    * \brief: Resolves paths such that each paths starts end ends with a communication
    *
    * Paths may start or end in a section border and not with the next communication.
    * This class adjusts the paths such that each of them starts end ends with a communicationstate
    * Example:
    *
    *PathID[1]
    *Transition:
    *	collecting_0->printing
    *Conditions:
    *  cnt == 5
    *Communication conditions:
    *	sensor == true
    *Datapath:
    *  lcd_value = lcd_value + sensor->read()

    *PathID[2]
    *Transition:
    *	printing->printing_1
    *Conditions:
    *Communication conditions:
    *Datapath:
    *  cnt = 1
    *  lcd_value = lcd_value / 5
    *
    * As shown in the example assume does to paths. One starting with the communication state collecting_0
    * and ending with the beginning of section printing. The other starts with the beginning of the section
    * and ends with communication printing_1. In order to have a communication to communication path those
    * paths need to be merged to collecting_0 -> printing_1. All datapath assignemtns and conditions need to be merged, too.
    *
    * Result:
    * PathID[14]
    *Transition:
    * collecting_0->printing_1
    *Conditions:
    *	cnt == 5 : 0x45be990
    *Communication conditions:
    *	sensor == true
Datapath:
   cnt = 1
   lcd_value = lcd_value + sensor->read() / 5
Stmts:
   lcd_value = lcd_value + sensor->read() : 0x2de1990
   If(cnt == 5) : 0x4508030 : 0x33c80a0
   cnt = 1 : 0x3d3c990
   lcd_value = lcd_value / 5 : 0x3216cc0
    *

   */

    class CommToCommNew {
    public:
        CommToCommNew(const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap, SCAM::Module *module);

        const std::map<std::string, std::vector<Path *>> &getNewSectionPathMap() const;

    private:
        void recursion(Path *path,std::set<SCAM::Path *>& visitedPaths);

        bool isCommToComm(Path p);

        bool isCommToSection(Path p);

        bool isSectionToComm(Path p);

        bool isSectionToSection(Path p);

        const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap;
        std::map<std::string, std::vector<SCAM::Path *> > newSectionPathMap;
        std::set<SCAM::Path> newPathSet;

        int recursionCnt;
        SCAM::Module * module;
        SCAM::Path *findInitialPath();
        SCAM::Path * findFirstComm(Path *path, std::set<SCAM::Path *> visitedPaths);
    };
}

#endif //PROJECT_COMMTOCOMMNEW_H
