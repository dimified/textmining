class CreateDummies < ActiveRecord::Migration
  def change
    create_table "dummies", :primary_key => "dummy_id", :force => true do |t|
      t.string   "title",       :limit => 200
      t.text     "description", :limit => 2147483647, :null => false
      t.string   "user",        :limit => 100,        :null => false
      t.string   "document"
      t.text     "lemma"
    end
  end
end
