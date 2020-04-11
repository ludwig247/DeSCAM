echo "This is a shell"
value=$(<tests.txt)
echo "$value"

file=./tests.txt
#grep -v '//' < $file|
#while IFS=" ;" read -r a b c; do
#    echo a: $a b: $b c: $c
#done

#mkdir build
#cd ../../cmake-build-debug


egrep -v '^//|^[[:space:]]*$' < $file|
while IFS= read -r test; do
  cmake --build ../../cmake-build-debug --target $test

    echo ===="$test SUCC"=====
done
cd ../../cmake-build-debug
make