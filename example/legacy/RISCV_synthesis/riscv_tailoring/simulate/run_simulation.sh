#!/bin/bash

# Import files
source ./import_files.sh

# Run simulation with user interface
xsim top_sim -gui

# Delete work directory
cd ..
rm -r work









