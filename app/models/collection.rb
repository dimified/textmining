class Collection < ActiveRecord::Base
  attr_accessible :collection_id, :description, :lemma, :title, :type, :user
end
