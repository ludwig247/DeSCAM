# AddExample-macro

The AddExample-macro provides the user with features that eases the adding of a new example to the DeSCAM-Project.
In order to add a new example include it in the [Examples.cmake](../Examples.cmake) and the AddExample-macro will do the rest of the work.
Comment/uncomment the add_example() in order to deactivate/activate the macro for one particular example.

**These features include:**
* Providing a list of the header-files required to run the "Print-ITL-Tests" on the example.
* Includes the example in the [Compile_ESL_tests](../../tests/Compile_ESL_Tests), 
which builds to test if all examples builds successfully and produces a report in the format of a json-script.
* Creating a new template directory tree including required CMakeLists.txt-files 
when adding new example.
* Automatic comment out or uncomment add_subdirectory in [add_subdirectory.cmake](../add_subdirectory.cmake) according to if the respective add_example is activated or not.

***Important remarks:***
The directory tree of the example should look like this:

```
/example/"example_name"
├── ESL                     # Electronic System Level-files
│   ├── env                 # All files regarding the environment for the example, including main.cpp
│   ├── example_name.h      # SystemC-PPA
│   └── CMakeLists.txt      #
├── RTL                     # VHDL/Verilog-files
│   ├── properties          # Dir
│   ├── testbench           # Dir
│   └── CMakeLists.txt      # 
└── CMakeLists.txt
```
* Organize the files regarding environment in a separate folder inside the ESL-folder
in the new example named "env", the rest in parent-folder "ESL"
* For the "Compile_ESL_Tests" to recognize the build-target of the new example when run, 
it is important that the target specified in the "add_executable()" ends with  "_Simulation", e.g. "myexample_simulation",
otherwise the test-build will fail.

To include a new example, add the macro "add_example()" to the [Example.cmake](../Example.cmake) in the parent "example"-directory, 
specifying name, description and example directory.

*example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)*

Note that if the name of the example directory is not specified, 
the macro will assume that the name of the directory is the same as the name of the example.

Add_example automatically adds "add_subdirectory()" for the new example to the [add_subdirectory.cmake](../add_subdirectory.cmake) in the parent "example"-directory
for Cmake to recognize the build-target.
CMake will comment out/uncomment the add_subdirectory() according to if the add_example for the example is commented out or not.