
require 'singleton'
class InvalidMoveError < StandardError
end

class Piece
  PIECES = { king: "K", queen: "Q", rook: "R", bishop: "B", knight: "N", pawn: "P", nil => " " }
  attr_reader :color, :kind
  attr_accessor :current_pos

  def copy
    self.class.new(@kind, @color, @current_pos.dup)
  end


  def self.setup(kind, color, current_pos)
    case kind
    when :rook
      Rook.new(kind, color, current_pos)
    when :bishop
      Bishop.new(kind, color, current_pos)
    when :king
      King.new(kind, color, current_pos)
    when :queen
      Queen.new(kind, color, current_pos)
    when :knight
      Knight.new(kind, color, current_pos)
    when :pawn
      Pawn.new(kind, color, current_pos)
    when nil
      NullPiece.instance
    end
  end

  def initialize(kind, color, current_pos)
    @kind = kind
    @color = color
    @current_pos = current_pos
  end

  def can_go?(destination, board)
    !board.occupied?(destination) || @color != board[*destination].color
  end

  def move_into_check?(pos)
  end


  def to_s
    if color == :black
      PIECES[kind].colorize(:color => :white, :background => :black)
    else
      PIECES[kind].colorize(:color => :black, :background => :white)
    end
  end
end

class SlidingPiece < Piece

  def evaluate_move(destination, board)
    av_moves = available_moves
    dir = find_direction(destination, av_moves)
    raise InvalidMoveError.new  if dir.nil?

    av_moves[dir].each do |pos|
      break if pos == destination
      raise InvalidMoveError.new if board.occupied?(pos)
    end

    return true if can_go?(destination, board)
    raise InvalidMoveError.new
  end

  private
  def find_direction(destination, av_moves)
    dir = nil
    av_moves.each do |key, pos_s|
      dir = key if pos_s.include?(destination)
    end
    dir
  end

  def available_moves_hori_ver
    y, x = @current_pos
    hori_ver = Hash.new{[]}
    1.upto(7) do |i|
      new_pos = {down: [y+i, x],
                up: [y-i, x],
                right: [y, x+i],
                left: [y, x-i]}
      new_pos.reject!{ |dir, pos| !pos[0].between?(0,7) || !pos[1].between?(0,7) }
      new_pos.each do |dir, pos|
        hori_ver[dir] += [pos.dup]
      end
    end
    hori_ver
  end

  def available_moves_diag
    y, x = @current_pos
    diag = Hash.new{[]}
    1.upto(7) do |i|
      new_pos = {rightdown: [y+i, x+i],
                leftdown: [y+i, x-i],
                rightup: [y-i, x+i],
                leftup: [y-i, x-i]}
      new_pos.reject!{ |dir, pos| !pos[0].between?(0,7) || !pos[1].between?(0,7) }
      new_pos.each do |dir, pos|
        diag[dir] += [pos.dup]
      end
    end
    diag
  end

end

class Bishop < SlidingPiece

  def available_moves
    available_moves_diag
  end

end

class Rook < SlidingPiece
  def available_moves
    available_moves_hori_ver
  end
end

class Queen < SlidingPiece
  def available_moves
    available_moves_hori_ver.merge(available_moves_diag)
  end

end

class SteppingPiece < Piece

  def evaluate_move(destination, board)
    if available_moves.include?(destination)
      return true if can_go?(destination, board)
    else
      raise InvalidMoveError.new
    end
  end

  def available_moves(delta)
    y, x = @current_pos
    av_moves = []
    delta.each do |pos|
      av_moves << [pos[0] + y, pos[1] + x]
    end
    av_moves.select{|pos| pos[0].between?(0,7) && pos[1].between?(0,7)}
  end

end

class Knight <SteppingPiece
  DELTA = [[-1,-2],[-2,-1],[-2,1],[-1,2],[1,2],[2,1],[2,-1],[1,-2]]
  def available_moves
    super(DELTA)
  end
end

class Pawn < SteppingPiece
  DELTAB = [[1,0]]
  DELTAW = [[-1,0]]
  def available_moves
    if @color == :black
      super(DELTAB)
    else
      super(DELTAW)
    end
  end

end

class King < SteppingPiece
  DELTA = [[-1,-1], [-1,0], [-1,1],[0,-1], [0,1], [1,-1], [1,0], [1,1]]
  def available_moves
    super(DELTA)
  end

end

class NullPiece
  include Singleton

  def to_s
    " "
  end

  def kind
  end

  def current_pos
  end

  def color
  end

  def copy
    NullPiece.instance
  end

  def evaluate_move(_,_)
    raise InvalidMoveError
  end



end
