#include <iostream>
#include "aml_driver.h"
#include "PrintAML/PrintAML.h"
#include <Model.h>
#include <Synthesize.h>
#include <PropertyFactory.h>
//#include <CommandlineControl.h>


int main(int argc, const char *argv[])
{


    SCAM::CommandlineControl commandlineControl("AML-parse",argc, argv);


    aml_driver driver;
    SCAM::Model* model = new SCAM::Model("AML-model");

    //Is there a file specified
    if (commandlineControl.getFileName().empty()) return 0;

    //DO THE PARSING//
    std::cout << "Setting up enviroment for file " << commandlineControl.getFileName() << std::endl << std::endl;
    driver.parse(commandlineControl.getFileName(), model);

    std::cout << "Creating model ..." << std::endl;
    if (driver.error_code == 0) {
        commandlineControl.output(model);
        return 0;
    } else {
        if (driver.error_code != 0){
            std::cout << commandlineControl.getFileName() << ": " << std::endl;
            std::cout << driver.error_location << ":";
            std::cout << driver.error_msg << std::endl;
        }
        return driver.error_code;
    }
}

