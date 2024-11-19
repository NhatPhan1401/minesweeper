class RemoveBoardData < ActiveRecord::Migration[7.0]
  def change
    remove_column :boards, :board_data, :text
  end
end
