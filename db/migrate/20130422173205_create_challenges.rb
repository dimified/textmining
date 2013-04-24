class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :challenge_id
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :followers

      t.timestamps
    end
  end
end
