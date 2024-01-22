#!/bin/bash
usage()
{
cat << EOF

    This script sets up the directory structure for a snakemake pipeline project.
    
    usage: $script_name --project-name <project name> --readme <readme file>

    Example dirctory structure:
    ├── README.md
    ├── LICENSE.md
    ├── scripts
    │   ├── main_scripts.py
    │   ├── main_scripts.sh
    │   └── main_scripts.r
    ├── lib
    │   ├── functions 
    │   │   ├── bash_functions.sh
    │   │   └── R_functions.r
    │   └── python_lib 
    │       └── python_functions.py
    ├── config
    │   ├── variables.sh
    │   └── variables.r
    ├── data
    │   └── data_file.txt
    ├── setup
    │   ├── install_script.sh
    │   ├── conda_env.yml
    │   └── pip_requirements.txt
    ├── notebooks
    │   ├── project_notes.md
    │   └── project_notebook.ipynb
    ├── results
    └── resources


EOF
}

export -f usage

ignore()
{
    cat << EOF > ${1}/.gitignore
    $project_dir/results/
    $project_dir/resources/
    $project_dir/data/
EOF
}

export -f ignore