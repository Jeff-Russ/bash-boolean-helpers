#!/usr/bin/env bash
# bool_helpers install.sh

SRC_DIR=$(cd "$(dirname ${BASH_SOURCE})" && pwd)
echo "==================================="
echo "making all .sh files in ""$SRC_DIR"
echo " executable by you only"
chmod u+x "$SRC_DIR"/*.sh
BRC_STR="source ""\"${SRC_DIR}/bool-helpers.sh\""
echo
echo "appending ""$HOME"/.bashrc
echo " with ""$BRC_STR"
echo "$BRC_STR" >> "$HOME"/.bashrc
echo
echo "installation complete."
echo "To view the man page, run:"
echo
echo "   $ bool-helpers"
echo
echo "To uninstall, remove the line or run ./uninstall.sh"
echo "==================================="

