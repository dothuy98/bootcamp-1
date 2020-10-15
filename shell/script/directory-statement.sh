#!/bin/bash

# mkdir child-directory-a child-directory-b を実行済み

touch child-directory-a/test.txt
echo "$0によってつくられたファイル" >> child-directory-a/test.txt
cd child-directory-a
mv test.txt ../child-directory-b
cd ../child-directory-b
mv test.txt ../
