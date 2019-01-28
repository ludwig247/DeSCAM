add_compile_options(-D__STDC_CONSTANT_MACROS)
add_compile_options(-D__STDC_LIMIT_MACROS)

add_library (modelFactory
        ModelFactory.cpp
        PluginAction.h
        CFG/CFGNode.cpp
        CFG/CFGFactory.cpp
        CFG/FlattenIf.cpp
        CFG/SectionFactory.cpp
        CFG/FindEndNode.cpp
        CFG/EnumartePathsVisitor.cpp
        CFG/FlattenWhile.cpp
        FindModules.cpp
        FindSCMain.cpp
        FindPorts.cpp
        FindCall.cpp
        FindNetlist.cpp
        FindInterface.cpp
        FindProcess.cpp
        FindVariables.cpp
        FindDataFlow.cpp
        FindInitalValues.cpp
        FindSections.cpp
        FindNewDatatype.cpp
        FindFunctions.cpp
        CFG/FunctionFactory.cpp
        CFG/CfgUtilities.cpp)