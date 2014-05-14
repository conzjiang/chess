require 'set'

class Piece
  attr_accessor :board, :pos
  attr_reader :color
  
  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
    #@board[pos] = self
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
    # return array of moves piece can move to
  end
end

class SlidingPiece < Piece
  
  def moves
    possible_moves = Set.new([])
    
    move_dirs.each do |x, y|
      n = 1
      
      loop do
        possible_pos = [pos[0] + (x * n), pos[1] + (y * n)]
        possible_moves << possible_pos if valid_space?(possible_pos)
        
        break if !valid_space?(possible_pos) || !board.empty?(possible_pos)
        n += 1
      end
    end
    
    possible_moves
  end
  
end

class Rook < SlidingPiece
  def move_dirs
    Set.new([[1, 0], [-1, 0], [0, 1], [0, -1]])
  end
end

class Bishop < SlidingPiece
  def move_dirs
    Set.new([[1, 1], [-1, 1], [-1, -1], [1, -1]])
  end
end

class Queen < SlidingPiece
  def move_dirs
    Set.new([[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]])
  end
end

class SteppingPiece < Piece
  def moves
    possible_moves = Set.new([])
    
    move_dirs.each do |x, y|
      possible_pos = [pos[0] + x, pos[1] + y]
      possible_moves << possible_pos if valid_space?(possible_pos)
    end
    
    possible_moves
  end
end

class Knight < SteppingPiece
  def move_dirs
    Set.new([[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]])
  end
end

class King < SteppingPiece
  def move_dirs
    Set.new([[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]])
  end
end

class Pawn < Piece
  def moves
    
    possible_moves = Set.new([])

    if self.color == :black
      left_black_diag = [pos[0] + 1, pos[1] - 1]
      right_black_diag = [pos[0] + 1, pos[1] + 1]
      forward = [pos[0] + 1, pos[1]]
      
      if self.pos[0] == 1
        two_spaces_forward = [pos[0] + 2, pos[1]]
        possible_moves << two_spaces_forward if board.empty?(two_spaces_forward)
      end
      
      if board.empty?(forward)
        possible_moves << forward
      end
      
      if !board.empty?(left_black_diag) && board[left_black_diag].color != self.color
        possible_moves << left_black_diag
      end
      
      if !board.empty?(right_black_diag) && board[right_black_diag].color != self.color
        possible_moves << right_black_diag
      end
    else # white pieces
      left_white_diag = [pos[0] - 1, pos[1] - 1]
      right_white_diag = [pos[0] - 1, pos[1] + 1]
      forward = [pos[0] - 1, pos[1]]
      
      if self.pos[0] == 6
        two_spaces_forward = [pos[0] - 2, pos[1]]
        possible_moves << two_spaces_forward if board.empty?(two_spaces_forward)
      end
      
      if board.empty?(forward)
        possible_moves << forward
      end
      
      if board[left_white_diag] && board[left_white_diag].color != self.color
        possible_moves << left_white_diag
      end
      
      if !board.empty?(right_white_diag) && board[right_white_diag].color != self.color
        possible_moves << right_white_diag
      end
    end
    
    possible_moves
  end
end