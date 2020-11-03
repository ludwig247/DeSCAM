add_compile_options(-D__STDC_CONSTANT_MACROS)
add_compile_options(-D__STDC_LIMIT_MACROS)

add_subdirectory(Optimizer)

add_library (modelFactory SHARED
        ModelFactory.cpp
		ClangDiagnosticPrinter.cpp
        PluginAction.cpp
        FindModules.cpp
        GetClangMain.cpp
        FindPorts.cpp
        GetClangNetlist.cpp
        FindProcess.cpp
        FindVariables.cpp
        FindDataFlow.cpp
        FindInitialValues.cpp
        FindNewDatatype.cpp
        FindFunctions.cpp
        FindGlobal.cpp
		FindStateName.cpp
		FindStateName.h
		IFindGlobal.h
		IFindModules.h
		IFindPorts.h
		IFindProcess.h
		IFindVariables.h
		IFindDataFlowFactory.h
		IFindStateName.h
		IFindInstances.h
		GetClangVariables.cpp
		GetClangVariables.h
		GetClangFunctions.cpp
		GetClangProcess.cpp
		GetClangPorts.cpp
		FindInstances.cpp
		clangCastVisitor.cpp)


target_link_libraries(modelFactory propertyFactory)
target_link_libraries(modelFactory cfgFactory)
target_link_libraries(modelFactory functionFactory)
