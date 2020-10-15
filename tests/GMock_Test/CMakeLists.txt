project(GMock_Test CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#find_package(GTest REQUIRED)
#find_package(GMock REQUIRED)

add_executable(GMock_Test main.cpp)
target_compile_options(GMock_Test PRIVATE -fPIC -O2 )

#TODO: factory should not be included
target_link_libraries(GMock_Test PRIVATE parser)


target_link_libraries(GMock_Test PRIVATE /import/lab/users/burr/DeSCAM/lib/libgmock.a
        /import/lab/users/burr/DeSCAM/lib/libgmock_main.a
        /import/lab/users/burr/DeSCAM/lib/libgtest.a
        /import/lab/users/burr/DeSCAM/lib/libgtest_main.a pthread)

include_directories(tests/mocks/modelFactory)