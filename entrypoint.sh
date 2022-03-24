#!/bin/bash

set -ex

CLONE_DIR=$(mktemp -d)
FW_STRING="FW"
BOOT_STRING="BOOTLOADER"

git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.email "$INPUT_USER_NAME"
git clone --single-branch --branch main "https://x-access-token:$API_TOKEN_GITHUB@github.com/unspun/fw-vega.git" "$CLONE_DIR"

if [[ "$INPUT_TYPE" == "$BOOT_STRING" ]]
then
  echo "Copying over bootloader resources"
  cp -R "tools/fw_upload" "$CLONE_DIR"
  cp -R "tools/upload_all" "$CLONE_DIR"
  cp -R "tools/update_manifest.template.json" "$CLONE_DIR"
elif [[ "$INPUT_TYPE" == "$FW_STRING" ]]
then
  rm -rf "$CLONE_DIR"/"$INPUT_BASE_ARTIFACT"-*
  echo "Adding files: $INPUT_SOURCE_FILE_MFG & $INPUT_SOURCE_FILE_UPLOAD"
  cp -R "$INPUT_SOURCE_FILE_MFG" "$CLONE_DIR"
  cp -R "$INPUT_SOURCE_FILE_UPLOAD" "$CLONE_DIR"
fi

cd "$CLONE_DIR"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MESSAGE"
  echo "Pushing git commit"
  git push -u origin HEAD:main
fi
