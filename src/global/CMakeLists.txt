add_subdirectory(tinyxml)

file(GLOB LoggerSrc "Logger/*.cpp")

add_library(global SHARED
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
        GlobalUtilities.cpp
        ${LoggerSrc} Logger/LoggingFilter.h)