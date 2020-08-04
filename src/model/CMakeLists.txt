set(AST_FILES
        AbstractNode.cpp
        Model.cpp
        Module.cpp
        ModuleInstance.cpp
        Port.cpp
        Channel.cpp
        Interface.cpp
        Variable.cpp
        FSM.cpp
        AbstractVisitor.cpp
        DataType.cpp
        DataSignal.cpp
        Function.cpp
        Parameter.cpp
        VariableTemplate.cpp
        Timepoint.cpp)


add_library(Model SHARED ${AST_FILES})

add_subdirectory(propertySuite)
add_subdirectory(Behavior)
add_subdirectory(Stmts)

target_link_libraries(Model  propertySuite)
target_link_libraries(Model  Behavior)
target_link_libraries(Model  Stmts)
#add_subdirectory(operationGraph)
