#!/bin/bash

# Replace these variables
GITLAB_URL="http://versioncontrol.vertoz.com"        # your GitLab instance URL
GROUP_PATH="Devops_Systems%2FJenkins"
TOKEN="gTDfJVs_XB4H_GjTNxsh"

# Get all repo HTTP URLs
repos=$(curl --silent --header "PRIVATE-TOKEN: $TOKEN" \
    "$GITLAB_URL/api/v4/groups/$GROUP_PATH/projects?per_page=100" | \
    jq -r '.[].http_url_to_repo')

# Clone each repo using token
for repo in $repos; do
    # Inject token into URL for HTTP authentication
    repo_with_token=${repo/http:\/\//http:\/\/oauth2:$TOKEN@}
    echo "Cloning $repo_with_token ..."
    git clone "$repo_with_token"
done
