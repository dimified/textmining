#!/bin/bash

echo "Password: "
stty -echo
read pass
stty echo

sites=('amnesty' 'business-impact-challenge' 'connected' 'create-an-inspirational-logo-for-openideo' 'e-waste' 'how-can-we-improve-sanitation-and-better-manage-human-waste-in-low-income-urban-communities' 'how-might-we-give-children-the-knowledge-to-eat-better' 'how-might-we-improve-health-care-through-social-business-in-low-income-communities' 'how-might-we-increase-the-availability-of-affordable-learning-tools-educational-for-children-in-the-developing-world' 'how-might-we-increase-the-number-of-bone-marrow-donors-to-help-save-more-lives' 'impact' 'localfood' 'maternal-health' 'usaid-humanity-united' 'vibrant-cities' 'voting' 'web-start-up' 'well-work' 'what-is-the-global-challenge-that-most-concerns-you-right-now-and-that-global-innovation-leaders-could-begin-to-solve' 'youth-employment')

for i in "${sites[@]}"
do
  find "xml/open/$i/$i""_challenges.xml" | while read -r file
  do
    mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE challenges ROWS IDENTIFIED BY '<challenge>';"
    echo "File imported: $file"
  done

  find "xml/open/$i/$i""_comments.xml" | while read -r file
  do
    mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE comments ROWS IDENTIFIED BY '<comments>';"
    mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE collections ROWS IDENTIFIED BY '<comments>';"
    echo "File imported: $file"
  done

  find "xml/open/$i/comments" | while read -r file
  do
    mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE comments ROWS IDENTIFIED BY '<comments>';"
    mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE collections ROWS IDENTIFIED BY '<comments>';"
    echo "File imported: $file"
  done

  find "xml/open/$i/contributions" | while read -r file
  do
    mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE contributions ROWS IDENTIFIED BY '<contribution>';"
    mysql -u root -p$pass -s -e "USE openideo_training; LOAD XML LOCAL INFILE '/Users/dimitrireifschneider/Websites/Openideo_Training/$file' INTO TABLE collections ROWS IDENTIFIED BY '<contribution>';"
    echo "File imported: $file"
  done
done
