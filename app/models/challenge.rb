class Challenge < ActiveRecord::Base
	require 'language_processing'
  attr_accessible :challenge_id, :description, :end_date, :followers, :start_date, :title
  include LanguageProcessing
end
