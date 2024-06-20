#!/bin/bash

#############################
# About: A Shell script to list out the collaborators of "repo" of "your organizations" section using Github-API
# 
# Inputs: Required to export "username" and "token" before executing the script
#
# Caution: while executing script pass the 2 command line arguments "your_organizations_name" "your_repo_name"
#
# Owner: uday
# 
# Date: 20-06-2024
##############################


# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2


# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Helper function for user alerts or to know exactly what is the error
#
# Function to check command-line arguments
function helper {
  expected_cmd_args=2
  if [ "$#" -ne $expected_cmd_args ];
  then
     echo "please execute the script with required command line arguments"
     echo "organzation name:" and "repo name:"
     exit 1
  fi
}

# Call the helper function to check command-line arguments
 helper "$@"


# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access

