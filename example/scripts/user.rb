#!/usr/bin/env ruby
require 'fileutils'
require 'rubygems'
require 'nokogiri'
require 'time'
require 'pathname'

# Modifying Time class to parse time into MySQL friendly version
class Time
  def to_mysql
    self.strftime("%Y-%m-%d %H:%M:%S")
  end
end

count = 0

# Generate user
#-------------------------------------------------------------------------

# Delete all unnecessary files
FileUtils.rm Dir.glob('www.openideo.com/profiles/*.html')

# Create folder for XML files
FileUtils.mkdir_p 'xml/user/'

# Run script for each file in specific folder
Dir.glob('www.openideo.com/profiles/*/index.html').each do |file|
  puts "Parsing file: " + file

  # Configuration
  page = Nokogiri::HTML(open(file)) do |config|
    config.strict.noblanks
  end

  # Variables
  nick = Pathname.new(file).dirname.basename.to_s
  name = page.css("#profile > h2").text.strip
  motto = page.css("#profile > h3").text.strip
  bio = page.css("#bio").text.strip
  join_date = Time.parse(page.css("#profile-info p")[0].children[3].text).to_mysql
  if page.css("#profile-info p")[1] != nil && page.css("#profile-info p")[1].children[1].text == "Occupation:"
    occupation = page.css("#profile-info p")[1].children[3].text
  end
  if page.css("#profile-info p")[2] != nil && page.css("#profile-info p")[2].children[1].text == "Company:"
    company = page.css("#profile-info p")[2].children[3].text
  end
  if page.css("#profile-info p")[3] != nil && page.css("#profile-info p")[3].children[1].text == "Country:"
    country = page.css("#profile-info p")[3].children[3].text
  end

  ## Comments
  # Generate array with all comment objects
  comments = []
  page.css("#comments .comment").each do |obj|
    object = {
      user: obj.css("h4[class='author-name']").text.strip,
      date: Time.parse(obj.css(".comment-body span[class='comment-date']").text).to_mysql,
      description: obj.css(".comment-message").text,
      votes: obj.css("span[class='applaud']").text
    }
    comments.push(object)
  end

  # Build XML structure with data
  builder = Nokogiri::XML::Builder.new(encoding:'UTF-8') do
    profile {
      user {
        nick nick unless nick.nil?
        name name unless name.nil?
        motto motto unless motto.nil?
        bio bio unless bio.nil?
        join_date join_date unless join_date.nil?
        occupation occupation unless occupation.nil?
        company company unless company.nil?
        country country unless country.nil?
      }
      comments.each do |comment|
      comments {
        user comment[:user] unless comment[:user].nil?
        create_date comment[:date] unless comment[:date].nil?
        description comment[:description] unless comment[:description].nil?
        votes comment[:votes] unless comment[:votes].nil?
        profile name unless name.nil?
        document 'comment'
      }
      end
    }
  end

  # Create file name based on folder name
  file_name = Pathname.new(file).dirname.basename.to_s 

  # Save XML structure in new file
  if xml = builder.to_xml
    xml_file = File.new(file_name + '.xml', 'w')
    xml_file.write(xml)
    xml_file.close
    FileUtils.mv xml_file, 'xml/user/'
  end
  # Increment total number of parsed files
  count += 1
end

puts "Successfully parsed and saved " + count.to_s + " files"

