# Getting started with PDD

1) Installing the tool 
    * Use a linux of your choice 
    * Recommended is Ubuntu 14.04+ 
    * Edit the script in install/install_new.sh (see comments in file) 
    * Run the script to install
    * If the installation worked correctly, you should find a binary "DESCAM" in bin/

2) Read the manual in doc/manual. The manual should teach you the fundamental ideas of PDD. 

3) Implement your first project:
    1) Generate the skeleton for your implementation: <br>
        `./DESCAM --file <path-to-root>/example/Bus/ESL/Bus_new.h --output <output-dir> -PrintSkeleton`
    2) Generate the ITL properties for your implementation: <br>
     `./DESCAM --file <path-to-root>/example/Bus/ESL/Bus_new.h --output <output-dir> -PrintITL` <br>
      or for SVA properties <br> 
    `./DESCAM --file <path-to-root>/example/Bus/ESL/Bus_new.h --output <output-dir> -PrintSVA` <br>
    3) Open your property checker (e.g. onespin) and load the design and properties
    4) Start implementing by filling the macros/functions such the reset property holds
    5) Continue implementing all operatin leaving the first important state after reset 
    6) Continue until all operations hold on the designs 

    

    
    
        
       
