#!/bin/bash

[[ -n "${_DVA_AI_MODEL_REFRESH_MANAGER_LOADED+x}" ]] && return 0
_DVA_AI_MODEL_REFRESH_MANAGER_LOADED=1

# * ┏==================================================================================================┓
# * ┃                    🤖 AI Model Refresh Interval: Options & Actions                               ┃
# * ┗==================================================================================================┛

# Storage file for AI model refresh interval configurations
AI_MODEL_REFRESH_FILE="$DVA_DATA_DIR/ai_model_refresh_intervals.json"

# Menu Title
AI_MODEL_REFRESH_TITLE="AI Model Refresh Interval"

# Menu Options
AI_MODEL_REFRESH_OPTIONS=(
  "➕  Add New Interval"
  "✏️   Modify Existing Interval"
  "🗑️   Delete Interval"
  "⬅️   Back"
)


# * ┏==================================================================================================┓
# * ┃                         🔧 Persistence Helper Functions                                         ┃
# * ┗==================================================================================================┛

function _amri_init_file() {
  if [[ ! -f "$AI_MODEL_REFRESH_FILE" ]]; then
    echo '{"intervals":[]}' > "$AI_MODEL_REFRESH_FILE"
  fi
}

function _amri_get_count() {
  jq -r '.intervals | length' "$AI_MODEL_REFRESH_FILE" 2>/dev/null || echo "0"
}

function _amri_get_all_summaries() {
  # Outputs lines: "INDEX|account|model|days|hours|minutes|created_at|updated_at"
  jq -r '.intervals | to_entries[] | "\(.key)|\(.value.account)|\(.value.model)|\(.value.days)|\(.value.hours)|\(.value.minutes)|\(.value.created_at // "")|\(.value.updated_at // "")"' \
    "$AI_MODEL_REFRESH_FILE" 2>/dev/null
}

function _amri_add() {
  local account="$1"
  local model="$2"
  local days="$3"
  local hours="$4"
  local minutes="$5"
  local created_at
  created_at=$(date +%s)

  jq \
    --arg account    "$account"    \
    --arg model      "$model"      \
    --argjson days       "$days"       \
    --argjson hours      "$hours"      \
    --argjson minutes    "$minutes"    \
    --argjson created_at "$created_at" \
    '.intervals += [{"account": $account, "model": $model, "days": $days, "hours": $hours, "minutes": $minutes, "created_at": $created_at, "updated_at": null}]' \
    "$AI_MODEL_REFRESH_FILE" > "${AI_MODEL_REFRESH_FILE}.tmp" && \
    mv "${AI_MODEL_REFRESH_FILE}.tmp" "$AI_MODEL_REFRESH_FILE"
}

function _amri_update() {
  local index="$1"
  local account="$2"
  local model="$3"
  local days="$4"
  local hours="$5"
  local minutes="$6"
  local updated_at
  updated_at=$(date +%s)

  jq \
    --argjson idx        "$index"      \
    --arg account    "$account"    \
    --arg model      "$model"      \
    --argjson days       "$days"       \
    --argjson hours      "$hours"      \
    --argjson minutes    "$minutes"    \
    --argjson updated_at "$updated_at" \
    '.intervals[$idx] = (.intervals[$idx] | {"account": $account, "model": $model, "days": $days, "hours": $hours, "minutes": $minutes, "created_at": .created_at, "updated_at": $updated_at})' \
    "$AI_MODEL_REFRESH_FILE" > "${AI_MODEL_REFRESH_FILE}.tmp" && \
    mv "${AI_MODEL_REFRESH_FILE}.tmp" "$AI_MODEL_REFRESH_FILE"
}

function _amri_delete() {
  local index="$1"
  jq --argjson idx "$index" 'del(.intervals[$idx])' \
    "$AI_MODEL_REFRESH_FILE" > "${AI_MODEL_REFRESH_FILE}.tmp" && \
    mv "${AI_MODEL_REFRESH_FILE}.tmp" "$AI_MODEL_REFRESH_FILE"
}


# * ┏==================================================================================================┓
# * ┃                         📋 Display Helper Functions                                             ┃
# * ┗==================================================================================================┛

# Formats the interval duration into a human-readable string.
# Usage: _amri_format_duration <days> <hours> <minutes>
function _amri_format_duration() {
  local days="$1"
  local hours="$2"
  local minutes="$3"
  local parts=()

  [[ "$days" -gt 0 ]]    && parts+=("${days}d")
  [[ "$hours" -gt 0 ]]   && parts+=("${hours}h")
  [[ "$minutes" -gt 0 ]] && parts+=("${minutes}m")

  # Fallback (should not happen after validation, but just in case)
  [[ ${#parts[@]} -eq 0 ]] && parts+=("0m")

  local IFS=" "
  echo "${parts[*]}"
}

# Calculates the next refresh epoch from a base timestamp + interval.
# Usage: _amri_calc_next_refresh <base_epoch> <days> <hours> <minutes>
# Outputs: epoch timestamp of next refresh
function _amri_calc_next_refresh_epoch() {
  local base_epoch="$1"
  local days="$2"
  local hours="$3"
  local minutes="$4"

  local interval_seconds=$(( (days * 86400) + (hours * 3600) + (minutes * 60) ))
  echo $(( base_epoch + interval_seconds ))
}

# Formats an epoch timestamp into a human-readable date string.
# Usage: _amri_format_epoch <epoch>
# Outputs: e.g., "Sep 28, 2026 08:30 AM"
function _amri_format_epoch() {
  local epoch="$1"
  if [[ -z "$epoch" || "$epoch" == "null" ]]; then
    echo "N/A"
    return
  fi
  date -r "$epoch" '+%b %d, %Y %I:%M %p' 2>/dev/null || echo "N/A"
}

# Calculates the time remaining until next refresh as a human-readable string.
# Usage: _amri_calc_time_remaining <next_refresh_epoch>
# Outputs: e.g., "2d 5h 30m" or "Overdue" or "N/A"
function _amri_calc_time_remaining() {
  local next_epoch="$1"
  if [[ -z "$next_epoch" || "$next_epoch" == "null" ]]; then
    echo "N/A"
    return
  fi

  local now
  now=$(date +%s)
  local diff=$(( next_epoch - now ))

  if [[ "$diff" -le 0 ]]; then
    echo "Overdue"
    return
  fi

  local r_days=$(( diff / 86400 ))
  local r_hours=$(( (diff % 86400) / 3600 ))
  local r_mins=$(( (diff % 3600) / 60 ))
  local parts=()

  [[ "$r_days" -gt 0 ]]  && parts+=("${r_days}d")
  [[ "$r_hours" -gt 0 ]] && parts+=("${r_hours}h")
  [[ "$r_mins" -gt 0 ]]  && parts+=("${r_mins}m")
  [[ ${#parts[@]} -eq 0 ]] && parts+=("<1m")

  local IFS=" "
  echo "${parts[*]}"
}

# Determines the base epoch for next-refresh calculation.
# Uses updated_at if present, otherwise created_at.
# Usage: _amri_get_base_epoch <created_at> <updated_at>
function _amri_get_base_epoch() {
  local created_at="$1"
  local updated_at="$2"

  if [[ -n "$updated_at" && "$updated_at" != "null" && "$updated_at" != "" ]]; then
    echo "$updated_at"
  elif [[ -n "$created_at" && "$created_at" != "null" && "$created_at" != "" ]]; then
    echo "$created_at"
  else
    echo ""
  fi
}

# Prints a table of all configured intervals with next-refresh countdown.
function _amri_print_table() {
  local count
  count=$(_amri_get_count)

  if [[ "$count" -eq 0 ]]; then
    printf "\n"
    print_status_warning "No refresh intervals configured yet."
    printf "\n"
    return 0
  fi

  printf "\n"
  printf "  ${BOLD}${CYAN}%-4s  %-15s  %-18s  %-10s  %-22s  %-12s${NC}\n" \
    "#" "Account" "Model" "Interval" "Next Refresh" "Remaining"
  printf "  ${CYAN}%-4s  %-15s  %-18s  %-10s  %-22s  %-12s${NC}\n" \
    "────" "───────────────" "──────────────────" "──────────" "──────────────────────" "────────────"

  local idx=0
  while IFS='|' read -r i account model days hours minutes created_at updated_at; do
    local duration
    duration=$(_amri_format_duration "$days" "$hours" "$minutes")

    local base_epoch next_epoch next_date remaining
    base_epoch=$(_amri_get_base_epoch "$created_at" "$updated_at")

    if [[ -n "$base_epoch" ]]; then
      next_epoch=$(_amri_calc_next_refresh_epoch "$base_epoch" "$days" "$hours" "$minutes")
      next_date=$(_amri_format_epoch "$next_epoch")
      remaining=$(_amri_calc_time_remaining "$next_epoch")
    else
      next_date="N/A"
      remaining="N/A"
    fi

    # Color the remaining column: red if overdue, green otherwise
    local remaining_display
    if [[ "$remaining" == "Overdue" ]]; then
      remaining_display="${RED}${BOLD}${remaining}${NC}"
    elif [[ "$remaining" == "N/A" ]]; then
      remaining_display="${DIM}${remaining}${NC}"
    else
      remaining_display="${GREEN}${remaining}${NC}"
    fi

    printf "  ${WHITE}%-4s  %-15s  %-18s  %-10s  %-22s${NC}  %b\n" \
      "$((i+1))." "$account" "$model" "$duration" "$next_date" "$remaining_display"
    ((idx++))
  done < <(_amri_get_all_summaries)

  printf "\n"
}

# Prints a single interval as a formatted summary card.
# Usage: _amri_print_summary_card <account> <model> <days> <hours> <minutes> [created_at] [updated_at]
function _amri_print_summary_card() {
  local account="$1"
  local model="$2"
  local days="$3"
  local hours="$4"
  local minutes="$5"
  local created_at="${6:-}"
  local updated_at="${7:-}"
  local duration
  duration=$(_amri_format_duration "$days" "$hours" "$minutes")

  local next_line=""
  local base_epoch
  base_epoch=$(_amri_get_base_epoch "$created_at" "$updated_at")
  if [[ -n "$base_epoch" ]]; then
    local next_epoch next_date remaining
    next_epoch=$(_amri_calc_next_refresh_epoch "$base_epoch" "$days" "$hours" "$minutes")
    next_date=$(_amri_format_epoch "$next_epoch")
    remaining=$(_amri_calc_time_remaining "$next_epoch")
    next_line="$(printf "\n  ${BOLD}Next    :${NC} %-s  ${DIM}(%s)${NC}" "$next_date" "$remaining")"
  fi

  local content
  content="$(printf "  ${BOLD}Account :${NC} %-s\n  ${BOLD}Model   :${NC} %-s\n  ${BOLD}Interval:${NC} %-s%s" \
    "$account" "$model" "$duration" "$next_line")"
  print_card "$content" "$CYAN"
}


# * ┏==================================================================================================┓
# * ┃                         🔍 Input Validation Helpers                                             ┃
# * ┗==================================================================================================┛

# Prompts for a required non-empty text field.
# Outputs the trimmed value via stdout; returns 1 if cancelled.
# Usage: _amri_prompt_required <prompt_label> <current_value>
function _amri_prompt_required() {
  local label="$1"
  local current="$2"
  local value=""

  while true; do
    if [[ -n "$current" ]]; then
      printf "  ${BOLD}${CYAN}%s${NC} ${DIM}[current: %s]${NC}\n  → " "$label" "$current"
    else
      printf "  ${BOLD}${CYAN}%s${NC}\n  → " "$label"
    fi
    read -r value

    # Allow keeping current value on empty input (only during modify)
    if [[ -z "$value" && -n "$current" ]]; then
      echo "$current"
      return 0
    fi

    if [[ -z "$value" ]]; then
      print_status_error "This field is required. Please enter a value."
      echo ""
    else
      echo "$value"
      return 0
    fi
  done
}

# Prompts for a non-negative integer.
# Outputs the value via stdout.
# Usage: _amri_prompt_integer <label> <current_value>
function _amri_prompt_integer() {
  local label="$1"
  local current="${2:-}"
  local value=""

  while true; do
    if [[ -n "$current" ]]; then
      printf "  ${BOLD}${CYAN}%s${NC} ${DIM}[current: %s]${NC} (press Enter to keep)\n  → " "$label" "$current"
    else
      printf "  ${BOLD}${CYAN}%s${NC}\n  → " "$label"
    fi
    read -r value

    # Keep current value on empty input during modify
    if [[ -z "$value" && -n "$current" ]]; then
      echo "$current"
      return 0
    fi

    # Must be a non-negative integer
    if [[ "$value" =~ ^[0-9]+$ ]]; then
      echo "$value"
      return 0
    else
      print_status_error "Invalid input. Please enter a non-negative whole number (e.g., 0, 1, 30)."
      echo ""
    fi
  done
}


# * ┏==================================================================================================┓
# * ┃                              📖 Action: Add New Interval                                        ┃
# * ┗==================================================================================================┛

function ai_model_refresh_interval_action_1() {
  clear
  printf "\n${BOLD}➕  Add New AI Model Refresh Interval${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n\n"

  # ── Account Name ──────────────────────────────────────────────
  printf "  ${DIM}Step 1 of 5 — Account Name${NC}\n"
  local account
  account=$(_amri_prompt_required "Account Name (e.g., Personal, Work):" "")
  echo ""

  # ── Model Name ────────────────────────────────────────────────
  printf "  ${DIM}Step 2 of 5 — Model Name${NC}\n"
  local model
  model=$(_amri_prompt_required "AI Model Name (e.g., Gemini 2.5 Pro):" "")
  echo ""

  # ── Refresh Interval ──────────────────────────────────────────
  printf "  ${DIM}Step 3 of 5 — Refresh Interval (Days)${NC}\n"
  local days
  days=$(_amri_prompt_integer "Days:" "")
  echo ""

  printf "  ${DIM}Step 4 of 5 — Refresh Interval (Hours)${NC}\n"
  local hours
  hours=$(_amri_prompt_integer "Hours:" "")
  echo ""

  printf "  ${DIM}Step 5 of 5 — Refresh Interval (Minutes)${NC}\n"
  local minutes
  minutes=$(_amri_prompt_integer "Minutes:" "")
  echo ""

  # ── At-least-one validation ───────────────────────────────────
  if [[ "$days" -eq 0 && "$hours" -eq 0 && "$minutes" -eq 0 ]]; then
    print_status_error "Refresh interval must be greater than zero. At least one of Days, Hours, or Minutes must be > 0."
    return 1
  fi

  # ── Confirmation ──────────────────────────────────────────────
  printf "\n${BOLD}${YELLOW}📋  Summary — New Interval${NC}\n"
  printf "───────────────────────────────────────────────────────────\n"
  _amri_print_summary_card "$account" "$model" "$days" "$hours" "$minutes"

  printf "\n"
  printf "  ${BOLD}Confirm and save this configuration?${NC} ${DIM}(yes/no)${NC}\n  → "
  local confirm
  read -r confirm
  echo ""

  case "$(echo "$confirm" | tr '[:upper:]' '[:lower:]')" in
    yes|y)
      _amri_add "$account" "$model" "$days" "$hours" "$minutes"
      print_status_success "Interval for '${account} / ${model}' saved successfully!"
      ;;
    *)
      print_status_warning "Cancelled. No changes were saved."
      ;;
  esac
}


# * ┏==================================================================================================┓
# * ┃                           📖 Action: Modify Existing Interval                                   ┃
# * ┗==================================================================================================┛

function ai_model_refresh_interval_action_2() {
  clear
  printf "\n${BOLD}✏️   Modify Existing AI Model Refresh Interval${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n"

  local count
  count=$(_amri_get_count)

  if [[ "$count" -eq 0 ]]; then
    printf "\n"
    print_status_warning "No intervals configured yet. Please add one first."
    return 0
  fi

  # ── Display existing intervals ────────────────────────────────
  _amri_print_table

  # ── Select an interval ────────────────────────────────────────
  printf "  ${BOLD}${CYAN}Select interval to modify${NC} ${DIM}(enter number, or 0 to cancel):${NC}\n  → "
  local choice
  read -r choice
  echo ""

  if [[ "$choice" == "0" || -z "$choice" ]]; then
    print_status_info "Cancelled."
    return 0
  fi

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 || "$choice" -gt "$count" ]]; then
    print_status_error "Invalid selection. Please enter a number between 1 and ${count}."
    return 1
  fi

  local idx=$(( choice - 1 ))

  # ── Fetch existing values ─────────────────────────────────────
  local old_account old_model old_days old_hours old_minutes old_created_at old_updated_at
  old_account=$(jq -r --argjson i "$idx" '.intervals[$i].account'     "$AI_MODEL_REFRESH_FILE")
  old_model=$(  jq -r --argjson i "$idx" '.intervals[$i].model'       "$AI_MODEL_REFRESH_FILE")
  old_days=$(   jq -r --argjson i "$idx" '.intervals[$i].days'        "$AI_MODEL_REFRESH_FILE")
  old_hours=$(  jq -r --argjson i "$idx" '.intervals[$i].hours'       "$AI_MODEL_REFRESH_FILE")
  old_minutes=$(jq -r --argjson i "$idx" '.intervals[$i].minutes'     "$AI_MODEL_REFRESH_FILE")
  old_created_at=$(jq -r --argjson i "$idx" '.intervals[$i].created_at // ""' "$AI_MODEL_REFRESH_FILE")
  old_updated_at=$(jq -r --argjson i "$idx" '.intervals[$i].updated_at // ""' "$AI_MODEL_REFRESH_FILE")

  printf "${BOLD}${YELLOW}📋  Current Configuration${NC}\n"
  printf "───────────────────────────────────────────────────────────\n"
  _amri_print_summary_card "$old_account" "$old_model" "$old_days" "$old_hours" "$old_minutes" "$old_created_at" "$old_updated_at"
  printf "\n${DIM}  Leave a field blank and press Enter to keep the current value.${NC}\n\n"
  printf "───────────────────────────────────────────────────────────\n\n"

  # ── Collect updated values ────────────────────────────────────
  printf "  ${DIM}Account Name${NC}\n"
  local new_account
  new_account=$(_amri_prompt_required "Account Name:" "$old_account")
  echo ""

  printf "  ${DIM}Model Name${NC}\n"
  local new_model
  new_model=$(_amri_prompt_required "AI Model Name:" "$old_model")
  echo ""

  printf "  ${DIM}Refresh Interval${NC}\n"
  local new_days
  new_days=$(_amri_prompt_integer "Days:" "$old_days")
  echo ""

  local new_hours
  new_hours=$(_amri_prompt_integer "Hours:" "$old_hours")
  echo ""

  local new_minutes
  new_minutes=$(_amri_prompt_integer "Minutes:" "$old_minutes")
  echo ""

  # ── At-least-one validation ───────────────────────────────────
  if [[ "$new_days" -eq 0 && "$new_hours" -eq 0 && "$new_minutes" -eq 0 ]]; then
    print_status_error "Refresh interval must be greater than zero. At least one of Days, Hours, or Minutes must be > 0."
    return 1
  fi

  # ── Confirmation ──────────────────────────────────────────────
  printf "\n${BOLD}${YELLOW}📋  Summary — Updated Interval${NC}\n"
  printf "───────────────────────────────────────────────────────────\n"
  _amri_print_summary_card "$new_account" "$new_model" "$new_days" "$new_hours" "$new_minutes"

  printf "\n"
  printf "  ${BOLD}Save these changes?${NC} ${DIM}(yes/no)${NC}\n  → "
  local confirm
  read -r confirm
  echo ""

  case "$(echo "$confirm" | tr '[:upper:]' '[:lower:]')" in
    yes|y)
      _amri_update "$idx" "$new_account" "$new_model" "$new_days" "$new_hours" "$new_minutes"
      print_status_success "Interval updated successfully!"
      ;;
    *)
      print_status_warning "Cancelled. No changes were saved."
      ;;
  esac
}


# * ┏==================================================================================================┓
# * ┃                              📖 Action: Delete Interval                                         ┃
# * ┗==================================================================================================┛

function ai_model_refresh_interval_action_3() {
  clear
  printf "\n${BOLD}🗑️   Delete AI Model Refresh Interval${NC}\n"
  printf "═══════════════════════════════════════════════════════════\n"

  local count
  count=$(_amri_get_count)

  if [[ "$count" -eq 0 ]]; then
    printf "\n"
    print_status_warning "No intervals configured yet. Nothing to delete."
    return 0
  fi

  # ── Display existing intervals ────────────────────────────────
  _amri_print_table

  # ── Select an interval ────────────────────────────────────────
  printf "  ${BOLD}${CYAN}Select interval to delete${NC} ${DIM}(enter number, or 0 to cancel):${NC}\n  → "
  local choice
  read -r choice
  echo ""

  if [[ "$choice" == "0" || -z "$choice" ]]; then
    print_status_info "Cancelled."
    return 0
  fi

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 || "$choice" -gt "$count" ]]; then
    print_status_error "Invalid selection. Please enter a number between 1 and ${count}."
    return 1
  fi

  local idx=$(( choice - 1 ))

  # ── Show selected interval ────────────────────────────────────
  local del_account del_model del_days del_hours del_minutes del_created_at del_updated_at
  del_account=$(jq -r --argjson i "$idx" '.intervals[$i].account'     "$AI_MODEL_REFRESH_FILE")
  del_model=$(  jq -r --argjson i "$idx" '.intervals[$i].model'       "$AI_MODEL_REFRESH_FILE")
  del_days=$(   jq -r --argjson i "$idx" '.intervals[$i].days'        "$AI_MODEL_REFRESH_FILE")
  del_hours=$(  jq -r --argjson i "$idx" '.intervals[$i].hours'       "$AI_MODEL_REFRESH_FILE")
  del_minutes=$(jq -r --argjson i "$idx" '.intervals[$i].minutes'     "$AI_MODEL_REFRESH_FILE")
  del_created_at=$(jq -r --argjson i "$idx" '.intervals[$i].created_at // ""' "$AI_MODEL_REFRESH_FILE")
  del_updated_at=$(jq -r --argjson i "$idx" '.intervals[$i].updated_at // ""' "$AI_MODEL_REFRESH_FILE")

  printf "${BOLD}${RED}⚠️   Interval Selected for Deletion${NC}\n"
  printf "───────────────────────────────────────────────────────────\n"
  _amri_print_summary_card "$del_account" "$del_model" "$del_days" "$del_hours" "$del_minutes" "$del_created_at" "$del_updated_at"

  # ── Explicit confirmation ─────────────────────────────────────
  printf "\n  ${BOLD}${RED}Are you sure you want to delete this interval?${NC} ${DIM}(yes/no)${NC}\n  → "
  local confirm
  read -r confirm
  echo ""

  case "$(echo "$confirm" | tr '[:upper:]' '[:lower:]')" in
    yes|y)
      _amri_delete "$idx"
      print_status_success "Interval for '${del_account} / ${del_model}' deleted successfully!"
      ;;
    *)
      print_status_warning "Cancelled. Interval was not deleted."
      ;;
  esac
}


# * ┏==================================================================================================┓
# * ┃                              📖 Action: Back                                                    ┃
# * ┗==================================================================================================┛

# Sentinel return code used to signal "Back" from the custom menu loop.
_AMRI_BACK_SENTINEL=99

function ai_model_refresh_interval_action_4() {
  # Signal the custom menu loop to exit
  return $_AMRI_BACK_SENTINEL
}


# * ┏==================================================================================================┓
# * ┃                              📖 AI Model Refresh Interval Menu Loop                             ┃
# * ┗==================================================================================================┛

function run_ai_model_refresh_interval_menu() {
  # Check for jq dependency
  if ! command -v jq &>/dev/null; then
    printf "\n❌ Error: 'jq' is not installed but is required for AI Model Refresh Interval.\n"
    printf "   Please install it: brew install jq\n"
    read -p "Press Enter to return..."
    return 1
  fi

  _amri_init_file

  local width=49
  local border_top="┏$(printf '━%.0s' $(seq 1 $width))┓"
  local border_sep="┃$(printf '─%.0s' $(seq 1 $width))┃"
  local border_empty="┃$(printf ' %.0s' $(seq 1 $width))┃"
  local border_bottom="┗$(printf '━%.0s' $(seq 1 $width))┛"

  local selected=0
  local key=""
  local options=("${AI_MODEL_REFRESH_OPTIONS[@]}")
  local title="$AI_MODEL_REFRESH_TITLE"

  # Hide cursor
  printf "\033[?25l"

  while true; do
    clear

    # ── Display current configurations ───────────────────────────
    local count
    count=$(_amri_get_count)

    if [[ "$count" -eq 0 ]]; then
      printf "\n  ${DIM}No refresh intervals configured yet.${NC}\n"
    else
      _amri_print_table
    fi

    # ── Draw menu box ─────────────────────────────────────────────
    echo "$border_top"
    echo "$border_empty"

    local pad=$(( (width - ${#title}) / 2 ))
    printf "┃%*s%s%*s┃\n" $pad "" "$title" $((width - pad - ${#title})) ""

    echo "$border_empty"

    for i in "${!options[@]}"; do
      echo "$border_sep"
      if [[ $i -eq $selected ]]; then
        printf "┃\033[7m  %-2d. %-*s\033[0m┃\n" $((i+1)) $((width-6)) "${options[$i]}"
      else
        printf "┃  %-2d. %-*s┃\n" $((i+1)) $((width-6)) "${options[$i]}"
      fi
    done

    echo "$border_empty"
    echo "$border_bottom"
    echo -e "\nUse ↑ ↓ to navigate, → or Enter to select, ← to Back"

    # ── Read input ────────────────────────────────────────────────
    stty -icanon -echo
    key=$(dd bs=1 count=1 2>/dev/null || echo "")
    if [[ $key == $'\x1b' ]]; then
      key2=$(dd bs=2 count=1 2>/dev/null || echo "")
      case "$key2" in
        "[A") # Up
          ((selected--))
          ((selected < 0)) && selected=$(( ${#options[@]} - 1 ))
          ;;
        "[B") # Down
          ((selected++))
          ((selected >= ${#options[@]})) && selected=0
          ;;
        "[C") # Right → treat as Enter
          key=""
          ;;
        "[D") # Left → Back
          stty sane
          printf "\033[?25h"
          return 0
          ;;
      esac
    fi
    stty sane

    # ── Execute action ────────────────────────────────────────────
    if [[ $key == "" ]]; then
      local choice=$(( selected + 1 ))
      local action_func="ai_model_refresh_interval_action_${choice}"

      printf "\033[?25h"

      if declare -f "$action_func" > /dev/null; then
        clear
        $action_func
        local exit_code=$?

        # Option 4 (Back) returns the sentinel to exit the loop
        if [[ $exit_code -eq $_AMRI_BACK_SENTINEL ]]; then
          return 0
        fi

        echo -e "\nPress Enter to continue..."
        read
      else
        print_status_warning "No action defined for option ${choice}."
        sleep 1
      fi

      printf "\033[?25l"
    fi
  done

  printf "\033[?25h"
}
