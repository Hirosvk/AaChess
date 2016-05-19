describe Display do

  describe '::initialize' do
    it 'initializes with board set up with Pieces placed on their initial positions.'
  end

  describe '#render' do
    it 'renders the grid on dislay.'
    it 'shows the right coodinate info such as 1..8, and a..h.'
    it 'colorize the pieces based on their colors.'
    it 'shows the cursor in yellow when no square is selected.'
    it 'shows the cursor in red when the square is selected.'
  end

  describe '#right_color?' do
    it 'returns true if the current player selects his/her color.'
    it 'raises InvalidMoveError if the player select an opponent\'s piece.'
  end

  describe '#move_piece' do
    it 'calls Board#move_piece method.'
    it 'passes the position of @selected_piece as start_pos and @cursor position as destinatino.'
  end

  describe '#interactive_render' do
    #interactive_render(current_player_color)
    it 'displays the current state of the board.'
    it 'allows players cursor navigation.'
    it 'rescue InvalidMoveError and prompt to retry.'
    it 'keeps asking for new entry until a valid move is made.'
  end


end
