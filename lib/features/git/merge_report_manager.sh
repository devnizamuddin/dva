#!/bin/bash

#* ┏==================================================================================================┓
#* ┃                              📊 Merge Report Manager                                             ┃
#* ┗==================================================================================================┛

function run_merge_report() {

  set -e

  TARGET_BRANCH=${1:-main}
  REPORT_FILE="merge-report-$(date +%Y%m%d-%H%M%S).md"

  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not inside a git repository"
    exit 1
  fi

  echo "🔍 Fetching latest remote data..."
  git fetch --all --prune

  CURRENT_BRANCH=$(git branch --show-current)

  echo "# Git Merge Analysis Report" > "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  echo "- Generated: $(date)" >> "$REPORT_FILE"
  echo "- Target Branch: \`$TARGET_BRANCH\`" >> "$REPORT_FILE"
  echo "- Repository: $(basename "$(git rev-parse --show-toplevel)")" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"

  echo "## Branch Summary" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"

  printf "%-35s %-12s %-12s %-15s\n" \
    "Branch" "Ahead" "Behind" "Merge Status"

  echo "" >> "$REPORT_FILE"
  echo "| Branch | Ahead | Behind | Merge Status |" >> "$REPORT_FILE"
  echo "|---|---|---|---|" >> "$REPORT_FILE"

  BRANCHES=$(git for-each-ref \
    --format='%(refname:short)' refs/heads/)

  for BRANCH in $BRANCHES; do

    if [ "$BRANCH" = "$TARGET_BRANCH" ]; then
      continue
    fi

    # Ahead / Behind
    COUNTS=$(git rev-list --left-right --count \
      "$TARGET_BRANCH...$BRANCH")

    BEHIND=$(echo "$COUNTS" | awk '{print $1}')
    AHEAD=$(echo "$COUNTS" | awk '{print $2}')

    # Merge conflict detection
    git checkout "$TARGET_BRANCH" > /dev/null 2>&1

    if git merge --no-commit --no-ff "$BRANCH" \
        > /dev/null 2>&1; then

      STATUS="✅ Clean Merge"
      git merge --abort > /dev/null 2>&1 || true

    else
      STATUS="⚠️ Conflicts"
      git merge --abort > /dev/null 2>&1 || true
    fi

    printf "%-35s %-12s %-12s %-15s\n" \
      "$BRANCH" "$AHEAD" "$BEHIND" "$STATUS"

    echo "| \`$BRANCH\` | $AHEAD | $BEHIND | $STATUS |" \
      >> "$REPORT_FILE"

  done

  git checkout "$CURRENT_BRANCH" > /dev/null 2>&1

  echo "" >> "$REPORT_FILE"
  echo "## Detailed Commit Differences" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"

  for BRANCH in $BRANCHES; do

    if [ "$BRANCH" = "$TARGET_BRANCH" ]; then
      continue
    fi

    echo "### $BRANCH" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    echo "#### Commits in $BRANCH but not in $TARGET_BRANCH" \
      >> "$REPORT_FILE"

    echo '```' >> "$REPORT_FILE"

    git log --oneline \
      "$TARGET_BRANCH..$BRANCH" \
      >> "$REPORT_FILE"

    echo '```' >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    echo "#### Commits in $TARGET_BRANCH but not in $BRANCH" \
      >> "$REPORT_FILE"

    echo '```' >> "$REPORT_FILE"

    git log --oneline \
      "$BRANCH..$TARGET_BRANCH" \
      >> "$REPORT_FILE"

    echo '```' >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

  done

  echo ""
  echo "✅ Merge report generated:"
  echo "📄 $REPORT_FILE"
  echo ""
}
