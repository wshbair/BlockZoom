#!/bin/bash
# type "./SPAM" in terminal
echo "***SENDING..."
for i in {1..1000}
do
  node /root/BlockZoom/rippled/transaction.js
  echo "Sent Tx number $i"
done
echo "***DONE."
