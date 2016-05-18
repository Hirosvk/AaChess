

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
    grid ||= Array.new(8){Array.new(8)}
    @grid = grid
  end

  attr_reader :grid
  def setup_board(board = INITIAL_BOARD)
    grid = []
    board.each_with_index do |row, i|
      grid << row.map.with_index do |kind_color, j|
        kind, color = kind_color
        Piece.setup(kind, color, [i,j])
      end
    end
    @grid = grid
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
    opp_pieces = all_pieces(other_color)

    opp_pieces.each do |piece|
      begin
        return true if piece.evaluate_move(my_king.current_pos, self)
      rescue InvalidMoveError
      end
    end
    false
  end

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

  def copy
    copy_board = Board.new
    8.times do |i|
      8.times do |j|
        copy_board[i,j] = self[i,j].copy
      end
    end
    copy_board
  end

  def checkmate?(color)


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

end
