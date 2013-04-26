class CreateExternalDatabase < ActiveRecord::Migration
  def up
  	create_table "challenges", :primary_key => "challenge_id", :force => true do |t|
	    t.string   "title",       :limit => 200,        :null => false
	    t.text     "description", :limit => 2147483647
	    t.datetime "start_date"
	    t.datetime "end_date"
	    t.integer  "followers"
	  end

	  add_index "challenges", ["title"], :name => "title_UNIQUE", :unique => true

	  create_table "comments", :primary_key => "comment_id", :force => true do |t|
	    t.datetime "create_date"
	    t.text     "description",  :limit => 2147483647
	    t.integer  "votes"
	    t.string   "user",         :limit => 100,        :null => false
	    t.string   "challenge",    :limit => 200
	    t.string   "contribution", :limit => 200
	  end

	  create_table "contributions", :primary_key => "contribution_id", :force => true do |t|
	    t.string   "title",       :limit => 200,        :null => false
	    t.text     "description", :limit => 2147483647
	    t.text     "questions",   :limit => 2147483647
	    t.datetime "create_date"
	    t.integer  "views"
	    t.integer  "votes"
	    t.string   "challenge",   :limit => 200,        :null => false
	    t.string   "user",        :limit => 100,        :null => false
	  end

	  add_index "contributions", ["title"], :name => "title_UNIQUE", :unique => true

	  create_table "homes", :force => true do |t|
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  end

	  create_table "tags", :primary_key => "tag_id", :force => true do |t|
	    t.string "name",         :limit => 100
	    t.string "contribution", :limit => 200, :null => false
	  end

	  create_table "users", :primary_key => "user_id", :force => true do |t|
	    t.string   "nick",       :limit => 50,         :null => false
	    t.string   "name",       :limit => 100,        :null => false
	    t.string   "motto",      :limit => 300
	    t.text     "bio",        :limit => 2147483647
	    t.datetime "join_date"
	    t.string   "occupation", :limit => 100
	    t.string   "company",    :limit => 100
	    t.string   "country",    :limit => 100
	  end

	  add_index "users", ["name"], :name => "name_UNIQUE", :unique => true
	  add_index "users", ["nick"], :name => "id_UNIQUE", :unique => true
  end

  def down
  end
end
