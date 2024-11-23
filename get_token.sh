curl -L \
  -X POST \
  -s \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $2" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  $1 | jq -r '.token'
