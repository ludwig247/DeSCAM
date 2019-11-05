
add_library(PrintDotSimple
        PrintDotSimple.cpp
        PrintStmtForDot.h)

add_library(PrintDotFull
        PrintDotFull.cpp
        PrintStmtForDot.h)

add_library(PrintDotStates
        PrintDotStates.cpp
        PrintStmtForDot.h)

add_library(PrintCFGDot
        CreateExplicitCFG.cpp
        PrintCFGDot.cpp
        PrintCFGDot.h
        PrintStmtForDot.h)
