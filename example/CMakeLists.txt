# Add a new example, it's description and it's directory using macro "add_example".
#	example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)
#
# Note: If example directory is not specified, it'll be assumed that example directory has the same name as the example itself.

include(AddExample.cmake)
add_example(Bus; "What busses do")
#add_example(FIFO;) #not working
add_example(myFPI; "unsure" ;FPI)
#add_example(I2C; "Print_ITL_Tests" )
add_example(Framer; "Print_ITL_Tests")
add_example(Paper; "Print_ITL_Tests")
add_example(Whishbone;)









