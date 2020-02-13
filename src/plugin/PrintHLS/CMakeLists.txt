add_subdirectory(HLS)
add_subdirectory(VHDLWrapper)

add_library(PrintHLS
            PrintHLS.cpp)

target_include_directories(PrintHLS PRIVATE HLS VHDLWrapper)
target_link_libraries(PrintHLS HLS)
target_link_libraries(PrintHLS VHDLWrapper)