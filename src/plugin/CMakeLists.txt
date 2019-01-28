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
add_plugin(PrintAML; "Structure and FSM in AML")
add_plugin(PrintSkeleton; "Print VHDL sceleton")
add_plugin(PrintDotSimple; "statemachine + conditions as .dot" ; PrintDot)
add_plugin(PrintDotFull; "statemachine + conditions + commitments as .dot" ; PrintDot)
add_plugin(PrintDotStates; "statemachine as .dot" ; PrintDot)
add_plugin(PrintSystemC; "Regenerate model in SystemC" ; PrintSystemC)
add_plugin(PrintSVA; "Complete set of properties in SVA")
add_plugin(PrintXML; "Dumps the structure of each module as XML")


#Add new options by calling:
add_plugin_option(PrintITL; pipelined; "Extends the properties in order to deal with pipelining more easily")


#Please don't change the code below.
add_library(PluginFactory
        ${CMAKE_SOURCE_DIR}/src/plugin/PluginFactory.cpp
        ${CMAKE_SOURCE_DIR}/src/plugin/PluginFactory.h)

# First we add the executable that generates the table
add_executable(MakeStyles MakeStyles.cpp)
set_target_properties(MakeStyles PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
        )
# Add the command to generate the source code
add_custom_command (
        OUTPUT ${CMAKE_SOURCE_DIR}/src/plugin/PluginFactory.cpp
        DEPENDS MakeStyles
        COMMAND MakeStyles ${CMAKE_SOURCE_DIR}/src/plugin/PluginFactory.cpp
)

