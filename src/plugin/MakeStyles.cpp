//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/16/18.
//

#include <sstream>
#include <fstream>
#include <vector>
#include "../parser/CommandLineParametersConfig.h"

int main (int argc, char *argv[])
{
    // make sure we have enough arguments
    if (argc < 2)  return 1;

    std::stringstream ss;
    std::ofstream fileStream;
    std::vector<std::string> plugin_names = split(PLUGIN_NAMES, ';');
    std::vector<std::string> plugin_directories = split(PLUGIN_DIRECTORIES, ';');


    ss.str("");
    ss << "#include \"PluginFactory.h\"\n";

    for (int i = 0; i < plugin_names.size(); ++i) {
        ss << "#include \"" << plugin_directories[i] << "/" << plugin_names[i] << ".h\"\n";
    }
    ss << "\nPluginFactory *PluginFactory::create(std::string type) {\n";
    for (const auto &plugin_name : plugin_names) {
        ss << "\tif (type == \"" << plugin_name << "\")"
            << "\t\treturn new " << plugin_name << "();\n";
    }
    ss << "\treturn nullptr;\n"
          "}";

    fileStream.open(argv[1]);
    fileStream << ss.rdbuf();
    fileStream.close();

    return 0;
}