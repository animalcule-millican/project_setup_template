#!/bin/bash
# This script is for setting up a directory structure, and optionally creating a github repo for snakemake pipeline projects
export SYS_ROOT=$(eval echo "~")
# parse command line arguments
export script_name=$(basename "$0")

# source usage function
source $SYS_ROOT/project_setup/functions.sh

# set getopt usage
TEMP=$(getopt -o prdgh: --long project:,readme:,description:,github,help: \
              -n "$script_name" -- "$@")

# Note the quotes around '$TEMP': they are essential!
eval set -- "$TEMP"
export github=
# parse usage arguments
while true; do
  case "$1" in
    -p | --project ) name="$2"; shift ;;
    -r | --readme ) readme_file="$2"; shift ;;
    -d | --description ) description="$2"; shift ;;
    -g | --github ) repo="REPO"; shift ;;
    -h | --help ) HELP="$2"; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
export github="$repo"
# check if help was passed
if [ -z "${HELP}" ]; then
    echo "${usage_snakemake}"
    exit 1
fi

# check if project name is set
if [ -z "${name}" ]; then
    echo "Error: project name not set"
    echo "${usage_snakemake}"
    exit 1
else
    export project_name=$name
fi

if [[ -f $description ]]; then
    export repo_descrip=$(cat $description)
fi
# if description is not empty and not a file 
if [[ ! -z $repo_descrip ]] && [[ ! -f $description ]]; then
    export repo_descrip=$description
fi
# if description is empty
if [[ -z $repo_descrip ]]; then
    export repo_descrip="This is a repo for ${project_name}"
fi

# set project directory path
project_dir=$SYS_ROOT/snek-pipelines/$project_name

# check if project directory already exists; exit if it does
if [[ -d $project_dir ]]; then
    echo "Error: project directory already exists"
    exit 1
fi

# make project directory
mkdir -p $project_dir/workflow/rules $project_dir/workflow/envs $project_dir/workflow/scripts $project_dir/workflow/notebooks $project_dir/workflow/report $project_dir/config $project_dir/results $project_dir/resources

# check if readme file exists; if so, copy to project directory
if [[ -n $readme_file ]] && [[ -f $readme_file ]]; then
    cat $readme_file > $project_dir/README.md
# else make generic readme file
else
  # make README.md
cat << EOF > $project_dir/README.md
# ${project_name}

## Description
This is a snakemake pipeline for the ${project_name} project.
I am but a simple and hubmle script for setting up the directory structure for a snakemake pipeline project. I don't know of the inter-workings and complexities of your ingenious pipeline. 

Please, oh knoweldgeable one, fill in the details of your pipeline here.

# ***This is a generic README file, it needs to be replaced with a project specific README file.***

EOF
fi


# make LICENSE.md
cat << EOF > $project_dir/LICENSE.md
MIT License

Copyright (c) $(date +%Y) $project_name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

EOF

if [[ -n $github ]]; then
    # make .gitignore
    echo "" > $project_dir/.gitignore

    # move to project directory
    cd $project_dir
    # create github repo using python script
    create_repo.py
    # initialize git repo
    git init
    # add files to git repo
    git add $project_dir/README.md
    # commit files to git repo
    git commit -m "${repo_descrip}"
    # add remote origin
    git branch -M main
    git remote add origin git@github.com:animalcule-millican/${project_name}.git
    git push -u origin main

    cd $SYS_ROOT
fi
