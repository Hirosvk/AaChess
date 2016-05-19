
class Board
  INITIAL_BOARD = [
  [[:rook, :black], [:knight, :black], [:bishop, :black], [:queen, :black], [:king, :black], [:bishop, :black], [:knight, :black], [:rook, :black]],
  [[:pawn, :black]] * 8,
  [[nil,nil]] * 8,
  [[nil,nil]] * 8,
  [[nil,nil]] * 8,
  [[nil,nil]] * 8,
  [[:pawn, :white]] * 8,
  [[:rook, :white], [:knight, :white], [:bishop, :white], [:king, :white], [:queen, :white], [:bishop, :white], [:knight, :white], [:rook, :white]]]


  def initialize(grid = nil)
    grid ||= Board.setup_board
    @grid = grid
  end

  def self.setup_board(board = INITIAL_BOARD)
    grid = []
    board.each_with_index do |row, i|
      grid << row.map.with_index do |kind_color, j|
        kind, color = kind_color
        Piece.setup(kind, color, [i,j])
      end
    end
    grid
  end

  def move_piece(start_pos, end_pos)
    self[*start_pos].evaluate_move(end_pos, self)

    self[*start_pos].current_pos = end_pos.dup
    self[*end_pos] = self[*start_pos]
    self[*start_pos] = NullPiece.instance
  end

  def in_check?(my_color)
    my_king = king(my_color)
    other_color = (my_color == :black) ? :white : :black
    opponents_pieces = all_pieces(other_color)

    opponents_pieces.each do |piece|
      begin
        return true if piece.evaluate_move(my_king.current_pos, self)
      rescue InvalidMoveError
      end
    end
    false
  end

  def checkmate?(color)
    return true if saving_moves(color).empty?
    false
  end

  def saving_moves(color)
    saving_moves = []

    all_pieces(color).each do |piece|
      8.times do |row|
        8.times do |col|

          tempgrid = self.copy
          begin
            if piece.evaluate_move([row,col], tempgrid)
              tempgrid.move_piece(piece.current_pos, [row,col])
              saving_moves << [piece.current_pos, [row, col]] unless tempgrid.in_check?(color)
            end
          rescue InvalidMoveError

          end
        end
      end
    end
    saving_moves
  end




  def occupied?(pos)
    !self[*pos].is_a?(NullPiece)
  end


  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, piece)
    @grid[row][col] = piece
  end

  def render_row(n)
    @grid[n].map { |piece| piece.to_s }
  end

  def copy
    copy_board = Board.new
    8.times do |i|
      8.times do |j|
        copy_board[i,j] = self[i,j].copy
      end
    end
    copy_board
  end


  private
  def king(color)
    @grid.map do |row|
      row.find { |piece| piece.kind == :king && piece.color == color }
    end.reject(&:nil?).first
  end

  def all_pieces(color)
    @grid.map do |row|
      row.select { |piece| piece.is_a?(Piece) && piece.color == color }
    end.flatten
  end



  def kings_escape_move(color)
    this_king = king(color)
    av_moves = []
    this_king.available_moves.each do |pos|
      begin
        av_moves << pos if this_king.evaluate_move(pos, self)
      rescue InvalidMoveError
      end
    end

    av_moves.each do |pos|
      tempboard = self.copy
      tempboard.move_piece(this_king.current_pos, pos)
      if tempboard.in_check?(color) == false
        return pos
      end
    end
    nil
  end



end
