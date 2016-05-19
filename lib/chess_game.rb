require_relative 'chess_manifest'

class Game

  # attr_reader :display, :current_player, :next_player
  def initialize(display = Display.new)
    @display = display
    @current_player = Player.new(:white)
    @next_player = Player.new(:black)
  end

  def play
    puts "Let's play Chess!"
    sleep (2)
    until checkmate?(@current_player.color)
      take_turn
    end
    puts "#{@next_player.color} has won!"
    # puts "#{@current_player.color}'s in check!"
    # puts @display.saving_moves(@current_player.color).to_s
  end

  def in_check?(color)
    @display.in_check?(color)
  end

  def checkmate?(color)
    @display.checkmate?(color)
  end

  def take_turn
    @display.interactive_render(@current_player.color)
    switch_players
  end

  private
  def switch_players
    @current_player, @next_player = @next_player, @current_player
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
