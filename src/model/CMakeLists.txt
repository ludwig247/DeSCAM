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
        Parameter.cpp VariableTemplate.h VariableTemplate.cpp)


add_library(Model ${AST_FILES})


add_subdirectory(Stmts)
add_subdirectory(Behavior)

target_link_libraries(Model Behavior)
target_link_libraries(Model Stmts)
#add_subdirectory(operationGraph)
