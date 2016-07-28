#!/bin/bash

for i in {99..1}
do
  echo "$i bottles of beer on the wall, $i bottles of beer, take one down, pass it around, $(($i-1)) bottles of beer on the wall";
  sleep 1
done

echo "all drunk!"
