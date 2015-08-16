#!/bin/bash -e

# Copyright (c) 2015 The zerocash Authors. All rights reserved.
# Use of this source code is governed by a MIT license that can be
# found in the LICENSE file.

# Script to install everything needed to build zerocash

# Packages needed for development
dev_list="autoconf libdb++-dev libboost-all-dev libssl-dev libprotobuf-dev
          protobuf-compiler libqrencode-dev libqt4-dev libminiupnpc-dev"

sudo apt-get update

packages="$(
  echo "${dev_list}" |
  tr " " "\n" | sort -u | tr "\n" " "
)"

# We initially run "apt-get" with the --reinstall option and parse its output.
# This way, we can find all the packages that need to be newly installed
# without accidentally promoting any packages from "auto" to "manual".
# We then re-run "apt-get" with just the list of missing packages.
echo "Finding missing packages..."
# Intentionally leaving $packages unquoted so it's more readable.
echo "Packages required: " $packages
echo
new_list_cmd="sudo apt-get install --reinstall $(echo $packages)"
if new_list="$(yes n | LANGUAGE=en LANG=C $new_list_cmd)"; then
  # We probably never hit this following line.
  echo "No missing packages, and the packages are up-to-date."
elif [ $? -eq 1 ]; then
  # We expect apt-get to have exit status of 1.
  # This indicates that we cancelled the install with "yes n|".
  new_list=$(echo "$new_list" |
    sed -e '1,/The following NEW packages will be installed:/d;s/^  //;t;d')
  new_list=$(echo "$new_list" | sed 's/ *$//')
  if [ -z "$new_list" ] ; then
    echo "No missing packages, and the packages are up-to-date."
  else
    echo "Installing missing packages: $new_list."
    sudo apt-get install ${new_list}
  fi
  echo
else
  # An apt-get exit status of 100 indicates that a real error has occurred.
  # I am intentionally leaving out the '"'s around new_list_cmd,
  # as this makes it easier to cut and paste the output
  echo "The following command failed: " ${new_list_cmd}
  echo
  echo "It produces the following output:"
  yes n | $new_list_cmd || true
  echo
  echo "You will have to install the above packages yourself."
  echo
  exit 100
fi