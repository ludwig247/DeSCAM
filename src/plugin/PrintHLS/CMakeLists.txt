add_subdirectory(HLS)
add_subdirectory(VHDLWrapper)
add_subdirectory(SynthesisScript)

add_library(PrintHLS
            PrintHLS.cpp)

target_include_directories(PrintHLS PRIVATE HLS VHDLWrapper SynthesisScript)
target_link_libraries(PrintHLS HLS)
target_link_libraries(PrintHLS VHDLWrapper)
target_link_libraries(PrintHLS SynthesisScript)