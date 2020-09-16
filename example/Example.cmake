include(add_example/AddExample.cmake)
# Add a new example, it's description and it's directory using macro "add_example".
#	example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)
#
# Note: If example directory is not specified, it'll be assumed that plugin directory has the same name as the example itself.
#
#
add_example(Bus; Print_ITL_Tests )
add_example(FPI; Print_ITL_Tests)
#add_example(I2C; Print_ITL_Tests)
add_example(Framer; Print_ITL_Tests)
add_example(Paper; Print_ITL_Tests)
#add_example(operation-pipeline; Print_ITL_Tests)
#add_example(RISCV_ISA; Print_ITL_Tests)
#add_example(RISCV_RI5CY; Print_ITL_Tests)
#add_example(RISCV_MS; Print_ITL_Tests)
#add_example(Whishbone; Print_ITL_Tests)
#add_example(example_test)
#add_example(example_with_more_arg; A_Test; test_with_args)
#
# Updates the list of add_subdirectory according to the add_example macros activated
update_list()