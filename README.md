# DeSCAM
![](https://github.com/ludwig247/DeSCAM/workflows/DESCAM-BUILD/badge.svg)

# Getting started with Property-Driven Development (PDD)

1) Installing the tool 
    * Use a linux of your choice 
    * Recommended is Ubuntu 14.04+ 
    * Edit the script in install/install_new.sh (see comments in file) 
    * Run the script to install
    * If the installation worked correctly, you should find a binary "DESCAM" in bin/

2) Understand the SystemC-PPA with the example in <path-to-root>/HowTo/GettingStarted/ESL/
    1) Compile the example: <br>
       `cd <path-to-root>/HowTo/GettingStarted/ESL/`   
       `mkdir build && cd build` <br>
       `cmake ../ && make`
       
    2) Runt the example with: <br>
    `./GettingStarted`
    
    3) The files MasterDummy, SlaveDummy and main.cpp are meant to model the environment, they are the testbench.
    What we want to implement is the design in Bus.h. Get yourself familiar with the SystemC subset
    
3) Read the manual in doc/manual. The manual should teach you the fundamental ideas of PDD.     
    
4) Implement your first project:
    1) Generate the skeleton for your implementation: <br>
        `./DESCAM --file <path-to-root>/HowTo/GettingStarted/ESL/Bus.h --output <output-dir> -PrintSkeleton`
    2) Generate the ITL properties for your implementation: <br>
     `./DESCAM --file <path-to-root>/HowTo/GettingStarted/ESL/Bus.h --output <output-dir> -PrintITL` <br>
      or for SVA properties <br> 
    `./DESCAM --file <path-to-root>/HowTo/GettingStarted/ESL/Bus.h --output <output-dir> -PrintSVA` <br>
    3) Open your property checker (e.g. onespin) and load the design and properties
    4) Start implementing by filling the macros/functions such the reset property holds
    5) Continue implementing all operations leaving the first important state after reset 
    6) Continue until all operations hold on the designs 

    

    





