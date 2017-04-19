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

  echo "${BATS_TMPDIR}"
  BATS_TMPDIR="$BATS_TMPDIR"
  mkdir -p "$GIT_TEST_REPOSITORY_PATH"
  cd "$GIT_TEST_REPOSITORY_PATH"
  git init --bare repo.git
  cd "$GIT_TEST_PROJECT_PATH"
  GIT_TEST_REPOSITORY_PATH="$GIT_TEST_REPOSITORY_PATH/repo.git"
  git remote add origin $GIT_TEST_REPOSITORY_PATH
  touch .gitignore
  echo "node_modules" >> .gitignore
}

@test "pre-push: test push" {
git co -b feature/TASK-9527
git add .
git commit -m "commit message"
run git push origin master
assert_success
}
