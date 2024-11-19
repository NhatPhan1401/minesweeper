class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :email
      t.string :name
      t.integer :width
      t.integer :height
      t.integer :mines
      t.text :board_data

      t.timestamps
    end
  end
end
