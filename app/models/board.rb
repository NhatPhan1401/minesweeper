class Board < ApplicationRecord
  attr_accessor :mine_count

  has_many :mines, dependent: :destroy

  validates :email, :name, :width, :height, :mine_count, presence: true
  validates :width, :height, :mine_count, numericality: { only_integer: true, greater_than: 0 }
  validate :valid_mine_count

  after_create :generate_mines_with_transaction

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

  def generate_mines_with_transaction
    Board.transaction do
      # Generate and validate the board
      generate_mines
    rescue => e
      errors.add(:base, "Failed to generate mines: #{e.message}")
      raise ActiveRecord::Rollback
    end
  end

  def generate_mines
    total_cells = width * height

    raise 'Mine count exceeds total cells' if mine_count > total_cells

    # Hash-based unique random sampling
    unique_indices = {}
    while unique_indices.size < mine_count
      random_index = rand(total_cells)
      unique_indices[random_index] ||= true
    end

    # Convert the sampled indices back to 2D coordinates
    mine_positions = unique_indices.keys.map do |index|
      x = (index % width) + 1  # Convert to 1-based x-coordinate
      y = (index / width) + 1  # Convert to 1-based y-coordinate
      { x:, y:, board_id: id } # Include board_id for association
    end

    # Use a transaction to insert mines
    Mine.transaction do
      Mine.insert_all!(mine_positions)
    rescue => e
      errors.add(:base, "Failed to insert mines: #{e.message}")
      raise ActiveRecord::Rollback
    end
  end
end
