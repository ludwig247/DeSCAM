macro (add_test)
    set(macro_arg ${ARGN})
    list(LENGTH macro_arg num_macro_arg)
    if(${num_macro_arg} LESS 1 OR ${num_macro_arg} GREATER 3)
        MESSAGE(FATAL_ERROR "wrong use of \"add_test\"!!!! You need to give at least the name of your TEST.")
    elseif(${num_macro_arg} EQUAL 1)
        list(GET macro_arg 0 first_arg)
        MESSAGE(WARNING "You didn't give a description to your test ${first_arg}")
        list(APPEND TEST_NAMES ${first_arg})
        list(APPEND TEST_DESCRIPTIONS "")
        list(APPEND TEST_DIRECTORIES ${first_arg}) # defaUlt will be same as TEST name
    elseif(${num_macro_arg} EQUAL 2)
        list(GET macro_arg 0 first_arg)
        list(GET macro_arg 1 second_arg)
                   MESSAGE(STATUS "add_TEST ${first_arg} ${second_arg} ${TEST_NAMES}")
        list(APPEND TEST_NAMES ${first_arg})
        list(APPEND TEST_DESCRIPTIONS ${second_arg})
        list(APPEND TEST_DIRECTORIES ${first_arg}) # defualt will be same as TEST name
    elseif(${num_macro_arg} EQUAL 3)
        list(GET macro_arg 0 first_arg)
        list(GET macro_arg 1 second_arg)
        list(GET macro_arg 2 third_arg)
                   #MESSAGE(STATUS "add_TEST ${first_arg}")
        list(APPEND TEST_NAMES ${first_arg})
        list(APPEND TEST_DESCRIPTIONS ${second_arg})

        list(APPEND TEST_DIRECTORIES ${third_arg}) # always append the directory even if it's repeated,
        # later before adding the subdirectories duplicates will be removed

    endif ()
endmacro(add_test)

add_test(I2C; "something")