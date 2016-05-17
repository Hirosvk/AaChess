require_relative 'piece'

class Board
  INITIAL_LAYOUT = [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook]


  attr_reader :grid
  def initialize(gride = nil)
    grid ||= Array.new(8){Array.new(8)}
    @grid = grid
  end

  def setup_board
    grid = []
    grid << INITIAL_LAYOUT.map.with_index { |kind, i| Piece.setup(kind, :black, [0,i]) }
    grid << (0..7).to_a.map.with_index { |_, i| Piece.setup(:pawn, :black, [1,i])}

    4.times { grid << Array.new(8){nil} }

    grid << (0..7).to_a.map.with_index {|_, i| Piece.setup(:pawn, :white, [6,i])}
    grid << INITIAL_LAYOUT.reverse.map.with_index { |kind, i| Piece.setup(kind, :white [7,i]) }
    @grid = grid
  end

  def [](row,col)
    @grid[row][col]
  end

  def [](row, col, piece)
    @grid[row][col] = piece
  end

  def render_row(n)
    @grid[n].map { |piece| piece.nil? ? " " : piece.to_s }
  end

  def move(start_pos, end_pos)
    raise unless valid_move?
  end

  def valid_move?
    start_pos.nil? == false &&
    end_pos.nil? == true &&
    (start_pos + end_pos).all?{|pos| pos.between?(0,7)}
  end

  def in_check?(color)
  end

  def occupied?(pos)
    !self[pos].nil?
  end

  def checkmate?(color)
  end


end
