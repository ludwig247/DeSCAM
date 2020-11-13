project(Optimizer_Tests C CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")


#DIRECTORIES src/FindCfgPaths/FindCfgPaths_test.h
set(SOURCE_FILES tests.cpp)
file(GLOB optFiles "src/*/*.h")
set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/plugin/PrintITL/DatapathVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/plugin/PrintITL/ConditionVisitor.cpp
        )

add_executable(Optimizer_Tests ${SOURCE_FILES} ${GLOBAL_FILES} ${optFiles})

target_include_directories(Optimizer_Tests PUBLIC src)

target_link_libraries(Optimizer_Tests parser)
target_link_libraries(Optimizer_Tests ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)
