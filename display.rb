require 'colorize'
require 'io/console'

class ExitRender < StandardError
  def initialize
  end
end

class InvalidCursorEntry < StandardError
end

class Display
  CURSOR_MOVE = {
    8 => [-1,0], #UP
    2 => [1,0], #DOWN
    4 => [0,-1], #LEFT
    6 => [0,1], #RIGHT
    5 => :select,
    0 => :unselect,
    9 => :exit
  }

  attr_reader :cursor, :board, :selected_piece, :cursor_selected
  def initialize(board)
    @board = board
    @cursor = [0, 0]
    @cursor_selected = false
    @selected_piece = NullPiece.instance
  end

  def self.new_board
    board = Board.new
    board.setup_board
    self.new(board)
  end

  def get_input
    move = STDIN.getch.to_i
    raise InvalidCursorEntry.new unless CURSOR_MOVE.include?(move)
    move
  end

  def direct_input
      move = get_input
      if CURSOR_MOVE[move] == :exit
        raise "geting out"
      elsif CURSOR_MOVE[move] == :unselect
        @selected_piece = NullPiece.instance
      elsif CURSOR_MOVE[move] == :select
        select_pos(move)
      else
        move_cursor(move)
      end
    rescue InvalidCursorEntry
      retry
  end

  def select_pos(move)
    @cursor_selected = !@cursor_selected
    if @selected_piece.is_a?(NullPiece)
      @selected_piece = @board[*@cursor]
      puts "selected!"
    end
  end

  def move_piece
    @board.move_piece(@selected_piece.current_pos, @cursor)
  end

  def reset_selected_piece
    @selected_piece = NullPiece.instance
  end

  def move_cursor(move)
    new_pos = [ @cursor[0] + CURSOR_MOVE[move][0], @cursor[1] + CURSOR_MOVE[move][1] ]
    raise InvalidCursorEntry.new unless new_pos.all?{|n| n <= 7 && n >= 0}
    @cursor = new_pos
    @cursor_selected = false
  end

  def render
    rboard = []
    8.times {|i| rboard << @board.render_row(i)}
    if @cursor_selected
      rboard[@cursor[0]][@cursor[1]] = rboard[@cursor[0]][@cursor[1]].colorize(:background => :red)
    else
      rboard[@cursor[0]][@cursor[1]] = rboard[@cursor[0]][@cursor[1]].colorize(:background => :yellow)
    end
    puts "Selected Piece: #{@selected_piece.to_s} at #{@selected_piece.current_pos.to_s}"
    puts "+ #{("a".."h").to_a.join(" ")}"
    puts "  " + "-" * 15
    8.times do |n|
      puts "#{n+1}|".colorize(:color => :brown) + rboard[n].join(" ")
    end
  end

  def in_check?(color)
    @board.in_check?(color)
  end

  def right_color?(color)
    unless @selected_piece.color == color
      raise InvalidMoveError.new
    end
    true
  end

  def set_to_move?
    @selected_piece.is_a?(Piece) && @cursor_selected && @selected_piece.current_pos != @cursor
  end

#   def interactive_render
#     while true
#       begin
#       system("clear")
#       render
#       direct_input
#
#       move_piece if set_to_move?
#
#       rescue InvalidMoveError
#         @selected_piece = NullPiece.instance
#         puts "That was invalid move!"
#         sleep(1)
#         retry
#       end
#       break if @board.in_check?(:white) || @board.in_check?(:black)
#       # sleep (1)
#     end
#     puts "check!"
#   end
#
end


if __FILE__ == $PROGRAM_NAME
  Display.new_board.interactive_render
end
