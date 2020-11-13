set(EXAMPLE_NAMES "")
set(CURRENT_DIR "/home/lanrez/Documents/Thesis/descamv4/tests/other/Compile_ESL_Tests")
set(PROJECT "Compile_ESL_Tests")
set(OUTPUT_FROM_EACH "")

file(GLOB ERROR_FILES_LIST "${CURRENT_DIR}/error_files/*.txt")
foreach(ERROR_FILE_NAME ${ERROR_FILES_LIST})
    get_filename_component(NAME ${ERROR_FILE_NAME} NAME_WLE)
    string(REPLACE "error_file_" "" NAME ${NAME})
    string(REPLACE "_Simulation" "" NAME ${NAME})

    list(FIND EXAMPLE_NAMES "${NAME}" EXAMPLE_ADDED)
    if(EXAMPLE_ADDED EQUAL -1)
        file(REMOVE ${ERROR_FILE_NAME})
        message(STATUS "Example not included anymore: removing ${ERROR_FILE_NAME}")
    endif()
endforeach()

foreach(EXAMPLE_NAME ${EXAMPLE_NAMES})
    set(EXAMPLE_NAME "${EXAMPLE_NAME}_Simulation")
    execute_process(COMMAND ${CMAKE_COMMAND} --build ../../cmake-build-debug --target ${EXAMPLE_NAME}
    WORKING_DIRECTORY ${CURRENT_DIR} RESULT_VARIABLE RESULT OUTPUT_VARIABLE OUTPUT
    ERROR_FILE ${CURRENT_DIR}/error_files/error_file_${EXAMPLE_NAME}.txt)
#message(STATUS "EXAMPLE_NAME = ${EXAMPLE_NAME}")
#message(STATUS "RESULT = ${RESULT}, OUTPUT = ${OUTPUT}")

    file(STRINGS ${CURRENT_DIR}/error_files/error_file_${EXAMPLE_NAME}.txt ERROR ENCODING UTF-8)
    string(REPLACE "," "" ERROR "${ERROR}")
    string(REPLACE "\"" "\\\"" ERROR "${ERROR}")
    string(REPLACE ";" "\",
    \"" ERROR "${ERROR}")

    if(RESULT EQUAL 0)
     set(SUCCESS "true")
    else()
     set(SUCCESS "false")
    endif()

list(APPEND OUTPUT_FROM_EACH "
   {
    \"test-suite\":\"${PROJECT}\",
    \"test_name\":\"${EXAMPLE_NAME}\",
    \"success\":${SUCCESS},
    \"errors\":[
    \"${ERROR}\"
    ]}")

    string(REPLACE ";" "," OUTPUT_FROM_EACH "${OUTPUT_FROM_EACH}")
    configure_file(${CURRENT_DIR}/error.json.in
            ${CURRENT_DIR}/json_output_files/error_compilation.json @ONLY)

endforeach()
