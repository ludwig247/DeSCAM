add_subdirectory(Bus)
#add_subdirectory(Framer)
#add_subdirectory(SingleMasterMultiSlave)
add_subdirectory(FPI)
#add_subdirectory(FIFO)
#add_subdirectory(tests)
#add_subdirectory(Whishbone)
#add_subdirectory(I2C)
#add_subdirectory(Comm_Test_newInterfaces)


# Add a new example, it's description and it's directory using macro "add_example".
#	example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)
#
# Note: If example directory is not specified, it'll be assumed that example directory has the same name as the example itself.

include(AddExample.cmake)
add_example(Bus; "What busses do")
#add_example(FIFO;) #not working
add_example(myFPI; "unsure" ;FPI)
#add_example(I2C; "Print_ITL_Tests" )
#add_example(Framer; "Print_ITL_Tests")
#add_example(Paper; "Print_ITL_Tests")
#add_example(RISCV_ISA)
#add_example(Whishbone)









