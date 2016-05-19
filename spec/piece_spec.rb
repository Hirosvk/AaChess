describe Piece do
  describe '::setup' do
    it 'takes kind, color, and current_position as arguments.'
    it 'returns an instance of Piece object based on the kind symbol'
    it 'returns a NullPiece when nil is passed as kind.'
  end

  describe '#copy' do
    it 'returns a duplicate of the selected piece.'
  end

  descrie '#can_go?' do
    it 'takes a position as array and board instance as arguments.'
    it 'returns true if there is a opponent\'s piece is on the position.'
    it 'returns true if the position is empty.'
  end

  describe '#to_s' do
    it 'returns a colorized letter representing its own kind and color.'
  end

  describe '#evaluate_move' do
    it 'takes a position in array and board instance as arguments.'
    it 'returns true if the piece can move to the position.'
    it 'raises InvalidMoveError if the move is invalid.'
  end

  describe '#available_move' do
    it 'gives array of all the possible positions that the piece can move to on the board.'
  end



end
