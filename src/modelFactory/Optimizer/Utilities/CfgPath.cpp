//
// Created by M.I.Alkoudsi on 5/20/19.
//

#include "CfgPath.h"

namespace SCAM {
    CfgPath::CfgPath() : PathID(1) {}

    CfgPath::CfgPath(const CfgPath &Path, int &ID) : PathID(ID) {
        this->path = Path.getPath();
    }

    const std::vector<CfgNode *> &CfgPath::getPath() const {
        return this->path;
    }

    const int &CfgPath::getPathID() const {
        return this->PathID;
    }

    void CfgPath::insertAtEnd(CfgNode *node) {
        this->path.push_back(node);
    }

    void CfgPath::deleteNodeBackward() {
        this->path.pop_back();
    }

    std::vector<CfgNode *> CfgPath::makePathToNode(int NodeId) {
        auto Path = this->getPath();
        while (Path.back()->getId() != NodeId) {
            Path.pop_back();
        }
        Path.pop_back();
        return Path;
    }

    std::string CfgPath::print() {
        std::stringstream ss;
        ss << "Path" << PathID << ": ";//

        for (auto node: path) {
            ss << "Node" << node->getId();
            if (node->getId() == path.back()->getId()) {}
            else { ss << " -> "; }
        }
        ss << std::endl;

        return ss.str();
    }
}