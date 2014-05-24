#!/bin/bash
if (g++ "$1" -o "$2"); then
  echo "Compile successfully"
fi
