#!/bin/bash
# type "./SPAM" in terminal
echo "***SENDING..."
for i in {1..1000}
do
  node ./spam.js
  echo "Sent Tx number $i"
done
echo "***DONE."
