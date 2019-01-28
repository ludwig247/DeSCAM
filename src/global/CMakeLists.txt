
add_subdirectory(tinyxml)

add_library(global ErrorMsg.cpp
       DataTypes.cpp
       ModelGlobal.h
        ExprTranslator.cpp
        ExprVisitor.cpp
        PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h
        Config.h
        NodePeekVisitor.cpp)

