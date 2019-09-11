add_library(PrintVHDL
        PrintVHDL.cpp
        OtherUtils.cpp
        RelocateOpStmts.cpp
        VHDLPrintVisitor.cpp
        ../../global/SimplifyVisitor.cpp
        ../../global/NodePeekVisitor.cpp
        ../../global/StmtNodeAlloc.cpp
        OperationPruning.cpp)

