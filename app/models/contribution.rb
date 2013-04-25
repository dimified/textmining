class Contribution < ActiveRecord::Base
  require 'language_processing'
  attr_accessible :challenge, :contribution_id, :create_date, :description, :questions, :title, :user, :views, :votes
  include LanguageProcessing
end
