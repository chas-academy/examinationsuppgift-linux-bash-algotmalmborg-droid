#!/bin/bash
if [ "$EUID" -ne 0 ];   then
  echo "ERROR: Script not in root"
  exit 1
  fi
