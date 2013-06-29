class ApplicationController < ActionController::Base
  protect_from_forgery

  $stop_words = []
  File.open(Dir.pwd + '/app/assets/documents/stopwords_en.txt', 'r').each_line do |line|
    $stop_words.push(line.strip)
  end

  $record_set = Collection.limit(400)
  $record_size = $record_set.size
  
  $dictionary = DocumentTermMatrix.new.dictionary
end
