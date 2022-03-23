#!/bin/sh

set -ex

CLONE_DIR=$(mktemp -d)

git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.email "$INPUT_USER_NAME"
git clone --single-branch --branch main "https://x-access-token:$API_TOKEN_GITHUB@github.com/unspun/fw-vega.git" "$CLONE_DIR"

if [[ "$INPUT_TYPE" == "BOOTLOADER" ]]
then
  cp -R "fw_upload" "$CLONE_DIR"
  cp "upload_all" "$CLONE_DIR"
  cp "upload_manifest.template.json" "$CLONE_DIR"
elif [[ "$INPUT_TYPE" == "FW" ]]
then
  rm -rf "$INPUT_BASE_ARTIFACT-*"
  cp -R "$INPUT_SOURCE_FILE_MFG" "$CLONE_DIR"
  cp -R "$INPUT_SOURCE_FILE_UPLOAD" "$CLONE_DIR"
fi

cd "$CLONE_DIR"
git add .
if git status | grep -1 "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MESSAGE"
  git push -u origin HEAD:main
fi
