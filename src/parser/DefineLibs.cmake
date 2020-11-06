if (APPLE)
    set(LLVM_LIBS
            libLLVM.dylib
            libLLVMAArch64AsmParser.a
            libLLVMAArch64CodeGen.a
            libLLVMAArch64Desc.a
            libLLVMAArch64Disassembler.a
            libLLVMAArch64Info.a
            libLLVMAArch64Utils.a
            libLLVMAggressiveInstCombine.a
            libLLVMAMDGPUAsmParser.a
            libLLVMAMDGPUCodeGen.a
            libLLVMAMDGPUDesc.a
            libLLVMAMDGPUDisassembler.a
            libLLVMAMDGPUInfo.a
            libLLVMAMDGPUUtils.a
            libLLVMAnalysis.a
            libLLVMARMAsmParser.a
            libLLVMARMCodeGen.a
            libLLVMARMDesc.a
            libLLVMARMDisassembler.a
            libLLVMARMInfo.a
            libLLVMARMUtils.a
            libLLVMAsmParser.a
            libLLVMAsmPrinter.a
            libLLVMAVRAsmParser.a
            libLLVMAVRCodeGen.a
            libLLVMAVRDesc.a
            libLLVMAVRDisassembler.a
            libLLVMAVRInfo.a
            libLLVMBinaryFormat.a
            libLLVMBitReader.a
            libLLVMBitstreamReader.a
            libLLVMBitWriter.a
            libLLVMBPFAsmParser.a
            libLLVMBPFCodeGen.a
            libLLVMBPFDesc.a
            libLLVMBPFDisassembler.a
            libLLVMBPFInfo.a
            libLLVMCFGuard.a
            libLLVMCodeGen.a
            libLLVMCore.a
            libLLVMCoroutines.a
            libLLVMCoverage.a
            libLLVMDebugInfoCodeView.a
            libLLVMDebugInfoDWARF.a
            libLLVMDebugInfoGSYM.a
            libLLVMDebugInfoMSF.a
            libLLVMDebugInfoPDB.a
            libLLVMDemangle.a
            libLLVMDlltoolDriver.a
            libLLVMDWARFLinker.a
            libLLVMExecutionEngine.a
            libLLVMExtensions.a
            libLLVMFrontendOpenACC.a
            libLLVMFrontendOpenMP.a
            libLLVMFuzzMutate.a
            libLLVMGlobalISel.a
            libLLVMHexagonAsmParser.a
            libLLVMHexagonCodeGen.a
            libLLVMHexagonDesc.a
            libLLVMHexagonDisassembler.a
            libLLVMHexagonInfo.a
            libLLVMInstCombine.a
            libLLVMInstrumentation.a
            libLLVMInterpreter.a
            libLLVMipo.a
            libLLVMIRReader.a
            libLLVMJITLink.a
            libLLVMLanaiAsmParser.a
            libLLVMLanaiCodeGen.a
            libLLVMLanaiDesc.a
            libLLVMLanaiDisassembler.a
            libLLVMLanaiInfo.a
            libLLVMLibDriver.a
            libLLVMLineEditor.a
            libLLVMLinker.a
            libLLVMLTO.a
            libLLVMMC.a
            libLLVMMCA.a
            libLLVMMCDisassembler.a
            libLLVMMCJIT.a
            libLLVMMCParser.a
            libLLVMMipsAsmParser.a
            libLLVMMipsCodeGen.a
            libLLVMMipsDesc.a
            libLLVMMipsDisassembler.a
            libLLVMMipsInfo.a
            libLLVMMIRParser.a
            libLLVMMSP430AsmParser.a
            libLLVMMSP430CodeGen.a
            libLLVMMSP430Desc.a
            libLLVMMSP430Disassembler.a
            libLLVMMSP430Info.a
            libLLVMNVPTXCodeGen.a
            libLLVMNVPTXDesc.a
            libLLVMNVPTXInfo.a
            libLLVMObjCARCOpts.a
            libLLVMObject.a
            libLLVMObjectYAML.a
            libLLVMOption.a
            libLLVMOrcError.a
            libLLVMOrcJIT.a
            libLLVMPasses.a
            libLLVMPowerPCAsmParser.a
            libLLVMPowerPCCodeGen.a
            libLLVMPowerPCDesc.a
            libLLVMPowerPCDisassembler.a
            libLLVMPowerPCInfo.a
            libLLVMProfileData.a
            libLLVMRemarks.a
            libLLVMRISCVAsmParser.a
            libLLVMRISCVCodeGen.a
            libLLVMRISCVDesc.a
            libLLVMRISCVDisassembler.a
            libLLVMRISCVInfo.a
            libLLVMRISCVUtils.a
            libLLVMRuntimeDyld.a
            libLLVMScalarOpts.a
            libLLVMSelectionDAG.a
            libLLVMSparcAsmParser.a
            libLLVMSparcCodeGen.a
            libLLVMSparcDesc.a
            libLLVMSparcDisassembler.a
            libLLVMSparcInfo.a
            libLLVMSupport.a
            libLLVMSymbolize.a
            libLLVMSystemZAsmParser.a
            libLLVMSystemZCodeGen.a
            libLLVMSystemZDesc.a
            libLLVMSystemZDisassembler.a
            libLLVMSystemZInfo.a
            libLLVMTableGen.a
            libLLVMTarget.a
            libLLVMTextAPI.a
            libLLVMTransformUtils.a
            libLLVMVectorize.a
            libLLVMWebAssemblyAsmParser.a
            libLLVMWebAssemblyCodeGen.a
            libLLVMWebAssemblyDesc.a
            libLLVMWebAssemblyDisassembler.a
            libLLVMWebAssemblyInfo.a
            libLLVMWindowsManifest.a
            libLLVMX86AsmParser.a
            libLLVMX86CodeGen.a
            libLLVMX86Desc.a
            libLLVMX86Disassembler.a
            libLLVMX86Info.a
            libLLVMXCoreCodeGen.a
            libLLVMXCoreDesc.a
            libLLVMXCoreDisassembler.a
            libLLVMXCoreInfo.a
            libLLVMXRay.a
            libLTO.dylib
            libRemarks.dylib)

    set(OTHERS
            #${CMAKE_SOURCE_DIR}/lib/libz3.so
            ${Z3_LIB_DIR}/libz3.a
            #rt
            dl
            #tinfo
            pthread
            )

    set(CLANG_LIBS
            libclang.dylib
            libclang-cpp.dylib
            libclangAnalysis.a
            libclangARCMigrate.a
            libclangAST.a
            libclangASTMatchers.a
            libclangBasic.a
            libclangCodeGen.a
            libclangCrossTU.a
            libclangDependencyScanning.a
            libclangDirectoryWatcher.a
            libclangDriver.a
            libclangDynamicASTMatchers.a
            libclangEdit.a
            libclangFormat.a
            libclangFrontend.a
            libclangFrontendTool.a
            libclangHandleCXX.a
            libclangHandleLLVM.a
            libclangIndex.a
            libclangLex.a
            libclangParse.a
            libclangRewrite.a
            libclangRewriteFrontend.a
            libclangSema.a
            libclangSerialization.a
            libclangStaticAnalyzerCheckers.a
            libclangStaticAnalyzerCore.a
            libclangStaticAnalyzerFrontend.a
            libclangTesting.a
            libclangTooling.a
            libclangToolingASTDiff.a
            libclangToolingCore.a
            libclangToolingInclusions.a
            libclangToolingRefactoring.a
            libclangToolingSyntax.a
            libclangTransformer.a
            )
elseif ()
    set(LLVM_LIBS
            libLLVM.so
            libLLVM-11.0.0.so
            libLLVM-11.so
            libLLVMAArch64AsmParser.a
            libLLVMAArch64CodeGen.a
            libLLVMAArch64Desc.a
            libLLVMAArch64Disassembler.a
            libLLVMAArch64Info.a
            libLLVMAArch64Utils.a
            libLLVMAggressiveInstCombine.a
            libLLVMAMDGPUAsmParser.a
            libLLVMAMDGPUCodeGen.a
            libLLVMAMDGPUDesc.a
            libLLVMAMDGPUDisassembler.a
            libLLVMAMDGPUInfo.a
            libLLVMAMDGPUUtils.a
            libLLVMAnalysis.a
            libLLVMARMAsmParser.a
            libLLVMARMCodeGen.a
            libLLVMARMDesc.a
            libLLVMARMDisassembler.a
            libLLVMARMInfo.a
            libLLVMARMUtils.a
            libLLVMAsmParser.a
            libLLVMAsmPrinter.a
            libLLVMAVRAsmParser.a
            libLLVMAVRCodeGen.a
            libLLVMAVRDesc.a
            libLLVMAVRDisassembler.a
            libLLVMAVRInfo.a
            libLLVMBinaryFormat.a
            libLLVMBitReader.a
            libLLVMBitstreamReader.a
            libLLVMBitWriter.a
            libLLVMBPFAsmParser.a
            libLLVMBPFCodeGen.a
            libLLVMBPFDesc.a
            libLLVMBPFDisassembler.a
            libLLVMBPFInfo.a
            libLLVMCFGuard.a
            libLLVMCodeGen.a
            libLLVMCore.a
            libLLVMCoroutines.a
            libLLVMCoverage.a
            libLLVMDebugInfoCodeView.a
            libLLVMDebugInfoDWARF.a
            libLLVMDebugInfoGSYM.a
            libLLVMDebugInfoMSF.a
            libLLVMDebugInfoPDB.a
            libLLVMDemangle.a
            libLLVMDlltoolDriver.a
            libLLVMDWARFLinker.a
            libLLVMExecutionEngine.a
            libLLVMExtensions.a
            libLLVMFrontendOpenACC.a
            libLLVMFrontendOpenMP.a
            libLLVMFuzzMutate.a
            libLLVMGlobalISel.a
            libLLVMHexagonAsmParser.a
            libLLVMHexagonCodeGen.a
            libLLVMHexagonDesc.a
            libLLVMHexagonDisassembler.a
            libLLVMHexagonInfo.a
            libLLVMInstCombine.a
            libLLVMInstrumentation.a
            libLLVMInterpreter.a
            libLLVMipo.a
            libLLVMIRReader.a
            libLLVMJITLink.a
            libLLVMLanaiAsmParser.a
            libLLVMLanaiCodeGen.a
            libLLVMLanaiDesc.a
            libLLVMLanaiDisassembler.a
            libLLVMLanaiInfo.a
            libLLVMLibDriver.a
            libLLVMLineEditor.a
            libLLVMLinker.a
            libLLVMLTO.a
            libLLVMMC.a
            libLLVMMCA.a
            libLLVMMCDisassembler.a
            libLLVMMCJIT.a
            libLLVMMCParser.a
            libLLVMMipsAsmParser.a
            libLLVMMipsCodeGen.a
            libLLVMMipsDesc.a
            libLLVMMipsDisassembler.a
            libLLVMMipsInfo.a
            libLLVMMIRParser.a
            libLLVMMSP430AsmParser.a
            libLLVMMSP430CodeGen.a
            libLLVMMSP430Desc.a
            libLLVMMSP430Disassembler.a
            libLLVMMSP430Info.a
            libLLVMNVPTXCodeGen.a
            libLLVMNVPTXDesc.a
            libLLVMNVPTXInfo.a
            libLLVMObjCARCOpts.a
            libLLVMObject.a
            libLLVMObjectYAML.a
            libLLVMOption.a
            libLLVMOrcError.a
            libLLVMOrcJIT.a
            libLLVMPasses.a
            libLLVMPerfJITEvents.a
            libLLVMPowerPCAsmParser.a
            libLLVMPowerPCCodeGen.a
            libLLVMPowerPCDesc.a
            libLLVMPowerPCDisassembler.a
            libLLVMPowerPCInfo.a
            libLLVMProfileData.a
            libLLVMRemarks.a
            libLLVMRISCVAsmParser.a
            libLLVMRISCVCodeGen.a
            libLLVMRISCVDesc.a
            libLLVMRISCVDisassembler.a
            libLLVMRISCVInfo.a
            libLLVMRISCVUtils.a
            libLLVMRuntimeDyld.a
            libLLVMScalarOpts.a
            libLLVMSelectionDAG.a
            libLLVMSparcAsmParser.a
            libLLVMSparcCodeGen.a
            libLLVMSparcDesc.a
            libLLVMSparcDisassembler.a
            libLLVMSparcInfo.a
            libLLVMSupport.a
            libLLVMSymbolize.a
            libLLVMSystemZAsmParser.a
            libLLVMSystemZCodeGen.a
            libLLVMSystemZDesc.a
            libLLVMSystemZDisassembler.a
            libLLVMSystemZInfo.a
            libLLVMTableGen.a
            libLLVMTarget.a
            libLLVMTextAPI.a
            libLLVMTransformUtils.a
            libLLVMVectorize.a
            libLLVMWebAssemblyAsmParser.a
            libLLVMWebAssemblyCodeGen.a
            libLLVMWebAssemblyDesc.a
            libLLVMWebAssemblyDisassembler.a
            libLLVMWebAssemblyInfo.a
            libLLVMWindowsManifest.a
            libLLVMX86AsmParser.a
            libLLVMX86CodeGen.a
            libLLVMX86Desc.a
            libLLVMX86Disassembler.a
            libLLVMX86Info.a
            libLLVMXCoreCodeGen.a
            libLLVMXCoreDesc.a
            libLLVMXCoreDisassembler.a
            libLLVMXCoreInfo.a
            libLLVMXRay.a
            libLTO.so
            libLTO.so.11
            libRemarks.so
            libRemarks.so.11)

    set(OTHERS
            #${CMAKE_SOURCE_DIR}/lib/libz3.so
            ${Z3_LIB_DIR}/libz3.so
            rt
            dl
            tinfo
            pthread
            )

    set(CLANG_LIBS
            libclang.so
            libclang.so.11
            libclang-cpp.so
            libclang-cpp.so.11
            libclangAnalysis.a
            libclangARCMigrate.a
            libclangAST.a
            libclangASTMatchers.a
            libclangBasic.a
            libclangCodeGen.a
            libclangCrossTU.a
            libclangDependencyScanning.a
            libclangDirectoryWatcher.a
            libclangDriver.a
            libclangDynamicASTMatchers.a
            libclangEdit.a
            libclangFormat.a
            libclangFrontend.a
            libclangFrontendTool.a
            libclangHandleCXX.a
            libclangHandleLLVM.a
            libclangIndex.a
            libclangLex.a
            libclangParse.a
            libclangRewrite.a
            libclangRewriteFrontend.a
            libclangSema.a
            libclangSerialization.a
            libclangStaticAnalyzerCheckers.a
            libclangStaticAnalyzerCore.a
            libclangStaticAnalyzerFrontend.a
            libclangTesting.a
            libclangTooling.a
            libclangToolingASTDiff.a
            libclangToolingCore.a
            libclangToolingInclusions.a
            libclangToolingRefactoring.a
            libclangToolingSyntax.a
            libclangTransformer.a
            )
endif ()