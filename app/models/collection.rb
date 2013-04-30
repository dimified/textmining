class Collection < ActiveRecord::Base
  require 'language_processing'
  attr_accessible :collection_id, :description, :lemma, :title, :document, :user
  include LanguageProcessing
end
