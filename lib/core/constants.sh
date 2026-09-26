#!/bin/bash

[[ -n "${_DVA_CONSTANTS_LOADED+x}" ]] && return 0
_DVA_CONSTANTS_LOADED=1

VERSION="1.0.6"
DVA_HOME="$HOME/.dva"
export DVA_DATA_DIR="$DVA_HOME/data"
