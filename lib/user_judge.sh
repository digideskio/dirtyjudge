#/bin/bash
time -p timeout 1s "$1" < "$2" > "user_output"
EXIT=$?
if [ $EXIT ]; then
  if (diff user_output "$3")
  then echo "Correct"
  else EXIT=1
  fi
elif [ $EXIT -ne 124 ]; then
  echo "Runtime error, exit code $EXIT";
else
  echo "Time limit exceeded"
fi
exit $EXIT
