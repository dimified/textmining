class CreateCollections < ActiveRecord::Migration
  def up
  	create_table "collections", :primary_key => "collection_id", :force => true do |t|
	    t.string   "title",       :limit => 200,        :null => false
	    t.text     "description", :limit => 2147483647
	    t.string   "user",        :limit => 100,        :null => false
	    t.string   "type"
	    t.text     "lemma"
	  end
  end

  def down
  end
end