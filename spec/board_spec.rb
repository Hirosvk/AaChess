describe Board do

  describe '::initialize' do
    it 'when gird is not specified, initializes with original setup.'
    it 'when grid is given, initializes with the given grid.'
  end

  describe '#move_piece' do
    #move_piece(start_pos, end_pos)
    it 'changes the current_position of the Piece instance.'
    it 'changes the position of the Piece object on the @grid.'
    it 'puts NullPiece on the previous position of the moving piece.'
    it 'move is valid when it moves into the square occupied by opponent\'s piece.'
  end

  describe '#in_check?' do
    #in_check?(color)
    it 'returns true if opponent\'s piece can take the king.'
    it 'returns false if none of the opponent\'s piece can take the king.'
  end

  describe '#saving_moves' do
    it 'returns sets of positions that any pieces can take to save the king; start_pos, end_pos.'
    it 'returns nil if there are no possible moves to save the king.'
  end

  describe '#checkmate?' do
    #check_mate?(color)
    it 'returns true if the player is in_check?, and there is no possible move to save the king by any pieces.'
    it 'returns false if the player in check can make move to save the king.'
    it 'returns false if the player is not in check.'
  end

  describe '#copy' do
    it 'duplicates the board object.' end
      board2 = board.copy
      expect(board).not_to be (board2)
    end
  end

  describe '#render_row' do
    render_row(row_n)
    it 'returns an array of colorized strings, each representing the piece occuping the space in the row.'
  end

  describe '#[]' do
  end

  describe '#[]=' do
  end

  describe '#occupied?' do
    #occupied?(pos)
    it 'returns true if the pos is occupied by a piece other than NullPiece.'
  end
end
