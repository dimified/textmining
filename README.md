Text Mining Application on Openideo
===================================

Bachelor Thesis 2: Practical approach of a recommendation system for textual content on basis of text mining.

Please refer to these instructions for using the parser and importer scripts. All script files should be in the same directory of the training data. The folder structure should look as following:

    Openideo_Training
      |-- open_import.sh
      |-- open.rb
      |-- rename.sh
      |-- user_import.sh
      |-- user.rb
      |-- www.openideo.com (Crawled Content)

IMPORTANT NOTE: For successful execution of all script it is highly recommended to name the root folder "openideo_training". If it is needed to use another name, you have to edit each script except rename.sh.

## 1. Renaming each file

The script "rename.sh" is used to rename each .tmp file into a .html file and to delete unneccessary files. You can optionally provide a parameter with the folder (e.g. ./rename.sh open) to specify the path in which the script should be processed. If no parameter exists the script will process each file in the subdirectories.

    ./rename.sh <<folder>>
    ./rename.sh open

## 2. Parsing content and saving into xml files

    ruby open.rb
    
The open script parses all data of contributions, challenges, comments inside www.openideo.com/open/ and generates a xml file.

    ruby user.rb
    
The user script parses all data of user inside www.openideo.com/profiles/ and generates a xml file.

## 3. Importing xml files into mysql database

NOTE: It is recommended to execute rake db:migrate to create the schema structure before importing any xml files.

    ./open_import.sh

The script "open_import.sh" imports the xml files into the database. It considers data from challenges, comments, contributions and tags. The password to connect to the database will be asked when script is called.

    ./user_import.sh

The script "user_import.sh" does take the version or date respectively as well as a parameter for importing xml files into the database.
