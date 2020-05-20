##InstrumentPower

The InstrumentPower plugin instruments the code of a SystemC header file provided
 in the argument with code that collects data necessary for power estimation of the
  system level design. To run the plugin run DeSCAM with the following arguments:
                         
     DESCAM -f <input_file>.h -o <output_file_location> -InstrumentPower

When running the plugin for the first time, make sure the DEBUG identifier is set to 1. 
  The program will output information which communication calls will correspond to which state
   number. Next, mark all states in the original header file
  (communication calls) with a comment before the communication call line:
       
    /*State <number_of_state_as_seen_by_DeSCAM>*/
  
This allows the plugin to recognize the corresponding states in the header file. 
This should obviously be automated in future work. Save the changes on the original
header file and run the plugin again, this time with DEBUG set to 0.
  
The output file will hold the name <input_file>_instrumented.h. Once the file is created,
make sure it has no syntax errors (#includes might need different paths depending
on where the output file was saved). 

DeSCAM recognizes all operations, states, system-level variables, etc from the header
file. This plugin attempts to utilize this information to insert code lines that count power-relevant 
events. For now, the plugin inserts only lines that count operations recognized by DeSCAM. 
Further work is needed to insert lines that monitor signal switching. All of the lines
inserted perform counting without disrupting the original functionality of the model
 described.
  
 The plugin has been tested in limited environment, so potential bugs might appear
 when using on new designs! Make sure every event will be counted in the appropriate 
 place. All counting and estimation is performed through a singleton class PowerEstimator. Make sure 
 to include it in the instrumented header file before simulating!


