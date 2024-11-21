class Board < ApplicationRecord
  attr_accessor :mine_count

  has_many :mines, dependent: :destroy

  validates :email, :name, :width, :height, :mine_count, presence: true
  validates :width, :height, :mine_count, numericality: { only_integer: true, greater_than: 0 }
  validate :valid_mine_count

  after_create :generate_mines

    def board_matrix
      # Create an empty matrix
      matrix = Array.new(height) { Array.new(width, '') }

      # Mark mines in the matrix
      mines.each do |mine|
        matrix[mine.y - 1][mine.x - 1] = '💣' # Adjust for 0-based indexing
      end

      matrix
    end

  private

  def valid_mine_count
    max_mines = width * height
    errors.add(:mine_count, 'cannot exceed total cells') if mine_count > max_mines
  end

  def generate_mines
    total_cells = width * height

    # Ensure mine count doesn't exceed total cells (already validated in `valid_mine_count`)
    raise 'Mine count exceeds total cells' if mine_count > total_cells

    # Randomly sample unique indices for mines
    mine_indices = (0...total_cells).to_a.sample(mine_count)

    # Convert 1D indices back to 2D coordinates
    mine_positions = mine_indices.map do |index|
      x = (index % width) + 1  # Convert to 1-based x-coordinate
      y = (index / width) + 1  # Convert to 1-based y-coordinate
      { x:, y: }
    end

    # Bulk insert mines into the database
    mines.insert_all(mine_positions)
  end
end
