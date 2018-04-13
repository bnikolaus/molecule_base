#!/bin/bash

molecule_path=`pwd`
role_path="./roles/"

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
    echo colors  
  done
}

clean() {

  home_path
  echo -e $RED"Removing all requirements"
  rm -rf \
  bin include lib pip-selfcheck.json roles test

}

make() {

  home_path
  echo -e $BLUE"Creating Virtualenv"
  virtualenv --python=python2.7 $molecule_path
  source ./bin/activate
  mkdir roles

}

requirements() {

  home_path
  echo -e $BLUE"Installing requirements for molecule"
  pip2.7 install --trusted-host pypi.python.org -r requirements.txt

}

init() {

  home_path
  if [ -d "./roles/base" ]; then
    echo -e $BLUE"skipping initilization of molecule role base"
  else
    echo -e $YELLOW"Creating molecule base" 
    role_path 
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

  home_path
  input="library.yml"
  while IFS= read -r var
  do
    repo_url="$(cut -d'|' -f2 <<<"$var")"   
    repo_name="$(cut -d'|' -f1 <<<"$var")"
    repo_hash="$(cut -d'|' -f3 <<<"$var")"
    echo $repo_url
    echo $repo_name
    echo $repo_hash
    role_path
    if [ -d $repo_name ]; then
      echo -e $GREEN"skipping git clone"
      cd $repo_name
      echo -e $YELLOW"Checking out $repo_hash"
      git checkout $repo_hash
    else 
      echo -e $GREEN"downloading $repo_name $repo_hash" 
      git clone $repo_url $repo_name
    fi
    home_path 
    add_role="    - role: $repo_name" 
    if grep -Fxq "$add_role" ./roles/base/molecule/default/playbook.yml; then
      echo -e $RED"Role $repo_name found skipping"   
    else
      echo -e $GREEN"Adding role $repo_name to molecule test"
      echo "    - role: $repo_name" >> ./roles/base/molecule/default/playbook.yml 
    fi  
  done < "$input"
    
}

runtest() {

  home_path
  cd test 
  molecule test

}

home_path() {

  cd $molecule_path

}

role_path() {

  cd $role_path

}


#role_path
#home_path
color_test
clean
make
requirements
init
link
library
runtest
