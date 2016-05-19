

class ExitRender < StandardError
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

  def initialize(board = Board.new)
    @board = board
    @cursor = [7, 7]
    @cursor_selected = false
    @selected_piece = NullPiece.instance
  end

  def saving_moves(color)
    @board.saving_moves(color)
  end

  def checkmate?(color)
    @board.checkmate?(color)
  end

  def move_piece
    @board.move_piece(@selected_piece.current_pos, @cursor)
  end

  def in_check?(color)
    @board.in_check?(color)
  end

  def interactive_render(current_player_color)
    while true
      begin
        system("clear")
        puts "This is #{current_player_color}'s turn."
        puts "#{current_player_color} is in check!".colorize(:color => :red) if in_check?(current_player_color)
        render
        direct_input
        if set_to_move? && right_color?(current_player_color)
          move_piece
          break
        end

      rescue InvalidMoveError
        reset_selected_piece
        puts "Invalid Move."
        sleep(1)
        retry
      end
    end
    reset_selected_piece
  end


  private

  def reset_selected_piece
    @selected_piece = NullPiece.instance
  end

  def move_cursor(move)
    new_pos = [ @cursor[0] + CURSOR_MOVE[move][0], @cursor[1] + CURSOR_MOVE[move][1] ]
    raise InvalidCursorEntry.new "You can't go outside the grid." unless new_pos.all?{|n| n <= 7 && n >= 0}
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

  def right_color?(color)
    unless @selected_piece.color == color
      raise InvalidMoveError.new "Your color is #{color.to_s}."
    end
    true
  end

  def set_to_move?
    @selected_piece.is_a?(Piece) && @cursor_selected && @selected_piece.current_pos != @cursor
  end


  def get_input
    move = STDIN.getch.to_i
    raise InvalidCursorEntry.new unless CURSOR_MOVE.include?(move)
    move
  end

  def direct_input
      move = get_input
      if CURSOR_MOVE[move] == :exit
        raise ExitRender.new "exiting the program."
      elsif CURSOR_MOVE[move] == :unselect
        unselect_pos(move)
      elsif CURSOR_MOVE[move] == :select
        select_pos(move)
      else
        move_cursor(move)
      end
    rescue InvalidCursorEntry
      retry
  end

  def unselect_pos(move)
    @selected_piece = NullPiece.instance
  end

  def select_pos(move)
    @cursor_selected = !@cursor_selected
    @selected_piece = @board[*@cursor] if @selected_piece.is_a?(NullPiece)
  end

end
