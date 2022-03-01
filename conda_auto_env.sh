#!/bin/bash

# conda-auto-env automatically activates a conda environment when
# entering a folder with an environment.yml file.
#
# If the environment doesn't exist, conda-auto-env creates it and
# activates it for you.
#
# To install add this line to your .bashrc or .bash-profile:
#
#       source /path/to/conda_auto_env.sh
#


function conda_auto_env() {
  if [ -e "environment.yml" ]; then
    ENV_NAME=$(head -n 1 environment.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $CONDA_PREFIX != *$ENV_NAME* ]]; then
      # Try to activate environment
      conda activate $ENV_NAME
    fi
  fi
}

export PROMPT_COMMAND="conda_auto_env"

##### Emulate Bash's PROMPT_COMMAND #####
precmd() { eval "$PROMPT_COMMAND" }
