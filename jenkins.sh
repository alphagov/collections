#!/bin/bash
set -x
export REPO_NAME=${REPO_NAME:-"alphagov/collections"}
export CONTEXT_MESSAGE=${CONTEXT_MESSAGE:-"default"}
export GH_STATUS_GIT_COMMIT=${SCHEMA_GIT_COMMIT:-${GIT_COMMIT}}
env

function github_status {
  REPO_NAME="$1"
  STATUS="$2"
  MESSAGE="$3"
  gh-status "$REPO_NAME" "$GH_STATUS_GIT_COMMIT" "$STATUS" -d "Build #${BUILD_NUMBER} ${MESSAGE}" -u "$BUILD_URL" -c "$CONTEXT_MESSAGE" >/dev/null
}

function error_handler {
  trap - ERR # disable error trap to avoid recursion
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  github_status "$REPO_NAME" error "errored on Jenkins"
  exit "${code}"
}

trap 'error_handler ${LINENO}' ERR
github_status "$REPO_NAME" pending "is running on Jenkins"

# Cleanup anything left from previous test runs
git clean -fdx

# Clone govuk-content-schemas depedency for contract tests
rm -rf tmp/govuk-content-schemas
git clone git@github.com:alphagov/govuk-content-schemas.git tmp/govuk-content-schemas
(
  cd tmp/govuk-content-schemas
  git checkout ${SCHEMA_GIT_COMMIT:-"master"}
)
export GOVUK_CONTENT_SCHEMAS_PATH=tmp/govuk-content-schemas

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

export RAILS_ENV=test
TEST_TASKS="default spec:javascript assets:precompile"

for task in $TEST_TASKS; do
  if ! bundle exec rake $task; then
    github_status "$REPO_NAME" failure "failed on Jenkins"
    exit 1
  fi
done

github_status "$REPO_NAME" success "succeeded on Jenkins"
