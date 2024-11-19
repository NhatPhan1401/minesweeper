class Board < ApplicationRecord
  attr_accessor :mine_count
  has_many :mines, dependent: :destroy

  validates :email, :name, :width, :height, :mine_count, presence: true
  validates :width, :height, :mine_count, numericality: { only_integer: true, greater_than: 0 }
  validate :valid_mine_count

  after_create :generate_mines

  def board_matrix
    # Create an empty matrix
    matrix = Array.new(height) { Array.new(width, 'x') }

    # Mark mines in the matrix
    mines.each do |mine|
      matrix[mine.y - 1][mine.x - 1] = '💣'
    end

    matrix
  end

  private

  def valid_mine_count
    max_mines = width * height
    errors.add(:mine_count, 'cannot exceed total cells') if mine_count > max_mines
  end

  def generate_mines
    all_positions = (1..width).flat_map do |row|
      (1..height).map { |col| { x: col, y: row } }
    end

    # Randomly sample n positions from the list
    selected_positions = all_positions.sample(mine_count)

    # Create a mine for each selected position
    mines.insert_all(selected_positions)
  end
end
