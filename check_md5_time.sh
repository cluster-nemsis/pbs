#!/bin/bash

FILE1="test1.txt"
FILE2="test2.txt"
SIZE="512MB";

## Create files
echo "Generating ${FILE1}... ";
time head -c ${SIZE} /dev/urandom > ${FILE1};
echo "Generating ${FILE2}... ";
time head -c ${SIZE} /dev/urandom > ${FILE2};

## Dropping caches
echo -n "Dropping caches... ";
echo 3 | sudo tee /proc/sys/vm/drop_caches; 

## Create md5sum for each file and determine time to do it
echo "Generating MD5 for ${FILE1}...";
time md5sum ./${FILE1} > ${FILE1}.md5;
echo "Generating MD5 for ${FILE2}...";
time md5sum ./${FILE2} > ${FILE2}.md5;

