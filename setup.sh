#!/bin/bash

# Colors
Black="\033[0;30m"        # Black
Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Yellow="\033[0;33m"       # Yellow
Blue="\033[0;34m"         # Blue
Purple="\033[0;35m"       # Purple
Cyan="\033[0;36m"         # Cyan
White="\033[0;37m"        # White

colors=( "$Black" "$Red" "$Green" \
         "$Yellow" "$Blue" "$Purple" \
         "$Cyan" "$White" )

color_test () {
  for i in "${colors[@]}"; do 
    echo -e $i test
  done
}

molecule_path=`pwd`
role_path="./roles"

clean() {
cd $molecule_path; rm -rf \
bin include lib pip-selfcheck.json test
}

make() {
virtualenv --python=python2.7 $molecule_path
mkdir roles
}

requirements() {
$molecule_path/bin/pip install -r requirements.txt
}

init() {
if [ -d "$role_path" ]; then
  echo "skipping init"
else
  ./bin/molecule init template \
  --url https://github.com/bnikolaus/cookiecutter-molecule \
  --role-name ./roles/molecule_base \ 
  --no-input
fi
}

link() {
echo "creating molecule links"
cd $molecule_path
ln -s ./roles/molecule_base molecule_base
}


color_test
#clean
#make
#requirements
#init
#link
