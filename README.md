## 🔒 Secured Env

Utility script to source environment variables from 1Password. Use this script if you don't want to store your API Keys and other sensitive information as plain text in your environment, available to anyone/all programs with access to your shell.

### Installation

1. Install the 1Password CLI from https://1password.com/downloads/command-line/
2. Clone this repository (e.g. `git clone [XY](https://github.com/AlexW00/secured-env) $HOME/.config`)
3. Create and configure a secured-env-config.sh file (see [secured-env-config-example.sh](secured-env-config-example.sh) for an example)
4. Export the path to your **config file** as SECURED_ENV_CONFIG_PATH (e.g. `export SECURED_ENV_CONFIG_PATH=$HOME/.config/secured-env/secured-env-config.sh`) (e.g. in your .bashrc or .zshrc file)
5. Source the **main script** (e.g. `source $HOME/.config/secured-env/secured-env.sh`) (after the previous steps) (e.g. in your .bashrc or .zshrc file)

Example configuration (`.bashrc` or `.zshrc`):

```bash
# ...
export SECURED_ENV_CONFIG_PATH=$HOME/.config/secured-env/secured-env-config.sh # the config file you created
source $HOME/.config/secured-env/secured-env.sh # the main script
# ...
```

### Usage

- Main commands:
  - `enter-secured-env` or `ese`: Enter the secured environment (sources the configured environment variables from 1Password)
  - `leave-secured-env` or `lse`: Leave the secured environment (unsets the configured environment variables)
  - `print-secured-env` or `pse`: Print the environment variable names that are currently available in the secured environment
- Configuration file commands:
  - `source-env-from-op <secret-reference> <account>`: Source an environment variable from 1Password into the secured environment
    - `<env_var_name>`: The name of the environment variable
    - `<secret_reference>`: The secret reference of the 1Password item to retrieve the environment variable from (can be copied from the 1Password item field menu ▼)
    - `[<account>]`: The name of the 1Password account to retrieve the environment variable from (optional, defaults to OP_DEFAULT_ACCOUNT)