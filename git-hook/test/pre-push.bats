#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$GIT_TEST_PROJECT_PATH"
  cd "$GIT_TEST_PROJECT_PATH"
  cp "$GIT_SRC_INSTALL_PATH/test/package.json" "$GIT_TEST_PROJECT_PATH/package.json"
  cp "$GIT_SRC_INSTALL_PATH/test/LICENSE" "$GIT_TEST_PROJECT_PATH/LICENSE"
  git init
  git config user.email sunnyadi@163.com
  git config user.name wangzengdi
  npm install "$GIT_SRC_PROJECT_PATH" --save

  mkdir -p "$GIT_TEST_REPOSITORY_PATH"
  git remote add origin "$GIT_TEST_REPOSITORY_PATH"
  cd "$GIT_TEST_REPOSITORY_PATH"
  git init --bare
  cd "$GIT_TEST_PROJECT_PATH"
}

@test "pre-push: test push" {
git add .
git commit -m "commit message"
git push origin master
assert_output_contains "error"
}
