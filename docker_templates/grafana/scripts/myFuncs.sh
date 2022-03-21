#!/bin/bash

# To install add this line to your .bashrc or .bash-profile:
#    source /path/to/myFuncs.sh
#

##### conda-auto-env automatically activates a conda environment when entering a folder with an environment.yml file.####
function conda_auto_env() {
  if [ -e "environment.yml" ]; then
    ENV_NAME=$(head -n 1 environment.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $CONDA_PREFIX != *$ENV_NAME* ]]; then
      # Try to activate environment
      conda activate $ENV_NAME
 #   else
    # Create the environment and activate
    #  echo "Conda env '$ENV_NAME' doesn't exist."
    #  conda env create -f environment.yml
    #  conda activate $ENV
      
    fi
  fi
}

export PROMPT_COMMAND="conda_auto_env"

##### Emulate Bash's PROMPT_COMMAND in ZSHRC #####
precmd() { eval "$PROMPT_COMMAND" }
