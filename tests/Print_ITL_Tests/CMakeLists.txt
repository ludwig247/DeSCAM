project(PrintITL_Test_Run C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")


#DIRECTORIES

set(SOURCE_FILES tests.cpp)

set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/parser/CommandLineParameter.cpp
        ${CMAKE_SOURCE_DIR}/src/parser/CommandLineParameter.h
        ${CMAKE_SOURCE_DIR}/src/global/ErrorMsg.cpp
        ${CMAKE_SOURCE_DIR}/src/global/DataTypes.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ModelGlobal.h
        ${CMAKE_SOURCE_DIR}/src/global/ExprTranslator.cpp
        ${CMAKE_SOURCE_DIR}/src/global/PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ExprVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/SimplifyVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/StmtNodeAlloc.cpp
        ${CMAKE_SOURCE_DIR}/src/global/NodePeekVisitor.cpp
        PrintITL_Test.h TestCases/ModuleFunctions.h)

add_executable(PrintITL_Test_Run ${SOURCE_FILES} ${GLOBAL_FILES})

target_link_libraries(PrintITL_Test_Run PrintITL)
target_link_libraries(PrintITL_Test_Run modelFactory)
target_link_libraries(PrintITL_Test_Run propertyFactory)
target_link_libraries(PrintITL_Test_Run Model)
target_link_libraries(PrintITL_Test_Run Stmts)
target_link_libraries(PrintITL_Test_Run ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)


set(LLVM_LIBS
        LLVMInstrumentation
        LLVMIRReader
        LLVMAsmParser
        LLVMDebugInfo
        LLVMOption
        LLVMLTO
        LLVMLinker
        LLVMipo
        LLVMVectorize
        LLVMBitWriter
        LLVMBitReader
        LLVMTableGen
        LLVMXCoreDisassembler
        LLVMXCoreCodeGen
        LLVMXCoreDesc
        LLVMXCoreInfo
        LLVMXCoreAsmPrinter
        LLVMX86Disassembler
        LLVMX86AsmParser
        LLVMX86CodeGen
        LLVMX86Desc
        LLVMX86Info
        LLVMX86AsmPrinter
        LLVMX86Utils
        LLVMSystemZDisassembler
        LLVMSystemZCodeGen
        LLVMSystemZAsmParser
        LLVMSystemZDesc
        LLVMSystemZInfo
        LLVMSystemZAsmPrinter
        LLVMSparcCodeGen
        LLVMSparcDesc
        LLVMSparcInfo
        LLVMR600CodeGen
        LLVMR600Desc
        LLVMR600Info
        LLVMR600AsmPrinter
        LLVMPowerPCCodeGen
        LLVMPowerPCAsmParser
        LLVMPowerPCDesc
        LLVMPowerPCInfo
        LLVMPowerPCAsmPrinter
        LLVMNVPTXCodeGen
        LLVMNVPTXDesc
        LLVMNVPTXInfo
        LLVMNVPTXAsmPrinter
        LLVMMSP430CodeGen
        LLVMMSP430Desc
        LLVMMSP430Info
        LLVMMSP430AsmPrinter
        LLVMMipsDisassembler
        LLVMMipsCodeGen
        LLVMMipsAsmParser
        LLVMMipsDesc
        LLVMMipsInfo
        LLVMMipsAsmPrinter
        LLVMHexagonCodeGen
        LLVMHexagonAsmPrinter
        LLVMHexagonDesc
        LLVMHexagonInfo
        LLVMCppBackendCodeGen
        LLVMCppBackendInfo
        LLVMARMDisassembler
        LLVMARMCodeGen
        LLVMARMAsmParser
        LLVMARMDesc
        LLVMARMInfo
        LLVMARMAsmPrinter
        LLVMAArch64Disassembler
        LLVMAArch64CodeGen
        LLVMSelectionDAG
        LLVMAsmPrinter
        LLVMAArch64AsmParser
        LLVMAArch64Desc
        LLVMAArch64Info
        LLVMAArch64AsmPrinter
        LLVMAArch64Utils
        LLVMMCDisassembler
        LLVMMCParser
        LLVMInterpreter
        LLVMMCJIT
        LLVMJIT
        LLVMCodeGen
        LLVMObjCARCOpts
        LLVMScalarOpts
        LLVMInstCombine
        LLVMTransformUtils
        LLVMipa
        LLVMAnalysis
        LLVMRuntimeDyld
        LLVMExecutionEngine
        LLVMTarget
        LLVMMC
        LLVMObject
        LLVMCore
        LLVMSupport)

set(CLANG_LIBS
        clangTooling
        clangFrontendTool
        clangFrontend
        clangDriver
        clangSerialization
        clangCodeGen
        clangParse
        clangSema
        clangStaticAnalyzerFrontend
        clangStaticAnalyzerCheckers
        clangStaticAnalyzerCore
        clangAnalysis
        clangARCMigrate
        clangRewriteFrontend
        clangRewriteCore
        clangEdit
        clangAST
        clangLex
        clangBasic
        clangASTMatchers)

set(OTHER_LIBS  z3)


set(LLVM_LD_FLAGS
        -lrt
        -ldl
        -ltinfo
        -lpthread)

foreach (clang_lib ${CLANG_LIBS})
    target_link_libraries(PrintITL_Test_Run ${CMAKE_SOURCE_DIR}/lib/lib${clang_lib}.a)
endforeach ()

foreach (other_lib ${OTHER_LIBS})
    target_link_libraries(PrintITL_Test_Run ${CMAKE_SOURCE_DIR}/lib/lib${other_lib}.so)
endforeach ()

foreach (llvm_lib ${LLVM_LIBS})
    target_link_libraries(PrintITL_Test_Run ${CMAKE_SOURCE_DIR}/lib/lib${llvm_lib}.a)
endforeach ()

foreach (ld_flag ${LLVM_LD_FLAGS})
    target_link_libraries(PrintITL_Test_Run ${ld_flag})
endforeach ()








