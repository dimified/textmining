class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :nick
      t.string :name
      t.string :motto
      t.text :bio
      t.datetime :join_date
      t.string :occupation
      t.string :company
      t.string :country

      t.timestamps
    end
  end
end
