//
// Created by M.I.Alkoudsi on 5/20/19.
//

#include "FindCfgPaths.h"
#include "Optimizer/Debug.h"
#include "FatalError.h"
#include "Logger/Logger.h"


namespace DESCAM {

    FindCfgPaths::FindCfgPaths() = default;

    FindCfgPaths::FindCfgPaths(std::map<int, CfgNode *> CFG, int EntryNode) : Cfg(std::move(CFG)), pathEmpty(false),
                                                                              whileNodeID(0) {
        //Finding whileNode
        for (auto node : Cfg) {
            if (dynamic_cast<DESCAM::While *>(node.second->getStmt())) {
                whileNodeID = node.second->getId();
                break;
            }
        }
        //Finding all paths in the blockCFG and marking nodes with paths that lead to them
        auto entryNode = Cfg.at(EntryNode);
        auto lastnode = this->Cfg.rbegin();

        for (int i = 0; i < lastnode->first + 1; i++) {
            isVisted.push_back(false);
            nodeInSuccVec.push_back(0);
        }
        for (auto nod : Cfg) {
            std::vector<int> pathsids;
            nodeAndAllPathsReachingItMap.insert(std::make_pair(nod.first, pathsids));
        }
        //Create an initial path and insert the entry node into it
        CfgPath *Path = new CfgPath();
        int pathid = 1;
        Path->insertAtEnd(entryNode);

        std::vector<CfgNode *> succList = entryNode->getSuccessorList();
        bool stillToVisit;
        while (!Path->getPath().empty()) {
            stillToVisit = false;
            if (Path->getPath().back() != nullptr) {
                if (isVisted[Path->getPath().back()->getId()] == false) {
                    isVisted[Path->getPath().back()->getId()] = true;
#ifdef DEBUG_FIND_CFG_PATHS
                    std::cout << "visited node" << Path->getPath().back()->getId() << std::endl;
#endif
                    if (EntryNode > this->whileNodeID) {
                        bool whileNext = false;
                        if (dynamic_cast<DESCAM::While *>(Path->getPath().back()->getSuccessorList().front()->getStmt()) ||
                            dynamic_cast<DESCAM::While *>(
                                    Path->getPath().back()->getSuccessorList().back()->getStmt())) {
                            whileNext = true;
                        }
                        if (!whileNext) {
                            if (nodeInSuccVec[Path->getPath().back()->getId()] <= 1) {
                                if (nodeInSuccVec[Path->getPath().back()->getId()] == 0) {
                                    if (isVisted[Path->getPath().back()->getSuccessorList().front()->getId()] ==
                                        false) {
                                        Path->insertAtEnd(Path->getPath().back()->getSuccessorList().front());
                                        stillToVisit = true;
                                    }
                                } else if (nodeInSuccVec[Path->getPath().back()->getId()] == 1) {
                                    if (isVisted[Path->getPath().back()->getSuccessorList().back()->getId()] == false) {
                                        Path->insertAtEnd(Path->getPath().back()->getSuccessorList().back());
                                        stillToVisit = true;
                                    }
                                }
                            }
                        }
                    } else {
                        if (nodeInSuccVec[Path->getPath().back()->getId()] <= 1) {
                            if (nodeInSuccVec[Path->getPath().back()->getId()] == 0) {
                                if (isVisted[Path->getPath().back()->getSuccessorList().front()->getId()] ==
                                    false) {
                                    Path->insertAtEnd(Path->getPath().back()->getSuccessorList().front());
                                    stillToVisit = true;
                                }
                            } else if (nodeInSuccVec[Path->getPath().back()->getId()] == 1) {
                                if (isVisted[Path->getPath().back()->getSuccessorList().back()->getId()] == false) {
                                    Path->insertAtEnd(Path->getPath().back()->getSuccessorList().back());
                                    stillToVisit = true;
                                }
                            }
                        }
                    }
                }
                if (!stillToVisit) {
                    if (dynamic_cast<DESCAM::While *>(Path->getPath().back()->getSuccessorList().front()->getStmt()) ||
                        (dynamic_cast<DESCAM::While *>(
                                Path->getPath().back()->getSuccessorList().back()->getStmt()))) {
                        addPathToPathsMap(Path->getPathID(), *Path);

                        //Marking nodes with paths that lead to them
                        for (auto nodinpath : Path->getPath()) {
                            nodeAndAllPathsReachingItMap.at(nodinpath->getId()).push_back(Path->getPathID());
                        }

                        //Create a new path from the previous path
                        pathid++;
                        Path = new CfgPath(*Path, pathid);
#ifdef DEBUG_FIND_CFG_PATHS
                        std::cout << "unvisited node" << Path->getPath().back()->getId() << std::endl;
#endif
                        //if node at the end of the path has an if statement, choose the next successor, if the last one is already chosen, choose the first
                        if (Path->getPath().back()->getSuccessorList().size() > 1) {
                            nodeInSuccVec[Path->getPath().back()->getId()] += 1;
                            if (nodeInSuccVec[Path->getPath().back()->getId()] >= 2) {
                                nodeInSuccVec[Path->getPath().back()->getId()] = 0;
                            }
                        }
                        //mark the last node in the path as unvisted and remove it from the path
                        isVisted[Path->getPath().back()->getId()] = false;
                        Path->deleteNodeBackward();
                    }
                    removeBackwardsUntilIf(Path);
                    if (this->pathEmpty) {
                        this->pathEmpty = false;
                        break;
                    }
                }
                if (Path->getPath().empty() || Path->getPath().back()->getId() == 0) { break; }
            } else {
                TERMINATE("Last node in the path can't be a null pointer");
            }
        }
    }

    FindCfgPaths::FindCfgPaths(const FindCfgPaths &FCP) : Pathsmap(FCP.getPathsMap()),
                                                          nodeAndAllPathsReachingItMap(
                                                                  FCP.getNodeAndAllPathsReachingItMap()) {

    }

    void FindCfgPaths::setPathsMap(const std::map<int, CfgPath> &pathsMap) {
        this->Pathsmap = pathsMap;
    }

    void
    FindCfgPaths::setNodeAndAllPathsReachingItMap(const std::map<int, std::vector<int>> &nodeAndPathsReachingItMap) {
        this->nodeAndAllPathsReachingItMap = nodeAndPathsReachingItMap;
    }


    const std::map<int, CfgPath> &FindCfgPaths::getPathsMap() const {

        return this->Pathsmap;

    }


    const std::map<int, std::vector<int>> &FindCfgPaths::getNodeAndAllPathsReachingItMap() const {
        return this->nodeAndAllPathsReachingItMap;
    }


    void FindCfgPaths::addPathToPathsMap(const int &pathID, CfgPath &path) {

        this->Pathsmap.insert(std::make_pair(pathID, path));
    }

    std::map<int, std::vector<CfgNode *>> FindCfgPaths::makeResetPathsToNode(int nodeId) {
        int cnt = 1;
        std::map<int, std::vector<CfgNode *>> pathsToNode;
        for (auto pathid : nodeAndAllPathsReachingItMap.at(nodeId)) {
            std::vector<CfgNode *> path = Pathsmap.at(pathid).makePathToNode(nodeId);
            bool foundPath = false;
            for (const auto &pathInMap : pathsToNode) {
                if (path == pathInMap.second) {
                    foundPath = true;
                    break;
                }
            }
            if (!foundPath) {
                pathsToNode.insert(std::make_pair(cnt++, path));
            }
        }
        return pathsToNode;
    }

    std::map<int, std::vector<CfgNode *>> FindCfgPaths::makeAllPathsToNode(int nodeId) {
        int cnt;
        std::map<int, std::vector<CfgNode *>> pathsToNode;
        pathsToNode = makeResetPathsToNode(nodeId);
        cnt = (*pathsToNode.rbegin()).first + 1;
        for (const auto &path : Pathsmap) { pathsToNode.insert(std::make_pair(cnt++, path.second.getPath())); }
        return pathsToNode;
    }

    void FindCfgPaths::removeBackwardsUntilIf(DESCAM::CfgPath *Path) {

        while (!Path->getPath().empty() && Path->getPath().back()->getSuccessorList().size() < 2) {
            isVisted[Path->getPath().back()->getId()] = false;
            if (Path->getPath().back()->getId() == 0 || Path->getPath().empty()) {
                this->pathEmpty = true;
                return;
            }
            Path->deleteNodeBackward();
        }

        if (Path->getPath().empty()) {
            this->pathEmpty = true;
            return;
        }
        if (Path->getPath().back()->getSuccessorList().size() > 1) {
            nodeInSuccVec[Path->getPath().back()->getId()] += 1;
            isVisted[Path->getPath().back()->getId()] = false;
        }
        if (nodeInSuccVec[Path->getPath().back()->getId()] >= 2) {
            nodeInSuccVec[Path->getPath().back()->getId()] = 0;
            Path->deleteNodeBackward();
            if (Path->getPath().empty()) {
                this->pathEmpty = true;
                return;
            }
            removeBackwardsUntilIf(Path);
        }
    }
}