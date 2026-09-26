#!/bin/bash

[[ -n "${_DVA_EXIT_LOADED+x}" ]] && return 0
_DVA_EXIT_LOADED=1

function exit_script() {
  echo -e "\n${RED}============================================${RESET}"
  echo -e "${RED}        -                                     ${RESET}"
  echo -e "${RED}       / \\                                   ${RESET}"
  echo -e "${RED}      /   \\                                  ${RESET}"
  echo -e "${RED}     /     \\        Exiting now...           ${RESET}"
  echo -e "${RED}    /_______\\                                ${RESET}"
  echo -e "${RED}    |       |                                 ${RESET}"
  echo -e "${RED}    |       |            o                    ${RESET}"
  echo -e "${RED}    |  Git  |          /|\\  -- -- -- -- - -  ${RESET}"
  echo -e "${RED}    |       |          / \\  -- -- -- - - -   ${RESET}"
  echo -e "${RED}    |_______|  -- -- -- -- -- -- -- - - -     ${RESET}"
  echo -e "${RED}==============================================${RESET}"
  echo ""
  exit 0
}
