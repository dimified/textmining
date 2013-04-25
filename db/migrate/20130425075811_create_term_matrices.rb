class CreateTermMatrices < ActiveRecord::Migration
  def change
    create_table :term_matrices do |t|
      t.integer :term_id
      t.string :term

      t.timestamps
    end
  end
end
