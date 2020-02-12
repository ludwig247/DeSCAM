# Add your plugin, it's description and it's directory using macro "add_plugin"
#	example: add_plugin(PrintMYStyle; "This plugin prints the model in MY style" ; MYStyleDirectory)
#
# Note: If plugin directory is not specified, it'll be assumed that plugin directory has the same name as the plugin itself.
#
################################################
#
# add your plugin options and their descriptions using macro "add_plugin_option"
#	example: add_plugin_option(MYStyle; OptimizeMYStyle; "This option prints the model in MY style after optimizing the structure")
#
################################################
# Attention! make sure to give the same name of your plugin to its class implementation


#Add new plugins by calling:

add_plugin(PrintITL; "Complete set of properties in ITL")
add_plugin(PrintSVA; "Complete set of properties in SVA")


#add_plugin(PrintTrueOperation; "Prints REAL operations ... ")
add_plugin(PrintSkeleton; "Structure and FSM in AML")
#add_plugin(PrintChisel; "Print a module in CHISEL")

#add_plugin(PrintDotSimple; "statemachine + conditions as .dot" ; PrintDot)
#add_plugin(PrintDotFull; "statemachine + conditions + commitments as .dot" ; PrintDot)
#add_plugin(PrintDotStates; "statemachine as .dot" ; PrintDot)

#add_plugin(PrintCFGDot; "Present Control Flow Graph of every module as .dot file" ; PrintDot)
#add_plugin(PrintCompleteness; "Completeness description in ITL")

#add_plugin(PrintTemplate; "Example for a plugin")


#add_plugin(PrintMonitor; "fill out")

#UNDER MAINTANANCE
#add_plugin(PrintSystemC; "Regenerate model in SystemC" ; PrintSystemC)



#NOT WORKING ANYMORE
#add_plugin(PrintVHDL; "Print VHDL template")
#add_plugin(PrintAML; "Structure and FSM in AML")
#add_plugin(PrintXML; "Dumps the structure of each module as XML")
#add_plugin(PrintModulesCheckers; "Create a project to check equivalency between generate module and original one" ; PrintSystemC)


#Add new options by calling:
add_plugin_option(PrintITL; adjustmacros; "Adjusts macros to automatically fit them to the generated RTL")
add_plugin_option(PrintITL; pipelined; "Extends the properties in order to deal with pipelining more easily")

#add_plugin_option(PrintCFGDot; explicit; "Extends the CFG of every module by showing the hidden statements behind communication statements")

add_plugin_option(PrintSkeleton; vhdl; "Prints a VHDL skeleton")
add_plugin_option(PrintSkeleton; sv; "Prints a SystemVerilog skeleton")
#
#
#add_optimize_option(all; "Enable all optimizations")
#add_optimize_option(gvp; "Propagate the value of constant global variables")
#add_optimize_option(lvp; "Propagate locally constant values")
#add_optimize_option(gcp; "Propagate globally constant values")
#add_optimize_option(rda; "Remove dead assignments")
#add_optimize_option(are; "Analyze reachability of CFG paths")
#add_optimize_option(fun; "Optimize functions")
#add_optimize_option(sim; "Simplify expressions")
#add_optimize_option(ros; "Reduce operators strength")
#add_optimize_option(arb; "Analyze range and bitwidth")
#add_optimize_option(mrc; "Merge redundant conditions")


#Please don't change the code below.
add_library(PluginFactory SHARED
        ${CMAKE_SOURCE_DIR}/src/plugin/PluginFactory.cpp)

# get the list of all added plugins in order to link them to DESCAM
get_directory_property(PLUGIN_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_NAMES)
foreach (plugin_lib ${PLUGIN_NAMES})
    #			MESSAGE(STATUS "linking ${plugin_lib}")
    target_link_libraries(PluginFactory ${plugin_lib})
endforeach ()

# First we add the executable that generates the table
add_executable(MakeStyles MakeStyles.cpp ${CMAKE_SOURCE_DIR}/src/parser/CommandLineParametersConfig.cpp )
set_target_properties(MakeStyles PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
        )
# Add the command to generate the source code
add_custom_command(
        OUTPUT ${CMAKE_SOURCE_DIR}/src/plugin/PluginFactory.cpp
        DEPENDS MakeStyles
        COMMAND MakeStyles ${CMAKE_SOURCE_DIR}/src/plugin/PluginFactory.cpp
)

