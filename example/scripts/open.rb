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

sites_container = [
  'amnesty', 
  'business-impact-challenge',
  'connected', 
  'create-an-inspirational-logo-for-openideo',
  'e-waste', 
  'how-can-we-improve-sanitation-and-better-manage-human-waste-in-low-income-urban-communities', 
  'how-might-we-give-children-the-knowledge-to-eat-better', 'how-might-we-improve-health-care-through-social-business-in-low-income-communities', 
  'how-might-we-increase-the-availability-of-affordable-learning-tools-educational-for-children-in-the-developing-world', 
  'how-might-we-increase-the-number-of-bone-marrow-donors-to-help-save-more-lives',
  'impact',
  'localfood',
  'maternal-health',
  'usaid-humanity-united',
  'vibrant-cities',
  'voting',
  'web-start-up',
  'well-work',
  'what-is-the-global-challenge-that-most-concerns-you-right-now-and-that-global-innovation-leaders-could-begin-to-solve', 
  'youth-employment'
]

sites_container.each do |container| 

  Dir.glob('www.openideo.com/open/' + container + '/').each do |site|
    base_site = File.basename(site)
    puts "-------------------------------------------------------------------"
    puts "Parsing path: ".upcase + site.upcase
    puts "-------------------------------------------------------------------"
    count = 0

    # Create folder for XML files
    FileUtils.mkdir_p 'xml/open/' + base_site + '/'
    FileUtils.mkdir_p 'xml/open/' + base_site + '/contributions/'
    FileUtils.mkdir_p 'xml/open/' + base_site + '/comments/'

    # Generate challenge
    # --------------------------------------------------------------------------
    challenge_file = Dir.glob(site + 'brief.html').first
    puts "-------------------------------------------------------------------"
    puts "Parsing file: " + challenge_file
    puts "-------------------------------------------------------------------"

    challenge_page = Nokogiri::HTML(open(challenge_file)) do |config|
      config.strict.noblanks
    end

    # Variables
    challenge_title = challenge_page.css("h2[class='title']").text.strip
    date = challenge_page.css(".details-date > label")[0].next
    start_date = Time.parse(date.text.strip).to_mysql
    end_date = Time.parse(date.next.next.next.next.text.strip).to_mysql
    challenge_followers = challenge_page.css("span[class='followers'] span").text

    # Description
    # Insert additional text after gallery into description
    challenge_description = challenge_page.css("#main-content > .spacer")[0].next.text.strip
    if challenge_page.css("#gallery")[0].next.next.name == 'a'
      challenge_description += " " +  challenge_page.css("#gallery")[0].next.next.next.text.strip
    else
      challenge_description += " " + challenge_page.css("#gallery")[0].next.next.text.strip
    end
    challenge_description.gsub!(/\s\s\s/, '')
    challenge_description.gsub!(/\n/, '')

    ## COMMENTS-----------------------------------------------------------------
    # Generate array with all comment objects
    challenge_comments = []
    challenge_page.css("#comments .comment").each do |obj|
      object = {
        user: obj.css("h4[class='author-name']").text.strip,
        date: Time.parse(obj.css(".comment-body span[class='comment-date']").text).to_mysql,
        description: obj.css(".comment-message").text,
        votes: obj.css("span[class='applaud']").text
      }
      challenge_comments.push(object)
    end

    ## CHALLENGES---------------------------------------------------------------
    # Build XML structure with data
    challenge_builder = Nokogiri::XML::Builder.new(encoding:'UTF-8') do
      challenge {
        title challenge_title unless challenge_title.empty?
        description challenge_description unless challenge_description.empty?
        start_date start_date unless start_date.empty?
        end_date end_date unless challenge_title.empty?
        followers challenge_followers unless challenge_followers.empty?
        document 'challenge'
      }
    end

    challenge_comment_builder = Nokogiri::XML::Builder.new(encoding:'UTF-8') do
      root {
        challenge_comments.each do |comment|
        comments {
          create_date comment[:date] unless comment[:date].empty?
          description comment[:description] unless comment[:description].empty?
          votes comment[:votes] unless comment[:votes].empty?
          user comment[:user] unless comment[:user].empty?
          challenge challenge_title unless challenge_title.empty?
          document 'comment'
        }
        end
      }
    end

    # Create filename based on contribution name
    challenges_file_name = Pathname.new(challenge_file).dirname.basename.to_s + "_challenges.xml"

    # Save XML structure in new file
    if xml = challenge_builder.to_xml
      xml_file = File.new(challenges_file_name, 'w')
      xml_file.write(xml)
      xml_file.close
      FileUtils.mv xml_file, 'xml/open/' + base_site + '/'
    end

    challenges_comments_file_name = Pathname.new(challenge_file).dirname.basename.to_s + "_comments.xml"

    if xml = challenge_comment_builder.to_xml
      xml_file = File.new(challenges_comments_file_name, 'w')
      xml_file.write(xml)
      xml_file.close
      FileUtils.mv xml_file, 'xml/open/' + base_site + '/'
    end

    count += 1

    # Generate contributions
    #---------------------------------------------------------------------------

    folders = ['inspiration', 'concepting']

    folders.each do |folder|
      puts "-------------------------------------------------------------------"
      puts "Going into folder: ".upcase + folder.upcase
      puts "-------------------------------------------------------------------"

      # Delete all unnecessary files
      FileUtils.rm Dir.glob(site + folder + '/*.html')
      # Run script for each file in specific folder
      Dir.glob(site + folder + '/*/index.html').each do |file|
        puts "Parsing file: " + file

        # Configuration
        page = Nokogiri::HTML(open(file)) do |config|
          config.strict.noblanks
        end

        ## CONTRIBUTION---------------------------------------------------------

        title = page.css("h2[class='item-title']").text
        challenge = page.css("h2[class='title']").text.strip
        if page.at_css(".date")
          date = Time.parse(page.css("div[class='date']").text).to_mysql
        end
        views = page.css("#content-submitted-by span[class='views']").text.gsub(/[^0-9]/, '')
        comments = page.css("#content-submitted-by span[class='comments']").text.gsub(/[^0-9]/, '')
        votes = page.css("#content-submitted-by span[class='votes']").text.gsub(/[^0-9]/, '')
        user = page.css("#content-submitted-by .text a").text
        user_name = page.css(".author-name").text

        # Tags
        if page.at_css("#gallery")
          tag = page.css("#gallery")[0]
        end

        # Description
        description = ''
        if page.at_css("h2[class='item-title']")
          description = page.css("h2[class='item-title']")[0].next.text.strip
        end

        # Save complete description in one string
        if page.at_css("h2[class='item-title']") && page.at_css("#gallery")
          begin
            if tag
              tag = tag.next
              feed = tag.text.strip
              description += feed + " "
            end
          end until tag.name == 'div' || tag.name == 'visual'
          description.gsub!(/\s\s\s/, '')
          description.gsub!(/\n/, '')
        end

        # Questions
        questions = page.css("div[id='content-questions']").text

        # Remove whitespaces between sentences
        questions.gsub!(/\s\s\s\s/, '')

        description << questions

        ## COMMENTS-------------------------------------------------------------
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

        ## CONTRIBUTIONS--------------------------------------------------------
        # Build XML structure for contributions
        contribution_builder = Nokogiri::XML::Builder.new(encoding:'UTF-8') do
          contribution {
            title title unless title.empty?
            description description unless description.nil?
            create_date date unless date.nil?
            views views unless views.empty?
            votes votes unless votes.empty?
            challenge challenge unless challenge.empty?
            user user unless user.empty?
            document 'contribution'
          }
        end

        # Create filename based on type name
        contributions_file_name = Pathname.new(file).dirname.basename.to_s +  "_contributions.xml"

        # Save XML structure in new file
        if xml = contribution_builder.to_xml
          xml_file = File.new(contributions_file_name, 'w')
          xml_file.write(xml)
          xml_file.close
          FileUtils.mv xml_file, 'xml/open/' + base_site + '/contributions/'
        end

        ## COMMENTS-------------------------------------------------------------
        # Build XML structure for comments
        comment_builder = Nokogiri::XML::Builder.new(encoding:'UTF-8') do
          root {
            # Including comments of inspiration and concepting
            comments.each do |comment|
            comments {
              create_date comment[:date] unless comment[:date].empty?
              description comment[:description] unless comment[:description].empty?
              votes comment[:votes] unless comment[:votes].empty?
              user comment[:user] unless comment[:user].empty?
              challenge challenge unless challenge.empty?
              contribution title unless title.empty?
              document 'comment'
            }
            end
          }
        end

        ## Create filename based on type name
        comments_file_name = Pathname.new(file).dirname.basename.to_s + '_comments.xml'

        # Save XML structure in new file
        if xml = comment_builder.to_xml
          xml_file = File.new(comments_file_name, 'w')
          xml_file.write(xml)
          xml_file.close
          FileUtils.mv xml_file, 'xml/open/' + base_site + '/comments/'
        end

        # Increment total number of parsed files
        count += 1
      end
    end
    puts "Successfully parsed and saved " + count.to_s + " files"
  end
end