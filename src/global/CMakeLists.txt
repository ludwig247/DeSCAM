add_compile_options(-D__STDC_CONSTANT_MACROS)
add_compile_options(-D__STDC_LIMIT_MACROS)

add_subdirectory(tinyxml)

file(GLOB LoggerSrc "Logger/*.cpp" "Logger/LoggingFilter.h")

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
        RecursiveVisitor.cpp
        Completeness.cpp
        ${LoggerSrc}
        FatalError.h)
