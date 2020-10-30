add_subdirectory(Print_ITL_Tests)
add_subdirectory(Compile_ESL_Tests)
add_subdirectory(PrintSkeleton_Test)
add_subdirectory(DataType_Test)
add_subdirectory(Module_Test)
#add_subdirectory(Model_Test) #there are some issues regarding compatibility btw TEST and actual methods
add_subdirectory(ExprTranslator_Test)
add_subdirectory(StmtNodeAlloc_Test)
add_subdirectory(SimplifyVisitor_Test)
add_subdirectory(Stmts_Test)
add_subdirectory(Optimizer_Test)
add_subdirectory(GMock_Test)


add_subdirectory(operationFactory)
add_subdirectory(global)

#find_file(
#        TEST_FILE
#        NAMES "Bus_new.h"
#        PATHS /import/lab/users/hesselberg/Simon_repo/DeSCAM/example/Bus ENV TEST
#        PATH_SUFFIXES "ESL"
#        NO_DEFAULT_PATH
#)
#message(STATUS ".h => ${TEST_FILE}")
#
#file(GLOB SOURCES
#        ../example/Bus/ESL/*.h
#        )
#message(STATUS ".h => ${SOURCES}")
