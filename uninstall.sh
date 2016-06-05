#!/usr/bin/env bash
# bool_helpers uninstall.sh

SRC_DIR=$(cd "$(dirname ${BASH_SOURCE})" && pwd)
BRC_STR="source ""\"${SRC_DIR}/bool-helpers.sh\""
echo "==================================="
echo "searching for \"bool-helpers.sh\" in ""$HOME"/.bashrc

sed -i.bak '/bool-helpers.sh/d' "$HOME"/.bashrc
echo "a backup of ~/.bashrc will be made: ~/.bashrc.bak"
echo
echo "Uninstallation complete."
echo "To reinstall, run ./install.sh"
echo "==================================="


