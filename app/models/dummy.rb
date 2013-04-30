class Dummy < ActiveRecord::Base
	require 'language_processing'
  attr_accessible :description, :document, :dummy_id, :lemma, :title, :user
  include LanguageProcessing
end