#!/usr/bin/env bash

load ../../node_modules/bats-assert/all

# Set path vars
GIT_SRC_PROJECT_PATH="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
GIT_SRC_INSTALL_PATH="$GIT_SRC_PROJECT_PATH/git-hook"
GIT_SRC_HOOK_PATH="${GIT_SRC_INSTALL_PATH}/hooks"
GIT_SRC_TEST_PATH="${GIT_SRC_INSTALL_PATH}/test"

# Temporary directory
if [ -z "$GIT_TEST_TMP_DIR" ]
then
  GIT_TEST_TMP_DIR="$(mktemp -d)"
fi

if [ -z "$GIT_TEST_PROJECT_PATH" ]
then
  GIT_TEST_PROJECT_PATH="$GIT_TEST_TMP_DIR/project"
  GIT_TEST_INSTALL_PATH="$GIT_TEST_PROJECT_PATH/node_modules/git-client-hook/git-hook"
  GIT_TEST_HOOK_PATH="$GIT_TEST_INSTALL_PATH/hooks"
  GIT_TEST_GIT_HOOKS_PATH="$GIT_TEST_PROJECT_PATH/.git/hooks"

  PATH="$GIT_TEST_HOOK_PATH:$GIT_TEST_INSTALL_PATH:$PATH"
fi

if [ -z "$GIT_TEST_REPOSITORY_PATH" ]
then
  GIT_TEST_REPOSITORY_PATH="$GIT_TEST_TMP_DIR/repository"
fi

teardown() {
  rm -rf "$(cd $GIT_TEST_TMP_DIR; pwd -P)"
}
