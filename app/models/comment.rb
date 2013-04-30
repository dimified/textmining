class Comment < ActiveRecord::Base
	require 'language_processing'
  attr_accessible :challenge, :comment_id, :contribution, :create_date, :message, :user, :votes
  include LanguageProcessing
end
