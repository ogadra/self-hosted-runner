check() {
  check_rate_limit() {
    if [[ $1 == *"rate limit"* ]]; then
      echo "ERROR: Rate limit has been exceeded."
      return 1
    fi
    return 0
  }
  
  if ! command -v jq &>/dev/null; then
    echo "ERROR: 'jq' is not installed but is required."
    return 1
  fi
 
  if ! response=$(curl -s "https://api.github.com/repos/actions/runner/releases/latest" 2>/dev/null); then
    echo "ERROR: Failed to get the latest release of runner via the GitHub API."
    return 1
  fi
 
  check_rate_limit "$response" || return 1

  if ! ver=$(echo "$response" | jq -r .tag_name 2>/dev/null); then
    echo $var;
    echo "ERROR: 'tag_name' does not exist in the response."
    return 1
  fi
 
  if [[ ! $ver == 'null' ]]; then
    # Remove 'v' prefix if it exists
    echo "${ver#v}"
    return 0
  fi
 
  if ! response=$(curl -s "https://api.github.com/repos/actions/runner/tags" 2>/dev/null); then
    echo "ERROR: Failed to get the latest tag of runner via the GitHub API."
    return 1
  fi
 
  check_rate_limit "$response" || return 1
 
  if ! tags=$(echo "$response" | jq ".[].name" 2>/dev/null); then
    echo "ERROR: 'name' does not exist in the response."
    return 1
  fi
 
  if ! echo "$tags" | jq -r 'sort_by(.) | reverse | .[0]'; then
    echo "ERROR: Failed to parse the latest tag of runner via the GitHub API."
    return 1
  fi
}

check
