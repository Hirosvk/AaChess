require 'colorize'
require 'io/console'
require_relative 'board'


class Display
  CURSOR_MOVE = {
    8 => [-1,0], #UP
    2 => [1,0], #DOWN
    4 => [0,-1], #LEFT
    6 => [0,1], #RIGHT
    0 => :select
  }

  attr_accessor :cursor
  def initialize(board)
    @board = board
    @cursor = [0, 0]
    @cursor_selected = false
  end

  def self.create_new_board
    board = Board.new
    board.setup_board
    self.new(board)
  end

  def get_input
    move = STDIN.getch.to_i
    raise InvalidCursorEntry unless CURSOR_MOVE.include?(move)
    move
  end

  def direct_input
    begin
      move = get_input
      if CURSOR_MOVE[move] == :select
        select_pos(move)
      else
        move_cursor(move)
      end
    rescue
      retry
    end
  end

  def select_pos(move)
    @cursor_selected = !@cursor_selected
  end

  def move_cursor(move)
    new_pos = [ @cursor[0] + CURSOR_MOVE[move][0], @cursor[1] + CURSOR_MOVE[move][1] ]
    raise InvalidCursorMoveError unless new_pos.all?{|n| n <= 7 && n >= 0}
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
    puts "+ #{("a".."h").to_a.join(" ")}"
    puts "  " + "-" * 15
    8.times do |n|
      puts "#{n+1}|".colorize(:color => :brown) + rboard[n].join(" ")
    end
  end

  def interactive_render
    20.times do
      system("clear")
      render
      direct_input
    end
  end

end
