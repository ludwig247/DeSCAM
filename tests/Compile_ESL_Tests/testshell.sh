exec 2> error_file
#exec 2>&1

file=./tests.txt

egrep -v '^//|^[[:space:]]*$' < $file|
while IFS= read -r test; do
  cmake --build ../../cmake-build-debug --target $test

if [ $? -eq 0 ]; then
     echo "==== build $test SUCCESS ===="
else
     echo "==== build $test FAILED ===="
fi
done

#cd ../../cmake-build-debug
#egrep -v '^//|^[[:space:]]*$' < $file|
#while IFS= read -r test; do
#make $test
#done
