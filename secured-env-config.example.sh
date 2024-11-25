#!/usr/bin/env bash

# ======================================================== #
# ======= Secured Environment Example Configuration ====== #
# ======================================================== #

# Configuration of which env variables should be sourced into your secured environment
# (This script gets executed everytime you call `enter-secured-env`)

# ~~~~~~~~~~~~~~~~ Defaults ~~~~~~~~~~~~~~~ #

# Configure these defaults to shorten the source-env-from-op function calls (makes the last `[<account>]` parameter optional).

export OP_DEFAULT_ACCOUNT=my.1password.eu

# ~~~~~~~~~ Environment Variables ~~~~~~~~~ #

# Here, you can configure the environment variables, which will be sourced from 1Password when entering the secured environment:
# - Commands:
#   - `source-env-from-op <secret-reference> <account>`: Source an environment variable from 1Password into the secured environment
#     - `<env_var_name>`: The name of the environment variable
#     - `<secret_reference>`: The secret reference of the 1Password item to retrieve the environment variable from (can be copied from the 1Password item field menu ▼)
#     - `[<account>]`: The name of the 1Password account to retrieve the environment variable from (optional, defaults to OP_DEFAULT_ACCOUNT)

# Example - sources the value of the secret reference as GITLAB_TOKEN in the secured environment
# (To get your secret reference, open the 1Password item, click on the ▼ next to the field and select "Copy Secret Reference")
source-env-from-op GITLAB_TOKEN "op://Private/GitLab Token/password"