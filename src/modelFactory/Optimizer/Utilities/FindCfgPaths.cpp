//
// Created by M.I.Alkoudsi on 5/20/19.
//

#include <Stmts/StmtCastVisitor.h>
#include "FindCfgPaths.h"
#include "FatalError.h"
#include "Logger/Logger.h"

namespace DESCAM {

FindCfgPaths::FindCfgPaths() = default;

FindCfgPaths::FindCfgPaths(std::map<int, CfgNode *> CFG, int EntryNode) : cfg_(std::move(CFG)),
                                                                          path_empty_(false),
                                                                          while_node_id_(0) {
  //Finding whileNode
  for (auto node : cfg_) {
    if (StmtCastVisitor<DESCAM::While>(node.second->getStmt()).Get()) {
      while_node_id_ = node.second->getId();
      break;
    }
  }
  //Finding all paths in the blockCFG and marking nodes with paths that lead to them
  auto entry_node = cfg_.at(EntryNode);
  auto last_node = this->cfg_.rbegin();

  for (int i = 0; i < last_node->first + 1; i++) {
    is_visited_.push_back(false);
    node_in_succ_vec_.push_back(0);
  }
  for (auto node : cfg_) {
    std::vector<int> path_ids;
    node_and_all_paths_reaching_it_map_.insert(std::make_pair(node.first, path_ids));
  }
  //Create an initial path and insert the entry node into it
  auto *Path = new CfgPath();
  int path_id = 1;
  Path->insertAtEnd(entry_node);

  std::vector<CfgNode *> succList = entry_node->getSuccessorList();
  bool still_to_visit;
  while (!Path->getPath().empty()) {
    still_to_visit = false;
    const auto end_node = Path->getPath().back();
    if (end_node != nullptr) {
      if (!is_visited_[end_node->getId()]) {
        is_visited_[end_node->getId()] = true;
#ifdef DEBUG_FIND_CFG_PATHS
        std::cout << "visited node" << Path->getPath().back()->getId() << std::endl;
#endif
        if (EntryNode > this->while_node_id_) {
          bool whileNext = false;
          if (StmtCastVisitor<DESCAM::While>(end_node->getSuccessorList().front()->getStmt()).Get() ||
              StmtCastVisitor<DESCAM::While>(end_node->getSuccessorList().back()->getStmt()).Get()) {
            whileNext = true;
          }
          if (!whileNext) {
            if (node_in_succ_vec_[end_node->getId()] <= 1) {
              if (node_in_succ_vec_[end_node->getId()] == 0) {
                if (!is_visited_[end_node->getSuccessorList().front()->getId()]) {
                  Path->insertAtEnd(end_node->getSuccessorList().front());
                  still_to_visit = true;
                }
              } else if (node_in_succ_vec_[end_node->getId()] == 1) {
                if (!is_visited_[end_node->getSuccessorList().back()->getId()]) {
                  Path->insertAtEnd(end_node->getSuccessorList().back());
                  still_to_visit = true;
                }
              }
            }
          }
        } else {
          if (node_in_succ_vec_[end_node->getId()] <= 1) {
            if (node_in_succ_vec_[end_node->getId()] == 0) {
              if (!is_visited_[end_node->getSuccessorList().front()->getId()]) {
                Path->insertAtEnd(end_node->getSuccessorList().front());
                still_to_visit = true;
              }
            } else if (node_in_succ_vec_[end_node->getId()] == 1) {
              if (!is_visited_[end_node->getSuccessorList().back()->getId()]) {
                Path->insertAtEnd(end_node->getSuccessorList().back());
                still_to_visit = true;
              }
            }
          }
        }
      }
      if (!still_to_visit) {
        if (StmtCastVisitor<DESCAM::While>(end_node->getSuccessorList().front()->getStmt()).Get() ||
            StmtCastVisitor<DESCAM::While>(end_node->getSuccessorList().back()->getStmt()).Get()) {
          addPathToPathsMap(Path->getPathID(), *Path);

          //Marking nodes with paths that lead to them
          for (auto node_in_path : Path->getPath()) {
            node_and_all_paths_reaching_it_map_.at(node_in_path->getId()).push_back(Path->getPathID());
          }

          //Create a new path from the previous path
          path_id++;
          Path = new CfgPath(*Path, path_id);
#ifdef DEBUG_FIND_CFG_PATHS
          std::cout << "unvisited node" << Path->getPath().back()->getId() << std::endl;
#endif
          //if node at the end of the path has an if statement, choose the next successor, if the last one is already chosen, choose the first
          if (end_node->getSuccessorList().size() > 1) {
            node_in_succ_vec_[end_node->getId()] += 1;
            if (node_in_succ_vec_[end_node->getId()] >= 2) {
              node_in_succ_vec_[end_node->getId()] = 0;
            }
          }
          //mark the last node in the path as unvisited and remove it from the path
          is_visited_[end_node->getId()] = false;
          Path->deleteNodeBackward();
        }
        removeBackwardsUntilIf(Path);
        if (this->path_empty_) {
          this->path_empty_ = false;
          break;
        }
      }
      if (Path->getPath().empty() || end_node->getId() == 0) { break; }
    } else {
      TERMINATE("Last node in the path can't be a null pointer")
    }
  }
}

FindCfgPaths::FindCfgPaths(const FindCfgPaths &FCP) : paths_map_(FCP.getPathsMap()),
                                                      node_and_all_paths_reaching_it_map_(
                                                          FCP.getNodeAndAllPathsReachingItMap()) {

}

void FindCfgPaths::setPathsMap(const std::map<int, CfgPath> &pathsMap) {
  this->paths_map_ = pathsMap;
}

void
FindCfgPaths::setNodeAndAllPathsReachingItMap(const std::map<int, std::vector<int>> &nodeAndPathsReachingItMap) {
  this->node_and_all_paths_reaching_it_map_ = nodeAndPathsReachingItMap;
}

const std::map<int, CfgPath> &FindCfgPaths::getPathsMap() const {

  return this->paths_map_;

}

const std::map<int, std::vector<int>> &FindCfgPaths::getNodeAndAllPathsReachingItMap() const {
  return this->node_and_all_paths_reaching_it_map_;
}

void FindCfgPaths::addPathToPathsMap(const int &pathID, CfgPath &path) {

  this->paths_map_.insert(std::make_pair(pathID, path));
}

std::map<int, std::vector<CfgNode *>> FindCfgPaths::makeResetPathsToNode(int nodeId) {
  int cnt = 1;
  std::map<int, std::vector<CfgNode *>> pathsToNode;
  for (auto path_id : node_and_all_paths_reaching_it_map_.at(nodeId)) {
    std::vector<CfgNode *> path = paths_map_.at(path_id).makePathToNode(nodeId);
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
  std::map<int, std::vector<CfgNode *>> paths_to_node;
  paths_to_node = makeResetPathsToNode(nodeId);
  cnt = (*paths_to_node.rbegin()).first + 1;
  for (const auto &path : paths_map_) { paths_to_node.insert(std::make_pair(cnt++, path.second.getPath())); }
  return paths_to_node;
}

void FindCfgPaths::removeBackwardsUntilIf(DESCAM::CfgPath *Path) {

  while (!Path->getPath().empty() && Path->getPath().back()->getSuccessorList().size() < 2) {
    is_visited_[Path->getPath().back()->getId()] = false;
    if (Path->getPath().back()->getId() == 0 || Path->getPath().empty()) {
      this->path_empty_ = true;
      return;
    }
    Path->deleteNodeBackward();
  }

  if (Path->getPath().empty()) {
    this->path_empty_ = true;
    return;
  }
  if (Path->getPath().back()->getSuccessorList().size() > 1) {
    node_in_succ_vec_[Path->getPath().back()->getId()] += 1;
    is_visited_[Path->getPath().back()->getId()] = false;
  }
  if (node_in_succ_vec_[Path->getPath().back()->getId()] >= 2) {
    node_in_succ_vec_[Path->getPath().back()->getId()] = 0;
    Path->deleteNodeBackward();
    if (Path->getPath().empty()) {
      this->path_empty_ = true;
      return;
    }
    removeBackwardsUntilIf(Path);
  }
}
}