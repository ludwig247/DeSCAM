//
// Created by schmitz on 17.04.20.
//

#ifndef DESCAM_INSTANCEQUEUE_H
#define DESCAM_INSTANCEQUEUE_H


#include <string>
#include <vector>

namespace SCAM {

    class InstanceQueue {
    public:
        InstanceQueue();

        virtual  ~InstanceQueue();


        void addToQueue(std::string name,std::string structure, std::string parentModule, std::string parentInstance, int level, int id);

        void addToQueueFront(std::string name,std::string structure, std::string parentModule, std::string parentInstance, int level, int id);


        bool empty();

        std::string getInst();
        std::string getMod();
        std::string getParentInst();
        std::string getParentMod();

        int getLevel();
        int getID();

        void clean();

    private:
        std::vector<std::string> _instanceNames;
        std::vector<std::string> _moduleNames;
        std::vector<std::string> _parentInstanceNames;
        std::vector<std::string> _parentModuleNames;

        std::vector<int> _level;
        std::vector<int> _id;

    };

}

#endif //DESCAM_INSTANCEQUEUE_H
