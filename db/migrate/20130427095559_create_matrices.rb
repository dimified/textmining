class CreateMatrices < ActiveRecord::Migration
  def change
		create_table "matrices", :primary_key => "term_id", :force => true do |t|  
      t.string :term,       :limit => 200,       :null => false
    end

    add_index "matrices", ["term"], :name => "term_UNIQUE", :unique => true
  end
end
