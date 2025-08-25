#!/bin/bash
# UI Helpers for DVA CLI - ASCII iPad Layout
# MIT License (c) 2025 Nizam Uddin Shamrat

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
BG_BLUE='\033[44m'
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
NC="\033[0m"

# Styles
BOLD="\033[1m"
DIM="\033[2m"


# Print a card (menu option)
function print_card() {
  local number="$1"
  local title="$2"
  local symbol="$3"
  local color="$4"

  echo -e "${color}┌──────────────────────────────┐${NC}"
  echo -e "${color}│ [$number] $symbol  $title${NC}"
  echo -e "${color}└──────────────────────────────┘${NC}"
}

# Print info box
function print_info() {
  echo -e "${CYAN}ℹ $1${NC}"
}

# Print success box
function print_success() {
  echo -e "${GREEN}✔ $1${NC}"
}

# Print error box
function print_error() {
  echo -e "${RED}✖ $1${NC}"
}
echo "s"


function printWellcomeMessage(){
  
  echo -e " ____    __    ____  _______  __       __        ______    ______   .___  ___.  _______    _______  _______ ";
  echo -e " \   \  /  \  /   / |   ____||  |     |  |      /      |  /  __  \  |   \/   | |   ____|  |       ||       |";
  echo -e "  \   \/    \/   /  |  |__   |  |     |  |     |  ,----' |  |  |  | |  \  /  | |  |__     |_     _||   _   |";
  echo -e "   \            /   |   __|  |  |     |  |     |  |      |  |  |  | |  |\/|  | |   __|      |   |  |  | |  |";
  echo -e "    \    /\    /    |  |____ |  |____ |  |____ |  _____  |  ___'  | |  |  |  | |  |____     |   |  |  |_|  |";
  echo -e "     \__/  \__/     |_______||_______||_______| \______|  \______/  |__|  |__| |_______|    |___|  |_______|";
  echo -e "";

  echo -e "                                                                                                                               
                                                                                                                               
DDDDDDDDDDDDD      VVVVVVVV           VVVVVVVV   AAA                            CCCCCCCCCCCCCLLLLLLLLLLL             IIIIIIIIII
D::::::::::::DDD   V::::::V           V::::::V  A:::A                        CCC::::::::::::CL:::::::::L             I::::::::I
D:::::::::::::::DD V::::::V           V::::::V A:::::A                     CC:::::::::::::::CL:::::::::L             I::::::::I
DDD:::::DDDDD:::::DV::::::V           V::::::VA:::::::A                   C:::::CCCCCCCC::::CLL:::::::LL             II::::::II
  D:::::D    D:::::DV:::::V           V:::::VA:::::::::A                 C:::::C       CCCCCC  L:::::L                 I::::I  
  D:::::D     D:::::DV:::::V         V:::::VA:::::A:::::A               C:::::C                L:::::L                 I::::I  
  D:::::D     D:::::D V:::::V       V:::::VA:::::A A:::::A              C:::::C                L:::::L                 I::::I  
  D:::::D     D:::::D  V:::::V     V:::::VA:::::A   A:::::A             C:::::C                L:::::L                 I::::I  
  D:::::D     D:::::D   V:::::V   V:::::VA:::::A     A:::::A            C:::::C                L:::::L                 I::::I  
  D:::::D     D:::::D    V:::::V V:::::VA:::::AAAAAAAAA:::::A           C:::::C                L:::::L                 I::::I  
  D:::::D     D:::::D     V:::::V:::::VA:::::::::::::::::::::A          C:::::C                L:::::L                 I::::I  
  D:::::D    D:::::D       V:::::::::VA:::::AAAAAAAAAAAAA:::::A          C:::::C       CCCCCC  L:::::L         LLLLLL  I::::I  
DDD:::::DDDDD:::::D         V:::::::VA:::::A             A:::::A          C:::::CCCCCCCC::::CLL:::::::LLLLLLLLL:::::LII::::::II
D:::::::::::::::DD           V:::::VA:::::A               A:::::A          CC:::::::::::::::CL::::::::::::::::::::::LI::::::::I
D::::::::::::DDD              V:::VA:::::A                 A:::::A           CCC::::::::::::CL::::::::::::::::::::::LI::::::::I
DDDDDDDDDDDDD                  VVVAAAAAAA                   AAAAAAA             CCCCCCCCCCCCCLLLLLLLLLLLLLLLLLLLLLLLLIIIIIIIIII";

echo -e "";
echo -e "";

echo -e "___  ____ _  _ ____ _    ____ ___  ____ ____    ____ _  _ ___ ____ _  _ ____ ___ _ ____ _  _";
echo -e "|  \ |___ |  | |___ |    |  | |__] |___ |__/    |__| |  |  |  |  | |\/| |__|  |  | |  | |\ |"; 
echo -e "|__/ |___  \/  |___ |___ |__| |    |___ |  \    |  | |__|  |  |__| |  | |  |  |  | |__| | \|";

echo -e "";
echo -e "";
print_double_divider
echo -e "";
echo -e "";
}

function print_double_divider(){
  echo -e "==========================================================================================================================================";
}

# Divider
function print_divider() {
  echo -e "──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────";
  }



#*
#* ┏==================================================================================================┓
#* ┃                                      🧾 Comment Code                                             ┃
#* ┗==================================================================================================┛
#*


# function printFlutter(){
#  echo -e "00       00   00000000  00        00        "
#  echo -e "00   0   00   00        00        00        "
#  echo -e "00  000  00   00        00        00        "      
#  echo -e "00 00 00 00   00000     00        00        "      
#  echo -e "0000   0000   00        00        00        "      
#  echo -e "000     000   00        00        00        "      
#  echo -e "00       00   00000000  00000000 00000000  "
#  echo -e "--------------------------------------------"
# }


# echo -e "";
# echo -e "DDDDDDDDDDDDD        VVVVVVVV           VVVVVVVV     AAA                            CCCCCCCCCCCCC LLLLLLLLLLL             IIIIIIIIII";
# echo -e "D::::::::::::DDD     V::::::V           V::::::V    A:::A                        CCC::::::::::::C L:::::::::L             I::::::::I";
# echo -e "D:::::::::::::::DD   V::::::V           V::::::V   A:::::A                     CC:::::::::::::::C L:::::::::L             I::::::::I";
# echo -e "DDD:::::DDDDD:::::D  V::::::V           V::::::V  A:::::::A                   C:::::CCCCCCCC::::C LL:::::::LL             II::::::II";
# echo -e "  D:::::D    D:::::D  V:::::V           V:::::V  A:::::::::A                 C:::::C       CCCCCC  L:::::L                  I::::I  ";
# echo -e "  D:::::D     D:::::D  V:::::V         V:::::V  A:::::A:::::A               C:::::C                L:::::L                  I::::I  ";
# echo -e "  D:::::D     D:::::D   V:::::V       V:::::V  A:::::A A:::::A              C:::::C                L:::::L                  I::::I  ";
# echo -e "  D:::::D     D:::::D    V:::::V     V:::::V  A:::::A   A:::::A             C:::::C                L:::::L                  I::::I  ";
# echo -e "  D:::::D     D:::::D     V:::::V   V:::::V  A:::::A     A:::::A            C:::::C                L:::::L                  I::::I  ";
# echo -e "  D:::::D     D:::::D      V:::::V V:::::V  A:::::AAAAAAAAA:::::A           C:::::C                L:::::L                  I::::I  ";
# echo -e "  D:::::D     D:::::D       V:::::V:::::V  A:::::::::::::::::::::A          C:::::C                L:::::L                  I::::I  ";
# echo -e "  D:::::D    D:::::D         V:::::::::V  A:::::AAAAAAAAAAAAA:::::A          C:::::C       CCCCCC  L:::::L         LLLLLL   I::::I  ";
# echo -e "DDD:::::DDDDD:::::D           V:::::::V  A:::::A             A:::::A          C:::::CCCCCCCC::::C LL:::::::LLLLLLLLL:::::L II::::::II";
# echo -e "D:::::::::::::::DD            V:::::V   A:::::A               A:::::A          CC:::::::::::::::C L::::::::::::::::::::::L I::::::::I";
# echo -e "D::::::::::::DDD               V:::V   A:::::A                 A:::::A           CCC::::::::::::C L::::::::::::::::::::::L I::::::::I";
# echo -e "DDDDDDDDDDDDD                   VVV   AAAAAAA                   AAAAAAA             CCCCCCCCCCCCC LLLLLLLLLLLLLLLLLLLLLLLL IIIIIIIIII";
# echo -e "";