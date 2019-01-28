# used variables to configure CommandLine Parameters
set (PLUGIN_NAMES "")
set (PLUGIN_DESCRIPTIONS "")
set (PLUGIN_DIRECTORIES "")
set (OPTION_NAMES "")
set (OPTION_DESCRIPTIONS "")

include(AddPlugin.cmake)
include(AddPluginOption.cmake)

# add Backend directory first in order to get all added plugins and options by the users
add_subdirectory(plugin)
get_directory_property(PLUGIN_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_NAMES)
get_directory_property(PLUGIN_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_DESCRIPTIONS)
get_directory_property(PLUGIN_DIRECTORIES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_DIRECTORIES)
get_directory_property(OPTION_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTION_NAMES)
get_directory_property(OPTION_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTION_DESCRIPTIONS)
# configure a header file to pass plugins and options of the CMake settings to the source code
configure_file (
        "${PROJECT_SOURCE_DIR}/src/parser/CommandLineParametersConfig.h.in"
        "${PROJECT_SOURCE_DIR}/src/parser/CommandLineParametersConfig.h"
)

list(REMOVE_DUPLICATES  PLUGIN_DIRECTORIES)
foreach (plugin_dir ${PLUGIN_DIRECTORIES})
#        MESSAGE(STATUS "adding ${plugin_dir}")
    add_subdirectory(${CMAKE_SOURCE_DIR}/src/plugin/${plugin_dir})
endforeach ()

add_subdirectory(global)
add_subdirectory(parser)
add_subdirectory(model)
add_subdirectory(propertyFactory)
add_subdirectory(modelFactory)
