class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :contribution_id
      t.string :title
      t.text :description
      t.text :questions
      t.datetime :create_date
      t.integer :views
      t.integer :votes
      t.string :challenge
      t.string :user

      t.timestamps
    end
  end
end
