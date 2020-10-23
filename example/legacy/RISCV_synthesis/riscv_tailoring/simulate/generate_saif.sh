#!/bin/bash

# Remove previous activity file
rm -f design_files/activity.saif

# Import files
source ./import_files.sh

# Run simulation and generate activity file
xsim top_sim -t ../generate_saif.tcl

# Delete work directory
cd ..
rm -r work









