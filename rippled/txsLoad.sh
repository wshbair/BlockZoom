#!/bin/bash
# type "./SPAM" in terminal
echo "***SENDING..."
for i in {1..3}
do
  node ./transaction.js
  echo "Sent Tx number $i"
done
echo "***DONE."
