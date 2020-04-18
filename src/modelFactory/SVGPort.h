//
// Created by schmitz on 06.04.20.
//

#ifndef DESCAM_SVGPORT_H
#define DESCAM_SVGPORT_H


#include <map>
#include <string>
#include <vector>

namespace SCAM{

    class SVGPort {
    public:


        SVGPort(std::string name);

        virtual  ~SVGPort();


        std::string getName();
        int getx();
        int gety();
        std::string getChannel();

        void setx(int x);
        void sety(int y);
        void setChannel(std::string channel);



    private:
        int _x;
        int _y;
        std::string _name;
        std::string _channel;

    };
}


#endif //DESCAM_SVGPORT_H
