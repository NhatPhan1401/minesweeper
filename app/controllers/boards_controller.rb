class BoardsController < ApplicationController
  def index
     @boards = Board.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    @board = Board.new(board_params)

    return unless @board.save

      redirect_to @board
  end

    def show
      @board = Board.find(params[:id])

      # Defaults for pagination
      @current_pos_x = params[:pos_x].to_i
      @current_pos_y = params[:pos_y].to_i

      @rows_per_page = 30
      @cols_per_page = 30

      # Define the boundaries of the viewport
      x_min = @current_pos_x + 1
      x_max = [@current_pos_x + @cols_per_page, @board.width].min
      y_min = @current_pos_y + 1
      y_max = [@current_pos_y + @rows_per_page, @board.height].min

      # Query mines within the viewport
      mines_in_viewport = @board.mines.where(x: x_min..x_max, y: y_min..y_max)

      # Build the matrix for the viewport
      @board_matrix = Array.new(@rows_per_page) { Array.new(@cols_per_page, '') }
      mines_in_viewport.each do |mine|
        matrix_x = mine.x - x_min
        matrix_y = mine.y - y_min
        @board_matrix[matrix_y][matrix_x] = '💣' if matrix_y.between?(0,
                                                                      @rows_per_page - 1) && matrix_x.between?(0,
                                                                                                               @cols_per_page - 1)
      end

      # Generate headers for visible rows and columns
      @col_headers = (x_min..x_max).to_a
      @row_headers = (y_min..y_max).to_a
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
