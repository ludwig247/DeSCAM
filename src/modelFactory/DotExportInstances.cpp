//
// Created by schmitz on 10.03.20.
//

#include "DotExportInstances.h"
#include <iostream>
#include <fstream>

namespace SCAM {

    void  DotExportInstances::addtoGraph(std::map<std::pair<std::string, std::string>, std::string> instanceMap) {

        for (auto elem : instanceMap) {
            _instanceMap.insert(elem);
        }
    }

    void DotExportInstances::printInstanceMap() {
        std::cout << "Instance Map:" << std::endl;
        for (auto elem : _instanceMap) {
            std::cout << "Name: "<<elem.first.first.c_str() << " Module: " << elem.first.second.c_str() << " Parent: "<< elem.second.c_str() << "\n";
        }
        std::cout << "#########" << std::endl;
    }

    void DotExportInstances::exportDot() {
        std::ofstream file;
        file.open ("Instances.dot");
        //Begin Graph
        file << "digraph D {\n";
        file << "top" << "[shape = diamond]" << "\n";
        for (auto elem : _instanceMap) {

            file << elem.first.first.c_str() << "[shape = circle]" << "\n";
        }
        int i = 0;
        for (auto elem_o : _instanceMap) {
            for (auto elem_i : _instanceMap) {
                if (elem_i.second.c_str() == elem_o.first.second) {
                    file << elem_o.first.first.c_str() << "->" << elem_i.first.first.c_str() << "\n";
                } else if (!elem_o.second.compare("top")) {
                    if (i == 0) {
                        file << "top" << "->" << elem_o.first.first.c_str() << "\n";
                        i = 1;
                    }

                }
            }
            i = 0;
        }



        file << "}\n"; //End Graph
        file.close();
    }
}


/*


    myfile << "Writing this to a file.\n";
    myfile.close();

}
digraph D {

        A [shape=diamond]
        B [shape=box]
        C [shape=circle]

        A -> B [style=dashed, color=grey]
        A -> C [color="black:invis:black"]
        A -> D [penwidth=5, arrowhead=none]

}

}
}
 */