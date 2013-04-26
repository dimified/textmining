class AddLemmaToDocuments < ActiveRecord::Migration
  def change
  	change_table :challenges do |t|
      t.text :lemma, :limit => 2147483647
		end

		change_table :comments do |t|
      t.text :lemma, :limit => 2147483647
		end

		change_table :contributions do |t|
      t.text :lemma, :limit => 2147483647
		end
  end
end
