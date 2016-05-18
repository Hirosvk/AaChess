require_relative 'chess_manifest.rb'

class Game

  attr_reader :display, :current_player, :next_player
  def initialize(display)
    @display = display
    @current_player = Player.new(:white)
    @next_player = Player.new(:black)
  end

  def self.setup_new_board
    self.new(Display.new_board)
  end


  def play
    puts "Let's play Chess!"
    sleep (2)
    until in_check?(@current_player.color)
      take_turn
      switch_players
    end
    puts "Check!"
    puts @display.board.kings_escape_move(@current_player.color).to_s
  end


  def switch_players
    @current_player, @next_player = @next_player, @current_player
  end

  def in_check?(color)
    @display.in_check?(color)
  end



  def take_turn
    while true
      begin
        system("clear")
        puts "This is #{@current_player.color}'s turn."
        @display.render
        @display.direct_input
        if @display.set_to_move?
          next unless @display.right_color?(@current_player.color)
          @display.move_piece
          break
        end

      rescue InvalidMoveError
        @display.reset_selected_piece
        puts "That was invalid move!"
        sleep(1)
        retry
      end
    end
    @display.reset_selected_piece
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.setup_new_board
  game.play
end
