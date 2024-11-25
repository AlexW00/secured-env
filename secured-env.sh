#! /bin/bash

###########################################################################
########################### Secured Environment ###########################
###########################################################################

# Utility script to source environment variables from 1Password into the current shell.
# The environment variables can be configured in a configuration file (see secured-env-config.example.sh).


# - Main commands:
#   - enter-secured-env or ese: Enter the secured environment (sources the configured environment variables from 1Password)
#   - leave-secured-env or lse: Leave the secured environment (unsets the configured environment variables)
#   - print-secured-env or pse: Print the environment variable names that are currently available in the secured environment
# - Helper functions:
#   - source-env-from-op <secret-reference> <account>: Source an environment variable from 1Password into the secured environment
#     - <env_var_name>: The name of the environment variable to source
#     - <secret_reference>: The secret reference of the 1Password item to retrieve the environment variable from (can be copied from the 1Password item field menu ▼)
#     - [<account>]: The name of the 1Password account to retrieve the environment variable from (optional, defaults to OP_DEFAULT_ACCOUNT)

# ======================================================== #
# ======================= Functions ====================== #
# ======================================================== #

# ~~~~~~~~~~~~~ Main functions ~~~~~~~~~~~~ #

function enter-secured-env() {
    if [ -f "$SECURED_ENV_CONFIG" ]; then
      if [ -z "$IS_SECURE_ENV" ]; then
        # shellcheck disable=SC1091
        # shellcheck source=./secured-env-config.sh
        source "$SECURED_ENV_CONFIG"

        if [ $? -eq 0 ]; then
          export IS_SECURE_ENV=true
          echo "Loaded secured env vars: $SOURCED_SECURE_ENV_VARS"
        else
          echo "At least could not load all secured env vars. Rollback initialized..."
          remove-secrets-from-env
        fi


      else
        echo "secured environment already loaded."
      fi
    else
      echo "No secured environment loaded. $SECURED_ENV_CONFIG not found."
    fi
}
alias ese=enter-secured-env

function leave-secured-env() {
    if [ "$IS_SECURE_ENV" = true ]; then
        remove-secrets-from-env

        unset IS_SECURE_ENV

        echo "Exited secured environment."
    else
        echo "Not in a secured environment."
    fi
}
alias lse=leave-secured-env

function print-secured-env() {
    if [ "$IS_SECURE_ENV" = true ]; then
        echo "secured environment vars: $SOURCED_SECURE_ENV_VARS"
    else
        echo "Not in a secured environment."
    fi
}
alias pse=print-secured-env

# ~~~~~~~~~~~~ Helper functions ~~~~~~~~~~~ #

function remove-secrets-from-env() {
  for var in $(echo "$SOURCED_SECURE_ENV_VARS" | tr ";" "\n"); do
    unset "$var"
  done

  unset SOURCED_SECURE_ENV_VARS
}

function add-secret-to-env() {
  local env_var_name=$1
  if [ -z "$env_var_name" ]; then
    echo "env var name not provided"
    return 1
  fi

  local env_var_value=$2
  if [ -z "$env_var_value" ]; then
    echo "env var value not provided"
    return 1
  fi

  export "$env_var_name"="$env_var_value"

  # Add the environment variable to the list of sourced variables
  if [ -z "$SOURCED_SECURE_ENV_VARS" ]; then
    export SOURCED_SECURE_ENV_VARS=$env_var_name
  else
    export SOURCED_SECURE_ENV_VARS="$SOURCED_SECURE_ENV_VARS;$env_var_name"
  fi
}

function source-env-from-op() {
  local env_var_name=$1
  if [ -z "$env_var_name" ]; then
    echo "env var name not provided"
    return 1
  fi

  local item_secret_ref=$2
  if [ -z "$item_secret_ref" ]; then
    echo "item secret reference not provided (you can copy it from the 1Password item field menu ▼, e.g. 'op://Private/GitLab Token/password')"
    return 1
  fi

  local account=$3
  if [ -z "$account" ]; then
    if [ -z "$OP_DEFAULT_ACCOUNT" ]; then
      echo "account not provided and OP_DEFAULT_ACCOUNT not set"
      return 1
    else
      account=$OP_DEFAULT_ACCOUNT # default to OP_DEFAULT_ACCOUNT
    fi
  fi


  local env_var_value
  if ! env_var_value=$(op read "$item_secret_ref" --account="$account"); then
    echo "Failed to retrieve the env var $env_var_name from 1password."
    return 1
  fi

  add-secret-to-env "$env_var_name" "$env_var_value"
}

# check if 1Password is installed when sourcing this file
if ! command -v op &> /dev/null
then
    echo "Warning: 1Password CLI could not be found. Please install it from https://1password.com/downloads/command-line/."
    return 1
fi