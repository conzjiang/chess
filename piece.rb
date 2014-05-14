class Piece
  attr_accessor :board, :pos
  attr_reader :color
  
  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
    @board[pos] = self
  end
  
  def valid_space?(coord)
    coord[0].between?(0, 7) && coord[1].between?(0, 7) &&
    (board.empty?(coord) || board[coord].color != self.color)
  end
    
  def valid_moves
    self.moves.reject { |move| self.move_into_check?(move) }
  end
  
  def move_into_check?(move)
    return false unless moves.include?(move)
    
    board_dup = board.dup
    board_dup.move!(self.pos, move)
    board_dup.in_check?(self.color)
  end
  
  def moves
    raise NotImplementedError
  end
end



