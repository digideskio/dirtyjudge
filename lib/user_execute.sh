#!/bin/bash
CMD="time $1; read -p 'Press Enter to continue'"
gnome-terminal -x bash -c "$CMD"
