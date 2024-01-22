#!/bin/bash
usage()
{
cat << EOF

    This script sets up the directory structure for a snakemake pipeline project.
    
    usage: $script_name --project-name <project name> --readme <readme file>

    Dirctory structure:
    ├── README.md
    ├── LICENSE.md
    ├── workflow
    │   ├── rules
    │   │   ├── module1.smk
    │   │   └── module2.smk
    │   ├── envs
    │   │   ├── tool1.yaml
    │   │   └── tool2.yaml
    │   ├── scripts
    │   │   ├── script1.py
    │   │   └── script2.R
    │   ├── notebooks
    │   │   ├── notebook1.py.ipynb
    │   │   └── notebook2.r.ipynb
    │   ├── report
    │   │   ├── plot1.rst
    │   │   └── plot2.rst
    │   └── Snakefile
    ├── config
    │   ├── config.yaml
    │   └── some-sheet.tsv
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