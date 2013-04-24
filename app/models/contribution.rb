class Contribution < ActiveRecord::Base
  attr_accessible :challenge, :contribution_id, :create_date, :description, :questions, :title, :user, :views, :votes
end
