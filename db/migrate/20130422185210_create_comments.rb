class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :comment_id
      t.datetime :create_date
      t.text :message
      t.integer :votes
      t.string :user
      t.string :challenge
      t.string :contribution

      t.timestamps
    end
  end
end
