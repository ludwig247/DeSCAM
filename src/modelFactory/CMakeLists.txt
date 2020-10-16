add_compile_options(-D__STDC_CONSTANT_MACROS)
add_compile_options(-D__STDC_LIMIT_MACROS)

add_subdirectory(Optimizer)

add_library (modelFactory SHARED
        ModelFactory.cpp
		ClangDiagnosticPrinter.cpp
        PluginAction.cpp
        FindModules.cpp
        FindSCMain.cpp
        FindPorts.cpp
        FindNetlist.cpp
        FindProcess.cpp
        FindVariables.cpp
        FindDataFlow.cpp
        FindInitialValues.cpp
        FindNewDatatype.cpp
        FindFunctions.cpp
        FindGlobal.cpp FindGlobal.h
		FindStateName.cpp
		FindStateName.h
		IFindGlobal.h
		IFindModules.h
		IFindPorts.h
		IFindNetlist.h
		IFindProcess.h
		IFindVariables.h
		IFindSCMain.h IFindDataFlowFactory.h IFindStateName.h GetClangVariables.cpp GetClangVariables.h)


target_link_libraries(modelFactory propertyFactory)
target_link_libraries(modelFactory cfgFactory)
target_link_libraries(modelFactory functionFactory)
