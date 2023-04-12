#!/bin/bash

app_name="setup-fakeship"
usage_string="Usage: ./${app_name}.sh path_to_vere path_to_pier path_to_repos"

if [ $# -ne 3 ] ; then
  echo "Use this script with a new, running fakeship to setup and install %suite."
  echo "$usage_string"
  echo "path_to_vere is the path to the vere binary"
  echo "path_to_pier is the path to the fakeship pier to setup and install %suite on"
  echo "path_to_repos is the path to the directory containing urbit and vere repositories (or where they should be cloned to)"
  exit 1
fi
path_to_vere=$(realpath $1)
path_to_pier=$(realpath $2)
path_to_repos=$(realpath $3)

path_to_scripts=$(pwd)

if [ ! -e "${path_to_pier}/.run" ]; then
  $path_to_vere dock $path_to_pier
fi

cd $path_to_repos
for repo in urbit vere; do
  if [ ! -d "$repo" ]; then
    url="https://github.com/urbit/${repo}.git"
    echo "cloning ${url} into ${path_to_repos}/${repo} ..."
    git clone ${url}
  else
    cd $repo
    git checkout master
    git pull
    cd ..
  fi
done
path_to_click=$(realpath vere/pkg/click/click)

cd urbit/pkg

for submodule in dev-suite uqbar-core zig-dev; do
  if [ ! -d "$submodule" ]; then
    url="https://github.com/uqbar-dao/${submodule}.git"
    echo "creating submodule ${url} in ${path_to_repos}/urbit/pkg/${submodule} ..."
    git submodule add ${url}
  else
    cd $submodule
    git checkout master
    git pull
    cd ..
  fi
done

# TODO: remove once master up to date
cd dev-suite
git checkout next/suite
git pull
cd ..
cd uqbar-core
git checkout hf/ziggurat-refactor-project
git pull
cd ..

echo "creating desks ..."
$path_to_click -k -i ${path_to_scripts}/create-desks.hoon ${path_to_pier}

echo "copying files into desks..."
for submodule in dev-suite uqbar-core zig-dev; do
  desk_name=""
  if [ "dev-suite" = "$submodule" ]; then
    desk_name="suite"
  elif [ "uqbar-core" = "$submodule" ]; then
    desk_name="zig"
  elif [ "zig-dev" = "$submodule" ]; then
    desk_name="zig-dev"
  fi

  rm -rf ${path_to_pier}/${desk_name}/*
  cp -RL ${path_to_repos}/urbit/pkg/${submodule}/* ${path_to_pier}/${desk_name}/
done

echo "committing and installing desks ..."
$path_to_click -k -i ${path_to_scripts}/commit-and-install-desks.hoon ${path_to_pier}

echo "script done. installation will be finished when dojo reads something like:"
echo "[%pyro %snapshot /zig-dev/~2023.4.12..04.41.46..0b46]"
exit 0
