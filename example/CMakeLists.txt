include(add_example/AddExample.cmake)

# Add a new example, it's description and it's directory using macro "add_example".
#	example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)
#
# Note: If example directory is not specified, it'll be assumed that plugin directory has the same name as the example itself.
add_example(Bus; Print_ITL_Tests )
#add_example(FIFO; Print_ITL_Tests)
add_example(FPI; Print_ITL_Tests)
#add_example(I2C; Print_ITL_Tests)
add_example(Framer; Print_ITL_Tests)
add_example(Paper; "Print_ITL_Tests")
#add_example(operation-pipeline;Print_ITL_Tests)
#add_example(RISCV_ISA)
#add_example(Whishbone)
#add_example(example_test)
#add_example(does_not_make_sense; A_Test; nonsense)



add_subdirectory(Bus)
add_subdirectory(Framer)
#add_subdirectory(SingleMasterMultiSlave)
add_subdirectory(FPI)
#add_subdirectory(FIFO)
#add_subdirectory(tests)
add_subdirectory(Whishbone)
#add_subdirectory(I2C)
#add_subdirectory(Comm_Test_newInterfaces)
#add_subdirectory(operation-pipeline)
#add_subdirectory(UART_NORDIC)
#add_subdirectory(RISCV_Test_ELF)
