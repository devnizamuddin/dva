#!/bin/bash

[[ -n "${_DVA_BOOTSTRAP_LOADED+x}" ]] && return 0
_DVA_BOOTSTRAP_LOADED=1

# Load Constants
source "$DVA_HOME/lib/core/constants.sh"

# Source all utils files
for file in "$DVA_HOME/lib/utils/"*.sh; do
    source "$file"
done

# Source components (UI)
source "$DVA_HOME/lib/ui/menu_ui.sh"
source "$DVA_HOME/lib/ui/welcome_ui.sh"

# Source features
source "$DVA_HOME/lib/features/clean/clean_manager.sh"
source "$DVA_HOME/lib/features/flutter/flutter_manager.sh"
source "$DVA_HOME/lib/features/text/text_case_converter.sh"
source "$DVA_HOME/lib/features/git/git_manager.sh"
source "$DVA_HOME/lib/features/note/notes_manager.sh"
source "$DVA_HOME/lib/features/custom_commands/custom_commands_manager.sh"
source "$DVA_HOME/lib/features/mac_os/mac_os_manager.sh"
source "$DVA_HOME/lib/features/disk/disk_manager.sh"
source "$DVA_HOME/lib/features/ai_model_refresh/ai_model_refresh_manager.sh"
