# 🔄 Git Sync Tasks
function git_sync_menu() {
  echo -e "${BLUE}--- Git Sync ---${NC}"
  echo "0) 🔙 Back"
  echo "1) Pull latest changes"
  echo "2) Push changes"
  echo "3) Sync all branches"
  read -p "Select a subtask [0-3]: " choice

  case "$choice" in
    1) log_task "Pulled latest"; git pull;;
    2) log_task "Pushed changes"; git push;;
    3) log_task "Synced branches"; echo "Syncing branches...";;
    0) return ;;
    *) echo -e "${RED}Invalid subtask.${NC}" ;;
  esac
}
