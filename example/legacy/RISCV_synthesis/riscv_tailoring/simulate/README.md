## How to run simulation or generate activity file (\*.saif)
**_Step 1:_**
Put testbench files to **testbench_files** folder. Alternatively define testbench files in **import\_files.sh**. If memory module is used, don't forget to modify it so it would point to valid memory initialization file.

**_Step 2:_**
Put design files (RTL or Gate-level netlist) to **design_files** folder. All used libraries have to be added to this folder as well. Alternatively define design files in **import\_files.sh**.

**_Step 3:_**
Modify **import\_files.sh** by following the instructions within the file.

**_Step 4:_** In order to generate activity file modify **generate\_saif.tcl** (define output file location and name, specify which signal activity should be tracked and specify desired simulation length).

**_Step 5:_** Execute **run\_simulation.sh** to run simulation in graphical environment or execute **generate\_saif.sh** to generate activity file.

