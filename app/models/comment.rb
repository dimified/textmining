class Comment < ActiveRecord::Base
  attr_accessible :challenge, :comment_id, :contribution, :create_date, :message, :user, :votes
end
