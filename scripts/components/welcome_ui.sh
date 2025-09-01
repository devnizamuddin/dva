#!/bin/bash

#*
#* ┏==================================================================================================┓
#* ┃                                   📖 Wellcome Message                                            ┃
#* ┗==================================================================================================┛
#*

function welcome_user(){
  

  print_welcome_text

  print_cli_name

  print_cli_name_full_form

  line_gap
  
}

function print_welcome_text(){

  echo -e " ____    __    ____  _______  __        ______    ______   .___  ___.  _______    _______  _______ ";
  echo -e " \   \  /  \  /   / |   ____||  |      /      |  /  __  \  |   \/   | |   ____|  |       ||       |";
  echo -e "  \   \/    \/   /  |  |__   |  |     |  ,----' |  |  |  | |  \  /  | |  |__     |_     _||   _   |";
  echo -e "   \            /   |   __|  |  |     |  |      |  |  |  | |  |\/|  | |   __|      |   |  |  | |  |";
  echo -e "    \    /\    /    |  |____ |  |____ |  _____  |  ___'  | |  |  |  | |  |____     |   |  |  |_|  |";
  echo -e "     \__/  \__/     |_______||_______| \______|  \______/  |__|  |__| |_______|    |___|  |_______|";
  
}

function print_cli_name(){

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

}

function print_cli_name_full_form(){

  echo -e "___  ____ _  _ ____ _    ____ ___  ____ ____    ____ _  _ ___ ____ _  _ ____ ___ _ ____ _  _";
  echo -e "|  \ |___ |  | |___ |    |  | |__] |___ |__/    |__| |  |  |  |  | |\/| |__|  |  | |  | |\ |"; 
  echo -e "|__/ |___  \/  |___ |___ |__| |    |___ |  \    |  | |__|  |  |__| |  | |  |  |  | |__| | \|";

}