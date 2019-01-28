//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/16/18.
//
#ifndef PROJECT_COMMANDLINEPARAMETERSCONFIG_H
#define PROJECT_COMMANDLINEPARAMETERSCONFIG_H


#include <vector>
#include <fstream>
#include <sstream>

#define PLUGIN_NAMES "PrintITL;PrintAML;PrintSkeleton;PrintDotSimple;PrintDotFull;PrintDotStates;PrintSystemC;PrintSVA;PrintXML"
#define PLUGIN_DESCRIPTIONS "Complete set of properties in ITL;Structure and FSM in AML;Print VHDL sceleton;statemachine + conditions as .dot;statemachine + conditions + commitments as .dot;statemachine as .dot;Regenerate model in SystemC;Complete set of properties in SVA;Dumps the structure of each module as XML"
#define PLUGIN_DIRECTORIES "PrintITL;PrintAML;PrintSkeleton;PrintDot;PrintDot;PrintDot;PrintSystemC;PrintSVA;PrintXML"
#define OPTION_NAMES "PrintITL;pipelined"
#define OPTION_DESCRIPTIONS "PrintITL;Extends the properties in order to deal with pipelining more easily"

std::vector<std::string> split(const std::string& s, char delimiter)
{
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream tokenStream(s);
    while (std::getline(tokenStream, token, delimiter))
    {
        tokens.push_back(token);
    }
    return tokens;
}

#endif //PROJECT_COMMANDLINEPARAMETERSCONFIG_H
