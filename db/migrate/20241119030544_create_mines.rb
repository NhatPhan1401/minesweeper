class CreateMines < ActiveRecord::Migration[7.0]
  def change
    create_table :mines do |t|
      t.references :board, null: false, foreign_key: true
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
