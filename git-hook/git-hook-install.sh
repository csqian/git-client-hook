#!/bin/bash

INSTALL_PATH=$(dirname "$0")
GIT_ROOT_DIR=$(git rev-parse --show-toplevel || echo "$INSTALL_PATH/../../..")
PROJECT_ROOT=${PROJECT_ROOT:-$(cd "$GIT_ROOT_DIR"; pwd -P)}
FROM_HOOK_PATH="$INSTALL_PATH/hooks"
TO_HOOK_PATH="$PROJECT_ROOT/.git/hooks"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
AFFECT_HOOKFILES=$(ls "$TO_HOOK_PATH" "$FROM_HOOK_PATH" |grep -v "\." |sort |uniq)

echo "INSTALL_PATH $INSTALL_PATH" >> ~/a.txt
echo "GIT_ROOT_DIR $GIT_ROOT_DIR" >> ~/a.txt
echo "PROJECT_ROOT $PROJECT_ROOT" >> ~/a.txt
echo "FROM_HOOK_PATH $FROM_HOOK_PATH" >> ~/a.txt
echo "TO_HOOK_PATH $TO_HOOK_PATH" >> ~/a.txt
echo -e "" >> ~/a.txt

is_node_env_dev() {
  node_env=$1
  if [ -n "$node_env" -a "$node_env" != "development" ]; then
    echo "No need to install git-hook in NODE_ENV: $node_env."
    exit 0
  fi
}

has_git_hooks_path() {
  echo $1 >> ~/a.txt
  if [ ! -d "$1" ]; then
    echo "No '.git' directory exist!"
    exit 0
  fi
}

is_node_env_dev $NODE_ENV
has_git_hooks_path $TO_HOOK_PATH

for hook_file in $AFFECT_HOOKFILES
do
  if [ -f "$TO_HOOK_PATH/$hook_file" ]
  then
    if [ -f "$FROM_HOOK_PATH/$hook_file" ]
    then
      diff_info=$(diff "$FROM_HOOK_PATH/$hook_file" "$TO_HOOK_PATH/$hook_file")
      if [ ! -z "$diff_info" ]
      then
        INSTALL_HOOKS+=($hook_file)
        EXIST_HOOKS+=($hook_file)
      fi
    else
      EXIST_HOOKS+=($hook_file)
    fi
  elif [ -f "$FROM_HOOK_PATH/$hook_file" ]
  then
    INSTALL_HOOKS+=($hook_file)
  fi
done
  

if [ ${#EXIST_HOOKS[@]} -gt 0 ]
then
  for hook_file in ${EXIST_HOOKS[@]}
  do
    echo "bak up $hook_file"
    mv "$TO_HOOK_PATH/$hook_file" "$TO_HOOK_PATH/$hook_file.$TIMESTAMP"
  done
fi

if [ ${#INSTALL_HOOKS[@]} -gt 0 ]
then
  echo -e "GIT CLIENT HOOK installing...! ⚙ \n"
  for hook_file in ${INSTALL_HOOKS[@]}
  do
    echo "install $hook_file"
    cp "$FROM_HOOK_PATH/$hook_file" "$TO_HOOK_PATH/$hook_file"
  done
  echo "GIT CLIENT HOOK install done!  🍻 "
else
  echo "No git client hooks should install"
fi

