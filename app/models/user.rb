class User < ActiveRecord::Base
  attr_accessible :bio, :company, :country, :id, :join_date, :motto, :name, :occupation, :user_id
end
