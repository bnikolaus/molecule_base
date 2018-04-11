#!/bin/bash

molecule_path=`pwd`
role_path="./roles"

# Colors
BLACK="\033[0;30m"        # BLACK
RED="\033[0;31m"          # RED
GREEN="\033[0;32m"        # GREEN
YELLOW="\033[0;33m"       # YELLOW
BLUE="\033[0;34m"         # BLURE
PURPLE="\033[0;35m"       # PURPLE
CYAN="\033[0;36m"         # CYAN
WHITE="\033[0;37m"        # WHITE

colors=( "$BLACK" "$RED" "$GREEN" \
         "$YELLOW" "$BLUE" "$PURPLE" \
         "$CYAN" "$WHITE" )

color_test () {
  for i in "${colors[@]}"; do 
    echo -e $i testing colors   
    echo ls 
  done
}

clean() {
echo -e $RED"Removing all requirements"
cd $molecule_path; rm -rf \
bin include lib pip-selfcheck.json test
}

make() {
echo -e $BLUE"Creating Virtualenv"
virtualenv --python=python2.7 $molecule_path
source ./bin/activate
mkdir roles
}

requirements() {
echo -e $BLUE"Installing requirements for molecule"
pip2.7 install --trusted-host pypi.python.org -r requirements.txt
}

init() {
if [ -d "$role_path/base" ]; then
  echo -e $BLUE"skipping initilization of molecule role base"
else
  echo -e $YELLOW"Creating molecule base" 
  cd $role_path 
  ../bin/molecule init template \
  --url https://github.com/bnikolaus/cookiecutter-molecule \
  --role-name base --no-input
fi
}

link() {
if [ -L "base" ]; then
  echo -e $BLUE"skipping link creation" 
else
  echo -e $YELLOW"Creating links to base"
  pwd
  cd $molecule_path
  ln -s ./roles/base test
fi
}

library() {
  echo "    - role: core" >> /test/molecule/default/playbook.yml
}

color_test
clean
make
requirements
init
link
