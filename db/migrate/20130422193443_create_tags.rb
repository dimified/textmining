class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :tag_id
      t.string :name
      t.string :contribution

      t.timestamps
    end
  end
end
