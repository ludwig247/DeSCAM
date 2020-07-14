# Directory: scripts
This folder contains necessary scripts to perform a Power Estimation.

## HowTo: Power Estimation
**_PLEASE NOTE:_**
The conversion from ".wlf" to ".vcd" does not support user-defined data types including arrays. If you want to run Power Estimation for the RISC-V CPU, please use the design in the branch "Riscv\_v3\_power" (without the backslashes). 

- **_Step 1: Generate ".wlf"-File_**
Call up ModelSim by using the "vsim" command. Load and Compile your Design. Next, simulate a TestBench you want to use for Power Estimation and be sure to add every signal in the design to the wave. If you want to do a Power Estimation for the CPU, simulate "CPU_tb.vhd". Afterwards, click "End Simulation". ModelSim should have created a file called "vsim.wlf", which you should copy and rename.

- **_Step 2: Convert ".wlf"-File into a ".vcd"-File_**
Open a terminal and run the following command:
wlf2vcd -o NAME.vcd NAME.wlf
A File called NAME.vcd should have been created.

- **_Step 3: Convert ".vcd"-File into a ".saif"-File_**
Open a terminal and run the following command:
vcd2saif -input NAME.vcd -output NAME.saif
A File called NAME.saif should have been created.

- **_Step 4: Adjust Scripts_**
The next step is to set values and references in the scripts. The following adjustments have to be made:
In "common\_setup\_st.tcl": Specify DESIGN\_NAME and set DESIGN\_REF\_DATA\_PATH to the Library Folder.
In "CPU.constaints.tcl": Change the name of the file in order to match the DESIGN\_NAME. Furthermore specify clk, rst and clk\_period.
In "dc\_setup\_st.tcl": Specify all the sources needed to synthesize the instance you want to run the Power Estimation for.
In "dc\_st.tcl": Specify path to the ".saif"-File as well as the instance, you want to run the Power Estimation for (Both need to be set twice!). For Example, if you want to Estimate the power for the CPU, you need to set the instance to cpu\_tb/IF\_CPU.

- **_Step 5: Perform Power Estimation_**
Open a terminal and switch to the Synopsys Design Compiler by using the "dc_shell" command. Then, use "source run.tcl".
