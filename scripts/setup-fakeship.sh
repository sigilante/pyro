#!/bin/bash

app_name="setup-fakeship"
usage_string="Usage: ./${app_name}.sh path_to_pier path_to_repos ship code"

if [ $# -ne 5 ] ; then
  echo "Use this script with a new, running fakeship to setup and install %suite."
  echo "$usage_string"
  echo "path_to_pier is the path to the fakeship pier to setup and install %suite on"
  echo "path_to_repos is the path to the directory containing urbit and vere repositories (or where they should be cloned to)"
  echo "ship is the shipname with no `~`, like 'zod' or 'nec'"
  echo "code is the +code"
  echo "port is the http port the ship is on"
  exit 1
fi
path_to_pier=$(realpath $1)
path_to_repos=$(realpath $2)
ship=$3
code=$4
port=$5

if [ ! -e "vere" ]; then
  curl -L https://urbit.org/install/linux-x86_64/latest | tar xzk --transform='s/.*/vere/g'
fi
path_to_vere=$(realpath ./vere)

# port=9999
# ship=zod
# code=lidlut-tabwed-pillex-ridrup
# $path_to_vere -F $ship --http-port $port -t &

cd $path_to_repos
for repo in urbit tools; do
  if [ ! -d "$repo" ]; then
    url="https://github.com/urbit/${repo}.git"
    echo "cloning ${url} into ${path_to_repos}/${repo} ..."
    git clone ${url}
  else
    cd $repo
    git checkout master
    git restore --staged .
    git pull
    cd ..
  fi
done
path_to_click=$(realpath tools/pkg/click/click)

cd urbit/pkg

for submodule in dev-suite uqbar-core zig-dev linedb pokur-dev; do
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

path_to_scripts=$(realpath dev-suite/scripts)

# TODO: remove once master up to date
cd dev-suite
git checkout hf/ziggurat-use-linedb-instead-of-clay
git pull
cd ..
cd uqbar-core
git checkout hf/ziggurat-refactor-project-state
git pull
cd ..
cd linedb
git checkout hf/linedb-update-script
git pull
cd ..

if [ ! -e "${path_to_pier}/.run" ]; then
  $path_to_vere dock $path_to_pier
fi

echo "creating desks ..."
$path_to_click -k -i ${path_to_scripts}/create-desks.hoon ${path_to_pier}

echo "copying base ..."
for submodule in base-dev arvo; do
  desk_name="base"
  cp -RL ${path_to_repos}/urbit/pkg/${submodule}/* ${path_to_pier}/${desk_name}/
done

echo "committing base ..."
$path_to_click -k -i ${path_to_scripts}/commit-base.hoon ${path_to_pier}

$path_to_click -k -i ${path_to_scripts}/dummy.hoon ${path_to_pier}
wait

echo "copying files into desks..."
for submodule in linedb dev-suite; do
  desk_name=""
  if [ "dev-suite" = "$submodule" ]; then
    desk_name="suite"
  elif [ "linedb" = "$submodule" ]; then
    desk_name="linedb"
  fi
  rm -rf ${path_to_pier}/${desk_name}/*
  cp -RL ${path_to_repos}/urbit/pkg/${submodule}/* ${path_to_pier}/${desk_name}/
done

echo "committing and installing desks ..."
$path_to_click -k -i ${path_to_scripts}/commit-and-install-desks.hoon ${path_to_pier}

$path_to_click -k -i ${path_to_scripts}/dummy.hoon ${path_to_pier}
wait

echo "copying files into %linedb ..."
url_base="http://localhost:${port}"
for submodule in zig-dev pokur-dev uqbar-core "pokur/src"; do
  repo_name=""
  if [ "zig-dev" = "$submodule" ]; then
    repo_name="zig-dev"
  elif [ "pokur-dev" = "$submodule" ]; then
    repo_name="pokur-dev"
  elif [ "uqbar-core" = "$submodule" ]; then
    repo_name="zig"
  elif [ "pokur/src" = "$submodule" ]; then
    repo_name="pokur"
  fi
  python3 ${path_to_repos}/urbit/pkg/linedb/scripts/linedb-load-files-from-directory.py $repo_name master ${path_to_repos}/urbit/pkg/${submodule} --ship $ship --password $code --url_base $url_base
done

echo "script done. installation will be finished when dojo reads something like:"
echo "[%pyro %snapshot /zig-dev/~2023.4.12..04.41.46..0b46]"
exit 0
