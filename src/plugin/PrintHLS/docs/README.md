Automatic Generation of RTL Models using DeSCAM and Vivado HLS
-----

The purpose of this plugin is the automatic generation of RTL models using DeSCAM and 
Vivado HLS

####User Guide:

* Open the file **generate_model.sh** in the **Scripts** directory.
* Enter your paths for _DeSCAM_, _Vivado HLS_, _Onespin_ and _Python_ (Version 3.6+ is required)
* run **generate_model.sh** (For usage run with -h or --help)
* keep **check_hls_output.py** in the same directory as **generate_model.sh** if running with --vivado_hls option

The resulting folder structure looks like this:

```
├── Module1
│   ├── HLS
│   │   ├── directives
│   │   │   └── Module1_directives.tcl
│   │   ├── Module1.cpp
│   │   ├── Module1_data_Types.h
│   │   ├── Module1_functions.h
│   │   ├── hls_script
│   │   │   └── Module1_run_hls.tcl
│   │   ├── synthesis
│   ├── Properties
│   │   ├── Module1_macros.vhi
│   │   ├── Module1_functions.vhi
│   │   └── Module1.vhi
│   └── RTL
│       ├── Module1_operations.vhd
│       ├── Module1_types.vhd
│       └── Module1.vhd
├── Module2
│   ├── ...
```

For each module a separate directory is created, which contains a folder for high level synthesis
files (HLS), property files (Properties) and RTL files (RTL). The HLS folder contains the files 
for the high level synthesis, one folder where the directives are stored, another folder where 
the script to run the high level synthesis is stored. The results of the high level synthesis are
written into the synthesis folder. Changes to the project can be made by loading the _synthesis_ 
folder as a project in Vivado HLS. This can also be done with the command `vivado_hls -p synthesis`.

The properties folder contains all files used for formal verification in onespin. The RTL folder contains
all VHDL files for the module.
 
 
Vivado HLS
----                                                       
                                                              
Vivado HLS is a well-known High Level Synthesis tool. The figure below shows the design flow of 
the tool. Vivado HLS synthesizes a C function, which can be written in C, C++ or SystemC. This 
function (Top Function) is the primary input for Vivado HLS and can contain a hierarchy of 
subfunctions. Another necessary input are the constraints, which contain information about the 
clock period, the clock uncertainty and a target FPGA. Furthermore, optional directives can be 
specified to control the synthesis process to achieve a certain behaviour or to optimize the RTL 
design.

![Design Flow in Vivado HLS](Vivado_HLS.png)

There is the possibility to write C test benches and simulate the C functions before synthesis
and verify the RTL output using the C/RTL co-simulation. Since we are pursuing the Property 
Driven Development Design Flow in this thesis, verification by simulation will not be discussed 
in more detail.

The C-based source code, directives and constraints can be added interactively in a Vivado HLS 
project via the graphical user interface (GUI) or via Tcl commands in the command prompt. 
Alternatively, Tcl scripts can be created and the commands executed in batch mode.

The primary output are RTL implementation files in hardware description language (HDL) formats, 
in the industry standard VHDL and Verilog. Vivado HLS packages the implementation files as an 
IP block for use with other tools in Xilinx Design Flow.

Vivado HLS also generates a synthesis report. The report provides details about performance and 
area of the RTL design. For example, information about the latency and initiation interval for 
the block and all sub-blocks instantiated in this block (respectively top function and 
sub-functions) are shown. The latency is the number of clock cycles required to generate the 
output. The Initiation Interval is the number of cycles before new inputs can be created 
(for designs without pipelining the initiation interval is one clock cycle greater than the 
latency). Furthermore there is a report about the required resources like memory, FIFOs, 
registers, multiplexers and expressions and an overview of the RTL ports with their respective 
protocols.

####Language Support

Vivado HLS supports many C, C++ and SystemC language constructs and is able to synthesize a 
large subset of modeling standard. However, there are some language constructs that are not 
support by high level synthesis.

All data of an RTL design must be read from input ports or written to output ports, thus the 
C function must implement all functionality and must not depend on calls to system functions 
or the underlying operating system. Therefore, system calls such as _printf()_, 
_sleep()_, and so on, cannot be synthesized. But some of these functions are supported 
by the C simulation and can be used for debugging. These system calls are then ignored during 
the synthesis.

Since hardware has a fixed set of resources, dynamic memory allocation is not supported. All 
memory requirements have to be either outside the function scope or have fixed limits known at 
compile time. Furthermore, recursive functions cannot be synthesized. Many of the C++ Standard 
Template Libraries (STLs) use dynamic memory allocation or contain recursive functions. Therefore 
STLs are not supported by Vivado HLS.

####High-Level Synthesis C Libraries

The Vivado HLS C libraries enable easy design and function of common hardware modeled in C and
synthesized to RTL. For example, there are libraries for Digital Signal Processing, Linear 
Algebra, Video and Filter. One library that is frequently used in this work is the 
_Abitrary Precision Data Types Library_: C-based native data types are only on 8-bit 
boundaries. RTL on the other hand supports arbitrary lengths. For area optimization it is 
therefore crucial that we do not rely on the boundaries of native C data types. For example, 
if a 17-bit adder or multiplier is required, we should not be forced to use a 32-bit adder or 
multiplier. Vivado HLS provides both integer and fixed-point data types of arbitrary precision 
for C and C++, and supports the arbitrary precision data types of the SystemC library.

####Interfaces

With C-based designs, input and output operations are executed in zero time via function 
parameters. The same operations are performed in RTL designs through input and output ports 
using I/O protocols. When the top-level function is synthesized, the arguments are synthesized 
into RTL ports. This process is called _interface synthesis_. Vivado HLS creates three 
types of ports on the RTL design:

* **Clock and Reset Ports:** If the design takes more than one clock cycle to complete the 
operation, Vivado HLS generates a reset port (_ap\_rst_) and a clock port 
(_ap\_clk_) for the RTL design.
* **Block-Level Interface Protocol:**  By default, a block-level interface protocol is added 
to the design with the port _ap\_start_, _ap\_ready_, _ap\_done_ and 
_ap\_idle_. These signals control the block regardless of any port-level I/O protocols. 
* **Port-Level Interface Protocol:**  The port-level protocol created for each function 
argument and for the function return (except void) depends on the C type and its default 
protocol. For scalars, arrays, pointers and references there are different protocols for input 
and output arguments. Function arguments which are both read and written are split into an input 
and output port at RTL. 

####Directives

Vivado HLS offers the user several options for optimizing the design. _Directives_ can 
be used to control Vivado HLS to create a design that meets the desired performance and area 
goals. Thus, different implementations are possible for the same source description. For example, 
a loop can be unrolled for better latency or can be pipelined for better throughput. The 
_directives_ are prioritized differently during synthesis. Ensuring that performance 
(clock and throughput) is maintained has the highest priority. Afterwards the latency is minimized
and finally the area is minimized.

_Directives_ can either be inserted as pragmas directly into the source code or can 
be entered using directive script files. Both have their advantages: With the help of pragmas 
it is directly visible in the code where optimizations for the synthesis have been made. Script 
files can be used to create different designs without the need to change the code. Afterwards 
the different designs can be compared.
