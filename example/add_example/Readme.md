# AddExample-macro

The AddExample-macro provides the user with features that eases the adding of a new example to the DeSCAM-Project.

**These features include:**
* Providing a list of the header-files required to run the "Print-ITL-Tests" on the example.
* Includes the example in the [Compile_ESL_tests](../../tests/Compile_ESL_Tests), 
which builds to test if all examples builds successfully and produces a report in the format of a json-script.
* Creating a new template directory tree including required CMakeLists.txt-files 
when adding new example.


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

To include a new example, add the macro "add_example()" to the [CMakeLists.txt](../CMakeLists.txt) in the parent "example"-directory, 
specifying name, description and example directory.

*example: add_example(PrintMYStyle; PrintITL; MYStyleDirectory)*

Note that if the name of the example directory is not specified, 
the macro will assume that the name of the directory is the same as the name of the example.

Add_Example automatically adds "add_subdirectory()" for the new example to the [CMakeLists.txt](../CMakeLists.txt) in the parent "example"-directory
for Cmake to recognize the build-target.
Every time the add_example