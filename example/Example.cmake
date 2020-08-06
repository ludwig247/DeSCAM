include(add_example/AddExample.cmake)
# Add a new example, it's description and it's directory using macro "add_example".
#	example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)
#
# Note: If example directory is not specified, it'll be assumed that plugin directory has the same name as the example itself.
#
#
add_example(Bus; Print_ITL_Tests )
add_example(FIFO; Print_ITL_Tests)
add_example(FPI; Print_ITL_Tests)
#add_example(I2C; Print_ITL_Tests)
#add_example(Framer; Print_ITL_Tests)
add_example(Paper; Print_ITL_Tests)
#add_example(operation-pipeline; Print_ITL_Tests)
#add_example(RISCV_ISA)
#add_example(Whishbone)
#add_example(example_test)
#add_example(does_not_make_sense; A_Test; nonsense)
#
# Updates the list of add_subdirectory according to the add_example macros activated
update_list()