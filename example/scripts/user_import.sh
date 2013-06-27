#!/bin/bash

echo "Password: "
stty -echo
read pass
stty echo

find "xml/user" | while read -r file
do
  mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE users ROWS IDENTIFIED BY '<user>';"
  echo "File imported: $file"

  mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE comments ROWS IDENTIFIED BY '<comments>';"
  mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE collections ROWS IDENTIFIED BY '<comments>';"
  echo "File imported: $file"
done
