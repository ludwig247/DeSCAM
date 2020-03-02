
#add_subdirectory(Bus)
#add_subdirectory(Framer)
#add_subdirectory(SingleMasterMultiSlave)
#add_subdirectory(FPI)
#add_subdirectory(FIFO)
#add_subdirectory(tests)
#add_subdirectory(Whishbone)
#add_subdirectory(I2C)
#add_subdirectory(Comm_Test_newInterfaces)



include(AddExample.cmake)

# Add a new example, the directory of the tests it's used for and it's directory using macro "add_example"
#	example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)
#
# Note: If example directory is not specified, it'll be assumed that plugin directory has the same name as the example itself.
add_example(Bus; Print_ITL_Tests )
add_example(FIFO; Print_ITL_Tests)
add_example(FPI; Print_ITL_Tests)
add_example(I2C; Print_ITL_Tests)
add_example(Framer; Print_ITL_Tests)


# configure a header file to pass plugins and options of the CMake settings to the source code
#configure_file (
#        "tests.h.in"
#        "${PROJECT_SOURCE_DIR}/tests/Print_ITL_Tests/TestCases/tests.h"
#)










