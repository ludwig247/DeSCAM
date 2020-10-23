# DeSCAM
![](https://github.com/ludwig247/DeSCAM/workflows/DESCAM-BUILD/badge.svg)

# Getting started with Property-Driven Development (PDD)

1) Installing the tool 
    * Read the Install.md

2) Understand the SystemC-PPA with the example in <path-to-root>/HowTo/GettingStarted/ESL/
    1) Compile the example: <br>
       `cd <path-to-root>/doc/Howto/GettingStarted/ESL/`   
       `mkdir build && cd build` <br>
       `cmake ../ && make`
       
    2) Run the example with: <br>
    `./GettingStarted`
    
    3) The files MasterDummy, SlaveDummy and main.cpp are meant to model the environment, they are the testbench.
    What we want to implement is the design in Switch.h. Get yourself familiar with the SystemC subset
    
3) Read the manual in doc/manual. The manual should teach you the fundamental ideas of PDD.     
    
4) Create & Load the project:
    1) Generate the VHDL skeleton for your implementation: <br>
        `./DESCAM --file <path-to-root>/HowTo/GettingStarted/ESL/Switch.h --output <output-dir> -PrintSkeleton` <br>
        or the Verilog skeleton
        `./DESCAM --file <path-to-root>/HowTo/GettingStarted/ESL/Switch.h --output <output-dir> -PrintSkeleton --sv` <br>
    2) Generate the ITL properties for your implementation: <br>
     `./DESCAM --file <path-to-root>/HowTo/GettingStarted/ESL/Switch.h --output <output-dir> -PrintITL` <br>
      or for SVA properties <br> 
    `./DESCAM --file <path-to-root>/HowTo/GettingStarted/ESL/Switch.h --output <output-dir> -PrintSVA` <br>
    3) Open your property checker (e.g. onespin) and load the design by loading the design. 
    Make sure, the type definitions are loaded first. 
    4) Load the properties. Make sure, that you load the macros first
    5) Try to prove the reset properties (it should fail)
    
5) Implement & Refine:<br> The goal is to implement the design and thereby fill the macros/function bodies with information from the design.
    Initially, the bodies are empty or filled with placeholder values.  
    1) Analyse the counter example of the reset property. Is this a design problem or a refinment property? 
    In this case it's a refinement issues. To prove the reset property:
        - Refine the macros/functions used in the commitment of the reset with the signal from the design. For example:
        ```sva
         function master_out_notify;
         	master_out_notify = Switch.master_out_notify ;
         endfunction 
       ```
        - For SVA: refine the binding of reset signal with:
        ```sva
         	bind Switch Switch_verification inst (.*, .reset(rst));
       ```
    The reset property holds, if everything is refined correctly. 
           
    2) Continue implementing all operations leaving the first important state (master_in_1) after reset 
    3) Continue until all operations hold on the design

6) Hints: 
    * Solve name collisions between RTL and macros/function by removing/commenting the macros or renaming the RTL signals.
    * `Instance: -I No main found, can't create nestlist` <br>
    This message is only relevant you provide a main and you're interested in the connection of the instances.
    If you just provide a module, you're free to ignore it.   
    * If your module does not provide any functions, the generated functions file will be empty.
    * PrintSVA: binding of the reset. Make sure the reset is correctly bound to the abstract reset:<br>
    `bind Switch Switch_verification inst (.*, .reset(rst));`
    * SystemVerilog / ITL: 
      If this combination is used, please set the following flags in OneSpin before loading the prpoerties. 
        * `set_itl_flavor vhi` 
        * `set_reset_sequence -high Switch/rst`
    * SystemVerilog / SVA:
      Error: <br>
      `-E- Unsupported trigger for Property sva/inst/reset_a - must be a clock signal` <br>
      Solution: add something to the clocked part of the process of the SystemVeriolog file, e.g.:
      replace `// FILL OUT HERE` with `master_in_notify <= 1'b0;`. This enables correct clock detection. 
   
 
