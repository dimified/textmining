class Challenge < ActiveRecord::Base
  attr_accessible :challenge_id, :description, :end_date, :followers, :start_date, :title
end
