include_directories(Common)

add_subdirectory(Common)
add_subdirectory(HLS)
add_subdirectory(VHDLWrapper)
add_subdirectory(SynthesisScript)

add_library(PrintHLS
            PrintHLS.cpp)

target_compile_options(PrintHLS PRIVATE -fPIC -O2 )

target_include_directories(PrintHLS PRIVATE HLS VHDLWrapper SynthesisScript CommonHLS)
target_link_libraries(PrintHLS HLS)
target_link_libraries(PrintHLS VHDLWrapper)
target_link_libraries(PrintHLS SynthesisScript)
target_link_libraries(PrintHLS CommonHLS)