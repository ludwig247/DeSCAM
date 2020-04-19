#file=./tests.txt
#
#egrep -v '^//|^[[:space:]]*$' < $file|
#while IFS= read -r test; do
#  exec 2> ./error_files/error_file_$test
#  cmake --build ../../cmake-build-debug --target $test
#
#if [ $? -eq 0 ]; then
#     echo "==== build $test SUCCESS ===="
#     export MY_OPTION="TRUE"
#else
#     echo "==== build $test FAILED ===="
#     export THING="FALSE"
#fi
#done

cmake --build ../../cmake-build-debug --target Compile_ESL_Test_Run


