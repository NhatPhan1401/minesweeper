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
    @board_matrix = @board.board_matrix
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
