
add_subdirectory(tinyxml)

add_library(global SHARED ErrorMsg.cpp
        DataTypes.cpp
        ModelGlobal.h
        ExprTranslator.cpp
        ExprVisitor.cpp
        PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h
        Config.h
        NodePeekVisitor.cpp
        StmtNodeAlloc.cpp
        SimplifyVisitor.cpp
        ModelGlobal.cpp RecursiveVisitor.cpp RecursiveVisitor.h)



