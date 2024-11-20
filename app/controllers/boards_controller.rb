class BoardsController < ApplicationController
  def index
     @boards = Board.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    @board = Board.new(board_params)

    if @board.save
      redirect_to @board
    end
  end

def show
  @board = Board.find(params[:id])
  
  # Defaults for pagination
  @current_pos_x = params[:pos_x].to_i
  @current_pos_y = params[:pos_y].to_i

  @rows_per_page = 30
  @cols_per_page = 30

  # Slice the matrix for the current page
  @board_matrix = @board.board_matrix[
    @current_pos_y...(@current_pos_y + @rows_per_page)
  ].map { |row| row[@current_pos_x...(@current_pos_x + @cols_per_page)] }

  # Full headers for columns and rows
  @col_headers = (@current_pos_x + 1..[@current_pos_x + @cols_per_page, @board.width].min).to_a
  @row_headers = (@current_pos_y + 1..[@current_pos_y + @rows_per_page, @board.height].min).to_a
end

  private

def board_params
  params.require(:board).permit(:email, :name, :width, :height, :mine_count).tap do |board_params|
    board_params[:width] = board_params[:width].to_i
    board_params[:height] = board_params[:height].to_i
    board_params[:mine_count] = board_params[:mine_count].to_i
  end
end

end
