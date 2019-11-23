add_library(PrintVHDL
        PrintVHDL.cpp
        OtherUtils.cpp
        RelocateOpStmts.cpp
        VHDLPrintVisitor.cpp
        OperationPruning.cpp
        VHDLPrintVisitorHLS.cpp
        VHDLPrintReset.cpp
        VHDLPrintResetNotify.cpp
        PrintVHDLForHLS.cpp
        ../../global/SimplifyVisitor.cpp
        ../../global/NodePeekVisitor.cpp
        ../../global/StmtNodeAlloc.cpp
        ../PrintHLS/PrintOperations.cpp
        ../PrintHLS/Utilities.cpp
        SignalFactory.cpp)

