# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
NC="\033[0m"

# Logs
LOG_FILE="$HOME/.dva/logs/dva.log"
mkdir -p "$(dirname "$LOG_FILE")"

function log_task() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}
