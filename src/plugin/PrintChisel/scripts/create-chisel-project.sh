#Call bash create-chisel-project.sh PROJECT_FOLDER_NAME PACKAGE_NAME 

cd /home/lukas/ChiselProjects
git clone https://github.com/ucb-bar/chisel-template.git $1 && echo "cloned"

cd $1
rm -rf .git
git init
git add .gitignore *

sed -i "s/chisel-module-template/$2/g" build.sbt

#cd src/main/scala
#PROJECT_FOLDER_NAME=$1
#PACKAGE_NAME=$2
#shift 2
#for arg do 
#	mkdir $arg
#	cd $arg
	

#done
#mkdir $3
