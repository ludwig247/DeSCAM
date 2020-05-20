add_compile_options(-D__STDC_CONSTANT_MACROS)
add_compile_options(-D__STDC_LIMIT_MACROS)

add_subdirectory(Optimizer)

add_library (modelFactory SHARED
        ModelFactory.cpp
	CheckErrors.cpp
        PluginAction.h
        FindModules.cpp
        FindSCMain.cpp
        FindPorts.cpp
        FindCall.cpp
        FindChannels.cpp
        FindChannelMethods.cpp
        FindNetlist.cpp
        FindInterface.cpp
        FindProcess.cpp
        FindVariables.cpp
        FindDataFlow.cpp
        FindInitalValues.cpp
        FindSections.cpp
        FindNewDatatype.cpp
        FindFunctions.cpp
        FindGlobal.cpp FindGlobal.h FindStateName.cpp FindStateName.h)

target_link_libraries(modelFactory propertyFactory)
target_link_libraries(modelFactory cfgFactory)
target_link_libraries(modelFactory functionFactory)
