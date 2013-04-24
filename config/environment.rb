# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Textmining::Application.initialize!

# add method for counting words
class String
  def count_words
    self.split.size
  end
end 