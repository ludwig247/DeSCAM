#Guildline on writing tests with LUBIS

1. The tests folder are a reflection (same name, same typing) of the folders within the src/
2. There is a folder name ClassName_Tests for each class containing the unit tests for this class. 
If there is a class TestClass in src/parser then there exists a folder tests/parser/TestClass_Tests
3. For each test a CMake has to be added that allows to compile and run the test. The executeable is named as the test. 
4. Tests that are not related to a specific class are put into the folder other

#TestCases
The folder contains tests cases. We use these tests to run integration tests (e.g. with PrintITL_Tests). 
They are a collection of minimal modules allowing to should ideally test the entire code of the design. 



