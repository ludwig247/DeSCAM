add_library(PrintVHDL
        PrintVHDL.cpp
        OtherUtils.cpp
        RelocateOpStmts.cpp
        VHDLPrintVisitor.cpp
        OperationPruning.cpp
        VHDLPrintVisitorHLS.cpp
        VHDLPrintResetNotify.cpp
        PrintVHDLForHLS.cpp
        ../../global/SimplifyVisitor.cpp
        ../../global/NodePeekVisitor.cpp
        ../../global/StmtNodeAlloc.cpp
        ../PrintHLS/BitSlicingHLS.cpp
        HLSmodule.cpp
        SignalFactory.cpp)

