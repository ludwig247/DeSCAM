#add_subdirectory(Bus)
#add_subdirectory(Framer)
#add_subdirectory(SingleMasterMultiSlave)
#add_subdirectory(FPI)
#add_subdirectory(FIFO)
#add_subdirectory(tests)
#add_subdirectory(Whishbone)
#add_subdirectory(I2C)
#add_subdirectory(Comm_Test_newInterfaces)
set (EXAMPLE_NAMES "")
set (EXAMPLE_DESCRIPTIONS "")
set (EXAMPLE_DIRECTORIES "")
#set (OPTION_NAMES "")
#set (OPTION_DESCRIPTIONS "")
#set (OPTIMIZE_OPTIONS, "")
#set (OPTIMIZE_OPTIONS_DESCRIPTIONS, "")



include(AddExample.cmake)
add_example(Busses;"Simple bus thing")



# add Backend directory first in order to get all added plugins and options by the users
#add_subdirectory(example)
get_directory_property(EXAMPLE_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_NAMES)
##get_directory_property(PLUGIN_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_DESCRIPTIONS)
##get_directory_property(PLUGIN_DIRECTORIES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_DIRECTORIES)
##get_directory_property(OPTION_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTION_NAMES)
##get_directory_property(OPTION_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTION_DESCRIPTIONS)
##get_directory_property(OPTIMIZE_OPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTIMIZE_OPTIONS)
##get_directory_property(OPTIMIZE_OPTIONS_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTIMIZE_OPTIONS_DESCRIPTIONS)

# configure a header file to pass plugins and options of the CMake settings to the source code
configure_file (
        "${PROJECT_SOURCE_DIR}/tests/Print_ITL_Tests/TestCases/exampleheaders.h.in"
        "${PROJECT_SOURCE_DIR}/tests/Print_ITL_Tests/TestCases/exampleheaders.h"
)









