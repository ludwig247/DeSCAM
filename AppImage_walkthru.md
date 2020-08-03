# Appimage Creation 
## Steps
- Base Container Build and Run: Done in the Test workflow

      * Docker Build
      * Docker Run
      * Docker Check

- Run Master Script: Done in the Test workflow

      * Run Master: This script creates and tests the AppImage inside the Base Container

- AppImage Is Copied Back to the work folder : Done in the Test workflow

      * Copy Image back

- Test on different OSs: Done for different OSs in the Test workflow

      * Docker Build OS
      * Docker Run OS
      * Docker Check OS
      * Run Test OS
      * Stop Container OS

## Debuging

- DSCAM: Adding Code or Altering the code
	This should be seen on the DEFAULT WORKFLOW steps 

- AppImage: 
	Build: The tool helm, failed just once on building, the cration of the AppImage
	       requires this tool to build. More information in Dockerfile
	Run: it is pretty unlikely to fail, it is mainly based on the scripts master and
	     installer, so unless they are changed, it will not fail. In case it fails, 
	     there are messages on WorkFlow Step, and some commands like ls, du -sh, etc
	     can be used to double check the files and its size. 
	     It is important to mention that the installer is run on a chroot inside a docker
	     container, this particular combination does not collect all libraries used, and
	     and copying the results from inside the tempenv folder to the AppImage Folder
	     may end up on some broken links. For this reason, there are some patches on the
	     master script, so probably more of them might be needed. In order debug this 
	     particular issue is better to build and run the Dockerfile locally and test.
	Test: the AppImage is tested on different containers and the log is shown on the 
	      Workflow messages, but sometimes the error might not say much, such the seg
	      fault. Then the problematic Container should be build and run locally and tools
	      such us gdb, strace, valgrind, or using some debugging flags such LD_DEBUG=all.
	      Once the issue is found on local, then the code can be tested on workflow.

## Useful Links
	- http://www.portablelinuxapps.org/docs/1.0/ar01s04.html	
	- https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action
	- https://www.booleanworld.com/creating-linux-apps-run-anywhere-appimage/

## Notes
	-  In the file: Modelglobal.h, the capturing of the env variables has been commented so that it can be
	   complaint with the default build process. In case the development with the AppImage is carried out
	   further, this needs to be uncommented, replacing the default hardcoded values for (SCAM_HOME,ROOT_DIR,
	   etc).
	- As a temporal patch, the install.sh script has been created. Basically running this script will install
	  completely the tool for all the supported OSs. So far only Ubuntu 18.04 and Ubuntu 16.04 covered, but the
	  structure of the script allows to introduce other OSs. It is important to say that the cmake build will
	  work on any Linux Distribution, but this script avoids the end user to care about the required packages.
	  In case a new OS is to be included, the cmake should be run on a clean installation of the desired OS (
	  a docker container) and then all packages required should be included in the scripts as the errors or
	  warnings appear. 
	- There are no steps on the workflow which test the install.sh script on different OSs, but this can be done
	  on a similar way of the images used for the AppImage Test steps, the only change would be the script to run, 
	  which in this case is the install.sh.
