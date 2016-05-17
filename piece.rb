require "colorize"

class Piece
  PIECES = { king: "K", queen: "Q", rook: "R", bishop: "B", knight: "N", pawn: "P" }
  attr_reader :color, :kind
  attr_accessor :current_pos

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
    end
  end

  def initialize(kind, color, current_pos)
    @kind = kind
    @color = color
    @current_pos = current_pos
  end

  def move_into_chech?(pos)
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

  def move(destination, board)
    av_moves = available_moves
    dir = find_direction(destination, av_moves)
    return nil if dir.nil?
    av_moves[dir].each do |pos|
      return true if pos == destination
      return nil if board.occupied?(pos)
    end
  end

  def find_direction(destination, av_moves)
    dir = nil
    av_moves.each do |key, pos_s|
      dir = key if pos_s.include?(destination)
    end
    dir
  end

end

class Bishop < SlidingPiece


  def available_moves
    y, x = @current_pos
    diag = Hash.new{[]}
    1.upto(7) do |i|
      new_pos = {rightdown: [x+i, y+i],
                leftdown: [x+i, y-i],
                rightup: [x-i, y+i],
                leftup: [x-i, y-i]}
      new_pos.reject!{ |dir, pos| !pos[0].between?(0,7) || !pos[1].between?(0,7) }
      new_pos.each do |dir, pos|
        diag[dir] += [pos.dup]
      end
    end
    diag
  end
end

class Rook < SlidingPiece
  # def available_moves
  #   vertical = (0..7).to_a.map { |i| [i, @current_pos[1]] }
  #   vertical.reject!{ |el| el == @current_pos }
  #
  #   horizontal = (0..7).to_a.map { |i| [@current_pos[0], i] }
  #   horizontal.reject!{ |el| el == @current_pos }
  #
  #   horizontal + vertical
  # end

  def available_moves
    y, x = @current_pos
    hori_ver = Hash.new{[]}
    1.upto(7) do |i|
      new_pos = {up: [x+i, y],
                down: [x-i, y],
                righ: [x, y+i],
                left: [x, y-i]}
      new_pos.reject!{ |dir, pos| !pos[0].between?(0,7) || !pos[1].between?(0,7) }
      new_pos.each do |dir, pos|
        hori_ver[dir] += [pos.dup]
      end
    end
    hori_ver
  end



end

class Queen < SlidingPiece
end

class SteppingPiece < Piece
end


class NullPiece < Piece
  module Singleton
  end
end
