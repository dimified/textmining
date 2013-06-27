#!/bin/bash
find $1* | while read -r file
do
    newfile=$(echo "$file" | sed 's/.tmp//g')
    mv "$file" "$newfile"
    echo "removed .tmp in $file"
done
