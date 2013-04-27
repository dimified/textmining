class ApplicationController < ActionController::Base
  protect_from_forgery

  $stop_words = []
  File.open(Dir.pwd + '/app/assets/documents/stopwords_en.txt', 'r').each_line do |line|
    $stop_words.push(line.strip)
  end
end
